// protocol      -> module
//   name        -> name
//
// interface     -> struct
//   name        ->   name
//   version     ->   version_
//
//   description 
//     summary   -> //
//
//   enum        -> enum
//     entry     
//       name    ->   name
//       value   ->   value
//
//                  struct *_listener
//   event       -> function   void function (void* data, gtk_shell1* gtk_shell1, uint capabilities);
//     arg       ->   arg   
//       type    ->   type 
//    
//   request     -> function
//     since     -> 
//     name      ->   name
//     arg       -> arg
//       name      ->   name
//       type      ->   type
//       interface ->   
//