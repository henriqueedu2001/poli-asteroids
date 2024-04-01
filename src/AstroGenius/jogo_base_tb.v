`timescale 1ns / 1ns

module jogo_base_tb;

    reg clock;
    reg reset;
    reg iniciar;
    reg [5:0] chaves;

    wire pronto;
    wire [4:0] db_estado_jogo_principal;
    wire [4:0] db_estado_coordena_asteroides_tiros;
    wire [4:0] db_estado_compara_tiros_e_asteroide;
    wire [4:0] db_estado_move_tiros;
    wire [4:0] db_estado_compara_asteroides_com_nave_e_tiros;
    wire [4:0] db_estado_move_asteroides;
    wire [3:0] db_estado_registra_tiro;
    wire [7:0] db_byte_saida_serial;
    wire db_serial_ativa;
    wire saida_serial;

    // Instantiate the astro_genius module
    jogo_base dut (
        /*inputs*/
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .chaves(chaves),
        .jogo_base_em_andamento(1'b1),
        .tela_renderizar(8'd5),
        .iniciar_transmissao(1'b0),
        /*outputs*/
        .gameover(pronto),
        .db_estado_jogo_principal(db_estado_jogo_principal),
        .db_estado_coordena_asteroides_tiros(db_estado_coordena_asteroides_tiros),
        .db_estado_compara_tiros_e_asteroide(db_estado_compara_tiros_e_asteroide),
        .db_estado_move_tiros(db_estado_move_tiros),
        .db_estado_compara_asteroides_com_nave_e_tiros(db_estado_compara_asteroides_com_nave_e_tiros),
        .db_estado_move_asteroides(db_estado_move_asteroides),
        .db_estado_registra_tiro(db_estado_registra_tiro),
        .db_serial_ativa(db_serial_ativa),
        .db_byte_saida_serial(db_byte_saida_serial),
        .saida_serial(saida_serial)
    );

   parameter clockPeriod = 20; // in ns, f=50MHz

    // Gerador de clock
    always #((clockPeriod / 2)) clock = ~clock;
    integer i = 0;

    always @(db_serial_ativa) begin
        if (db_serial_ativa) begin
            // para printar com os comentarios
            // $write("%b\n", db_byte_saida_serial[7:0]);
            i = i + 1;
            if (i == 1)
                $write("%b # pontuacao\n", db_byte_saida_serial[7:0]);
            else if (i == 2)
                $write("%b # {opcode_nave (2 bits), vidas (3 bits),  3'bzero}\n", db_byte_saida_serial[7:0]);
            else if (i == 3) 
                $write("%b # posicoes de asteroides\n", db_byte_saida_serial[7:0]);
            else if (i > 3 && i < 19)
                $write("%b\n", db_byte_saida_serial[7:0]);
            else if (i == 19)
                $write("%b # opcode dos asteroides\n", db_byte_saida_serial[7:0]);
            else if (i > 19 && i < 23)
                 $write("%b\n", db_byte_saida_serial[7:0]);
            else if (i == 23)
                 $write("%b # posicoes de tiros \n", db_byte_saida_serial[7:0]);
            else if (i > 23 && i < 39)
                 $write("%b\n", db_byte_saida_serial[7:0]);
            else if (i == 39)
                 $write("%b # opcode dos tiros \n", db_byte_saida_serial[7:0]);
            else if (i > 39 && i < 43)
                 $write("%b\n", db_byte_saida_serial[7:0]);
            else if (i == 43)
               $write("%b # {jogada_especial (um bit), especial_disponivel (um bit), jogada_tiro (um bit), tiro_disponivel (um bit) acabou_vidas (um bit), 3'bzero}  \n", db_byte_saida_serial[7:0]);
            else if (i == 44) 
                $write("%b # BK \n", db_byte_saida_serial[7:0]);
            else if (i == 45) begin
                $write("%b\n\n", db_byte_saida_serial[7:0]);
                i = 0;
            end
        end
    end
     
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(5, jogo_base_tb);

        // valores iniciais
        clock = 1'b0;
        reset = 1'b1;
        iniciar = 1'b0;
        chaves = 6'b000000;
        #(5*clockPeriod)

        reset = 1'b0;
        iniciar = 1'b1;
        #(10*clockPeriod)

        iniciar = 1'b0;
        #(10*clockPeriod)
        #(2000*clockPeriod)

        chaves = 6'b010001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b001001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b000101;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b001001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b010001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b100001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b000010;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b010001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b010001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b100001;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b000101;
        #(10*clockPeriod)
        chaves = 6'b000000;
        #(2000*clockPeriod)

        chaves = 6'b000000;
        #(20000*clockPeriod)
        // #(1000000*clockPeriod)
        $finish;
    end

endmodule