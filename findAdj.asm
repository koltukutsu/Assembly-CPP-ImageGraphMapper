.section .text
whiteNeighborCount: .int 0 ; 255 degerinde beyaz komsulari saklamak icin kullanilir.
.global findAdj

findAdj:
    PUSH EBP
    MOV EBP, ESP

    ; Parametreleri al
    MOV EDX, [EBP+8]  ; Haritanın genişliği (N)
    MOV ECX, [EBP+12] ; Haritanın yüksekliği (M)
    MOV ESI, [EBP+16] ; Harita verisi adresi (int **resim_org)
    MOV EDI, [EBP+20] ; index_i dizisinin adresi
    LEA EAX, [EBP+24] ; index_j dizisinin adresi

    XOR EBX, EBX      ; Dizi indeksi (EBX) sıfırlanır
    XOR EAX, EAX      ; Satır sayacı (EAX) sıfırlanır

row_loop:
    CMP EAX, ECX
    JGE end_row_loop

    XOR EDX, EDX      ; Sütun sayacı (EDX) sıfırlanır
col_loop:
    CMP EDX, EDX
    JGE end_col_loop

        ; resim_org[i][j] kontrolü
        MOV ESI, [ESI + 4*EAX]  ; ESI, resim_org[i]'nin adresini alır
        MOV ESI, [ESI + 4*EDX]  ; ESI, resim_org[i][j]'yi alır
        ; kac 255 deger var icin flag AX
        MOV AX, 0
        ; COMPARISON yapmak gerekiyor
        ;1 [i][j+1]
        MOV ESI, [ESI + 4*EAX]  ; ESI, resim_org[i]'nin adresini alır
        MOV ESI, [ESI + 4*(EDX +  1)]  ; ESI, resim_org[i][j+1]'yi alır
        CMP ESI, 255
        JNE devam_final
        INC 

        ;2 [i][j-1]
        MOV ESI, [ESI + 4*EAX]  ; ESI, resim_org[i]'nin adresini alır
        MOV ESI, [ESI + 4*(EDX - 1)]  ; ESI, resim_org[i][j-1]'yi alır
        ;3 [i+1][j]
        MOV ESI, [ESI + 4*(EAX + 1)]  ; ESI, resim_org[i+1]'nin adresini alır
        MOV ESI, [ESI + 4*EDX]  ; ESI, resim_org[i+1][j]'yi alır
        ;4 [i-1][j]
        MOV ESI, [ESI + 4*(EAX - 1)]  ; ESI, resim_org[i-1]'nin adresini alır
        MOV ESI, [ESI + 4*EDX]  ; ESI, resim_org[i-1][j]'yi alır
        CMP ESI, 255
        JNE devam_final           ; Eğer resim_org[i][j] 255 değilse, atla

        ; index_i ve index_j'ye değer atama
        MOV EAX, DWORD PTR [whiteNeighborCount]
        CMP EAX, 1
        JE add_index
        CMP EAX, 3
        JE add_index
        CMP EAX, 4
        JE add_index

skip_add:
    INC EDX
    JMP col_loop
    
add_index:
    ; index_i ve index_j'ye değer atama
    MOV [EDI + 4*EBX], EAX ; index_i[EBX] = EAX (i)
    MOV [EAX + 4*EBX], EDX ; index_j[EBX] = EDX (j)
    INC EBX                ; EBX'yi arttır (counter)
    JMP end_add_index

end_add_index:
    INC EDX
    JMP col_loop
end_col_loop:

    INC EAX
    JMP row_loop
end_row_loop:

    POP EBP
    RET
