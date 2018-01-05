-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import ..complete
import ...walking

open categories
open categories.functor
open categories.natural_transformation
open categories.isomorphism
open categories.initial
open categories.walking
open categories.util.finite

namespace categories.universal

private definition {u v} Cone_from_map_to_limit
  { C : Category.{u v} }
  { J : Category.{u v} } 
  { F : Functor J C } 
  { L : LimitCone F } 
  { Z : C.Obj } 
  ( f : C.Hom Z L.terminal_object.cone_point ) : Cone F :=
{
  cone_point    := Z,
  cone_maps     := λ j, C.compose f (L.terminal_object.cone_maps j),
  commutativity := ♯ 
}
private definition {u v} ConeMorphism_from_map_to_limit
  { C : Category.{u v} }
  { J : Category.{u v} } 
  { F : Functor J C } 
  { L : LimitCone F } 
  { Z : C.Obj } 
  ( f : C.Hom Z L.terminal_object.cone_point ) : ConeMorphism (Cone_from_map_to_limit f) L.terminal_object :=
{
  cone_morphism := f,
  commutativity := ♯ 
}

open categories.util.finite.Two

-- PROJECT this construction is unpleasant
instance Equalizers_from_Limits ( C : Category ) [ Complete C ] : has_Equalizers C := {
  equalizer := λ X Y f g, let lim := limitCone(ParallelPair_functor f g) in {
    equalizer     := lim.terminal_object.cone_point,
    inclusion     := lim.terminal_object.cone_maps Two._0,
    witness       := let commutativity := @Cone.commutativity _ _ _ lim.terminal_object Two._0 Two._1 in 
                     begin
                       have fw := commutativity tt,
                       have gw := commutativity ff,
                       -- TODO this is suffering from https://github.com/leanprover/lean/issues/1889
                       dsimp at fw {unfold_reducible := tt, md := semireducible},
                       dsimp at gw {unfold_reducible := tt, md := semireducible},
                       rw fw,
                       rw gw,
                     end,
    map           := begin
                       -- PROJECT this is really ugly! Those inductions should work better...
                       tidy,
                       induction j,
                       tidy,
                       exact k,
                       exact C.compose k f,
                       induction j,
                       induction k_1,
                       tidy,
                       induction f_1,
                       tidy,
                       induction k_1,
                       tidy,
                       induction f_1,
                       induction f_1,
                       tidy,
                     end,
    factorisation := begin
                       tidy,
                       unfold universal.morphism_to_terminal_object_cone_point,
                       tidy,
                     end,
    uniqueness    := begin
                       tidy,
                       let Z_cone : Cone (ParallelPair_functor f g) := {
                         cone_point := Z,
                         cone_maps := λ j : Two, C.compose a (lim.terminal_object.cone_maps j),
                         commutativity := begin
                                            tidy, induction j, any_goals { induction k }, any_goals { induction f_1 }, tidy,
                                            {
                                              have c := lim.terminal_object.commutativity,
                                              have c₁ := @c Two._0 Two._1 ff,
                                              dsimp at c₁ {unfold_reducible := tt, md := semireducible},
                                              rw c₁,
                                            },
                                            {
                                              have c := lim.terminal_object.commutativity,
                                              have c₂ := @c Two._0 Two._1 tt,
                                              dsimp at c₂ {unfold_reducible := tt, md := semireducible},
                                              rw c₂,
                                            },
                                          end
                       },
                       have p := lim.uniqueness_of_morphisms_to_terminal_object Z_cone ⟨ a, _ ⟩ ⟨ b, _ ⟩,
                       exact congr_arg ConeMorphism.cone_morphism p,
                       -- finally, take care of those placeholders
                       tidy,
                       induction j,
                       tidy,      
                       have c := lim.terminal_object.commutativity,
                       rw ← @c Two._0 Two._1 tt,
                       repeat { rw ← C.associativity },
                       rw witness, 
                     end
  }                       
}

instance Products_from_Limits ( C : Category ) [ Complete C ] : has_Products C := {
    product := λ { I : Type } ( F : I → C.Obj ), 
                 let lim_F := limitCone (Functor.fromFunction F) in
                  {
                    product       := lim_F.terminal_object.cone_point,
                    projection    := λ i, lim_F.terminal_object.cone_maps i,
                    uniqueness    := λ Z f g, begin
                                                intros, 
                                                have p := lim_F.uniqueness_of_morphisms_to_terminal_object, 
                                                have q := p _ (ConeMorphism_from_map_to_limit f)
                                                  { cone_morphism := g, commutativity := begin tidy, simp *, end }, -- PROJECT think about automation here
                                                exact congr_arg ConeMorphism.cone_morphism q, -- PROJECT surely this line can be automated: if you know a = b, you know a.x = b.x
                                              end,
                    map           := λ Z i, (lim_F.morphism_to_terminal_object_from { 
                                              cone_point := Z, 
                                              cone_maps := i, 
                                              commutativity := begin
                                                                 tidy, 
                                                                -- TODO: fails because there aren't enough binders to revert! Minimised as https://github.com/leanprover/lean/issues/1889
                                                                --  dsimp at * {unfold_reducible := tt, md := semireducible}, 
                                                                 unfold_projs at * {md:=semireducible}, 
                                                                 tidy 
                                                               end 
                                            }).cone_morphism,
                    factorisation := ♯ 
                  }
}

instance Limits_from_Products_and_Equalizers ( C : Category ) [ has_Products C ] [ has_Equalizers C ] : Complete C := {
  limitCone := λ J F,
    let product_over_objects   := product (F.onObjects) in
    let product_over_morphisms := product (λ f : ( Σ s : J.Obj, Σ t : J.Obj, J.Hom s t ), F.onObjects f.2.1) in
    let source    := product_over_morphisms.map (λ f, C.compose (product_over_objects.projection f.1) (F.onMorphisms f.2.2) )  in
    let target    := product_over_morphisms.map (λ f, product_over_objects.projection f.2.1 ) in
    let equalizer := equalizer source target in {
      terminal_object     := {
        cone_point    := equalizer.equalizer,
        cone_maps     := λ j : J.Obj, C.compose equalizer.inclusion (product_over_objects.projection j),
        commutativity := λ j k f, begin
                                   have p := congr_arg (λ i, C.compose i (product_over_morphisms.projection ⟨ j, ⟨ k, f ⟩ ⟩)) equalizer.witness,                                
                                   blast,                                   
                                  end
      },
      morphism_to_terminal_object_from := λ cone : Cone F, {
        cone_morphism := /- we need a morphism from the tip of f to the equalizer -/
                         equalizer.map
                           (product_over_objects.map cone.cone_maps) ♯,
        commutativity := ♯
      },
      uniqueness_of_morphisms_to_terminal_object := ♯
    }
}

end categories.universal