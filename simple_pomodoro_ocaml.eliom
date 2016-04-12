[%%shared
    open Eliom_lib
    open Eliom_content
    open Html5.D
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
      Lwt.return
        (Eliom_tools.F.html
           ~title:"simple_pomodoro_ocaml"
           ~css:[["css";"simple_pomodoro_ocaml.css"]]
           Html5.F.(body [
             h2 [pcdata "Welcome from Eliom's distillery!"];
           ])))
