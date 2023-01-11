# Set Up

## Instalar bundle

```bash
cd ~Tateti-Ruby
gem install bundle
bundle install
```

## Set up Database

```bash
Rails db:create
Rails db:migrate
Rails db:seed
```

# Usar Api

# Modelos

## Modelo ISP

### Los atributos de este modelo son el nombre, contraseña encriptada y token 

#### Este modelo se relaciona con Servicios (1:N), posee la funcionalidad has_secure_password de la gema bcrypt para poder asignarle una contraseña y esta gema la encripta, las validaciones de nombre (tiene que estar presente y ser unico), contraseña digerida (tiene que estar prensente) y token (unico); el callback llama al metodo set_token para asignarle un token con SecureRandom.uuid antes de ser creado.

## Modelo Service

### Los atributos de este modelo son el nombre, el precio, la descripcion y el isp_id

#### El modelo Servicio se relaciona con Usuario a traves de UserService, posee validaciones de todos sus atributos (tiene que estar presente), el metodo pending_request obtiene todos los UserService que estan pendientes en orden de creacion y el metodo reject_request obtiene todos los UserService que estan rechazados en el ultimo mes.

## Modelo User

### Los atributos de este modelo son el nombre, el apellido, el mail, la contraseña encriptada y el token

#### El modelo del Usuario posee la funcionalidad has_secure_password, se relaciona con un Servicio a traves de UserService, y posee un token unico que se asigna en el metodo set_token antes de ser creado

## Modelo UserService

### Los atributos de este modelo son un status de tipo enum (aprobado: 1, rechazado: 2, pendiente:0), el user_id y service_id

# Controladores

## Controlador Isp

### set_isp

#### Es un metodo utilizado como CallBack para buscar el isp correspondiente con el id enviado en el url, en el caso de no encontrar dicho isp devuelve un mensaje de error

### check_token

#### Es un metodo utilizado como CallBack para corroborar que el token enviado en el header es el correspondiente al isp que se ha ingresado anteriormente, en el caso de que el token no corresponda devuelve un mensaje de error

### create

#### Este metodo requiere un objeto isp que posea name, password y confirm_password; el metodo comienza realizando un checkeo de que la contraseña y confirmar contraseña sean iguales, si esto es asi instancia un objeto Isp con el nombre y la contraseña, en el caso de poder guardarlo devuelve el objeto sino devuelve error

### update

#### Este metodo requiere un objeto isp que posea name, el token en el header authorization y en el url el id del isp a actualizar; el metodo utiliza los metodos set_isp y check_token como CallBack (antes de la ejecutarse), el metodo asigna el atributo nombre para modificarlo, en el caso de guardarlo devuelve el objeto, en el caso contrario devuelve error

### destroy

#### Este metodo requiere el token en el header authorization y el url el id del isp a eliminar; el metodo utiliza los metodos set_isp y check_token como CallBack (antes de la ejecutarse) en el caso de poder eliminar la instancia devuelve vacio, en el caso contrario devuelve error

### login

#### Este metodo requiere un objeto isp que posea el name y password; el metodo busca un isp con dicho nombre en el caso de estar presente verifica que la contraseña sea correcta, si es correcta devuelve el objeto, en el caso contrario devuelve error

### change_password

#### Este metodo requiere un objeto isp que posea current_password, password y confirm_password, el token en el header authorization y en el url el id del isp a cambiar la contraseña; el metodo utiliza los metodos set_isp y check_token como CallBack (antes de la ejecutarse), el metodo verifica que la contraseña sea la correspondiente al isp, en el caso de ser correcta verifica que la contraseña y confirmar contraseña sean igual si es asi se le asigna contraseña y en el caso de guardarlo devuelve el objeto y en caso contrario devuelve error

### list_request

#### Este metodo requiere el token en el header authorization y en el url el id del isp a ver la lista de peticiones de serivicos que estan pendientes; el metodo llama a la funcion de Service pending_request por cada servicio que posee, elimina los vacios y los asigna a user_service, si este tiene almenos 1 atributo lo/s devuelve y en caso contrario devuelve el mensaje que no hay peticiones pendientes

### list_rejected

#### Este metodo requiere el token en el header authorization y en el url el id del isp a ver la lista de peticiones de serivicos que estan rechazados el ultimo mes; el metodo llama a la funcion de Service reject_request por cada servicio que posee, elimina los vacios y los asigna a user_service, si este tiene almenos 1 atributo lo/s devuelve y en caso contrario devuelve el mensaje que no hay peticiones rechazadas el ultimo mes

## Controlador Servicio

### set_isp

#### Es un metodo utilizado como CallBack para buscar el isp correspondiente con el id enviado en el url, en el caso de no encontrar dicho isp devuelve un mensaje de error

### check_token

#### Es un metodo utilizado como CallBack para corroborar que el token enviado en el header es el correspondiente al isp que se ha ingresado anteriormente, en el caso de que el token no corresponda devuelve un mensaje de error

### set_service

#### Es un metodo utilizado como CallBack para buscar el servicio correspondiente con el id enviado en el url, en el caso de no encontrar dicho servicio devuelve un mensaje de error

### set_user_service

#### Es un metodo utilizado como CallBack para buscar el user_service correspondiente con el id enviado en el url, en el caso de no encontrar dicho user_service devuelve un mensaje de error

### change_service?

#### El metodo revisa si el usuario posee un user_service, en ese caso asigna el userservice, cambia el servicio por el enviado en la url, y el status a pendiente, si se puede guardar devuelve verdadero y en caso contrario un error o falso

### index

#### Devuelve todos los servicios con orden del isp_id

### create

#### El metodo requiere un objeto service con los atributos name,price y description y el id del isp en el url, el metodo utiliza los metodos set_isp y check_token como CallBack (antes de la ejecutarse); el metodo instancia con el objeto enviado como Servicio al perteneciendo al isp asignado anteriormente, si se guarda devuelve el servicio y en caso contrario devuelve error

### request_service

#### El metodo requiere un objeto user con el id, el id del isp y service en el url y el token del usuario en el header, el metodo utiliza los metodos set_isp y set_service como CallBack (antes de la ejecutarse); el metodo busca el usuario con el id, si este esta presente checkea que el token enviado en header con el del usuario, si estos coinciden llama a change_service, en el caso que no tenga un service previamente instancia un user_service que pertenece al service y al usuario enviados anteriormente, si se guarda devuelve el user_service y en caso contrario devuelve error

### check_request

#### El metodo requiere un objeto userservice con un status; el id del isp, service y el user_service en el url y el token del isp en el header, el metodo utiliza los metodos set_isp, set_service, set_user_service y check_token como CallBack (antes de la ejecutarse); el metodo asigna el estado enviado al userservice, si este se guarda devuelve el servicio y en caso contrario devuelve error

## Controlador Usuario

### Metodos create, update, login y change password similares al del isp