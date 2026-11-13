	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ CURSOR_WIDTH,   8
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34 // 0b00110100

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

    movz x10, 0x80, lsl 16
    movk x10, 0x8080, lsl 00

    mov x2, SCREEN_HEIGH
	lsr x2, x2, 1
	add x2, x2, 100
    add x1, xzr, xzr
	mov x3, SCREEN_WIDTH
	add x4, x2, 15

    bl cuadradoVariable

	mov x2, x4
	mov x4, SCREEN_HEIGH
	add x3, x1, 100
	movz x10, 0xFF, lsl 16
	movk x10, 0xFF00, lsl 0
    bl cuadradoVariable

	add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0x00, lsl 16
    movk x10, 0xFF00, lsl 00
	bl cuadradoVariable

	add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0x00, lsl 16
    movk x10, 0xFF, lsl 00
    bl cuadradoVariable

    add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0xFF, lsl 16
    bl cuadradoVariable

    add x1, x3, xzr
	add x3, x3, 100
	movz x10, 0xFFFF, lsl 00 
    bl cuadradoVariable


	mov x1, SCREEN_WIDTH
	lsr x1, x1, 2
    mov x2, SCREEN_HEIGH
	lsr x2, x2, 2


	bl puntero


	// bl linea_arcoiris
	// Ejemplo de uso de gpios

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits
	// Lee el estado de los GPIO 0 - 31
	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado
	movz x19, 0x10, lsl 16
InfLoop:
    sub x19, x19, 1
	cbnz x19, InfLoop
    // bl arcoiris_update

	mov x9, GPIO_BASE
	str wzr, [x9, GPIO_GPFSEL0] 
	ldr w10, [x9, GPIO_GPLEV0]
	and w11, w10, 0b11110
	cbz w11, skip
	// bl moverPuntero
	// bl linea_arcoiris

skip:
    movz x19, 0x50, lsl 16
	b InfLoop


// UBICAR CORRECTAMENTE EL FB ///////////////////////////////////////////////////////
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


/// DIBUJAR UNA LINEA /////////////////////////////////////////////////////////////
// LINEA CONSTANTE  ------------------------------------------------
constLineDrawer:
    sub sp, sp, 32
	stur x0, [sp,24]
	stur x13, [sp,16]
	stur x4, [sp,8]
	stur x3, [sp,0]

    bl fb_set
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


// DIBUJAR UN TRIANGULO EQUILATERO //////////////////////////////////////////////////////////
// x1, x2: x,y del centro
// x3: tamaño, hacia abajo/izquierda, del triángulo.
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
	and w12, w9, 0b10
	cbnz w12, setVerticalT
    mov x12, 2556
	b triangleStart
setVerticalT:
    mov x12, -2564
triangleStart:
    mov x3, x4
	lsl x3, x3, 1
	add x3, x3, 1
	add x0, x0, x12
	bl constLineDrawer
    add x4, x4, 1
	sub x5, x5, 1
	cbnz x5, triangleStart

	ldur x1, [sp,0]
	ldur x2, [sp,8]
	ldur x3, [sp,16]
	ldur x4, [sp,24]
	ldur x5, [sp,56]
	ldur lr, [sp,32]
	ldur x10, [sp,40]
	ldur x11, [sp,48]
	add sp, sp, 64
	br lr


    movz x10, 0x80, lsl 16
    movk x10, 0x8080, lsl 00

	movz x10, 0x00, lsl 16
	movk x10, 0xFFFF, lsl 00

///// MOVER CUADRADO /////////////////////////////////////////////////////////////


moverCuadrado:
    sub sp, sp, 48
	stur lr, [sp,24]
	stur x5, [sp,16]
	stur x10, [sp,8]
    stur x9, [sp,0]

	and w9, w11, 0b10
	cbnz w9, mover_arriba
	and w9, w11, 0b100
	cbnz w9, mover_izquierda
	and w9, w11, 0b1000
	cbnz w9, mover_abajo


// "Mover derecha"
    mov x5, x3
	mov x3, x1
	add x3, x3, 2
	bl fb_set
	movz x10, 0x00, lsl 16
    movk x10, 0x80, lsl 00
    bl cuadradoVariable
	movz x10, 0x80, lsl 16
	movk x10, 0x8080, lsl 00
	mov x3, x5
	mov x5, x1
	mov x1, x3
	add x3, x3, 2
	bl fb_set
	bl cuadradoVariable
	mov x1, x5
	add x1, x1, 2
    b fin

mover_arriba:
    mov x5, x2
	mov x2, x4
	sub x2, x2, 2
	bl fb_set
	movz x10, 0x00, lsl 16
    movk x10, 0x80, lsl 00
    bl cuadradoVariable
	movz x10, 0x80, lsl 16
	movk x10, 0x8080, lsl 00
	mov x2, x5
	mov x5, x4
	mov x4, x2
	sub x2, x2, 2
	bl fb_set
	bl cuadradoVariable
	mov x4, x5
	sub x4, x4, 2
    b fin

mover_izquierda:
    mov x5, x1
	mov x1, x3
	sub x1, x1, 2
	bl fb_set
	movz x10, 0x00, lsl 16
    movk x10, 0x80, lsl 00
    bl cuadradoVariable
	movz x10, 0x80, lsl 16
	movk x10, 0x8080, lsl 00
	mov x1, x5
	mov x5, x3
	mov x3, x1
    sub x1, x1, 2
	bl fb_set
	bl cuadradoVariable
	mov x3, x5
	sub x3, x3, 2
    b fin


mover_abajo:

	mov x5, x4
	mov x4, x2
	add x4, x4, 2
	bl fb_set
	movz x10, 0x00, lsl 16
    movk x10, 0x80, lsl 00
    bl cuadradoVariable
	movz x10, 0x80, lsl 16
	movk x10, 0x8080, lsl 00
	mov x4, x5
	mov x5, x2
	mov x2, x4
	add x4, x4, 2
	bl fb_set
	bl cuadradoVariable
	mov x2, x5
	add x2, x2, 2
    b fin

fin:
    ldur lr, [sp,24]
	ldur x5, [sp,16]
	ldur x10, [sp,8]
	ldur x9, [sp,0]
	add sp, sp, 24
	br lr



linea_arcoiris:
    sub sp, sp, 48
	stur x1, [sp,40]
	stur x4, [sp,32]
	stur x2, [sp,24]
	stur lr, [sp,16]
	stur x6, [sp,8]
	stur x7, [sp,0]

    add x2, x2, 8
	add x4, x2, 16
    sub x1, x1, 1
    bl fb_set
	movz w10, 0x87, lsl 16
	movk w10, 0xCEFA, lsl 0
    bl lineaVariableRapidaVertical
	add x2, x2, 16
	add x4, x4, 16
	bl fb_set
	movz w10, 0xFF, lsl 16
	movk w10, 0xFFFF, lsl 0
	bl lineaVariableRapidaVertical
	add x2, x2, 16
	add x4, x4, 16
	bl fb_set
	movz w10, 0x87, lsl 16
	movk w10, 0xCEFA, lsl 0
	bl lineaVariableRapidaVertical
	ldur x7, [sp,0]
	ldur x6, [sp,8]
	ldur lr, [sp,16]
	ldur x2, [sp,24]
	ldur x4, [sp,32]
	ldur x1, [sp,40]
	add sp, sp, 48
    br lr


arcoiris_update:  // ARCOIRIS UPDATE ESTÁ AL REVÉS; TIENE QUE SER DESDE ABAJO A LA DERECHA HASTA ARRIBA A LA IZQUIERDA
    sub sp, sp, 72
	stur lr, [sp,0]
	stur x0, [sp,8]
	stur x1, [sp,16]
	stur x2, [sp,24]
	stur w10, [sp,32]
	stur w11, [sp,40]
	stur w12, [sp,48]
	stur w13, [sp,56]
	stur w14, [sp,64]

    mov x0, x20
	mov x2, SCREEN_HEIGH
    movz w10, 0x80, lsl 16
	movk w10, 0x8080, lsl 00
	movz w12, 0x00, lsl 16
    movk w12, 0x80, lsl 00
	movz w13, 0xFF, lsl 16
	movk w13, 0xFFFF, lsl 0
	movz w14, 0x87, lsl 16
	movk w14, 0xCEFA, lsl 0
loop00:
    mov x1, SCREEN_WIDTH
	sub x1, x1, 16 //No queremos actualizar el último pixel de la derecha porque ese lee el de la fila que viene
loop01:
	ldur w11, [x0]
	cmp w11, w12
	b.eq fondo_check
	cmp w11, w13
	b.eq arcoiris_check
	cmp w11, w14
	b.eq arcoiris_check
// Else, forma parte de la imagen.
	b.eq finn
fondo_check:
    add x0, x0, 8
	ldur w11, [x0]
    cmp w11, w14
	b.ne segundoColor
	sub x0, x0, 8
	stur w14, [x0]
	b finn
segundoColor:
    cmp w11, w13
	b.ne finn // Else, tiene otro color: fondo o imagen, no importa
	sub x0, x0, 8
	stur w13, [x0]
	b finn

arcoiris_check:
    add x0, x0, 8
	ldur w11, [x0]
	cmp w11, w12
	b.ne finn //Si no es el fondo, skip
	sub x0, x0, 4
	ldur w11, [x0]
	cmp w11, w12
	b.ne finn
	sub x0,x0, 4
    stur w12, [x0]
finn:
    add x0, x0, 4
	sub x1, x1, 1
	cbnz x1, loop01

	sub x2, x2, 1
	add x0, x0, 64 //Skip último píxel
	cbnz x2, loop00
    
	ldur w14, [sp,64]
	ldur w13, [sp,56]
	ldur w12, [sp,48]
	ldur w11, [sp,40]
	ldur w10, [sp,32]
    ldur x2, [sp,24]
	ldur x1, [sp,16]
	ldur x0, [sp,8]
	ldur lr, [sp,0]
	add sp, sp, 72
	ret


puntero:
    add sp, sp, 48
	stur lr, [sp,0]
	stur x0, [sp,8]
	stur w10, [sp,16]
	stur x3, [sp,24]
	stur x1, [sp,32]
	stur x2, [sp,40]

	movz w10, 0x00, lsl 16
	// movk w10, 0x8080, lsl 00

	mov x3, CURSOR_WIDTH
	add x2, x2, x3
	bl fb_set
	stur w10, [x0]
	add x0, x0, 2560
	stur w10, [x0]
	sub x2, x2, x3
	sub x2, x2, x3
	bl fb_set
	stur w10, [x0]
    sub x0, x0, 2560
	stur w10, [x0]
	add x2, x2, x3

	add x1, x1, x3
	bl fb_set
	stur w10, [x0]
    add x0, x0, 4
	stur w10, [x0]
	sub x1, x1, x3
	sub x1, x1, x3
	bl fb_set
	stur w10, [x0]
	sub x0, x0, 4
	stur w10, [x0]

    ldur x2, [sp,40]
    ldur x1, [sp,32]
    ldur x3, [sp,24]
    ldur w10, [sp,16]
	ldur x0, [sp,8]
    ldur lr, [sp,0]
    sub sp, sp, 48
	ret
