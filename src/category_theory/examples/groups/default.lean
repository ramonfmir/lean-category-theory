-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import category_theory.functor
import category_theory.tactics.obviously

open category_theory

namespace category_theory.examples.groups

universe u₁

def Group : Type (u₁+1) := Σ α : Type u₁, group α

instance group_from_Group (G : Group) : group G.1 := G.2

structure GroupHomomorphism (G H : Group.{u₁}) : Type u₁ :=
  (map: G.1 → H.1)
  (is_group_hom : is_group_hom map . obviously)

instance (G H : Group.{u₁}) (f : GroupHomomorphism G H) : is_group_hom f.map := f.is_group_hom

@[simp,search] lemma GroupHomomorphism.is_group_hom_lemma (G H : Group) (f : GroupHomomorphism G H) (x y : G.1) : f.map(x * y) = f.map(x) * f.map(y) := by rw f.is_group_hom.mul

def GroupHomomorphism.identity (G : Group) : GroupHomomorphism G G :=
{ map := id }

def GroupHomomorphism.composition {G H K : Group} (f: GroupHomomorphism G H) (g: GroupHomomorphism H K) : GroupHomomorphism G K :=
{ map := λ x, g.map (f.map x) }

@[extensionality] lemma GroupHomomorphism_pointwise_equality {G H : Group} (f g : GroupHomomorphism G H) (w : ∀ x : G.1, f.map x = g.map x) : f = g :=
begin
    induction f with fc,
    induction g with gc,
    tidy,
end

instance CategoryOfGroups : large_category Group := 
{ hom  := GroupHomomorphism,
  id   := GroupHomomorphism.identity,
  comp := @GroupHomomorphism.composition }

end category_theory.examples.groups
