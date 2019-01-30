
type register =
  Reg_rip | Reg_rsp | Reg_rax | Reg_rdi | Reg_rsi |
  Reg_rdx | Reg_rcx | Reg_rbx | Reg_rbp | Reg_r8  | Reg_r9 |
  Reg_r10 | Reg_r11 | Reg_r12 | Reg_r13 | Reg_r14 | Reg_r15

type scale =
  Scale_1 | Scale_2 | Scale_4 | Scale_8

type address =
  | Address_value of int64
  | Address_label of string
                       
type addr_mode =
  | Addr_Mode_Immed of address
  | Addr_Mode_Reg of register
  | Addr_Mode_Direct of address
  | Addr_Mode_Indirect of register
  | Addr_Mode_Indirect_Disp of address * register
  | Addr_Mode_Indirect_Scaled of address * register * register * scale

type instruction =
  | Inst_mov of addr_mode * addr_mode
  | Inst_movsbl of addr_mode * addr_mode
  | Inst_movzbl of addr_mode * addr_mode
  | Inst_lea of addr_mode * addr_mode
  | Inst_add of addr_mode * addr_mode
  | Inst_sub of addr_mode * addr_mode
  | Inst_imul of addr_mode * addr_mode
  | Inst_neg of addr_mode
  | Inst_sal of int * addr_mode
  | Inst_sar of int * addr_mode
  | Inst_shr of int * addr_mode
  | Inst_and of addr_mode * addr_mode
  | Inst_or of addr_mode * addr_mode
  | Inst_xor of addr_mode * addr_mode
  | Inst_not of addr_mode
  | Inst_cmp of addr_mode * addr_mode
  | Inst_test of addr_mode * addr_mode
  | Inst_jmp of address
  | Inst_je of address
  | Inst_jne of address
  | Inst_js of address
  | Inst_jns of address
  | Inst_jg of address
  | Inst_jge of address
  | Inst_jl of address
  | Inst_jle of address
  | Inst_ja of address
  | Inst_jb of address
  | Inst_push of addr_mode
  | Inst_pop of addr_mode
  | Inst_call of string
  | Inst_ret
  | Inst_syscall
  | Directive_text
  | Directive_globl of string
  | Directive_label of string
  | Directive_asciz of string

let address_to_string addr =
  match addr with
    Address_value v -> Int64.to_string v
  | Address_label l -> l

let reg_to_string reg =
  match reg with
    Reg_rip -> "%rip"
  | Reg_rsp -> "%rsp"
  | Reg_rax -> "%rax"
  | Reg_rdi -> "%rdi"
  | Reg_rsi -> "%rsi"
  | Reg_rdx -> "%rdx"
  | Reg_rcx -> "%rcx"
  | Reg_rbx -> "%rbx"
  | Reg_rbp -> "%rbp"
  | Reg_r8 -> "%r8"
  | Reg_r9 -> "%r9"
  | Reg_r10 -> "%r10"
  | Reg_r11 -> "%r11"
  | Reg_r12 -> "%r12"
  | Reg_r13 -> "%r13"
  | Reg_r14 -> "%r14"
  | Reg_r15 -> "%r15"
                 
let scale_to_string scale =
  match scale with
    Scale_1 -> "1"
  | Scale_2 -> "2"
  | Scale_4 -> "4"
  | Scale_8 -> "8"
                 
let addr_mode_to_string addr_mode =
  match addr_mode with
    Addr_Mode_Immed addr -> "$" ^ (address_to_string addr)
  | Addr_Mode_Reg reg -> reg_to_string reg
  | Addr_Mode_Direct addr -> address_to_string addr
  | Addr_Mode_Indirect reg -> "(" ^ (reg_to_string reg) ^ ")"
  | Addr_Mode_Indirect_Disp (disp, reg) -> (address_to_string disp) ^ "(" ^ (reg_to_string reg) ^ ")"
  | Addr_Mode_Indirect_Scaled (disp, regbase, regindex, scale) ->
     (address_to_string disp) ^ "(" ^ (reg_to_string regbase) ^ "," ^ (reg_to_string regindex) ^ "," ^ (scale_to_string scale) ^ ")"
                                                                                                                         
let instruction_to_string inst =
  match inst with
    Inst_mov (src,dst) -> Printf.sprintf "    mov %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_movsbl (src,dst) -> Printf.sprintf "    movsbl %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_movzbl (src,dst) -> Printf.sprintf "    movzbl %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_lea (src,dst) -> Printf.sprintf "    lea %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_add (src,dst) -> Printf.sprintf "    add %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_sub (src,dst) -> Printf.sprintf "    sub %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_imul (src,dst) -> Printf.sprintf "    imul %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_neg dst -> Printf.sprintf "    neg %s\n" (addr_mode_to_string dst)
   | Inst_sal (count,dst) -> Printf.sprintf "    sal %d,%s\n" count (addr_mode_to_string dst)
   | Inst_sar (count,dst) -> Printf.sprintf "    sar %d,%s\n" count (addr_mode_to_string dst)
   | Inst_shr (count,dst) -> Printf.sprintf "    shr %d,%s\n" count (addr_mode_to_string dst)
   | Inst_and (src,dst) -> Printf.sprintf "    and %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_or (src,dst) -> Printf.sprintf "    or %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_xor (src,dst) -> Printf.sprintf "    xor %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_not dst -> Printf.sprintf "    not %s\n" (addr_mode_to_string dst)
   | Inst_cmp (src,dst) -> Printf.sprintf "    cmp %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_test (src,dst) -> Printf.sprintf "    test %s,%s\n" (addr_mode_to_string src) (addr_mode_to_string dst)
   | Inst_jmp label -> Printf.sprintf "    jmp %s\n" (address_to_string label)
   | Inst_je label -> Printf.sprintf "    je %s\n" (address_to_string label)
   | Inst_jne label -> Printf.sprintf "    jne %s\n" (address_to_string label)
   | Inst_js label -> Printf.sprintf "    js %s\n" (address_to_string label)
   | Inst_jns label -> Printf.sprintf "    jns %s\n" (address_to_string label)
   | Inst_jg label -> Printf.sprintf "    jg %s\n" (address_to_string label)
   | Inst_jge label -> Printf.sprintf "    jge %s\n" (address_to_string label)
   | Inst_jl label -> Printf.sprintf "    jl %s\n" (address_to_string label)
   | Inst_jle label -> Printf.sprintf "    jle %s\n" (address_to_string label)
   | Inst_ja label -> Printf.sprintf "    ja %s\n" (address_to_string label)
   | Inst_jb label -> Printf.sprintf "    jn %s\n" (address_to_string label)
   | Inst_push src -> Printf.sprintf "    push %s\n" (addr_mode_to_string src)
   | Inst_pop src -> Printf.sprintf "    pop %s\n" (addr_mode_to_string src)
   | Inst_call fn -> Printf.sprintf "    call %s\n" fn
   | Inst_ret -> "    ret\n"
   | Inst_syscall -> "    syscall\n"
   | Directive_text -> ".text\n"
   | Directive_globl str -> Printf.sprintf "    .globl %s\n" str
   | Directive_label str -> Printf.sprintf "%s:\n" str
   | Directive_asciz str -> Printf.sprintf "    .asciz \"%s\"\n" str

let write_instrs_to_file instrs file =
  let outfile = open_out file in
  let write_inst inst = output_string outfile (instruction_to_string inst) in
  List.iter write_inst instrs;
  close_out outfile
