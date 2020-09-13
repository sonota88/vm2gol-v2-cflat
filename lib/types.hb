// -*- mode: c -*-

typedef int TokenKind;
TokenKind TOKEN_KW    = 1;
TokenKind TOKEN_SYM   = 2;
TokenKind TOKEN_INT   = 3;
TokenKind TOKEN_STR   = 4;
TokenKind TOKEN_IDENT = 5;

struct Token_tag {
  TokenKind kind;
  char[64] str;
};
typedef struct Token_tag Token;

// --------------------------------

typedef int NodeKind;
NodeKind NODE_INT  = 1;
NodeKind NODE_STR  = 2;
NodeKind NODE_LIST = 3;

struct NodeItem_tag {
  NodeKind kind;
  int int_val;
  char[64] str_val;
  struct NodeList_tag* list;
};
typedef struct NodeItem_tag NodeItem;

struct NodeList_tag {
  int len;
  struct NodeItem_tag*[64] items;
};
typedef struct NodeList_tag NodeList;

// --------------------------------

struct Name_tag {
  char[16] str;
  struct Name_tag* next;
};
typedef struct Name_tag Name;

struct Names_tag {
  struct Name_tag* head;
};
typedef struct Names_tag Names;
