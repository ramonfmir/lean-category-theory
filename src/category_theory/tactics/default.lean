-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import tidy.applicable tidy.force tidy.at_least_one tidy.repeat_at_least_once tidy.smt tidy.tidy

import tidy.auto_cast

open tactic

attribute [reducible] cast
attribute [reducible] lift_t coe_t coe_b has_coe_to_fun.coe
attribute [simp] id_locked_eq
attribute [ematch] subtype.property

@[applicable] lemma {u v} pairs_componentwise_equal {α : Type u} {β : Type v} { X Y : α × β } ( p1 : X.1 = Y.1 ) ( p2 : X.2 = Y.2 ) : X = Y := ♯

meta def trace_goal_type : tactic unit :=
do g ← target,
   trace g,
   infer_type g >>= trace,
   skip

set_option formatter.hide_full_terms false

set_option pp.proofs false