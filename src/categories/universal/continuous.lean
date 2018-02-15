-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import .universal

open categories
open categories.functor
open categories.initial

namespace categories.universal

universes u
variable {C : Type u}
variable [category C]
variable {D : Type u}
variable [category D]

structure Continuous (F : Functor C D ) :=
  (preserves_limits : ∀ {J : Type u} [category J] (G : Functor J C) (L : LimitCone G), is_terminal ((Cones_functoriality G F).onObjects L.terminal_object))

structure Cocontinuous (F : Functor C D ) :=
  (preserves_colimits : ∀ {J : Type u} [category J] (G : Functor J C) (L : ColimitCocone G), is_initial ((Cocones_functoriality G F).onObjects L.initial_object))


-- PROJECT right adjoints are continuous

end categories.universal

