module mux_2_1bit(a, b, sel, out);

    input a, b;
    input sel;
    output out;
    
    assign out = sel ? b : a;

endmodule