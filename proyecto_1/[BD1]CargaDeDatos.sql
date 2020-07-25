/*------------------------------------ INSERCIONES EN LAS TABLAS---------------------------------------*/
/*----------------------------------------------------------------------------------------------------*/
INSERT INTO TITULO (nombre)
SELECT distinct (TITULO_DEL_EMPLEADO) FROM temporal WHERE TITULO_DEL_EMPLEADO IS NOT NULL;
COMMIT;


/*INSERTANDO EN TABLA EMPLEADOS*/
INSERT INTO EMPLEADO(nombre,apellido,direccion,telefono,fecha_nacimiento,
genero,id_titulo)
SELECT 
distinct t.NOMBRE_EMPLEADO, t.APELLIDO_EMPLEADO ,t.DIRECCION_EMPLEADO,t.TELEFONO_EMPLEADO,to_date(t.FECHA_NACIMIENTO_EMPLEADO,'YYYY-MM-DD'),
t.GENERO_EMPLEADO, ti.id_titulo
FROM temporal t
INNER JOIN TITULO ti
ON t.TITULO_DEL_EMPLEADO = ti.nombre
WHERE t.TITULO_DEL_EMPLEADO IS NOT NULL;
COMMIT;

/*INSERTANDO EN LA TABLA PACIENTES */

INSERT INTO PACIENTE (nombre,apellido,direccion,telefono,fecha_nacimiento,
genero,peso,altura)
SELECT
distinct t.NOMBRE_PACIENTE,t.APELLIDO_PACIENTE,t.DIRECCION_PACIENTE,t.TELEFONO_PACIENTE,
to_date(t.FECHA_NACIMIENTO_PACIENTE,'YYYY-MM-DD'),t.GENERO_PACIENTE,to_number(t.PESO),to_number(t.ALTURA)
FROM temporal t
WHERE t.NOMBRE_PACIENTE IS NOT NULL AND
t.APELLIDO_PACIENTE IS NOT NULL AND t.FECHA_NACIMIENTO_PACIENTE IS NOT NULL;
COMMIT;

/* INSERTANDO TABLA TRATAMIENTO */
INSERT INTO TRATAMIENTO(nombre)
SELECT 
distinct t.TRATAMIENTO_APLICADO
FROM temporal t
WHERE t.TRATAMIENTO_APLICADO IS NOT NULL;
COMMIT;


/* INSERTANDO TABLA DIAGNOSTICO */
INSERT INTO DIAGNOSTICO(nombre)
SELECT 
distinct t.DIAGNOSTICO_DEL_SINTOMA
FROM temporal t
WHERE t.DIAGNOSTICO_DEL_SINTOMA IS NOT NULL;
COMMIT;


/*INSERTANDO TABLA SINTOMA */
INSERT INTO SINTOMA(nombre)
SELECT 
distinct t.SINTOMA_DEL_PACIENTE
FROM temporal t
WHERE t.SINTOMA_DEL_PACIENTE IS NOT NULL;
COMMIT;


/*INSERTANDO TABLA EVALUACION */
INSERT INTO EVALUACION(fecha,id_paciente,id_empleado)
SELECT 
distinct to_date(t.FECHA_EVALUACION,'YYYY-MM-DD'), p.id_paciente,e.id_empleado
FROM temporal t
LEFT JOIN PACIENTE p
ON t.NOMBRE_PACIENTE = p.nombre AND t.APELLIDO_PACIENTE =p.apellido
LEFT JOIN EMPLEADO e
ON t.NOMBRE_EMPLEADO = e.nombre AND t.APELLIDO_EMPLEADO = e.apellido
WHERE t.FECHA_EVALUACION IS NOT NULL AND p.id_paciente IS NOT NULL AND e.id_empleado IS NOT NULL;
COMMIT;


/*INSERTANDO TABLA PACIENTE_TRATAMIENTO */
INSERT INTO PACIENTE_TRATAMIENTO(fecha,id_paciente,id_tratamiento)
SELECT
distinct to_date(t.FECHA_TRATAMIENTO,'YYYY-MM-DD'), p.id_paciente, tr.id_tratamiento
FROM temporal t
INNER JOIN PACIENTE p
ON t.NOMBRE_PACIENTE = p.nombre AND t.APELLIDO_PACIENTE =p.apellido
INNER JOIN TRATAMIENTO tr
ON tr.nombre = t.TRATAMIENTO_APLICADO
WHERE t.FECHA_TRATAMIENTO IS NOT NULL AND p.id_paciente IS NOT NULL AND tr.id_tratamiento IS NOT NULL;
COMMIT;


/*------INSERTANDO TABLA EVALUACION_SINTOMA--------*/

INSERT INTO EVALUACION_SINTOMA(
    id_evaluacion,
    id_sintoma
)
SELECT DISTINCT
    (SELECT id_evaluacion FROM EVALUACION e WHERE e.id_empleado = (
        SELECT id_empleado FROM EMPLEADO x 
        WHERE x.nombre = t.NOMBRE_EMPLEADO AND x.apellido = t.APELLIDO_EMPLEADO AND x.direccion = t.DIRECCION_EMPLEADO 
    ) AND e.id_paciente = (
        SELECT id_paciente FROM PACIENTE y 
        WHERE y.nombre = t.NOMBRE_PACIENTE AND y.apellido = t.APELLIDO_PACIENTE AND y.direccion = t.DIRECCION_PACIENTE 
    )AND e.fecha = TO_DATE(t.FECHA_EVALUACION,'YYYY-MM-DD')),
    (SELECT id_sintoma FROM SINTOMA s WHERE s.nombre = t.SINTOMA_DEL_PACIENTE)
FROM temporal t
WHERE t.SINTOMA_DEL_PACIENTE IS NOT NULL AND 
    t.NOMBRE_EMPLEADO IS NOT NULL AND
    t.DIRECCION_EMPLEADO IS NOT NULL AND
    t.APELLIDO_EMPLEADO IS NOT NULL AND
    t.NOMBRE_PACIENTE IS NOT NULL AND
    t.APELLIDO_PACIENTE IS NOT NULL AND
    t.DIRECCION_PACIENTE IS NOT NULL;
COMMIT;



/*INSERTANDO TABLA DIAGNOSTICO_SINTOMA */
INSERT INTO DIAGNOSTICO_SINTOMA(rango, id_diagnostico,id_sintoma)
SELECT DISTINCT
to_number(t.RANGO_DEL_DIAGNOSTICO), d.id_diagnostico, s.id_sintoma
from temporal t, DIAGNOSTICO d, SINTOMA s
WHERE t.DIAGNOSTICO_DEL_SINTOMA = d.nombre and t.SINTOMA_DEL_PACIENTE = s.nombre;
COMMIT;
