# Entregable 3

Autora: María Galvín Terrero

## Ejercicio

Creamos la imagen de jenkins en docker (fuera del terraform): `docker build -t myjenkins-blueocean .` 

Dentro del terraform creamos:

1. Imagen de docker.
2. Red de docker.
3. Los dos volúmenes.
4. Los dos contenedores.

Para ejecutar terraform usamos:
- .\terraform init
- .\terraform apply

Y haría falta decir `yes` para que se creen y se ejecuten todos los contenedores, volúmenes y redes.

Ahora nos vamos al navegador: `http://localhost:8080`

Para sacar la contraseña:
1. Accedemos al contenedor de docker: `docker exec -it jenkins-blueocean bash`
2. Buscamos en la ruta dada: `cat /var/jenkins_home/secrets/initialAdminPassword`

Vamos a crear un Pipeline (from SCM): 
1. Hacemos click en `Nueva tarea`.
2. Introducimos un nombre para la tarea y seleccionamos `Pipeline`.
3. Hacemos click en `OK`.
4. En `Pipeline`, en `Definition` seleccionamos `Pipeline script from SCM`.
5. En `SCM` seleccionamos `Git`.
6. En `Repository URL`, introducimos la URL del repositorio Git (https://github.com/mariaagalvinn/simple-python-pyinstaller-app.git).
7. En `Branch Specifier` ponemos `main`.
8. En `Script Path`, introduce el path del archivo Jenkinsfile (docs/Jenkinsfile).
9. Hacemos click en `Guardar`.

Una vez terminamos, tenemos que hacer click en `Panel de control`, luego en la tarea y, por último, en `Construir ahora`.

Una vez construido, hacemos click en "Open Blue Ocean". Seleccionamos la `build` creada y le damos a `Artefacto` y lo descargamos.

Y ya solo nos quedaría ejecutar el programa compilado en la terminal.