let table = <:table< task(
  id integer NOT NULL,
  name text NOT NULL,
  is_done boolean NOT NULL
) >>

let task_table = <:table< task(
  name text NOT NULL,
  is_done boolean NOT NULL
) >>

let connect () =
  Lwt_PGOCaml.connect ~database:"test" ~user:"postgres" ()

let get_db : unit -> unit Lwt_PGOCaml.t Lwt.t =
  let db_handler =
    ref None in
  fun () ->
    match !db_handler with
    | Some h -> Lwt.return h
    | None ->
        let open Lwt in
        connect ()
        >>=  begin fun dbh ->
          db_handler := Some dbh;
          Lwt.return dbh
        end

let add { Task.name; _ } =
  let open Lwt in
  get_db () >>= fun dbh ->
    Lwt_mutex.with_lock mutex begin fun () ->
      Lwt_Query.query dbh
    <:insert< $task_table$ :=
      { name = $string:name$; is_done = false } >>
    end

let done_it { Task.id; _ } =
  let open Lwt in
  get_db () >>= fun dbh ->
    Lwt_mutex.with_lock mutex begin fun () ->
      Lwt_Query.query dbh
      <:update< t in $table$
                := { is_done = true }
                | t.id = $int32:Int32.of_int id$ >>
    end
