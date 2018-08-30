-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison, Reid Barton, Mario Carneiro

import .limits
import .comparisons

open category_theory

universes u v

namespace category_theory.universal

variables {C : Type u} [𝒞 : category.{u v} C] [has_binary_products.{u v} C]
include 𝒞

def binary_product.braiding (P Q : C) : prod P Q ≅ prod Q P :=
{ hom := prod.pair (prod.π₂ _ _) (prod.π₁ _ _),
  inv := prod.pair (prod.π₂ _ _) (prod.π₁ _ _) }

def binary_product.symmetry (P Q : C) : (binary_product.braiding P Q).hom ≫ (binary_product.braiding Q P).hom = 𝟙 _ :=
begin
  dunfold binary_product.braiding,
  obviously,
end

def binary_product.associativity (P Q R : C) : (prod (prod P Q) R) ≅ (prod P (prod Q R)) :=
{ hom := prod.pair (prod.π₁ _ _ ≫ prod.π₁ _ _) (prod.pair (prod.π₁ _ _ ≫ prod.π₂ _ _) (prod.π₂ _ _)),
  inv := prod.pair (prod.pair (prod.π₁ _ _) (prod.π₂ _ _ ≫ prod.π₁ _ _)) (prod.π₂ _ _ ≫ prod.π₂ _ _) }

-- TODO verify the pentagon?

end category_theory.universal