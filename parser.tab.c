/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"



#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

FILE *outQ;
char *fName = "out.q.c";

char *line;
int lineSize;

#define true 1
#define false 0

enum op_igualdades{igual, no_igual, mayor, mayor_igual, menor, menor_igual};
enum op_logicos{and, or};
enum op_aritmeticas{sum, sub, mul, divi};
enum op_asignaciones{aigual, asum, asub, amul, adivi};

int tagCount = 1;
int br = 0;
int co = 0;
int fi = 0;

int int_regs[1   +5];
int float_regs[1 +3];

// Struct auxiliar para tratar con valores en la zona de expression
struct reg_tipo{
	int reg;
	int tipo;
};

// Variables auxiliares para comprobar los parámetros de las funciones
char* functionName = "";
int functionNumberParam = -1;
int checkingParamNumber = 0;

// Variables auxiliares para contar el número de parámetros de un array y sus tipos
int longitud_array = 0;
enum type tipo_array = -1;

// Variable auxiliar para controlar el movimiento relativo de R7
int r7Displacement = 0;

void yyerror(char*);
void lib_reg(struct reg_tipo*);
int assign_reg(int tipo);
void gc(char* text);

void adde(char*, enum type, enum category, int, int , struct array*);
struct reg_tipo * igualdades(struct reg_tipo*, struct reg_tipo*, enum op_igualdades);
struct reg_tipo * logicos(struct reg_tipo*, struct reg_tipo*, enum op_logicos);
struct reg_tipo * aritmeticas(struct reg_tipo*, struct reg_tipo*, enum op_aritmeticas);
int asignaciones(struct reg_tipo*, char*, enum op_asignaciones);
int getTag();

struct nodo * find(char* id);


#line 138 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELIF = 259,
    ELSE = 260,
    WHILE = 261,
    DO = 262,
    FOR = 263,
    CONTINUE = 264,
    BREAK = 265,
    AND = 266,
    OR = 267,
    NOT = 268,
    EQUALS = 269,
    NOT_EQ = 270,
    LESS_EQ = 271,
    BIGGER_EQ = 272,
    VOID = 273,
    INT = 274,
    FLOAT = 275,
    CHAR = 276,
    BOOL = 277,
    STRING = 278,
    HEADER = 279,
    GLOBAL = 280,
    RETURN = 281,
    PRINT = 282,
    ASSIGN_ADD = 283,
    ASSIGN_SUBS = 284,
    ASSIGN_MULT = 285,
    ASSIGN_DIV = 286,
    LIT_INT = 287,
    LIT_FLOAT = 288,
    LIT_CHAR = 289,
    LIT_STRING = 290,
    TRUE = 291,
    FALSE = 292,
    ID = 293,
    MAIN = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 114 "parser.y"

	char *str;
	long int4;
	float fl;
	char ch;
	struct reg_tipo * expr;
	int tip;
	int int1;

#line 240 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  5
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   539

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  57
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  73
/* YYNRULES -- Number of rules.  */
#define YYNRULES  136
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  252

#define YYUNDEFTOK  2
#define YYMAXUTOK   294


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,    47,     2,     2,
      51,    52,    45,    43,    54,    44,     2,    46,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    53,
      41,    40,    42,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    55,     2,    56,    48,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    49,     2,    50,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   146,   146,   150,   151,   153,   154,   156,   156,   158,
     159,   164,   164,   165,   165,   167,   178,   183,   184,   184,
     186,   187,   192,   194,   195,   199,   199,   199,   217,   222,
     223,   226,   227,   228,   229,   230,   231,   239,   240,   248,
     252,   253,   257,   258,   259,   262,   263,   264,   265,   267,
     267,   268,   274,   262,   293,   294,   295,   296,   297,   303,
     293,   323,   324,   325,   323,   336,   337,   346,   336,   357,
     359,   360,   369,   358,   380,   381,   386,   389,   392,   395,
     398,   408,   422,   423,   430,   437,   450,   450,   459,   460,
     463,   463,   464,   464,   471,   476,   485,   501,   502,   508,
     519,   520,   523,   526,   529,   532,   535,   538,   541,   544,
     547,   550,   553,   556,   557,   559,   568,   577,   586,   588,
     597,   610,   610,   636,   637,   643,   643,   659,   659,   679,
     680,   681,   682,   684,   685,   687,   688
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IF", "ELIF", "ELSE", "WHILE", "DO",
  "FOR", "CONTINUE", "BREAK", "AND", "OR", "NOT", "EQUALS", "NOT_EQ",
  "LESS_EQ", "BIGGER_EQ", "VOID", "INT", "FLOAT", "CHAR", "BOOL", "STRING",
  "HEADER", "GLOBAL", "RETURN", "PRINT", "ASSIGN_ADD", "ASSIGN_SUBS",
  "ASSIGN_MULT", "ASSIGN_DIV", "LIT_INT", "LIT_FLOAT", "LIT_CHAR",
  "LIT_STRING", "TRUE", "FALSE", "ID", "MAIN", "'='", "'<'", "'>'", "'+'",
  "'-'", "'*'", "'/'", "'%'", "'^'", "'{'", "'}'", "'('", "')'", "';'",
  "','", "'['", "']'", "$accept", "program", "header", "headerWrapper",
  "headerdcl", "$@1", "paramWrapper", "paramWrapperRecursive", "$@2",
  "$@3", "param", "global", "$@4", "globalWrapper", "functionArea",
  "functionWrapper", "functiondcl", "$@5", "$@6", "main",
  "statementWrapper", "statement", "printeableThings", "loop", "forLoop",
  "@7", "@8", "@9", "@10", "$@11", "$@12", "$@13", "$@14", "whileLoop",
  "@15", "@16", "@17", "@18", "$@19", "$@20", "conditional", "@21", "@22",
  "$@23", "ifCond", "@24", "$@25", "$@26", "elifCond", "@27", "$@28",
  "$@29", "elseCond", "varAssign", "variabledcl", "arraydcl", "$@30",
  "arrayWrapper", "array", "$@31", "$@32", "expression", "literals",
  "boolLiteral", "functionCall", "$@33", "paramsFunctionCallWrapper",
  "paramsFunctionCall", "$@34", "$@35", "typePrimitive", "typeVariable",
  "typeFunction", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
      61,    60,    62,    43,    45,    42,    47,    37,    94,   123,
     125,    40,    41,    59,    44,    91,    93
};
# endif

#define YYPACT_NINF (-160)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-124)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -18,   -40,    12,     2,  -160,  -160,   -29,  -160,    -5,  -160,
    -160,   158,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,
      -9,  -160,    16,  -160,  -160,    19,  -160,   104,     3,   177,
    -160,     7,    22,  -160,  -160,  -160,   -34,     9,    11,    13,
      23,    29,   -10,    24,    13,    25,    21,   204,    43,    15,
      30,    47,  -160,    37,    38,  -160,  -160,  -160,    49,    60,
      52,    15,  -160,  -160,  -160,  -160,  -160,   -32,    15,    15,
     275,  -160,  -160,  -160,    69,    70,    61,    64,  -160,   204,
      53,  -160,  -160,  -160,    83,    65,   226,   341,    15,    15,
      15,    15,    15,    15,    15,    15,    15,    15,    15,    15,
      15,    15,  -160,    66,   -31,  -160,    75,    82,    15,    71,
      72,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,
      93,  -160,    95,  -160,  -160,   112,    99,   100,  -160,   483,
     470,   491,   491,    96,    96,    96,    96,   226,   226,   103,
     103,   103,   103,  -160,   105,  -160,  -160,  -160,  -160,   288,
     417,    15,    15,    15,    15,    15,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,  -160,   107,   110,    15,  -160,   116,  -160,
    -160,   121,   448,   448,   448,   448,   448,   448,  -160,  -160,
    -160,   111,  -160,  -160,   448,   124,   138,    15,   148,   149,
    -160,  -160,   199,  -160,    15,   155,  -160,   448,  -160,   163,
     203,    20,   164,   448,  -160,    15,  -160,   167,   172,   236,
    -160,    15,   448,   224,    15,  -160,   198,   380,  -160,   392,
     162,    15,  -160,  -160,  -160,  -160,   431,   179,    15,   201,
    -160,  -160,   328,  -160,   207,   184,  -160,   210,  -160,   212,
     219,  -160,   232,  -160,    72,   211,   216,   220,  -160,  -160,
     258,  -160
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,     0,     0,    17,     5,     1,     0,    23,     0,    18,
       2,     0,   135,   131,   132,   130,   129,     4,     6,   136,
       0,    20,   131,    24,    23,     0,     7,     0,     0,    22,
      25,     0,     0,    19,    21,    83,     0,     0,     0,    11,
       0,     0,     0,     0,    11,     0,    10,     0,     0,     0,
       0,     0,    29,     0,     0,    13,   133,    12,   134,     0,
       0,     0,   115,   116,   117,   119,   120,    96,     0,     0,
       0,    97,   118,    94,     0,     0,    45,     0,     8,     0,
       0,    15,    82,    98,     0,     0,    99,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    81,     0,     0,    54,     0,     0,     0,     0,
     121,    28,    30,    31,    42,    46,    43,    55,    32,    62,
       0,    33,     0,    26,    14,     0,     0,   127,   100,   108,
     107,   101,   102,   103,   104,   106,   105,   109,   110,   111,
     112,   114,   113,    84,     0,    86,    44,    38,    36,     0,
       0,     0,     0,     0,     0,     0,    47,    56,    63,    35,
      34,    29,    16,    95,     0,   124,     0,    85,    90,    39,
      41,     0,    40,    77,    78,    79,    80,    76,    48,    57,
      65,    45,   122,   125,   128,     0,    89,     0,     0,     0,
      58,    69,     0,    27,     0,     0,    92,    91,    37,     0,
       0,    74,     0,   126,    87,     0,    49,     0,     0,     0,
      64,     0,    93,     0,     0,    29,     0,     0,    50,     0,
      45,     0,    66,    51,    59,    75,     0,     0,     0,     0,
      71,    29,     0,    29,     0,    45,    52,    45,    29,     0,
       0,    60,    45,    68,     0,     0,     0,     0,    73,    29,
      45,    53
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -160,  -160,  -160,  -160,  -160,  -160,   231,  -160,  -160,  -160,
     197,  -160,  -160,  -160,  -160,   259,  -160,  -160,  -160,  -160,
    -159,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,   183,  -160,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,    54,   -27,  -160,  -160,  -160,  -160,  -160,
    -160,   -58,  -160,  -160,   -75,  -160,  -160,  -160,  -160,  -160,
      -3,  -160,   285
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,     8,    18,    31,    45,    46,    47,    79,
      57,     7,    21,    27,    10,    11,    23,    38,   161,    24,
      76,   112,   171,   113,   114,   115,   156,   178,   189,   213,
     223,   228,   240,   116,   117,   157,   179,   190,   200,   229,
     118,   119,   158,   180,   191,   192,   227,   239,   201,   209,
     234,   246,   210,   120,   121,    35,   168,   185,   186,   187,
     205,    70,    71,    72,    73,    85,   164,   165,   194,   166,
      36,    59,    25
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      34,   122,   181,    83,    41,    19,     1,   144,    19,     4,
      86,    87,     5,    12,    13,    14,    15,    16,   145,  -121,
       9,    42,    50,    84,   -70,   208,    19,     6,    61,    26,
     129,   130,   131,   132,   133,   134,   135,   136,   137,   138,
     139,   140,   141,   142,    58,    17,    51,    62,    63,    64,
     149,    65,    66,    67,    37,    28,   220,    30,    39,    68,
      40,    43,    44,    48,   -61,    -9,    69,   -54,   105,    49,
     106,   107,   235,    52,   237,    55,    58,    54,    60,   242,
      13,    14,    15,    16,    32,    75,    74,   108,   109,    77,
     250,    78,   172,   173,   174,   175,   176,   177,    81,   110,
     151,   152,   153,   154,    80,    82,   122,   103,   184,   125,
     104,   111,   155,   123,   -61,   126,   127,   -54,   105,   143,
     106,   107,   150,    13,    14,    15,    16,    32,   147,   197,
      13,    14,    15,    16,    32,   148,   203,   108,   109,    96,
      97,    98,    99,   100,   101,   122,   159,   212,   160,   110,
     162,   101,  -123,   217,    33,   163,   219,   199,   167,   182,
     122,   193,   122,   226,   183,   -61,   -88,   122,   -54,   105,
     232,   106,   107,   188,   195,   122,    12,    22,    14,    15,
      16,    13,    14,    15,    16,    32,   218,   -61,   108,   109,
     -54,   105,   196,   106,   107,    12,    13,    14,    15,    16,
     110,   198,   202,    13,    14,    15,    16,    32,   204,   207,
     108,   109,   225,   -61,   206,   211,   -54,   105,   214,   106,
     107,   215,   110,    13,    14,    15,    16,    56,   231,    13,
      14,    15,    16,    32,   -67,   -61,   108,   109,   -54,   105,
     216,   106,   107,    13,    14,    15,    16,    32,   110,   221,
     233,    13,    14,    15,    16,    32,   238,   244,   108,   109,
     241,   -61,   243,   247,   -54,   105,   248,   106,   107,   249,
     110,    98,    99,   100,   101,    53,   124,    13,    14,    15,
      16,    32,   -72,    29,   108,   109,    88,    89,   146,    90,
      91,    92,    93,    20,   245,     0,   110,     0,     0,    88,
      89,     0,    90,    91,    92,    93,     0,     0,   251,     0,
       0,     0,     0,     0,     0,     0,    94,    95,    96,    97,
      98,    99,   100,   101,     0,     0,     0,     0,   102,    94,
      95,    96,    97,    98,    99,   100,   101,     0,     0,    88,
      89,   169,    90,    91,    92,    93,     0,     0,     0,     0,
       0,     0,    88,    89,     0,    90,    91,    92,    93,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    94,
      95,    96,    97,    98,    99,   100,   101,     0,     0,     0,
       0,   236,    94,    95,    96,    97,    98,    99,   100,   101,
       0,    88,    89,   128,    90,    91,    92,    93,     0,     0,
       0,     0,     0,    88,    89,     0,    90,    91,    92,    93,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    94,    95,    96,    97,    98,    99,   100,   101,     0,
      61,     0,   222,    94,    95,    96,    97,    98,    99,   100,
     101,     0,    88,    89,   224,    90,    91,    92,    93,    62,
      63,    64,   170,    65,    66,    67,     0,     0,     0,    88,
      89,    68,    90,    91,    92,    93,     0,     0,    69,     0,
       0,     0,    94,    95,    96,    97,    98,    99,   100,   101,
       0,    88,     0,   230,    90,    91,    92,    93,     0,    94,
      95,    96,    97,    98,    99,   100,   101,    90,    91,    92,
      93,     0,     0,     0,     0,     0,     0,    92,    93,     0,
       0,    94,    95,    96,    97,    98,    99,   100,   101,     0,
       0,     0,     0,     0,    94,    95,    96,    97,    98,    99,
     100,   101,    94,    95,    96,    97,    98,    99,   100,   101
};

static const yytype_int16 yycheck[] =
{
      27,    76,   161,    61,    38,     8,    24,    38,    11,    49,
      68,    69,     0,    18,    19,    20,    21,    22,    49,    51,
      49,    55,    32,    55,     4,     5,    29,    25,    13,    38,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,    47,    50,    56,    32,    33,    34,
     108,    36,    37,    38,    51,    39,   215,    38,    51,    44,
      38,    52,    51,    40,     3,    52,    51,     6,     7,    40,
       9,    10,   231,    49,   233,    54,    79,    52,    35,   238,
      19,    20,    21,    22,    23,    38,    56,    26,    27,    52,
     249,    53,   150,   151,   152,   153,   154,   155,    38,    38,
      28,    29,    30,    31,    55,    53,   181,    38,   166,    56,
      40,    50,    40,    49,     3,    32,    51,     6,     7,    53,
       9,    10,    51,    19,    20,    21,    22,    23,    53,   187,
      19,    20,    21,    22,    23,    53,   194,    26,    27,    43,
      44,    45,    46,    47,    48,   220,    53,   205,    53,    38,
      38,    48,    52,   211,    50,    56,   214,     8,    53,    52,
     235,    50,   237,   221,    54,     3,    50,   242,     6,     7,
     228,     9,    10,    52,    50,   250,    18,    19,    20,    21,
      22,    19,    20,    21,    22,    23,   213,     3,    26,    27,
       6,     7,    54,     9,    10,    18,    19,    20,    21,    22,
      38,    53,     3,    19,    20,    21,    22,    23,    53,     6,
      26,    27,    50,     3,    51,    51,     6,     7,    51,     9,
      10,    49,    38,    19,    20,    21,    22,    23,    49,    19,
      20,    21,    22,    23,    50,     3,    26,    27,     6,     7,
       4,     9,    10,    19,    20,    21,    22,    23,    38,    51,
      49,    19,    20,    21,    22,    23,    49,    38,    26,    27,
      50,     3,    50,    52,     6,     7,    50,     9,    10,    49,
      38,    45,    46,    47,    48,    44,    79,    19,    20,    21,
      22,    23,    50,    24,    26,    27,    11,    12,   105,    14,
      15,    16,    17,     8,   240,    -1,    38,    -1,    -1,    11,
      12,    -1,    14,    15,    16,    17,    -1,    -1,    50,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    41,    42,    43,    44,
      45,    46,    47,    48,    -1,    -1,    -1,    -1,    53,    41,
      42,    43,    44,    45,    46,    47,    48,    -1,    -1,    11,
      12,    53,    14,    15,    16,    17,    -1,    -1,    -1,    -1,
      -1,    -1,    11,    12,    -1,    14,    15,    16,    17,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    41,
      42,    43,    44,    45,    46,    47,    48,    -1,    -1,    -1,
      -1,    53,    41,    42,    43,    44,    45,    46,    47,    48,
      -1,    11,    12,    52,    14,    15,    16,    17,    -1,    -1,
      -1,    -1,    -1,    11,    12,    -1,    14,    15,    16,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    41,    42,    43,    44,    45,    46,    47,    48,    -1,
      13,    -1,    52,    41,    42,    43,    44,    45,    46,    47,
      48,    -1,    11,    12,    52,    14,    15,    16,    17,    32,
      33,    34,    35,    36,    37,    38,    -1,    -1,    -1,    11,
      12,    44,    14,    15,    16,    17,    -1,    -1,    51,    -1,
      -1,    -1,    41,    42,    43,    44,    45,    46,    47,    48,
      -1,    11,    -1,    52,    14,    15,    16,    17,    -1,    41,
      42,    43,    44,    45,    46,    47,    48,    14,    15,    16,
      17,    -1,    -1,    -1,    -1,    -1,    -1,    16,    17,    -1,
      -1,    41,    42,    43,    44,    45,    46,    47,    48,    -1,
      -1,    -1,    -1,    -1,    41,    42,    43,    44,    45,    46,
      47,    48,    41,    42,    43,    44,    45,    46,    47,    48
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    24,    58,    59,    49,     0,    25,    68,    60,    49,
      71,    72,    18,    19,    20,    21,    22,    50,    61,   127,
     129,    69,    19,    73,    76,   129,    38,    70,    39,    72,
      38,    62,    23,    50,   111,   112,   127,    51,    74,    51,
      38,    38,    55,    52,    51,    63,    64,    65,    40,    40,
      32,    56,    49,    63,    52,    54,    23,    67,   127,   128,
      35,    13,    32,    33,    34,    36,    37,    38,    44,    51,
     118,   119,   120,   121,    56,    38,    77,    52,    53,    66,
      55,    38,    53,   118,    55,   122,   118,   118,    11,    12,
      14,    15,    16,    17,    41,    42,    43,    44,    45,    46,
      47,    48,    53,    38,    40,     7,     9,    10,    26,    27,
      38,    50,    78,    80,    81,    82,    90,    91,    97,    98,
     110,   111,   121,    49,    67,    56,    32,    51,    52,   118,
     118,   118,   118,   118,   118,   118,   118,   118,   118,   118,
     118,   118,   118,    53,    38,    49,    90,    53,    53,   118,
      51,    28,    29,    30,    31,    40,    83,    92,    99,    53,
      53,    75,    38,    56,   123,   124,   126,    53,   113,    53,
      35,    79,   118,   118,   118,   118,   118,   118,    84,    93,
     100,    77,    52,    54,   118,   114,   115,   116,    52,    85,
      94,   101,   102,    50,   125,    50,    54,   118,    53,     8,
      95,   105,     3,   118,    53,   117,    51,     6,     5,   106,
     109,    51,   118,    86,    51,    49,     4,   118,   111,   118,
      77,    51,    52,    87,    52,    50,   118,   103,    88,    96,
      52,    49,   118,    49,   107,    77,    53,    77,    49,   104,
      89,    50,    77,    50,    38,   110,   108,    52,    50,    49,
      77,    50
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    57,    58,    59,    59,    60,    60,    62,    61,    63,
      63,    65,    64,    66,    64,    67,    67,    68,    69,    68,
      70,    70,    71,    72,    72,    74,    75,    73,    76,    77,
      77,    78,    78,    78,    78,    78,    78,    78,    78,    78,
      79,    79,    80,    80,    80,    82,    83,    84,    85,    86,
      87,    88,    89,    81,    91,    92,    93,    94,    95,    96,
      90,    98,    99,   100,    97,   102,   103,   104,   101,   105,
     106,   107,   108,   105,   109,   109,   110,   110,   110,   110,
     110,   111,   111,   111,   112,   112,   113,   112,   114,   114,
     116,   115,   117,   115,   118,   118,   118,   118,   118,   118,
     118,   118,   118,   118,   118,   118,   118,   118,   118,   118,
     118,   118,   118,   118,   118,   119,   119,   119,   119,   120,
     120,   122,   121,   123,   123,   125,   124,   126,   124,   127,
     127,   127,   127,   128,   128,   129,   129
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     3,     0,     4,     0,     2,     0,     7,     0,
       1,     0,     2,     0,     4,     2,     4,     0,     0,     5,
       0,     2,     3,     0,     2,     0,     0,    10,     7,     0,
       2,     1,     1,     1,     2,     2,     2,     5,     2,     3,
       1,     1,     1,     1,     2,     0,     0,     0,     0,     0,
       0,     0,     0,    18,     0,     0,     0,     0,     0,     0,
      13,     0,     0,     0,     6,     0,     0,     0,    10,     0,
       0,     0,     0,    11,     0,     4,     3,     3,     3,     3,
       3,     5,     5,     1,     6,     7,     0,    10,     0,     1,
       0,     2,     0,     4,     1,     4,     1,     1,     2,     2,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     1,     1,     1,     1,     1,
       1,     0,     5,     0,     1,     0,     4,     0,     2,     1,
       1,     1,     1,     1,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 7:
#line 156 "parser.y"
                                                {adde((yyvsp[0].str), (yyvsp[-1].tip), funcion, 0, -1, NULL);}
#line 1663 "parser.tab.c"
    break;

  case 10:
#line 159 "parser.y"
                                                               {
												if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
												checkingParamNumber = 0;
											}
#line 1672 "parser.tab.c"
    break;

  case 11:
#line 164 "parser.y"
                       {checkingParamNumber++;}
#line 1678 "parser.tab.c"
    break;

  case 13:
#line 165 "parser.y"
                                                                  {checkingParamNumber++;}
#line 1684 "parser.tab.c"
    break;

  case 15:
#line 167 "parser.y"
                                                                                                                {	
																		if(functionName[0] == '\0') {
																			adde((yyvsp[0].str), (yyvsp[-1].tip), param, 0, getAddress((yyvsp[-1].tip), 1), NULL);
																		} else {
																			struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																			
																			if(param == NULL) yyerror("El parametro o la funcion no esta declarado en el header.");
																			if((yyvsp[-1].tip) != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																			if(strcmp((yyvsp[0].str), param->id) != 0) yyerror("El nombre del parametro no corresponde con el del header");	
																		}
																	}
#line 1700 "parser.tab.c"
    break;

  case 18:
#line 184 "parser.y"
                                                   {scope = 0;}
#line 1706 "parser.tab.c"
    break;

  case 19:
#line 184 "parser.y"
                                                                                                {scope = 0;}
#line 1712 "parser.tab.c"
    break;

  case 23:
#line 194 "parser.y"
                                                                        {br = 0; co = 0;}
#line 1718 "parser.tab.c"
    break;

  case 24:
#line 195 "parser.y"
                                                                    {br = 0; co = 0;}
#line 1724 "parser.tab.c"
    break;

  case 25:
#line 199 "parser.y"
                                        {functionName = (yyvsp[0].str); functionNumberParam = countFunctionParameters((yyvsp[0].str));}
#line 1730 "parser.tab.c"
    break;

  case 26:
#line 199 "parser.y"
                                                                                                                                                        {
											struct nodo *puntero = search((yyvsp[-5].str), funcion);
											if(puntero == NULL) yyerror("La funcion no esta declarada en el header");
											if((yyvsp[-6].tip) != puntero->tipo) yyerror("El tipo de la funcion no corresponde con la del header");
									
											puntero = puntero->param;
											while(puntero != NULL) {
												adde(puntero->id, puntero->tipo, local, scope, puntero->address, puntero->array); // FIXME cuando es array el tipo no es el del puntero, sino entero
												
												puntero = puntero->param;
											}
											
											functionNumberParam = -1;
											functionName = "";
										}
#line 1750 "parser.tab.c"
    break;

  case 27:
#line 215 "parser.y"
                                                                                                                                        {deleteScope(scope);}
#line 1756 "parser.tab.c"
    break;

  case 28:
#line 217 "parser.y"
                                                                                                        {deleteScope(scope);}
#line 1762 "parser.tab.c"
    break;

  case 36:
#line 231 "parser.y"
                                                                        {
												if (br){
													snprintf(line,lineSize, "\tGT(%d) //break- l:%d\n", br,numlin);
													gc(line);
												}else{
													yyerror("Break fuera de bucle");
												}
												}
#line 1775 "parser.tab.c"
    break;

  case 38:
#line 240 "parser.y"
                                                        {
												if (co){
													snprintf(line,lineSize, "\tGT(%d) //continue - l:%d\n", co,numlin);
													gc(line);
												}else{
													yyerror("Continue fuera de bucle");
												}
												}
#line 1788 "parser.tab.c"
    break;

  case 45:
#line 262 "parser.y"
                {(yyval.int1) = co;}
#line 1794 "parser.tab.c"
    break;

  case 46:
#line 263 "parser.y"
                                        {(yyval.int1) = br;}
#line 1800 "parser.tab.c"
    break;

  case 47:
#line 264 "parser.y"
                                        {co = getTag(); (yyval.int1) = co;}
#line 1806 "parser.tab.c"
    break;

  case 48:
#line 265 "parser.y"
                                        {br = getTag(); (yyval.int1) = br;}
#line 1812 "parser.tab.c"
    break;

  case 49:
#line 267 "parser.y"
                                                {scope++;}
#line 1818 "parser.tab.c"
    break;

  case 50:
#line 267 "parser.y"
                                                                       {scope--;}
#line 1824 "parser.tab.c"
    break;

  case 51:
#line 268 "parser.y"
                                        {
					snprintf(line,lineSize, "L %d: //for con - l:%d\n", (yyvsp[-6].int1),numlin);
					gc(line);
					}
#line 1833 "parser.tab.c"
    break;

  case 52:
#line 274 "parser.y"
                                        {
					if ((yyvsp[-1].expr)->tipo != boolean){
						yyerror("La expresión del bucle no es booleana");
					}
					snprintf(line,lineSize, "\tIF (!R%d) GT(%d); //for bool - l:%d\n",(yyvsp[-1].expr)->reg, (yyvsp[-8].int1),numlin);
					gc(line);
					lib_reg((yyvsp[-1].expr));
					}
#line 1846 "parser.tab.c"
    break;

  case 53:
#line 284 "parser.y"
                                        {
					co = (yyvsp[-17].int1);	// Retrieve previous continue tag
					br = (yyvsp[-16].int1);	// Retrieve previous break tag
					snprintf(line,lineSize, "L %d: //for bre - l:%d\n", (yyvsp[-14].int1),numlin);
					gc(line);
					
					deleteScope(scope);
					}
#line 1859 "parser.tab.c"
    break;

  case 54:
#line 293 "parser.y"
                {(yyval.int1) = co;}
#line 1865 "parser.tab.c"
    break;

  case 55:
#line 294 "parser.y"
                                                {(yyval.int1) = br;}
#line 1871 "parser.tab.c"
    break;

  case 56:
#line 295 "parser.y"
                                                {co = getTag(); (yyval.int1) = co;}
#line 1877 "parser.tab.c"
    break;

  case 57:
#line 296 "parser.y"
                                                {br = getTag(); (yyval.int1) = br;}
#line 1883 "parser.tab.c"
    break;

  case 58:
#line 297 "parser.y"
                                                {
						snprintf(line,lineSize, "L %d: //while con - l:%d\n", (yyvsp[-1].int1),numlin);
						gc(line);
						}
#line 1892 "parser.tab.c"
    break;

  case 59:
#line 303 "parser.y"
                                                {
						if ((yyvsp[-1].expr)->tipo != boolean){
							yyerror("La expresión del bucle no es booleana");
						}
						snprintf(line,lineSize, "\tIF (!R%d) GT(%d); //while bool - l:%d\n",(yyvsp[-1].expr)->reg, (yyvsp[-5].int1),numlin);
						gc(line);
						lib_reg((yyvsp[-1].expr));
						}
#line 1905 "parser.tab.c"
    break;

  case 60:
#line 312 "parser.y"
                                                {
						co = (yyvsp[-12].int1);	// Retrieve previous continue tag
						br = (yyvsp[-11].int1);	// Retrieve previous break tag
						snprintf(line,lineSize, "L %d: // while bre - l:%d\n", (yyvsp[-9].int1),numlin);
						gc(line);
						deleteScope(scope);
						}
#line 1917 "parser.tab.c"
    break;

  case 61:
#line 323 "parser.y"
                {(yyval.int1) = fi;}
#line 1923 "parser.tab.c"
    break;

  case 62:
#line 324 "parser.y"
                                                        {fi = getTag(); (yyval.int1) = fi;}
#line 1929 "parser.tab.c"
    break;

  case 63:
#line 325 "parser.y"
                                                        {snprintf(line,lineSize, "//if start - l:%d\n",numlin);gc(line);}
#line 1935 "parser.tab.c"
    break;

  case 64:
#line 329 "parser.y"
                                                        {
							fi = (yyvsp[-5].int1);	// Retrieve previous if tag
							snprintf(line,lineSize, "L %d: //if exit - l:%d\n", (yyvsp[-4].int1),numlin);
							gc(line);
							}
#line 1945 "parser.tab.c"
    break;

  case 65:
#line 336 "parser.y"
                                {(yyval.int1) = getTag();}
#line 1951 "parser.tab.c"
    break;

  case 66:
#line 337 "parser.y"
                                                                              {
							if ((yyvsp[-1].expr)->tipo != boolean){
								yyerror("La expresión del if no es booleana");
							}
							snprintf(line,lineSize, "\tIF (!R%d) GT(%d); //if bool - l:%d\n",(yyvsp[-1].expr)->reg, (yyvsp[-4].int1),numlin);
							gc(line);
							lib_reg((yyvsp[-1].expr));
							}
#line 1964 "parser.tab.c"
    break;

  case 67:
#line 346 "parser.y"
                                                        {
							snprintf(line,lineSize, "\tGT(%d); //exit if - l:%d\n",fi,numlin);
							gc(line);
							}
#line 1973 "parser.tab.c"
    break;

  case 68:
#line 351 "parser.y"
                                                        {
							snprintf(line,lineSize, "L %d: //if not - l:%d\n", (yyvsp[-9].int1),numlin);
							gc(line);
							deleteScope(scope);
							}
#line 1983 "parser.tab.c"
    break;

  case 70:
#line 359 "parser.y"
                                        {(yyval.int1) = getTag();}
#line 1989 "parser.tab.c"
    break;

  case 71:
#line 360 "parser.y"
                                                                {
					if ((yyvsp[-1].expr)->tipo != boolean){
						yyerror("La expresión del if no es booleana");
					}
					snprintf(line,lineSize, "\tIF (!R%d) GT(%d);//elif bool - l:%d\n",(yyvsp[-1].expr)->reg, (yyvsp[-4].int1),numlin);
					gc(line);
					lib_reg((yyvsp[-1].expr));
					}
#line 2002 "parser.tab.c"
    break;

  case 72:
#line 369 "parser.y"
                                        {
					snprintf(line,lineSize, "\tGT(%d); //exit elif - l:%d\n",fi,numlin);
					gc(line);
					}
#line 2011 "parser.tab.c"
    break;

  case 73:
#line 374 "parser.y"
                                        {
					snprintf(line,lineSize, "L %d: //elif not - l:%d\n", (yyvsp[-9].int1),numlin);
					gc(line);
					deleteScope(scope);
					}
#line 2021 "parser.tab.c"
    break;

  case 75:
#line 381 "parser.y"
                                                                                                                                {deleteScope(scope);}
#line 2027 "parser.tab.c"
    break;

  case 76:
#line 386 "parser.y"
                                                                {
																		asignaciones((yyvsp[0].expr), (yyvsp[-2].str), aigual);
																		}
#line 2035 "parser.tab.c"
    break;

  case 77:
#line 389 "parser.y"
                                                                        {
																		asignaciones((yyvsp[0].expr), (yyvsp[-2].str), asum);
																		}
#line 2043 "parser.tab.c"
    break;

  case 78:
#line 392 "parser.y"
                                                                        {
																		asignaciones((yyvsp[0].expr), (yyvsp[-2].str), asub);
																		}
#line 2051 "parser.tab.c"
    break;

  case 79:
#line 395 "parser.y"
                                                                        {
																		asignaciones((yyvsp[0].expr), (yyvsp[-2].str), amul);
																		}
#line 2059 "parser.tab.c"
    break;

  case 80:
#line 398 "parser.y"
                                                                        {
																		asignaciones((yyvsp[0].expr), (yyvsp[-2].str), adivi);
																		}
#line 2067 "parser.tab.c"
    break;

  case 81:
#line 408 "parser.y"
                                                        {												/*adde($2, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), NULL);
																										snprintf(line,lineSize, "\t//ID initialization: %s - l:%d\n",$2, numlin);
																										gc(line);// FIXME free reg_tipo*/
																										
																										r7Displacement++;
																										adde((yyvsp[-3].str), (yyvsp[-4].tip), (scope == 0) ? global : local, scope, +(r7Displacement * 4), NULL);
																										
																										snprintf(line, lineSize, "\tR7 = R7 - %d\n", 4 * r7Displacement);
																										gc(line);
																										snprintf(line, lineSize, "\tI(R6 - %d) = R%d\n", 4 * r7Displacement, (yyvsp[-1].expr)->reg);
																										gc(line);
																										
																										lib_reg((yyvsp[-1].expr));
																										}
#line 2086 "parser.tab.c"
    break;

  case 84:
#line 430 "parser.y"
                                                                     {
																		if ((yyvsp[-3].int4) < 0) yyerror("Una array no puede tener un número de elementos negativo");
																		struct array *arr = malloc(sizeof(struct array));
																		arr->length = (yyvsp[-3].int4);
																		arr->address = getAddress((yyvsp[-5].tip), arr->length);
																		adde((yyvsp[-1].str), (yyvsp[-5].tip), (scope == 0) ? global : local, scope, getAddress((yyvsp[-5].tip), 1), arr);
																		}
#line 2098 "parser.tab.c"
    break;

  case 85:
#line 437 "parser.y"
                                                                            {
																		struct nodo* puntero = find((yyvsp[-1].str));
																		if (puntero == NULL){
																			yyerror("La segunda ID no está definida");
																		};
																		if((yyvsp[-6].tip) != puntero->tipo) {
																			yyerror("El tipo de ambas ID no coincide");
																		};
																		if (puntero->array == 0){
																			yyerror("La segunda ID no es una array");
																		};
																		adde((yyvsp[-3].str), (yyvsp[-6].tip), (scope == 0) ? global : local, scope, getAddress(entero,1), puntero->array);
																		}
#line 2116 "parser.tab.c"
    break;

  case 86:
#line 450 "parser.y"
                                                                         {tipo_array = (yyvsp[-5].tip);}
#line 2122 "parser.tab.c"
    break;

  case 87:
#line 450 "parser.y"
                                                                                                                        {
																									struct array *arr = malloc(sizeof(struct array));
																									arr->length = longitud_array;		
																									arr->address = getAddress((yyvsp[-9].tip), arr->length);
																									adde((yyvsp[-6].str), (yyvsp[-9].tip), (scope == 0) ? global : local, scope, getAddress((yyvsp[-9].tip), 1), arr);																									
																									tipo_array = -1;
																									longitud_array = 0;
																								}
#line 2135 "parser.tab.c"
    break;

  case 90:
#line 463 "parser.y"
                {longitud_array++;}
#line 2141 "parser.tab.c"
    break;

  case 91:
#line 463 "parser.y"
                                                                        {if((yyvsp[0].expr)->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");}
#line 2147 "parser.tab.c"
    break;

  case 92:
#line 464 "parser.y"
                                  {longitud_array++;}
#line 2153 "parser.tab.c"
    break;

  case 93:
#line 464 "parser.y"
                                                                        {if((yyvsp[0].expr)->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");}
#line 2159 "parser.tab.c"
    break;

  case 94:
#line 471 "parser.y"
                                                                                                {
																					if ((yyvsp[0].expr)->tipo == vacio) yyerror("Una funcion void no devuelve parametro");
																					struct reg_tipo *ex = (yyvsp[0].expr);
																					(yyval.expr) = (yyvsp[0].expr);
																					}
#line 2169 "parser.tab.c"
    break;

  case 95:
#line 476 "parser.y"
                                                                                                                {
																					struct nodo *puntero = find((yyvsp[-3].str));
																					if (puntero->array == NULL) yyerror("La ID no es una array");
																					int reg = assign_reg(puntero->tipo);
																					struct reg_tipo *ex =  malloc(sizeof(struct reg_tipo));
																					ex->reg = reg;
																					ex->tipo = puntero->tipo; // FIXME if array it should return caracter, not ristra
																					// TODO collect from array
																					}
#line 2183 "parser.tab.c"
    break;

  case 96:
#line 485 "parser.y"
                                                                                                                                                                {
																					struct nodo *puntero = find((yyvsp[0].str));
																					if (puntero->array != NULL) yyerror("La ID es una array");
																					int reg = assign_reg(puntero->tipo);
																					struct reg_tipo *ex = malloc(sizeof(struct reg_tipo));
																					ex->reg = reg;
																					ex->tipo = puntero->tipo;
																					if (puntero->tipo == comaFlotante){
																						snprintf(line,lineSize, "\tRR%d = I(R6 - %d);  //evaluate %s %d\n", reg, puntero->address, (yyvsp[0].str), numlin);
																						gc(line);
																					}else{
																						snprintf(line,lineSize, "\tR%d = I(R6 - %d);  //evaluate %s %d\n", reg, puntero->address, (yyvsp[0].str), numlin);
																						gc(line);
																					}
																					(yyval.expr) = ex;
																					}
#line 2204 "parser.tab.c"
    break;

  case 97:
#line 501 "parser.y"
                                                                                                                                                {(yyval.expr) = (yyvsp[0].expr);}
#line 2210 "parser.tab.c"
    break;

  case 98:
#line 502 "parser.y"
                                                                                                                        {
																					if ((yyvsp[0].expr)->tipo != boolean) yyerror("No es un tipo boolean");
																					snprintf(line,lineSize, "\tR%d=!R%d;\n",(yyvsp[0].expr)->reg,(yyvsp[0].expr)->reg);
																					gc(line);
																					(yyval.expr) = (yyvsp[0].expr); // same type, same register
																					}
#line 2221 "parser.tab.c"
    break;

  case 99:
#line 508 "parser.y"
                                                                                                                        {
																					if ((yyvsp[0].expr)->tipo == comaFlotante){
																						snprintf(line,lineSize, "\tRR%d=0-RR%d;\n",(yyvsp[0].expr)->reg,(yyvsp[0].expr)->reg);
																					}else if((yyvsp[0].expr)->tipo == entero){
																						snprintf(line,lineSize, "\tR%d=0-R%d;\n",(yyvsp[0].expr)->reg,(yyvsp[0].expr)->reg);
																					}else{
																						yyerror("No es un tipo numérico");
																					}
																					gc(line);
																					(yyval.expr) = (yyvsp[0].expr); // same type, same register
																					}
#line 2237 "parser.tab.c"
    break;

  case 100:
#line 519 "parser.y"
                                                                                                                {(yyval.expr) = (yyvsp[-1].expr);}
#line 2243 "parser.tab.c"
    break;

  case 101:
#line 520 "parser.y"
                                                                                {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), igual);
																					}
#line 2251 "parser.tab.c"
    break;

  case 102:
#line 523 "parser.y"
                                                                                {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), no_igual);
																					}
#line 2259 "parser.tab.c"
    break;

  case 103:
#line 526 "parser.y"
                                                                                {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), menor_igual);
																					}
#line 2267 "parser.tab.c"
    break;

  case 104:
#line 529 "parser.y"
                                                                        {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), mayor_igual);
																					}
#line 2275 "parser.tab.c"
    break;

  case 105:
#line 532 "parser.y"
                                                                                                {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), menor);
																					}
#line 2283 "parser.tab.c"
    break;

  case 106:
#line 535 "parser.y"
                                                                                        {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), menor);
																					}
#line 2291 "parser.tab.c"
    break;

  case 107:
#line 538 "parser.y"
                                                                                                {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), or);
																					}
#line 2299 "parser.tab.c"
    break;

  case 108:
#line 541 "parser.y"
                                                                                        {
																					(yyval.expr) = igualdades((yyvsp[-2].expr), (yyvsp[0].expr), and);
																					}
#line 2307 "parser.tab.c"
    break;

  case 109:
#line 544 "parser.y"
                                                                                        {
																					(yyval.expr) = aritmeticas((yyvsp[-2].expr), (yyvsp[0].expr), sum);
																					}
#line 2315 "parser.tab.c"
    break;

  case 110:
#line 547 "parser.y"
                                                                                        {
																					(yyval.expr) = aritmeticas((yyvsp[-2].expr), (yyvsp[0].expr), sub);
																					}
#line 2323 "parser.tab.c"
    break;

  case 111:
#line 550 "parser.y"
                                                                                        {
																					(yyval.expr) = aritmeticas((yyvsp[-2].expr), (yyvsp[0].expr), mul);
																					}
#line 2331 "parser.tab.c"
    break;

  case 112:
#line 553 "parser.y"
                                                                                        {
																					(yyval.expr) = aritmeticas((yyvsp[-2].expr), (yyvsp[0].expr), divi);
																					}
#line 2339 "parser.tab.c"
    break;

  case 115:
#line 559 "parser.y"
                                                                                        {
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = entero;
																		snprintf(line,lineSize, "\tR%d = %ld;\n",reg, (yyvsp[0].int4));
																		gc(line);
																		(yyval.expr) = res;
																		}
#line 2353 "parser.tab.c"
    break;

  case 116:
#line 568 "parser.y"
                                                                                                                {
																		int reg = assign_reg(comaFlotante);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = comaFlotante;
																		snprintf(line,lineSize, "\tRR%d = %f;\n",reg, (yyvsp[0].fl));
																		gc(line);
																		(yyval.expr) = res;
																		}
#line 2367 "parser.tab.c"
    break;

  case 117:
#line 577 "parser.y"
                                                                                                                        {
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = caracter;
																		snprintf(line,lineSize, "\tR%d = %d;\n",reg, (yyvsp[0].ch));
																		gc(line);
																		(yyval.expr) = res;
																		}
#line 2381 "parser.tab.c"
    break;

  case 118:
#line 586 "parser.y"
                                                                                                                {(yyval.expr) = (yyvsp[0].expr);}
#line 2387 "parser.tab.c"
    break;

  case 119:
#line 588 "parser.y"
                                                                                        {
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 1;\n",reg);
																		gc(line);
																		(yyval.expr) = res;
																		}
#line 2401 "parser.tab.c"
    break;

  case 120:
#line 597 "parser.y"
                                                                                                                                {
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 0;\n",reg);
																		gc(line);
																		(yyval.expr) = res;
																		}
#line 2415 "parser.tab.c"
    break;

  case 121:
#line 610 "parser.y"
                           {
							functionName = (yyvsp[0].str); functionNumberParam = countFunctionParameters((yyvsp[0].str));

							snprintf(line,lineSize, "\n\tR7 = R7 - %d\n", (functionNumberParam + 2) * 4);
							gc(line);
						}
#line 2426 "parser.tab.c"
    break;

  case 122:
#line 617 "parser.y"
                                                                                {
																	struct nodo *puntero = search((yyvsp[-4].str), funcion);
																	if(puntero == NULL) {
																		yyerror("La funcion no esta declarada en el header");
																	}
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = R6\n", (functionNumberParam + 1) * 4);
																	gc(line);	
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = etiqueta\n", (functionNumberParam) * 4);
																	gc(line);	
																	
																	snprintf(line,lineSize, "L et:\tR7 = R7 + %d\n", (functionNumberParam + 2) * 4);
																	gc(line);	
																	
																	functionNumberParam = -1;
																	functionName = "";
																}
#line 2449 "parser.tab.c"
    break;

  case 124:
#line 637 "parser.y"
                                                           {
											if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
											checkingParamNumber = 0;
										}
#line 2458 "parser.tab.c"
    break;

  case 125:
#line 643 "parser.y"
                                           {checkingParamNumber++;}
#line 2464 "parser.tab.c"
    break;

  case 126:
#line 643 "parser.y"
                                                                                        {
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if((yyvsp[0].expr)->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																						
																						param->address = checkingParamNumber * 4;

																						if((yyvsp[0].expr)->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d\n", (checkingParamNumber - 1) * 4, (yyvsp[0].expr)->reg);
																						} else {
																							snprintf(line,lineSize, "\tI(R7 + %d) = RR%d\n", (checkingParamNumber - 1) * 4, (yyvsp[0].expr)->reg);
																						}
																						gc(line);
																						
																						lib_reg((yyvsp[0].expr));
																					}
#line 2485 "parser.tab.c"
    break;

  case 127:
#line 659 "parser.y"
        {checkingParamNumber++;}
#line 2491 "parser.tab.c"
    break;

  case 128:
#line 659 "parser.y"
                                                                                                                                {	
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if((yyvsp[0].expr)->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																						
																						param->address = checkingParamNumber*4;

																						if((yyvsp[0].expr)->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d\n", (checkingParamNumber - 1) * 4, (yyvsp[0].expr)->reg);
																						} else {
																							snprintf(line,lineSize, "\tI(R7 + %d) = RR%d\n", (checkingParamNumber - 1) * 4, (yyvsp[0].expr)->reg);
																						}
																						gc(line);
																						
																						lib_reg((yyvsp[0].expr));
																					}
#line 2512 "parser.tab.c"
    break;

  case 129:
#line 679 "parser.y"
                                                {(yyval.tip) = boolean;}
#line 2518 "parser.tab.c"
    break;

  case 130:
#line 680 "parser.y"
                                                                {(yyval.tip) = caracter;}
#line 2524 "parser.tab.c"
    break;

  case 131:
#line 681 "parser.y"
                                                                        {(yyval.tip) = entero;}
#line 2530 "parser.tab.c"
    break;

  case 132:
#line 682 "parser.y"
                                                                {(yyval.tip) = comaFlotante;}
#line 2536 "parser.tab.c"
    break;

  case 133:
#line 684 "parser.y"
                                                {(yyval.tip) = ristra;}
#line 2542 "parser.tab.c"
    break;

  case 134:
#line 685 "parser.y"
                                                        {(yyval.tip) = (yyvsp[0].tip);}
#line 2548 "parser.tab.c"
    break;

  case 135:
#line 687 "parser.y"
                                                {(yyval.tip) = vacio;}
#line 2554 "parser.tab.c"
    break;

  case 136:
#line 688 "parser.y"
                                                        {(yyval.tip) = (yyvsp[0].tip);}
#line 2560 "parser.tab.c"
    break;


#line 2564 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 691 "parser.y"


struct nodo * find(char* id){
	struct nodo *puntero = search(id, local);
	if (puntero == NULL){
		puntero = search(id, global);
		if (puntero == NULL){
			yyerror("ID no existente");
		}
	}
	return puntero;
}

int getTag(){
	int res = tagCount;
	tagCount = tagCount + 1;
	return res;
}

void gc(char* text){
	printf("%s",text);
	fputs(text, outQ);
}

int assign_reg(int tipo){
	int len;
	if (tipo == comaFlotante){
		len = sizeof(float_regs)/sizeof(int_regs[0]);
		for (int i = 0; i < len; i++){
			if (!float_regs[i]){
				float_regs[i] = true;
				return i;
				break;
			}
		}
		yyerror("Fallo de compilador, sin registros comaFlotante");
	}else{
		len = sizeof(int_regs)/sizeof(int_regs[0]);
		for (int i = 0; i < len; i++){
			if (!int_regs[i]){
				int_regs[i] = true;
				return i;
				break;
			}
		}
		yyerror("Fallo de compilador, sin registros entero");
	}

}

void lib_reg(struct reg_tipo* reg){
	int len;
	if (reg->tipo == comaFlotante){
		len = sizeof(float_regs)/sizeof(int_regs[0]);
		if (len <= reg->reg){
			snprintf(line,lineSize,"Fallo de compilador, el registro comaFlotante %d no está disponible, máximo %d",reg->reg, len);
			yyerror(line);
		}
		float_regs[reg->reg] = false;
	}else{
		len = sizeof(int_regs)/sizeof(int_regs[0]);
		if (len <= reg->reg){
			snprintf(line,lineSize,"Fallo de compilador, el registro entero %d no está disponible, máximo %d", reg->reg, len);
			yyerror(line);
		}
		int_regs[reg->reg] = false;
	}
	free(reg);
}

void adde(char* id, enum type tipo, enum category categoria, int scope, int address, struct array *array) {
	if (!add(id, tipo, categoria, scope, address, array)){
		yyerror("Error al añadir a pila, la variable ya existe");
	}
}

void yyerror(char* mens) {
  printf("Error en linea %i: %s \n",numlin,mens);
	fclose(outQ);
  exit(-1);
}

int main(int argc, char** argv) {
	int len = sizeof(float_regs)/sizeof(int_regs[0]);
	for (int i = 0; i < len; i++){
		float_regs[i] = false;
	}

	len = sizeof(int_regs)/sizeof(int_regs[0]);
	for (int i = 0; i < len; i++){
		int_regs[i] = false;
	}

	char charSize = 'a';
	lineSize = sizeof(charSize)*300;
	line = malloc(lineSize);

  if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	outQ = fopen(fName,"w");
	fputs("", outQ);
	fclose(outQ);
	outQ = fopen(fName,"a");

	snprintf(line,lineSize, "BEGIN\n");
	gc(line);
	yyparse();
	snprintf(line,lineSize, "END\n");
	gc(line);

	free(line);
	fclose(outQ);

	show();
  return 0;
}


// Funciones auxiliares

struct reg_tipo * igualdades(struct reg_tipo* izq, struct reg_tipo* der, enum op_igualdades operator){
	snprintf(line,lineSize,"\t// Igualdad - l:%d\n",numlin);
	gc(line);

	char op[2];
	if (operator == igual){
		strncpy(op, "==",sizeof(op));
	}else if (operator == no_igual){
		strncpy(op, "!=",sizeof(op));
	}else{
		if (izq->tipo == boolean && der->tipo == boolean){
			yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
		}
		if (operator == mayor){
			strncpy(op, ">",sizeof(op));
		}else if (operator == mayor_igual){
			strncpy(op, ">=",sizeof(op));
		}else if (operator == menor){
			strncpy(op, "<",sizeof(op));
		}else if (operator == menor_igual){
			strncpy(op, "<=",sizeof(op));
		}else{
			yyerror("Error de compilador en la igualdad");
		}
	}


	struct reg_tipo* res;
	if (izq->tipo == caracter && der->tipo == caracter ||
			izq->tipo == entero && der->tipo == entero ||
			izq->tipo == entero && der->tipo == caracter ||
			izq->tipo == caracter && der->tipo == entero ||
			izq->tipo == boolean && der->tipo == boolean){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		int reg = assign_reg(entero);
		snprintf(line,lineSize, "\tR%d=RR%d%sRR%d;\n",reg ,izq->reg,op,der->reg); // FIXME get register
		lib_reg(der);
		lib_reg(izq);
		struct reg_tipo *aux =  malloc(sizeof(struct reg_tipo));
		aux->reg = reg;
		aux->tipo = boolean;
		res = aux;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tR%d=RR%d%sR%d;\n",der->reg,izq->reg,op,der->reg);
		lib_reg(izq);
		res = der;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tR%d=R%d%sRR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}


struct reg_tipo * logicos(struct reg_tipo* izq, struct reg_tipo* der, enum op_logicos operator){
	snprintf(line,lineSize,"\t// Logico - l:%d\n",numlin);
	gc(line);

	char op[2];
	if (operator == and){
		strncpy(op, "&&",sizeof(op));
	}else if (operator != or){
		strncpy(op, "||",sizeof(op));
	}else{
		yyerror("Error de compilador en lógicos");
	}

	struct reg_tipo* res;
	if (izq->tipo == boolean && der->tipo == boolean){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en lógicos, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}


struct reg_tipo * aritmeticas(struct reg_tipo* izq, struct reg_tipo* der, enum op_aritmeticas operator){
	snprintf(line,lineSize,"\t// Aritmetica - l:%d\n",numlin);
	gc(line);

	char op[1];
	if (operator == sum){
		strncpy(op, "+",sizeof(op));
	}else if (operator == sub){
		strncpy(op, "-",sizeof(op));
	}else if (operator == mul){
		strncpy(op, "*",sizeof(op));
	}else if (operator == divi){
		strncpy(op, "/",sizeof(op));
	}else{
		yyerror("Error de compilador en aritméticas");
	}
	struct reg_tipo* res;
	if (izq->tipo == caracter && der->tipo == caracter ||
			izq->tipo == entero && der->tipo == entero ||
			izq->tipo == entero && der->tipo == caracter ||
			izq->tipo == caracter && der->tipo == entero){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=RR%d%sRR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tRR%d=RR%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=R%d%sRR%d;\n",der->reg,izq->reg,op,der->reg);
		lib_reg(izq);
		res = der;
	}else{
		yyerror("Fallo en aritméticas, asegúrese de que usa tipos correctos");
	}
	gc(line);
	return res;
}

int asignaciones(struct reg_tipo* reg, char* id, enum op_asignaciones operator){
	snprintf(line,lineSize,"\t// Assign %s - l:%d\n",id,numlin);
	gc(line);

	struct nodo *puntero = find(id);

	// Address registry
	int temp = assign_reg(entero);
	struct reg_tipo *address_reg = malloc(sizeof(struct reg_tipo));
	address_reg->reg = temp;
	address_reg->tipo = entero;

	char op[1];
	if (operator == aigual){	// FIXME string
		if (reg->tipo == comaFlotante){
			snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
			gc(line);
			snprintf(line,lineSize,"\tI(R%d)=RR%d;\n", address_reg->reg, reg->reg);
			gc(line);
		}else{
			snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
			gc(line);
			snprintf(line,lineSize,"\tI(R%d)=R%d;\n", address_reg->reg, reg->reg);
			gc(line);
		}
		lib_reg(address_reg);
		lib_reg(reg);

		return 0;
	}else{
		if (operator == asum){
			strncpy(op, "+",sizeof(op));
		}else if (operator == asub){
			strncpy(op, "-",sizeof(op));
		}else if (operator == amul){
			strncpy(op, "*",sizeof(op));
		}else if (operator == adivi){
			strncpy(op, "/",sizeof(op));
		}else{
			yyerror("Error de compilador en aritméticas");
		}
	}

	temp = assign_reg(puntero->tipo);
	struct reg_tipo *val = malloc(sizeof(struct reg_tipo));
	val->reg = temp;
	val->tipo = puntero->tipo;

	if(puntero->tipo == entero && reg->tipo == entero){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=R%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == comaFlotante && reg->tipo == comaFlotante){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tRR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tRR%d=RR%d%sRR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=RR%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == entero && reg->tipo == comaFlotante){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tR%d=R%d%sRR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=R%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == comaFlotante && reg->tipo == entero){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tRR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tRR%d=RR%d%sR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=RR%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else{
		yyerror("Fallo en asignaciones, asegúrese de que usa tipos correctos");
	}

	lib_reg(val);
	lib_reg(address_reg);
	lib_reg(reg);
	return 0;
}
