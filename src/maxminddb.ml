type mmdb

external version : unit -> string = "mmdb_ml_version"

external create : path:string -> mmdb = "mmdb_ml_open"

external close : mmdb -> unit = "mmdb_ml_close"

external dump_per_ip_raw : string -> mmdb -> string =
  "mmdb_ml_dump_per_ip"

external dump_global_raw : mmdb -> string =
  "mmdb_ml_dump_global"

external lookup_path_raw : ip:string -> query:string list -> mmdb -> string =
  "mmdb_ml_lookup_path"

let without_null s =
  String.sub s 0 (String.length s - 1)

let dump ?ip mmdb = match ip with
  | None -> dump_global_raw mmdb |> without_null
  | Some ip -> dump_per_ip_raw ip mmdb |> without_null

let lookup_path ~ip ~query mmdb =
  lookup_path_raw ~ip ~query mmdb |> without_null

let postal_code ~ip mmdb =
  lookup_path ip ["postal";"code"] mmdb

let with_mmdb ~path f =
  let this_mmdb = create path in
  f this_mmdb |> ignore;
  close this_mmdb
