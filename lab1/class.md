[class]

***class: token; annotation token; lexer; FunctionDecl***

# lexer

The Lexer and Preprocessor Library
The Lexer library contains several tightly-connected classes that are involved with the nasty process of lexing and preprocessing C source code. The main interface to this library for outside clients is the large Preprocessor class. It contains the various pieces of state that are required to coherently read tokens out of a translation unit.

The core interface to the Preprocessor object (once it is set up) is the Preprocessor::Lex method, which returns the next Token from the preprocessor stream. There are two types of token providers that the preprocessor is capable of reading from: a buffer lexer (provided by the Lexer class) and a buffered token stream (provided by the TokenLexer class).

## The Token class
The Token class is used to represent a single lexed token. Tokens are intended to be used by the lexer/preprocess and parser libraries, but are not intended to live beyond them (for example, they should not live in the ASTs).

Tokens most often live on the stack (or some other location that is efficient to access) as the parser is running, but occasionally do get buffered up. For example, macro definitions are stored as a series of tokens, and the C++ front-end periodically needs to buffer tokens up for tentative parsing and various pieces of look-ahead. As such, the size of a Token matters. On a 32-bit system, sizeof(Token) is currently 16 bytes.

Tokens occur in two forms: annotation tokens and normal tokens. Normal tokens are those returned by the lexer, annotation tokens represent semantic information and are produced by the parser, replacing normal tokens in the token stream. Normal tokens contain the following information:

A SourceLocation — This indicates the location of the start of the token.


A length — This stores the length of the token as stored in the SourceBuffer. For tokens that include them, this length includes trigraphs and escaped newlines which are ignored by later phases of the compiler. By pointing into the original source buffer, it is always possible to get the original spelling of a token completely accurately.


IdentifierInfo — If a token takes the form of an identifier, and if identifier lookup was enabled when the token was lexed (e.g., the lexer was not reading in “raw” mode) this contains a pointer to the unique hash value for the identifier. Because the lookup happens before keyword identification, this field is set even for language keywords like “for”.


TokenKind — This indicates the kind of token as classified by the lexer. This includes things like tok::starequal (for the “*=” operator), tok::ampamp for the “&&” token, and keyword values (e.g., tok::kw_for) for identifiers that correspond to keywords. Note that some tokens can be spelled multiple ways. For example, C++ supports “operator keywords”, where things like “and” are treated exactly like the “&&” operator. In these cases, the kind value is set to tok::ampamp, which is good for the parser, which doesn’t have to consider both forms. For something that cares about which form is used (e.g., the preprocessor “stringize” operator) the spelling indicates the original form.


Flags — There are currently four flags tracked by the lexer/preprocessor system on a per-token basis:
StartOfLine — This was the first token that occurred on its input source line.


LeadingSpace — There was a space character either immediately before the token or transitively before the token as it was expanded through a macro. The definition of this flag is very closely defined by the stringizing requirements of the preprocessor.
DisableExpand — This flag is used internally to the preprocessor to represent identifier tokens which have macro expansion disabled. This prevents them from being considered as candidates for macro expansion ever in the future.


NeedsCleaning — This flag is set if the original spelling for the token includes a trigraph or escaped newline. Since this is uncommon, many pieces of code can fast-path on tokens that did not need cleaning.
One interesting (and somewhat unusual) aspect of normal tokens is that they don’t contain any semantic information about the lexed value. For example, if the token was a pp-number token, we do not represent the value of the number that was lexed (this is left for later pieces of code to decide). Additionally, the lexer library has no notion of typedef names vs variable names: both are returned as identifiers, and the parser is left to decide whether a specific identifier is a typedef or a variable (tracking this requires scope information among other things). The parser can do this translation by replacing tokens returned by the preprocessor with “Annotation Tokens”.

## Annotation Tokens
Annotation tokens are tokens that are synthesized by the parser and injected into the preprocessor’s token stream (replacing existing tokens) to record semantic information found by the parser. For example, if “foo” is found to be a typedef, the “foo” tok::identifier token is replaced with an tok::annot_typename. This is useful for a couple of reasons: 1) this makes it easy to handle qualified type names (e.g., “foo::bar::baz<42>::t”) in C++ as a single “token” in the parser. 2) if the parser backtracks, the reparse does not need to redo semantic analysis to determine whether a token sequence is a variable, type, template, etc.

Annotation tokens are created by the parser and reinjected into the parser’s token stream (when backtracking is enabled). Because they can only exist in tokens that the preprocessor-proper is done with, it doesn’t need to keep around flags like “start of line” that the preprocessor uses to do its job. Additionally, an annotation token may “cover” a sequence of preprocessor tokens (e.g., “a::b::c” is five preprocessor tokens). As such, the valid fields of an annotation token are different than the fields for a normal token (but they are multiplexed into the normal Token fields):

SourceLocation “Location” — The SourceLocation for the annotation token indicates the first token replaced by the annotation token. In the example above, it would be the location of the “a” identifier.
SourceLocation “AnnotationEndLoc” — This holds the location of the last token replaced with the annotation token. In the example above, it would be the location of the “c” identifier.
void* “AnnotationValue” — This contains an opaque object that the parser gets from Sema. The parser merely preserves the information for Sema to later interpret based on the annotation token kind.
TokenKind “Kind” — This indicates the kind of Annotation token this is. See below for the different valid kinds.
Annotation tokens currently come in three kinds:

tok::annot_typename: This annotation token represents a resolved typename token that is potentially qualified. The AnnotationValue field contains the QualType returned by Sema::getTypeName(), possibly with source location information attached.
tok::annot_cxxscope: This annotation token represents a C++ scope specifier, such as “A::B::”. This corresponds to the grammar productions “::” and “:: [opt] nested-name-specifier”. The AnnotationValue pointer is a NestedNameSpecifier * returned by the Sema::ActOnCXXGlobalScopeSpecifier and Sema::ActOnCXXNestedNameSpecifier callbacks.
tok::annot_template_id: This annotation token represents a C++ template-id such as “foo<int, 4>”, where “foo” is the name of a template. The AnnotationValue pointer is a pointer to a malloc’d TemplateIdAnnotation object. Depending on the context, a parsed template-id that names a type might become a typename annotation token (if all we care about is the named type, e.g., because it occurs in a type specifier) or might remain a template-id token (if we want to retain more source location information or produce a new type, e.g., in a declaration of a class template specialization). template-id annotation tokens that refer to a type can be “upgraded” to typename annotation tokens by the parser.
As mentioned above, annotation tokens are not returned by the preprocessor, they are formed on demand by the parser. This means that the parser has to be aware of cases where an annotation could occur and form it where appropriate. This is somewhat similar to how the parser handles Translation Phase 6 of C99: String Concatenation (see C99 5.1.1.2). In the case of string concatenation, the preprocessor just returns distinct tok::string_literal and tok::wide_string_literal tokens and the parser eats a sequence of them wherever the grammar indicates that a string literal can occur.

In order to do this, whenever the parser expects a tok::identifier or tok::coloncolon, it should call the TryAnnotateTypeOrScopeToken or TryAnnotateCXXScopeToken methods to form the annotation token. These methods will maximally form the specified annotation tokens and replace the current token with them, if applicable. If the current tokens is not valid for an annotation token, it will remain an identifier or “::” token.

## The Lexer class
The Lexer class provides the mechanics of lexing tokens out of a source buffer and deciding what they mean. The Lexer is complicated by the fact that it operates on raw buffers that have not had spelling eliminated (this is a necessity to get decent performance), but this is countered with careful coding as well as standard performance techniques (for example, the comment handling code is vectorized on X86 and PowerPC hosts).

The lexer has a couple of interesting modal features:

The lexer can operate in “raw” mode. This mode has several features that make it possible to quickly lex the file (e.g., it stops identifier lookup, doesn’t specially handle preprocessor tokens, handles EOF differently, etc). This mode is used for lexing within an “#if 0” block, for example.
The lexer can capture and return comments as tokens. This is required to support the -C preprocessor mode, which passes comments through, and is used by the diagnostic checker to identifier expect-error annotations.
The lexer can be in ParsingFilename mode, which happens when preprocessing after reading a #include directive. This mode changes the parsing of “<” to return an “angled string” instead of a bunch of tokens for each thing within the filename.
When parsing a preprocessor directive (after “#”) the ParsingPreprocessorDirective mode is entered. This changes the parser to return EOD at a newline.
The Lexer uses a LangOptions object to know whether trigraphs are enabled, whether C++ or ObjC keywords are recognized, etc.
In addition to these modes, the lexer keeps track of a couple of other features that are local to a lexed buffer, which change as the buffer is lexed:

The Lexer uses BufferPtr to keep track of the current character being lexed.
The Lexer uses IsAtStartOfLine to keep track of whether the next lexed token will start with its “start of line” bit set.
The Lexer keeps track of the current “#if” directives that are active (which can be nested).
The Lexer keeps track of an MultipleIncludeOpt object, which is used to detect whether the buffer uses the standard “#ifndef XX / #define XX” idiom to prevent multiple inclusion. If a buffer does, subsequent includes can be ignored if the “XX” macro is defined.
The TokenLexer class
The TokenLexer class is a token provider that returns tokens from a list of tokens that came from somewhere else. It typically used for two things: 1) returning tokens from a macro definition as it is being expanded 2) returning tokens from an arbitrary buffer of tokens. The later use is used by _Pragma and will most likely be used to handle unbounded look-ahead for the C++ parser.


# parser
The Parser Library¶
This library contains a recursive-descent parser that polls tokens from the preprocessor and notifies a client of the parsing progress.

Historically, the parser used to talk to an abstract Action interface that had virtual methods for parse events, for example ActOnBinOp(). When Clang grew C++ support, the parser stopped supporting general Action clients – it now always talks to the Sema library. However, the Parser still accesses AST objects only through opaque types like ExprResult and StmtResult. Only Sema looks at the AST node contents of these wrappers.

# Sema
The Sema Library


This library is called by the Parser library during parsing to do semantic analysis of the input. For valid programs, Sema builds an AST for parsed constructs.

# class FunctionDecl
Declaration contexts
Every declaration in a program exists within some declaration context, such as a translation unit, namespace, class, or function. Declaration contexts in Clang are represented by the DeclContext class, from which the various declaration-context AST nodes (TranslationUnitDecl, NamespaceDecl, RecordDecl, **FunctionDecl**, etc.) will derive. The DeclContext class provides several facilities common to each declaration context:

Source-centric vs. Semantics-centric View of Declarations

DeclContext provides two views of the declarations stored within a declaration context. The source-centric view accurately represents the program source code as written, including multiple declarations of entities where present (see the section Redeclarations and Overloads), while the semantics-centric view represents the program semantics. The two views are kept synchronized by semantic analysis while the ASTs are being constructed.
Storage of declarations within that context

Every declaration context can contain some number of declarations. For example, a C++ class (represented by RecordDecl) contains various member functions, fields, nested types, and so on. All of these declarations will be stored within the DeclContext, and one can iterate over the declarations via [DeclContext::decls_begin(), DeclContext::decls_end()). This mechanism provides the source-centric view of declarations in the context.
Lookup of declarations within that context

The DeclContext structure provides efficient name lookup for names within that declaration context. For example, if N is a namespace we can look for the name N::f using DeclContext::lookup. The lookup itself is based on a lazily-constructed array (for declaration contexts with a small number of declarations) or hash table (for declaration contexts with more declarations). The lookup operation provides the semantics-centric view of the declarations in the context.
Ownership of declarations

The DeclContext owns all of the declarations that were declared within its declaration context, and is responsible for the management of their memory as well as their (de-)serialization.
All declarations are stored within a declaration context, and one can query information about the context in which each declaration lives. One can retrieve the DeclContext that contains a particular Decl using Decl::getDeclContext. However, see the section Lexical and Semantic Contexts for more information about how to interpret this context information.