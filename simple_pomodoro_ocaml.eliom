[%%shared
    open Eliom_lib
    open Eliom_content
    open Html5.D
    open Base
]

module Simple_pomodoro_ocaml_app =
  Eliom_registration.App (
    struct
      let application_name = "simple_pomodoro_ocaml"
    end)

let main_service =
  Eliom_service.App.service ~path:[] ~get_params:Eliom_parameter.unit ()

let () =
  Simple_pomodoro_ocaml_app.register
     ~service:main_service
    (fun () () ->
      let open Lwt in
      print_endline "service";
      Db.incomplete () >>= fun tasks ->
        let task_table =
          Html5.D.tbody @@ List.map task_elt tasks
        in
        let () =
          ignore @@ init task_table
        in
        Lwt.return (Eliom_tools.F.html
          ~title:"Simple Pomodoro tool using Ocsigen & Eliom"
          ~css:[
            ["css";"bootstrap.min.css"];
            ["css";"main.css"] ]
          Html5.F.(body [
            div ~a:[ a_class [ "container" ]] [
              header [
                div ~a:[ a_class [ "hero-unit" ]] [
                  h1 [ pcdata "Simple Todo tool" ];
                ]];
              (*article [
                h2 [ pcdata "TODOs" ];
                task_form;
                tablex
                  ~a:[ a_class [ "table"; "table-striped" ]]
                  ~thead:(thead [tr [ th [ pcdata "TODO" ]; th [] ]]) @@
                  [ task_table ]];*)
              (*article [
                h2 [ pcdata "About this" ];
                p  [ pcdata "This is ";
                    Raw.a ~a:[ a_href @@
                      Xml.uri_of_string
                      "https://github.com/heroku-buildpack-ocaml/heroku-buildpack-ocaml"
                    ] [
                      pcdata "heroku-buildpack-ocaml"
                    ];
                    pcdata " sample."]
              ]*)
        ]])))
(*    ~service:main_service
    (fun () () ->
      Lwt.return
        (Eliom_tools.F.html
           ~title:"simple_pomodoro_ocaml"
           ~css:[["css";"simple_pomodoro_ocaml.css"]]
           Html5.F.(body [
             h2 [pcdata "Welcome from Eliom's distillery!"];
           ]))) *)
