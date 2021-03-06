import category_theory.presheaves
import category_theory.limits.limits

universes u v

open category_theory
open category_theory.examples
open category_theory.limits
open category_theory.presheaves
open topological_space

namespace category_theory.presheaves

instance has_mem_open_set_op (X : Top) : has_mem X.α ((opens X)ᵒᵖ) := 
(by apply_instance : has_mem X.α (opens X))

variables {C : Type u} [𝒞 : category.{u v} C]
include 𝒞

variable [has_colimits.{u v} C]

namespace Presheaf
def near (F : Presheaf.{u v} C) (x : F) : { U : (opens F.X)ᵒᵖ // x ∈ U } ⥤ C :=
(full_subcategory_inclusion (λ U : (opens F.X)ᵒᵖ, x ∈ U)) ⋙ F.𝒪

def stalk_at (F : Presheaf.{u v} C) (x : F.X) : C :=
colimit (F.near x)
end Presheaf

def stalk_at {X : Top.{v}} (𝒪 : (opens X)ᵒᵖ ⥤ C) (x : X) : C :=
{ Presheaf . X := X, 𝒪 := 𝒪 }.stalk_at x

end category_theory.presheaves
