type t = { name : string; strategy : float list -> float }

val make : string -> (float list -> float) -> t
val bid : t -> float list -> float
