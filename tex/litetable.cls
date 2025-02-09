%% *********************************************************************
%%          Copyright 2024 by M.Y. XIA <myhsia@outlook.com>            *
%%                                                                     *
%%    This work may be distributed and/or modified under the           *
%%    conditions of the LaTeX Project Public License                   *
%%                                                                     *
%%               http://www.latex-project.org/lppl.txt                 *
%%                                                                     *
%%    either version 1.3c of this license or any later version.        *
%%                                                                     *
%%    This work has the LPPL maintenance status `maintained'.          *
%%                                                                     *
%%    The Current Maintainers of this work are M.Y. XIA & L.J. Guo     *
%%                                                                     *
%%    This work consists of the files litetable.cls,                   *
%%                                and README.md.                       *
%%    available at https://github.com/myhsia/litetable                 *
%% *********************************************************************
\RequirePackage{xparse}
\ProvidesExplClass {litetable} {2025/02/10} {3.2A} {Colorful Timetable}

\DeclareOption* { \PassOptionsToClass \CurrentOption { article } }
\ProcessOptions \relax
\LoadClass { article }

\pagestyle { empty }
\RequirePackage { tikz }

% Compatibility for texlive 2019 and later (by @ljguo)
\cs_if_exist:NF \clist_put_right:Ne
  { \cs_generate_variant:Nn \clist_put_right:Nn { Ne } }
\cs_if_exist:NF \exp_args:NNNe
  {
    \cs_new:Npn \exp_args:NNNe #1#2#3#4
      {
        \exp_after:wN #1
        \exp_after:wN #2
        \exp_after:wN #3
        \tex_expanded:D { {#4} }
      }
  }

% Module for left -> right data structure (by @ljguo)
\cs_new_protected_nopar:Npn \__lite_get_left:nN #1#2
  {
    \group_begin:
    \seq_set_split:Nnn \l__lite_tmpa_seq { -> } {#1}
    \exp_args:NNNe \group_end:
    \tl_set:Nn #2 { \seq_item:Nn \l__lite_tmpa_seq { 1 } }
  }
\cs_new_protected_nopar:Npn \__lite_get_right:nN #1#2
  {
    \group_begin:
    \seq_set_split:Nnn \l__lite_tmpa_seq { -> } {#1}
    \exp_args:NNNe \group_end:
    \tl_set:Nn #2 { \seq_item:Nn \l__lite_tmpa_seq { 2 } }
  }
\cs_generate_variant:Nn \__lite_get_left:nN { e }
\cs_generate_variant:Nn \__lite_get_right:nN { e }

% Workshop Broadcast
\cs_new_protected:Npn \lite_msg_new:nn #1#2
  { \msg_new:nnn { litetable } {#1} {#2} }
\cs_new_protected:Npn \lite_msg_warning:n #1
  { \msg_warning:nn { litetable } {#1} }

\int_new:N \l__time_num_int
\dim_new:N \l__time_vunit_dim
\keys_define:nn { litetable / timelist }
  {
    numformat    .tl_set:N   = \l__lite_timelist_numformat_tl,
      numformat  .initial:n  = \ttfamily \bfseries,
    timeformat   .tl_set:N   = \l__lite_timelist_timeformat_tl,
      timeformat .initial:n  = \ttfamily,
    hidetime     .bool_set:N = \l__lite_timelist_hidetime_bool,
      hidetime   .initial:n  = false,
      hidetime   .default:n  = true
  }
\NewDocumentCommand \timelist { O{} m O{} }
  { \keys_set:nn { litetable / timelist } { #1, #3 } \lite_timelist:n {#2} }
\cs_new_protected_nopar:Npn \lite_timelist:n #1
  {
    \clist_set:Nn \l__lite_time_clist {#1}
    \int_set:Nn \l__time_num_int { \clist_count:N \l__lite_time_clist }
    \dim_set:Nn \l__time_vunit_dim
      { \fp_eval:n { 1/( 2\l__time_num_int + 3.5 ) } \paperheight }
  }

\clist_new:N \l__week_ratio_clist
\clist_new:N \l__week_accum_clist
\int_new:N \l__week_num_int
\dim_new:N \l__week_hunit_dim
\NewDocumentCommand \weeklist { O{} m O{} }
  { \keys_set:nn { litetable / weeklist } { #1, #3 } \lite_weeklist:n {#2} }
\keys_define:nn { litetable / weeklist }
  {
    format   .tl_set:N  = \l__lite_weeklist_format_tl,
      format .initial:n = \bfseries \scshape,
    sep      .tl_set:N  = \l__lite_weeklist_sep_tl
  }
\cs_new_protected_nopar:Npn \lite_weeklist:n #1
  {
    \clist_set:Nn \l__lite_week_clist {#1}
    \int_step_inline:nn { \clist_count:N \l__lite_week_clist }
      {
        \__lite_get_right:eN
          { \clist_item:Nn \l__lite_week_clist {##1} } \l__lite_tmpb_tl
        \clist_put_right:Ne \l__week_ratio_clist { \l__lite_tmpb_tl }
      }
    \int_step_inline:nn { \clist_count:N \l__lite_week_clist }
      {
        \clist_clear:N \l__week_accumtmp_clist
        \int_step_inline:nn {##1}
          {
            \clist_put_right:Ne \l__week_accumtmp_clist
              { \clist_item:Nn \l__week_ratio_clist {####1} }
          }
        \clist_put_right:Ne \l__week_accum_clist
          { \int_eval:n { \clist_use:Nn \l__week_accumtmp_clist { + } } }
      }
    \int_set:Nn \l__week_num_int
      {
        \clist_item:Nn \l__week_accum_clist
          { \clist_count:N \l__lite_week_clist }
      }
    \dim_set:Nn \l__week_hunit_dim
      { \dim_eval:n { 14\paperwidth/\l__week_num_int/15 } }
  }

\int_new:N \l__lite_weekday_int
\int_set:Nn \l__lite_weekday_int { 1 }
\NewDocumentCommand \newday { O{1} } { \int_add:Nn \l__lite_weekday_int {#1} }

\dim_new:N \l__lite_timelist_yshift_dim
\keys_define:nn { litetable / frame }
  {
    color   .tl_set:N  = \l__bg_color_tl,
      color .initial:n = gray,
    sem     .tl_set:N  = \l__bg_sem_tl,
    unknown .code:n    = \tl_if_novalue:nF {#1}
      { \tl_set_eq:NN \l__bg_color_tl \l_keys_key_tl }
  }
\NewDocumentEnvironment { litetable } { O{} m O{} }
  {
    \tikzpicture [ remember~picture, overlay ]
    \group_begin:
    \keys_set:nn { litetable / frame } { #1, #3 }
    \lite_maketable:n {#2}
  } { \group_end: \endtikzpicture }
\cs_new_protected_nopar:Npn \lite_maketable:n #1
  {
    \fill [ \l__bg_color_tl!5 ]
      (current~page.north~west) rectangle +
      (\paperwidth, -1.5\l__time_vunit_dim)
     node [ midway, black, font = \huge \bfseries ] {#1};
    \tl_if_empty:NF \l__bg_sem_tl
      {
        \node [ shift = {(-.02\paperwidth, -.75\l__time_vunit_dim)},
                left, rectangle, fill = DarkBlue!10, text = DarkBlue!60,
                inner~sep = 2ex, rounded~corners = 8pt, font = \large
              ] at (current~page.north~east) { \l__bg_sem_tl };
      }
    % Darker Blocks
    \int_step_inline:nnnn { 0 } { 2 } { \l__time_num_int }
      {
        \filldraw [ fill = \l__bg_color_tl!5, draw = gray,
                    thick, densely~dashed, line~cap = round ]
          ([shift = {(-.4pt, \fp_eval:n { -2 * ##1 - 2.5 } \l__time_vunit_dim)}]
           current~page.north~west) rectangle +
          (\paperwidth + .8pt, -2\l__time_vunit_dim);
      }
    \bool_if:NTF \l__lite_timelist_hidetime_bool
      { \dim_set:Nn \l__lite_timelist_yshift_dim { -1.5\l__time_vunit_dim } }
      { \dim_set:Nn \l__lite_timelist_yshift_dim { -\l__time_vunit_dim } }
    \int_step_inline:nn { \l__time_num_int }
      {
        \node [ darkgray!80, shift =
                {(
                  \paperwidth/30,
                  -2 * ##1 \l__time_vunit_dim + \l__lite_timelist_yshift_dim
                )}, font = \large \l__lite_timelist_numformat_tl
              ] at (current~page.north~west) {##1};
      }
    % Classes time
    \bool_if:NF \l__lite_timelist_hidetime_bool
      {
        \int_step_inline:nn { \clist_count:N \l__lite_time_clist }
          {
            \__lite_get_left:eN { \clist_item:Nn \l__lite_time_clist {##1} }
            \l__lite_tmpa_tl
            \__lite_get_right:eN { \clist_item:Nn \l__lite_time_clist {##1} }
            \l__lite_tmpb_tl
            \node [ gray, align = center, shift =
                    {(
                      \paperwidth/30,
                      \fp_eval:n { -1.85 - 2 * ##1 } \l__time_vunit_dim
                    )}, font = \l__lite_timelist_timeformat_tl
                  ] at (current~page.north~west)
              { \l__lite_tmpa_tl\\ \l__lite_tmpb_tl };
          }
      }
    % Weekdays
    \int_step_inline:nn { \clist_count:N \l__lite_week_clist }
      {
        \int_compare:nNnF { ##1 } = { \clist_count:N \l__lite_week_clist }
          {
            \node [ shift =
                    {(\fp_eval:n
                        {
                          14 * \clist_item:Nn \l__week_accum_clist {##1}/
                          \l__week_num_int/15 + 1/15
                        } \paperwidth, -2\l__time_vunit_dim
                    )}, darkgray, font = \ttfamily
                  ] at (current~page.north~west) { \l__lite_weeklist_sep_tl };
          }
        \__lite_get_left:eN { \clist_item:Nn \l__lite_week_clist {##1} }
        \l__lite_tmpa_tl
        \node [ shift =
                {(\fp_eval:n
                    {
                      14(
                        \clist_item:Nn \l__week_accum_clist {##1} -
                        \clist_item:Nn \l__week_ratio_clist {##1}/2
                        )/\l__week_num_int/15 + 1/15
                    } \paperwidth, -2\l__time_vunit_dim
                )}, font = \large \l__lite_weeklist_format_tl
              ] at (current~page.north~west) { \l__lite_tmpa_tl };
      }
  }

\NewDocumentCommand \more { m }
  {
    \node [ yshift = .5\l__time_vunit_dim, left = 1ex,
            darkgray, font = \small \bfseries
          ] at (current~page.south~east) {#1};
  }

\keys_define:nn { litetable / course }
  {
    color    .tl_set:N  = \l__course_color_tl,
      color  .initial:n = black,
    subject  .tl_set:N  = \l__course_subject_tl,
    lecture  .tl_set:N  = \l__course_lecture_tl,
    location .tl_set:N  = \l__course_location_tl,
    comment  .tl_set:N  = \l__default_comment_tl,
    unknown  .code:n    = \tl_if_novalue:nF {#1}
      { \tl_set_eq:NN \l__course_color_tl \l_keys_key_tl }
  }
\dim_new:N \l__course_infoshift_dim
\lite_msg_new:nn { course }
  { \exp_not:N \course~box(s)~exceed~workdays~were~ignored }
\NewDocumentCommand \course { O{} m O{} m O{} }
  {
    \group_begin:
    \bool_lazy_any:nTF
      {
        {
          \int_compare_p:nNn { \l__lite_weekday_int } >
            { \clist_count:N \l__lite_week_clist }
        }
        { \int_compare_p:nNn { #2 } > { \clist_count:N \l__lite_time_clist } }
        { \int_compare_p:nNn { #4 } > { \clist_count:N \l__lite_time_clist } }
      } { \lite_msg_warning:n { course } }
      {
        \keys_set:nn { litetable / course } { #1, #3, #5 }
        \int_compare:nNnTF {#2} < {#4}
          { \__lite_course_box_aux:nn {#2} {#4} }
          { \__lite_course_box_aux:nn {#4} {#2} }
      }
    \group_end:
  }
\cs_new_protected_nopar:Npn \__lite_course_box_aux:nn #1#2
  {
    \begin{scope}
      % Course box fg
      \clip [ preaction = { draw, ultra~thick, \l__course_color_tl!60 },
              preaction = { fill, \l__course_color_tl!10 },
              rounded~corners = 8pt ]
        ([shift =
          {(
            \fp_eval:n
              {
                \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }
              } \l__week_hunit_dim + \paperwidth/15 + 1.2pt,
            \fp_eval:n { -.5 - 2 * #1 } \l__time_vunit_dim - 1.2pt
        )}]current~page.north~west) rectangle +
        (
          \clist_item:Nn \l__week_ratio_clist
            { \l__lite_weekday_int } \l__week_hunit_dim - 2.4pt,
          \fp_eval:n { 2( #1 - #2 - 1 ) } \l__time_vunit_dim + 2.4pt
        );
      % Course box bg
      \fill [ \l__course_color_tl!60 ]
        ([shift =
          {(
            \fp_eval:n
              {
                \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }
              } \l__week_hunit_dim + \paperwidth/15,
            \fp_eval:n { -.5 - 2 * #1 } \l__time_vunit_dim
        )}]current~page.north~west) rectangle +
        (
          \clist_item:Nn \l__week_ratio_clist
            { \l__lite_weekday_int } \l__week_hunit_dim,
          -\l__time_vunit_dim/2
        );
    \end{scope}
    % Course info
    \tl_if_eq:NNTF {#1} {#2}
      {
        \bool_lazy_and:nnTF % Single-unit height course box
          { \tl_if_empty_p:N \l__course_location_tl }
          { \tl_if_empty_p:N \l__course_lecture_tl }
          { \tl_set:Nn \l__course_anchor_tl { } }
          { \tl_set:Nn \l__course_anchor_tl { above } }
        \node
          [ \l__course_anchor_tl, \l__course_color_tl!60, shift =
            {(
              \fp_eval:n
                {
                  \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                  \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }/2
                } \l__week_hunit_dim + \paperwidth/15,
              \fp_eval:n { -1.75 - #1 - #2 } \l__time_vunit_dim
            )}, align = center, font = \bfseries
          ] at (current~page.north~west) { \l__course_subject_tl };
        \bool_lazy_or:nnTF
          { \tl_if_empty_p:N \l__course_location_tl }
          { \tl_if_empty_p:N \l__course_lecture_tl }
          { \tl_set:Nn \l__s@course_sep_tl { } }
          { \tl_set:Nn \l__s@course_sep_tl { ,~ } }
        \node
          [ shift =
            {(
              \fp_eval:n
                {
                  \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                  \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }/2
                } \l__week_hunit_dim + \paperwidth/15,
              \fp_eval:n { -1.75 - #1 - #2 } \l__time_vunit_dim
            )}, below, \l__course_color_tl!60, align = center
          ] at (current~page.north~west)
          { \l__course_location_tl \l__s@course_sep_tl \l__course_lecture_tl };
      }
      {
        \bool_lazy_and:nnTF % Multiply-unit height course box
          { \tl_if_empty_p:N \l__course_location_tl }
          { \tl_if_empty_p:N \l__course_lecture_tl }
          {
            \tl_set:Nn \l__course_anchor_tl { }
            \dim_set:Nn \l__course_infoshift_dim { 0pt }
          }
          {
            \tl_set:Nn \l__course_anchor_tl { above }
            \dim_set:Nn \l__course_infoshift_dim { \l__time_vunit_dim/8 }
          }
        \node
          [ \l__course_color_tl!60, align = center, shift =
            {(
              \fp_eval:n
                {
                  \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                  \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }/2
                } \l__week_hunit_dim + \paperwidth/15,
              \fp_eval:n { -1.5 - #1 - #2 } \l__time_vunit_dim +
              \l__course_infoshift_dim
            )}, font = \large \bfseries, \l__course_anchor_tl
          ] at (current~page.north~west) { \l__course_subject_tl };
        \bool_lazy_or:nnTF
          { \tl_if_empty_p:N \l__course_location_tl }
          { \tl_if_empty_p:N \l__course_lecture_tl }
          { \tl_set:Nn \l__@course_sep_tl { } }
          { \tl_set:Nn \l__@course_sep_tl { \\ } }
        \node
          [ shift =
            {(
              \fp_eval:n
                {
                  \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int } -
                  \clist_item:Nn \l__week_ratio_clist { \l__lite_weekday_int }/2
                } \l__week_hunit_dim + \paperwidth/15,
              \fp_eval:n { -1.625 - #1 - #2 } \l__time_vunit_dim
            )}, below, \l__course_color_tl!60, align = center
          ] at (current~page.north~west)
          { \l__course_location_tl \l__@course_sep_tl \l__course_lecture_tl };
        \node
          [ shift =
            {(
              \clist_item:Nn \l__week_accum_clist { \l__lite_weekday_int }
              \l__week_hunit_dim + \paperwidth/15,
              \fp_eval:n { -2.5 - 2 * #2 } \l__time_vunit_dim
            )}, above~left, \l__course_color_tl!60, outer~sep = .5ex
          ] at (current~page.north~west) { \l__default_comment_tl };
      }
  }

\endinput
% End of file litetable.cls
