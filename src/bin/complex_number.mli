type t

val create : real:float -> imaginary:float -> t
val to_tuple : t -> float * float
val add : t -> t -> t
val sub : t -> t -> t
val square : t -> t
val ( + ) : t -> t -> t
