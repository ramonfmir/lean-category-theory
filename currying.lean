-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import .natural_transformation
import .equivalence
import .products.products

open tqft.categories
open tqft.categories.isomorphism
open tqft.categories.functor
open tqft.categories.equivalence

namespace tqft.categories.natural_transformation

-- PROJECT show Fun(C → Fun(D → E)) is equivalent to Fun(C × D → E)

-- theorem {u1 v1 u2 v2 u3 v3} Currying_for_functors
--   ( C : Category.{u1 v1} )
--   ( D : Category.{u2 v2} )
--   ( E : Category.{u3 v3} ) :
--   Equivalence (FunctorCategory C (FunctorCategory D E)) (FunctorCategory (C × D) E) :=
--   begin
--     fsplit,
--     fsplit,
--     {      
--       -- Define the functor
--       unfold_projections,
--       intros F,
--       fsplit,
--       {
--         -- define it on objects
--         intros,
--         induction a with c d,
--         exact (F.onObjects c).onObjects d,
--       },
--       {
--         intros,
--         induction a with f g,
--         pose p := (F.onMorphisms f),
--         dsimp at p, -- FIXME match failed on dsimp, again :-(   
--       }
--     }
--   end

  -- {
  --   functor := {
  --     onObjects     := λ F, {
  --       onObjects     := λ p, (F.onObjects p.1).onObjects p.2,
  --       onMorphisms   := sorry,
  --       identities    := sorry,
  --       functoriality := sorry
  --     },
  --     onMorphisms   := sorry,
  --     identities    := sorry,
  --     functoriality := sorry
  --   },
  --   inverse := sorry,
  --   isomorphism_1 := sorry,
  --   isomorphism_2 := sorry
  -- }

end tqft.categories.natural_transformation