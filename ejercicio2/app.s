	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ CURSOR_WIDTH,   8
	.equ BITS_PER_PIXEL, 32
	.equ LINEA_DIVISORA, 340

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34 // 0b00110100

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20

	movz x10, 0xEC, lsl 16  // x10 es el registro genérico
	movk x10, 0xECEC, lsl 00
    movz x7, 0xEC, lsl 16 // Color del pincel
	movk x7, 0xECEC, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0] 
	add x0,x0,4   
	sub x1,x1,1    
	cbnz x1,loop0  
	sub x2,x2,1    
	cbnz x2,loop1  


    movz x10, 0x80, lsl 16
    movk x10, 0x8080, lsl 00

    mov x2, LINEA_DIVISORA   // Pintar la linea divisoria gris
    add x1, xzr, xzr
	mov x3, SCREEN_WIDTH
	add x4, x2, 15

    bl cuadradoVariable

	mov x2, x4
	mov x4, SCREEN_HEIGH        // En orden, pinta los cinco colores que serán utilizados
	add x3, x1, 100
	movz x10, 0xF3, lsl 16
	movk x10, 0xFF9D, lsl 0
    bl cuadradoVariable

	add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0xFE, lsl 16
    movk x10, 0x7F7F, lsl 00
	bl cuadradoVariable

	add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0xBA, lsl 16
    movk x10, 0xFFA4, lsl 00
    bl cuadradoVariable

    add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0x55, lsl 16
	movk x10, 0x66E1, lsl 00
    bl cuadradoVariable

    add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0xB1, lsl 16
	movk x10, 0x8CF5, lsl 00
    bl cuadradoVariable

    mov x1, 545   // GOMA DE BORRAR
	mov x2, 421
	mov x3, 596
	mov x4, 472
    movz x10, 0x41, lsl 16
    movk x10, 0x413E, lsl 00
	bl cuadradoVariable

	movz w10, 0xE6, lsl 16   // Parte Naranja
	movk w10, 0x7E22, lsl 00
	mov x1, 549
	mov x2, 425
	mov x3, 592
	mov x4, 468
	bl cuadradoVariable

    movz x10, 0x41, lsl 16  // Parte blanca-negra
    movk x10, 0x413E, lsl 00
	mov x1, 548
	mov x2, 394
	mov x3, 593
	mov x4, 421
	bl cuadradoVariable
	add x1, x1, 1
	sub x3, x3, 1
	sub x2, x2, 2
	sub x4, x4, 2
	bl cuadradoVariable
	add x1, x1, 1
	sub x3, x3, 1
	sub x2, x2, 2
	sub x4, x4, 2
	bl cuadradoVariable
	add x1, x1, 2
	sub x3, x3, 2
	sub x2, x2, 1
	sub x4, x4, 1
	bl cuadradoVariable

	movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00
	mov x1, 551
	mov x2, 397
	mov x3, 590
	mov x4, 421
	bl cuadradoVariable
	add x1, x1, 1
	sub x3, x3, 1
	sub x2, x2, 2
	sub x4, x4, 2
	bl cuadradoVariable
	add x1, x1, 1
	sub x3, x3, 1
	sub x2, x2, 2
	sub x4, x4, 2
	bl cuadradoVariable
	add x1, x1, 2
	sub x3, x3, 2
	sub x2, x2, 1
	sub x4, x4, 1
	bl cuadradoVariable

	mov x1, SCREEN_WIDTH
	lsr x1, x1, 2
    mov x2, SCREEN_HEIGH
	lsr x2, x2, 2


	bl puntero



	movz x19, 0x30, lsl 16  // x19 es el contador del delay
	add w5, wzr, wzr           // w5 va a ser el estado anterior
InfLoop:
    sub x19, x19, 1
	cbnz x19, InfLoop

	mov x9, GPIO_BASE
	str wzr, [x9, GPIO_GPFSEL0] 
	ldr w10, [x9, GPIO_GPLEV0]
	and w6, w10, 0b11110
	bl moverPuntero
    
	and w6, w10, 0x20
	cmp w5, w6
	b.eq pass
	cmp x2, 355
	b.gt agarrarColor
	cmp x2, 330
    b.gt pass
	cmp x2, 10
	b.lt pass
    bl pintar_cuadrado
	bl puntero
pass:
	mov w5, w6
    movz x19, 0x30, lsl 16
	b InfLoop

agarrarColor:
    cmp x1, 500
	b.gt borrarCanvas
    ldur w7, [x0]
	b pass

borrarCanvas:
    sub sp, sp, 48
    stur x1, [sp,0]
	stur x2, [sp,8]
	stur x0, [sp,16]
	stur x3, [sp, 24]
	stur x4, [sp, 32]
	stur x10, [sp,40]

	add x1, xzr, xzr
	add x2, xzr, xzr
	mov x3, SCREEN_WIDTH
	mov x4, LINEA_DIVISORA
	movz x10, 0xEC, lsl 16
	movk x10, 0xECEC, lsl 00
	bl cuadradoVariable

    ldur x1, [sp,0]
	ldur x2, [sp,8]
	ldur x0, [sp,16]
	ldur x3, [sp, 24]
	ldur x4, [sp, 32]
	ldur x10, [sp,40]
	add sp, sp, 48
	b pass



// UBICAR CORRECTAMENTE EL FB, usando x1 y x2 como x, y -----------------------------------------------
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



// LINEA VARIABLE  HORIZONTAL ------------------------------------------------
// ARGUMENTOS x1, x2: x, y inicial x3: x final ("x2").
// VARIABLES x9: contador
lineaVariable:
    sub sp, sp, 16
	stur x0, [sp,8]
	stur x9, [sp,0]
	bl fb_set
    sub x9, x3, x1
comienzo:
	stur w10, [x0]
	add x0, x0, 4
	sub x9, x9, 1
	cbnz x9, comienzo
    ldur x9, [sp,0]
	ldur x0, [sp,8]
	add sp, sp, 16
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





// DIBUJAR UN RECTANGULO /////////////////////////////////////////////////////////////
// x1, x2: x, y iniciales
// x3, x4: x, y finales
//VARIABLES x9: contador de linea
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




///////////////////////////// PINTAR EL CUADRADO EN LA UBICACION DEL PUNTERO ///////////////////////////////////////////////////////////

pintar_cuadrado:
    sub sp, sp, 64
    stur x0, [sp,0]
    stur x1, [sp,8]
	stur x2, [sp,16]
	stur x3, [sp,24]
	stur x4, [sp,32]
	stur w10, [sp,40]
	stur lr, [sp,48]
    stur x9, [sp,56]

	mov x9, SCREEN_HEIGH
    lsr x9, x9, 1
	add x9, x9, 100

    add x3, x1, 10
	cmp x3, SCREEN_WIDTH
	b.gt end
    add x4, x2, 10
	cmp x4, x9
	b.gt end
	sub x1, x1, 10
	cmp x1, xzr
	b.lt end
	sub x2, x2, 10
	cmp x2, xzr
	b.lt end
	mov w10, w7
	bl cuadradoVariable
end:
    ldur x0, [sp,0]
    ldur x1, [sp,8]
	ldur x2, [sp,16]
	ldur x3, [sp,24]
	ldur x4, [sp,32]
	ldur w10, [sp,40]
	ldur lr, [sp,48]
	ldur x9, [sp,56]
    add sp, sp, 64
	br lr
	





/////////////////////// FUNCIONES DE PUNTEROS ////////////////////////////////////////////////////////////////////////////////

////// IMPRIMIR EL PUNTERO ///
puntero:
    add sp, sp, 48
	stur lr, [sp,0]
	stur x0, [sp,8]
	stur w10, [sp,16]
	stur x3, [sp,24]
	stur x1, [sp,32]
	stur x2, [sp,40]

	movz w10, 0x00, lsl 16
	//movk w10, 0x0000, lsl 00

	mov x3, CURSOR_WIDTH
	add x2, x2, x3
	bl fb_set
	ldur w11, [x0]
	stur w10, [x0]
	add x0, x0, 2560
	ldur w12, [x0]
	stur w10, [x0]
	sub x2, x2, x3
	sub x2, x2, x3
	bl fb_set
	ldur w13, [x0]
	stur w10, [x0]
    sub x0, x0, 2560
	ldur w14, [x0]
	stur w10, [x0]
	add x2, x2, x3

	add x1, x1, x3
	bl fb_set
	ldur w15, [x0]
	stur w10, [x0]
    add x0, x0, 4
	ldur w16, [x0]
	stur w10, [x0]
	sub x1, x1, x3
	sub x1, x1, x3
	bl fb_set
	ldur w17, [x0]
	stur w10, [x0]
	sub x0, x0, 4
	ldur w18, [x0]
	stur w10, [x0]

    ldur x2, [sp,40]
    ldur x1, [sp,32]
    ldur x3, [sp,24]
    ldur w10, [sp,16]
	ldur x0, [sp,8]
    ldur lr, [sp,0]
    sub sp, sp, 48
	ret


/////// LIMPIAR EL PUNTERO ////////

limpiarPuntero:
    add sp, sp, 40
	stur lr, [sp,0]
	stur x0, [sp,8]
	stur x3, [sp,16]
	stur x1, [sp,24]
	stur x2, [sp,32]


	mov x3, CURSOR_WIDTH
	add x2, x2, x3
	bl fb_set
	stur w11, [x0]
	add x0, x0, 2560
	stur w12, [x0]
	sub x2, x2, x3
	sub x2, x2, x3
	bl fb_set
	stur w13, [x0]
    sub x0, x0, 2560
	stur w14, [x0]
	add x2, x2, x3

	add x1, x1, x3
	bl fb_set
	stur w15, [x0]
    add x0, x0, 4
	stur w16, [x0]
	sub x1, x1, x3
	sub x1, x1, x3
	bl fb_set
	stur w17, [x0]
	sub x0, x0, 4
	stur w18, [x0]

    ldur x2, [sp,32]
    ldur x1, [sp,24]
    ldur x3, [sp,16]
	ldur x0, [sp,8]
    ldur lr, [sp,0]
    sub sp, sp, 40
	ret



///// MOVER PUNTERO ///////////////////


moverPuntero:
    sub sp, sp, 48
	stur lr, [sp,24]
	stur x5, [sp,16]
	stur x10, [sp,8]
    stur x9, [sp,0]
    cbz w6, fin
    bl limpiarPuntero
	and w9, w6, 0b10
	cbnz w9, mover_arriba
	and w9, w6, 0b100
	cbnz w9, mover_izquierda
	and w9, w6, 0b1000
	cbnz w9, mover_abajo


// "Mover derecha"
    add x1, x1, 4
	bl fb_set
	bl puntero
	b fin

mover_arriba:
    sub x2, x2, 4
	bl fb_set
	bl puntero
	b fin

mover_izquierda:
    sub x1, x1, 4
	bl fb_set
	bl puntero
	b fin

mover_abajo:

	add x2, x2, 4
	bl fb_set
	bl puntero
	b fin

fin:
    ldur lr, [sp,24]
	ldur x5, [sp,16]
	ldur x10, [sp,8]
	ldur x9, [sp,0]
	add sp, sp, 24
	br lr
