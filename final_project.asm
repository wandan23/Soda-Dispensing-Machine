#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

	jmp start
	db 509 dup(0)
	dw isr			
	dw 0000
	db 508 dup(0)
	
	
	
	
start:	cli
	mov		  ax,0200h
	mov       ds,ax
    mov       es,ax
    mov       ss,ax
    mov       sp,0FFFEH
	
	;intialize drink address
	drnk equ 0002h
	szep equ 0003h
	drnk1 equ 0004h
	drnk2 equ 0005h
	drnk3 equ 0006h
	rst_status equ 0007h
	
	mov al, 11111111b
	mov rst_status,al
	
	
	mov al, 10010000b									
	out 06h,al
	mov al,[rst_status]
	out 04h,al
	out 02h,al

		
	;set initial quantities	
	mov al,10
	mov [drnk1],al
	mov al,10
	mov [drnk2],al
	mov al,10
	mov [drnk3],al
		
	sti
	mov al,00010011b
	out 30h,al
	mov al,80h
	out 32h,al
	mov al, 03h
	out 32h,al
	mov al,0FEh
	out 32h,al	
		
x1: 
	;taking input of drink
	mov al,0ffh
	out 04h,al
	out 02h,al

	;check for button press
	in al,00h
	mov bl,al
	not al
	and al,00000111b
	jz x1 

	mov al,bl
	mov drnk,al
	out 04h,al
	
	;start timer for idleness for 20 seconds
	mov al,00110000b
	out 46h,al
	mov al,14h
	out 40h,al
	mov al,00h
	out 40h,al
	

	
	mov bl,1
	
	;button press for quantity
x3:	cmp bl,1
	jl x1
	in al,00h
	mov bl,al
	not al
	and al, 000111000b
	jz x3
	
	
	mov al,bl
	mov szep,al
	mov bl,[drnk]
	and al,bl
	mov rst_status,al
	out 04h,al
	
	
	
sml1:		mov al,[szep]
			not al
			and al,00001000b
			jz med1
		
			
			mov al,[drnk]
			not al
			and al,11111110b
			jnz x1sd2
			
			mov al,[drnk1]
			cmp al,1
			jge disp
			
			mov al, 11111110b									
				out 02h,al
			
				mov cx,1000
q1:				dec cx
				jnz q1
				
			jmp x1
			

x1sd2:		mov al,[drnk]
			not al
			and al,11111101b
			jnz x1sd3	
			
			mov al,[drnk2]
			cmp al,1
			jge disp
			
				mov al,11111101b
				out 02h,al
				
				
				mov cx,1000
q2:				dec cx
				jnz q2
				

				
			jmp x1

	
x1sd3:
			mov al,[drnk3]
			cmp al,1
			jge disp
			mov al, 11111011b									
			out 02h,al
			
			mov cx,1000
q3:			dec cx
			jnz q3
			
			jmp x1

	
med1:	mov al,[szep]
		not al
		and al,00010000b
		jz lrg1
		
			mov al,[drnk]
			not al
			and al,11111110b
			jnz x1md2
			
			mov al,[drnk1]
			cmp al,2
			jge disp
			
			mov al, 11111110b									
				out 02h,al
			
				mov cx,1000
q4:				dec cx
				jnz q4
			
			jmp x1
	
x1md2:		mov al,[drnk]
			not al
			and al,11111101b
			jnz x1md3
			
			mov al,[drnk2]
			cmp al,2
			jge disp
			;glow insufficient drink2
			mov al, 11111101b									
				out 02h,al
			
				mov cx,1000
q5:				dec cx
				jnz q5
			jmp x1
x1md3:

			mov al,[drnk3]
			cmp al,2
			jge disp
			;glow insufficient drink3
			mov al, 11111011b									
				out 02h,al
			
				mov cx,1000
q6:				dec cx
				jnz q6
			jmp x1
	
lrg1:		
			mov al,[drnk]
			not al
			and al,11111110b
			jnz x1ld2
			
			mov al,[drnk1]
			cmp al,3
			jge disp
			
			mov al, 11111110b									
				out 02h,al
			
				mov cx,1000
q7:				dec cx
				jnz q7
			jmp x1
			
x1ld2:		mov al,[drnk]
			not al
			and al,11111101b
			jnz x1ld3
			
			mov al,[drnk2]
			cmp al,3
			jge disp
			
			mov al, 11111101b									
				out 02h,al
			
				mov cx,1000
q8:				dec cx
				jnz q8
			jmp x1
x1ld3:
			mov al,[drnk3]
			cmp al,3
			jge disp
			
			mov al, 11111011b									
				out 02h,al
			
				mov cx,1000
q9:				dec cx
				jnz q9
			jmp x1
	
disp:

	
x5:	in al,00h
	mov bl,al
	not al
	and al,01000000b
	jz x5
	
	cli
	
	mov al,10011000b
	out 16h,al
	mov al,00h
	out 14h,al
	
	
	mov al,[szep]
	not al
	and al,00001000b
	jz x11	
 	
	
		in al,10h
		cmp al,9
		jl x1
		
		
		mov al,[drnk]
		not al
		and al,11111110b
		jnz xsd2
		
		mov al,[drnk1]
		sub al,1
		mov [drnk1],al

		
				mov al,00110000b
				out 26h,al
				mov al,0Ah
				out 20h,al
				mov al,00h
				out 20h,al
		
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del0:		dec cx
			jnz del0
		
		mov al, 10010000b									
		out 06h,al
		jmp x1
			
xsd2:	mov al,[drnk]
		not al
		and al,11111101b
		jnz xsd3
		
		
		mov al,[drnk2]
		sub al,1
		mov [drnk2],al
				
				
				mov al,01110000b
				out 26h,al
				mov al,0Ah
				out 22h,al
				mov al,00h
				out 22h,al
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del1:		dec cx
			jnz del1
		
		mov al, 10010000b									
		out 06h,al

			
			jmp x1
			
xsd3:	
		mov al,[drnk3]
		sub al,1
		mov [drnk3],al
		
			
			mov al,10110000b
			out 26h,al
			mov al,0Ah
			out 24h,al
			mov al,00h
			out 24h,al
			
			
x14:
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del2:		dec cx
			jnz del2
		
		mov al, 10010000b									
		out 06h,al
		jmp x1
	
x11:	
		mov al,[szep]
		not al
		and al,00010000b
		jz x12
		
		
		in al,10h
		cmp al,10011001b
		jl x1
				
	
			mov al,[drnk]
			not al
			and al,11111110b
			jnz xmd2
		
			mov al,[drnk1]
			sub al,2
			mov [drnk1],al
		
			
			mov al,00110000b
			out 26h,al
			mov al,14h
			out 20h,al
			mov al,00h
			out 20h,al
			
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del3:		dec cx
			jnz del3
		
		mov al, 10010000b									
		out 06h,al
			
			
			jmp x1
		
xmd2:		
			mov al,[drnk]
			not al
			and al,11111101b
			jnz xmd3
			
					mov al,[drnk2]
		sub al,2
		mov [drnk2],al
			
		
			mov al,01110000b
			out 26h,al
			mov al,14h
			out 22h,al
			mov al,00h
			out 22h,al
			
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del4:		dec cx
			jnz del4
		
		mov al, 10010000b									
		out 06h,al
			
			jmp x1
			
xmd3:		
			mov al,[drnk3]
			sub al,2
			mov [drnk3],al

			;Drink3
			;Rotate Motor3 for 2s
			mov al,10110000b
			out 26h,al
			mov al,14h
			out 24h,al
			mov al,00h
			out 24h,al
		
		
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del5:		dec cx
			jnz del5
		
		mov al, 10010000b									
		out 06h,al
			
			
			jmp x1
		
x12:	
		
	
		in al,10h
		cmp al,11000101b
		jl x1
		
		mov al,[drnk]
		not al
		and al,11111110b
		jnz xld2
			
			mov al,[drnk1]
			sub al,3
			mov [drnk1],al
			
			
			mov al,00110000b
			out 26h,al
			mov al,1Eh
			out 20h,al
			mov al,00h
			out 20h,al
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del6:		dec cx
			jnz del6
		
		mov al, 10010000b									
		out 06h,al
			
			jmp x1
			
xld2:	
		mov al,[drnk]
		not al
		and al,11111101b
		jnz xld3
		
			mov al,[drnk2]
			sub al,3
			mov [drnk2],al
		
			
			mov al,01110000b
			out 26h,al
			mov al,1Eh
			out 22h,al
			mov al,00h
			out 22h,al
			
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del7:		dec cx
			jnz del7
		
		mov al, 10010000b									
		out 06h,al
			
			jmp x1
			
xld3:
			
			mov al,[drnk3]
			sub al,3
			mov [drnk3],al
			mov al,10110000b
			out 26h,al
			mov al,1Eh
			out 24h,al
			mov al,00h
			out 24h,al
		
			
		mov al,00001110b
		out 06h,al
		
			mov cx,10000
del8:		dec cx
			jnz del8
		
		mov al, 10010000b									
		out 06h,al
		
			jmp x1

	
x2:	jmp x2 
	
isr:mov al,00h
	out 04h,al
	iret
	
	

	


	