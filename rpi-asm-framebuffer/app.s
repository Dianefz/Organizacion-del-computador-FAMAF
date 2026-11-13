    .equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32
	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34
    

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz w10, 0x05, lsl 16
	movk w10, 0x0517, lsl 0

    mov x3, 143
	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
    subs x9, x2, x3
    b.gt loop1
	movz w10, 0x00, lsl 16
	movk w10, 0x8000, lsl 00 
	cbnz x2,loop1  // Si no es la última fila, salto

    mov x1, 208 // Base de la casa
	mov x2, 153
	mov x3, 552
	mov x4, 360	
	movz w15, 0x807E, lsl 00
	movz w16, 0x9f9c, lsl 00
	bl rectanguloCasa

///////////////////	TECHOS ///////////////////////////////////////////////////////////	
	mov x1, 131 //Barra blanca de abajo
	mov x2, 305
	mov x3, 630
	mov x4, 312
	movz w10, 0xa0, lsl 16
	movk w10, 0x9F9F, lsl 0
	bl cuadradoVariable
	
	
	mov x1, 209  //Dos triangulos del primer piso
	mov x2, 225
	mov x5, 79
    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
	bl triangleMaker
	mov x1, 552
	mov x2, 225
    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
	bl triangleMaker

    mov x1, 209 // Primer techo
	mov x2, 225
	mov x3, 552
	mov x4, 305
	bl cuadradoVariable


///////////////////////////////////////////////////////////////

    mov x1, 187 //Barra blanca de arriba
	mov x2, 145
	mov x3, 574
	mov x4, 153
	movz w10, 0xa0, lsl 16
	movk w10, 0x9F9F, lsl 0
	bl cuadradoVariable
	
	
	mov x1, 233  //Dos triangulos del segundo piso
	mov x2, 97
	mov x5, 47
    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
	bl triangleMaker
	mov x1, 528
	mov x2, 97
    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
	bl triangleMaker

    mov x1, 233 // Segundo techo
	mov x2, 97
	mov x3, 528
	mov x4, 145
	bl cuadradoVariable

    mov x1, 353 //atico
	mov x2, 49
	mov x3, 424
	mov x4, 105
	bl rectanguloCasa

	mov x1, 389  //techo atico triangulo
	mov x2, 8
	mov x5, 47
    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
	bl triangleMaker


/////////////////////// VENTANAS ////////////////////////////////////////////
	movz w10, 0xCF, lsl 16
	movk w10, 0xCFCF, lsl 00
    
	mov x1, 401 //Grande 1
	mov x2, 152
    mov x3, 536
	mov x4, 225
	bl cuadradoVariable
	add x1, x1, 8
	add x2, x2, 8
	sub x3, x3, 8
	add x4, x4, 8
	bl cuadradoVariable
    add x1, x1, 8
	add x2, x2, 8
	sub x3, x3, 8
	add x4, x4, 8
	bl cuadradoVariable


	//////////// planta baja
	// izquierda
	mov x1, 225
	mov x2, 312
	mov x3, 376
	mov x4, 353
    bl cuadradoVariable
	// derecha
	mov x1, 497
	mov x2, 312
	mov x3, 538
	mov x4, 352
	bl cuadradoVariable

    ///ventana izquierda
	mov x1, 225
	mov x2, 152
	mov x3, 264
	mov x4, 200
	bl cuadradoVariable

	///ventana centro
	mov x1, 305
	mov x2, 152
	mov x3, 336
	mov x4, 184
	bl cuadradoVariable
    
	///ventana atico
	mov x1, 377
	mov x2, 57
	mov x3, 400
	mov x4, 96
	bl cuadradoVariable

	mov x1, 361
	mov x3, 368
	bl cuadradoVariable

	mov x1, 409
	mov x3, 416
	bl cuadradoVariable

    //chimenea
	movz w10, 0xb0, lsl 16
	movk w10, 0x8f6c, lsl 0
	mov x1, 257 
	mov x2, 48
	mov x3, 283
	mov x4, 97
	bl cuadradoVariable
	mov x1, 249 
	mov x2, 41
	mov x3, 291
	mov x4, 48
	bl cuadradoVariable


// PORCHE ///////////////////////////////////////////////////////////////////////////

    movz w10, 0xFF, lsl 16
	movk w10, 0xFFFF, lsl 0
	///////// pilares////////////
    mov x1, 145
	mov x2, 338
	mov x3, 168
	mov x4, 393
    bl cuadradoVariable
	add x1, x1, 8
	add x3, x1, 8
	mov x2, 312
	mov x4, 338
	bl cuadradoVariable
   
    mov x1, 385
	mov x2, 338
	mov x3, 408
	mov x4, 368
    bl cuadradoVariable
	add x1, x1, 8
	add x3, x1, 8
	mov x2, 312
	mov x4, 338
	bl cuadradoVariable

    mov x1, 465
	mov x2, 338
	mov x3, 488
	mov x4, 368
    bl cuadradoVariable
	add x1, x1, 8
	add x3, x1, 8
	mov x2, 312
	mov x4, 338
	bl cuadradoVariable

	mov x1, 593
	mov x2, 338
	mov x3, 616
	mov x4, 465
    bl cuadradoVariable
	add x1, x1, 8
	add x3, x1, 8
	mov x2, 312
	mov x4, 338
	bl cuadradoVariable

	/////////////////////////// Puerta///////////////////////////
	mov x1, 425
	mov x2, 314
	mov x3, 448
	mov x4, 361
	bl cuadradoVariable

	////////////////////////// Baranda////////////////////////////
    mov x1, 168
	mov x2, 338
	mov x3, 385
	add x4, x2, 6
	movz w10, 0x1C, lsl 16
    movk w10, 0x1B19, lsl 00
	bl cuadradoVariable
	add x2, x2, 12
	add x4, x4, 12
	bl cuadradoVariable
	add x2, x2, 12
	add x4, x4, 12
	bl cuadradoVariable

	mov x1, 488
	mov x2, 338
	mov x3, 593
	add x4, x2, 6
	movz w10, 0x1C, lsl 16
    movk w10, 0x1B19, lsl 00
	bl cuadradoVariable
	add x2, x2, 12
	add x4, x4, 12
	bl cuadradoVariable
	add x2, x2, 12
	add x4, x4, 12
	bl cuadradoVariable

    ///////////////////////////// Pared////////////////
	movz w10, 0xb0, lsl 16
	movk w10, 0x8f6c, lsl 0

	mov x1, 168
	mov x2, 368
	mov x3, 385
	mov x4, 393
	bl cuadradoVariable
	
	mov x1, 489 // pared cochera
	mov x2, 368
	mov x3, 593
	mov x4, 465
	bl cuadradoVariable
	


    ///Porton
	movz w15, 0xFf, lsl 16
	movk w15, 0xFfFf, lsl 0

	movz w16, 0xCF, lsl 16
	movk w16, 0xCFCF, lsl 00

	mov x1, 513
	mov x2, 393
	mov x3, 584
	mov x4, 464
	bl rectanguloCasa

    movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0

	mov x1, 545
	mov x2, 457
	mov x3, 552
	mov x4, 465
	bl cuadradoVariable



    //Escalera baranda
	movz w10, 0x7f, lsl 16
	movk w10, 0x7f7f, lsl 0

	mov x1, 353 
	mov x2, 401
	mov x3, 521
	mov x4, 465
	mov x9, 5
	bl cuadradoVariable
escaleraLoop:
    add x4, x2, xzr
	sub x2, x2, 8
	add x1, x1, 8
	sub x3, x3, 8
	bl cuadradoVariable
	sub x9, x9, 1
	cbnz x9, escaleraLoop

	//Escalones
	movz w10, 0xaf, lsl 16
	movk w10, 0xafaf, lsl 0

	mov x1, 361 
	mov x2, 449
	mov x3, 512
	mov x4, 465
	mov x9, 5
	bl cuadradoVariable
escalonesLoop:
    add x4, x2, xzr
	sub x2, x2, 16
	add x1, x1, 8
	sub x3, x3, 8
	bl cuadradoVariable
	sub x9, x9, 1
	cbnz x9, escalonesLoop
	add x4, x2, xzr
	sub x2, x2, 8
	add x1, x1, 8
	sub x3, x3, 8
	bl cuadradoVariable


	

	////////PREDIO///////////////////////////
    //// sendero 
	movz w10, 0x8f, lsl 16
	movk w10, 0x8f8f, lsl 0

	mov x1, 1        
	mov x2, 337
	mov x3, 32
	mov x4, 480
	bl cuadradoVariable      
	mov x2, 457
	mov x3, 160
	bl cuadradoVariable
	mov x2, 441
	mov x3, 48
	bl cuadradoVariable
	mov x2, 465
	mov x3, 640
	bl cuadradoVariable
	




	////farol
	movz w10, 0x1f, lsl 16
	movk w10, 0x1f1f, lsl 0
    
    mov x1, 33       //base
	mov x2, 473
	mov x3, 72
	mov x4, 480
	bl cuadradoVariable
	add x1, x1, 8
	sub x3, x3, 8
	mov x4, x2
	sub x2 , x2, 8
	bl cuadradoVariable
	mov x1, 49       //poste
	mov x2, 329
	mov x3, 56
	mov x4, 465
	bl cuadradoVariable
	mov x1, 33      //punta
	mov x2, 345
	mov x3, 40
	mov x4, 360
	bl cuadradoVariable
	add x1,x1,32
	add x3,x3,32
	bl cuadradoVariable
	mov x1, 41      
	mov x2, 337
	mov x3, 64
	mov x4, 344
	bl cuadradoVariable
	add x2,x2,24
	add x4,x4,24
	bl cuadradoVariable

/// tronco 
    movz w10, 0x3e, lsl 16
	movk w10, 0x100, lsl 0

    mov x1, 89
	mov x2, 288
	mov x3, 112
	mov x4, 344
	bl cuadradoVariable

    movz w10,0x00, lsl 16
	movk w10, 0x5f02, lsl 0

	mov x1, 100  
	mov x2, 276
	mov x5, 40
	bl triangleMaker
	mov x2, 266
	mov x5, 30
	bl triangleMaker
	mov x2, 258
	mov x5, 20
	bl triangleMaker




	// Ejemplo de uso de gpios
	mov w6, 1
InfLoop:
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w7, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// 000000000000000000010
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	and w13, w7, 0b00010
    lsr w13, w13, 1
	subs w5, w13, w6
    beq InfLoop
	mov w6, w13
	bl pintarVentanas
	bl pintarCielo

	//---------------------------------------------------------------
	// Infinite Loop

	b InfLoop


fb_set:
    sub sp,sp,8
    stur x9, [sp,0]
	
	mov x9, 640
	mul x9, x9, x2
	add x9, x9, x1
	lsl x9, x9, 2
	add x0, x20, x9

    ldur x9, [sp,0]
	add sp,sp,8
	ret



lineDrawer:
    sub sp, sp, 32
	stur x0, [sp,24]
	stur x13, [sp,16]
	stur x4, [sp,8]
	stur x3, [sp,0]

    and x13, x9, 0b10 // solo deja en pie la bandera 2
	cbnz x13, setVertical
	mov x4, 4
	b continue
setVertical:
    mov x4, 2560
continue:
    stur w10,[x0]
	add x0, x0, x4
	sub x3, x3, 1
	cbnz x3, continue

    ldur x0, [sp,24]
	ldur x13,[sp,16]
	ldur x4,[sp,8]
	ldur x3, [sp,0]
	add sp,sp,32

	ret



triangleMaker:
    sub sp, sp, 64
	stur x1, [sp,0]
	stur x2, [sp,8]
	stur x3, [sp,16]
	stur x4, [sp,24]
	stur x5, [sp,56]
	stur lr, [sp,32]
	stur x12, [sp,40]
	stur x11, [sp,48]

	bl fb_set
    mov x4, xzr
    mov x12, 2556 
triangleStart:
    mov x3, x4
	lsl x3, x3, 1
	add x3, x3, 1
	add x0, x0, x12
	bl lineDrawer
    add x4, x4, 1
	sub x5, x5, 1
	cbnz x5, triangleStart

	ldur x1, [sp,0]
	ldur x2, [sp,8]
	ldur x3, [sp,16]
	ldur x4, [sp,24]
	ldur x5, [sp,56]
	ldur lr, [sp,32]
	ldur x12, [sp,40]
	ldur x11, [sp,48]
	add sp, sp, 64
	br lr


      
// DIBUJAR UN RECTANGULO /////////////////////////////////////////////////////////////
// x1, x2: x, y iniciales
// x3, x4: x, y finales
//VARIABLES x9: contador linea
cuadradoVariable: 
    sub sp, sp, 24
	stur lr, [sp,16]
	stur x0, [sp,8]
	stur x9, [sp,0]
	bl fb_set
	sub x9, x4, x2
comienzoCuadrado:
	bl lineaVariableRapida
    add x0, x0, 2560
	sub x9, x9, 1
	cbnz x9, comienzoCuadrado
	ldur lr, [sp,16]
	ldur x0, [sp,8]
	ldur x9, [sp,0]
	add sp, sp, 24
	ret


	// LINEA VARIABLE RÁPIDA  HORIZONTAL ------------------------------------------------
// x1: x inicial, x3: x final.
// x0 FRAMEBUFFER ACTUALIZADO
lineaVariableRapida: 
    sub sp, sp, 16
	stur x0, [sp,8]
	stur x9, [sp,0]
    sub x9, x3, x1
comienzoR:
	stur w10, [x0]
	add x0, x0, 4
	sub x9, x9, 1
	cbnz x9, comienzoR
    ldur x9, [sp,0]
	ldur x0, [sp,8]
	add sp, sp, 16
	ret



// LINEA VARIABLE RÁPIDA  VERTICAL ------------------------------------------------
// x2: x inicial, x3: x final.
// x0 FRAMEBUFFER ACTUALIZADO
lineaVariableRapidaVertical: 
    sub sp, sp, 16
	stur x0, [sp,8]
	stur x9, [sp,0]
    sub x9, x4, x2
comienzoRV:
	stur w10, [x0]
	add x0, x0, 2560
	sub x9, x9, 1
	cbnz x9, comienzoRV
    ldur x9, [sp,0]
	ldur x0, [sp,8]
	add sp, sp, 16
	ret


// RECTANGULO CASA -------------------------------------------------------------
// x1, x2 : x y iniciales
// x3, x4 : x y finales
rectanguloCasa:
	sub sp, sp, 64
	stur x0, [sp,0]
	stur x2, [sp,8]
	stur lr, [sp,16]
	stur x4, [sp,24]
	stur x9, [sp,32]
	stur w11, [sp,40]
	stur w12, [sp,48]
	stur x14, [sp,56]
	

    mov x9, x4
	mov w10, w15
	mov w12, w10
casaLoop:    
	add x4, x2, 8
	bl fb_set
	bl cuadradoVariable
	add x2, x4, xzr
    sub w11, w10, w12
	cbz w11, segundoColor
// primer color
    mov w10, w15
	b continuar
segundoColor:
    mov w10, w16
continuar:
    subs x14, x9, x4
	b.gt casaLoop

	ldur x0, [sp,0]
	ldur x2, [sp,8]
    ldur lr, [sp,16]
	ldur x4, [sp,24]
	ldur x9, [sp,32]
	ldur w11, [sp,40]
	ldur w12, [sp,48]
	ldur x14, [sp,56]
	add sp, sp, 64
	br lr
	
pintarVentanas:
    sub sp, sp, 8
	stur lr, [sp,0]
	
    cbnz w13, filtroNoche 
    movz w10, 0xaf, lsl 16
	movk w10, 0xafaf, lsl 0
	b pintar
filtroNoche:	
    movz w10, 0xe3, lsl 16
	movk w10, 0xd626, lsl 0
	b pintar

pintar:	
    mov x1, 385   //ventana atico  
	mov x2, 65
	mov x3, 392
	mov x4, 72
	bl cuadradoVariable
	mov x1, 361   
	mov x3, 368
	bl cuadradoVariable
	mov x1, 409  
	mov x3, 416
	bl cuadradoVariable
	mov x1, 385   
	mov x2, 81
	mov x3, 392
	mov x4, 96
	bl cuadradoVariable
	mov x1, 361    
	mov x3, 368
	bl cuadradoVariable
	mov x1, 409    
	mov x3, 416
	bl cuadradoVariable

    mov x1, 233    //ventana arriba izquierda   
	mov x2, 177
	mov x3, 256
	mov x4, 192
	bl cuadradoVariable
	mov x2, 161
	mov x3, 240
	mov x4, 168
	bl cuadradoVariable
	mov x1, 249      
	mov x3, 256
	bl cuadradoVariable
	mov x1, 313   //ventana baño   
	mov x2, 161
	mov x3, 328
	mov x4, 176
	bl cuadradoVariable
	mov x1, 433     //ventanal grande
	mov x2, 169
	mov x3, 504
	mov x4, 232
	bl cuadradoVariable
	mov x1, 409    /// ventanal, vidrios superiores
	mov x2, 153
	mov x3, 416
	mov x4, 160
	bl cuadradoVariable
	mov x1, 433     
	mov x3, 448
	bl cuadradoVariable
	mov x1, 457    
	mov x3, 480
	bl cuadradoVariable
	mov x1, 489    
	mov x3, 504
	bl cuadradoVariable
	mov x1, 521    
	mov x3, 528
	bl cuadradoVariable

	mov x1, 409  //ventanal, costados
	mov x2, 185
	mov x3, 418
	mov x4, 200
	bl cuadradoVariable
	mov x1, 519 
	mov x3, 528
	bl cuadradoVariable
	mov x1, 417    
	mov x2, 177
	mov x3, 424
	mov x4, 208
	bl cuadradoVariable
	mov x1, 513   
	mov x3, 520
	bl cuadradoVariable
	mov x1, 409     
	mov x2, 185
	mov x3, 416
	mov x4, 200
	bl cuadradoVariable
	

	mov x1, 241      //ventanas planta baja
	mov x2, 321
	mov x3, 264
	mov x4, 336
	bl cuadradoVariable
	mov x1, 281     
	mov x3, 320
	bl cuadradoVariable
	mov x1, 337     
	mov x3, 360
	bl cuadradoVariable
	mov x1, 425      //ventana puerta
	mov x3, 448
	bl cuadradoVariable
	mov x1, 500
	mov x3, 515
	bl cuadradoVariable
	mov x1, 520     
	mov x3, 535
	bl cuadradoVariable

	//luz farol
	mov x1, 41    
	mov x2, 343
	mov x3, 49
	mov x4, 361
	bl cuadradoVariable
    mov x1, 56
	mov x3, 65
	bl cuadradoVariable


    ldur lr, [sp,0]
	add sp, sp, 8	
	br lr

pintarCielo:
    mov x0, x20
    movz w17, 0x25, lsl 16 //color dia
	movk w17, 0x96BE, lsl 0
	movz w18, 0x05, lsl 16 //color noche
	movk w18, 0x0517, lsl 0
	mov x2, SCREEN_HEIGH       // Y Size
loop2:
	mov x1, SCREEN_WIDTH         // X Size
loop3:
    ldur w10, [x0]
    sub w9, w10, w17
	cbnz w9, segundoColorr
	stur w18,[x0]  // Colorear el pixel N
saltar:	
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop3  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop2 // Si no es la última fila, salto
	br lr
segundoColorr:
    sub w9, w10, w18
	cbnz w9, saltar
	stur w17, [x0]
	b saltar

    

	