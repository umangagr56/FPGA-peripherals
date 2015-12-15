//-------------------------------------------------------------------
//-- scicad1_tb
//-- Banco de pruebas para el ejemplo de transmision continua de
//-- cadenas
//-------------------------------------------------------------------
//-- BQ September 2015. Written by Juan Gonzalez (Obijuan)
//-------------------------------------------------------------------
//-- GPL License
//-------------------------------------------------------------------
`default_nettype none
`timescale 100 ns / 10 ns
`include "baudgen.vh"


module txstr_tb();

//-- Baudios con los que realizar la simulacion
localparam BAUD = `B115200;

//-- Tics de reloj para envio de datos a esa velocidad
//-- Se multiplica por 2 porque el periodo del reloj es de 2 unidades
localparam BITRATE = (BAUD << 1);

//-- Tics necesarios para enviar una trama serie completa, mas un bit adicional
localparam FRAME = (BITRATE * 11);

//-- Tiempo entre dos bits enviados
localparam FRAME_WAIT = (BITRATE * 4);

//-- Registro para generar la señal de reloj
reg clk = 0;

//-- Linea de tranmision
wire tx;

//-- Simulacion de la señal dtr
reg dtr = 0;

//-- Instanciar el componente
txstr #(.BAUD(BAUD))
  dut(
    .clk(clk),
    .dtr(dtr),
    .tx(tx)
  );

//-- Generador de reloj. Periodo 2 unidades
always
  # 0.5 clk <= ~clk;


//-- Proceso al inicio
initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("examples/txstr_tb.vcd");
  $dumpvars(0, txstr_tb);

  #1 dtr <= 0;

  //-- Comenzar primer envio
  #FRAME_WAIT dtr <= 1;
  #(BITRATE * 2) dtr <=0;

  //-- Segundo envio (2 caracteres mas)
  #(FRAME * 11) dtr <=1;
  #(BITRATE * 1) dtr <=0;

  #(FRAME * 11) $display("FIN de la simulacion");
  $finish;
end

endmodule