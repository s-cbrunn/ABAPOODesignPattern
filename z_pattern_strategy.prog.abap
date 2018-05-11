*&---------------------------------------------------------------------*
*& Report z_pattern_strategy
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_pattern_strategy.


" Behavior interfaces for fly and quack
INTERFACE lif_fly_behavior.
  METHODS fly.
ENDINTERFACE.

INTERFACE lif_quack_behavior.
  METHODS quack.
ENDINTERFACE.


" Two behavior for fly
CLASS lcl_fly DEFINITION.

  PUBLIC SECTION.
    INTERFACES lif_fly_behavior.

ENDCLASS.

CLASS lcl_fly IMPLEMENTATION.

  METHOD lif_fly_behavior~fly.
    WRITE:/ 'I can fly...'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_no_fly DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_fly_behavior.

ENDCLASS.

CLASS lcl_no_fly IMPLEMENTATION.

  METHOD lif_fly_behavior~fly.
    WRITE:/ 'I can´t fly'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_no_quack DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_quack_behavior.
ENDCLASS.

CLASS lcl_no_quack IMPLEMENTATION.

  METHOD lif_quack_behavior~quack.
    WRITE:/ 'no quack'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_quack DEFINITION.

  PUBLIC SECTION.
    INTERFACES: lif_quack_behavior.

ENDCLASS.

CLASS lcl_quack IMPLEMENTATION.

  METHOD lif_quack_behavior~quack.
    WRITE:/ 'quack, quack...'.
  ENDMETHOD.

ENDCLASS.

" Abstract class for duck
CLASS lcl_duck DEFINITION ABSTRACT.

  PUBLIC SECTION.
    METHODS constructor.
    METHODS do_quack.
    METHODS do_fly.
    METHODS do_show ABSTRACT.
    METHODS set_fly_behavior IMPORTING io_fly TYPE REF TO lif_fly_behavior.
    METHODS set_quack_behavior IMPORTING io_quack TYPE REF TO lif_quack_behavior.

  PROTECTED SECTION.
    DATA mo_quack TYPE REF TO lif_quack_behavior.
    DATA mo_fly TYPE REF TO lif_fly_behavior.

ENDCLASS.


CLASS lcl_duck IMPLEMENTATION.

  METHOD constructor.
    mo_fly = NEW lcl_no_fly( ).
    mo_quack = NEW lcl_no_quack(  ).
  ENDMETHOD.

  METHOD do_quack.
    mo_quack->quack( ).
  ENDMETHOD.

  METHOD do_fly.
    mo_fly->fly( ).
  ENDMETHOD.


  METHOD set_fly_behavior.
    mo_fly = io_fly.
  ENDMETHOD.

  METHOD set_quack_behavior.
    mo_quack = io_quack.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_mallard DEFINITION INHERITING FROM lcl_duck.
  PUBLIC SECTION.
    METHODS: do_show REDEFINITION.

ENDCLASS.

CLASS lcl_mallard IMPLEMENTATION.

  METHOD do_show.
    WRITE:/ 'I am a mallard'.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_mallard) = NEW lcl_mallard( ).

  lo_mallard->do_fly( ).
  lo_mallard->do_quack( ).

  " change strategy
  WRITE:/.
  WRITE:/ 'new strategy'.
  WRITE:/.

  lo_mallard->set_fly_behavior( NEW lcl_fly(  ) ).
  lo_mallard->set_quack_behavior( NEW lcl_quack( ) ).

  lo_mallard->do_fly( ).
  lo_mallard->do_quack( ).
