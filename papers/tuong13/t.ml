open Melt_lib open L
open Melt_highlight
open Simsoc_cert

##verbatim '?' = Code.Raw_.verbatim
##verbatim '!' = Code.Raw.verbatim
##verbatim '#' = Code.Coq.verbatim
##verbatim 'Z' = Code.Coq.verbatim
##verbatim '~' = Code.Ml.verbatim
##verbatim '@' = Code.Humc_.verbatim
##verbatim 'O' = Code.Dot.verbatim
##verbatim 'X' = Code.Raw__.verbatim

open Printf

module Argument = struct
  let dir_init = Sys.argv.(1)

  let dir_img = sprintf \"%s/doc/img/%d.png\" dir_init
  let file_arm6 = sprintf \"%s/../../simsoc-cert-cc1.9/arm6/arm6.pdf\" dir_init
  let page_middle = sprintf \"%s/doc/img/page_middle.png\" dir_init

  let img1 = dir_img 1
  let img2 = dir_img 2
  let img3 = dir_img 3
  let img4 = dir_img 4
end

let red_ = Color.of_int_255 (0x9F, 0x00, 0x00)
let red = Color.textcolor_ red_
let orange = Color.of_int_255 (0xFF, 0xED, 0xDF)
let blue = Color.textcolor_ Color.blue

let sh4_intro = "The generated {S.Manual.Sh.C.gcc} ({Version.Size.manual_sh4}K) contains a part similar as this program: "
let sl_intro x = "The {x} ({Version.Cpp11_bis.simlight2_no_man_size}K without manual) contains a part similar as: "

let index_ s x = index s (footnotesize x)

let () =
  main
    ~packages:[]
    ~author:[ footnotesize (mail \"tuong@users.gforge.inria.fr\") ]

    (Beamer (Some (`Em 1., `Em 1.), B.Abr
[ B.Center ("", "")

(* ********************************************************* *)
; B.Abr (BatList.map
           (fun (page, y, trim_top) ->
             B.Center
               ("Example: page in the ARMv6 manual (p. " ^^ latex_of_int page ^^ ")",
                includegraphics ~x:(-1.) ~y ~trim:(`Mm 0., `Mm 0., `Mm 0., `Mm trim_top) ~page ~scale:0.9 Argument.file_arm6))
           [ 158, -5.5, 25.
           ; 159, -6., 20. ])

(* ********************************************************* *)
; B.Center ("{P.simcert}, code generation from the manual",
            let open Code.Dot in
            let deepskyblue = Color.of_int_255 (0x00, 0xBF, 0xFF) in
            let module S = S_sz (struct let normal = normalsize let footnote = footnotesize let tiny = tiny let color_keyword = Some deepskyblue end) in
            let dodgerblue = Color.color_name_ (Color.of_int_255 (0x1E, 0x90, 0xFF)) in
            let floralwhite = B "deepskyblue" in
            let style_back = B "[style=\"angle 45-\"]" in
"<OO{ Header { shift_x = 0.
             ; shift_y = -8.3
             ; scale = Some 0.6
             ; node = { n_color = \"darksalmon\" ; shape = Note }
             ; edge = { e_color = Some dodgerblue ; style = Some \"-angle 45\" } } }O

  arm_pdf [texlbl="ARMv6.pdf"]
  arm_txt [texlbl="ARMv6.txt"]

  patch1 [shape=none, texlbl="patch \& extract"]
  patch2 [shape=none, texlbl="patch \& extract"]
  patch3 [shape=none, texlbl="patch \& extract"]

  subgraph cluster_ocaml {
    style="dashed, rounded"
    color=O{floralwhite}O
    ast_deco [texlbl="IS encoding"]
    ast_asm [texlbl="ASM syntax"]
    ast_pseudo [texlbl="pseudo-code"]

    intern_merge [shape=none, texlbl="merge \& preprocess"]
    intern_ocaml [texlbl="internal representation of the AST in O{textcolor_ deepskyblue P.ocaml}O"]

    out_coq_ [shape=none, texlbl="O{multiline_ \"monadic higher order\nfactoring\"}O"]
    out_simlight_ [shape=none, texlbl="O{multiline_ \"normalization, flattening\nand specialization\"}O"]
  }

  out_coq [style=filled, fillcolor=papayawhip, texlbl="shallow embedding to O{textcolor_ deepskyblue "Coq"}O"]
  out_coq_to [shape=none, texlbl="copy"]
  out_simlight [style=filled, fillcolor=papayawhip, texlbl="fast ISS (O{textcolor_ deepskyblue S.C.gcc}O/C++)"]
  out_simlight_to [shape=none, texlbl="copy"]

  subgraph cluster_simsoc {
    style="dashed, rounded"
    color=O{floralwhite}O
    cluster_simsoc_title [shape=none, texlbl="O{multiline_ \"SimSoC\n(C++/SystemC)\"}O"]
    subgraph cluster_simsoc_arm {
      style=dotted
      cluster_simsoc_arm_title [shape=none, texlbl="O{multiline ["ARMv6" ; S.SL.C.gcc ]}O"]
      simsoc_mmu [texlbl="MMU"]
      simsoc_iss [style=filled, fillcolor=papayawhip, texlbl="fast ISS (O{textcolor_ deepskyblue S.C.gcc}O/C++)"]
    }
    simsoc_peri [texlbl="O{multiline_ \"memory\nand peripherals\"}O"]
  }

  subgraph cluster_simcoq {
    style="dashed, rounded"
    color=O{floralwhite}O
    cluster_simcoq_title [shape=none, texlbl="O{multiline [ "ARMv6" ; S.SL.coq ]}O"]
    simcoq_iss [style=filled, fillcolor=papayawhip, texlbl="O{multiline [ "shallow" ; "embedding" ; "to {Color.textcolor_ deepskyblue "Coq"}" ]}O"]
  }

  /* */
  cluster_simsoc_title -> cluster_simsoc_arm_title -> simsoc_iss -> simsoc_mmu -> simsoc_peri -> out_simlight_to [style=invis]
  cluster_simcoq_title -> simcoq_iss [style=invis]

  /* */
  arm_pdf -> arm_txt [label="pdftotext", constraint=false]
  arm_txt -> patch1 -> ast_deco
  arm_txt -> patch2 -> ast_asm
  arm_txt -> patch3 -> ast_pseudo

  ast_deco -> intern_merge
  ast_asm -> intern_merge
  ast_pseudo -> intern_merge

  intern_merge -> intern_ocaml

  intern_ocaml -> out_coq_ -> out_coq
  intern_ocaml -> out_simlight_ -> out_simlight

  simcoq_iss -> out_coq_to O{style_back}O
  out_coq_to -> out_coq O{style_back}O

  simsoc_iss -> out_simlight_to O{style_back}O
  out_simlight_to -> out_simlight O{style_back}O

O>")

(* ********************************************************* *)
; B.Abr (let open Code.Dot in
         let edge_to_normal = \"-triangle 45\" in
         BatList.map
           (fun (fct_edge, darksalmon, draw_red, attr_error) ->
             B.Bottom
               ("CompCert, semantic preservation proved in {P.coq}",
                minipage (`Cm 3.5)
                  (Label.notation_ (itemize [ "``{red S.C.compcert}'': first AST defined in Coq"
                                            ; "``{red S.C.asm}'': last AST defined in Coq"
                                            ]))
                ^^
                let edge_to_fct dir = B (concat [ "[" ; text (sprintf \"style=%S,\" (match dir with `normal -> \"-stealth\" | `back -> \"stealth-\")) ; "color={darksalmon}]" ]) in
                let edge_to dir = B (concat [ "[" ; text (sprintf \"style=%S,\" (match dir with `normal -> edge_to_normal | `back -> \"triangle 45-\")) ; "color={draw_red}]" ]) in
"<OO{ Header { shift_x = -2.9
             ; shift_y = -0.2
             ; scale = None
             ; node = { n_color = \"mediumseagreen\" ; shape = Box true }
             ; edge = { e_color = None ; style = None } } }O

  /* nodes */
  compcert_c [texlbl="O{B S.C.compcert}O"]
  clight [texlbl="Clight"]
  c_minor [texlbl="CO{symbolc '#'}Ominor"]
  cminor [texlbl="Cminor"]
  cminorsel [texlbl="CminorSel"]
  rtl [texlbl="RTL"]
  ltl [texlbl="LTL"]
  ltlin [texlbl="LTLin"]
  linear [texlbl="Linear"]
  mach [texlbl="Mach"]
  asm [texlbl="O{B S.C.asm}O"]

  error O{attr_error}O

  /* nodes: "fct" version */
  compcert_c_fct [shape=point, style=invis]
  clight_fct [shape=point, style=invis]
  c_minor_fct [shape=point, style=invis]
  cminor_fct [shape=point, style=invis]
  cminorsel_fct [shape=point, style=invis]
  rtl_fct [shape=point, style=invis]
  ltl_fct [shape=point, style=invis]
  ltlin_fct [shape=point, style=invis]
  linear_fct [shape=point, style=invis]
  mach_fct [shape=point, style=invis]

  /* */
  compcert_c -> rtl [style=invis]
  clight -> cminorsel [style=invis]
  cminorsel -> ltlin [style=invis]
  cminor -> linear [style=invis]
  ltlin -> asm [style=invis]

  compcert_c_fct -> cminorsel_fct [style=invis]
  clight_fct -> cminor_fct [style=invis]
  cminorsel_fct -> ltl_fct [style=invis]
  cminor_fct -> ltlin_fct [style=invis]
  ltlin_fct -> mach_fct [style=invis]

  /* */
  { rank = same ;
    compcert_c -> compcert_c_fct O{edge_to_fct `normal}O
    compcert_c_fct -> clight O{edge_to `normal}O
    clight -> clight_fct O{edge_to_fct `normal}O
    clight_fct -> c_minor O{edge_to `normal}O }
  c_minor -> c_minor_fct O{edge_to_fct `normal}O
  c_minor_fct -> cminor O{edge_to `normal}O
  { rank = same ;
    rtl -> cminorsel_fct O{edge_to `back}O
    cminorsel_fct -> cminorsel O{edge_to_fct `back}O
    cminorsel -> cminor_fct O{edge_to `back}O
    cminor_fct -> cminor O{edge_to_fct `back}O }
  rtl -> rtl_fct O{edge_to_fct `normal}O
  rtl_fct -> ltl O{edge_to `normal}O
  { rank = same ;
    ltl -> ltl_fct O{edge_to_fct `normal}O
    ltl_fct -> ltlin O{edge_to `normal}O
    ltlin -> ltlin_fct O{edge_to_fct `normal}O
    ltlin_fct -> linear O{edge_to `normal}O }
  linear -> linear_fct O{edge_to_fct `normal}O
  linear_fct -> mach O{edge_to `normal}O
  { rank = same ;
    asm -> mach_fct O{edge_to `back}O
    mach_fct -> mach O{edge_to_fct `back}O }

  /* */
  compcert_c_fct -> error O{fct_edge}O
  clight_fct -> error O{fct_edge}O
  c_minor_fct -> error O{fct_edge}O
  cminor_fct -> error O{fct_edge}O
  cminorsel_fct -> error O{fct_edge}O
  rtl_fct -> error O{fct_edge}O
  ltl_fct -> error O{fct_edge}O
  ltlin_fct -> error O{fct_edge}O
  linear_fct -> error O{fct_edge}O
  mach_fct -> error O{fct_edge}O

O>"))
           (let monad = index_ bot "monad" in
            [ ( let darksalmon = Color.color_name_ (Color.of_int_255 (0x3C, 0xB3, 0x71)) in
               B "[style=invis]"
             , darksalmon
             , darksalmon
             , B "[texlbl=\"{phantom monad}\", color=white]" )

           ; ( B ("[style=\"" ^^ text edge_to_normal ^^ "\",color={Color.color_name_ (Color.of_int_255 (0xF5, 0xA7, 0x5F))}]")
             , Color.color_name_ (Color.of_int_255 (0x3C, 0xB3, 0x71))
             , Color.color_name_ (let i = 200 in Color.of_int_255 (i, i, i))
             , B "[texlbl=\"{monad}\"]" ) ]))

(* ********************************************************* *)
; B.Top ("CompCert, the generation{newline}from {P.coq} to {P.ocaml}",
         minipage (`Cm 5.)
           (Label.notation_ (itemize [ "``{red S.C.human}'': an arbitrary sequence of character"
                                     ; "``{red S.C.compcert}'': programs compiled successfully with {Version.compcert} <!-dc!>"
                                     ; "``{red S.C.asm}'': programs compiled successfully with {Version.compcert} <!-dasm!>" ]))
         ^^
         let open Code.Dot in
         let darksalmon_ = Color.of_int_255 (0xF5, 0xA7, 0x5F) in
         let darksalmon = color_name_ darksalmon_ in
         let mediumseagreen_ = Color.of_int_255 (0x3C, 0xB3, 0x71) in
         let mediumseagreen = color_name_ mediumseagreen_ in
         let deepskyblue = Color.of_int_255 (0x00, 0xBF, 0xFF) in
         let floralwhite = B "deepskyblue" in
         let ocaml = texttt (Color.textcolor_ deepskyblue P.ocaml) in
         let coq = texttt (Color.textcolor_ deepskyblue P.coq) in
         let gcc = texttt (Color.textcolor_ deepskyblue S.C.gcc) in
         let col_fct = Color.textcolor_ darksalmon_ in
         let black s = small (emph (Color.textcolor_ (let i = 0x86 in Color.of_int_255 (i, i, i)) s)) in
         let greentriangleright = Color.textcolor_ mediumseagreen_ "{blacktriangleright}" in
"<OO{ Header { shift_x = -2.0
             ; shift_y = -6.2
             ; scale = Some 0.9
             ; node = { n_color = \"mediumseagreen\" ; shape = Box true }
             ; edge = { e_color = None ; style = Some \"-triangle 45\" } } }O

  subgraph cluster_coq {
    style="dashed, rounded"
    color=O{floralwhite}O

    compcert_c [texlbl="O{B S.C.compcert}O"]
    asm [texlbl="O{B S.C.asm}O"]

    compcert_c_fct [texlbl="O{multiline [ col_fct (ocaml ^^ "-compiling") ; black ("(generated from " ^^ coq ^^ ")")]}O", color=darksalmon]

    compcert_c -> compcert_c_fct [color=O{mediumseagreen}O]
  }

  subgraph cluster_other1 {
    style="dashed, rounded"
    color=O{floralwhite}O

    human_c [texlbl="O{B S.C.human}O"]
    human_c_fct [texlbl="O{multiline [ col_fct (gcc ^^ "-preprocessing {greentriangleright} " ^^ ocaml ^^ "-parsing") ; black ("(not yet generated from " ^^ coq ^^ ")") ]}O", color=darksalmon]
    human_c -> human_c_fct [color=O{mediumseagreen}O]

  }

  subgraph cluster_other2 {
    style="dashed, rounded"
    color=O{floralwhite}O

    asm_fct [texlbl="O{multiline [ col_fct (ocaml ^^ "-printing {greentriangleright} " ^^ gcc ^^ "-linking") ; black ("(not yet generated from " ^^ coq ^^ ")") ] }O", color=darksalmon]
    exec [texlbl="executable"]
    asm_fct -> exec [color=O{mediumseagreen}O]
  }

  human_c_fct -> compcert_c [color=O{mediumseagreen}O]
  compcert_c_fct -> asm [color=O{mediumseagreen}O]
  asm -> asm_fct [color=O{mediumseagreen}O]

  error [texlbl="O{B (index_ bot "monad")}O"]
  compcert_c_fct -> error [color=O{darksalmon}O]
  human_c_fct -> error [color=O{darksalmon}O]
  asm_fct -> error [color=O{darksalmon}O]

O>")

(* ********************************************************* *)
; B.Center ("{P.simcert}, towards the correctness proof",
            let open Code.Dot in
            let deepskyblue = Color.of_int_255 (0x00, 0xBF, 0xFF) in
            let module S = S_sz (struct let normal = normalsize let footnote = footnotesize let tiny = tiny let color_keyword = Some deepskyblue end) in
            let module SL_p = S.SL_gen (struct let sl = "PROGRAM" end) in
            let dodgerblue = Color.color_name_ (Color.of_int_255 (0x1E, 0x90, 0xFF)) in
            let firebrick = color_name_ (Color.of_int_255 (0xB2, 0x22, 0x22)) in
            let floralwhite = B "deepskyblue" in
            let style_back = B "style=\"angle 45-\"" in
"<OO{ Header { shift_x = -0.8
             ; shift_y = -6.6
             ; scale = Some 0.8
             ; node = { n_color = \"darksalmon\" ; shape = Box false }
             ; edge = { e_color = Some dodgerblue ; style = Some \"-angle 45\" } } }O

  pdf_sh [shape=note, texlbl="O{multiline [S.Manual.Sh.C.human ; "(pdf)"]}O"]
  pdf_txt_sh [shape=note, style=filled, fillcolor=papayawhip, texlbl="O{multiline [S.Manual.Sh.C.human ; "(txt)"]}O"]

  pseudocode [shape=ellipse, style=dashed, color=dodgerblue, texlbl="O{ multiline [ "pseudo-code and" ; "decoder generator" ] }O"]

  subgraph cluster_simsoc {
    style="dashed,rounded"
    color=O{floralwhite}O

    subgraph cluster_simlight {
      style=bold
      color=darksalmon
      iss [shape=note, style=filled, fillcolor=papayawhip, texlbl="O{B S.Manual.Sh.C.compcert}O"]
      simlight_dots [shape=note, texlbl="O{ multiline [ S.SL.C.compcert ; "libraries" ] }O"]
    }
  }

  subgraph cluster_coq {
    style="dashed,rounded"
    color=O{floralwhite}O

    mid [shape=ellipse, style=dashed, color=dodgerblue, texlbl="O{ multiline [ "deep embedded" ; "pretty-printer" ; "for {S.C.compcert}" ] }O"]

    subgraph cluster_compcert_simlight {
      style=bold
      color=darksalmon
      bgcolor=papayawhip
      coq_src2 [shape=note, style=filled, fillcolor=papayawhip, texlbl="O{B S.Manual.Sh.Coq.Deep.compcert}O"]
      coq_src_dot [shape=note, texlbl="O{ multiline [ S.SL.Coq.Deep.compcert ; "libraries" ] }O"]
    }

    subgraph cluster_simulateur {
      style=bold
      color=darksalmon
      coq_src1 [shape=note, style=filled, fillcolor=papayawhip, texlbl="O{B S.Manual.Sh.coq}O"]
      coq_src_simul_dot [shape=note, texlbl="O{ multiline [ S.SL.coq ; "libraries" ] }O"]
    }

    coq_proof [shape=note, color=firebrick, texlbl="O{ multiline [ "Correctness proof :" ; S.SL.coq ; "{leftrightarrow_}" ; "{S.SL.Coq.Deep.compcert} ?" ] }O"]
  }

  /* */
  iss -> simlight_dots [style=invis]
  coq_src2 -> coq_src_dot [style=invis]
  coq_src1 -> coq_src_simul_dot [style=invis]
  pdf_sh -> coq_src1 [style=invis]

  /* */
  pdf_sh -> pdf_txt_sh [label="pdftotext", constraint=false]
  pdf_txt_sh -> pseudocode [constraint=false]
  pseudocode -> iss
  pseudocode -> coq_src1
  simlight_dots -> mid [ltail=cluster_simlight]
  coq_src_dot -> mid [ltail=cluster_compcert_simlight, O{style_back}O]
  coq_src_dot -> coq_proof [color=O{firebrick}O, ltail=cluster_compcert_simlight]
  coq_src_simul_dot -> coq_proof [color=O{firebrick}O, ltail=cluster_simulateur]

O>")

(* ********************************************************* *)
; B.Abr (let title x = "Example: page in the {S.Manual.Sh.C.human} (p. " ^^ x ^^ ")" in
         [ B.Center (let page = 234 in title (latex_of_int page), includegraphics ~x:(-0.5) ~y:(-.5.0) ~scale:0.7 \"sh4_and.pdf\")
         ; B.Center (title "234 middle", includegraphics ~x:(-0.5) ~y:(-1.) ~scale:0.4 Argument.page_middle) ])

(* ********************************************************* *)
; B.Abr
  (let sh4_example =
     BatList.map
       (fun (x, trim_top, img, title) ->
         B.Center ("Example: conversion to text" ^^ title, includegraphics ~x ~y:(-1.) ~trim:(`Mm 0., `Mm 0., `Mm 0., `Mm trim_top) ~scale:0.6 img)) in

   BatList.map (fun x -> B.Abr x)
     [ sh4_example
         [ 0., 55., Argument.img1, " and syntax error"
         ; -1., 52., Argument.img3, " and syntax error"
         ; 0., 52., Argument.img2, " and type error" ]

     ; (let l =
          let open English in
          let s1, s2 =
            "The compilation correctly terminates with {Version.gcc}.",
            Label.question_ "Does it compile with {P.compcert}?" in
          [ [ yes ; yes   ; maybe ], Some (s1 ^^ s2)
          ; [ yes ; yes   ; no    ], Some (s1
                                           ^^
                                           Label.problem_ "``<!unsigned long!>'' is not supported in {Version.compcert} (inside ``struct'')."
                                           ^^
                                           Label.fix_ "Generate every ``<!unsigned long!>'' to ``int'' so that {S.Manual.Sh.C.gcc} {in_} {S.C.compcert}.") ] in
        let lg = latex_of_int (BatList.length l) in
        BatList.mapi
          (fun pos (h_comment, msg) ->
            B.Top ("Example: limitation of {P.compcert}", (*  [{latex_of_int (Pervasives.succ pos)}/{lg}] *)
                   sh4_intro
                   ^^
                   "<@@{H_comment h_comment }@
struct S { unsigned long i:1 }
main () {}
@>"
                   ^^
                   (match msg with None -> "" | Some s -> s)))
          l)
     ; sh4_example [ 0., 55., Argument.img4, "" ] ])

(* ********************************************************* *)
; B.Center ("Example: fragment of patch in OCaml",
"<~
[ [ Replace_all ("&&", "&"), p [ 1065 ]
    (* not Coq well typed otherwise *)
  ; Replace_all ("(long i)", "i"), [ R (1077, 2) ] ]
; [ comment_first ", int *FPUL", p [ 4003 ; 4008 ; 6913 ; 6918 ]
  ; Replace_first (S "*FPUL", "FPUL"), p [ 4005 ; 4010 ; 6915 ; 6921 ; 2113 ; 2116 ] ]
; [ Replace_all ("TLB[MMUCR. URC] ", "TLB_MMUCR_URC"), [ R (4162, 13) ] ]
; [ Replace_first (S "MACL", "MACL_"), p [ 4222 ]
  ; Replace_first (S "STS", "STS_"), p [ 6924 ] ]
(* type error *)
; [ Replace_first (S "MACH&0x00008000",
                   "bool_of_word(MACH&0x00008000)"), p [ 4290 ] ]
(* simplifying *)
; [ Replace_first (All, "if_is_write_back_memory_and_look_up_in_operand_cache_eq_miss_then_allocate_operand_cache_block(R[n]);"), [ R (5133, 3) ]
  ; Replace_first (Re "(is_dirty_block(R\\[n\\])) +write_back(R\\[n\\]);?"
                  , "_is_dirty_block_then_write_back(R[n]);"), p [ 5502 ; 5543 ] ] ]
~>")
(*
"<~
[ [ Replace_tilde 2, p [ 1434 ; 1439 ; 4276 ; 4279 ]
  ; Replace_tilde 1, p [ 5424 ; 6115 ; 6277 ] ]
; [ Add_char_end ";", p [ 1502 ; 6932 ]
  ; Replace_first (S ",", ";"), p [ 3871 ]
  ; Replace_first (S "Lo", "lo"), p [ 3955 ]
  ; Replace_first (S "}", "{"), p [ 4555 ]
  ; Replace_first (S "long n", "long n)"), p [ 4979 ]
  ; Replace_first (S "((", "("), p [ 5280 ]
  ; Replace_all ("–=", "-="), [ R (6713, 151) ]
  ; Replace_first (S "H'", "H_"), p [ 7302 ] ]

; [ add_int_type, p [ 6103 ; 6269 ]
  ; Replace_first (S "d, n", "int d, int n"), p [ 4746 ] ] ]
~>"
*)

(* ********************************************************* *)
; B.Center ("Patching the {S.Manual.Sh.C.human}",
            "Patching data = 8K (without counting blanks)" ^^ vspace (`Em 1.)
            ^^
            let perc n =
              Color.textcolor_ (Color.of_int_255 (0xCF, 0x5C, 0x16)) ((latex_of_int n) ^^ "%") in
            tabular [`L;`Vert;`R;`Vert;`R;`Vert;`R;`Vert;`R]
              [ Data [S.Manual.Sh.C.human; "words" ; "common" ; "" ; "changed" ]
              ; Hline
              ; Data [""; "" ; "" ; "deleted" ; "" ]
              ; Data ["original.txt" ; "86980" ; "85070 {perc 98}" ; "499 {perc 1}" ; "1411 {perc 2}"]
              ; Hline
              ; Data [""; "" ; "" ; "inserted" ; "" ]
              ; Data ["patched.txt" ; "87372" ; "85070 {perc 97}" ; "872 {perc 1}" ; "1430 {perc 2}"] ])

(* ********************************************************* *)
; B.Abr
  (let l =
     let open English in
     [ [ yes ; yes ; maybe ; maybe ], Some (Label.problem_ "Does it compile with {P.compcert}?")
     ; [ yes ; yes ; no ; no ], Some (concat_line_t [ "No, 64 bits value are not supported in {Version.compcert}."
                                                    ; "Remark: {notin} {S.C.compcert} {rightarrow_} {notin} {S.C.asm}." ]
                                      ^^
                                      Label.fix_ "Emulate operations on 64 bits data structure with a 32 bits library, then {S.SL.ArmSh.C.gcc} {in_} {S.C.asm}.") ] in
   let lg = latex_of_int (BatList.length l) in
   BatList.mapi
     (fun pos (h_comment, msg) ->
       B.Top ("Example: typing {S.SL.ArmSh.C.gcc} with {P.compcert}",  (*[{latex_of_int (Pervasives.succ pos)}/{lg}]*)
              vspace (`Em 1.)
              ^^
              sl_intro S.SL.ArmSh.C.gcc
              ^^
              "<@@{H_comment h_comment}@
#include <inttypes.h>

void main() {
  int64_t x = 0;
}
@>"
              ^^
              (match msg with None -> "" | Some s -> s)))
     l)

(* ********************************************************* *)
; B.Abr
  (let (tit1, l1), (tit2, l2), (tit3, l3) =
     let open English in
     let in__ = "{in_}" in
  (** *)
     ("",
      [ [ yes ; yes   ; maybe ; maybe ], Some (tabular (BatList.init 3 (fun _ -> `L))
                                                 [ Data [ "{S.SL.ArmSh.C.human} {in__}" ; S.C.gcc ; "" ]
                                                 ; Data []
                                                 ; Data [] ]
                                               ^^
                                               Label.problem_ "Does it compile with {P.compcert} ?")

      ; [ yes ; yes   ; yes   ; maybe ], Some (tabular (BatList.init 3 (fun _ -> `L))
                                                 [ Data [ "{S.SL.ArmSh.C.human} {in__}" ; S.C.gcc ; "" ]
                                                 ; Data [ "" ; "{S.SL.ArmSh.C.gcc} {in__}" ; S.C.compcert ]
                                                 ; Data [] ]
                                               ^^
                                               Label.fact "The compilation correctly terminates with {Version.compcert} <!-dc!>.")

      ; [ yes ; yes   ; yes   ; yes   ], Some (tabular (BatList.init 3 (fun _ -> `L))
                                                 [ Data [ "{S.SL.ArmSh.C.human} {in__}" ; S.C.gcc ; "" ]
                                                 ; Data [ "" ; "{S.SL.ArmSh.C.gcc} {in__}" ; S.C.compcert ]
                                                 ; Data [ "" ; "" ; "{S.SL.ArmSh.C.compcert} {in__} {S.C.asm}" ] ]
                                               ^^
                                               Label.fact "The compilation correctly terminates with {Version.compcert} <!-dasm!>.")

      ; [ yes ; yes   ; yes   ; yes   ], Some (Label.problem_ "Where is the problem?") ]),

  (** *)
     (", towards validation",
      [ [ yes ; yes   ; yes   ; yes   ],
        (Some "At runtime, tests fail. Indeed, <!line 1!> is not always equal to <!line 2!>:{
texttt (tabular (interl 4 `L)
    [ Data [ "" ; "gcc -m64" ; Color.cellcolor_ orange ^^ "gcc -m32 -O0" ; "gcc -m32 -O1" ]
    ; Data [ "" ; "" ; Color.cellcolor_ orange ^^ "{textrm P.compcert} ia32-linux" ; "gcc -m32 -O2" ]
    ; Data [ "" ; "" ; Color.cellcolor_ orange ; "gcc -m32 -O3" ]
    ; Hline
    ; Data [ "line 1" ; blue "100000000" ; Color.cellcolor_ orange ^^ blue "1" ; blue "0" ]
    ; Data [ "line 2" ; blue "100000000" ; Color.cellcolor_ orange ^^ blue "0" ; blue "0" ] ]) }
{newline}
Remark: {blue "<!Int32.shift_left 1_l 32!>"} ${overset P.ocaml longrightarrow}$ {blue "<!1_l!>"}.")

      ; [ yes ; yes   ; yes   ; yes   ], Some (Label.warning_ "From {S.C.human}, {Version.compcert} sometimes performs as heuristic an external call to the <!gcc -m32 -O0!> preprocessor (which wrongly optimizes here)."
                                               ^^
                                               Label.fix_ "Regenerate the {S.Manual.ArmSh.C.compcert} so that it computes the shift ``<!<<!>'' with 64 bits value as argument everywhere used.") ]),

  (** *)
     ("", [ (*[ yes ; yes   ; yes   ; yes   ],
       (Some "As remark:
{
texttt (tabular (interl 3 `L)
    [ Data [ "" ; "gcc -m64" ; Color.cellcolor_ orange ^^ "gcc -m32 -O0" ]
    ; Data [ "" ; "gcc -m32 -O1" ; Color.cellcolor_ orange ^^ textrm P.compcert ]
    ; Data [ "" ; "gcc -m32 -O2" ; Color.cellcolor_ orange ]
    ; Data [ "" ; "gcc -m32 -O3" ; Color.cellcolor_ orange ]
    ; Hline
    ; Data [ "line 1" ; blue "ffffffff" ; Color.cellcolor_ orange ^^ blue "0" ]
    ; Data [ "line 2" ; blue "ffffffff" ; Color.cellcolor_ orange ^^ blue "ffffffff" ] ]) }")*) ]) in
   let lg1, lg2 = BatList.length l1, BatList.length l2 in
   let lg = latex_of_int (lg1 + lg2 + BatList.length l3) in
   let title tit pos lg = "Example: limitation of {P.compcert}" ^^ tit (*^^ " [{latex_of_int (Pervasives.succ pos)}/{lg}]"*) in
   [ B.Abr
       (BatList.mapi
          (fun pos (h_comment, msg) ->
            B.Top (title tit1 pos lg,
                   sl_intro S.SL.ArmSh.C.gcc
                   ^^
                   "<@@{H_comment h_comment}@
#include <stdio.h>
void main() {                int i = 32 ;
  return(                1lu <<  i)     ;
                                          }
@>"
                   ^^
                   (match msg with None -> "" | Some s -> s)))
          l1)

  (* FIXME factorize with above  ***************************** *)
   ; B.Abr
     (BatList.mapi
        (fun pos (h_comment, msg) ->
          B.Top (title tit2 (lg1 + pos) lg,
                 sl_intro S.SL.ArmSh.C.gcc
                 ^^
                 "<@@{H_comment h_comment}@
#include <stdio.h>
void main() {                int i = 32 ;
  printf("line 1 %lx\n", 1lu <<  i)     ;
  printf("line 2 %lx\n", 1lu << 32)     ; }
@>"
                 ^^
                 (match msg with None -> "" | Some s -> s)))
        l2)

  (* FIXME factorize with above  ***************************** *)
   ; B.Abr
     (BatList.mapi
        (fun pos (h_comment, msg) ->
          B.Top (title tit3 (lg1 + lg2 + pos) lg,
                 sl_intro S.SL.ArmSh.C.gcc
                 ^^
                 "<@@{H_comment h_comment}@
#include <stdio.h>
void main() {                 int i = 32  ;
  printf("line 1 %lx\n", (1lu <<  i) - 1) ;
  printf("line 2 %lx\n", (1lu << 32) - 1) ; }
@>"
                 ^^
                 (match msg with None -> "" | Some s -> s)))
        l3) ])

(* ********************************************************* *)
; B.Abr (BatList.map
           (fun body -> B.Center ("Printing the {S.C.compcert} AST", body))
[ "<#
Inductive floatsize : Type :=
  | F32 : floatsize
  | F64 : floatsize.
Inductive type : Type :=
  | Tvoid : type
  | Tfloat : floatsize -> type
  | Tfunction : typelist -> type -> type
with typelist : Type :=
  | Tnil : typelist
  | Tcons : type -> typelist -> typelist.
Definition ident := positive.
Record program (A : Type) : Type := mkprogram
  { prog_funct : list (ident * A);
  ; prog_main : ident }.
Definition ast := program type.
#>"; "<#
Check _floatsize : floatsize -> s.
Check _type : type -> s.
Check _typelist : typelist -> s.
Check _ident : ident -> s.
Check _program : forall A, (A -> s) -> program A -> s.
Check _ast : ast -> s.
#>"; "<#
Definition _floatsize := __floatsize
  | "F32"
  | "F64".
Definition _type_ T (ty : #{PPP}#) := ty _ _floatsize
  | "Tvoid"
  | "Tfloat"
  | "Tfunction"
  | "Tnil"
  | "Tcons".
  Definition _type := _type_ _ (@__type).
  Definition _typelist := _type_ _ (@__typelist).
Definition _ident := _positive.
Definition _program {A} #{PPP}# := @__program #{PPP}#
  {{ "prog_funct" ; "prog_main" }}.
Definition _ast := _program _type.
#>"; "<#
  Notation "A ** n" := (A ^^ n --> A) (at level 29) : type_scope.

Check _INDUCTIVE : string -> forall n, s ** n.
  Notation "| x" := (_INDUCTIVE x _) (at level 9).

Check _RECORD : forall n, vector string n -> s ** n.
  Notation "{{ a ; .. ; b }}" :=
    (_RECORD _ (Vcons _ a _ .. (Vcons _ b _ (Vnil _)) ..)).
#>"; "<#
  Notation "A [ a ; .. ; b ] -> C" :=
    (A ** a -> .. (A ** b -> C) ..) (at level 90).

Definition __floatsize {A} : A [ 0   (* F32       :           _ *)
                               ; 0 ] (* F64       :           _ *)
                             -> _ := #{PPP}#.
Definition _type_ A B (f : _ -> Type) := f (
                             A [ 0   (* Tvoid     :           _ *)
                               ; 1   (* Tfloat    : _ ->      _ *)
                               ; 2   (* Tfunction : _ -> _ -> _ *)
                               ; 0   (* Tnil      :           _ *)
                               ; 2 ] (* Tcons     : _ -> _ -> _ *)
                             -> B).
Definition __type {A} : _type_ A _ (fun ty => _ -> ty) := #{PPP}#.
Definition __typelist {A} : _type_ A _ (fun ty => _ -> ty) := #{PPP}#.
#>"])

(* ********************************************************* *)
; B.Center ("The generated {S.Decoder.Sh.coq}",
"Decode a given word (16, 32 bits...) to instruction to be executed later.
<Z
Local Notation "0" := false.
Local Notation "1" := true.
Definition decode (w : word) : Z{PPP}Z := match w16_of_word w with
Z{PPP}Z
(* 9.4.1 ANDI *)
| word16 1 1 0 0 1 0 0 1 _ _ _ _ _ _ _ _ => DecInst _ (ANDI w[n7#n0])
(* 9.4.2 ANDM *)
| word16 1 1 0 0 1 1 0 1 _ _ _ _ _ _ _ _ => DecInst _ (ANDM w[n7#n0])
Z{PPP}Z
| _ => DecUndefined_with_num inst 0
end.
Z>")
(* "<~
; ("Format                     Summary of Operation        Instruction Code       States    T Bit",
   "AND     Rm,Rn              Rm & Rm \226\134\146 Rn               ",
   [(I_1, 1); (I_0, 2); (I_1, 1); (I_m, 4); (I_n, 4); (I_0, 1); (I_1, 1); (I_0, 2); ])
; ("Format                     Summary of Operation        Instruction Code       States    T Bit",
   "AND     #imm,R0            R0 & imm \226\134\146 R0              ",
   [(I_i, 8); (I_1, 1); (I_0, 2); (I_1, 1); (I_0, 2); (I_1, 2); ])
; ("Format                     Summary of Operation        Instruction Code       States    T Bit",
   "AND.B #imm,@(R0,GBR) (R0+GBR) & imm \226\134\146                 ",
   [(I_i, 8); (I_1, 1); (I_0, 1); (I_1, 2); (I_0, 2); (I_1, 2); ])
~>" *)

(* ********************************************************* *)
; B.Abr
  (let s = "S" in
   let module SL_p = S.SL_gen (struct let sl = s end) in
   BatList.map
     (fun after ->
       B.Top ("{S.SL.coq} ${overset "?" "="}$ {S.SL.Coq.Deep.compcert}, towards {S.C.lambda_l}",
                 Label.warning_
                   (concat [ "The semantic preservation proof developed in {P.compcert} requires some non-trivial extra hypothesis to be provided:"
                           ; newline
                           ; "<!val compiler : !>{S.P.Coq.Deep.compcert}<! -> !>{langle}{S.P.Coq.Deep.asm}{index_ rangle "monad"}"
                           ; newline
                           ; "<!val proof    : !>{forall}<! behavior, !>{forall}<! P, !>{(*red*) "<!compiler P !>{ne} {index_ bot "monad"}"}<! -> !>"
                           ; newline
                           ; "{red "<!    exec_behaves behavior P!>"}<! -> !>{langle}<!P !>{index_ approx "<!behavior!>"}<! compiler P!>{index_ rangle "monad"}" ])
                 ^^
                 after ))
     [ Label.example
         (itemize
            [ "{blue "<!exec_behaves converge  P!>"} ${overset "<!proof!>" longrightarrow}$ {blue "<!P !>{index_ approx "<!converge!>"}<! compiler P!>"}"
            ; "{blue "<!exec_behaves diverge   P!>"} ${overset "<!proof!>" longrightarrow}$ {blue "<!P !>{index_ approx "<!diverge !>"}<! compiler P!>"}"
            ; "{blue "<!exec_behaves get_stuck P!>"} ${overset "<!proof!>" longrightarrow}$ {blue "{index_ bot "monad"}"}" ])
     ; Label.problem_
                   "Is there some {red "<!b!>"} such that ``{red "<!exec_behaves b !>{S.SL.Coq.Deep.compcert}"}''?"
                 ^^ pause ^^
                 Label.definition_
                   ("``{red S.C.lambda_l}'': {S.C.asm} sources {texttt s} equipped with these proofs in Coq~:"
                    ^^
                      enumerate [ "{SL_p.Coq.Deep.asm} obtained successfully, i.e. {ne} {index_ bot "monad"}"
                                ; "{exists} <!b!> {in_} \{<!converge!>, <!diverge!>\}, <!exec_behaves b !>{SL_p.Coq.Deep.compcert}" ])])

(* ********************************************************* *)
; B.Abr
  (let l =
     let open English in
     let s =
       "The compilation to {S.C.asm} succeeds. Then to be in {S.C.lambda_l}, the first hypothesis is met."
       ^^
       Label.question_ "What about its behavior, does this program converge, diverge or get stuck?" in
     [ [ yes ; yes   ; yes   ; yes   ; maybe ], Some s
     ; [ yes ; yes   ; yes   ; yes   ; no    ], Some (s
                                                      ^^
                                                      Label.warning_ "The type of ``main'' is not of the form {texttt "unit {rightarrow} int"}. So {S.SL.C.asm} initially goes wrong in {Version.compcert}. {footnotesize "(Proved in {P.coq}.)"}") ] in
   let title = "The limit of {S.C.lambda_l}" in
   let lg = latex_of_int (BatList.length l) in
   BatList.mapi
     (fun pos (h_comment, msg) ->
       B.Top (title (* ^^ " [{latex_of_int (Pervasives.succ pos)}/{lg}]"*),
              sl_intro S.SL.ArmSh.C.asm
              ^^
              "<@@{H_comment h_comment}@
int main(int x) {
  return x;
}
@>"
              ^^
              (match msg with None -> "" | Some s -> s)))
     l)

(* ********************************************************* *)
; B.Center ("{S.SL.coq} ${overset "?" "="}$ {S.SL.Coq.Deep.compcert}, towards {S.C.infty}",
            let module SL_a = S.SL_gen (struct let sl = "FUN" end) in
            let i_sqcup x = index sqcup (tiny x) in

            "By defining the pretty-printer as a morphism between categories that preserve the applicative operator ``${sqcup}$'' of languages:"
            ^^
            (let module SL_p = S.SL_gen (struct let sl = "PROGRAMS" end) in
             align_ "$({SL_p.C.asm}, {i_sqcup "apply"}) {overset "pretty-print" longrightarrow} ({SL_p.Coq.Deep.asm}, {i_sqcup "APPLY"})$")
            ^^
            (let module SL_a = S.SL_gen (struct let sl = "P" end) in
             "the goal is to determine if {align_ "{forall} {SL_a.C.asm}, ({blue S.SL.C.asm} {i_sqcup "apply"} {SL_a.C.asm}) {blue "{in_} {S.C.lambda_l}"} "}")
            ^^
            Label.definition_
              ("``{red S.C.infty}'': the smallest set satisfying:"
               ^^
               enumerate (let module S = S_sz (struct let normal = normalsize let footnote = footnotesize let tiny = tiny let color_keyword = Some red_ end) in
                          [ "${S.C.lambda_l} {subseteq} {red S.C.infty}$"
                          ; "{forall} {SL_a.C.asm}, {forall} {S.P.C.infty}, {newline}
                             ({SL_a.C.asm} {i_sqcup "apply"} {S.P.C.infty}) {in_} {red S.C.infty} {longrightarrow_ } {SL_a.C.asm} {in_} {red S.C.infty}" ]))
            ^^ pause ^^
            blue "Warning: ongoing work!")

(* ********************************************************* *)
; B.Center ("", bibliographystyle "alpha" ^^ bibliography "t")

]))
