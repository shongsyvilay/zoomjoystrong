/*****************************************************************
Language Creator

@author Stacey Hongsyvilay
@version Winter 2020
*****************************************************************/

%{
	#include <stdio.h>
	#include "zoomjoystrong.h"
	#include <SDL2/SDL.h>
	void yyerror(const char* msg);
	void setColor(int r, int g, int b);
	void pointCheck(int x, int y);
	void lineCheck(int x1, int y1, int x2, int y2);
	void rectangleCheck(int x, int y, int w, int h);
	void circleCheck(int x, int y, int r);
	void invalidInput(char* statement);
	int yylex();
	
%}



%define parse.error verbose
%start plots

%union { int i; float f; char* str; }

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT
%token YOUMESSEDUP

%type<i> INT
%type<f> FLOAT
%type<str> YOUMESSEDUP

%%
plots: 			statement
			| 	plots statement
;

statement:		point
			|	end
			|	circle
			|	rectangle
			|	set_color
			|	line
			|	youmessedup
;

point:			POINT INT INT END_STATEMENT				{ pointCheck($2, $3); }
;

line:			LINE INT INT INT INT END_STATEMENT		{ lineCheck($2, $3, $4, $5); }
;

circle:			CIRCLE INT INT INT END_STATEMENT		{ circle($2, $3, $4); }
;

rectangle:		RECTANGLE INT INT INT INT END_STATEMENT	{ rectangleCheck($2, $3, $4, $5); }
;

set_color:		SET_COLOR INT INT INT END_STATEMENT		{ setColor($2, $3, $4); }
;

youmessedup:	YOUMESSEDUP								{ invalidInput($1); }
;

end:			END										{ finish(); return 0; }

%%

int main(int argc, char** argv) {
	setup();
	yyparse();
}

void yyerror(const char* msg) {
	fprintf(stderr, "ERROR! %s\n", msg);
}

/** checking that the colors do not go paste the acceptable range **/
void setColor(int r, int g, int b){
	if(r > 255 || g > 255 || b > 255) {
		printf("One of the set color inputs is incorrect. Please fix.\n");
		exit(EXIT_FAILURE);
	}
	else {
		set_color(r, g, b);
	}
}

/** checking that the point values do not go past the canvas **/
void pointCheck(int x, int y ) {
	if(0 > x || x > 1024 || 0 > y || y > 768) {
		printf("One of your points are out of bounds.");
		exit(EXIT_FAILURE);
	}
	else {
		point(x, y);
	}
}

/** checking that the line values do not go beyond the canvas **/
void lineCheck(int x1, int y1, int x2, int y2 ) {
	if(0 > x1 || x1 > 1024 || 0 > x2 || x2 > 1024 || 0 > y1 || y1 > 768 || 0 > y2 || y2 > 768 ) {
		printf("One of your lines are out of bounds.");
		exit(EXIT_FAILURE);
	}
	else {
		line(x1, y1, x2, y2);
	}
}

/** checking that the rectangle values do not go beyond the canvas **/
void rectangleCheck(int x, int y, int w, int h) {
	if(0 > x || x > 1024 || x + w > 1024 || 0 > y || y > 768 || y + h > 768) {
		printf("Your rectangle is going out of bounds. Please fix.");
		exit(EXIT_FAILURE);
	}
	else {
		rectangle(x, y, w, h);
	}
}

/** checking that the circle values do not go beyond the canvas **/
void circleCheck(int x, int y, int r) {
	if(0 > x || x > 1024 || x + r > 1024 || 0 > y || y > 768 || y + r > 768) {
		printf("Your circle is out of bounds. Put it somewhere on canvas.");
		exit(EXIT_FAILURE);
	}
	else {
		circle(x, y, r);
	}
}

/** if a statement has an error then it will get printed out to notify the user**/
void invalidInput(char* statement) {
	printf("You had an incorrect statement.\n");
	for (int i = 0; i < strlen(statement); i++){ 
		printf("%c", statement[i]);
	}
	printf("\n");
}

