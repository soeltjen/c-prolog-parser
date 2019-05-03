

/* * * * * * * * * * * * * * * * * * * * * * * * *
 * This second part of the program is the parser *
 * * * * * * * * * * * * * * * * * * * * * * * * */
DOMAINS
toklist  = string*
program   = program(statementlist)
statementlist = statement*
/* * * * * * * * * * * * * * * * * * * * * * * *
 * Definition of what constitutes a statement  *
 * * * * * * * * * * * * * * * * * * * * * * * */
 
statement = if_then_else(exp,statement,statement);
if_Then(exp,statement);
while(exp,statement);
assign(exp,exp);
declare(exp,exp);
declare_assign(exp,statement).


/* * * * * * * * * * * * * * *
 * Definition of expression  *
 * * * * * * * * * * * * * * */
exp       = plus(exp,exp);
minus(exp,exp);
identifier(id);
int(integer);
type(id).
id        = string

PREDICATES
tokl(string,toklist)

s_program(toklist,program)
s_statement(toklist,toklist,statement)
s_statementlist(toklist,toklist,statementlist)
s_exp(toklist,toklist,exp)
s_exp1(toklist,toklist,exp,exp)
s_exp2(toklist,toklist,exp)

istype(id,exp)

CLAUSES

tokl(Str,[H|T]):-
	fronttoken(Str,H,Str1),!,
	tokl(Str1,T).
tokl(_,[]).


s_program(List1,program(StatementList)):-
	s_statementlist(List1,List2,StatementList),
	List2=[].

s_statementlist([],[],[]):-!.

s_statementlist(List1,List4,[Statement|Program]):-
	s_statement(List1,List2,Statement),
	List2=[";"|List3],
	s_statementlist(List3,List4,Program).

s_statement(["if"|List1],List7,if_then_else(Exp,Statement1,Statement2)):-
	s_exp(List1,List2,Exp),
	List2=["then"|List3],
	s_statement(List3,List4,Statement1),
	List4=["else"|List5],!,
	s_statement(List5,List6,Statement2),
	List6=["fi"|List7].

s_statement(["if"|List1],List5,if_then(Exp,Statement)):-!,
	s_exp(List1,List2,Exp),
	List2=["then"|List3],
	s_statement(List3,List4,Statement),
	List4=["fi"|List5].

s_statement(["do"|List1],List4,while(Exp,Statement)):-!,
	s_statement(List1,List2,Statement),
	List2=["while"|List3],
	s_exp(List3,List4,Exp).

s_statement([ID|List1],List3,declare_assign(Exp1,Statement)):-
	istype(ID,Exp1),
	s_statement(List1, List3,Statement),!.
	%List1=["="|List2],!,
	%s_exp(List2,List3,Exp).
	
s_statement([ID|List1],List3,assign(Exp1,Exp)):-
	s_exp([ID], [], Exp1),
	List1=["="|List2],!,
	s_exp(List2,List3,Exp).

s_statement([ID|List1],List3,declare(Exp1,Exp)):-!,
	istype(ID,Exp1),
	s_exp(List1,List3,Exp).

s_exp(LIST1,List3,Exp):-
	s_exp2(List1,List2,Exp1),
	s_exp1(List2,List3,Exp1,Exp).

s_exp1(["+"|List1],List3,Exp1,Exp):-!,
	s_exp2(List1,List2,Exp2),
	s_exp1(List2,List3, plus(Exp1,Exp2),Exp).

s_exp1(["-"|List1],List3,Exp1,Exp):-!,
	s_exp2(List1,List2,Exp2),
	s_exp1(List2,List3, minus(Exp1,Exp2),Exp).

s_exp1(List,List,Exp,Exp).

s_exp2([Int|Rest],Rest,int(I)):-
	str_int(Int,I),!.

s_exp2([Id|Rest],Rest,identifier(Id)):-
	isname(Id).

istype(Id,type(Id)):-
	Id = "char",!.
istype(Id,type(Id)):-
	Id = "int",!.
istype(Id,type(Id)):-
	Id = "float",!.
GOAL
	%tokl("int max(int ch, int nm); char x; x = ‘a’; int y = 7; int a = 3; if (y < a) { x = ‘b’; } else if (y > a) { x = ‘c’; } else { x = ‘d’; } while (1) { x = ‘e’; }",Ans).
	%tokl("b=2; if b then a=1 else a=2 fi; do a=a-1 while a;",Ans), s_program(Ans,Res).
	%tokl("b=2;",Ans), s_program(Ans,Res).
	tokl("int b; a=2; char c = 5;",Ans), s_program(Ans,Res).
