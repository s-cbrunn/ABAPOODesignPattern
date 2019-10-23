*&---------------------------------------------------------------------*
*& Report z_pattern_observer
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_pattern_observer.

" Hint: it's the simple way of observer pattern

INTERFACE lif_observer.

  METHODS update IMPORTING iv_temp TYPE i
                           iv_wet  TYPE i
                           iv_air  TYPE i.

ENDINTERFACE.

INTERFACE lif_subject.

  METHODS attach IMPORTING io_observer TYPE REF TO lif_observer.
  METHODS detach IMPORTING io_observer TYPE REF TO lif_observer.
  METHODS notify.

ENDINTERFACE.




CLASS lcl_weather_data DEFINITION.

  PUBLIC SECTION.
    INTERFACES lif_subject.

    METHODS: set_values IMPORTING iv_temp TYPE i
                                  iv_wet  TYPE i
                                  iv_air  TYPE i.

  PRIVATE SECTION.
    METHODS: set_changed.

    DATA mt_observer TYPE TABLE OF REF TO lif_observer.
    DATA mv_temperature TYPE i.
    DATA mv_wetness TYPE i.
    DATA mv_air_pressure TYPE i.

ENDCLASS.

CLASS lcl_weather_data IMPLEMENTATION.

  METHOD lif_subject~attach.
    APPEND io_observer TO mt_observer.
  ENDMETHOD.

  METHOD lif_subject~detach.
    DELETE mt_observer WHERE table_line = io_observer.
  ENDMETHOD.

  METHOD lif_subject~notify.

    LOOP AT mt_observer ASSIGNING FIELD-SYMBOL(<lo_observer>).
      <lo_observer>->update( iv_temp = mv_temperature iv_wet = mv_wetness iv_air = mv_air_pressure ).
    ENDLOOP.

  ENDMETHOD.

  METHOD set_changed.
    me->lif_subject~notify( ).
  ENDMETHOD.

  METHOD set_values.
    mv_temperature = iv_temp.
    mv_wetness = iv_wet.
    mv_air_pressure = iv_air.

    me->set_changed( ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_observer_for_temp_wet DEFINITION.

  PUBLIC SECTION.
    INTERFACES
      lif_observer.

    METHODS constructor IMPORTING io_subject TYPE REF TO lif_subject.
    METHODS show_data.

  PRIVATE SECTION.
    DATA mv_temperature TYPE i.
    DATA mv_wetness TYPE i.
    DATA mo_subject TYPE REF TO lif_subject.

ENDCLASS.

CLASS lcl_observer_for_temp_wet IMPLEMENTATION.

  METHOD constructor.
    mo_subject = io_subject.
    mo_subject->attach( io_observer = me ).
  ENDMETHOD.

  METHOD show_data.
    WRITE:/ | Temperature: { mv_temperature } °C, Wetness: { mv_wetness }|.
  ENDMETHOD.

  METHOD lif_observer~update.
    mv_temperature = iv_temp.
    mv_wetness = iv_wet.


    me->show_data( ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_observer_for_temp_air DEFINITION.

  PUBLIC SECTION.
    INTERFACES
      lif_observer.

    METHODS constructor IMPORTING io_subject TYPE REF TO lif_subject.
    METHODS show_data.

  PRIVATE SECTION.
    DATA mv_temperature TYPE i.
    DATA mv_air_pressure TYPE i.
    DATA mo_subject TYPE REF TO lif_subject.

ENDCLASS.

CLASS lcl_observer_for_temp_air IMPLEMENTATION.

  METHOD constructor.
    mo_subject = io_subject.
    mo_subject->attach( io_observer = me ).
  ENDMETHOD.

  METHOD show_data.
    WRITE:/ | Temperature: { mv_temperature } °C, Air Pressure: { mv_air_pressure }|.
  ENDMETHOD.

  METHOD lif_observer~update.
    mv_temperature = iv_temp.
    mv_air_pressure = iv_air.

    me->show_data( ).
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.

  " create subject(s)
  DATA(lo_weather_data) = NEW lcl_weather_data( ).

  " create observers
  DATA(lo_first_observer) = NEW lcl_observer_for_temp_air( io_subject = lo_weather_data ).
  DATA(lo_second_observer) = NEW lcl_observer_for_temp_wet( io_subject = lo_weather_data ).

  " subject send some informations
  lo_weather_data->set_values( iv_temp = 20 iv_wet = 50 iv_air  = 30 ).
  write:/ '---'.
  lo_weather_data->set_values( iv_temp = 12 iv_wet = 70 iv_air  = 24 ).
