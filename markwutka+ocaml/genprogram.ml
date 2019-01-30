open X64

let program = [
    Directive_text;
    Directive_globl "_start";
    Directive_label "_start";
    
    Inst_lea (Addr_Mode_Indirect_Disp (Address_label "L_.str", Reg_rip), Addr_Mode_Reg Reg_rdi);
    Inst_call "puts";

    Inst_mov (Addr_Mode_Immed (Address_value (Int64.of_int 60)), Addr_Mode_Reg Reg_rax);
    Inst_mov (Addr_Mode_Immed (Address_value (Int64.of_int 0)), Addr_Mode_Reg Reg_rdi);
    Inst_syscall;
             
    Directive_label "L_.str";
    Directive_asciz "hello world"];;
                
             
write_instrs_to_file program "program.s"


                                         
    
