Title Calculadora_Lisbeth(EXE)
;-----------------------

STACKS SEGMENT STACK
    ;----TAMANO DE MEMORIA QUE UTILIZARA
    DB 32 DUP(0)
STACKS ENDS
;-----------------------SECCION DATOS
DATASG SEGMENT PARA 'DATA' ;se declaran las variables utilizadas en el programa y los mensajes 
    NUM1 DB ?
    NUM2 DB ?
    RESULTADO DB ?
MENU DB 13,10,"------ CALCULADORA ------ " ,13,10
     DB 13,10," Que operacion matemetica vas a realizar?",13,10
     DB 13,10,"1. SUMA"
     DB 13,10,"2. RESTA"
     DB 13,10,"3. DIVISION"
     DB 13,10,"4. MULTIPLICACIÓN"
     DB 13,10,"5. Salir"
     DB 13,10,"-> RS $"
     ;------------------MENU 

     MENSJE1 DB 13,10," Ingrese el primer numero: $"
     MENSAJE2 DB 13,10," Ingrese el segundo numero: $"
     MENSAJEr DB 13,10," El resultado de la operacion es:" ,13,10
     MENSAJEcont DB 13,10,"Presione cualquier tecla para continuar...",13,10
     MENSJEsal DB 13,10 , " <<< Saliendo >>>",13,10
; -----------
    ; SUM DB 13,10, "*** SE REALIZARA UNA SUMA ***",13,10
     ;REST DB 13,10,"*** SE RESALIZARA UNA RESTA***",13,10
     ;DIVC DB 13,10,"*** SE REALIZARA UNA DIVISION ***",13,10
     ;MULT DB 13,10,"** SE REALIzARA UNA MULTIPLICACION"

     
DATASG ENDS
;--------------------------------
CODESG SEGMENT PARA 'CODE'

START PROC FAR
ASSUME SS:STACKS, DS:DATASG, CS:CODESG ;INFORMACION 

MOV AX,DATASG
MOV DS,AX

;MUESTRA EL MENU 

OMENU PROC ;el menú principal y permite al usuario seleccionar una operación matemática. 
    ;LLAMA EL METODO CLEAR PARA LIMPIAR PANTALLA
    CALL CLEAR
    ;MUESTRA EL MENU
    LEA DX,MENU
    MOV AH,09
    INT 21H
    ;CAPTURAR OPCION
    MOV AH,1
    INT 21H

    ;CONDICIONES PARA CAPTURAR LA OPCION
    CMP AL,"1"
    ;LLAMA METODO SUMA
    JE SUMA

    ;CONDICIONES PARA CAPTURAR LA OPCION
    CMP AL,"2"
    ;LLAMA METODO RESTA
    JE RESTA

    ;CONDICIONES PARA CAPTURAR LA OPCION
    CMP AL,"4"
    ;LLAMA METODO MULTIPLICACION
    JE MULTIPLICACION

 ;CONDICIONES PARA CAPTURAR LA OPCION
    CMP AL,"3"
    ;LLAMA METODO DIVISION
    JE DIVISION


    ;LLAMA METODO SALIR
    CMP AL,"5"
    JE SALIR



OMENU ENDP

;+++++++ METODO SUMA +++++++;
SUMA PROC
    ;LIMPIAR PANTALLA
    CALL CLEAR
    
    ;LLAMA METOD DE DATOS 
    CALL DATOS
    ;--- sE REALIZA LA SUMA ---
    ; Los valores de NUM1 y NUM2 se cargan en el registro AL y luego se utiliza la instrucción ADD para sumarlos.
    MOV AL,NUM1
    ADD AL,NUM2
    ;GUARDAR RESULTADO
    MOV RESULTADO,AL
    ;MUESTRA RESULATDO 
    LEA DX,MENSAJEr
    MOV AH,09
    INT 21H
    CALL IMPRIMIR 
    CALL STOP
    ;VOLVER AL MENU
    JMP OMENU

SUMA ENDP

;_____ METODO RSTA _______
RESTA PROC
     ;LIMPIAR PANTALLA
    CALL CLEAR
   
       ;LLAMA METOD DE DATOS 
    CALL DATOS
    ;--- sE REALIZA LA RESTA ---
    ;Los valores de NUM1 y NUM2 se cargan en el registro AL y luego se utiliza la instrucción SUB para restar NUM2 a NUM1.
    MOV AL,NUM1
    SUB AL,NUM2
    ;GUARDAR RESULTADO
    MOV RESULTADO,AL
    ;MUESTRA RESULATDO 
    LEA DX,MENSAJEr
    MOV AH,09
    INT 21H
    ;IMPRIMIR RESULTADO
    CALL IMPRIMIR 
    CALL STOP
    ;VOLVER AL MENU
    JMP OMENU
RESTA ENDP

;XXXX METODO DE MULTIPLICACION XXXX;
MULTIPLICACION PROC
     ;LIMPIAR PANTALLA
    CALL CLEAR
   
       ;LLAMA METOD DE DATOS 
    CALL DATOS
    ;--- sE REALIZA LA MULTIPLICACION ---
    ;NUM1 se carga en el registro AL y el valor de NUM2 se carga en el registro BL. Luego, 
    ;se utiliza la instrucción MUL para realizar la multiplicación de BL y AL. 
    ;El resultado se almacena en los registros AX
    MOV AL,NUM1
    MOV BL,NUM2
    ;REALIZAR MULT
    MUL BL ;mult bl*al 

    ;GUARDAR RESULTADO
    MOV RESULTADO,AL
    ;MUESTRA RESULATDO 
    LEA DX,MENSAJEr
    MOV AH,09
    INT 21H
    CALL IMPRIMIR 
    CALL STOP
    ;VOLVER AL MENU
    JMP OMENU
MULTIPLICACION ENDP
;//// METODO DE DIVISION ///;
DIVISION PROC
     ;LIMPIAR PANTALLA
    CALL CLEAR
    
       ;LLAMA METOD DE DATOS 
    CALL DATOS
    ;LIMPIRAR REGISTRO 
    XOR AX,AX ;limpis el registro de ax
    ;--- sE REALIZA LA DIVISION ---
    ;
    MOV AL,NUM1
    MOV AL,NUM2
    ;NUM1 se carga en el registro AL y luego se sobrescribe con el valor de NUM2. 
    ;Luego, se utiliza la instrucción DIV para realizar la operación de división entre el valor en AX 
    ;(concatenación de AH y AL) y el valor en BL. 
    ;El resultado de la división se almacena en el registro AL y el residuo en el registro AH.
    ;DIV, REALIZA LA OPERACION DE DIVISION
    DIV BL
    ;GUARDAR RESULTADO
    MOV RESULTADO,AL
    ;MUESTRA RESULATDO 
    LEA DX,MENSAJEr
    MOV AH,09
    INT 21H
    CALL IMPRIMIR 
    CALL STOP
    ;VOLVER AL MENU
    JMP OMENU
    
DIVISION ENDP
    ;-------mETODO DE IMPRIMIR
    IMPRIMIR PROC
    ;RESULTADO DE LA OPERACION QUE LLAMO EL METODO
    MOV AL, RESULTADO
    ;DESEMPAQUETAR PARA QUE EL PROGRAMA MUESTRE 2 NUMEROS
    AAM

    ;DESPLEGAR PRIMER DIGITO
    MOV BX,AX
    MOV AH, 2
    MOV DL, BH
    ADD DL, 30H
    MOV BH, 0CH   ; Cambiar el atributo de color a rojo
    INT 21H

    ;DESPLEGAR SEGUNDO DIGITO
    MOV AH,2
    MOV DL, BL
    ADD DL, 30H
    MOV BH, 0CH   ; Cambiar el atributo de color a rojo
    INT 21H

    ;---RETORNAR AL METODO DE LLAMADO
    RET
IMPRIMIR ENDP

    ;-------METODO DE LOS DATOS-----;
    DATOS PROC
       
        ;---- SOLICITAR EL PIRMER NUMERO ----
        LEA DX,MENSJE1
        MOV AH,09
        INT 21H
        ;CAPTURAR NUMERO
        MOV AH,01H
        INT 21H
        ;CONVERTIR A DECIMAL Y GUARDAR 
        SUB AL,30H
        MOV NUM1,AL


        ;----- SOLICITAR SEGUNDO NUMERO ----
        LEA DX,MENSAJE2
        MOV AH,09
        INT 21H
        ;CAPTURAR NUMERO
        MOV AH,01H
        INT 21H
        ;CONVERTIR A DECIMAL Y GUARDAR 
        SUB AL,30H
        MOV NUM2,AL

        ;RETORNAR AL LLAMADO
        RET

        
    DATOS ENDP

;-----LIPMIAR PANTALLA-------;
CLEAR PROC
    MOV AH, 06H  ; Función de scroll
    XOR AL, AL   ; Llena la pantalla con espacios en blanco
    XOR CX, CX   ; Coordenadas superiores izquierdas (0,0)
    MOV DH, 24   ; Coordenada inferior derecha (24,79)
    MOV DL, 79
    MOV BH, 07H  ; Atributo de color (predeterminado)
    INT 10H      ; Realiza la interrupción
    RET
CLEAR ENDP


 ;---------PAUSAR EL PROGRAMA-----;
STOP PROC
    MOV AH, 09H
    LEA DX, MENSAJEcont
    INT 21H

    MOV AH, 01H
    INT 21H

    RET
STOP ENDP

;********* METODO SALIR *********;
SALIR PROC
    LEA DX,MENSJEsal
    MOV AH,09
    INT 21H
    ;RETORNAR 0 PARA CERRA PROGRAMA
    MOV AH,4CH
    INT 21H 

SALIR ENDP


START ENDP
CODESG ENDS
END START
