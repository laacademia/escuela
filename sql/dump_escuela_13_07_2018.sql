PGDMP     4    2                v            escuela    9.4.9    10.1 �   m
           0    0    ENCODING    ENCODING     #   SET client_encoding = 'SQL_ASCII';
                       false            n
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            o
           1262    968140    escuela    DATABASE     w   CREATE DATABASE escuela WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF8' LC_CTYPE = 'en_US.UTF8';
    DROP DATABASE escuela;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            p
           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    7            q
           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    7                        3079    11905    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            r
           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    968141    sp_trg_ai_cursadas()    FUNCTION     �  CREATE FUNCTION sp_trg_ai_cursadas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE    
BEGIN
	/* Se realiza una copia de los modulos del curso para la cursada */
	insert into cursadas_modulos(descripcion,mes,anio,observaciones,nombre,id_cursada,orden)
	select descripcion,mes,new.anio,observaciones,nombre,NEW.id,orden from cursos_modulos where id_curso=NEW.id_curso order by orden;
	RETURN NULL;
  END;
$$;
 +   DROP FUNCTION public.sp_trg_ai_cursadas();
       public       postgres    false    7    1                       1255    968142    sp_trg_ai_cursadas_alumnos()    FUNCTION     �  CREATE FUNCTION sp_trg_ai_cursadas_alumnos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      DECLARE
	_orden integer;
	_mes_modulo integer;
	_anio_modulo integer;
	_cantidad_modulos integer;
	_mes_inicio_cursada integer;
	m record; --modulos
      BEGIN             
	
	
	SELECT mes,anio into _mes_inicio_cursada,_anio_modulo FROM cursadas_modulos WHERE id_cursada =NEW.id_cursada ORDER BY mes ASC LIMIT 1; --primer mes de la cursada	
	SELECT count(1) into _cantidad_modulos FROM cursadas_modulos WHERE id_cursada =NEW.id_cursada; --cantidad de modulos de la cursada
	
	_mes_modulo = NEW.modulo_inicio;--modulo donde empieza el alumno	 
	_orden := 1;	
        for m in SELECT * FROM cursadas_modulos WHERE id_cursada =NEW.id_cursada ORDER BY mes,anio
        loop       
		IF(_mes_modulo>12)THEN	--si es el ultimo mes incremento el año
			_mes_modulo := _mes_inicio_cursada;
			_anio_modulo := _anio_modulo+1;
		END IF;
		
		INSERT INTO cursos_modulos_alumnos(id_curso,id_alumno,mes,anio,orden,id_estado_pago)
		VALUES(NEW.id_curso,NEW.id_alumno,_mes_modulo,_anio_modulo,_orden,1);
		
		_mes_modulo = _mes_modulo +1;
		_orden := _orden +1;
        end loop;       

      RETURN NULL;      
      END;
    $$;
 3   DROP FUNCTION public.sp_trg_ai_cursadas_alumnos();
       public       postgres    false    1    7            �            1259    968143    alquiler_sede    TABLE     9  CREATE TABLE alquiler_sede (
    id integer NOT NULL,
    id_sede integer NOT NULL,
    fecha date NOT NULL,
    valor_hora numeric(10,2) NOT NULL,
    fecha_alta timestamp without time zone DEFAULT now() NOT NULL,
    hora_desde time without time zone NOT NULL,
    hora_hasta time without time zone NOT NULL
);
 !   DROP TABLE public.alquiler_sede;
       public         postgres    false    7            �            1259    968147    alquiler_sede_cabecera    TABLE     G  CREATE TABLE alquiler_sede_cabecera (
    id integer NOT NULL,
    id_sede integer NOT NULL,
    descripcion character varying(255) NOT NULL,
    total numeric(10,2) NOT NULL,
    id_estado_pago integer DEFAULT 1 NOT NULL,
    mes integer,
    anio integer,
    fecha_alta timestamp without time zone DEFAULT now() NOT NULL
);
 *   DROP TABLE public.alquiler_sede_cabecera;
       public         postgres    false    7            �            1259    968152    alquiler_sede_cabecera_id_seq    SEQUENCE        CREATE SEQUENCE alquiler_sede_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.alquiler_sede_cabecera_id_seq;
       public       postgres    false    7    174            s
           0    0    alquiler_sede_cabecera_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE alquiler_sede_cabecera_id_seq OWNED BY alquiler_sede_cabecera.id;
            public       postgres    false    175            �            1259    968154    alquiler_sede_detalle    TABLE     v  CREATE TABLE alquiler_sede_detalle (
    id integer NOT NULL,
    id_aula integer NOT NULL,
    fecha date NOT NULL,
    valor_hora numeric(10,2),
    subtotal numeric(10,2),
    fecha_alta timestamp without time zone DEFAULT now() NOT NULL,
    hora_desde time without time zone NOT NULL,
    hora_hasta time without time zone NOT NULL,
    id_cabecera integer NOT NULL
);
 )   DROP TABLE public.alquiler_sede_detalle;
       public         postgres    false    7            �            1259    968158    alquiler_sede_detalle_id_seq    SEQUENCE     ~   CREATE SEQUENCE alquiler_sede_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.alquiler_sede_detalle_id_seq;
       public       postgres    false    7    176            t
           0    0    alquiler_sede_detalle_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE alquiler_sede_detalle_id_seq OWNED BY alquiler_sede_detalle.id;
            public       postgres    false    177            �            1259    968160    alquiler_sede_id_seq    SEQUENCE     v   CREATE SEQUENCE alquiler_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.alquiler_sede_id_seq;
       public       postgres    false    7    173            u
           0    0    alquiler_sede_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE alquiler_sede_id_seq OWNED BY alquiler_sede.id;
            public       postgres    false    178            �            1259    968162    personas    TABLE     `  CREATE TABLE personas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    dni numeric(8,0) NOT NULL,
    foto_dni boolean DEFAULT false NOT NULL,
    legajo integer NOT NULL,
    id_tipo_persona integer NOT NULL,
    cuil character varying(11)
);
    DROP TABLE public.personas;
       public         postgres    false    7            �            1259    968166    alumnos_id_seq    SEQUENCE     p   CREATE SEQUENCE alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.alumnos_id_seq;
       public       postgres    false    179    7            v
           0    0    alumnos_id_seq    SEQUENCE OWNED BY     4   ALTER SEQUENCE alumnos_id_seq OWNED BY personas.id;
            public       postgres    false    180            �            1259    968168    alumnos_legajo_seq    SEQUENCE     t   CREATE SEQUENCE alumnos_legajo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.alumnos_legajo_seq;
       public       postgres    false    7    179            w
           0    0    alumnos_legajo_seq    SEQUENCE OWNED BY     <   ALTER SEQUENCE alumnos_legajo_seq OWNED BY personas.legajo;
            public       postgres    false    181            �            1259    968170    aulas    TABLE     �   CREATE TABLE aulas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    piso integer,
    nombre character varying(60) NOT NULL,
    id_sede integer NOT NULL
);
    DROP TABLE public.aulas;
       public         postgres    false    7            �            1259    968173    aulas_id_seq    SEQUENCE     n   CREATE SEQUENCE aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.aulas_id_seq;
       public       postgres    false    7    182            x
           0    0    aulas_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE aulas_id_seq OWNED BY aulas.id;
            public       postgres    false    183            �            1259    968175    ciudades    TABLE     �   CREATE TABLE ciudades (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    cp integer NOT NULL,
    id_provincia integer NOT NULL
);
    DROP TABLE public.ciudades;
       public         postgres    false    7            �            1259    968178    ciudades_id_seq    SEQUENCE     q   CREATE SEQUENCE ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.ciudades_id_seq;
       public       postgres    false    184    7            y
           0    0    ciudades_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE ciudades_id_seq OWNED BY ciudades.id;
            public       postgres    false    185            �            1259    968180    clases    TABLE     O  CREATE TABLE clases (
    id integer NOT NULL,
    descripcion character varying NOT NULL,
    id_cursada integer NOT NULL,
    id_modulo integer NOT NULL,
    id_tipo_clase integer NOT NULL,
    fecha date NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    id_aula integer
);
    DROP TABLE public.clases;
       public         postgres    false    7            �            1259    968186    clases_asistencia    TABLE     |   CREATE TABLE clases_asistencia (
    id integer NOT NULL,
    id_persona integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_asistencia;
       public         postgres    false    7            �            1259    968189    clases_id_seq    SEQUENCE     o   CREATE SEQUENCE clases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.clases_id_seq;
       public       postgres    false    7    186            z
           0    0    clases_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE clases_id_seq OWNED BY clases.id;
            public       postgres    false    188            �            1259    968191    clases_profesores    TABLE     }   CREATE TABLE clases_profesores (
    id integer NOT NULL,
    id_profesor integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_profesores;
       public         postgres    false    7            �            1259    968194    clases_profesores_id_seq    SEQUENCE     z   CREATE SEQUENCE clases_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.clases_profesores_id_seq;
       public       postgres    false    7    189            {
           0    0    clases_profesores_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE clases_profesores_id_seq OWNED BY clases_profesores.id;
            public       postgres    false    190            �            1259    968196    condiciones_alumno    TABLE     m   CREATE TABLE condiciones_alumno (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 &   DROP TABLE public.condiciones_alumno;
       public         postgres    false    7            �            1259    968199    condiciones_alumno_id_seq    SEQUENCE     {   CREATE SEQUENCE condiciones_alumno_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.condiciones_alumno_id_seq;
       public       postgres    false    7    191            |
           0    0    condiciones_alumno_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE condiciones_alumno_id_seq OWNED BY condiciones_alumno.id;
            public       postgres    false    192            �            1259    968201    cursadas    TABLE     �   CREATE TABLE cursadas (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    id_curso integer NOT NULL,
    id_sede integer,
    anio integer
);
    DROP TABLE public.cursadas;
       public         postgres    false    7            �            1259    968204    cursadas_alumnos    TABLE     Z  CREATE TABLE cursadas_alumnos (
    id integer NOT NULL,
    id_cursada integer NOT NULL,
    id_alumno integer NOT NULL,
    id_condicion_alumno integer DEFAULT 2 NOT NULL,
    modulo_inicio integer NOT NULL,
    abono_matricula boolean DEFAULT false NOT NULL,
    fecha_inscripcion date DEFAULT now() NOT NULL,
    id_curso integer NOT NULL
);
 $   DROP TABLE public.cursadas_alumnos;
       public         postgres    false    7            �            1259    968210    cursadas_alumnos_id_seq    SEQUENCE     y   CREATE SEQUENCE cursadas_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_alumnos_id_seq;
       public       postgres    false    7    194            }
           0    0    cursadas_alumnos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE cursadas_alumnos_id_seq OWNED BY cursadas_alumnos.id;
            public       postgres    false    195            �            1259    968212    cursadas_cuotas    TABLE     �   CREATE TABLE cursadas_cuotas (
    id integer NOT NULL,
    importe numeric(10,2) NOT NULL,
    fecha_operacion timestamp without time zone DEFAULT now() NOT NULL,
    id_cursadas_modulos integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL
);
 #   DROP TABLE public.cursadas_cuotas;
       public         postgres    false    7            �            1259    968216    cursadas_cuotas_id_seq    SEQUENCE     x   CREATE SEQUENCE cursadas_cuotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cursadas_cuotas_id_seq;
       public       postgres    false    196    7            ~
           0    0    cursadas_cuotas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE cursadas_cuotas_id_seq OWNED BY cursadas_cuotas.id;
            public       postgres    false    197            �            1259    968218    cursadas_id_seq    SEQUENCE     q   CREATE SEQUENCE cursadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.cursadas_id_seq;
       public       postgres    false    7    193            
           0    0    cursadas_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE cursadas_id_seq OWNED BY cursadas.id;
            public       postgres    false    198            �            1259    968220    cursadas_modulos    TABLE     [  CREATE TABLE cursadas_modulos (
    id integer NOT NULL,
    descripcion character varying NOT NULL,
    mes integer NOT NULL,
    observaciones character varying,
    nombre character varying(100) NOT NULL,
    id_cursada integer NOT NULL,
    anio integer,
    orden integer,
    fecha_inicio date,
    fecha_fin date,
    nro_modulo integer
);
 $   DROP TABLE public.cursadas_modulos;
       public         postgres    false    7            �            1259    968226    cursadas_modulos_alumnos    TABLE     �   CREATE TABLE cursadas_modulos_alumnos (
    id integer NOT NULL,
    id_modulo integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL,
    orden integer
);
 ,   DROP TABLE public.cursadas_modulos_alumnos;
       public         postgres    false    7            �            1259    968229    cursadas_modulos_alumnos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursadas_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.cursadas_modulos_alumnos_id_seq;
       public       postgres    false    200    7            �
           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE cursadas_modulos_alumnos_id_seq OWNED BY cursadas_modulos_alumnos.id;
            public       postgres    false    201            �            1259    968231    cursadas_modulos_id_seq    SEQUENCE     y   CREATE SEQUENCE cursadas_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_modulos_id_seq;
       public       postgres    false    7    199            �
           0    0    cursadas_modulos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE cursadas_modulos_id_seq OWNED BY cursadas_modulos.id;
            public       postgres    false    202            �            1259    968233    cursadas_profesores    TABLE     �   CREATE TABLE cursadas_profesores (
    id integer NOT NULL,
    id_cursada integer NOT NULL,
    id_profesor integer NOT NULL,
    id_tipo_profesor integer NOT NULL
);
 '   DROP TABLE public.cursadas_profesores;
       public         postgres    false    7            �            1259    968236    cursadas_profesores_id_seq    SEQUENCE     |   CREATE SEQUENCE cursadas_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.cursadas_profesores_id_seq;
       public       postgres    false    203    7            �
           0    0    cursadas_profesores_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE cursadas_profesores_id_seq OWNED BY cursadas_profesores.id;
            public       postgres    false    204            �            1259    968238    cursos    TABLE     #  CREATE TABLE cursos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(255) NOT NULL,
    duracion integer NOT NULL,
    porcentaje_correlativa numeric(10,2) DEFAULT 100 NOT NULL,
    cant_minimo_alumnos integer,
    cant_maxima_alumnos integer,
    cant_modulos integer NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    cant_clases_practicas integer,
    cant_clases_teoricas integer,
    certificado_incluido boolean NOT NULL,
    monto_certificado numeric(10,2),
    orden integer
);
    DROP TABLE public.cursos;
       public         postgres    false    7            �
           0    0 $   COLUMN cursos.porcentaje_correlativa    COMMENT     �   COMMENT ON COLUMN cursos.porcentaje_correlativa IS 'porcentaje necesario para poder cursar los siguientes cursos que son correlativos';
            public       postgres    false    205            �
           0    0 "   COLUMN cursos.certificado_incluido    COMMENT     e   COMMENT ON COLUMN cursos.certificado_incluido IS 'Si el certificado esta incluido o se paga aparte';
            public       postgres    false    205            �            1259    968243    cursos_correlatividad    TABLE     �   CREATE TABLE cursos_correlatividad (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_curso_previo integer NOT NULL
);
 )   DROP TABLE public.cursos_correlatividad;
       public         postgres    false    7            �            1259    968246    cursos_correlatividad_id_seq    SEQUENCE     ~   CREATE SEQUENCE cursos_correlatividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.cursos_correlatividad_id_seq;
       public       postgres    false    206    7            �
           0    0    cursos_correlatividad_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE cursos_correlatividad_id_seq OWNED BY cursos_correlatividad.id;
            public       postgres    false    207            �            1259    968248    cursos_id_seq    SEQUENCE     o   CREATE SEQUENCE cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.cursos_id_seq;
       public       postgres    false    7    205            �
           0    0    cursos_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE cursos_id_seq OWNED BY cursos.id;
            public       postgres    false    208            �            1259    968250    cursos_modulos    TABLE       CREATE TABLE cursos_modulos (
    id integer NOT NULL,
    descripcion character varying NOT NULL,
    mes integer NOT NULL,
    observaciones character varying,
    nombre character varying(100) NOT NULL,
    id_curso integer NOT NULL,
    orden integer,
    nro_modulo integer
);
 "   DROP TABLE public.cursos_modulos;
       public         postgres    false    7            �            1259    968256    cursos_modulos_alumnos    TABLE     �   CREATE TABLE cursos_modulos_alumnos (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_alumno integer NOT NULL,
    mes integer NOT NULL,
    anio integer NOT NULL,
    orden integer NOT NULL,
    id_estado_pago integer
);
 *   DROP TABLE public.cursos_modulos_alumnos;
       public         postgres    false    7            �            1259    968259    cursos_modulos_alumnos_id_seq    SEQUENCE        CREATE SEQUENCE cursos_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.cursos_modulos_alumnos_id_seq;
       public       postgres    false    210    7            �
           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE cursos_modulos_alumnos_id_seq OWNED BY cursos_modulos_alumnos.id;
            public       postgres    false    211            �            1259    968261    cursos_modulos_id_seq    SEQUENCE     w   CREATE SEQUENCE cursos_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cursos_modulos_id_seq;
       public       postgres    false    209    7            �
           0    0    cursos_modulos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE cursos_modulos_id_seq OWNED BY cursos_modulos.id;
            public       postgres    false    212            �            1259    968263    databasechangeloglock    TABLE     �   CREATE TABLE databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);
 )   DROP TABLE public.databasechangeloglock;
       public         postgres    false    7            �            1259    968266    datos_academicos    TABLE     �   CREATE TABLE datos_academicos (
    id integer NOT NULL,
    id_nivel_estudio integer,
    estudia_actualmente boolean,
    institucion_estudia character varying(100),
    dias integer,
    horas integer,
    id_persona integer NOT NULL
);
 $   DROP TABLE public.datos_academicos;
       public         postgres    false    7            �            1259    968269    datos_academicos_id_seq    SEQUENCE     y   CREATE SEQUENCE datos_academicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.datos_academicos_id_seq;
       public       postgres    false    214    7            �
           0    0    datos_academicos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE datos_academicos_id_seq OWNED BY datos_academicos.id;
            public       postgres    false    215            �            1259    968271    datos_actuales    TABLE     b  CREATE TABLE datos_actuales (
    id integer NOT NULL,
    calle character varying(255),
    altura integer,
    piso integer,
    id_ciudad integer,
    telefono_particular character varying(15),
    telefono_celular character varying(15),
    telefono_mensaje character varying(15),
    email character varying(100),
    id_persona integer NOT NULL
);
 "   DROP TABLE public.datos_actuales;
       public         postgres    false    7            �            1259    968274    datos_actuales_id_seq    SEQUENCE     w   CREATE SEQUENCE datos_actuales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.datos_actuales_id_seq;
       public       postgres    false    7    216            �
           0    0    datos_actuales_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE datos_actuales_id_seq OWNED BY datos_actuales.id;
            public       postgres    false    217            �            1259    968276    datos_laborales    TABLE     K  CREATE TABLE datos_laborales (
    id integer NOT NULL,
    id_profesion integer,
    empresa_trabaja character varying(100),
    domicilio_trabaja character varying(500),
    telefono_laboral character varying(15),
    email_laboral character varying(255),
    id_persona integer NOT NULL,
    profesion character varying(255)
);
 #   DROP TABLE public.datos_laborales;
       public         postgres    false    7            �            1259    968282    datos_laborales_id_seq    SEQUENCE     x   CREATE SEQUENCE datos_laborales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.datos_laborales_id_seq;
       public       postgres    false    7    218            �
           0    0    datos_laborales_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE datos_laborales_id_seq OWNED BY datos_laborales.id;
            public       postgres    false    219            �            1259    968284    datos_salud    TABLE       CREATE TABLE datos_salud (
    id integer NOT NULL,
    cobertura_medica character varying(100),
    apto_curso boolean,
    observaciones_medicas character varying(255),
    certificado_medico boolean,
    id_persona integer NOT NULL,
    id_grupo_sanguineo integer
);
    DROP TABLE public.datos_salud;
       public         postgres    false    7            �            1259    968287    datos_salud_id_seq    SEQUENCE     t   CREATE SEQUENCE datos_salud_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.datos_salud_id_seq;
       public       postgres    false    220    7            �
           0    0    datos_salud_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE datos_salud_id_seq OWNED BY datos_salud.id;
            public       postgres    false    221            �            1259    968289    estados_pago    TABLE     h   CREATE TABLE estados_pago (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
     DROP TABLE public.estados_pago;
       public         postgres    false    7            �            1259    968292    estados_pago_id_seq    SEQUENCE     u   CREATE SEQUENCE estados_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.estados_pago_id_seq;
       public       postgres    false    7    222            �
           0    0    estados_pago_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE estados_pago_id_seq OWNED BY estados_pago.id;
            public       postgres    false    223            �            1259    968294    grupos_sanguineos    TABLE     m   CREATE TABLE grupos_sanguineos (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 %   DROP TABLE public.grupos_sanguineos;
       public         postgres    false    7            �            1259    968297    grupos_sanguineos_id_seq    SEQUENCE     z   CREATE SEQUENCE grupos_sanguineos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.grupos_sanguineos_id_seq;
       public       postgres    false    7    224            �
           0    0    grupos_sanguineos_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE grupos_sanguineos_id_seq OWNED BY grupos_sanguineos.id;
            public       postgres    false    225            �            1259    968299    inscripciones_modulos    TABLE     �   CREATE TABLE inscripciones_modulos (
    id integer NOT NULL,
    id_inscripcion integer NOT NULL,
    mes_modulo integer NOT NULL,
    anio_modulo integer NOT NULL,
    id_estado_pago integer
);
 )   DROP TABLE public.inscripciones_modulos;
       public         postgres    false    7            �            1259    968302    inscripciones_modulos_id_seq    SEQUENCE     ~   CREATE SEQUENCE inscripciones_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.inscripciones_modulos_id_seq;
       public       postgres    false    7    226            �
           0    0    inscripciones_modulos_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE inscripciones_modulos_id_seq OWNED BY inscripciones_modulos.id;
            public       postgres    false    227            �            1259    968304    modulos    TABLE     �   CREATE TABLE modulos (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    numero integer NOT NULL,
    id_curso integer NOT NULL,
    porcentaje_presencia numeric(10,2) DEFAULT 100 NOT NULL
);
    DROP TABLE public.modulos;
       public         postgres    false    7            �            1259    968308    modulos_id_seq    SEQUENCE     p   CREATE SEQUENCE modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.modulos_id_seq;
       public       postgres    false    228    7            �
           0    0    modulos_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE modulos_id_seq OWNED BY modulos.id;
            public       postgres    false    229            �            1259    968310    niveles_estudios    TABLE     l   CREATE TABLE niveles_estudios (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 $   DROP TABLE public.niveles_estudios;
       public         postgres    false    7            �            1259    968313    niveles_estudios_id_seq    SEQUENCE     y   CREATE SEQUENCE niveles_estudios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.niveles_estudios_id_seq;
       public       postgres    false    7    230            �
           0    0    niveles_estudios_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE niveles_estudios_id_seq OWNED BY niveles_estudios.id;
            public       postgres    false    231            �            1259    968315    paises    TABLE     �   CREATE TABLE paises (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    nacionalidad character varying(60) NOT NULL
);
    DROP TABLE public.paises;
       public         postgres    false    7            �            1259    968318    paises_id_seq    SEQUENCE     o   CREATE SEQUENCE paises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.paises_id_seq;
       public       postgres    false    232    7            �
           0    0    paises_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE paises_id_seq OWNED BY paises.id;
            public       postgres    false    233            �            1259    968320    perfiles    TABLE     E   CREATE TABLE perfiles (
    perfil character varying(60) NOT NULL
);
    DROP TABLE public.perfiles;
       public         postgres    false    7            �            1259    968323    profesiones    TABLE     ^   CREATE TABLE profesiones (
    id integer NOT NULL,
    descripcion character varying(255)
);
    DROP TABLE public.profesiones;
       public         postgres    false    7            �            1259    968326    profesiones_id_seq    SEQUENCE     t   CREATE SEQUENCE profesiones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.profesiones_id_seq;
       public       postgres    false    7    235            �
           0    0    profesiones_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE profesiones_id_seq OWNED BY profesiones.id;
            public       postgres    false    236            �            1259    968328 
   provincias    TABLE     z   CREATE TABLE provincias (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    id_pais integer NOT NULL
);
    DROP TABLE public.provincias;
       public         postgres    false    7            �            1259    968334    provincias_id_seq    SEQUENCE     s   CREATE SEQUENCE provincias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.provincias_id_seq;
       public       postgres    false    7    237            �
           0    0    provincias_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE provincias_id_seq OWNED BY provincias.id;
            public       postgres    false    238            �            1259    968336    sedes    TABLE       CREATE TABLE sedes (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    nombre_espacio character varying(100),
    nombre_titular character varying(100) NOT NULL,
    apellido_titular character varying(100) NOT NULL,
    telefono_titular character varying(15),
    calle character varying(255) NOT NULL,
    altura integer,
    piso integer,
    id_ciudad integer NOT NULL,
    valor_hora numeric(10,2),
    activo boolean DEFAULT true NOT NULL,
    paga_alquiler boolean NOT NULL,
    id_tipo_pago_sede integer
);
    DROP TABLE public.sedes;
       public         postgres    false    7            �            1259    968343    sedes_formadores    TABLE     {   CREATE TABLE sedes_formadores (
    id integer NOT NULL,
    id_formador integer NOT NULL,
    id_sede integer NOT NULL
);
 $   DROP TABLE public.sedes_formadores;
       public         postgres    false    7            �            1259    968346    sedes_formadores_id_seq    SEQUENCE     y   CREATE SEQUENCE sedes_formadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sedes_formadores_id_seq;
       public       postgres    false    240    7            �
           0    0    sedes_formadores_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE sedes_formadores_id_seq OWNED BY sedes_formadores.id;
            public       postgres    false    241            �            1259    968348    sedes_id_seq    SEQUENCE     n   CREATE SEQUENCE sedes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sedes_id_seq;
       public       postgres    false    239    7            �
           0    0    sedes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE sedes_id_seq OWNED BY sedes.id;
            public       postgres    false    242                       1259    976408    temp_ciudades    TABLE     u   CREATE TABLE temp_ciudades (
    id integer NOT NULL,
    ciudad character varying(200),
    id_localidad integer
);
 !   DROP TABLE public.temp_ciudades;
       public         postgres    false    7                       1259    976406    temp_ciudades_id_seq    SEQUENCE     v   CREATE SEQUENCE temp_ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_ciudades_id_seq;
       public       postgres    false    7    273            �
           0    0    temp_ciudades_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE temp_ciudades_id_seq OWNED BY temp_ciudades.id;
            public       postgres    false    272                       1259    976387    temp_personas    TABLE     I  CREATE TABLE temp_personas (
    id integer NOT NULL,
    legajo integer,
    sede character varying(100),
    apellido character varying(100),
    nombre character varying(100),
    fecha_nacimiento character varying(100),
    nacionalidad character varying(100),
    dni character varying(100),
    cuil character varying(100),
    calle character varying(100),
    numero character varying(100),
    piso character varying(100),
    codigo_postal integer,
    ciudad character varying(100),
    provincia character varying(100),
    pais character varying(100),
    tel_particular character varying(100),
    tel_celular character varying(100),
    tel_mensaje character varying(100),
    email character varying(100),
    grupo_sang character varying(100),
    cobertura_medica character varying(100),
    apto_curso character varying(10),
    observaciones character varying(500),
    primario character varying(100),
    secundario character varying(100),
    terciario character varying(100),
    estudia character varying(100),
    institucion character varying(100),
    profesion character varying(100),
    empresa character varying(100),
    domicilio character varying(500),
    tel_laboral character varying(100),
    email_laboral character varying(100),
    foto character varying(100),
    foto_dni character varying(100),
    cert_medico character varying(100),
    reglamento character varying(100),
    activo character varying(100),
    fecha_egreso character varying(100),
    libreta character varying(100),
    fecha_inicio character varying(100),
    curso1 character varying(100)
);
 !   DROP TABLE public.temp_personas;
       public         postgres    false    7                       1259    976379    temp_personas2    TABLE     1  CREATE TABLE temp_personas2 (
    legajo integer,
    sede character varying(100),
    apellido character varying(100),
    nombre character varying(100),
    fecha_nacimiento character varying(100),
    nacionalidad character varying(100),
    dni character varying(100),
    cuil character varying(100),
    calle character varying(100),
    numero character varying(100),
    piso character varying(100),
    codigo_postal integer,
    ciudad character varying(100),
    provincia character varying(100),
    pais character varying(100),
    tel_particular character varying(100),
    tel_celular character varying(100),
    tel_mensaje character varying(100),
    email character varying(100),
    grupo_sang character varying(100),
    cobertura_medica character varying(100),
    apto_curso character varying(10),
    observaciones character varying(500),
    primario character varying(100),
    secundario character varying(100),
    terciario character varying(100),
    estudia character varying(100),
    institucion character varying(100),
    profesion character varying(100),
    empresa character varying(100),
    domicilio character varying(500),
    tel_laboral character varying(100),
    email_laboral character varying(100),
    foto character varying(100),
    foto_dni character varying(100),
    cert_medico character varying(100),
    reglamento character varying(100),
    activo character varying(100),
    fecha_egreso character varying(100),
    libreta character varying(100),
    fecha_inicio character varying(100),
    curso1 character varying(100)
);
 "   DROP TABLE public.temp_personas2;
       public         postgres    false    7                       1259    976385    temp_personas_id_seq    SEQUENCE     v   CREATE SEQUENCE temp_personas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_personas_id_seq;
       public       postgres    false    271    7            �
           0    0    temp_personas_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE temp_personas_id_seq OWNED BY temp_personas.id;
            public       postgres    false    270            �            1259    968350 
   tipo_clase    TABLE     e   CREATE TABLE tipo_clase (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_clase;
       public         postgres    false    7            �            1259    968353    tipo_clase_id_seq    SEQUENCE     s   CREATE SEQUENCE tipo_clase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tipo_clase_id_seq;
       public       postgres    false    7    243            �
           0    0    tipo_clase_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE tipo_clase_id_seq OWNED BY tipo_clase.id;
            public       postgres    false    244            �            1259    968355 	   tipo_pago    TABLE     d   CREATE TABLE tipo_pago (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_pago;
       public         postgres    false    7            �            1259    968358    tipo_pago_id_seq    SEQUENCE     r   CREATE SEQUENCE tipo_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tipo_pago_id_seq;
       public       postgres    false    245    7            �
           0    0    tipo_pago_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE tipo_pago_id_seq OWNED BY tipo_pago.id;
            public       postgres    false    246            �            1259    968360    tipo_pago_sede    TABLE     j   CREATE TABLE tipo_pago_sede (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 "   DROP TABLE public.tipo_pago_sede;
       public         postgres    false    7            �            1259    968363    tipo_pago_sede_id_seq    SEQUENCE     w   CREATE SEQUENCE tipo_pago_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tipo_pago_sede_id_seq;
       public       postgres    false    7    247            �
           0    0    tipo_pago_sede_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE tipo_pago_sede_id_seq OWNED BY tipo_pago_sede.id;
            public       postgres    false    248            �            1259    968365    tipo_persona    TABLE     g   CREATE TABLE tipo_persona (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
     DROP TABLE public.tipo_persona;
       public         postgres    false    7            �            1259    968368    tipo_persona_id_seq    SEQUENCE     u   CREATE SEQUENCE tipo_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.tipo_persona_id_seq;
       public       postgres    false    7    249            �
           0    0    tipo_persona_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE tipo_persona_id_seq OWNED BY tipo_persona.id;
            public       postgres    false    250            �            1259    968370    tipo_persona_perfiles    TABLE     �   CREATE TABLE tipo_persona_perfiles (
    id integer NOT NULL,
    id_tipo_persona integer NOT NULL,
    perfil character varying(60)
);
 )   DROP TABLE public.tipo_persona_perfiles;
       public         postgres    false    7            �
           0    0    TABLE tipo_persona_perfiles    COMMENT     Z   COMMENT ON TABLE tipo_persona_perfiles IS 'Perfiles a asignar cuando se crea un usuario';
            public       postgres    false    251            �            1259    968373    tipo_persona_perfiles_id_seq    SEQUENCE     ~   CREATE SEQUENCE tipo_persona_perfiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tipo_persona_perfiles_id_seq;
       public       postgres    false    251    7            �
           0    0    tipo_persona_perfiles_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE tipo_persona_perfiles_id_seq OWNED BY tipo_persona_perfiles.id;
            public       postgres    false    252            �            1259    968375    tipo_profesor    TABLE     h   CREATE TABLE tipo_profesor (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 !   DROP TABLE public.tipo_profesor;
       public         postgres    false    7            �            1259    968378    tipo_profesor_id_seq    SEQUENCE     v   CREATE SEQUENCE tipo_profesor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tipo_profesor_id_seq;
       public       postgres    false    253    7            �
           0    0    tipo_profesor_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE tipo_profesor_id_seq OWNED BY tipo_profesor.id;
            public       postgres    false    254            �            1259    968380    usuario_persona    TABLE     �   CREATE TABLE usuario_persona (
    id integer NOT NULL,
    usuario character varying(60) NOT NULL,
    id_persona integer NOT NULL
);
 #   DROP TABLE public.usuario_persona;
       public         postgres    false    7                        1259    968383    usuario_persona_id_seq    SEQUENCE     x   CREATE SEQUENCE usuario_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_persona_id_seq;
       public       postgres    false    255    7            �
           0    0    usuario_persona_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE usuario_persona_id_seq OWNED BY usuario_persona.id;
            public       postgres    false    256                       1259    968385    v_sedes    VIEW     �  CREATE VIEW v_sedes AS
 SELECT s.id,
    s.nombre,
    s.nombre_espacio,
    s.nombre_titular,
    s.apellido_titular,
    s.telefono_titular,
    s.calle,
    s.altura,
    s.piso,
    s.id_ciudad,
    s.paga_alquiler,
    s.valor_hora,
    s.activo,
    c.nombre AS ciudad,
    pr.nombre AS provincia,
    p.nombre AS pais,
    ((s.nombre)::text || COALESCE((((((', Localidad: '::text || (c.nombre)::text) || ', '::text) || (pr.nombre)::text) || ', '::text) || (p.nombre)::text), ''::text)) AS sede_descripcion
   FROM (((sedes s
     LEFT JOIN ciudades c ON ((c.id = s.id_ciudad)))
     LEFT JOIN provincias pr ON ((pr.id = c.id_provincia)))
     LEFT JOIN paises p ON ((p.id = pr.id_pais)));
    DROP VIEW public.v_sedes;
       public       postgres    false    232    184    184    232    239    239    237    237    184    237    239    239    239    239    239    239    239    239    239    239    239    7                       1259    968390    v_alquiler_cabecera    VIEW     �  CREATE VIEW v_alquiler_cabecera AS
 SELECT c.id,
    c.id_sede,
    c.descripcion,
    c.total,
    c.id_estado_pago,
    c.mes,
    c.anio,
    c.fecha_alta,
    ep.descripcion AS estado_pago,
    s.sede_descripcion,
    ((c.anio || '-'::text) || c.mes) AS periodo,
    s.id_ciudad,
    s.ciudad,
    s.pais,
    s.provincia
   FROM ((alquiler_sede_cabecera c
     LEFT JOIN estados_pago ep ON ((ep.id = c.id_estado_pago)))
     LEFT JOIN v_sedes s ON ((s.id = c.id_sede)));
 &   DROP VIEW public.v_alquiler_cabecera;
       public       postgres    false    174    174    174    174    174    174    174    174    222    222    257    257    257    257    257    257    7                       1259    968395    v_aulas    VIEW     �  CREATE VIEW v_aulas AS
 SELECT a.id,
    a.nombre,
    a.descripcion,
    a.piso,
    a.id_sede,
    s.nombre AS nombre_sede,
    s.nombre_titular,
    s.apellido_titular,
    s.calle,
    s.altura,
    s.piso AS piso_sede,
    s.id_ciudad,
    s.paga_alquiler,
    s.valor_hora AS valor_hora_sede,
    s.activo,
    s.ciudad,
    s.provincia,
    s.pais,
    s.sede_descripcion
   FROM (aulas a
     JOIN v_sedes s ON ((s.id = a.id_sede)));
    DROP VIEW public.v_aulas;
       public       postgres    false    257    257    257    257    257    257    257    257    257    257    257    182    182    182    182    182    257    257    257    257    7                       1259    968400 
   v_ciudades    VIEW     �  CREATE VIEW v_ciudades AS
 SELECT s.id,
    s.nombre,
    s.cp,
    s.id_provincia,
    s.provincia,
    s.id_pais,
    s.pais
   FROM ( SELECT c.id,
            c.nombre,
            c.cp,
            c.id_provincia,
            pr.nombre AS provincia,
            pr.id_pais,
            p.nombre AS pais
           FROM ((ciudades c
             JOIN provincias pr ON ((c.id_provincia = pr.id)))
             JOIN paises p ON ((p.id = pr.id_pais)))) s;
    DROP VIEW public.v_ciudades;
       public       postgres    false    232    237    237    237    232    184    184    184    184    7                       1259    968404    v_clases    VIEW     *  CREATE VIEW v_clases AS
 SELECT c.id,
    c.descripcion AS clase_descripcion,
    c.fecha,
    c.hora_inicio,
    c.hora_fin,
    c.id_tipo_clase,
    tc.descripcion AS tipo_clase,
    c.id_modulo,
    cm.nombre AS nombre_modulo,
    cm.descripcion AS descripcion_modulo,
    cm.mes AS mes_modulo,
    c.id_cursada,
    cu.descripcion AS cursada_descripcion,
    cu.fecha_inicio AS fecha_inicio_cursada,
    cu.fecha_fin AS fecha_fin_cursada,
    cursos.id AS id_curso,
    cursos.nombre AS nombre_curso,
    cursos.descripcion AS curso_descripcion,
    cursos.duracion AS duracion_curso,
    cursos.cant_minimo_alumnos,
    cursos.cant_maxima_alumnos,
    cursos.cant_modulos,
    cursos.activo,
    cursos.certificado_incluido,
    cursos.monto_certificado
   FROM (((((clases c
     LEFT JOIN cursadas cu ON ((cu.id = c.id_cursada)))
     LEFT JOIN cursadas_modulos cm ON ((cm.id = c.id_modulo)))
     LEFT JOIN cursos ON ((cursos.id = cu.id_curso)))
     LEFT JOIN aulas au ON ((au.id = c.id_aula)))
     LEFT JOIN tipo_clase tc ON ((tc.id = c.id_tipo_clase)));
    DROP VIEW public.v_clases;
       public       postgres    false    182    186    186    186    186    186    186    186    186    186    193    193    193    193    193    199    199    199    199    205    205    205    205    205    205    205    205    205    205    243    243    7                       1259    968409 
   v_cursadas    VIEW     �  CREATE VIEW v_cursadas AS
 SELECT cu.id,
    cu.descripcion,
    cu.fecha_inicio,
    cu.fecha_fin,
    cu.id_curso,
    c.nombre AS curso,
    c.descripcion AS descripcion_curso,
    c.duracion AS duracion_curso,
    c.porcentaje_correlativa,
    c.cant_minimo_alumnos,
    c.cant_maxima_alumnos,
    c.cant_modulos,
    c.activo,
    cu.id_sede,
    s.nombre AS sede,
    s.sede_descripcion
   FROM ((cursadas cu
     JOIN cursos c ON ((c.id = cu.id_curso)))
     JOIN v_sedes s ON ((s.id = cu.id_sede)));
    DROP VIEW public.v_cursadas;
       public       postgres    false    193    193    193    193    193    193    205    205    205    205    205    205    205    205    205    257    257    257    7                       1259    968414 
   v_personas    VIEW     �  CREATE VIEW v_personas AS
 SELECT a.id,
    a.nombre,
    a.apellido,
    a.fecha_nacimiento,
    a.dni,
    a.foto_dni,
    a.legajo,
    a.id_tipo_persona,
    tp.descripcion AS tipo_persona,
    aca.id_nivel_estudio,
    ne.descripcion AS nivel_estudio,
    aca.estudia_actualmente,
    aca.institucion_estudia,
    aca.dias,
    aca.horas,
    act.calle,
    act.altura,
    act.piso,
    act.id_ciudad,
    ciu.nombre AS ciudad,
    ciu.cp,
    ciu.id_provincia,
    pro.nombre AS provincia,
    pro.id_pais,
    pai.nombre AS pais,
    act.telefono_particular,
    act.telefono_celular,
    act.telefono_mensaje,
    act.email,
    dl.id_profesion,
    p.descripcion AS profesion,
    dl.empresa_trabaja,
    dl.domicilio_trabaja,
    dl.telefono_laboral,
    dl.email_laboral,
    ds.cobertura_medica,
    ds.apto_curso,
    ds.observaciones_medicas,
    ds.certificado_medico,
    ds.id_grupo_sanguineo,
    gs.descripcion AS grupo_sanguineo,
    ((((a.dni || ' - '::text) || (a.apellido)::text) || ' '::text) || (a.nombre)::text) AS descripcion
   FROM (((((((((((personas a
     LEFT JOIN tipo_persona tp ON ((tp.id = a.id_tipo_persona)))
     LEFT JOIN datos_academicos aca ON ((a.id = aca.id_persona)))
     LEFT JOIN datos_actuales act ON ((a.id = act.id_persona)))
     LEFT JOIN datos_laborales dl ON ((a.id = dl.id_persona)))
     LEFT JOIN datos_salud ds ON ((a.id = ds.id_persona)))
     LEFT JOIN grupos_sanguineos gs ON ((ds.id_grupo_sanguineo = gs.id)))
     LEFT JOIN niveles_estudios ne ON ((aca.id_nivel_estudio = ne.id)))
     LEFT JOIN profesiones p ON ((dl.id_profesion = p.id)))
     LEFT JOIN ciudades ciu ON ((ciu.id = act.id_ciudad)))
     LEFT JOIN provincias pro ON ((pro.id = ciu.id_provincia)))
     LEFT JOIN paises pai ON ((pai.id = pro.id_pais)));
    DROP VIEW public.v_personas;
       public       postgres    false    216    214    214    184    184    184    184    179    179    179    179    179    179    179    179    216    216    216    216    216    214    218    218    218    218    218    218    220    220    220    220    220    220    224    224    230    230    232    232    235    235    237    237    237    249    249    216    216    216    214    214    214    7                       1259    968419    v_cursadas_alumnos    VIEW       CREATE VIEW v_cursadas_alumnos AS
 SELECT ca.id,
    ca.id_cursada,
    ca.id_alumno,
    ca.id_condicion_alumno,
    ca.modulo_inicio,
    ca.abono_matricula,
    ca.fecha_inscripcion,
    c.id_curso,
    c.curso,
    c.descripcion_curso,
    c.descripcion AS cursada,
    c.fecha_inicio AS fecha_inicio_cursada,
    c.fecha_fin AS fecha_fin_cursada,
    c.sede,
    c.sede_descripcion,
    p.nombre AS nombre_alumno,
    p.apellido AS apellido_alumno,
    p.dni,
    p.legajo,
    p.telefono_celular,
    p.telefono_mensaje,
    p.email,
    p.apto_curso,
    p.certificado_medico
   FROM (((cursadas_alumnos ca
     JOIN v_cursadas c ON ((c.id = ca.id_cursada)))
     JOIN v_personas p ON ((p.id = ca.id_alumno)))
     JOIN condiciones_alumno cond ON ((cond.id = ca.id_condicion_alumno)));
 %   DROP VIEW public.v_cursadas_alumnos;
       public       postgres    false    191    262    262    262    262    262    262    262    194    194    262    262    263    263    263    263    263    263    263    263    263    263    194    194    194    194    194    7            	           1259    968424    v_cursadas_modulos    VIEW     �  CREATE VIEW v_cursadas_modulos AS
 SELECT cm.id,
    cm.descripcion,
    cm.mes,
    cm.observaciones,
    cm.nombre,
    cm.id_cursada,
    cm.anio,
    ((((cm.anio || '-'::text) || cm.mes) || '-01'::text))::date AS periodo,
    (((((cm.anio || '-'::text) || cm.mes) || '-01'::text))::date >= (((((date_part('year'::text, now()) || '-'::text) || date_part('month'::text, now())) || '-'::text) || date_part('day'::text, now())))::date) AS modulo_vigente,
    c.descripcion AS cursada,
    c.id_curso,
    c.curso,
    c.descripcion_curso,
    c.duracion_curso,
    cm.orden,
    c.id_sede,
    c.sede,
    cm.nro_modulo
   FROM (cursadas_modulos cm
     JOIN v_cursadas c ON ((c.id = cm.id_cursada)));
 %   DROP VIEW public.v_cursadas_modulos;
       public       postgres    false    262    199    199    262    262    262    199    199    199    262    199    199    262    262    199    262    199    7                       1259    968804    v_cursadas_modulos_alumnos    VIEW     �  CREATE VIEW v_cursadas_modulos_alumnos AS
 SELECT cma.id,
    cma.id_modulo,
    cma.id_cursadas_alumnos,
    cma.orden,
    cm.descripcion AS modulo_descripcion,
    cm.mes AS mes_modulo,
    cm.anio AS anio_modulo,
    cm.nombre AS modulo_nombre,
    cm.id_cursada,
    cm.cursada,
    cm.anio AS anio_cursada,
    cm.periodo AS periodo_cursada,
    cm.modulo_vigente,
    ca.fecha_inicio_cursada,
    ca.fecha_fin_cursada,
    cm.id_curso,
    cm.curso,
    cm.id_sede,
    cm.sede,
    ca.sede_descripcion,
    ca.id_condicion_alumno,
    ca.fecha_inscripcion,
    ca.nombre_alumno,
    ca.apellido_alumno,
    ca.dni,
    ca.legajo,
    ca.telefono_celular,
    ca.telefono_mensaje,
    ca.email,
    ca.apto_curso,
    ca.certificado_medico
   FROM ((cursadas_modulos_alumnos cma
     LEFT JOIN v_cursadas_modulos cm ON ((cm.id = cma.id_modulo)))
     LEFT JOIN v_cursadas_alumnos ca ON ((ca.id = cma.id_cursadas_alumnos)));
 -   DROP VIEW public.v_cursadas_modulos_alumnos;
       public       postgres    false    265    265    265    265    265    265    200    265    265    265    265    265    265    265    264    264    264    264    264    264    264    264    264    264    264    264    264    264    264    200    200    200    7            
           1259    968429    v_provincias    VIEW     �   CREATE VIEW v_provincias AS
 SELECT pr.id,
    pr.nombre,
    pr.id_pais,
    p.nombre AS pais,
    p.nacionalidad
   FROM (provincias pr
     LEFT JOIN paises p ON ((p.id = pr.id_pais)));
    DROP VIEW public.v_provincias;
       public       postgres    false    237    232    232    232    237    237    7                       1259    968433    v_tipo_persona_perfiles    VIEW     �   CREATE VIEW v_tipo_persona_perfiles AS
 SELECT tpp.id,
    tpp.id_tipo_persona,
    tp.descripcion AS tipo_persona,
    tpp.perfil
   FROM (tipo_persona_perfiles tpp
     JOIN tipo_persona tp ON ((tp.id = tpp.id_tipo_persona)));
 *   DROP VIEW public.v_tipo_persona_perfiles;
       public       postgres    false    251    249    249    251    251    7            �           2604    968437    alquiler_sede id    DEFAULT     f   ALTER TABLE ONLY alquiler_sede ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_id_seq'::regclass);
 ?   ALTER TABLE public.alquiler_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    178    173            �           2604    968438    alquiler_sede_cabecera id    DEFAULT     x   ALTER TABLE ONLY alquiler_sede_cabecera ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_cabecera_id_seq'::regclass);
 H   ALTER TABLE public.alquiler_sede_cabecera ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    175    174            �           2604    968439    alquiler_sede_detalle id    DEFAULT     v   ALTER TABLE ONLY alquiler_sede_detalle ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_detalle_id_seq'::regclass);
 G   ALTER TABLE public.alquiler_sede_detalle ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    177    176            �           2604    968440    aulas id    DEFAULT     V   ALTER TABLE ONLY aulas ALTER COLUMN id SET DEFAULT nextval('aulas_id_seq'::regclass);
 7   ALTER TABLE public.aulas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    183    182            �           2604    968441    ciudades id    DEFAULT     \   ALTER TABLE ONLY ciudades ALTER COLUMN id SET DEFAULT nextval('ciudades_id_seq'::regclass);
 :   ALTER TABLE public.ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    185    184            �           2604    968442 	   clases id    DEFAULT     X   ALTER TABLE ONLY clases ALTER COLUMN id SET DEFAULT nextval('clases_id_seq'::regclass);
 8   ALTER TABLE public.clases ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    188    186            �           2604    968443    clases_profesores id    DEFAULT     n   ALTER TABLE ONLY clases_profesores ALTER COLUMN id SET DEFAULT nextval('clases_profesores_id_seq'::regclass);
 C   ALTER TABLE public.clases_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    190    189            �           2604    968444    condiciones_alumno id    DEFAULT     p   ALTER TABLE ONLY condiciones_alumno ALTER COLUMN id SET DEFAULT nextval('condiciones_alumno_id_seq'::regclass);
 D   ALTER TABLE public.condiciones_alumno ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    192    191            �           2604    968445    cursadas id    DEFAULT     \   ALTER TABLE ONLY cursadas ALTER COLUMN id SET DEFAULT nextval('cursadas_id_seq'::regclass);
 :   ALTER TABLE public.cursadas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    193            �           2604    968446    cursadas_alumnos id    DEFAULT     l   ALTER TABLE ONLY cursadas_alumnos ALTER COLUMN id SET DEFAULT nextval('cursadas_alumnos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    195    194            �           2604    968447    cursadas_cuotas id    DEFAULT     j   ALTER TABLE ONLY cursadas_cuotas ALTER COLUMN id SET DEFAULT nextval('cursadas_cuotas_id_seq'::regclass);
 A   ALTER TABLE public.cursadas_cuotas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    196            �           2604    968448    cursadas_modulos id    DEFAULT     l   ALTER TABLE ONLY cursadas_modulos ALTER COLUMN id SET DEFAULT nextval('cursadas_modulos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    199            �           2604    968449    cursadas_modulos_alumnos id    DEFAULT     |   ALTER TABLE ONLY cursadas_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('cursadas_modulos_alumnos_id_seq'::regclass);
 J   ALTER TABLE public.cursadas_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    200            �           2604    968450    cursadas_profesores id    DEFAULT     r   ALTER TABLE ONLY cursadas_profesores ALTER COLUMN id SET DEFAULT nextval('cursadas_profesores_id_seq'::regclass);
 E   ALTER TABLE public.cursadas_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203            �           2604    968451 	   cursos id    DEFAULT     X   ALTER TABLE ONLY cursos ALTER COLUMN id SET DEFAULT nextval('cursos_id_seq'::regclass);
 8   ALTER TABLE public.cursos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    208    205            �           2604    968452    cursos_correlatividad id    DEFAULT     v   ALTER TABLE ONLY cursos_correlatividad ALTER COLUMN id SET DEFAULT nextval('cursos_correlatividad_id_seq'::regclass);
 G   ALTER TABLE public.cursos_correlatividad ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    206            �           2604    968453    cursos_modulos id    DEFAULT     h   ALTER TABLE ONLY cursos_modulos ALTER COLUMN id SET DEFAULT nextval('cursos_modulos_id_seq'::regclass);
 @   ALTER TABLE public.cursos_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    209            �           2604    968454    cursos_modulos_alumnos id    DEFAULT     x   ALTER TABLE ONLY cursos_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('cursos_modulos_alumnos_id_seq'::regclass);
 H   ALTER TABLE public.cursos_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    210            �           2604    968455    datos_academicos id    DEFAULT     l   ALTER TABLE ONLY datos_academicos ALTER COLUMN id SET DEFAULT nextval('datos_academicos_id_seq'::regclass);
 B   ALTER TABLE public.datos_academicos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    215    214            �           2604    968456    datos_actuales id    DEFAULT     h   ALTER TABLE ONLY datos_actuales ALTER COLUMN id SET DEFAULT nextval('datos_actuales_id_seq'::regclass);
 @   ALTER TABLE public.datos_actuales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    217    216            �           2604    968457    datos_laborales id    DEFAULT     j   ALTER TABLE ONLY datos_laborales ALTER COLUMN id SET DEFAULT nextval('datos_laborales_id_seq'::regclass);
 A   ALTER TABLE public.datos_laborales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    219    218            �           2604    968458    datos_salud id    DEFAULT     b   ALTER TABLE ONLY datos_salud ALTER COLUMN id SET DEFAULT nextval('datos_salud_id_seq'::regclass);
 =   ALTER TABLE public.datos_salud ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    220            �           2604    968459    estados_pago id    DEFAULT     d   ALTER TABLE ONLY estados_pago ALTER COLUMN id SET DEFAULT nextval('estados_pago_id_seq'::regclass);
 >   ALTER TABLE public.estados_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    223    222            �           2604    968460    grupos_sanguineos id    DEFAULT     n   ALTER TABLE ONLY grupos_sanguineos ALTER COLUMN id SET DEFAULT nextval('grupos_sanguineos_id_seq'::regclass);
 C   ALTER TABLE public.grupos_sanguineos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    225    224            �           2604    968461    inscripciones_modulos id    DEFAULT     v   ALTER TABLE ONLY inscripciones_modulos ALTER COLUMN id SET DEFAULT nextval('inscripciones_modulos_id_seq'::regclass);
 G   ALTER TABLE public.inscripciones_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    227    226            �           2604    968462 
   modulos id    DEFAULT     Z   ALTER TABLE ONLY modulos ALTER COLUMN id SET DEFAULT nextval('modulos_id_seq'::regclass);
 9   ALTER TABLE public.modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    229    228            �           2604    968463    niveles_estudios id    DEFAULT     l   ALTER TABLE ONLY niveles_estudios ALTER COLUMN id SET DEFAULT nextval('niveles_estudios_id_seq'::regclass);
 B   ALTER TABLE public.niveles_estudios ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    231    230            �           2604    968464 	   paises id    DEFAULT     X   ALTER TABLE ONLY paises ALTER COLUMN id SET DEFAULT nextval('paises_id_seq'::regclass);
 8   ALTER TABLE public.paises ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    233    232            �           2604    968465    personas id    DEFAULT     [   ALTER TABLE ONLY personas ALTER COLUMN id SET DEFAULT nextval('alumnos_id_seq'::regclass);
 :   ALTER TABLE public.personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    180    179            �           2604    968466    personas legajo    DEFAULT     c   ALTER TABLE ONLY personas ALTER COLUMN legajo SET DEFAULT nextval('alumnos_legajo_seq'::regclass);
 >   ALTER TABLE public.personas ALTER COLUMN legajo DROP DEFAULT;
       public       postgres    false    181    179            �           2604    968467    profesiones id    DEFAULT     b   ALTER TABLE ONLY profesiones ALTER COLUMN id SET DEFAULT nextval('profesiones_id_seq'::regclass);
 =   ALTER TABLE public.profesiones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    236    235            �           2604    968468    provincias id    DEFAULT     `   ALTER TABLE ONLY provincias ALTER COLUMN id SET DEFAULT nextval('provincias_id_seq'::regclass);
 <   ALTER TABLE public.provincias ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    238    237            �           2604    968469    sedes id    DEFAULT     V   ALTER TABLE ONLY sedes ALTER COLUMN id SET DEFAULT nextval('sedes_id_seq'::regclass);
 7   ALTER TABLE public.sedes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    242    239            �           2604    968470    sedes_formadores id    DEFAULT     l   ALTER TABLE ONLY sedes_formadores ALTER COLUMN id SET DEFAULT nextval('sedes_formadores_id_seq'::regclass);
 B   ALTER TABLE public.sedes_formadores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    240            	           2604    976411    temp_ciudades id    DEFAULT     f   ALTER TABLE ONLY temp_ciudades ALTER COLUMN id SET DEFAULT nextval('temp_ciudades_id_seq'::regclass);
 ?   ALTER TABLE public.temp_ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    273    272    273            	           2604    976390    temp_personas id    DEFAULT     f   ALTER TABLE ONLY temp_personas ALTER COLUMN id SET DEFAULT nextval('temp_personas_id_seq'::regclass);
 ?   ALTER TABLE public.temp_personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    271    270    271            �           2604    968471    tipo_clase id    DEFAULT     `   ALTER TABLE ONLY tipo_clase ALTER COLUMN id SET DEFAULT nextval('tipo_clase_id_seq'::regclass);
 <   ALTER TABLE public.tipo_clase ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    244    243            �           2604    968472    tipo_pago id    DEFAULT     ^   ALTER TABLE ONLY tipo_pago ALTER COLUMN id SET DEFAULT nextval('tipo_pago_id_seq'::regclass);
 ;   ALTER TABLE public.tipo_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    246    245            �           2604    968473    tipo_pago_sede id    DEFAULT     h   ALTER TABLE ONLY tipo_pago_sede ALTER COLUMN id SET DEFAULT nextval('tipo_pago_sede_id_seq'::regclass);
 @   ALTER TABLE public.tipo_pago_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    248    247            �           2604    968474    tipo_persona id    DEFAULT     d   ALTER TABLE ONLY tipo_persona ALTER COLUMN id SET DEFAULT nextval('tipo_persona_id_seq'::regclass);
 >   ALTER TABLE public.tipo_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    250    249            �           2604    968475    tipo_persona_perfiles id    DEFAULT     v   ALTER TABLE ONLY tipo_persona_perfiles ALTER COLUMN id SET DEFAULT nextval('tipo_persona_perfiles_id_seq'::regclass);
 G   ALTER TABLE public.tipo_persona_perfiles ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    252    251            �           2604    968476    tipo_profesor id    DEFAULT     f   ALTER TABLE ONLY tipo_profesor ALTER COLUMN id SET DEFAULT nextval('tipo_profesor_id_seq'::regclass);
 ?   ALTER TABLE public.tipo_profesor ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    254    253             	           2604    968477    usuario_persona id    DEFAULT     j   ALTER TABLE ONLY usuario_persona ALTER COLUMN id SET DEFAULT nextval('usuario_persona_id_seq'::regclass);
 A   ALTER TABLE public.usuario_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    256    255            
          0    968143    alquiler_sede 
   TABLE DATA                     public       postgres    false    173   ��      
          0    968147    alquiler_sede_cabecera 
   TABLE DATA                     public       postgres    false    174   ,�      
          0    968154    alquiler_sede_detalle 
   TABLE DATA                     public       postgres    false    176   F�      
          0    968170    aulas 
   TABLE DATA                     public       postgres    false    182   `�      
          0    968175    ciudades 
   TABLE DATA                     public       postgres    false    184   z�      
          0    968180    clases 
   TABLE DATA                     public       postgres    false    186   �Y       
          0    968186    clases_asistencia 
   TABLE DATA                     public       postgres    false    187   Z      "
          0    968191    clases_profesores 
   TABLE DATA                     public       postgres    false    189   'Z      $
          0    968196    condiciones_alumno 
   TABLE DATA                     public       postgres    false    191   AZ      &
          0    968201    cursadas 
   TABLE DATA                     public       postgres    false    193   �Z      '
          0    968204    cursadas_alumnos 
   TABLE DATA                     public       postgres    false    194   Q[      )
          0    968212    cursadas_cuotas 
   TABLE DATA                     public       postgres    false    196   �[      ,
          0    968220    cursadas_modulos 
   TABLE DATA                     public       postgres    false    199   �[      -
          0    968226    cursadas_modulos_alumnos 
   TABLE DATA                     public       postgres    false    200   �]      0
          0    968233    cursadas_profesores 
   TABLE DATA                     public       postgres    false    203   p^      2
          0    968238    cursos 
   TABLE DATA                     public       postgres    false    205   �^      3
          0    968243    cursos_correlatividad 
   TABLE DATA                     public       postgres    false    206   �^      6
          0    968250    cursos_modulos 
   TABLE DATA                     public       postgres    false    209   >_      7
          0    968256    cursos_modulos_alumnos 
   TABLE DATA                     public       postgres    false    210   `      :
          0    968263    databasechangeloglock 
   TABLE DATA                     public       postgres    false    213   �`      ;
          0    968266    datos_academicos 
   TABLE DATA                     public       postgres    false    214   /a      =
          0    968271    datos_actuales 
   TABLE DATA                     public       postgres    false    216   Ia      ?
          0    968276    datos_laborales 
   TABLE DATA                     public       postgres    false    218   �a      A
          0    968284    datos_salud 
   TABLE DATA                     public       postgres    false    220   �a      C
          0    968289    estados_pago 
   TABLE DATA                     public       postgres    false    222   ?b      E
          0    968294    grupos_sanguineos 
   TABLE DATA                     public       postgres    false    224   �b      G
          0    968299    inscripciones_modulos 
   TABLE DATA                     public       postgres    false    226   �b      I
          0    968304    modulos 
   TABLE DATA                     public       postgres    false    228   �b      K
          0    968310    niveles_estudios 
   TABLE DATA                     public       postgres    false    230   �b      M
          0    968315    paises 
   TABLE DATA                     public       postgres    false    232   Zc      O
          0    968320    perfiles 
   TABLE DATA                     public       postgres    false    234   �c      
          0    968162    personas 
   TABLE DATA                     public       postgres    false    179   �c      P
          0    968323    profesiones 
   TABLE DATA                     public       postgres    false    235   Zd      R
          0    968328 
   provincias 
   TABLE DATA                     public       postgres    false    237   td      T
          0    968336    sedes 
   TABLE DATA                     public       postgres    false    239   �e      U
          0    968343    sedes_formadores 
   TABLE DATA                     public       postgres    false    240   �f      j
          0    976408    temp_ciudades 
   TABLE DATA                     public       postgres    false    273   g      h
          0    976387    temp_personas 
   TABLE DATA                     public       postgres    false    271   i      f
          0    976379    temp_personas2 
   TABLE DATA                     public       postgres    false    269   PH      X
          0    968350 
   tipo_clase 
   TABLE DATA                     public       postgres    false    243   �      Z
          0    968355 	   tipo_pago 
   TABLE DATA                     public       postgres    false    245   4      \
          0    968360    tipo_pago_sede 
   TABLE DATA                     public       postgres    false    247   �      ^
          0    968365    tipo_persona 
   TABLE DATA                     public       postgres    false    249          `
          0    968370    tipo_persona_perfiles 
   TABLE DATA                     public       postgres    false    251   i       b
          0    968375    tipo_profesor 
   TABLE DATA                     public       postgres    false    253   �       d
          0    968380    usuario_persona 
   TABLE DATA                     public       postgres    false    255   !      �
           0    0    alquiler_sede_cabecera_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('alquiler_sede_cabecera_id_seq', 2, true);
            public       postgres    false    175            �
           0    0    alquiler_sede_detalle_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('alquiler_sede_detalle_id_seq', 3, true);
            public       postgres    false    177            �
           0    0    alquiler_sede_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('alquiler_sede_id_seq', 8, true);
            public       postgres    false    178            �
           0    0    alumnos_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('alumnos_id_seq', 9, true);
            public       postgres    false    180            �
           0    0    alumnos_legajo_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('alumnos_legajo_seq', 6, true);
            public       postgres    false    181            �
           0    0    aulas_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('aulas_id_seq', 4, true);
            public       postgres    false    183            �
           0    0    ciudades_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('ciudades_id_seq', 1, false);
            public       postgres    false    185            �
           0    0    clases_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('clases_id_seq', 3, true);
            public       postgres    false    188            �
           0    0    clases_profesores_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('clases_profesores_id_seq', 1, false);
            public       postgres    false    190            �
           0    0    condiciones_alumno_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('condiciones_alumno_id_seq', 3, true);
            public       postgres    false    192            �
           0    0    cursadas_alumnos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('cursadas_alumnos_id_seq', 14, true);
            public       postgres    false    195            �
           0    0    cursadas_cuotas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('cursadas_cuotas_id_seq', 1, false);
            public       postgres    false    197            �
           0    0    cursadas_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('cursadas_id_seq', 12, true);
            public       postgres    false    198            �
           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('cursadas_modulos_alumnos_id_seq', 40, true);
            public       postgres    false    201            �
           0    0    cursadas_modulos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('cursadas_modulos_id_seq', 72, true);
            public       postgres    false    202            �
           0    0    cursadas_profesores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('cursadas_profesores_id_seq', 3, true);
            public       postgres    false    204            �
           0    0    cursos_correlatividad_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('cursos_correlatividad_id_seq', 3, true);
            public       postgres    false    207            �
           0    0    cursos_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('cursos_id_seq', 2, true);
            public       postgres    false    208            �
           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('cursos_modulos_alumnos_id_seq', 13, true);
            public       postgres    false    211            �
           0    0    cursos_modulos_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('cursos_modulos_id_seq', 10, true);
            public       postgres    false    212            �
           0    0    datos_academicos_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('datos_academicos_id_seq', 3, true);
            public       postgres    false    215            �
           0    0    datos_actuales_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('datos_actuales_id_seq', 5, true);
            public       postgres    false    217            �
           0    0    datos_laborales_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('datos_laborales_id_seq', 3, true);
            public       postgres    false    219            �
           0    0    datos_salud_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('datos_salud_id_seq', 4, true);
            public       postgres    false    221            �
           0    0    estados_pago_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('estados_pago_id_seq', 1, false);
            public       postgres    false    223            �
           0    0    grupos_sanguineos_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('grupos_sanguineos_id_seq', 1, false);
            public       postgres    false    225            �
           0    0    inscripciones_modulos_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('inscripciones_modulos_id_seq', 1, false);
            public       postgres    false    227            �
           0    0    modulos_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('modulos_id_seq', 1, false);
            public       postgres    false    229            �
           0    0    niveles_estudios_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('niveles_estudios_id_seq', 1, false);
            public       postgres    false    231            �
           0    0    paises_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('paises_id_seq', 1, false);
            public       postgres    false    233            �
           0    0    profesiones_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('profesiones_id_seq', 1, false);
            public       postgres    false    236            �
           0    0    provincias_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('provincias_id_seq', 1, false);
            public       postgres    false    238            �
           0    0    sedes_formadores_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('sedes_formadores_id_seq', 5, true);
            public       postgres    false    241            �
           0    0    sedes_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('sedes_id_seq', 8, true);
            public       postgres    false    242            �
           0    0    temp_ciudades_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('temp_ciudades_id_seq', 43, true);
            public       postgres    false    272            �
           0    0    temp_personas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('temp_personas_id_seq', 654, true);
            public       postgres    false    270            �
           0    0    tipo_clase_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('tipo_clase_id_seq', 3, true);
            public       postgres    false    244            �
           0    0    tipo_pago_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('tipo_pago_id_seq', 4, true);
            public       postgres    false    246            �
           0    0    tipo_pago_sede_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('tipo_pago_sede_id_seq', 2, true);
            public       postgres    false    248            �
           0    0    tipo_persona_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_persona_id_seq', 1, false);
            public       postgres    false    250            �
           0    0    tipo_persona_perfiles_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('tipo_persona_perfiles_id_seq', 1, true);
            public       postgres    false    252            �
           0    0    tipo_profesor_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_profesor_id_seq', 3, true);
            public       postgres    false    254            �
           0    0    usuario_persona_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('usuario_persona_id_seq', 1, false);
            public       postgres    false    256            J	           2606    968479 &   niveles_estudios niveles_estudios_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY niveles_estudios
    ADD CONSTRAINT niveles_estudios_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.niveles_estudios DROP CONSTRAINT niveles_estudios_pkey;
       public         postgres    false    230            	           2606    968481    alquiler_sede pk_alquiler_sede 
   CONSTRAINT     U   ALTER TABLE ONLY alquiler_sede
    ADD CONSTRAINT pk_alquiler_sede PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.alquiler_sede DROP CONSTRAINT pk_alquiler_sede;
       public         postgres    false    173            	           2606    968483 0   alquiler_sede_cabecera pk_alquiler_sede_cabecera 
   CONSTRAINT     g   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT pk_alquiler_sede_cabecera PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT pk_alquiler_sede_cabecera;
       public         postgres    false    174            	           2606    968485 .   alquiler_sede_detalle pk_alquiler_sede_detalle 
   CONSTRAINT     e   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT pk_alquiler_sede_detalle PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT pk_alquiler_sede_detalle;
       public         postgres    false    176            
	           2606    968487    personas pk_alumnos 
   CONSTRAINT     J   ALTER TABLE ONLY personas
    ADD CONSTRAINT pk_alumnos PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.personas DROP CONSTRAINT pk_alumnos;
       public         postgres    false    179            	           2606    968489    aulas pk_aulas 
   CONSTRAINT     E   ALTER TABLE ONLY aulas
    ADD CONSTRAINT pk_aulas PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT pk_aulas;
       public         postgres    false    182            	           2606    968491    ciudades pk_ciudad 
   CONSTRAINT     I   ALTER TABLE ONLY ciudades
    ADD CONSTRAINT pk_ciudad PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT pk_ciudad;
       public         postgres    false    184            	           2606    968493    clases pk_clases 
   CONSTRAINT     G   ALTER TABLE ONLY clases
    ADD CONSTRAINT pk_clases PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.clases DROP CONSTRAINT pk_clases;
       public         postgres    false    186            	           2606    968495 &   clases_asistencia pk_clases_asistencia 
   CONSTRAINT     ]   ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT pk_clases_asistencia PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT pk_clases_asistencia;
       public         postgres    false    187            	           2606    968497 &   clases_profesores pk_clases_profesores 
   CONSTRAINT     ]   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT pk_clases_profesores PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT pk_clases_profesores;
       public         postgres    false    189            	           2606    968499 (   condiciones_alumno pk_condiciones_alumno 
   CONSTRAINT     _   ALTER TABLE ONLY condiciones_alumno
    ADD CONSTRAINT pk_condiciones_alumno PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.condiciones_alumno DROP CONSTRAINT pk_condiciones_alumno;
       public         postgres    false    191            	           2606    968501    cursadas pk_cursadas 
   CONSTRAINT     K   ALTER TABLE ONLY cursadas
    ADD CONSTRAINT pk_cursadas PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT pk_cursadas;
       public         postgres    false    193            	           2606    968503 $   cursadas_alumnos pk_cursadas_alumnos 
   CONSTRAINT     [   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT pk_cursadas_alumnos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT pk_cursadas_alumnos;
       public         postgres    false    194            "	           2606    968505 "   cursadas_cuotas pk_cursadas_cuotas 
   CONSTRAINT     Y   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT pk_cursadas_cuotas PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT pk_cursadas_cuotas;
       public         postgres    false    196            $	           2606    968507 $   cursadas_modulos pk_cursadas_modulos 
   CONSTRAINT     [   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT pk_cursadas_modulos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT pk_cursadas_modulos;
       public         postgres    false    199            (	           2606    968509 4   cursadas_modulos_alumnos pk_cursadas_modulos_alumnos 
   CONSTRAINT     k   ALTER TABLE ONLY cursadas_modulos_alumnos
    ADD CONSTRAINT pk_cursadas_modulos_alumnos PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.cursadas_modulos_alumnos DROP CONSTRAINT pk_cursadas_modulos_alumnos;
       public         postgres    false    200            *	           2606    968511 *   cursadas_profesores pk_cursadas_profesores 
   CONSTRAINT     a   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT pk_cursadas_profesores PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT pk_cursadas_profesores;
       public         postgres    false    203            ,	           2606    968513    cursos pk_cursos 
   CONSTRAINT     G   ALTER TABLE ONLY cursos
    ADD CONSTRAINT pk_cursos PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.cursos DROP CONSTRAINT pk_cursos;
       public         postgres    false    205            .	           2606    968515 .   cursos_correlatividad pk_cursos_correlatividad 
   CONSTRAINT     e   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT pk_cursos_correlatividad PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT pk_cursos_correlatividad;
       public         postgres    false    206            2	           2606    968517     cursos_modulos pk_cursos_modulos 
   CONSTRAINT     W   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT pk_cursos_modulos PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT pk_cursos_modulos;
       public         postgres    false    209            6	           2606    968519 0   cursos_modulos_alumnos pk_cursos_modulos_alumnos 
   CONSTRAINT     g   ALTER TABLE ONLY cursos_modulos_alumnos
    ADD CONSTRAINT pk_cursos_modulos_alumnos PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.cursos_modulos_alumnos DROP CONSTRAINT pk_cursos_modulos_alumnos;
       public         postgres    false    210            8	           2606    968521 .   databasechangeloglock pk_databasechangeloglock 
   CONSTRAINT     e   ALTER TABLE ONLY databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.databasechangeloglock DROP CONSTRAINT pk_databasechangeloglock;
       public         postgres    false    213            :	           2606    968523 $   datos_academicos pk_datos_academicos 
   CONSTRAINT     [   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT pk_datos_academicos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT pk_datos_academicos;
       public         postgres    false    214            <	           2606    968525     datos_actuales pk_datos_actuales 
   CONSTRAINT     W   ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT pk_datos_actuales PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT pk_datos_actuales;
       public         postgres    false    216            >	           2606    968527 "   datos_laborales pk_datos_laborales 
   CONSTRAINT     Y   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT pk_datos_laborales PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT pk_datos_laborales;
       public         postgres    false    218            @	           2606    968529    datos_salud pk_datos_salud 
   CONSTRAINT     Q   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT pk_datos_salud PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT pk_datos_salud;
       public         postgres    false    220            B	           2606    968531    estados_pago pk_estados_pago 
   CONSTRAINT     S   ALTER TABLE ONLY estados_pago
    ADD CONSTRAINT pk_estados_pago PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.estados_pago DROP CONSTRAINT pk_estados_pago;
       public         postgres    false    222            D	           2606    968533 &   grupos_sanguineos pk_grupos_sanguineos 
   CONSTRAINT     ]   ALTER TABLE ONLY grupos_sanguineos
    ADD CONSTRAINT pk_grupos_sanguineos PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.grupos_sanguineos DROP CONSTRAINT pk_grupos_sanguineos;
       public         postgres    false    224            F	           2606    968535 .   inscripciones_modulos pk_inscripciones_modulos 
   CONSTRAINT     e   ALTER TABLE ONLY inscripciones_modulos
    ADD CONSTRAINT pk_inscripciones_modulos PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.inscripciones_modulos DROP CONSTRAINT pk_inscripciones_modulos;
       public         postgres    false    226            H	           2606    968537    modulos pk_modulos 
   CONSTRAINT     I   ALTER TABLE ONLY modulos
    ADD CONSTRAINT pk_modulos PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.modulos DROP CONSTRAINT pk_modulos;
       public         postgres    false    228            L	           2606    968539    paises pk_paises 
   CONSTRAINT     G   ALTER TABLE ONLY paises
    ADD CONSTRAINT pk_paises PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.paises DROP CONSTRAINT pk_paises;
       public         postgres    false    232            N	           2606    968541    perfiles pk_perfil 
   CONSTRAINT     M   ALTER TABLE ONLY perfiles
    ADD CONSTRAINT pk_perfil PRIMARY KEY (perfil);
 <   ALTER TABLE ONLY public.perfiles DROP CONSTRAINT pk_perfil;
       public         postgres    false    234            P	           2606    968543    profesiones pk_profesiones 
   CONSTRAINT     Q   ALTER TABLE ONLY profesiones
    ADD CONSTRAINT pk_profesiones PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.profesiones DROP CONSTRAINT pk_profesiones;
       public         postgres    false    235            R	           2606    968545    provincias pk_provincias 
   CONSTRAINT     O   ALTER TABLE ONLY provincias
    ADD CONSTRAINT pk_provincias PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.provincias DROP CONSTRAINT pk_provincias;
       public         postgres    false    237            T	           2606    968547    sedes pk_sedes 
   CONSTRAINT     E   ALTER TABLE ONLY sedes
    ADD CONSTRAINT pk_sedes PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sedes DROP CONSTRAINT pk_sedes;
       public         postgres    false    239            V	           2606    968549 $   sedes_formadores pk_sedes_formadores 
   CONSTRAINT     [   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT pk_sedes_formadores PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT pk_sedes_formadores;
       public         postgres    false    240            l	           2606    976413    temp_ciudades pk_temp_ciudades 
   CONSTRAINT     U   ALTER TABLE ONLY temp_ciudades
    ADD CONSTRAINT pk_temp_ciudades PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_ciudades DROP CONSTRAINT pk_temp_ciudades;
       public         postgres    false    273            j	           2606    976395    temp_personas pk_temp_personas 
   CONSTRAINT     U   ALTER TABLE ONLY temp_personas
    ADD CONSTRAINT pk_temp_personas PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_personas DROP CONSTRAINT pk_temp_personas;
       public         postgres    false    271            Z	           2606    968551    tipo_clase pk_tipo_clase 
   CONSTRAINT     O   ALTER TABLE ONLY tipo_clase
    ADD CONSTRAINT pk_tipo_clase PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.tipo_clase DROP CONSTRAINT pk_tipo_clase;
       public         postgres    false    243            \	           2606    968553    tipo_pago pk_tipo_pago 
   CONSTRAINT     M   ALTER TABLE ONLY tipo_pago
    ADD CONSTRAINT pk_tipo_pago PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT pk_tipo_pago;
       public         postgres    false    245            `	           2606    968555     tipo_pago_sede pk_tipo_pago_sede 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_pago_sede
    ADD CONSTRAINT pk_tipo_pago_sede PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_pago_sede DROP CONSTRAINT pk_tipo_pago_sede;
       public         postgres    false    247            b	           2606    968557    tipo_persona pk_tipo_persona 
   CONSTRAINT     S   ALTER TABLE ONLY tipo_persona
    ADD CONSTRAINT pk_tipo_persona PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.tipo_persona DROP CONSTRAINT pk_tipo_persona;
       public         postgres    false    249            d	           2606    968559 .   tipo_persona_perfiles pk_tipo_persona_perfiles 
   CONSTRAINT     e   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT pk_tipo_persona_perfiles PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT pk_tipo_persona_perfiles;
       public         postgres    false    251            f	           2606    968561     tipo_profesor pk_tipo_profesores 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_profesor
    ADD CONSTRAINT pk_tipo_profesores PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_profesor DROP CONSTRAINT pk_tipo_profesores;
       public         postgres    false    253            h	           2606    968563 "   usuario_persona pk_usuario_persona 
   CONSTRAINT     Y   ALTER TABLE ONLY usuario_persona
    ADD CONSTRAINT pk_usuario_persona PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT pk_usuario_persona;
       public         postgres    false    255            	           2606    968565    personas uk_alumnos_dni 
   CONSTRAINT     J   ALTER TABLE ONLY personas
    ADD CONSTRAINT uk_alumnos_dni UNIQUE (dni);
 A   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_dni;
       public         postgres    false    179            	           2606    968567    personas uk_alumnos_legajo 
   CONSTRAINT     P   ALTER TABLE ONLY personas
    ADD CONSTRAINT uk_alumnos_legajo UNIQUE (legajo);
 D   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_legajo;
       public         postgres    false    179             	           2606    968569 $   cursadas_alumnos uk_cursadas_alumnos 
   CONSTRAINT     i   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT uk_cursadas_alumnos UNIQUE (id_cursada, id_alumno);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT uk_cursadas_alumnos;
       public         postgres    false    194    194            &	           2606    968571 $   cursadas_modulos uk_cursadas_modulos 
   CONSTRAINT     c   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT uk_cursadas_modulos UNIQUE (mes, id_cursada);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT uk_cursadas_modulos;
       public         postgres    false    199    199            0	           2606    968573 .   cursos_correlatividad uk_cursos_correlatividad 
   CONSTRAINT     w   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT uk_cursos_correlatividad UNIQUE (id_curso, id_curso_previo);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT uk_cursos_correlatividad;
       public         postgres    false    206    206            4	           2606    968575     cursos_modulos uk_cursos_modulos 
   CONSTRAINT     ]   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT uk_cursos_modulos UNIQUE (mes, id_curso);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT uk_cursos_modulos;
       public         postgres    false    209    209            X	           2606    968577 $   sedes_formadores uk_sedes_formadores 
   CONSTRAINT     h   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT uk_sedes_formadores UNIQUE (id_formador, id_sede);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT uk_sedes_formadores;
       public         postgres    false    240    240            ^	           2606    968579    tipo_pago uk_tipo_pago 
   CONSTRAINT     Q   ALTER TABLE ONLY tipo_pago
    ADD CONSTRAINT uk_tipo_pago UNIQUE (descripcion);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT uk_tipo_pago;
       public         postgres    false    245            �	           2620    968580    cursadas trg_ai_cursadas    TRIGGER     m   CREATE TRIGGER trg_ai_cursadas AFTER INSERT ON cursadas FOR EACH ROW EXECUTE PROCEDURE sp_trg_ai_cursadas();
 1   DROP TRIGGER trg_ai_cursadas ON public.cursadas;
       public       postgres    false    193    286            �	           2620    968581 (   cursadas_alumnos trg_ai_cursadas_alumnos    TRIGGER     �   CREATE TRIGGER trg_ai_cursadas_alumnos AFTER INSERT ON cursadas_alumnos FOR EACH ROW EXECUTE PROCEDURE sp_trg_ai_cursadas_alumnos();

ALTER TABLE cursadas_alumnos DISABLE TRIGGER trg_ai_cursadas_alumnos;
 A   DROP TRIGGER trg_ai_cursadas_alumnos ON public.cursadas_alumnos;
       public       postgres    false    194    287            m	           2606    968582 0   alquiler_sede_cabecera fk_alquiler_sede_cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera FOREIGN KEY (id_estado_pago) REFERENCES estados_pago(id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera;
       public       postgres    false    222    174    2370            n	           2606    968587 6   alquiler_sede_cabecera fk_alquiler_sede_cabecera__sede    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera__sede FOREIGN KEY (id_sede) REFERENCES alquiler_sede(id);
 `   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera__sede;
       public       postgres    false    174    2308    173            o	           2606    968592 4   alquiler_sede_detalle fk_alquiler_sede_detalle__aula    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__aula FOREIGN KEY (id_aula) REFERENCES aulas(id);
 ^   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__aula;
       public       postgres    false    176    182    2320            p	           2606    968597 8   alquiler_sede_detalle fk_alquiler_sede_detalle__cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__cabecera FOREIGN KEY (id_cabecera) REFERENCES alquiler_sede_cabecera(id);
 b   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__cabecera;
       public       postgres    false    174    176    2310            r	           2606    968602    aulas fk_aulas_sede    FK CONSTRAINT     d   ALTER TABLE ONLY aulas
    ADD CONSTRAINT fk_aulas_sede FOREIGN KEY (id_sede) REFERENCES sedes(id);
 =   ALTER TABLE ONLY public.aulas DROP CONSTRAINT fk_aulas_sede;
       public       postgres    false    239    182    2388            s	           2606    968607    ciudades fk_ciudad_provincia    FK CONSTRAINT     w   ALTER TABLE ONLY ciudades
    ADD CONSTRAINT fk_ciudad_provincia FOREIGN KEY (id_provincia) REFERENCES provincias(id);
 F   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT fk_ciudad_provincia;
       public       postgres    false    2386    237    184            x	           2606    968612 /   clases_asistencia fk_clases_asistencia__persona    FK CONSTRAINT     �   ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia__persona FOREIGN KEY (id_persona) REFERENCES personas(id);
 Y   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia__persona;
       public       postgres    false    2314    179    187            y	           2606    968617 ,   clases_asistencia fk_clases_asistencia_clase    FK CONSTRAINT        ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia_clase FOREIGN KEY (id_clase) REFERENCES clases(id);
 V   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia_clase;
       public       postgres    false    187    186    2324            t	           2606    968622    clases fk_clases_aula    FK CONSTRAINT     f   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_aula FOREIGN KEY (id_aula) REFERENCES aulas(id);
 ?   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_aula;
       public       postgres    false    182    186    2320            u	           2606    968627    clases fk_clases_cursadas    FK CONSTRAINT     p   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 C   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_cursadas;
       public       postgres    false    193    186    2332            v	           2606    968632    clases fk_clases_modulo    FK CONSTRAINT     u   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_modulo FOREIGN KEY (id_modulo) REFERENCES cursadas_modulos(id);
 A   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_modulo;
       public       postgres    false    186    2340    199            z	           2606    968637 &   clases_profesores fk_clases_profesores    FK CONSTRAINT     ~   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT fk_clases_profesores FOREIGN KEY (id_profesor) REFERENCES personas(id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores;
       public       postgres    false    2314    189    179            {	           2606    968642 .   clases_profesores fk_clases_profesores__clases    FK CONSTRAINT     �   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT fk_clases_profesores__clases FOREIGN KEY (id_clase) REFERENCES clases(id);
 X   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores__clases;
       public       postgres    false    189    186    2324            w	           2606    968647    clases fk_clases_tipo_clase    FK CONSTRAINT     w   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_tipo_clase FOREIGN KEY (id_tipo_clase) REFERENCES tipo_clase(id);
 E   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_tipo_clase;
       public       postgres    false    2394    243    186            |	           2606    968652    cursadas fk_cursadas__cursos    FK CONSTRAINT     o   ALTER TABLE ONLY cursadas
    ADD CONSTRAINT fk_cursadas__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 F   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT fk_cursadas__cursos;
       public       postgres    false    2348    205    193            }	           2606    968657 6   cursadas_alumnos fk_cursadas_alumnos__condicion_alumno    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__condicion_alumno FOREIGN KEY (id_condicion_alumno) REFERENCES condiciones_alumno(id);
 `   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__condicion_alumno;
       public       postgres    false    2330    194    191            ~	           2606    968662 .   cursadas_alumnos fk_cursadas_alumnos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__cursadas;
       public       postgres    false    193    194    2332            	           2606    968667 .   cursadas_alumnos fk_cursadas_alumnos__personas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__personas FOREIGN KEY (id_alumno) REFERENCES personas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__personas;
       public       postgres    false    194    179    2314            �	           2606    968672 +   cursadas_cuotas fk_cursadas_cuotas__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__alumnos FOREIGN KEY (id_cursadas_alumnos) REFERENCES cursadas_alumnos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__alumnos;
       public       postgres    false    196    194    2334            �	           2606    968677 +   cursadas_cuotas fk_cursadas_cuotas__modulos    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__modulos FOREIGN KEY (id_cursadas_modulos) REFERENCES cursadas_modulos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__modulos;
       public       postgres    false    196    199    2340            �	           2606    968682 4   cursadas_profesores fk_cursadas_profesores__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 ^   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__cursadas;
       public       postgres    false    2332    203    193            �	           2606    968687 6   cursadas_profesores fk_cursadas_profesores__profesores    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__profesores FOREIGN KEY (id_profesor) REFERENCES personas(id);
 `   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__profesores;
       public       postgres    false    203    2314    179            �	           2606    968692 9   cursadas_profesores fk_cursadas_profesores__tipo_profesor    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__tipo_profesor FOREIGN KEY (id_tipo_profesor) REFERENCES tipo_profesor(id);
 c   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__tipo_profesor;
       public       postgres    false    203    2406    253            �	           2606    968697 6   cursos_correlatividad fk_cursos_correlatividad__cursos    FK CONSTRAINT     �   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 `   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos;
       public       postgres    false    205    206    2348            �	           2606    968702 >   cursos_correlatividad fk_cursos_correlatividad__cursos_previos    FK CONSTRAINT     �   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos_previos FOREIGN KEY (id_curso_previo) REFERENCES cursos(id);
 h   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos_previos;
       public       postgres    false    2348    206    205            �	           2606    968707 ,   cursadas_modulos fk_cursos_modulos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 V   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT fk_cursos_modulos__cursadas;
       public       postgres    false    2332    193    199            �	           2606    968712 (   cursos_modulos fk_cursos_modulos__cursos    FK CONSTRAINT     {   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 R   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT fk_cursos_modulos__cursos;
       public       postgres    false    209    2348    205            �	           2606    968717 -   datos_academicos fk_datos_academicos__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT fk_datos_academicos__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 W   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__alumnos;
       public       postgres    false    2314    214    179            �	           2606    968722 6   datos_academicos fk_datos_academicos__niveles_estudios    FK CONSTRAINT     �   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT fk_datos_academicos__niveles_estudios FOREIGN KEY (id_nivel_estudio) REFERENCES niveles_estudios(id);
 `   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__niveles_estudios;
       public       postgres    false    2378    214    230            �	           2606    968727 )   datos_actuales fk_datos_actuales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT fk_datos_actuales__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales__alumnos;
       public       postgres    false    179    216    2314            �	           2606    968732 )   datos_actuales fk_datos_actuales_ciudades    FK CONSTRAINT        ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT fk_datos_actuales_ciudades FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales_ciudades;
       public       postgres    false    216    2322    184            �	           2606    968737 +   datos_laborales fk_datos_laborales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT fk_datos_laborales__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 U   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__alumnos;
       public       postgres    false    179    218    2314            �	           2606    968742 /   datos_laborales fk_datos_laborales__profesiones    FK CONSTRAINT     �   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT fk_datos_laborales__profesiones FOREIGN KEY (id_profesion) REFERENCES profesiones(id);
 Y   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__profesiones;
       public       postgres    false    218    2384    235            �	           2606    968747 #   datos_salud fk_datos_salud__alumnos    FK CONSTRAINT     z   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT fk_datos_salud__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 M   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__alumnos;
       public       postgres    false    2314    179    220            �	           2606    968752 -   datos_salud fk_datos_salud__grupos_sanguineos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT fk_datos_salud__grupos_sanguineos FOREIGN KEY (id_grupo_sanguineo) REFERENCES grupos_sanguineos(id);
 W   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__grupos_sanguineos;
       public       postgres    false    220    2372    224            �	           2606    968757    modulos fk_modulos_cursos    FK CONSTRAINT     l   ALTER TABLE ONLY modulos
    ADD CONSTRAINT fk_modulos_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 C   ALTER TABLE ONLY public.modulos DROP CONSTRAINT fk_modulos_cursos;
       public       postgres    false    228    2348    205            q	           2606    968762    personas fk_personas_tipo    FK CONSTRAINT     y   ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_personas_tipo FOREIGN KEY (id_tipo_persona) REFERENCES tipo_persona(id);
 C   ALTER TABLE ONLY public.personas DROP CONSTRAINT fk_personas_tipo;
       public       postgres    false    179    2402    249            �	           2606    968767    provincias fk_provincias_pais    FK CONSTRAINT     o   ALTER TABLE ONLY provincias
    ADD CONSTRAINT fk_provincias_pais FOREIGN KEY (id_pais) REFERENCES paises(id);
 G   ALTER TABLE ONLY public.provincias DROP CONSTRAINT fk_provincias_pais;
       public       postgres    false    237    232    2380            �	           2606    968772 +   sedes_formadores fk_sedes_formadores__sedes    FK CONSTRAINT     |   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT fk_sedes_formadores__sedes FOREIGN KEY (id_sede) REFERENCES sedes(id);
 U   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT fk_sedes_formadores__sedes;
       public       postgres    false    240    239    2388            �	           2606    968777 6   tipo_persona_perfiles fk_tipo_persona_perfiles__perfil    FK CONSTRAINT     �   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__perfil FOREIGN KEY (perfil) REFERENCES perfiles(perfil);
 `   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__perfil;
       public       postgres    false    234    251    2382            �	           2606    968782 <   tipo_persona_perfiles fk_tipo_persona_perfiles__tipo_persona    FK CONSTRAINT     �   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__tipo_persona FOREIGN KEY (id_tipo_persona) REFERENCES tipo_persona(id);
 f   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__tipo_persona;
       public       postgres    false    249    251    2402            �	           2606    968787 +   usuario_persona fk_usuario_persona__persona    FK CONSTRAINT     �   ALTER TABLE ONLY usuario_persona
    ADD CONSTRAINT fk_usuario_persona__persona FOREIGN KEY (id_persona) REFERENCES personas(id);
 U   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT fk_usuario_persona__persona;
       public       postgres    false    2314    255    179            
   h   x���v
Q���WH�),��I-�/NMIUs�	uVа�Q0�QP720��50�54U�Q020�30@U00�25�25�3�44�� �R74�2 !0��ִ��� ��:      
   
   x���          
   
   x���          
   
   x���          
      x���K���%��_�]N��B�[6+�BP��H�ڵu���������$u��x|��VUf� � �Ǐ��������p�o�������������t����z
��}�U������������!=Ꮢ������������?�C�F�%�(������E��g$?tCߺ�CW���}�:�0�]3����G;�4�$��y}���������(E4H��7�V"��͏ƥ;��4;��C�u�,�H�҄����}2�{B��1�s�\~ҶlI�߇�p�᧻fw[\�p�9L������_�	�7�ɷoCwq]���8�bkj²^m���6.�!m�Q�st$����!����Ǆ��N�� ��7����T�O�w?��!9�&�JOo�iu6>M�ĳ�dO�ŋ�&N�6�e�_ڮ3N\.¾����K��7��,:��g�})i[74��CW��b�_��.C�'�e�\��ẙ]��Yf�4���]G��5�o;/�身7}{F:�=�v�f)K���!�h��]��_��@s@�	���4�W��gV�`+���|�H�~r�e�d�~A�n;�2ҳ'��ý��<�6qҷ�������I�mn�O�,����X���j�a	��̂t�A��=G{��8'#�칦�_�L�a��*&��[Zl[����{��_����z1�c�P�-ڠ��������C�OP�9�Q\��!�=PA�)���8~����4l�j�IE�~I���fh��髋T��C��d8�mZ[d|�����aɜ7��]�#>U%(H�v��
�O����n&H���6��q*��m_���u��ڞW��䇇\Wᇟ�ϣR�����yt��nP�J9Ϧ��:� �e�`�O�g"�S��B������6>��S3/�J��&�`�ū��ͅ�E����X��`�8�U������Gx[�3�������f�;��N��NM�i]����f8\�Ќr��S�]%���ik������ֻh��+j0肾�!��=���S�*�MC�o��jlh���������槿���L�Ik�����M�
������_MG�9�g��	C%S}G݇��9!+�>g*�M����s��a�G���6L���\lϘ`�6��6�R��W��B�fYs�֝+i'j�u;�O���x�o���.N��j���}�����?a�~5�k��K�hǤn��O��:9�Z�e�:G�	{G$G6������aj1�3x��w�l\�a��D��u�3F��ff��RS��,�PW7��<׻H�Ly:�oO�`��f�«�4����Z���6��m���������t'yA�G_�[T�Oh�s�ν�Op��`������?�3W�do~]Z���A$�7�����v|L�(o�yƒdod������b�?��X�~��� �X@K���۽=E��'3�s��!���%��I�ꭉ�v5${�}��0�#x��{����7ӄ�{�]���LIAog����St�e��TTqz�>Fu-��g%�p|���2P9p�ӳ%q<�O�4G@��,��q������,7.(�Y�C��s3=����ʎ�&&�,�e�����@haT�,CU��b�e��v�rL n�N�>FzH��-KA�c�/f?��йp	�ҚN(ܖ�%�Р���t�p0����뗰;ߖ��-�w:��I��ÛY���K��̏'������*7����-�^/�����q��ŭdg蜑��Nu�"��q�\�����n�a��#My� <\G��d�c8 ��̈�/�%^ێb����_Α ����I�FrMǜnc���A��}����]���E���s�C �S�#a���AN�w;=��Al�<_�8�	4ԙF��}�5i�i3s@@����T�����6���ո��C�29��rh@��dMrx���x��-�� ��}��[����ش}k�}9�r1Ў����/߇�@У��fCU�����)�v�y>��K�	�nn�q����^� ����w�ay̠6y���������3(ccly{�m�Ü@���y�X>�N��U<���گ>���K���C�H�>�%O��a��L���0�`�=�k�Eu�}�>��gｿ����\���)�5bى藺S�u�/{�ׇ�O����V�BK�_�}��6Ѥa͸̝���8[ *w�q�6iR�[�3�,Z�����ICw�-[���䡾��`�'�j���ھ,�$(�5�+�Ԩ���Ň׀H�L#��D���7o��n:��!�o�h1�Z,?/�����r�@l�nY�?v����R�z���鯣�ܖ)�	EB��V��&L9N��[�q�_F�^��X�/��	�����8$������E)/�I�8nB�r�T��Wt[\!�h�g�P��d����;3W�D]a����hŁ��D�\hz�(�ݔ �5�M>�7����;FP�شM{x	'���q���پ^�*>w�-���^�y����VPjd����ẕ�mi����ft����o�T4s���k�1��y����uOw��vRSn"���"�NZAr�v\��PJ%*2�4�c�?־P�o ��@�{*��p	��Q�έx����6�}�C&*�uQi��q�?k�����N���'T�9.���b2��wl�&%� O98�ׁ�� �7�� y����Q�x_[�T�q���V�L��;}Н���47���{h����IN荕�!�/:�����@�0:2��0�AO�/��i�q�Xx�R�t�p$�A�A/�-�b����aT�%<����d� :�짍�'>��zi����i��r}rV�@��r���� ��7��u��B���7?P�Τ�T�=��3�'��Bs����=�t�k�	}͗t�����/�0����H����8�:�{�;l�e�����t����pu�PW���Gx+�&_q*�~��!�4)�H����?w����k%���B�8�΍�G�ğ���|-�9�i��n���}�Y�I
F`����Q<7�e���?���2M��l�g�=����O9K���_ ߄��l�g%\��������P��t���+����m�����F@ z6U��p�_KxK����&�����.��(3Pիw�E����Q/�xy�,b��;<B�pq���Y0����+q�WSnrz�ko\"�Uȳ�^��j�a�6K�#�;���P(������љP�9���'J�)��F� �z_=)vkZ�������/��� ;����a
�O{uWˡ�(�_�e�o}��ֵX��5;æ�C���P��l2�2v�o0�w|�aoh���p,D�p{g����%�+��D��[�+zge��[Fu��%c����[��������?�+��fԇMP�fiMKǎi`&LҪ��q�o�=}L��6xҾ������-�Lv�T򮾵��t�d�-ٗt��pۛ`���7 Y ��M���V�[{h\�d�s)l��v�M�[N� h=Jm�dbru��dUk�X+l�b���Q'�垱�_�AV�$s����C�.�����bH#_��R�l��"�H��}�^��ף�h�ɦ�"���~p&�����K%�Թk��wᏲ��N?��XU����Z��.���Gg<=8���D�N	����?G?�w/G{d�����/��9�Qƛ��ur�7Y����WW9h�3l>�2�U�1�#�s�-�nt:ݨp���rT�eN
���	�Vdl�/z���6�J�=V��s�֦nM+���g>ɹܤA�u�Q9R+�_~ʭ'�&���i��$5�&;�w9g���=:3��f��ˠ�J��8;���>����x�/�~�Ar�uC'��n�ڧzY�\ߞHMx�]���!��.����ƿ�����l�NRW�o/"�bl�q5
��fm�6ЏJ�yP�j�
�>�nV0h���|n˅�bi�������oǷ8(^
'Y�)Gb��0���8�^��p�S>��5�)��O�-�;ۻ��Ll����E;�������+�� �1�    �l�!Y���5�7��5��[Upt�����(	j��M�H`z������n�=�X$��"�ǚ^�C0F���E����R\4Z�[&9���ƾ�)���k]�H^Tz�3����I�4���{����03'c��.��1�60�?Mc���=�?:�ӿa��}h+�ΝH"�dR>lY&�Y2(�VA|^�7zӱî�A�����i�A�=ɼI�حZ��`7�&�,v��K&��u�͕`�5�/����h:}�K�L���'�[y,o~��dW|hr��L,�FХUo�m�B^�Nq[���١����]����]d�n�+��̏Bۄۅne�X�#��Ob�w�W���Ob����@1�V��p��&��/�{'g?���\CMLw@�fc�}1�>�Dq���+��b�v�����j�to���J� �)�9���O�8�y�%��4��f{��38kI���["6��%���ǿ;:�Et��Gx3��`Q��'b|	틮$��'ZM"����F��\*�6���C�Ē���m���?<��ik�����i�����6�ot�'��g�R �8O߽\gӉ��7ȱa�w���k5_�h�]LBL�+�P�w�~iy_Ø�����c�7�+2A]���W)��Oӑ@�b}ﻘ���f��%n���e양n
�Ix4���s��?��I�Ũ '��d��D����Z�p�s�����
St]/]�{�N�wnS�=��6��0�+6n �:�ںg�ՠ��^z�q��v����C��nMS
�� 3a������4L�A�k�m���o��/��U�Wϔ{״:l�+qWSFǊ�\��z��mYxě���2L��nӪ�*it�g�G�o>��%�|�����ކi{Zw[��k�r�[l��^�r��.�igv��}�Rp�2���l򪌚��Q��Ɋ��.<4�o���	�U��vw߇��(�������� ��W�m�R��!&��n�<�����ŉ[�,�:�Y&ż9�z�9����=��z��J!ބ��Ќc HUi����%S.�8�o�S��)*�z���%d�I��f���Y��Uo\3��(��l�(�jx ��:����_F���IY������#Y�e�݈^�����xsw۰�e&ty��ox|��
���MG�Y�s��>�ms����,.����r�����2�i_�k8,�Z> =k�o������׈g�^gvb�����Ďʳ��,���	��Y���<=95��kr�!*x��G�yW�B�ֵ>�k��$�q��Q€3�<�����r��X!���`x�6��n栠��#��cl:?)�!��'M�	G�k����ISi-a�-���$Zuƫ�H{	¶�'Q*��R�@�͸~�rm⇧��$
�z9���5�}�d}��&���I���b���rn��\g�>=���湯��j1f�p^�/)����\죾�#�5�n")4���e��&O����1� 1�g�HW'�.i�,z���!��y��:���a{���� ���N��Ů�q	����n��"�����Yc��DL|^F���F�!�G��6�{�Z\w0��i������ ��l'<pm�'G�a�0�|��+�|/
c�7jĘ�s{����R5t{��r}��|���V���tc2z����
췞)n����g���	�$�!|�3I���Jg;g���-U��>[�&����tXe��c$��p��l��¦[�xZ�⛳��R?�أ������mn�(+x�J�Y	�׾U?_^�ڪ5gY����I+��g���]E�����n���fĥ��ں�:�E�e��R>r�ؤ7�gC5����s0����9����A��yWmv#����\�x��>�ߜc����N��ņ1�4��s�'�\l�Ω��?�����������o��_M�P�s���zf��נش��2o�T�I4�Wh��U��k��������bO-����e���޷�W�K�mi'a+�7^q���;�D���
,4?����(�u��H��To�\�`p���`xt^aK�n������L��㍜�^�ё^�Nn�6���DO\x���é,U��AZ�������j�� e�T6�9�K�Gs؀����4�<��A�����ۣq��
������m�R�}r�4�nR��q�P`�WEh蜸��l@�%G�3-��J�'lW�``��><ï����@��J�[\1D�#���?���������(+șh���;��T���
{F!��8�������w��h�[�.��::�s)e��p"&'�Dڰ	����<H�%'���Q~Ei�\ck=PtΓ�`P&B�	�1��ŲB���C8�3���})� ����v���c���o�r9$�bx��	P+)�j�a��Ǟ��(9j��(m�
�ݪJ�X�N��k�U�
�Q�
������g�**�n���|N�����H,n�W����:a,�J�@ܠq�0�l%���9IT��ۄB2L� ���l��G�`��$h���iqvè�|���IG�r�Wk�a�����<.���>�ó5�a��4}��!��	���+O�d:C8�0\F����\�:�yQ�&4�n�0�sXހ ���8�4��tU������7�Ö%go`G��0I�M��j���
��?���^Ğ���]�������v	r����$d����E�en�Omx����V��.�N�v@�]J��o�K�6.��Q���_�<N�LԄ���7�U*��\�[��^����n���s�[��H�궓o��Eϕl�k4��0� ��ӱ�`���-H�(��4񃓀�?��Q�4W�X���9F�'�[.L�����9M0:���A+�Y�]-�+g�Y!���|AP2g���0dM���VXX��Q�'��1��+�z§�+��W��j{b��"v�M�o�E�0e:tpShtA]�[ \Ŋ=���j�נTX:4���R��(\'��ih��5p� 7���K�5<X%�0z-<�^y\����L��o�`�=&��W��!�N�Ɛ��V[��M�h�[����	dO�ٸ�c��+��5�m�q���¨x9\�@�q�{.<*�8��Jh����.l\�_�	�Nwet�e�"y��{xg��" 0�%��̝q�pD!����O{Rot8����m�����/�-�a���'�'>z�r����k�tX[8��e�(-�[W���r8b�p��������I����x���`;M������5�5N4x��ءL�#~���.I��p*4��9�9I�h(��<�hV��7 :�b/M�T�oH�f`+�УY/�W������Ϧ{���p>�i�e~�9U\@�2o|{�w��+ˇr��#%M�j�;�/�H�D;s�6R�����cX��v:����1�b�9vn��\Ed���A&Wڇ�w��Ǘ0���L${^WF��Bm.����~Fch yo�o�,ř����*=U�HV&�DKt�ϒ5c�0��+y�O�����`R�D�d��=�PE�̌L
�����WaJ'�~x�� V-Agl#JV,cZ&�|����?>S<䔦*<L�nI��0Y}c�q%DwO�r0L��kU�0�uQ~x��#H��b��B	�c���Ђ|L�/D�3c�Q�V�9c����z9�o�S��d� q
� i��=�+,R}[��G��2Ȋs�&��t�kW�{��Q(#����_�\'#z�9* 	���R��I��g{��u���˪��p�o��K�.���*� ���F�NA|[@?$?�]e����V»Ϧ���b��HO�N���cdg��˙�S�Wz>�FjJ��}�Jt3�+y}��L2A�y�g�U���Rv�C��e�;�<�Pf�2���[�2����t�M
SD'��G��c�������*yR��ٿ����~.�^�Z��h�E|c
:���bij�GdD�?X���Je�i����5fz��H#��!K-G�\+5�6y�C֬���9`���e    ܻ���!�ʳ�����8#\�'^ި���©	��EX�n0��2�PE�x�"sj�����l4�>�i��=Ut�����_��f��3/����wA�C��2�ţM��
���|��vF�9��_�G���w��r%N�҆׷��gDI��{D��� ��Y�1���c�" �4e�C�_��B����0��9�"N��cskM�%���β���U��肝#��r^���,����P��:���vEG����m��7�ѿE[�~����a�_�3s������0���j�<?��DlF�ŕt��t���G#m/<{��[�o�uJz��e����v��_��Ji�;%9�'5���M<�gѸ�c��1V�G��o$`|1�9-�#�\�:�p�B9�C�N	� d�i9ٝ�£?��^�1\��ƕ"��?3�tk��`�f؆�@����&�J���٤�@2�h�5��M7w
��)�k�ۻ��]z�ġ�*�ԟ������� Bx	i�*�ZH8l@	��V�C̳?���@n��e���b���-FFC���ӭ`t�&7D��i���_��AG8��j�I�d3��ѼC[,���L�A[*I��c�Zk
�[�C���.�B�����r�K&��$ݲ��I4��7�*]~��b����+L2T_Rϑ�^��U�20L���FL��$ݧ��9W<PHR��c� f2�TM�~]���E�m�[�ƀD�py�����áu��c��c;=d�@��k�_)}�q�QA�I�[/:�K؁�F7k8���'�
d�V]��&���sU�"q��4�몇\�Q�H�LҦ����×;`{b���������m���k+G�cԗH��k�>!�?7OW�ɇm6D�(�p+���c���[/:��E�KȔ�Lg3�f�N�m�Q��k����0�����S�o�-��7]0E�G�G�n�,��3$�%W���zB(7av�i�~r�@��7�$����OZc��A�	�.`S�$)v��e,���l\[n�6&w�6@�r�|*S$�˔|<\^�i�V��'�{����߰���01��~�A��M���&<�>�.沢P��B�"FiF��y�P�)�(�^��&ɕ����r���w���>4�R�{<3=�vJ����+��WI��Ґg6�ԤX�I�*iJ!�?���:L�G;ێ�J]g7�ж���φ�%�Eg:�*z쨌��{��L�іa��#M��ţ��sD��� :G���(����^�Ң�}F*���������!��i�������Ȧ����l��D����N�7��9�'���`^�դ���t���1-��v�4�&~Z�cmx�RMg�(�&x٧�����`%�ٹ�_�Ԗ���J%/@�T&ɛ{28)���J�RGxX����P�	o���0AYKB3�"�`r[.0g�|K5D<����1)N��w��(�	b~�P�����7vU��g$��O閼��fgYX�B�����L-��h�!�ٺ��5VpY]@��j=��!~q���`{7ج��E�-���5=��|O���%��<ұ�m	��o��H�5`��F��:�����m�dY.6�9B��Go�Ĕ�T[�!��m���	�{�0�q1
Ƭ�yl/�ek�%��dΡe-7�&�R�4�bYjxOVb��)I{6�f��Յ� he���t��Kh��a�&Ua����Am3Ȇ��Җ��0�jU㹚��]��~l�i�=G$ק�
��{�6N�o� :YlQ�_
0^i��O��8��r��?��L@D�d�!<i+or꧘r�Yv� _��A�*���/��y���J�����}5�9� 4[ /I��c�wR����#-��M�/�TdW�G�d8y�R�����{��z�F�?}�i&����c�\��t�E�0e-��R���ȏ�?��Fo����l�W�veΈ���T=@�d��,K�З�C(��A�/�g�CM	_�b���{˦�ul�|��t��($�'P��2J�'��jC���J�����$xެ2�k}�
�R/���,�ʻ�����JA��Q�ԟTs�j����X<������=��
z��%F�P!ӡ1��m����3,I˘R\Z�s7���I�ݙN�X�)�d��-޲�Y	��ï��@��y�R���J��M:u��ppݤ�Y
Jg�"[����k����~w����B��|!~�`�/dV��G�&tTp2B���O�|��T�-�Ijq�����$Z7�mQޝ���kp��Lb�}��Ȏ'�!���}j����-:�ź�-q����;�}\�µ�o�8�����!RL8=�Zr�������o@��ضI�AR�p;�}�-�����s��3���^�pX��),E8Y��=�}��T�M+�@���?ڠ�ӶϵV�Í�|�'�S^˝SV�2f���L�b����*��y)�����789mM�]��=��ѽ�n��,�O���������� b��V����J�Ӏ%<�����W�\�ZN:�h�H#ָEI�1c�<�Q�{�M��ߥ��S_aY;�*�+";�.�u�}�c��'��/�o��!�GZF����Rnq'��� �-�'��dO;��ˣh�,i��#���C��^�K��� v��w�u���v}
���4lҰ�e^O;�Ռn��3}�hΓ�D��w���<bѕ����ɦ;N��f�=�|�z2�F��-쌗�f"v���5k��4�\�[�S&��3�FN�Pi.����6���5�	�n�-��t��������7��B	矤=�M쭨��_����G�]����wyf²�N���[�4[M��皝���N�z��Sʳ��F����	e�6*����_fA�+�%/QC�ؾ/����`������9N/���q�]��9�,�#/��=ч�L�-vYY`���=�[���W o�|k�C�������!^!׵/�眿�Q;-5VX|�H�om�� oq=pM?���[+A���2:���oS�I=:L��&,���%3g��"��z�͇X�d��]������.�kx}�S�L�J�G��m/�w�4:s�9��B���C,e\����˚�����I��)Ћ�]XD�H#Iњ �u�o5��mr
��;\P����u;ۄ#?��F�9+�d��	��6�k
���&�=�`�~%�}�� ��Չ��w��@���fBF4:��N�š�Fh.����v|;X&j-�T/M\���G.I�>���bgK0d�����L�gwhÍj:����VWx�tf���kt�k0�v+'ܖ��e��2�P@�U�`}�&I���e��B��-eMpqF�S}:��|
چ@*�:r?���Ѷ�*�S���u����LB��L�&�M9'wQ$by
�d
��8��hnB�Pp��ve^:��/��P1D�W<�AJ��ݒ�	�ٴ�uZp�	D�I;����V��M6;$
�ƦX��_�^�\�<�k#U[��^�Jf�Dŭ�_�����k��E��E����`�i��8���?�aB�`����I�8)�4�/x����)��r��"EVqIҢS���)�~+��ś謹�ߗ3&/�R\Lk98nE�����J)>��	w-.�עB��T���yO��^!�;��2�A|�~���b���~9eEn�Z<�g@�3��:h��P숬}P�6%���#�)�Tx3�4��-�৲G�}C�u��"�`�+vcj~�jߥ��8��b�����L�����v�Z���6����Ԁ��o��!�Zߊ���k^�m�x4��a�M�N���w�W���;�2�{f&�7�F+"���@8��Q�I������������a�Jvn�Q�5й*=��������e�n��(𼱝n�>�S��R�j��Hy��f�w�#2�Q=6�D�1~s��5uLSt�:��F�L{�d�0�gy0���r� ����'8��u��z�ȫNXX�T�ۥ���>A��2�Br��J����2x����.��J)��[��eșF���JqDjzqi�y͔�a�Y�.�2�    t��2����S,�N���`����be�ίPp�:���E}V�>v�����Y�,�@�e�+�M�M�����H=����Ïe-��N���kŘ����bx���@x����.��w:Gp���[�r3���O���Ƶ(%)�o����84����Vlh�Wsn�I|����l����k%E��j������*`����q��^�X��.�>x4MW�)��5T=d;W�66����v�!�&2|��+��FM~�7ؽF��m\��	�)���>�R�q�����u~�`���3����1Z���H/"��qv��`2*��s>�i�ӗ� <n��~.R���\���$5b��b-W���)�#�<MMhV,3��C4�S��@��|�����Y���*���B�#b�a?�d��,�/"_$�k��>b�� �:�Ѯ=�4��O��x�9	�ۆ��\o!&a)͈᛫�Po+ 7���(�ḰJ���:*���	��3�R��z<Mm�������μ���~/�>�Չ�i�t���qE�t	� ���>�U�!%�?c���(P��{��y��S�n�h�*7X�����eЦ�ı0x�C���nĚё�7���:m��pzr�w�IV]��XT�'�(�6I}�qεM�i�Wӄ��yn�`)�싀�M��t!v8�\�j�l�����zy�n��1u�/���!�y����U6��$V"��q|>!��!rP%ʫ�Q5��0Zd�������İ#\;I��29f���8B���ԯ�K�e��t���yD���Tr�F��V�@�*v��.~ׄ+�T��[R�Zf 8�={�{L"{_L���k!��|�����֙"I�����ŲL�vi-\�:�[P����yW{�Og�:̳��-�g����d���g�c�����������M����-�ł0�έ������h��H�lC~�����h��z��20�*i*�8�
-���,��)�������b-��qhcU�ch�*�*/g�gAǪ�<�+ ��1RU�XW7�,�7i� ��ag�Y�%~,v<���ю�S�&��-O�kac�@�I���Jt˝�d�_*�J�u�]KM㟻�'�����9�5�Xo����eQjvQ���/�&Q��,#�.�k���r{��Zڀ��U)D�`�S��%����3k�J����v����L+M[:��$��
#���N��'��ʉ}f���zhϤU���n1'	�6I*&�r�OCG��[���ݙ��WrEt!{�͎�E�d+LT
�J��ĺ�K䱥9���D��_	���.�J�i��!�����]I����<�a�z{���v�Q"O����-7^�K؞f��u���^j��s�~�.]�DK�]���yw)�D`ϧ��V��S(�������f�=��T�3v>~��P��̎�M����=�K�1L���%�ﾣ�[�h=��Wx�;�q�3�wQ\��p�	S������x�	
�Uk��|��t�uS��bo ���Ҟ�f4a��4��^���b9���}�ޢ�x���\�)�\aiaP��`$;�Re}@�������ÉB޵�������ކ&i}��,���jUeV�6��f6�	;[w	xeB�{v'�|ry�)�|��Ԇ�k�Or��ϭ�rjA(7C�+1p�0,�Yܶ�$��,�i� �U��0�J�aҢ�	ǠvXw���Yf�ݶ{��k�9/��vf�-U4!ҷ���D�&�ow��ٲi��]�[�����#�.�α^9�q��@Q�o�uM2���p/Ŷ'�o�0Q��F��]��vFr��Vuiy[Iwm�9�qM�dk�5nTF#��6��sey�wf&�ZビVw�wf�a���YnD���]ܘ
����,��s���艰h��7�P&Lh'������XO��;3�?�8���R�~0���6X/�zFp_đ�����ﺡ�K�0uc�M$�IL�?�:nVvv�yx���k��ȱ��Y
'����2�bOr�Ot����[ݚV���Є��$��?>�`�`Y�"Bs"��Pwn���F�w��`2M)ލ�8�?�Z/��m+`H�s�����Y�E/�����_�ݤn  ��Tم'iM���O8�{�M�wZ̫�
z���t����I�����e�|x�9H03ĶV�v>������r��^�d��"̇��5��C�2:v>bү��5]5��~#��[��wV�_��33�&ܙC7ϬDW����!�۲�5�w2tp-pq�ni�����9<��"[&��]���4V]�a�7�xM3�V'�(
,wR��R%�����D�8�ՇwX�us�(�92ɶ7u���d�G��6;�������E)�R�=�b5'�aqV���%9v��IQ&�k�>s�3�2���ZH9%�㦃��Aj�E��&�����|��PRd�s�b@�J�4%�f-8��j���	�4j)�hX�a��vCFt+HUQ7�Y���k2-1����&z�C�_�Ԁȡ�oz<I���E AW�B����y��Π��ot��%4!�����%\��k��"}۠���V��G��_)��M7��k<>����&ؓN�N!$hb_��Bl�&���a*���꽅f�C���b�e�Z�bE��d��d��5���.h�l��D�gJ��,:��o;�S�@]�D������7Ku�����\ÇA
�/����a����6\�/�*��B^� Ij�I1-��j�
�����Ӂ�Q~��
��x�b+��7~x��h�Q��2[x�iW�	4S�I�<�%�p�����&�����n
?{w}o��T;:k�&RRgj�o�`�SU�������U��n��&�pgZ�5ad��@Q-�D�)?��z�`�'�%�(�x`.���0tN�Q�ayR�wAl��<F�8���締.�@Y�ώ������wR��g��ˤ�bQ��%n�Ѩj),)H�H�|D� A�U���:>3Kvd��t���4�p�Q�˜���FgT��F�$@��Xx��"���KL����(>��.;���O�Ӧ	?i�Pv��i-����G����o��P� �����&�C¦&��;T6�S��({�F[��&�e�{�|��
���+�}ӎ�E
'�60����(K�P�z?�$+K��'E�>�o>����
J�~��@n�hJ����N��l[�R�e%�$�=#�0�P�a�"�I�ʍ?�;M,ڂ��$k�Փ�<�%�c�lü]M�J �^������ݎ6�����U�� ,���2.Z�����Kg�䠠'p�4�&I��r���&�:"M����?KD�'w�)2;٥�U����p��.��?�4Q��$I�&�c3���,�C���8��r��b/����Z �Np�c0�ۘҁ�v��υf�/�0Tzb������Z���Rf#4�#�BM��2�h�ʱ4���N�5~�Dl�p<c��6���J�p!B}x@��A��x_Z�L��ܢ��Л����o������bQLfFS�v�s�#�)YU�P�R�b�`^S���T�#�q�M`�u��}n���� '���	��[T�YUA����W�D$��2+⊽w���:j�M��#�V'1D�tI��2r��E�r�A�AP�=Q��S�ʌ�S��۾5����S'�@�����N��H���h���c��0���gv��|4���'��j��\m��p�4c,$���y�'��`q�@?��m��4����U¥7ǵͪߠ��?�F��H�]kZ2v=S���������_D��F�������{���8�1�Q��Cn�\e�~y%������^j�!RCp� H:մ�I�4i�&�CuA*�a�����"Op����[�C����TP��!�J�/Zq���(,sjc��\a���:�f��� 7YUvA�'#ݻWk�*�Dc���6x.�1����F؞�c��c-s�G��H�:�L�bW�����-v��u���C��N����Ӻ���    ��)9�AA���j]������
�h<��[�p������v� aW4��%� /@�F����-�]�ޣ�k�6x�rn���P|�V��Д�0�WtYߖ��e9�6�F#����9��Ɍ^�C;-�d�-�4��Gn4�J�݉�Jzΰ{��W�V�<�[�Ά�:XE#0�(v���z�K�0�/Hb�Q
����I�� ���Z�&�8O%�˱`ى������z�0���Ȧ��ʁkY	m�e��+�TfW�^
vJo���	R!I��[�jK��y_<���TD��k08g�C/IY��*��_C0�~K�O�QI*_�l�[��9ar�"vޅ��Ip$�
�L�0���uE�c�r�E�G�̏�1��ћ�Nu��n��I�ci�HP�`�=���/�䣕>އ^S�ЮW��#��Ziɭ0^Ab�]V�m�/�.2(#6��Ld5w����H��ai��C��w�ё&R`�M��,r�픰+�RĜ�˘�j�b��'GE�Cg4�m��m�z͠����ڍCgџ���ׁk�p��G��/�)v|o��䔘�5�L�Pylh.(~���hl���EKgj?�ˠ���!GZ����/�^�O�+M�cݳ�o�ƅ���`J({�$�8g�i��6aB������ɷr��8�)�h�K��}n;��>Z�^H�fd�u����Zpa���`�(�*(��>�@P�ٍ�$HC�͙�/����^p��M��g��9�$�D�|������z3p�;�z�({"s�����&a��I�����b���W�j��h�BMث�M(�s���V�,Al�:�F�/�:{�L�	[z��o�`dԷ���e��`�âL2��9��){��OVB���������1��3!��o~�����%ێ��re�g�D�"E"�Y�vJǸ�������&.���ߝ3��a�!�iT:+w�|ȯǅ�N
n -�����,��8�2]�5��N�c
��"��e6u˷d�:o��a4u�(�9t�_��)�"hA���ы���ߧ�w���:��7��4ś|:&"~��VT~8t�zL����\_��_��*��	1��!?X:H����E_��r��=���s.?F_�����u�7������u��\�7)wU� +}��v��HA���Js�ڜj�/Ջ$6�ӞF���6�R}�M`�E.pX.���Wh�oTZ��&0S,?�[��snF����2BCi���,��&^�ɺվ�r�U"���+K�ɞ �'�&�/p7�|�#�[t �or��a���mq_+�+>�X�!����\�:l>t|Ȍ��\����2�P�9��.C����U�PJ}GBL(ըm�BS3�$O;�!���Ss�o:b(������n91��L2����0�8��oTW�p�et��y��j���.H����gq��b��Pj��jqqp*���d,U�����~�]r�9�d�&�2߿�$?ajM�Ő1����Y��Z:S��rJ�B�a��U�?��bm�\^��[���X�x�\�L�����\�fw�tG�0�������,mp��D}�4�}t�b�@.��Y�>Mj�g�hw���E�1g �Tr32n'�"1��ѹ/�E0Fa��LP�	JFӲ��t�џ�cV<�r�7�]R(ͨ&�֡g)h{[����u�׺����S�ǜ&��3�TT�4��Fud�d��"{nu�6U�a��w��'�A�:�?X�9�\ݎ -�m�+1����i�$a{�&�9�NV����Qb���$�;*V#]x��s��J1Y�`�~k֙M��Mm?|�s�n�'{��MT*��u1�1�┯�d "��|;[?\�J�ص���Pi���(5�J�;�n���L-�-�rj��,Ȃprb��x`�c0��z9�r����P�$<��{�C�E[퍯�e.�����8�:���c��'!۽}����i�$CV$�7���'�&EĘI�6��1t�`j�MzefHL�����Fp����D�	Ӈ"8Y�̫�Q�Ƭ��?�l�hq�ī��#b����,����u2LU��'a��c��>��0W�qud�Qmݗa#cT̃��Syv���	��������.��qda��Q����6� @�#T�2W;���o��k���ߪ?�[v�7�q��!.'NѮ��#t*�9�K����[>�$�aV�e�]�-�����o�9+ X)N�����L#��J5�>���d��sZ��fF��t�]��
����?��B�bN��E)j`E:�r4��ҙ:��l��	��)��=�Jԅ#��I|c�qwB�;0XR2+@`�
ɺ�\dfP��$S�`H�"n�a��G�����7�Y��4R�8����N*�,��7�o�m���q�3Sf����0̠@V\���pT�9�8qP��	�$��u��0��s#L�0-Q�ѣ��Ry�н�m`��]�/{.w�>	FpSh$%�S�RR���p�|W��[0nb��{$�&�H���PF-*_��2��8�:[����a1]�~�����a@��4w��Y|����[���l�Ŧ��[z�y�����xˢ�c�Y�:s+��vL��we�4}h�P�V)5pY���������lb�qê�٦,��Ak �Vj�$���)g:o��?k�6�8� ����˳g��b����ّ����u\�k�]k}��XvŮ�ݤ�ǕH�w�6#�⼌�iS����8[����1M"ߋ����"xgQ�J���<I1Zŀ`��_Q�m���䡩U���ծh���o��~:�'�S.���0r��ڝ�s{Y�:�����Y�/B�0?"�쏛C�ڎ�-Glд��� ��9f=����	u�V�8�:d'�d�Cɤ$g!h�TGW:�`������+�*[���*]�����,�a�ͣLDz~��9P|ð�ĝ�,�e���]s��"��9G,|��@e"���-u(h�N�:7�vί��Wz� 	aJ�1p�ā,$-�
���H�b�g,8��jw�L=4���(���u��C��R;I������~�L-%�V����F=�QYO�5�u���K����ʧA��K~�}W߆�Ht�,�'u���7L��pah���E������W"n��#����4��;�A^�Pb]^�Ky_��NgJ��uB�a�t�u��O۝M5��O~�!aw��|55k�Z�(HB��2��.y:�Q����#�p��(�l:�h�/~լL����F~�'����Xy� G:�Z1XF�� �~�P�\AK?�1Y��xZ�l`��=D�
�������{�ʨItNq��p��p�~{3y��*���[H�K�)�g����N�����TXR��kLRQI>�Q�*2�fOYn:k��ST�r��-g��Lb1�I���8�EH.C��9s����"���Í��^��)Aǡ:*k�*�(��ruҵ
�O�2�\w�h,���8��aB�;�L��9VxhF5>�������������!^�Q'3ى3���)6�O��0����mcנ��gA��R�
��{��Z�W{"���3̝J,�R���k~ܩĜ�%{,v �R�1�:��F�g����t�5����l|gIܵ0���Y�E���%���i��*'�Qİ'{.���?>��g1�^@r�+\w�d>b5���t�O��
�|	0ů���2�ڟ�W�t�UG-�C�ϫ%ϳ:�U��EeI�8b{	v��۰O�F�G8�m�n�zVGI5X^k:%:gB��6� �b�N¬���;I$��O��@�Sα&��I��ބ���i{..��q�T0c��:p1ޭJ��rur���8:��j�,���o	��e�v�z�LE�0��܆ӱ��Prܷ�ۅ7�s<ۦ�6�8�i���b����2L��e��4�h�����{�<1���&]��5YS�'΢��fӽkĢ�l�*Y#��֟�;�z�v-_�NK��3��~-���[O]</2k��dQ�}��12ۆ��z"+|�1\�Ϣg�v0ɊNe+���V����m1HTi���	*C��W�    �JϤ��t��u�X+���*��o�/.�`aCɷcO�*�r��A�j蜱�|���T嫴L��E����V�M��-�IU8x�����P�x��/s���-��-���4�ȹ��k�\��� h�e����jϓIT"1E��y6�9�,�alE
�-.�j�+����߽i��d�ĜLk�3�[".W��m��|vw�>��Z�-,��k?�|v����URy��B�*�t�?���E���j2�^�֣���[����<dM�;�F�%\�	�/^�c}��*��cEP�"�E���ꙇ?����y�R|�ϲ�/�˓���x�T�p�rbY{�X�d*����t�Q�w�5Ms�[�.������i#΋b��`mA����*9XGb��tJ���t���E��u��G�>le�7�R��`6��e���ao�JkZ�).��S�b/mL�8����K�-�R��诖џ�`���!��v��6��%����M���n�jkw�
O�q���ov���큑���R����ѵZ�(P9.�� 2�A�_p�������_{f/츄C�:|sң[��7laP�O�ؾ9��ć·�q}��eŰ�32��ת՜\�>YA�>�h�win����*1����g�b��>%���'��j���ˮ�˝x���P�����t�`�gu�R<ʲg�s���bT�t񗯇����6<��}���l.�S!�0���x8t^s1)m��Af�Yx;�<����˝Uyw��6e`�RzbTt|��x/^�_�%��Y+�%������Z�0y�=���%� îh<瑖1l<�������X�"�M�G[�,��3�K ��ݠ��)h�.��0�����t`��E�o�1�ﳵL��=ۇr��r:�~���Ð�������|S�N��:I-��x>=��	��e9����4'�3}�D����'�6d��=�T���[h���>D��X%��C�9J3�I�K>��d���]6-�S���H�z�6րA?D��[�Hz��F��J��X,����L�9���pvLZ�:��w6T�x�U�u�@��Ⱦ�w�1ؕH@<H���ҿ!�
[ZѪ�K-N� ��k�¢�ļ���GV|^0zď��V�A��,Mk�X�o�M�����[��h��hG���m��Xn1�c���`�=�%e��E�����'�l%�`��k�t��03ݺ9�G�7��YErH�e�a��}*��$��W���sk����S���o���4��؇y�gFM�5�p׵�)ܘd�>��1;ˎc�مi0�8��=<��J��Jh��-�)A) R��,K2%����hF���;Ks�6�*�ᮡ��X�nG�lj[��0�en�j�ejio���$�W-ޖ��-T��D��;�$�M��
̧&a����w��Bة���N��ٺ��f����54���oy�K
��p��fX��O��3��?Z����!O����{K9|��[f�e.wM�ӎ���F2Iܗ��Tbޘ_���g3���E�x�mt�"ﶌ	|�zejCH$w���rxf�L�;]���O��q0���]{	�PJGvҷ�oe�',־��XUk�}oP\p�����p>��w͏p$�i]�
��m��ï�G������B����b��M�doo����\-��^5K����L���$=u0Is��%����Ilػ����p��[��pA�����q��f]2Pt+j���B|�)�F�Kжk�x*�W�q4CO���!؊g��N+,��	���⹆-S�~�}c��[�Si���P���߁�IX�D�An)�!H+�!I8H�&��j��I=S���0>�>0� �c�o���K�*Ff��3��ą�0t�3:ˌ��h?�F`��E���z*�CG(r��͵D��p�v�3�j;)����V�P�"J�锱�O�S�S�c�7��P��5Oą�Nón�F��}j~%|��x2TO+�2A�^�KW�[�1����}3:��h��!�����k�_D�$0U�/)0��^=X�d���p؀�D��­oK�� ��O��tn��vE�&���+�c��� �&ɿ�u�k�(x�7�J2,(��Pu��LN@5�M���;>c�r~���� ��AR�]u�"�
WeR���gG��'3 ������)���PP�f�K�rF4�.L3X���0/_6�r�,�B�2)M�:�Z���?���EVN���l�z�J^"��VB���X%�O�&$��h��U�t�ݹ+�1>dREܾ�RF|�'��W\N
�|�j���ek�k�y�P}te3%;��Q?�DOQ��X�a�EHЍv���ƻz�}#�hX/b�7�H�bx�yݝq���簧�Ƨ���[��6p��}}��E�Qu_,{�QCǺК��_P�aggۦ��1�*h�l�xf(���,�$��<IǇ��-���=[\o9=c���f.���D����*����U�h�������L/MfU� ��d'}�=l�s�C�"�*3���({5Ty(��缻��ȰKR�c���0g^����D�0JL�j3>���ѩټy�#�|��N'��EJ�Ia�x��c�T����Y������$�P�vtĚ�D{�u�`Q~	��x��C��_HMx�ՃE7�}ԄƩ:K\"���j�b�� �E>9�����J��,+9��p�΢OJ��~Y�R:��c�t���CPM3��y��|��	���F���"�5گb�ICSe�e�[��,|�H�9�8{B"�&�|�k�!,v�^~ղ���zQ׾n���ݯ�vp��4���ѳ����Ijp�����v_�TUH3��ez'�rLA��o���6��hy��Ò�p ����!�cl�D�C~l��� Ϊ��^�l�X�)#�J��/%��u)�\�Rs3\��hӣ��.�l�M� f��G1�����BOJ�pHl��Vɵ��A�b�e�h�'X�T�x�EΗ��A�%=���,����4�FpR��:X��_?�w��'[C{���{gYF�䟎9,�
^���.L�Hϗi پ���e:�ś�T�ڍrU%��H*��_����I�O�>8��tB�����_�q�g){�?H�~p��W�j��/?�l�Z7C� �=�9�<n���.��iu��~5�J�6^#b;�+��'���ksx,�CgZ�X��\,R�M�q�v�hu��r��7�zЀʚ��p�$��F�ҷ��W]��v輱cv���]?�����J�T2��́��K&qq6K+p\PP�=?<;��A�H�wYM&=�&����d��(��\�_��4c�)Z`�p�\���iɲd��%��3���sB�,z��;�=��Ȅ��	�H���F�r�fZ�[^�xǻ�A��a-a_��������t���iY�|+Kl����w�+l�1�+�ᒻڌ�ͦ��� :��Ң�Ļ�F�sF���͵��Tj��J��̷R=tS�^�9�w�HWw���op����*��UmP������&L�m�_���o�&�"�Z��2:�<*?�L7Qo�>&�����L�kS�j0?}_�:��H]�1CXR��+�������i�۫MT�����Z�W�[^�	.�h�+}6�M����UC���ƻ�b���"��4����¦Q�)xȱ|�>��ݨL�yil��|~��i���.\���qu�mq��<���q˵]�߰x�7�_|��.����	,#�ʵo���д�c�����#�M�ө����)f,�/��Q�e�슾r��$�bn���ъ�a9�X0ȝԫp�|�jR�b�p�F�������O����@�_�-��8�� ߞ2L�.,+\ /�-T�y�\�gPo�+�����1�ݿ��8a�H &��$��M�2X ��ٮ�!U�>Z�g�2����zS�[�Ø��qgf�_K�節��7ު����r2���S`�~�J��k��N"�Ov:3e�b߿L��4�]}$���~�NP}�� ^C�hS�*l��՟<ʽ{J�S�M����K�:"�\�N�ܡȶ�N���BQU���w��CJ4Q=�/    cK{j���s)����|��X�H�N	�m�o���m������^�x�R��҄�nuxUُ��b+|}�����2vj�`�xӇ�rG��:�����DR���i���f�u̳%��w��C��,V��U�6w����P4�숎kyz�G��#���la_}֤�]�,�NtXO��2�ƛEG��~�tj���r�5f_�n�K8f��x���ǎ�}��h��vN���.�����k��d�@��*�Uʢ�R�]�>I�����z��s�,�c&�Q�7�m�6�(��L7|&﬘���"�g��)�ϵK��$��xfy�	�����L�BF��%��B�;��h+�$��NA��2�������}�,Ѱ`>F�{����c7|�Y��]��.�aAڝ��c�����!�OVi���@�,�I�*���{�*���5~�C�<Ǜ̏r����.����[�4����F~4�H�ɑ2C�9�/���W>?��?�����6�m�K�`��s��5�r�&�c8�$�P�R���Z�"X0<O����I ǫ%��'��B��z�ށB�ѷ&�R��aBT��z���	���螺�M�'z|.�v�*��sb��K(�+~@\t;=�e|�,&�5�L��Z�.��tZFWsr���<�U$.���oG-ܵ��Q2u��g̟�Ź(��	���[	�ھv��a2�����M뛀�6��~y_umQ״�ތI�t�v~������A�&X|8˅���Lr���jC�M���Ax����h3��$�:t����]��-+ͣ�(��6a'9���x�
�-�cb���T�!\��[`tK}�|[�e*� ,�9�/�����7'�r0⢛�)%)��$�X�;�b��`��<Z��Tc.�ܾ<�9�B��w�����6����n��gP��HS���pυ��)�Ԗ�`T!���>0�5��u͐���W�=m���W�q��͢�&\e&�*��|�|O�ͦ>c���-�U�V͔�Z������i鯗�I�x�1&婜��f�K�aT�ܠN��)I�V���
���o6��K���'�ʄ�����E�� 0/���4�KrN��^���p	�����Z��"�ܖ^��o���O5ޭK#�<�2�*�T����*���b[����R�ք�9�n	��q�3et�^T��mb�yp�3H
�R9���y�qv�o�3�����q�kĺ>�%�K���0�.gΔ����:�`��/d�ͅB�a ����˙���W47/���Q����Z�����Rw��}m|p��ہ��~��RÕ�.��ydٽi��"VX�}Bh�+$y�"o��*�:A5��Br(�y���E�b�.W��г�8�sH��ЁI#X�|!�����b�j�;Q�V�a3�շ&�o�Quẘ,�� ����<��Iu�Mw"�T�8��Q��f�b�-W�$���2^�AX?��B�=3�w�����b/�2����1L�W�@'��e����.��Tt�Ӻ�P��Ќ$�JMɼ.������$��+� =.��&��F��a8��~�l3�|�I�9&I H�d>�u#��dj�oIJڟ���,��ο��6~�.�^��1D �Jp�
CO��&�7�>���qSPPPȹx�]�
a3�
z�{)M��+�E��N�莗4��$Jj%��[�@���D2��aKI13��Z�ҡ	{�Z�Kի(v��ם
�/w���b�����`-{�Վ�D�I��Q�tgȵ�5*'!D!k�N;��6S��������mo�MÍ���	���Gq� Mc}�c?U�i�zHQ����K�'p�15F*f�gX�� �X�� ��aiܨ�|hB�ޏ�I�4Q��M��.��q������w\���WM,"�*J��e��Sj��Ѱ�أ�Q��T��`�;�F��8X&�`��ͻ�e����I��.��"�]\�b?�\A\�C�K�����NX4^w�kdr��6r���QA뛝���HyT�-�L�̳Xb���^T�Ψ�8�m8I�,�T�!a�i��{!b�7�F�/M�W8��?��MM��7XQJ�]!�t���em.��<H?mm���R9e���Q�Ґ�ߤ��/��@SPq��J�©  �T�J2��<2�� ��k�ʤ��}QE�b3^I�îPo��J�+��M�f�q�ź�p��@L9
u,�	��Nφ�3��ߕ[�T;֠��+�\P	C��&�"�1k�+�`�����pt
��6����;/��]8~�E�Y3l�K���Z�wA�]ڗa�F�(��G���+�ehL0h���I�t�1OD̃��<�X��<m�����c	u�c��x�rO0�`n�_[��MZ�����R���X.�A�u�<x葉NIe����UU����c`�N�X�D�>F��K��#F��ΓxnH:��&�ݎ/�3i'�^����� �z�_Y�9ʽ�`�Y��{�B,߂bC�Y��:|�k�S�W?ծ�l_��,��}A��g��u�ل[�r+�*Q<�w éLL��o>��2x��v���q�e�nua�����g��O�'�I;��P�ع���7�ǣ�L�2�Ձ"�V�'7�z�$bWw�Mx^Y���
���2�@/٫0.��8�{/·�4�n1 �K�W��["R��=��a譥��T����,:��ڨ�7����Y����f\O&�gƻ�h�l�Dk��?��'��p�n 2�*�MX�h]�"5������"�˛o�C��}
רض�
���qR�����+,nXFR*76�=t&����/[rW������D��(��P�9�9�w��?�"'*{��Ԏ�{�k �WJF�F����=�(t�!P7Oh�H	���:uf��i��S'����Y��ğ�`��P��;�P�*wG�Cz f��>P��I�w";Ug�m��'e�,ߝ)vP/28��u������k�c�Z�Q��ҏ!C}Ǭ�،����H�5�
���P,v�I��9[C�F�F$�
(kR�]sb�*��xc?5|�]9�HĨ���G�6��]�v�l�"�PB�t�b�꣇���J���Hqj�^�%��3��L_x�ڲyOYb�$!��b�9�zp����[U�B�f��v���w�
��ΰ���<�q���gG7�5�K�����wq����*�B��	����Y�����h`W���W*�R���/��L"��X|e�q��\�= �&��U��z�6��QҶ~�|��̕�N{�Q�S5���頣K���5A�oY��r�`($�2�v���+/ã�Y[��R�6�ӽX	�����w�r�%����'�ӷ�ζ��U~�g������b`���-\�D��^�����%SQ��v�nӱ�Ԓ�<�Ө.Yv��hw2��dα?3�����F�&g)Bm���-MI��#>i��J�|Z��O̐�S�k����	���2��h��d%��g�J��'k�l@24u�u����KU���
cr����r�w�[�#�t�4΋e�ж�!� ���5B����=R[��>fTD�a�̖�S�{I�CMJ�!>i��OK��͙���V���Kʡ �����:�KI�(}r��.�F�&�d�H�O�+\����=���e+Ԓ���'��R:�����n�2m��"��h�	��#�!�y�f���J�ƝX'�W�
2�	���w�p�&4��,_��\讏��eRC}�O�P����Uh���� 	boL؉X���jړ�-��,L�1������� ~�^��OL��r�G��k�|5��}N��u���ͦ��_L�֟%6E9�]xs%�n�kN�Y���u�l��W�����	ϙ4TP0�È��?�c��:��?� ���><�F��-���=��M��n�F�L�,-����/�k�eg���GݧD�?PTިJ4�';��]Gʵv��>ه�y|f�Xt&	�}4�'���\`�OB�d	�4�,ez�3�^#�TN�'��1#��E��CњNE#~a�|����4;��L'��d�\�J�p堛=��+�W��Vixo2�V    ;bb��.�fHp8VS@�8=�$�yhQ1�8�i^��1i�b=�:�y�Z�6�2�5�3A9�>��p]ϔ)�G6��Dg��xM~(���}�2|�>���CY�7�4����E��|���
�h����>�2�4���x*�,�Z"��O��d�x`Bnf�mik���:�zF�����O=Pj�槥�n����) }[�����#d9�vPi*M����k�#}+�?�'zΫ��|�K�"$���h���&��,p�F��lA��9i*y�AO��V�������O���G9�����5�ޙ{�`t���$���R�?�����U�����K!�n/��MĴx�K�qF#�-tx,@p��s�t_��0g%o�cO�8��΋��9�F{W��4ߒ�T)�~����rdw��KE+t@��m�����f�]Zx�ڔ�=��QF���WH�^�iO��	���2>��Pn,��*d��Ѐ��!�*G��@3��>V��i�`k�s+��rԍh�����>т����ne��*��t!2���8j���C�B�DMe�^�T��2v���g�]��ó7Bɥ�[N�icv&qD��rw�*v^�~"���Z6�S�h��WG`Ѡ��懋�f��j{�d�i���SI�
�[�3��`w�2�ZA��R�:�p�ƻ�+t�rQ+�c4�IR��]�mf[�ֆ	�qz��G������X�(⦰U#�w�J�`Z1���n��@��}�H���._�$n
���z3M`y'�~uwU��3�6W�m�]^yж��mtz���9�Ǆ�"���D��Go�r?έ	}D�:���U�a�-����s��U��Qyzf�s~���/$��	wA�������kk�ߎ�x�C��s06WKs�+*P�0�#ah���ξ�7�`���'|w�5���C�JCF_hh���9p���r���p���y<SY%C+pA\�{��z�E9��sX��XH���<��g�U�kGoß?��U�UZ��Us3�������^;Mjg�Z G~�4M�W�F���{�)��⮪&�ib�()��b�[�t�ଂ"�M��3\�+�6��H)lp� �E�v���`�4�@N���A�������η�gk0X�L��{LcR�EG��'��}�R�"��5@PDiRJ�A#T?Ђ ���1`l��<��-^Z����B�l��!>{æ�a�\���i��XXG��29s���^��7��T3'�u��u�M�����[��I*�D����ju�'r4�ϵ��KQ�!����8Y�������`Zd������]K�!G���A'B��7OV��Ĭ�z,� 8+��������}ٶ���������}����ٶ������g�{,;�&Ϥ��Ú�]c�1��$s�u�Y�T��:�ň�8�8\��63m�w=X�R�ց#��f�r��R!?<�f�K~XSﺑ�1qr�V�U���5{��
1�.7t�5�tT�8X��k�)6|�{���Qsa��׳���1��>98�qϬ��C�v�?��Й.����ug�{��v��Y�E;KԿv�3�F�	�^iō�K��>�lo/�@--�K_Kb
,��|���{ ����c��5^}��Di᰺߮�)}���	C ��_����`���EVEV�ٛ8p����/�u��<�.���4HDf6��X?��N��7HC6C���7���"7"��i�yDUE��HɁ��T}�u����8*�L��!o�ԕ����Y�^=j)����_�6����M�u��u+)�`ټ*��c�V,��mS���R���u�XB�S� �N�^��G�9D������-um=I>��g2�Ko���_�c]�Pi�h"��ܮ���v��ō��o�C�����ǋ%*�Tn��w~���8%��O���Oo(Qџ}�l��#����%�H�;I��0��k�(�]?z""�X�u��S
�:S�~����3�<Whq�rW�x���D��P)���k�L.�'�C�.����z�J ���$�=֘��[�j1ih�mc��|��2�����d�9f.�3�	=�۲���������ǎ�=�7���k���q����)�����M��+�t��=���.�PQ$�����dΏr��� 9=~���N�:�O�]�E*��p���w��aY�*�9[V*�ʱP4�Z���ˇl��R�^G!Bz�>1#����W�"�{�O|���d�J��س�gVø�k��s�jt۩�D*6��]A������q�Öz�*��'�{�0	t�v���n#S6�ͯx�<1�?[=~�bk��o�m�6 a��(9�����ˢd&:���%�[��@ҡՆ`�X��[ZPHm]o�5Q�	so[E��[�/�%��s0iG�2����@@��]���Ӊ�jXX�;O� �����E���&C}�Lؒ��:��n��8=�&����<|�<�*��ydh����^�\s=�d!����h��1�@<1[��L��~�tWw킱��/!�y��3	
_��� ��v`�����y뗒��n)%n|u�(�������:ʛ��w���8��c 
��S�_�����;fv����Ya:hB�H�mH���.��l=��M��Or鞔X�=���������hs���(�0W�a���ߒc���}h�^jtr����Ɗ���u2�Y�QW������o���@H��{�&���ɳ���.����M�X.Z ��u6,�d/w�}�[`"q�-FmI����)� >l�Ճ9���'nq�'�[��w�l��WD(�Hv�L�ٸ7�e1�e�~,%m�'T%=�=E�T��
9Ƈ~NfV�d��ƪE���(hx+Zx�w�\���xL�e�2цٿ�����)^�M%�J3�zw�e@/�^�.a��� ����훌��s7�T5�e�S�A������S�����8���n�?tES&s�7_�h�\��2c��W*FE�d@;�< �@U<!�8�XSJ�T���d���jl�/�Ї�B/�T�,��U �R�?|�����6t�○�Ů:���1�}�ӧ.tKu��j,:H���
P�vXS�Ww*D��P�伌=�̼�6L��xj��'.g[ ��S|�5��t	���_FyXh5L��m��cz((�v W�oc1�q��,�>i���v��I�n���>Hi ���u쑮M}m����#\\gZ��,X���Vf�Po4_ryo&��M��
��uv�е������m��:9 �>V/�C(�LCEK�ؘ)$��e�6��{&{'D/��I��v�����0i��0��sg���t�WS�?&�P�d���WN�}��M;���G]��i}߬� [�z�
∺�]%��"5��`H���s��kT�=�7��O?�G���i�^����?о�hY�����T,j.�.�j�w;Z��+#>��d+:����M�]Iɐ�q�z�rUDr�����AELSo���FSA7�Y�u��ھ~�kaa�K��ask�!e��iPӖ��+g��ж�{1eh�L�غ�]���G��[9~��J�B2��'���n�J gCM��"$aC�F8�*�0�g_�ƺ	P{RLFӬ�����R-��^��Zh�֠��vƩ"~�b6ظY��]åfC��T�g��6�h]x�TP#�_�ϒ8��S&T�����R̓c�M�C�8�п&�"�p6�B5pgB�֮�bO�j����n+�v�R�}C�IKe�$�[�,2&�-��T��e����UJp��_�6eJ�+I�2�JR���ؗ�̒yO�C���L��$��Mz��aZ�=�KfT�R`	!���'�<~n�MQ9%G��S�ˊ�¬t�:�~���J.�`e�;i��m��ݸҨ�Q�#��}�׆��������F�%e�VYR�.�;��_9R�&I/�k��E��)���"O?v�`���;�B}��E� >�7��FKo5U4����l'��6e�]���l��m�饳7&���u�l���i
g���L�е�,����:0���nR7sxmƴ���r����8�    �h�br��S|��%�o��~qY�<�y��{�(��#<�.Eaie&<
BR�6�*Sw�6���t/�E�O��.naSJiY���"�Ҵ2��~ ��`��?� �8�f$YM��2�E
K�:?�-�k�¾���6 ���������3vs�Gm��k:����mR�)�>n�+'�xa)�z�S��SF������i��)c�����~3�N,� ��`87���,:����{�~s�O=�dǹ�;D�ʫVZ�J1�䷘�fb��f�. ܡ��h22�g�٠xn�vZ����c����^n��p+w:ϑ�����F6�t��`�c��k�ۛ7Nf�m��V�b�.#����(���V+1f]x�vZ���+��j�= G
#�4Dgv@7��c��"_��/j�V�`8=`E�S���cU�>�H�h	<�3�I'S��'y��E��B�/çW��J�q!�w�5P�y ��%��2���v���<�}B�_��5?�;��]�ɂ�g��I� 乹4�BwH��%�o8-��S�&�Za������U�8	�L�O���~َU��(�rP��R^|���>���\�."��9珕m����rUx�^�6g���ch�rP0�`u{�E2�?ǭw�F+�9 �/��%���7A�B�9�\�RR�0\⁛!�ޓ�� ���-2"�
VO��bhɆHIà�jϭ��@���?��1��u�5@��A36|7�A�%�p��>Hv,��Op��F���@\���EȚ��:/�j�k��x�6�(])�x���r�R��;�wL�s�2���@�سr��x�^В��O��n!~s;��\��:e�Bok �&�7�~�9�uѵ��F�a���K�h�0;o5�YJ3�����D��u��(��6�G~5����l��'��f��ޙ�����y�d�}���EE���$�r
�NAl�l�h�P�S�v���+�^�j/&��v�h��v]�AbpT�Hۡ9U�ܑ�kk�.���q� ��lz���X�����Lg���U"^���;K8�A��>��M�A�9��r;L�G�V�@�1�㍷0��S�d��یyҡ��d���%Ň��.�'9mT�G��?�m���Ⱥ�޶H�I��5nj�t�5��|7�IÔ�]2^��ד�M�B���&	��3h�ʃ�jj���<���%���AUS9}	�-~�pQÀr����#�f�	�v?�E�=�fL���I���2@�,���Ib�+U.џ Α�����V�"�{��]IQ�Y���yuƻ�IpޭC��1�v!�4�BC�\�y��o{4�����OZ��׏:}���"���/�v���3�}=�f�ˎ�u���`f?~;[���k�kpׁJ��g�B�9�Dy���B�F��2O�E�>��z-[����A�*��[�YuoN�4���4.��V�{�\+t>8�"�h-�P���Y�H�j:pgd�t�LZ<�#�b�9+4�G�`��$��ݶ�h&Gmõ�@�l���ؐ�t7N��?]��Uh6w��A�5zK-�\ϵ��.�ZPOʩS���qkA��Q�ih=�Ы�0U�[ v���t�=�!�8̜�`�|q74x��G�*sok�(�k�/"������6��O��]�$�\�ko��\}bLO2�O�t,oJ��&o���=[Ɓ�G�YA�V"#{����ޖvX��R";�өn�|���84���>e���~��C;m�y��P�a�Y�d���cު�J>��k����-���\���G�kh�l�����d6Wa_#" ���ȍ�D�ڹ��{�E5rd&?�T�J��q�b]�E�ݱ�J)��uL��X���Շ{��~Jo�~d"
+X{�6�Tʑ+�}N`E���m��Zx�v���U˾��2�R����KY�u����5w�.�{a� �>���~��jiV� �>��8E#�ZOQ'4۠P�Lն���_#T-��Pz�Ҝk�R&�{�l��c7�D�]Ќ�Y�Q�^<��-~���p�����-7�fnW�|�����l�ulw7`f7]Q���̹��oq�qyKr�j�91���!]�9���������l ��T��vJ+�d8�D8��9	�x�^5`%b���s.L�0tHuނ՛]��)h*�m0�F�|�� �d؆1�fv�T�(����f�q��\hǟyn�>^����Ry���醯�b�5"2�v/�{ k?C��O���y���=��R7��8���_V�p�:$s���g ����&������&b���6xNP���m���� 2� ��v�J|�9��>G���.654������5~qk�1�Q�����կ1���"�;p�3ŊD�ARw��1t�6i�'tEdB,�֧�S};?��R<F��9�sKaK��a�C��c��^��
���/����,��w��Y�Ű�ETO7�Z���d&��(�ƙ9��,�C�v+�z�H�x 9�T=����6~���]wa�@yٜ��V�`g�NϽJ�c���6�'���I�PO|�ר��b��u�|kN��/!O�mWQ!��=x�:�Lٶ` �b�S�xˊvb��7?���%
�(�]�u����i�k'G~(��dh��W�s�N�љTN�>�ć�Lv9�@��ߋ���3'*�L������7E�*���5ىN*�A�ܹh��i4��<E�N�U(�-�bD�n��P/Ƒ��s�d����i%g4"K�e#��]�ck#E�?)p33�k�$���6�cA�E'θ�SI�g�a�c�^~e�]s����6r�i��p��������b��n��K���l�κ�$/ԉ�m�6D,��fټ���{q��^2���s��>�:�ɏFt
��%,�v�R����I7�T�!�}NQA%f����rc�3ıP�k�;�������۶�+�G��2�} 6�����y�ѭ~RbA��B�U@���O�`�3��ak����q�|vm��B@��KFR-��z��'�Q��n��w6[Et��_9
���6*����eFV*��B�!�B�͔c?�W	_�A��{-��}��S��
�վ�e��͕��r�����m���T9Z��9����jhnZ�%~�
��m�_)�B�fz�֐�@�S�f|H8�!Pi��.~ƵKU�=�0�D,u��a�6<l���}�~Tb74Qe���@�Q�M�eIA��g˒��!�b���JpÌ_n�lCn��V�N��xC�H�n�.u�h�z�n����L��펛���]?����~�����O���e���v��^2���G�д��s��-c�?Ī5�D֭ފuV��|g�R5��z y2]�5�)�iw�X��,n������d�����&T�1	:�oM[�F=�����~�I�q{Gi�����5Z��Bե@
=�� M���%m�ٽ�U�j����o�ݜz4A�~e��x��	�4;iE�}��6`�o`��n��~g�L����"��Dh��s�d2�,>�?̴��1b�H�
X�6r8��J��<΃�N����2�vG��dV��ņ�b�+F�DFm��_�.^���=Ճ
;\�7R��T�ug&�R%�Ix�m��[g	R� �|'��$d=�$(\m��U�F��o������>�UB?)��H��_��9К�o�0�7�H'i�:��.3�Em4�L�������]�$l�[�bZ?X���:ʉ�JI��� I�6�N��	�QC9D��pޝ6�� �{���X)� �����`���䍛��e�ڥ:&X%�T���z߃��'�lȚj��!���EEp.#�*��z�Ϥ���H�o��w�bJ�˺'������a�V��1܍��Tm1�ob��A��.���6�mR��C�2 U�T���t 1�˟�ǔ_�ˈ��@���f�/VW+���u�I��b�>~�$��=Il8�8��h���kfCR��x��St��A�E?�7�^���.�]�&PK���"l}c�=Rw�9x���3    ���\ 5��<���ｦ�����NQZnZ����Fc<SǸ(�BF�)z�F�<�؝v/q���#�f@��p�3�#&�+-_oM1�@������Jm�¸{W��)��r��e���2�{g��0J�pMa�r�����e���\�fs�6�>ђmʛv��<m��h������H�J龭�<�����6�9K&TI3��KE��n}��e˯Xq�8!T-��n��_J���w7�k\� &*�L�"����<��ګ��!F�(Lō����E�OnY�:4ĬOp^����J*<^�ʔ����'��w���#(JB���\ɓ*n��a�ǈ9��ޱF��ps��i�M�>N�(��}#d�����
 j0�a�^��r�6h�'o���6Ħ?����Y�ASK�vmѸ����������3T����:�a�R�'�,]8u�����@4ʭ%,�Wd&a�׮���C��m��A����!p 3�3�D1�g�2���?�A�vWJpM����{������'	Ro�ĥ�6��+�?ȓ�m6�1��ʛߥ��lAs�X��.���A̯w��m/�A�&��ү��%qh�Ӑ���=�6	�|����-��|z�Y��^�h�-2�t���|�+��T1���m��$,�0�&�j�L@ %^��h�,��)� ��_l�Zy��G��Aua� �ejOoS���=[��G��gJ�����Y��h쇤�.]��Q�Si���Z�3U��}�T�1�d����,�=�G��HFRl	�-m����l��}:���A�ORc��a��cXVS}������^�t�g����m�I�C���/В�.�S��svl��56U�@Ef�l�$7�c�<i�Y.�I�t���	@�H�c�����ͭ��G�N��������j�#,�$[ػ�~�ǋ� �ê��8�^���g���dp��xy��u���^��$j�B�YߎN^����n��SF���L�5:+��v2n���k�b�"���]y�S�>��=��R^w/q�//����t���깨����3�����B3�:m�݋��7_�S��_-Y6uڎ%7n��vsyi�B!���Lh���z���c��1��wc���6�u�;(i<��g����;s����o��[�!u�XZw�oN�P��hg�Λ���:��� ~����S0%7��\t�RrG� �j9�Z$�hӅe�{"�R� ̞>-�
�i6�A�n�F�Xq���*��*A�v��,k���N�%���X���۳zv�"�.j8쵧��eS��ؾ�2y�3����@�sD��$}������♊Ƚ��=�Qf�P]04�� #��N�ݰ+l��]�q���AP�������H�L�c�l_��a�>B��0�Z�ݐ�x�ꊝ��y�B��a"��'+Uf�C�t� �
�U�}�z$�@ق(�t���&�tw]��&6�-�������d�P�i�=�����f{}� ��n����~��"�W�Ύ�"ա�XE�8�l�Mb�����݈�Da�k�ٿ�ic�/���f�'�afk�����g+��ewx�>e-�`v���Y�b�[����������-�ƵK,`�-A���V�g����ųH1l����9K%h�0V�>�
n�ݽD��eDv踞���$a
q$�]�om`tV�?�����V}�W�U��VUfԦ|���݇NKx�a��7}�[)�7��a����^v�r��m��]�S���l�!UG�M��%�nL���[v���쟆0�{x�n�ȫzN;��/:�c��D�LC�m��u����_>̧&ʺ��6? ����?lC�[�Kˀ��X
����������%��W�p�p�/�}�Xe1��1�P6�k�]l�Gm��h�>�9�����0	p��W�Z�`y�q�z;"�0|������c���M�<�{��y܌�5����^��X}wolA��G��#8��>���-�e�/.��(W�(�_�^ ��X��/����}��V"�eaO�/�D���f�т���_�û�f0��Җ�=�_]r+�;���7ם���sԭ����L,����T�_����`�:���]X͂@�B�zaַqb#�3�)�À�'M�y�Ei	��{�M0�S�'�����,	�q�J�[{��z�^�7�B&u�_ظ���s�a1�������ߦ-w�k��߶�vb�.��軭�7�gC<2*���dWr60���>��X�~�ڵ?��Z�i��e�P��m=�z��:���\���.�Z�Γ]\=�FlTq�ITТ����tہo�̗{�V�w��:ۚ6���T���t_ۙk�"���6ի��zר癷�u��x
��5���5��Hq� �\����[����Ն��v&�2cV�e����ȴuC���ƓM|e����Ƒ�6{)6��b�b1�m���Un~�m�w�O�Vgz�����b�^Dy���x/�<"m�¦Z'�ܮ�O�س��qQ�ǒ�3A0giv����y�&�3�������4�q�!��8�f�M�M�e}�����e5Z��,d̀�klr�q`�=�go�?�s�1J�bæ�lY|9��x����y�oC;Տv0Ga��r�VdRm�:���B"Ά��W�F�j'+�>���E��F�����Y�Ӹ��W�;}���D�\'���Vo��`���v�E5���5�(^l���*�,E�瀜��x��  s���č��|F ���,^C�|N����_t%\��G�q4uZR��%N6�vu�ûɴt�h�n�,��{1�~�#6)�b��7�H˩t�o�@Cc���C�D���I4�+�1Ft�i�o}�T�s��;c��2��UL��rL/���{��7��Ρ�X�L�Mdڠ���1�ّ��@J@��F"���HQ��L�q����[�
,ѫ�7	���ӘXmr7Ӱ�䌧���������	Q`����D��J�k�}����N�	��$C4%j�W�r��و_|��|.	U��wF�@r��h>%sI�z�����SN���*�:D�v����Z��OE��Q�_X����tH�~s�Ù*5��4�v���=��A��#�������kF��v�ۋV����˟�5���骂8O*s�����>\6J'�H�,@=�~���iI�"o���>�����1�|g�L�\`�����m���j[���X����Nq֮6�(�[/�!î�8f�}c���!�)W;�F�&7jtC�D�5�l8b�z˾���L��T9��O[#���)5�M�|�F���6�qJm|����mԩ����r�'��m�emK#��F��o�c�Æm��얖�!.�>��Q����SZ�2���؈�e�!'C��Q��S��ɴ�D�6���/q��X���&:*<��E���l�Eφ_����>'1m^bb�D�]�K����.�ٰԼ\b�ԯ\AnK���$�BUI�lHV���`�w߻9���3���RaDJ��2P0?�Q�o�����&�u��]�	�n����>�c���x٠V��}�U���]�ڽ�v�/w��1�w]���~���s������>���i����	�_'�fj�"��Z⋝`�,��J����Dq_:C��q��k��^���ծ��lQ wPĻt�C��mm�:)~8Z��;):�PQ��8�<L�VH��3Vp��>���MrP�=�۽�UM�mWxɷ�����\�R�Pu����Z|�{8����,�"��e��Bt��������X��Cr
��ls�T�ɶ��X�9�e��+�P�%��j\t&�hw�hZt&�K`����}!n���g}	��d�h���k�������?[��:m�i��s��w���e#�q�b�7O���F��̩�ɘDMh��B̀������n[/��"����7���#Z)�U�[��o�����#.�+� ߐ�r�Ϗ
��A�܅BQ�{�����Y�dH5=��{'܃�glV�ŀ�̂n��������TK̀-E�
�Ѵ<�Ww    Tp0��Z�/�Gm�����݆�%0�-�/��߻ɭ�#-��5�0/�n@?�,��z Rz'������Ny�D�hh��6$���,��8}�tIuZ��t��P�ζ�Aç�q�^���(�ن����X�1����ٰ�� ���l��C� �O�=�cO.�}f�>ֶF2��Ij�������*C?}l��m�Ӈ��?�O�۫d�Q�Q�I8���h��v`��Ȃ���a0�E-� �*�~�0 �ؙ��я�&�^��#z�@?�X�Jo��":�Qe+	$!W 
h�����7����~��3��{L��p�:�|�r>QU�DRyA"�_K7/+D�Y��-��_�K�?�hPYM,��A�Q�a�c&W�3��ǡ����IA혎}�Z�P�V��4����.������yf��ܣ��p��wp�mu ��?�9���H ��Bu+y,я�p��P0��e���m� �h�e�-�=������^��=�R��b[���e2SA����_Z	�Y�P�[Ƴ�ˍ���T����y e9�`_Q�Po=Z��V�kka����w5z�H�Yʼ,
i����RDpQD�K��[	���)�3U�ޜ���щ���nX�ڍW�K���mOJ��l��ݫ�?"�w���8��q� �=�A�>�k{N�,O.e�L��.��4�i�,�v�4��D�Y�xSe��Z$o)�ޯ�4���	�7��f6 yC=G�5S�v:3ۋvY*���*�]A9c�&�f4JmW��Ȧn�I��y5aOBdE]�_"�R7 ��b�ǧQX;%��1��(u/)z^yw�(�6J��8�P�g�����ޝ4��羅�O���68Ԫw�m������ۺ�k�Xo�/����[���M��2�����&��yY[�h��]z5Y.�Q��;���{���U�r�F���s�T3V������X3`�T?v�;UJ������B�*�Q!�	���j��3N~����c�/�	�ʚ��oX_�cR���S֒����d*T&��-�CQ�����з�X�Ǧ	h�[h��Qw�b���;�ǌ�����˵G+?��#XƽG���=XxRw������l�j�!�0���K���|�bŠ�h��͒��.�3ꧣe;�7�����w��P#���e^;l!zIZ�v.�C@2� ���	[�g��g�0���6�K�L�qu�ϣ|�x�(K��V�=[b�c�mv�=��Ի�����X�-u�ǻ�D�`��aMT�f#���e"N���u����*��c�g�T�1���ŧ�/a�d�/��v�n���t)yL�5����Hvg��K��<������������[��r.������K(���Nk{�в[�@��P�n]��8X1�n�K5�4f��a��:L!J����(VO5��4~ѿF�þ�)>e���X�wy�b'j[#)������ڠ�K�s��ԕY5H~4�l4��pE��j�3.}��NS�[X���eg����F�,>��o�Ă�|)�㍽�6�����;W'��7��4��߉^��"����I��V��G�OP�$�Ȉc�X����7B|����گ��\��|Mե��h^Z���z�2�L�����e�6'�8��!��bQĲ��)mX�~a�Fu�O��s�NGW>Fd ��`��cr�vU��뗳����]�%��fQ��*4���C�q�1(o�SzQ�ًZ�r�om�:O���a��8������w{(�oYt
��$lo�#7)֥��A(����Dd�~�<'hU�h�=��
�v��v��;7�I�{ɇj�G j������_Lߌ~ׁ�/�TZ����nn�Oj�њc|�.<���$��k�Gr��2N���Lk�	��9��`��t�`��ק�Hc����߭�z��(Y IRZ��cԾ���dՋ�ty��zGyޅy��Yk��"Ӏ��tC�|<�+��&1��#t�<ڮ�f�篐��lh
��Y1�7�A4�ǍN����bQa�&u+����9oH���EzOx�����U2|�]Sf/&1�������+	vOD�jdn������@n#��<�[�L.�O#?�j4�xH��Y��->�9^8�J�vR��=��A�Gtwd!��R0H�k�w=T�0��2�Y����0֋@����n�K�����>�*E0���} �{VCk6q�.���6�&a_��}��5Z�-Z��x���x9����'�-�6�1��ɧņ�8�2ĭ7[�q�s!���~󿪇.Oip�q��A�`l�S�֧�uld�L-��z&���"������U^������Q}a��2R�@þ�+-�[��a��]�-�����oP��F*�6��g���5Q�EZP��s���$���v��X���h��s5�m���l�<�Fo��m�p��n���Ll�{2[�t��2$6/5�/�1o�2��@TA������~]V�Ol��.��xJ��i<E�f�+oFS�Yq�x���F�r4ʙA��h�LTH���F��{m#l� ��@��~^�l���=���N�F|��Jm��X�(�O!�0jG��L��['���9�q�P]����l��6�(A߭��(TMF��-��)ES�R璲J�ha_�/#R�K���nca4]��'`+|b�$���aٟ>p�2UK�	zJ�R��u�O���q�3O�\��õ��&�ƫ�an��{pc�(l��-�`&��}m&��W7 7v���[H�mr�dx��M͡�����!�ȈFE�򃺁#9}��Wk��E͕9m�mfZ�pQo�u�BZ����L8��@�D��A��DÝ�S������{�.2�����{L�o��գ\��t!YG���`�}�,���3�H-�u-T�B�Ӗ���OF�wT���W��J"9��R�k��ޓ�{���*���1/�2��[�	�e�a���"7���+Z_�`����Dz ���ϹL��%�b�.zL�q�$�G��1x���#}�,M��s�$M��-@�Џ�_L���yz!,�����wg����{��4�3�&�*���qk��)�K� g��.[秄�W �w��uBK�=�I�x����,�^P&q�"M�鳉y��D1e��H��a�AYpO��ՠWK��䠃�*����:wyP���uƎ2]tip���]���L��xt��z^˼r����t�N��Э,��V1!}��e��?�	��.���d�-J�Q�Fa��TN�X���~bOd��6N+l�ϰ�� be��!p�n�)�ݗ#'��;�R�uw�֨ }�[|	���R0 2�i�dv��'�?]o:�L����d�TL��a8��)���m�*�w�9�������@�����mu��7�Q
��j�a�����s�1ɵ35 {��7�ER��k�{�h�ʓ�6rj`�?� ��\���Cy�(��!�R�!�B��c?�0>�q\�#p��^��&N�2�h_�/�%*�������z7����Di�q������q���>�Sw߱���H����E!Ɵp�ؑ�Ȱ᳿-[���0��D���_�-E���X�����iC){�����֨Щ;�09��ˣ��Ee]��UJD!�i����e"�3}',5Q��me��-��Ayߢ���&H�&�[�;��ķ�lO?�:�5����V^tB#������TeeZ�&۹�`YA��zY�"�/�o�c)U�jhe+��O��	|��sKv�P�W4��x���wL��{:��z��3�}���l��8�}���e=O��
)�S;>���6\Ñ��_�X���?"R��Z���3��.UI�� g��J1��H">T���h�;��b�o0�O%��HH3�{�-{���~���i���wm +=!jpMj~�v/;Li�)ьڻ
�:�g��vMG�D3*�݁G,��Xs���N��Hr¸R��vݎBk�'���4��,3N�3��@#+�	q��m�G \���`2��\i��?��x�ЦJ��xC���3;�Æ    �����dV�НS4�&$F"[������̨�r�ͧ��f�{�K��B�/z8:��aw���Џ���mC�r{����Q��=��(wj�Z�d ���7iUy�*��1a�zhm�g?��}�Z �sG�z���zuA<,ZR�E��s�-0��2���D�O���pxkA�p��鋯N�M���������:]|Ē:-��05Ѥ&�Z@گ�/.�a�f ���o/7��0�ƎX���8�{0�?˒Le_���\����������)y	H��\J�s�=����g(�}�.�W�'[+��6�|arЗh��wɴ���X���>-�*{�1��ѣQ6� �}��8�^0����8J8,ҟ�DX��(����$ێ�����v����O��U;�4LhV-�6�i����6�R�������)t.�RhK���w��2.��y
�'zU}e�Yj�����1�+���a��8��=m��N�m���,�s�!ؾ�I��ߍ�䔘����4r���
����h���6��H�����Ϛ����Nz�U��v�1�$�t�E���q`���Ek��-U�[{��M���쟸�Ϋ�6��&�Ȱ��:=�Y9P�4��Lg�^�i9����g��,��B霜Me�$�}��(�b�=(�sV���6��v6'��N�Mv�d�	��v�-���L��<�Q��t��{�������ߣ>�Ŵ\Bn>��y�")(�土s�J���?P��=��"m$�"�͋�D�l�[���8!w�-�Y`&��+�U%��f{�]�h����&���-~�?4�G�=���8���s���fq����Y��*����9
!P��= S�&�%~���pw�%�͎d"gʑ�IhqN��]�J�����c)��'��pa�J��Y$l>%U%y�=0�gۈ����S�-��
��	+�i��>G,��k�̝]�,��}�ѳ��>�Ճ���=n���o*��"�e4�\�J��4Q.j󡋓;T�*��V�t/�m5��~��1Г�|���T߲A���))�^m���veyY=W�Kn��ޕG©�h�G��Ä��lU�H���n�?�����l#������=g��7cL�p�S�u��ϛ���&���o��6�#�
�8AQ�ٲ�Р���f�U/)�3��ճi�;M?�����c���ް���߯�$,`�5T��^nI�7��f�L��e��a�-��ME[���޲%ԽUv�%�X[�zD`ݎ|!��"`���eJ��*�h�f�|$"�'�`�eAb�ބNa0�
ɳe}�x'�#.[�a}�冿G�j���p�׎ݶj(������2�'
�r���W<�&�KP�4A���L��zq�_m9ΰ_��4����λ�q�;�������֪,�K�U�����w}M���D��N�Yሽ	RjY_�v+ơ�������Ķ!HԢ( 5r/b�x��ц����^��I�=X�Z�!KN<�OK|�r�OG�l�G��^��]���ErUǿ��y�ʃ�YТ�s)�E��t���\Y�e����'�mŝ�ۂ�ܟ�J	'r���¬�+4xG�0\%/J��1[O�e�W��pX�����s��(�e�v�Ck��ی�h2� ��m���	{Tt;-�TE8���n^�TС��/��j�P��.��;K�ر�^7u�G;��C(�nq�l~T�fs{ ��#�|=�!�'�@Зa�Z�;��{�bn���&��&�K� +L�`�\�kv5Q%Ty�'�j,g�l��&4I�a��i����P���T}�"��-���g�6�
�B�*�?���+��.�Q0@7ad�^���jLE�k���	.������ٺ�x�(D����ݲ�̆k=M�77�D�0��z���-&��lm�b���OBol�ݫn:���0|>�W�O�#Td�ܲ���\C�G.U�w�[',ȼ6,�t\A?Eh��Ǎ�M��aK
F��[�|���֟������Ǥt���@��lia��	������?g㘩�QVYd%�$�.�b|�}�}2� 
�Fȇ�F��-8׀.E�@%�~��+r��Z?>��>8^�m�0A&�շB�j@��
�Zd�)(��BF��U4-��:SO�0�3��؋�Pc&�
S��0lO�r��]�ԇ�B��-���?R".`���O;d��� c���O�]�q�l/����t���yyt}�}ۥm�+2�|����FT�(�)m��/	��j��r�M#VR3�����V�o���m[l��&�lCH�8��e�����1�e0ê�\������;�7�����;������� �����9��H��a{�%���l��訜4�U� 6X��B�bpbq]&إ+���d/�w��:>�j��e�w�_��b"�(�d�У��ņ��b]�v��<�TQ|N�X��Ն��J�;at�jl����:�����f��j���KڏO,��Ϯn� ͆&#%��Z�zC��+����?\��m�N��S�d�ʰ;��x@�'c�J��w�-�f#6��r���\�!e&�R�9�]_�b��R��%�܀���>�!<����#�1|����`�]<p��>R��X����Cǽ��3i;�'���oyS���S2�@]Ll/�	��P���$�Ԁ�n�x���<Nυ�<�y�m��^'��8h;@�K�4z���R�]�<@*`�i��aȒ���ܻ���3�L�
^�&�0c�HFA�FTj�Zׅ��Վ��蔍f^-��
	�P��6�bh_�T��CE����7�v���$���{o������A�ۺEy����0����Y��[S���CT�t�]�ԓ���uL;c2ǚ:Dk�o*�͌��o.2m �y��,6pJ��o��#�S��d�ε�&(磛�Li@
���5@%7�ʽ��̲Oe�%J��-����g�J䑯ϬP����x�N�*��TP��~�x�}�L�'���H��q��J��?���̩���6��&��` �DS���Nܹ'���ڙ���n\@f6-5`�P;�	��C��h����� f�0h�����FJ߇.����m}:���%�<dh�}�n@�,���;%w���ˎ��G Q�u�:�T�CI�����y�l-��h���V�����,8�����&�$rj�v&��DaSa�"F\)�F�j��v� ל�2���f�<��5�;�m��g�m�=�5��lӇ��!�|�6�.����h�r�Y��r���`C���@d�m�51x�k�)�j0�0���H�Z0qwF=b5�v];xp��=u�kK3yWFE�*��0u�o��
�.�L�j���+R=F:��'��/1�zlC6�tA�qW�Aӽ��UH���;T�e#E�|G��ں͆��mGQ|�8j�L����k�N�z������^m�BF�<�3��r����0[��	�R�`�M��B�� \�64�� 'C&�t�E�շ�e�=���iO�b�7�x�a�L��u�_����3.�����$��r1}���T�C�Rp�GtG�F[�\���˹@wj���W=�T��׎i�=޹��&;V�V��דּ�����Mn��b��P	�)u�@MVᶂ�^~/�4y=�7�hj���*��w��6��t �hu�D׽�uA�?�q�"��K�{@o��!��u���Z0��#u�p	�ٯ���<n���A���X����(t�z��[����{�]
Q�PV۶Qu@p���S��X$|ۖ	;���	1b7���U���aY�M�����#'�k+m�]�:�E��e�ǭ>��xr������A���݇��
X����I|�;����Ɇ���Z9a�w�<C3Ǽ���{�ӷm�^RQ(G����f�Ba!������ܽ$ԥҐY��<.?�Z9n&æZ#l�у�sم;�.2@��F"<*�A,����W\T��9�?Lrc��cV��� �ݶhd������Q=����{S��S�E/�YZ�!lj�fE%K.���E���3Jݡ���x�=W�3`�    ��/����W[�J]��K��3U�5�����)�)��u��6�U�w�9 �F7�m��5>�F(l�0<������_��g�h��W����@k@�%S���$f��a.���o�¬OB��DO[l\M�,"6[�:q�@T_����=
��H�m�}J�Q�P���}����� ?E-8s?�Ѱ��0y��g���0���������6S�e.��PZ��9x�[J�M�$�P��y?n`��%�H>��$���?@�/�S�2���8�cԞ�J�Z�j�p�h����)Z'ܷ���� a�No������ۦi7h޷u�nI�G٢n��vy��Nu��ޛv�F}.�n��4h�g�h\4D84Nw���u���9�T��b�����Y;r���o��7{N�^߸+�=�Cı�znО����vn(L���6����e�������k��5���~��>��:�Z��8߶����Qo��_�@r���sZ|r{)C����W��o2ol�"��c��<���eM��j���RP)i�Z|)����6$
�����'SxkC$%?�[���dΉ�@�M;J�O��zG�!�тј﮴Q��dnЖ/��h`��Dg*i\�AXp����C8p���FC����i$/p�;(��A"]%�@Jٍ;g
6����	1���,"עp")�(7�7Հ,�R$O��<˥��y��rkP�8|�?@��di|�6I�S#�dc�g�fY��uݸ������,��uǔ���ԃ���d��5� �X��H[H_4�oG
ځ��$/k{f��d)o\%���ݓ	B��pV �uT�l�Id�A�+X�$������ۢ|����-��'�/���yj��W�%VIv��u�d�W��_�Wz4�3*�F�`�gܓ�l�@ukk���F�#���M0��`��fk2v�7�V�}e6�m���B+��ؼo�~?��"��(�.4�c�����u�<vF(��'�mv��Z�G�~
��^�2�x��>C�1�˴mV�؃&���&���a�[Rv[�i�k�!��x���x�PL�x(k*�ھd�͏��N��㺩�\����=P�r"k���byQ�����`�?H��MP&Byl���߀�EO�\d�xF������3s��6Sd��^���yA�S��R��4̀_t غ�4��D��rN����sw�������'�m��;s�J���!�V����Ć+`���h�b���Q��ie�u�pǠ�^V�L{#�I�e�h����O���R��S�Tm�ql�
��l���z}��R�ϟ�?u�/!2��=p���G��솨��~�t0Fmh�pOww��,�(�5b$p->�&�|�0���}�9(1E2�M�"���pvf�e� $kX���n���7gkL�.�"�$&!ʼx��.dh��f�����B���8wB��ئJj]~�\�U�����7B��$2{ն:z�<j�]��k��FVd���N���P��j@�w�bv��YR��TQ�{^A��5�j��[�Z���߶M@���ŚU	<j���s�T �uUT���~�|<�b�t����q� �� ���9C�sx�{%�޼�K�ڣ���j b�M-�)��U�����3q9_����i�C�p60_y~^n\�[=�
i*S�%v�栆V�3����l���`����<m.�(�?�֘M	BT�5~>����W�LMU"CLg&����{?�������s���?�G���FY�:����mT#���Sꋭڶ���b�_c�)�GF�짛��t��j+�Ro}4�r�]�$5����M�i�� �Is���;ͱY��~��,��IU�	��S�U�4���",[M=v����\�\�~�Y�ﱃ��oy�ճ-vYPS�2��ga�ɲUs�f3�R�2����l��6j����2�W�W����E���b<���_��oV2&���rs؀�>�S�c�_+
ƍM^��шɬwsX��?�V�Æ�e?B��{'��Ӂ��2_{4�RBp'��Vi�Տ`,H�k�w���1��H�������޻�7� �ʊ|G"��ǲ���mB��##um;��c��^�1�.��m��?�M�X/�W�R��ZA]}Qޕ��6�w*�6(Uk������MF�b����J%1B\h�`�b���s�GlQ�j>����3Ə6���j e����J��-��	��fRUcؤz������:�g��S�P�d���&Qm�2�QX������\)��TfR �0�;� h��w� PPG?2��w�m�9����N
�zk�i6���7L}ϰ��T�����:��;mN��-�h�������(��Sܷ,b��)��`�j�1(X��z0�yQ6���~b�`ۅ7�/v��_�h��s��>��|q��M/?�[��!�4�����O�%���V�e����	��6Ɠ���J^�{�����d]8[�ϘRȢhhp�MQ�
�6�0��}:Y2-�#�7�C=V��aZ�L�A{-�9� �!5�hhPE}��\I��z��z�Ƚ�ߩ�a�PY9�cِ I&�ŞC��c2$��4�����W��09��9�96��kT�LaPR3�{�ϛ<���W�4����kG�q���w��(��H���t;!�m���rǕ����7��i|���x*�j��ϣ�g/�{6�#��Y ]}�{�����tb�0E�Q�A�C��|\f�� 	|o�[H͖��0����+4
��)x�u�N��,�Ͱ���Q`��]'�c0~}�� zxG��ڻ���M�⎻������Zo֩�c�5c���Ն> ��z�.P7C�H�q��S�,��-������������(û�����N�A��ڣ�<S���2A���&��-X�ɋ����d~�}O�:~����!������zo�2�g��#��K(C�ܻ���a���� �d�=T��5
(���q�AY��q�K+6P��舯S+F�~�3��W������*�p7Z�T�<��X2��?-����a�)�[=uR��=�[ޡ*����l\}�v�:}�Q�4���4�
E
�J��~V`+^F���]�8�q[]�J�vW�1g�{���ؠ�����,tH	Gi++����-M=ښ��%��xc�G[3ɪ���w	��b�ڛ7m|)A��,D8G{9C�e����������4c�)kV�B����v�7�ۺ<z�9���5B ��{�����e����5�HZ�bf�Nuⰾc��v��>���߾��| Ojps\�εs�l|0��춃������e<;��kRV#��� gP9��4�m)c���)!�c�/+�k�����?ar�EN�j��f�W�*�A����rC�ς��CJt-�+8�7�*c\I�(����zz���8�1w��n�%�5��
(�9���ߡ!/s�Ue��c7A���Y.��C,�箼�_@��+t=�<%�����X�2��_��GN����d�ގ���#b!W����,k�Ň�+�.4q��f����Qb���9mA�?U ^'HjWo��1��T��-y���(*S���&��؇v�����FQ��ۅ���e�N�yr�86���_�e�2�Kֽ]ehk�,>��#���?�&\�S�V,;������y�q~�3,B+2���(9O�K{4��9+�|��[y������;��7H-����BAw/Vx�6<px��CWKT�7O�6lJJ��m�0w}ү�v�ѭ5�+��Q5�qgݛ�)7�"�&���q䗓�xM��(Q���O��@/���N����|�v����X*p��C�x�pb5��8HQva	W��>�LO���㺼q�=X�g�� $�o�-v��siP��+=�(�d=�%IDIQ��N��	sbݕ|n��	�
���]��͇�V1ݝ���ƪ�
Qb\-慲�D�+hx���r2Yz�J�h�;�T��,���K1���J~���6[�q�$�1��hc����W=    �*���I�G��n����:d�!����}$��:���wPNl��u�Z��ef�8�&sH����Cw����0ț(�ƙ�Y��n�\�,6%���PlL�(�ZI���=�!,�	�X��=�B2��mS"a3���<*��
Jܘ�HP�5�\���ȯ]�ZLu�Ob�W��[o��z��ċ�m#����*⬶�܂��t��j[(��u�+��`�T��G3A\PJ|��Xar[�ܖ�'��hg���P��M�F�;���.�ɨ�|�h��Yh�}�U�A�[}g�K��J� ����o�&��Owqe'`���\n����) �e���`:qT_����?��xi@;9�&��	B���FB2&���>�ROtBm�����v|z;�6����:��Kq����@f��>~��ql�n����s���D;Eǔ5��ce�[�
�
�v{?��&��Z����5�=ί+����Op�v�5�ډ��v�΋m�ocK�zt��A�%���?l4;�=�V�8�SnRL �g�;GA���?�Fw*�鿵|q��OUc�@�_��q�:�4�0�.P��jg[�	�<�L��h(�d��Z�iS	ه��={��c�M.D��>c�r��<<D�<�C�0AѴ�T�#�(F]����R��㬰+7E!\�q7�-�6є^���主�s�4}|��o4�`�J�6t��.,�'�@����b�P����O��H{�r������gܭ),EwR6�'��r�2�	��W7=m��p���^����_l/&(Q>e4��_�N���WT��MSV.c�MFy6�E�)�x�w=M���g
"���R����ţ�P�cG'���+�/Х��-���e��,���4��#�-8����7]��b<�����o��Q�G˭FnnIĲ-�I7��ːF�/��% P9�c�K�s��M��#���H�@2U��D'Ǽ�;�ڛf����K�~�4��4�;��G�q,�]�W�x��NP?l,�7��w1_.ǔQ7��aF��:�ݰ&V_� ?�� ��MF�67X�^��$Վ�5-p���w ��k�����蚧I~���;���oS��x�B���b���`s-�����Dn�I�M���a`�+u��q����+^����!��|}<1���o_��/?e��@�_�۴���5�%@�qR��yYML*�d��9��~��ֹkg��,�F��3���華k+a�yF��	��ͦe���5�����/Y���ƧE"t!�{v�)VR��vGM��w-�XԞhǇ(G� �|sk��/@�3����Ѵ$�[�<���\bҀI��]����B85$BʹӍ�Y� ȅ���e�)[9���.Y�Ŭ���J5���Q�n��ǿ��4x*m5AS�xea�)���v�Q�ǆx�_2)��GLG7���@f	x�d�u�(�e7���t��d�s�
�������
?����/�M������Y���DzL��m�~��%��b_ׂ�t�wk+�'J0��6��܍�I��P)��_4��үpx�%Z"��}�PGWxR2�NA���=�K"��7;����e`6va$bO%��K�T����\��%FSX�r��}u�p�j_�z�Z���O�<��P4�g�zK�a�����0�]����h�h4�g�Z��Q�:���m�̡�s���`7Qr�h�XDQ�S�	j%��A�
����!���1�-� p��r~�Z%}�tF�n �=�/��쑕*U��Jfy�i;��a���V�8�#�#�ٳ�]��J&���]$J���V�{ �P�zSXjUJ���I�&�>3FD��MA�Z�1�C\����Yȅj�0/r��K���Ě�"���u��Ţ=~�ϴ�Z�����Z�qϡ!� �R��6h+�.k�0�m�c� {:� D�Z�Ս����J�l%IB��Сr���e��y ��}w����<��h���UT���c1zf�I�T�~n/����NP~Dn0����d/PABx[�Dp��Wy� �F���-P��=8l���:|.�C��b�L�p��p&"1��S��%ȎR�V���������D���(Vկא�,w��+�r��F�}6�M���p���4�?c\%@� @���g�k���Cr��������.�֜W5O;h��_!�!�M����1w�@�M;J��D3�a�ۣ�׮ Um9�e����V��4�S|z�i�g�DЈ����ל�ڭZs�g�I	����0UB��ܦ��8�`e����B��کF�}�-��ļ��� �n�MC>�J�ͭ{z�ު3���`���u����~W�I��Dx]�}�7���f���|�u�[#�S��Ms�H���ˢ��V	�����ݞi$�x��@�(Ο�d�^��C�8���p.����KrUY�����$="�T����M��$z>=�I���rf�UfeUe��?�ݗ��`9��o<J��Le�=_u�]"'���{쒶Fr�@�dZ���[�}��.�D�,�B�m|rӭwl�r+�m]x@�i�X��Nu��-8�J��������[�:_�\4k���V��.pjTqځ,��<����xҬ@�Z�F���6>��%�����&��-�r��$�;����K:i�L�R���/����Dj����V�?���v>�s~�~Sx��������}�g8�,ݝ��:q�U��σIme[�J-U�����a�gv���`U^����HW�vƪ�MPcQ�1��
����v[�c�:av�c���	������XŜe��k�Y�ʊ����=��y�9�������������}��hk�M�ۖ� ��K��%?�<Q�|I�w���v٫K(�ʃcM;(��v�BM=����o��DQ�_>�F�=?�|s͵PG?��V�2��=Wu0�gd��ru.�g���-���^��n�X������\0���RЦ��LT�Svt����
q�v�����D�����x��d������,�=�.m����%F�}m/[��R}��zu�W
��T$����= ��ۅ̠+���I�#�_n+���q��]���m��]������Z;���T�d�m��BE͈"������#�P�����צ�D���s�I;%o�׎Ԏa΁��Y�ӳ!���/UǢ������w=���}���\�g��$��b'$ ��;t}υ��M,���2��U��V�^O?M��y���	�q�m��%$ mA�|( �G�I���J�)qd%�z�Q`_�Jȧ�4�e�}���q���	��i%�p��R�cl�rIs�--l-�"�w]��7�`��Z��N���`�&3�Vg���\���q ���1� ��g��Ŏ�K3��D3����6��ѮE��+Qi����<��'�sY���,Ad��D�}ۻ�n���\��}ݓ������$J>��$.Z�$���qR熬j�m1���S�S	�J���?�DR�+-��-�p��a����$S�~�߳�16����1i#FuZ�
%i�5��57�E�����dU��U��7~��O��i�����5KQ���R�g�^u�/�#e�Á�^�:�"����g�r<V+N�5k�?<���'V�r�<>�*[��Q�C�]\?Ċ�g����u��l���\��ͪ4-��f��\6�;��tS��Z� ds�?�kNr��'5��Թ&^�4�����ԕx��_��]�[���d\��eo�_��cv�ޭ��_�kM��f�&��מk{���^�9�g�/�\TP�-�?(�޸�,��|h��kk���L����"G���ؚ��5���m�T=�4KnH�°t�
��i�Ҍ ��Uezd��|���d%��b|�[�={���E��H,V!���>B,T���'�v���Qwj�W�j���?�c{�K(m=m����V�waUf����oe�e.Lh���uŚ��P�ȡ-�clUaOҚ�AjO�{Uu�]�(U��7'�RޮV�<�-1C�U�+x�e�    V�%|WB��T�����$m <$�a�ZR2�� 1l��_��Ka�K�nj5�M���������A����V��gT�Bo��z4��x�u�8��5$Y���MT�6w����Vdϛ�4�H��)��������I/� ��Ďt
��jiQ�)F���V�������Bbs�e(����a��񭟜W�at�{��s�
�Tx��,�bcD����1��"�ؘB�W�)�<�]���<�R�uE�~����I 似�naC=\��'�LZ[]��I$k_�U��G��1!��uG���ǎܣԼ�:���"ƵO����������{�]q���@� �Z�v�د�38�k��M�r�!�av���)!�1�S�Z��j�=�3�@�����P���o�x�Cƹ�q����)Z�W<?8���)���1i�@t�U(GC%��g�|���*�"ɼ�[��d�jϷu���J��o�|Ñ���Ga?�q+��z<�QP@��q���W��smH����,1)��p��fl�$�[�Ȍ��6�F�9x�L��ƚ�K�\kxw�!��|�i�Zu��/K�h�1K��
�=\������G̃{\q�W���`�j���I��C��飪]_x�������"���vR_��!g���W�|3; ����Y&�/Ã4o�
,@�f�&4h�%`�F���s�&��{��}M�=S�2ע��F��,vD0I�Q�.�s#g3��]��jtrq���oY�3���@�Dˌ]R8cS���0/߆�j~L���7ی��Ԟ�o���<�)�r[�#�5>�s-պ^�>�zn &��a�B������,P?�Q��@�p��]�������l��/��s���
fͥ��\"%�_'>U�u��~��`	Q��y���Y�a��諠��c��wI}k����BT�q>{|�G&�=&b�:��9�G��"�i����:\
�{X%�G/IK�L� �����96����E�_�*A?�kWHt�xiύ��L���緲�|.p�?���h����%S����s1���D���~��@gO�M+�\�J����o��o!ާ��3�*_���a��T;��=Ob�y�ߞ/� ��U;�}��[�_���ص���)���f��o�ṉ'��g�3��z(�%���B�b7��ݯO�˄S���eU-;�3�#���,Fg�c_����dX��֬�/'1g�Q���6�j(O�=QǪH�QHs������X��ar��1v�7.���ᩊ��/%�.|I��v(q���)�D7�?x�qU��+�3�'>�^���^U���1�4|���"/�z�m���/��Lo}CxѴ���[����)k��]�]����H�j���{|Q��m;�ױm����|�c=:N� �9���Lٵ]���d�F�e��+`�&��;y�^M�<�s��(l�h|��B�������*�3�Z���������g�;K���~wF�#F��@ ��]O�H���$��5
�>�hCI4�� �Hܽ.����w? +zK	��w����w��X�6	��ކ���΄���N�Ƈ]��OC��U���eš��X�D�Pm��v�=�
����d��aLP�l�3��v�D����9���HF�5|C��-K��kp
���(ۢ���0�+i�7����?}����f`���ӜK�8��b-z�ǹǈ؄��+е�Dp�7]3P �kk���y������x�Η��)\m���s!0~������sp�W��CA���-ű<�{8�H�(��S����:�T���>V�L'
֖.��g JX=y+Udlj��ݕH��R�x�/�kqߞQ�2�8��'l�a�ϖa�+��%Z�K#媑-v�T��H�j�Ķka�<tNw�7t������md����V퀻�PC��${�����S��w�VV��>���]Ӧ�L�Bx;�[9X�t�[��?����t<uX�{h�
�g�4���݀���(|��j��cG��3WLN(����(]���������iG�����^&�x���4k,)���P)Ƙ��Ce3L��T�==��9�?��G�H�H]��W�Up�1�?j}u�[d�ų6� "=� ���:|WZ؇��ϟ��ׄ�`ߨ��1o%��^ƖC�%�ߛ�
A�Ϧo/�V�j��M�_H�*����I7��4 �c�B��\���챟E����y��}8���>k}Y�Ӓ��h�u�]���Y^�/�*���2�M-�s���p��< ��ᘒ�I�88���@/v�*]/�����%2�+������y�b��eHM�{���`l>>�ޡ��n$�K���+����6�Z�&����n�,�c~�-��d������H�3m'.��[��'��QX��vЎ��yL߶��B�[CS���<d��+��hZ��fUst��	�gK����v�H��߮�\E�ߙ+!���K���Թަ|U���p��L��M���vw�9��}�b��N�"����qv�">�n�6A���ユ�Q]�)z��,Օ@~�+*�:�����v�d;�B8�B�w����҃�R�2��SW�		X�<&S�F�uV13x$\���g�o�T]�ٌ.#x�Ytѹ\���J���+��gC�Ӎ��a�~��3N�����g�>�zڂw�>�+���<|�����K�Zj�jD�[W.{DE��!�(}��?�H3�/�3�T#mS/Q��a5}�p�g����;���p���:B�Ș�ss�U������N�1;��(��!�I��Am����j�sUK���ǣ���yp���ٟ05?y��&�8a�韩�%��������ԡ~����s��K@�D�y��b�ܮ�ID/����<�`�5����Ի��
����ݨ<��J�zf�J�w	�x�j���d44�5��&��<���혿O<��3l���u�n�V��E`l�X���,��aJ�:��^�C�%0q����p����-��U�%�K�Jվ���x�Kuex͙�O嵠0Pk.bE��Ϲ>>d���R
�����6�J�@|��4��)�p?��[k�@��G���an��a�V��e+1)�`�S�ȡqS=yL	2��UŢ��6��w��>?���6���i�ݱ�r%����]M�4�yf����-rk���6o�*ko�f�)�X�г$�!�F����g�*��pW���x>���+�~�+N���\����K�X�*k�1�(vE�+�bӭ'u�����}��.݅����+�ތKl�1�����1�"�^e�x�$l+�{�^��͹����~L�*�]um�w{���~�l������G�w$ݡq�c��C;�[�ss� 2��q��c�&ɤV����$K�����;]�m�n�?rԈ�pय़1��+b�7�2&�?�\�Gt��jp	��%���i �Uu]����?MG����I�j*g�  >c�9���˙�v�� ��!%p̄�oO���#�Β�ǌ�}R ��V
����Dg�o����e���{13�����f�ɞ1ǿ���㏉��8��IY/$�?���\[��:g	��߂,��ϻ7W�өζ糍���ە��i������,S`�"�.�>R����I|��JX�0c\Xjt]���&k�5�r�ŭt�!$�إ�]�^������f�hY���ހ�����t��֌i�϶�,��%�T��"����G��ԑ�z��fh��i�uoѴh���H��W�-`Y� �q��zO�����M��8��U*4��TWD�Yɾ;+�D��`®~�.���x��I6͛��$\dJ��1l���~�����sI�����$�P�m@^@�a!N��\�=q��S �Z� ް���^o��J�߽ڇ���j��w�e{H��z�.u�t���X7rӫ
��l|ң��l�CJjX�(���F�m�[_�/�P̓���W#�k5/3WP�K)���:������>]l�� ��X��W|��س�E    �ï�E� F�ׄ���Ka޵x���O5�1����o����x���:<��:b���{jϒ̍�\g�n���"�o��r���ih�����w�a�0Z�g�g���u��������_�+\	⥃��=�5�ڮ�3{�W�H2�H
�T�H3��2�_�a��{�<��#��+i�(0r2�c7��N��VDa[",��4t����(|�X5.TwR�{��Sa�I�P���ƾ��E�ʝk(��`���c�'Hi�鏞�;X~������G�e�<Wܞ��f�����v��������wn�l��0Ŗ{�T�L6�L��h0!7��>���H��n��V+r��%���ߓ}��4m��H	�=Y��)�P�C�&Ή��<���{��M:X�(]i�q�#>���!�'�_��E�H���c�$͢z
��Aͅ.��44]�~���[M&yԝh���c�t���h�k�	L�g��/Y�=��v������T��rQ:����s�o��=y$�������tFՏ���q!ѕ����O�HZh7�g��A����]���oΎ�����,h8���*�ў�D�K�8_؉�\���x�0�/�W0I?��:Px�B��#��a������#'+�9U�?|����&�y��Y�71q��K��� ��׫< >n~*Z<�Xx�E
��8�g��(���=:}5��F;��� 1���q���nW�>�p ۈ��
0��w���!��a��k��	��GX�o�W�>�����m�{����Խ��n�-)�ZKg?"Y�7�	%�{���8��bN|3��
��޻�����Z���N⾟��?��Za=�(��Tx�6�kz�e�"�xI,I�<*���1�~���^r�O��_%o�AЯ��_i����^������������ή܌s0�*פ��.�E�|�,:�x���@�{C~{���q���IӅ���g�X/���V_/��5�j�\Z�
'��(Q�Q#��H�;��#?�]#��Р��*�wȤ�i��$���6K���M���rw�JCN��g�_��p�;&���a��a��)&z8v;S�b�	qN�P5��^�,Y�h��U���Ԝ��s�O�'��~J�{�/��3��^?�~]����c��]׏��z�r�sM-�U�⾳E��c������Fw����>�[v.E{E)���ѐct��L�k��9_gw��ۮ�v�J������L��`6콽�oS2����� ʙ�_!�\9�#G1�C½�m�g�&u��9s���[�&�왮�ʙ���oJ*P�3����������g�;	�Ʉ�	���_�şMo�Z��i�}���Ԏ�o��<����v(����H���F�ӓo�07O�����e�U0#4g��R���u�3C/ξ�b¦���-G�P0�Z�H�eװ������ ����}T�+�rkx~���V�����a�e�YVVb=�j�횯Uvz��&~�`�L�ӓ2�C]���n;D��� �^CXSY��::W/
�SQ�Ʒv&����o�-F#�&���r��;���#�"k�B�ox����`3q���M���c�C0�� G��<���g��r"�����9��ȗ&^$}Q�0�5zz$Q:ˊ�C���<����4���O2��m��F�8~/
��kobD�m��8������٪/�6<�Lx�7w��×xu-~$�� �E|�w[~)|_�I(�}�o�[.O�7�)���9L�������b�������inͯ��p�^Z�o��FLhzs&����IEs�,VU��*��_�Ҥ&���%֙��^��9G~�c
�kڹ�\$�H��SK�F�)����Ґf�=����V��3p�I��[�Y��?��,n�p?|�X�.�a��7�@	�d؞���ZJ�5���<8����ه��u�n��H��Ӭ�B	.�*b_r(��j��Ù�������o+�B�����U�`>��Ov�xs�kƾ%�aL��wsX<�vZ�,{s���\�n��G{\O1�m�"IE�����S��Ԩ�'���V��#���\w����>�ģ)��4��J�t9&1��,/vB-�(��kL�%���y�!ҖHA5uQ&R�-	�)�~���B�_;�ޭǤ�����\=��m��Pk-e�7�ܰ�z������%}�pP*�"�f�=�!ك�p����sN"q$98��_���`�Duc�#(�w��Ze��}_l�<}�����{.�/-$�v��9�Л`�����d��;đ~��5��x���\Z��W�ݭ��=�r����s]/�^��i��إi����ϵo)-�D���7A:֓*0���֥3�A��C����ٕ��\t����������ʪ��2`��֓݀�e r`��U�����ڲE(�V>O���� ������o�x��}{fc��q�����}���ۯ��?�������~����_����m"ف����ǔ�
���1<���cf_�/�C��ŢY��9��|F�Ve[�&��Y�*��^�fF߲uw�4�;��͗�Yߝ#eE��oH�d�԰��&'�W��I�"O�n����i�m�<���`���1n�!|m�s�Gƭ�� <�"yd����!�W�]�Hc�9�p��납
Q���<1�@k͙�s�#y齩L�D�坱[��u��������������ќj��邳�a�
h��lح�p��� �5ՔE7�&0���np�!'�(������+���1x�
m&�u�pd�e��jF��7�:��.5�|�\&���C��)�.�=uH��UR�DWүwu�zeJ����,�'ɬi������.IZ�h.�C<��LiAo�D�>��,P��8�\H]-���08mQb0Y�:n���O����2A0�\�Ū0�*R��������շ����Y�ap1-xVw�F?x_ک�;�� M}t.�q��]��:-��wj+6]��ÇfJd�.���`P_�N�%>�/�����x����C��;�k�g\�TP���|C����o��*��a��%��hׇD4�.�g�y|H�����~)1�x6N,m7��7R8�g��`����yvE��I���4��.�h���4H�"�����k&%>�$U�vح� ���p�B9�Ҝ-_��eJ$_��9�KIw[��X�M�g��r0p4ؕ�}�Vwz�� :);	��n�����o�աO�٭����LKTOc;���b�B��h�'<�ZJ����k/[3��.�,�C&������G��]��Ÿ6�i���d� �I�o�?v5p$_=^�*t�����dM��#B������^˓��T2�{�~��	95��p�t��&���ٷ��t����X�
�'a��O��lvv�Ղ����~z��`Í����'D.����G������w�p��ܸ:��#z��s4O(�k�0%�����&*?�;�)<��w�Ix�Ty��2����w�ԋ0�'�Q�m�z,��d�e����|/�B���Z�ȉ��~5���pi&���U\����߾�l#�hN]��=��z�]����jG�Y����F/iv,$r>h�5hI�g��0v��O��D'Ϯ�]V/���R��s9�p���J�������`�&�:�@^���$�����zr���ImS}L�e�,E��PX�=��t��QHꧼ�ѕ��>��k��yM ���4j�5�2)R�����Db+>٨C���Aj}Ry��29�]���x�{sq���S���;#��`�� ���Jw����A�����Z�gG#p�7��:��MY�ק��\}��(�e��l���b]�� J]9�ԏ�m��E�d��z�X��-�~�w��� p�{&a�3���	�%���^�Q9�Ar�3IT�D�4���@����!Fe�����Q�ߜa'�e@p�U�d�����va��O�``ƿ�E��b�5|F,��P?M*؝�Z    8f�XB��i�z��!�����H�B̸Y��b�,S��1_\�Xw��n&"�g->�a#�Y��2��'�+�Q�IG�kA�)�OYB�g�dV���'60� �o�p������'�C�&�8JS�����IJ�j�ہx���Q����Ƀ�c�#���E il~������`9�B{�}C�]���2������r�\%6��5�g�����1O?�,'�miO���	ܫ�v%��"���fW��'�|X��h������������;����$�օbݘӰ	F����$R/���`TR*�\?�:C�#�'�n�I�=��/l���=������^��S0�������NK݂��@~��!���/.��/d�H��ó��Jg�����*l�3�=�َg}�K��kX��2�p��x����D���nI�b�C]A{�5�ip�4�6�d�ށ�0�N�ߛ[K�'#iٴ�]&:Bij8<޽ ��j(�K��{Z��}է��~Ϯ%Z+����5\Q�=�&R{�\+]�$��R �xu���orJ���7�;3`�K[�7l��/��a�bx�_����k��X��:V�P�<t�D�/&�?�P��j��o�RQ���n���3��Xj���#?���7�:d:]�0�wPF�3\�C�><��R>��>�ͭ�F% ���*�t�,�D���J�CG]�Q��]\3�͍>B�(ѹ��S�ع�k�����/q���3�j]lw.����;���&��o-|%�5,ati��F	<�E�x-��6f���X/�X���O5_��z�βJ���������>ͣ��D{?����O`�L�+��\u�؏u���XB����K�����嚐x�л�K��s��ѐ��_D<���a�!�)7w\ा\��G��`q���/]-pT�'�F=O�����E�7�W{����V�8�����2���Y�6�����G<�������-�V/���qT0��>`�|�g|��#½������&�/E�ϻ�z�W��/�	�+��~����-�oKq���<��a�c�:z�����܊)���1?��jՓ�F����٩j�_�3���7a���HfI�;�n�j��̋X�m�li8��;���7�k�L��.\��4|�r<V8MwB�@3\e�[����3-��:^�x������q�{��
o�sݵ��	�v�$��k�G�w�<6��!�i�!��?s{oI��K�|���)x�����x���fz�n�}⣾��z�|#��^�����(�S׺,������w��6�M;�8E{��s�A���0�-�/V�v������^z����r��U�TuM�o����M⤛[׾ʣ�IL����7N���ȶ��EY��݅��~>7g��P�#:�����W��v]D��x���5�
�:�h�p��}��R�7��G�W�全9SUA�O��<����7�7d�t�G@a��rܚ��q�9�"���(%N�s��-\Ua@��/���3.h����\��ϯ(e*Ͼ��u\�M�m���<='ڋ�g)�)��ޅ޿�s:A\h}���AS;�m/��vA@����>\e������/�*qv7��*)
Mb;Q'��模0l��o̌������F�jW(�W�.hҒ|�"פD�ǿ�(���u��P.IIѡ�$��QjR�V���^�(.7[�\/I_(��21:k��'Gq���MCn*��Z1Y�@-��2��n�D�����:<�y�D��&���n����<25N'�yX����:
3^�"�$��}�/��`��0Rg��6����M#�N���l]SM�/
���|��&V��l�S���r��J��A��$g�'$�z�������z�oĔx?�/�1J��8<�_��b��^����,�C�I$�؄y�$�d�o�	H6}���}C�,�e���U���r}J��L9ɍ�O�ϖ��zX�s�������0�=�,%@}�ͮ�82�����qł���11Q�S�/@�90P.�p���\�$��VLG�K�q��Wn/�5�ґ�p	"XGl���!��%!,������<��'R��K�*���_ZA�+q"H�o߀����bS\lAI�(a�rv(���n��^��2	�����)�2L�ߴ����:l��2(��s���Y+���x���C�͟t� ��q����%p�ƁS������(4r����"t<��B�?�t?� 'ṙ���H���;�@����T�V߱\ۣ(�P��bM�P���x�yP|�-^J���k�Ԛ����i��m� L�����v�,��.8.j���c��~vɴ���7�
fyQr��ʭ��귽 c��y;(�\)��ͩ���	�{d��2X���k��@Y[�*�0S}�s{����++7㹹�Z�����|�l�K(U柺U�FZ���޶�1�&{-(~�}S��k��%����%V�ǆ*�wZ�g��1M�/����U�&)p욪,` -�vm\�i���E�52<����t�PSt�k��B0�����P�C}{�C^\���G��0����7���Q��IZ�����L���<̱��&�JAxo�?�g�Ц��Q���h�~*�J�D*>h⤤	�M#���X����v�uT�]].4�����i6��"Ma�Q�{�A�{�DĿ�G;����%L��<��n�ݮ5��[
�Nx��Ë]�W��J����V��v�53U�|��B��n���n6e|`�bo=W��L�d��v������p�Ǎ
�}�5��KQ��*F�D���P�fӄ�q�]��a�R	z`���'nt����0�)<:��sƕQImmDd\PdfDo������%/9na�z�V}pb�m��s����>:AK�Z$�8�?�>��O�%0\�1�9ۃgM&z�K�8=�<g��E�c����5Jȝ�}ö0iI�Ep��7Dt��_5<��Wq	;��aX6sk~��Xc ݝ%b�e���ޱ�Ç�pϥ:���T��D(x�f�U:FF�+�1D��:�9;�\˕k*M�qۻ�*`������\�|�vm�5�-v�NZt��89{�P�����4�� ��i:K���-K�K'�����aӆ���q��`�1��c�H�ttɥ�k���Oc������ƭ�@M0�Z�gz�'����1F
�q���n��7i�*��%�W���֚��eh�I����N÷�8���~e�������_��{��EO��ơ;�ڎz��P�15�yW[��k�R�U���l#O�ؿ�F�������.X���%�1���𪃅�mBXo��|у����P��=�ׄ�dMM,o�[�R�/͝h0��?�0mu���·-V�N�Q�<�ʵv�n��z_���r�����|�J�s
_���t�_tiv��_��̵�*5�(ϵ��~j�>f5�8 �7\�Uю������r�i�.x���kU��e��0>_)u=���ʊ\_Hf�4�W!��Dؽv������	�'B��,�^��B�^�O�b���Go|�?3|�b��t]mި��\��ƍN�24('��}�F6���39Z<1����b���J�S��n�5��QwO7@Ww�]��q���¸���6�o��}��89{_�_-���\��^���~�O��c�^����4��n�������E߻Wv"&?��.|���!��V?P�`�[�0fj�@E)��a���o��$��P��k��G���EY��Ñ�US�K���^�lƋ�
�e�1r7�e*�	�C35y츄�{��%�1�c�Nʛ{	�{.b��9:�\��v��J?�H��,"W�Ye����F���O3,�o�5ϗ��8B��[����9�5z|��@}�& ��ڳ� 4��ќ8���؜��*�+w�������������D+��a&�
�L���բ�MRB[�uf<�ؘ�G�3�N�!�oD	����C�0.(s��*6�������E�������O{I�٭���VH�ڽ9����PN[�* �jD�3w	���i.���F"��!�}^�N���"�r�:�D>m��:yv��yZ�G�    �)�qUVH	n�^D��� ^T��;_�Q�><Ӯ�CM;�U��/�p#6���j��9F��s?$���nH��ڐS/����c Z����lYE�lA:j M��m��3֔���ke)/5��|h��i:��C�քd/i�]��#�% ˕	G��d���˄nG�m�kX��s��a1L�z��9�ۿr8�/�%y��J�J<a`z�.
0��T�q�/����j�U��9�y�(�6�g3v����]I֧qy�[e'k�:�Wd���� ��Z�<H$"�F�?��1QslU��35c�f�A]�Ry5�	E�[��B���x��gxT?[��R)�A������p�ڪ��Pج:�ª��PѢ�ov�]������������1��Ŝdv#|s$m�됳�T��=���V��Wܐ����6�����?�ބY��<�ZT[m�J�����;��%����x\�[0^��fr�K�ˇ(�,�s�i�Z�Ak>�����������4�a����T����7�-n�T&���{RL�B����YDds;����A���ђ�ahin�%^g�Ǹ��{�����s�M��z��jv|O���H�a m��J~M�a�f"u�c��LSV�rp�i���`�H� 連��%a�+�����bz�K~&؂��]{�����{f�>PV#��4w������v�^�����g�LK���V�<w���T>�������$ĚۗR@���:�l_�.xn�uskɝ(R<�\w̪�p�2����b;�����>�m���$����Y)5}�:���+�>\�r��";��5c�f�p�dQ���6J�����='�zEQ������A���>QN�Q�gm�����o�!j/�C76���<�����sb�!�2���� >}��Y�������
��%)�]��HMǵ����?��}�D�*�N@�U�fs%E�'E���ސ$ק�`�:�P�}j�X��������L�zNTy�n���]�&Q�BiOqज<�~�5?<�S�ji�$-Jc�U`N���]�G{i�2|��<6Ψ�@"��C�R9����6���`��?��N�`�H����q_�����3p���i�7����"m ��EQ��?��*v��g�/) y������G|���[���/���_�G|�x�WN�:��|𵣼ؕ>�1>�<Q!z\\����<�}$��~\˶�ɕ��z4������H#��5?&'�ₒ�I8�l56�|���x��dcӎ�����gxzM�������i�-$�������@0+~��� ���t`�l'�R��x+5�hmd"f��v���yI��������:xp%L�M��Y�����C�U?��?�8K� >�XCݽ��u�R�+\���|3阰*Y�(ВOV�,H���P#����n��.
�*
�p���ȥҔ<�PM����ƿ�oH��,f�vR���ča�G�97H��k.��[��	r1�]����Ļ�Ya���3��9߄�utX�yW'VS5�}qB-d�7˽��̛9��Ef��7�}���Lv���Z���<�^l�XV X�F�]<)s���R���=kH��//�l�{}���|44o�q;;����s&ʱ�\ |�Eń��_��L��0�a�z��qbs������q���`�@�3���w�`\�����5���~��us����ޡeބ#�V_|w���\��w�3�.����ӆ���aȬzMч����-:��2��nyELS(���0tQd��gV��t)�TK:�c쌾��Ϝ]�=�	> k�P)���z����#gE�k��;7��SٝN�@q5w����u`�70�a�(\y��H���_|�c�<ape`��o'v��{\��!��^x�����L����[Q�I,�;����K4m�.�/�c�E�m'g�7}�;KK}RtJ�oC�ۨ�4��������<I��r��ǰ��v��0T���˹/��!���j������K������qN\�W�SNcVܷ�*�b�p����V���1�c�ܴ���y�u�����8�.{�H�{ou�%E�`+��	���wf��L�_��;;����)�&�I�+G#LC��3�D;9�JB������[e"Nͩ���ų'?������[���;�U�K~hw�&�j�|��[�"�5��%@��q�N�V���^G�X�|�L���j	��yӂ̥*�1G�qߕ�F�*���p9�Ov�`G�↦��z�`��4�^��Kz�jl�iv?����s�}��>F��:L����7�8r`w;N��vfl׽��k��� k��_��{K�p�'Q��o´�ֵ�Õ�Q�#Eł�iC����v��&����7��p�%U�6_1i��z�@��a�X�k��q���9K�Y�f�ߗ�"���϶WQ8'���%N�,��%|p��[�9����x
��,z_�R1K�LĚ�ĀC��Bbn��`,B#��s�!��c�����$��],�)�A����DF��93u�_(F�Fx�L�������Kn�wUIǬ���ܟ}/�	%�PS0~'��
�J�a��W�xE�<,��W*D�|�vN�ޏ�;ù�h=^��	�p�N�<Dy m�������6{������B��`��(��G@t�F�]su~
�)^��Ai
�3��9a�|���1
6r�ܸ�SBso�"<��_(�'��Ew��d�>��>D�2\�.\�M�߇_��H�$��(+�AP�#�0��w��84�����WQ0�\�$�4�ǀ�Pd���b����������j�3a{^��xXb�)ad}�tAX�ݾF`�=Ӷ��9QCR�];L%�Y�\'��4P+1��᣾֏ɼy��l _K����$o���zT��{i�{�wj�0O-%�Quj}��huۉ��$|Ƴ�~��_v��g>>���;�,9��Z�J�%�q0�N(*����+��pe|��5ub���2A�߀p�K���r|�#��d�f��vq��90~��
P��*��Ş"5�����F�rBi�]��靃-�v��}�����4��1�a����X�՛�ƅ۩�~k.���)L^844��s�����p5�'�Q_X|�4��#i7}�LM7�����Ξ+K����G���;3����'
5�ݜ�mX����	�p��Cw�L|�����gj����ʎ$�W���^÷V8�0�W:W�_07�۫����g�7ZԹ�zʀ�����_�;ѹ[��8��K��Û(�+�{H��Y��ק�g��΢G������6��,<����o�,<�L�).#����ID?���9}#�'V|�硟|�Y����J
�@��g����8ڹ�����c7rA<��䋧/bH<U��[mp�\戾lv8�G}6s�LM�{���d{2z~�S��lf���W�$�V���wޱ����$���T3h��s�>��{?,�L3>}�Ӣ��I�5�=�����>�X�O=[�K���g�(f*.C�1l~⨦U��1P3�ꎫoЁ�G<Ik>p���� yqךl��  s$g�V(�\�3�ܧ�[ϷS�Mq/+��}�F#
h�l��̰���o�������/˓�����U��[�.}W�XyW�poo�=�Z�6�\��������u�,:�jk��v~��>�D�x�~c�:{�����B�-n���>��/�H����^;�?vl�И�#�`�[Kڣ̎�v�c�\�D �����׎>Z`�R��:����,|cFU�{}r*#����O�-�>�kt��ff�!����9�k����Q��r/K����b�ُ˰�pd:��)�a��ٞJ����l���\��7�CT�_�2j\��^:��*[r!Q��e�JK�=�.^���_vD�mY���^d`��?�*�;����vr�d�zyg�0Q�>���2S����{;}g<IvYg	b9���S4������S�Nj�bo�3��,U�sG�i=�a,�90f�รxd�$x3gO���r�p�͒ @x�Lņ�    ��&"6���R�X�2] �\գ�L������7QV�_VK�|�����a?�E��-���]p�u�}K<�Z�82���W~�އ\�@�ǽo��덈C�*��K�����+�����Z��/�o��/^��֓��t�-w,���ьvl�cK�ޱ= �%y�d�1J�`�gK$,���9�'Dl���O���6�>��s㜲%�ћ��q.3�w�;�IyR���L��G'y��H�X����x�n'�|�A�a�÷��A��IүL���B-�M�l�Ӯ4�Z��р_	� �F0,����)�C,#��R�u>�7�JI]�y��pX�Nl�
�%��$�5N�� Ibw���R���/�.�y�>�d�,�3�j�j,�9�eƹ,�S��`���yܢ�}ĕ�VcNܱK���7_'<� C�x6���a�ա47��GGce���:���Í�6��硴#H��#Y\��%�u�Aen������.��	����&1�"o8���Q��N��~�Te�����4��]�����Z~(x�H�{O��|=J�/��?��VL8������>����1���W�ktu]L�G�E�/ ��~�{�v\�%H ��� 쇋mъ�D"j�T����i�����@��i liTu}�I�����Z%Ef�7��N\�s�2_��w��
�c�,Qr���A�b:����u�/�
�bi&���ϗ�z��-�<~�(N7���:��]uu/���/�p�*�
p�{0lxou�5�Mu#g�j�즍6{���UvK�s`-��ާ��2:[�>�n�`�_��TFB��Z�.v���g�dfQ���m��x:�������;�2���(rC��ә�m��V��>�&��P2�-r|��l[13L*h��HGq{\*'%��_�c����m��K��v[����� 9��M]뜯�g�µ���N������u<�>��rc�c�&�B����*	�h�[-WG�"7��U�$5�v&i}MTF|��krG��&w��t�P-�5.4���Zo��������n���Ƌ�x}���J��S�n�_<�s5��ztJ���n%��cYD[��4*˃�$��������Aw�S�:;���l
��z(�s�� D��7Z֜}����g˽"ce�o��:�)�9���I�X�7w��b�xKs�/��Ӣ+Kg����� ,K�Er�ݷP���Rv�h��^2��>�F˨��nJ/8���%��軌��J��V$^Kz	���i��05	M�Bi��E{����y�|нA�r�1̀˥�Y��C��+ɤ�ͦp���y�|�}'6e_�^I�����e���Ĥ�:�/M0`������|��U*զ4�a�`��`�|i�ٌ��t�?�S=M�{���p�Ε�򱾝��7D��M86��8s��O��J�?ѩ�i�!'!�+�6Nj�+x��>�8�<�c�}u�itC��kf�Ҍ�q4a��DU(=�d��d��������MR7�ů��K������`XR�w���9����R��֒�t��c���ۦz�ͱ��n�3-ب����WL�?��܃[��{�!Q;׷U1q?;^�ׂ�`�lE�9]����[��^�������JCϻ��Z���#a��ت�9i�m���蠍�?�=�Y�X"Pe�=W��uk�����j�:Sc��mx�>�e��닳E�Jً>Ԓ�����y��z)���W��ip@�WO�c��ݧ���`�b�t#��dR1'��ǧjB1��T��~�zщ�k�΁��%R����X���2z.�n�ӣ�a��`�MH������I�Wp�b����»6�"<��@�8�L��W�^�m4Ž�ʉf}Q
\I�������(���D�3RK6]�_pң{Wy��AJ�N<'�e�Ic��IH�p!7���V<�����SEM��yK��`;��6
_JMDEt�1���oj#:�l���fl}����.��B%x�c&�*��h�p0oT�E`b�{8k�8��D�>��`x�a!�URE���0r@yh |H9ա�7�2�U�e'!P������	c8�>_ ���������@�<��o-��0�ͅ��W���ņOd��>���n_�M-�=�ݐ��-Z���-r�>|��H�揁�<
��̣�hwt�Ɖ��[���4�pS���V�;�0��2��<��E��ъ���s`n_3��0tr�9:f!���n��Uy�۵�]���J�0}�N_��܍�L�O���}[b�v'Q�x�C%ޗ��"">�Z����D�e�;�|{R�!��M�(�i�s�G�BN� |�c����T�%~��ȥ�V��o��U]�Y�>�h�9����R��������Ñ�z��9�4�+��\|ɇ6�+�l;�j���c8آ��Kݻ{V�+X���Z��X���s�J{�P8�ɛ�6�&������_Œq<���pN���\0��	=Y:��E��Ԥ�v`M�#�m-�G���(��^;����`	G��_�̴.���S,O�{�H�$�fQ&y�"��o�c1�TyGF�ڽX������d}�#�H�`a6��uoM����~�W<k'^�(����c�;A���*�Y�t۞�A|�]��,��fwc�.���<>{+L��J
k,s������^2X�k�����ewc7��ܔ�ap)��p�wNd%V��y�1���R��j��0Q�M"H�l�=юL�_V�r���
�o��1�[��G�9�|x%�X5����SX�h1�	w}���C�f�"�P���T?���p,b{W���X�,+� ظ��t�oZ�Ћ����=<fX�F5"Kh�x� bS|r����;�fh%�I88���:���S�`G
���N�Ǻ���ڽba-�!��{��ɼ��:��2��?��Ƭ�H6��U���r(����q��*�0<	L�`�g;��xA2)�H�����f7�����<��gN�)�-��d�ޝ��䳇�=�MW�gg�-�ͭs�\Ǟ�"Z�O��݃R�UdI-8qF\���)4���(}P�^�=��߷GG��]:�JH�X4�ћѣC�F�X%&H�'5��K�;��;i ���Ji	�{�݂C>&e/SB��E�f�b�c�^1���g}L�H�,�G�ќf������G�`7�N͖_T��U���9\\�Fx�)X�NK�N�7�m���hI%��|��N��pp,V���\���b�G�=J�9~� �ҵ�n�,s�h���Nt���a,��y��Zn�Ym��<m�1&J�ȝ>�Di��F�X��m�كS���>u�ݚ��;�N�>�n���#�U7o�����Q�f���B���!��b�*����,�`��l}|r��v�3N��f`�<�Z�C8�"�c��~'8�ӵ���,��:�?��t�-܆�֧��������X�X�0�]�vp�Œ���	��/�7�����ѥ�]!�4΅�_1���8�7��I.�6O�J�c���x�c=��&����$����dҧ�\E�!
�:�B]<�ͯTA�f�ըE7��w*�b�M��+A_C,���^�o�`y�oo����6Ϧ�f{9�[=�G��Z�x8�ü�9K��'QE�i��tB�Z���E�}ߪ��S���3g��'�a�\��d�"��9�ÿ����Z�KM��|_����e�2��Az���X)2�(���T��A�Ϣ���� .��~	�snL�D4/��\�|C59�D�
_���f�b��:V� ��3�i�$�V���L�Sz�05�R��@*:#k��0E�*�&=����$H<�A�@@�%��[8ɝ���*�G{}�r�z��/w�g��_N#J'�v�aT��>7�w��^�a)#	Ë��1F35��oOM�ٴ�4�i�L ��XE�тi�X_M�ف>�sh���_M�[`�_BbUt�w6@{�8�w�l���p�
�\h�D�C�����_-�B~Ķo|X)�B_(W[��K�Ҭ��Ç�cM�5��F˲�Y�j"-9�Y�N�x����Qé�V44�O�����'�V��O}'�{�Տ X    dZ{=d��ɪ�Æ1<�Z��>��6<��ߺg�XN;��:��Z����>�� T�c��yx�^ƶ��y�w�"��f����	��;v<�� L <��6K��:�۫I����$��hG*�H���L��$
�\��������]X�p�/4��~E��k<�>�"�C�}ݲ�@��� ���]��\��.�v��$�U�<�}G�[R��р�>��v\O���M��7:�L�o5?�]j��g��]r�TI3v���y�l�J�֯�"@bDފi�X��W+���ht�33d[
��M���7�it�7�w�E��O縋Ua�Z�.G�U?�8:(c���V2m	�ט��q��\�EO��=|hs�?�J��ŵh���r�?����T̤2vF�-8S���q����;����Ì7�\�\�jGT�{���I��l��d���bw$��1���h���{_�)�6�ޭ}�]���)>`<�/�SCC�ŏ��<\+���ˣ|+g��v���,/�:]�;)a8\4�����S��%/�6���d7ڴ���+�ۅ�_w+�u���&�й�-����O
���&�o�h0T�����#)��"}>�wtL{����y�}�|0f��D�	�]�~���jɩ�/��u����n����z�U�_?��}[��\�n/�-��u�)�G�px��C�YQ�?y�X�=!��	�[�VSЧ�畬�p[ɍ�/p�p��-�����[r����b���w���S)� r�`QVY��xvu����=x��)���D�ui~��B�L|�@�N�A����������<�u��:���ܺ�d'���N�_�]�хb�����מi~ˋ&���m�J2NZ�9"�-��� `�҇�8*{ 7#��N`b��z���b'�������:���Z� �s�ۋ��բh&�>)��9�}bO���	H{𙹡��yAб/�Y��w���1�n��}�x��/m?��l�g��.t,�#>j�U#�^x�-6�l�]�{ԣ���ZHY�S����6hs]�������Ż+|�F���IN����B+y��`�L�]6�,8W`�c�f���-P�B�i�e7����lK���XQ�uu�[��n8�&�~�{8��K��@�s�����������q�(���F*��*4k����eq<�K��ϫ\D�?\p_�U[vHf�)f�0�r��||�K�w�6��������Q���jx7�u�b�E�Ls�(���!�ӏ��{������,�G����
����>�����}�|}�b���>��ϯ2����Vv#�ا�\��ǅ+h�-w��na�/Q�WO{�oa���x#��W��p��]�mYt��-���������W��	S;�e�x�����m���'a�j�o�6����� �1��g����t]�kC�ICb��ч��&�Ծ�g��]� 8�VȻ�,5ف��Z�qVnex����*0�Z�:<�	~�@���l�7S�����l����8d���ͷo�L���YyVG���e��J�Ω�F������/ Z2L�K��B��}�#f��ۊ��c�,Aޖ�)l=�btP�������Rf���PuxÐ��di�v�Ze�H+ۊ���Y~��qUw��<M�oR�U���eJl�}3���0��H�$
�}���6�}>9�-�WGv���������"����ڦ����䎙i���%�b8��)�W���Ib)_�fe[�oK)�>4?�f|�Urj����*��LĤ�7������r~���D���Jʣ=�&ܬ�x����Б'�඘�O�0Gz���g>�Z]#�|�W~Η�O���������t����UJ�EMDA���:�F����L���t�}3Hܘ��g�	@$��� �)���tO�u�^�QХ<���o"g�π6�nK�j�ܲ9��Fs����}�Ƽ0c��v�~|���Bۜ?*8��k`��^�Ix�3#';�Z����\�1{�S�L�\�Y0�v�.;�/CO"��؋�@��Z_�Cx9 �;���"���<54�o���)8V�\� �����A]����6���۳�@�S_u7�R��&.��5��ٕI�g@xFw÷���_�	<�.X=����h���kH'�l��F�&yF3�f�>���Y�ސ&���XS���������~���������<�����\�����*�spx�~�c�?����Ł��}V��U���0{c��
�`��TR|#I/�[=}6�_%��e������ѸP��������]]���`k���G�n��%o�<��[���-�(��n�{} %��l_iUK>����\�$�G[�����������SնVC��m�n�i�!�h��.ީ|/��-�Tt:\Q,�\u����2{N x���/�A�3��#DN�*=,mc���^� �=�R��yj�6��v��Ho��F(��{��$�R�M	�J�po��]r*����p8�5ݪ)!��W�x������I���3��E��?�/��Y� w�2��������)�k@칇���F_�y�����!q9��<����>%����ɠ��pW��(����E��;�\*�>�)U����%�s�i�`vq��Х�hcx´�h���������2�9�o�ʌ6Qś+�l|X %��jP���I%Pp�%� ����_��KN3�-�i1�Ɗ���n�z?��}��s�z��N�k�����X���pZ������Ӱ
��������]%�kX�B�>؎��E���S�"��nͪ��v��Ȇ�T���G�JG�q�o����f�n��Ȑ���9b~3�O��c��uw%����=Z��[�����8`�7�X��ő:2���*_ǒ�"��;��N�,�-Iܴ��T:ia���(RTý�1��0�rѽ5�c<��1x� $O��v�ޱ�u4�</?(�h�q<�����+�K��	�0�Ǳ\i �_�������˷�H�`���Q}�?g�o����L�n%�Þ����w���Z�"F�]���}{�dO��9mm���j��|-�}D�m�[vIذ�h^�h�*�i�C�|9��eߕ��ܥ�h9���Wv?>�d�̑������r���O�j������&Zo'��V��Kj�9��OY�Z��_b��|��y}�������˶>��\r\�W�g��OL��l_%��KX�9V�t@isI���a�M�}�`��o������[��џho�'Ο-EnսX��i �_?��Y��+0�_��+��r�a10����9u��k� -	���@0+_��ך_����Q���I��9&�Y����^���"�=�%f�Uϭp��%v��T�kOɨ�*��p��)�$��̽���?�1l��g}�-׊?���&��i#Kڠ��R��3�}�³�L�P8m�K�6�J:{��<��0�'��K=i��X�q��j9}��Ě�S�����D&�d�!�I�0�U����gz��1�%5�U09��_WT�}��u��ͷsʖ�DZ �����кŞ����Ǭ;�yx'�_I��c���*N�N,蚝A��q���?S-��4ve�'���Px��'��/Jy�����z��&[��q��j쎖�`?�U�m�5P�~�ܬ�W�%�m[U�^�I�ٷ/��$=��L���a"y}��h�y8����1ȏA���K�R͉�Y��=5j���R����x֬�`������]���9�he�a��n��tǼ�O���;GS���N�٬]x����G�8mģe}P�'C��-6�a�ͣ*y[b�ʹ+��侅o2��p4�1* _o��y'2?�ύ
m���_��X�Ѓ�1�T��*�u��2��v�mm��)y�1�Tc˵`�V�:�uvkr�Q��ĢG��ZB�-T��3���x�9��B6'J�?��GM!:<�@�[�[G�x��k�w����߉����������3=˶�	���i��cx����OY*�t�G`���������
v=U��3]���    jtx�Ļ�¢K��w&5���w��2KO����UR<��+���_+S=��`��Z�j�O��Mws�o�k���F����������
�:��l3%7X�_�[m/[m>7�k�e��g�>,�9�|��6����}�p׼ifR:／؂�zQg��D'�bpW?��e��`�*��T��!3=�qq�.&�`�)vv��#��w�R>�'���BLG�wM�N���*�7��%�O�Lrv.c�f�-s���T-��f ��/g߱H�[���u�:�����������vN�J��vΙ���4��Y�Ug���\wqǠ���Uco�C�����돰ں]2x������X��'y�^=�0��O��jZl��5�����T��S�98Z*ԏ��,�l.���G�J��	�3�T��o�Ś��0آG���t�u��ނ>��h|*������bh�ss�aK���h�6vkj���5-u�vno�y�f�'F3f�i���@���H����΃�i�վ7�]8�����w*?A^�����u�$J�N>�(�%x��k��f�>@�mw��*ic����S��;/,f�/�9\u���<��a�3?۱��#ꂅ#\_��Ʃ����~��`�`���t������tlU��7�.V�����䆡Jه�J�8:��_�=p����ŻA��7�囝�<���SD���hn�:��z���hn�(�����B��Z��k^����r�������n��ӻ�~�����˩���ҭu~a���\��At�}��A�y!���f�{Zᛮ67!��"�z��Y2�w�k�`es��
ͰY�x��>�ӊ�p^Ok���-��;�ٟ����������{#T��ۘ��gs4Ⱦg���"6��8_Z��J��#C���+k;�eq���Q����IN���GW㴉�&%oZG��7�^Q�Y����M�7���"zc�O�3r� j7lS3���^�yR�ihgl����D�?xG5'�K�� ד�;?�%����(<h���w����[3<�>��a��{L�t�E��DR;��՚�0���95�g��a����l��<�Z���t`�>�^��@����0��6�����F��һ�1�}�K���6s�@���y���]?h�z���yC�wSF���Y�~�1�j�~����0"��<"��Z�8��gr��X=�6����~��2q�+P��ur�����C!�K��O�s��~���[GK|N�<�V��ǔ:c���o�(a�f�ﻃ���H�����ͶO�S|���F-�~~,NQ|ԅ�q��.�H�x�Q0�ɹI����5���fj.��Jc�_T��s���`2�f�?��� �2�/��߂[��ۋ6|#_|^�^�C)Ij����,�YjsӋ��
�5K�tY�lCl�.:;��fLQZ
�o���ٍ�h�n��<����Ş��3��ޟ����,J�}�iO�`W0���L���F���J���������_i��V��L
�3pN}�� ���U�g}�߾�b��ֽ�c.홑�9������S=�cp*�f�?�)��R�F}L5�Ot@?�z���1�-7a��@u�Z�ᖤ���?�S���N�����ǵT i�[�7Ϗpxi�<s_���,\i ^}D����=i�=@��Zn�!�X��YK�����.vV�]�a�jd�R{�`��(}as�$׆+��l8�jO���BP��|?�6$n#p� �Fv���q���da�(獐7]��d��AV���oή�wn�r����c�9y���R��Y�e�h��R��RB��̉�G���X~��f����PJ,7߄9��f«'�����4?S)�4�O卻<6?9�U��SU> 6&J	�'�Vx?ܝ�c����^|�I�:7������\�K�1���vB����s�O{���~-��0��s}u�h�L��'J�c��!<ņ޹c3Q�#�8�K�������CWԣ��t���ޅ�p�|�Vj/)��I��!Fi��,.d-Ϥ�`]s��%�d.�un�Pu�:����"��l���,�u���X�^�"���I�K�p�a�)h�na$0V����%��O9�Ꮓ5R荥6o�:��[���s&!3��n$/x)�P�8��n���-�x��@������4�}:f(9q{�m�Z4v$P��J:�c� ��J�wL!<[n��+��#�`�E����pvBUD��4KǲA����\�+v0���L��g�Q#�8�`��L��Y_�`|Qy�c�3�Uˋs�=�.�6c �vR�〒�uW�@�W��1��5E�������f������˵���Vb0�f�:��&��7�����q��	���3�ϟ�up��e�g)�ܜ`��`��9b���.�o'�'�_C�-C=�e�HQs��~�ܢ�Hq��_�nY��uNh4�n� �RK��4
mtZ��^V��Ó��M�iT$g�����F�[w�K�l����TR�o����NΩ��ͩ1t8�4�c�� �q�bf�{��dO���}�r���xw6^H��\R[���!E���� �����'�RDG;�BVUֺ����7�+�ɍ��ɥ�8���`�l�F�\C�^MZ%0�ȗK=85�f���po��A��>���>#:^u�X��X��(��=��?��������^M��[~8��h([�\�L:���I����lLȠ��/��}fs�����:�ã�(�l�鐚��
����c���ᒦ��&���@tӏj���%O�*�D�g�/�*�S�a�u (9*q�U��7���$��݆�
��.���G�����l�6�dV7�#���e,���(�T1�^���J���j��E=��%d(�B9��:�e��W�1����aײ�TN��:�;D�k�������ƞ-E��	uP�	,6�f��V�����-x��jvХ��ܸ`"�)��2�Q���~>K��G�����PL����C�'��r�n����l#��aDuG�B"�v�w��H�~�^ ���nb^��j�
�wh�hvo����v�E�tw�g�"IؒdB�������b�,�� v/Rj�'��)���v(�V�gX-���R�Hx�5 ��]���a+a!�=��^�j�G1e����Rץ�<�X��&;Ms�b�_���΅���=��.�Ip���������G�Йy��¨�IjR�6YY�
%�Zõ� 6�+�Yc@\p�W�K�!�.Q-�ai!k��iű�r��s��V������� ��^:Ҙ��P�>)��s�Y�u������ȗ��aWw�Ë\,`k�$�$'՝��P�����j��{�0���u�ߟs��TY����첞�����L������������L6*#����=+�S���Z�g�i�g�H7�I��B������n�n&L���5�����{�r��]z�ù�wZ��eZ�}#o�f���x�8Fm�,�E��$���R��$��6�'\���89j�ѩ$�Z
��?!�������}����:��kFʋ�G
{�̷�7��s�HZyEw� ����v�#��a�_B�^.��-	�/������F:w�)}!7�ا�+��]�buE�����R�$�z�۟���s�"�"�d$$���0��,�Rz���)�p�H�/�F��4L�3|��!7�C�Ң�Ȱ��%��jrN�d"����\�-�as��N>�]�)���I�äą3��ɬ�\$0�3���2�7�-&�༫�i�9߷���|��5��6����-��`��c����7���:�#-�T�dO�����ҩ���+�0�������W�@�{����{56�y�|=K�v�`n�Wg�=t>g9�-\���"	�ެ�&�����+��I���M��m��l���`�&�P�@��B��tBϜ��._I�
���� ;�|���)��91�^3��k���>��s����ˀ��$��PR��w�F�&z��z���    ;���C�Z'���h����#D�.�t�@�6\��C;����Fa��W�	�1��o���l�Z���?�"�w�ǻ~�����Q�!w&�6�f�bi/�tI�6U����viv4���>pղka[��"*s���4�N�U�����o�;8a'	{�>"	蠁]������� �0�f������}
�F,.�o��?���ع�P�Y�`��2�����XN �H�kpx>���
7>4����^�,��7����x:������_ȓ���č��i�����җ��*9r��(�ڰ���3Gl�N����(0j������mc&;qj�`k��'�z�-)N���Fn%�IC��i����~�L�-��r��]_�����8|E�M~$%\�o�ɭ�]j�j0y�iaǒ.��ߠ���H�p����\R蜵�E�E�~ay�P�����yJ��"���烀�G�jNA��UӨ��^�+7vIVY�ל鲱�.���n����n��+f�d��!%��̉L��B�W�(
�k�oئ�k���L���O)������/�X+��t�s~�n��]��{��G� m�հb��n��I��tI��G����ma�v�/�� �fe�V��T^�?�R�`[��{�p���Hn�#��/&  �����n%i�g;�VrFG�z��
ų��x��Ğ��^�vר>6��u@Z�TN��J��0/a���n��V�"�K%��'�<6>�=4d�28�|���@?�<��������Ɣ|dA��3?�:x�Z�����T�Ο�gv7�/�_4��?;�]l�!M�����I)�T~2`��:�b���ZDTx�R�HN9 �4Gԍ�p�=^Ï���v�<��K9�����R����jJ��8n0_X�p�J��E�OJ�B\��.�ڸ��k%�:�����q����eF%,u�6�l�b�L7�̲������d^��RB^���Z�~����,BŻ[����-�WI�Y�����D �N5<6�GZM�2ū>��$��@��~��"�7��2C�;�"	�*$��Sv
L�E�� T��Go�be��UH��@�fw�nm ���6J���4�	ŗO[# ���J�7I��\Q ]��-`�3�!�,L8�(6ĴG��-����(���3inM ��%�3���)��� R.}�u~���ox��I�u��`����|$�(+<`��=8�8"X.�����'�`-7�$2�H7ZVk\�;B��X���~�K$�f}P��W�6Zr��R��L@�'�^�鴃��T�bd��2끽�F*S�gUL�O��|���%��s3�,̟cG�` oƊM���s�2�{C���*�(�T��A߉~e4.X��Un��?�-6kGS�9=�^��CfХCG����Z{ T����y<�4�i,g������Cb����Da��h��2�������q�l�)���	�W8��u�E�:` ���l�c��ca��g{�{(б��t��6�<u�I�-�{ZjW��RZ�nZkיA�K���ʋ 5�kY�P���0��F�%�[ \����i�C7���bV�13���nU� �v6쫑�J�C��l&0�:Ų�<����7n�'72���+U�	}/�Ysd�&�!������}8�V�?�©H-����K���o<��{F,г����+���6,�4p�(�>%�ӿ�1G~k;.������ �	�6���u��B2(�	�]�E��n�b���eR�r���e\�9pQ2?�jM PZP]n$5 �5�]r|�*��2�A)"��%7��r���^��[�M*j`w׌���('J��cAM�RD.(�������#(ߓ �����T�H��w�2�T��*���yt{�:�=7Bӆc>�5�O}u��Q���$Uu��b�8�*|�dO�l-�L�/��Qz��Ҋh�L�����"��&��L�	����ʂ޻�bO�y��a�ao���u�w���_z��=Gf��������������С#7��$��H̳m^f`(]|�ߺ��,'s6���v2gs��ͣ�G��ݖ��ֹ��z� �V�{�� ��|p���?��g9���|�:La/k�WUK���f&S�-}��4l{�Iaa]�肮E�5�fB����3:r��)f��A>a�P���e뒲Y@�,�*��콠c����#SK��+�3u�\��8�����7�F<��{O�H�f�w��9��A��ض�1��n�e>c�_}���I���a�������'W���<��O� �_D�Z�a+E_�~k�R*�PU:��J�؎�S0C;;��v�t��=�y�f��h�&�(�/�?��#u��}i>�;����Ev��%s�e3;��Uj#;�k�'��.S kq���C�n�U�XD-��{�4i�����>�<M��Q���bc�aH|Ӽ]�v�q|�R��4��E�~>�WR��
ݴ�[gf�1�i�zlI�Q;�Q�kg_h?�Dӫ"h;�>�ɋ�����؝�Μ���={4S{>$�4�Ҽk�H�Rt�
3v(p���f��Ѕ9cD�>�R`kWO���SA��۷`uF���1w����N7�h���i�)�N���m��������@~�aGuJ����}�6�y��ؖD�L]7�m�HD�S8��ː� Ę������P/~�gs���W߽&�bo�
Hz���''%�Y�����A�
���O���zO2~v������w��h�i���Y��i�Q�Ōn�d�qs$�	���Ć̮	�f �������z���&��ח%Θ����l-������z�7��~I�����gI��^=����z'Y�i1
�
��<)������k�W����˒R��]$��?ݕ)cpn�;�*S����6+S�{�={f�=頡VQe�#�-\��Wl��f-=��'�r�R-~��O���:�������m�>���y�6�Ie0LG蕵��&��K:�;U�-�?�ñW���������j�b���R�r�/����ܘ��ws=��"�ˮ��%2{�F0W+N�����]Ȳ�]�/���L�����v���@���ΐ�{-}�`�w���À�ri7w��i),��������;(ڱ=k�4�"c��W�����v��5�K�Ҿ��u�RB�I�^�.�Kk<)|p GP�n���B�=��%�C���ܵ��k���"u9
�EEbs�O`)�ĝ�\�9�+�3]ٛ�B�6?A�
������Գ���Sᭃh&H�
'��svM���A��`߶؟�yI;\ߴ�P��2'���~���{�4rɲ�,e�؅@���C�E��Ow�aS�����HC���!��V�hb�.�zH���y��������JiHJLq�5���]���TbAV��5�I
������Nj�Hέ�uB�@��O�5/1��;��Ph�+�{�p6��o*����bB�� J��#���5f		�p�h߶����~E����k:�.��~f�B`�����ck �r��������n�289��������K~*�˘Ϳ�^�y�`��W�z���?�\1��i��v�)�J�|/��.���M�����
�Z�寧CP�o��L���F�]`nݼ�D�KL��?t�u֡��X=�)�U�fܸR2_Ѓ�ܥ�� w�L�� �%�^x��c��G�$'Dz�����	I$��r쪡k�~�y	1���u��p�ƭ{{��!_����xV>�?6;v�<�md�D�0-��U���U+*�g���"��<��pq�����'��P�<���1���3�$�G�{s�9	_C�OВ���G�pO�%%�!9 v�b{��?7��p�( ���L����d$g�{{�(0?�H
�f�^���1�����?H�/��:H��Q�
�,� D7K+��y�>,��2[6^�;��A��T�U?:��٤&����R9��=e"'�,\��9�-"M�$}��~uT$.�Xxx���,F�j�    ��N,�D��������]c�D˦��{ȍ�;o�f�Q.QAq�7{~E�T���( ͈��V��I-?��mT#�?cO;�fW(���&��A��ȋïJ���?��++�U���F:w�A�@hw���FqP)�RI��h;�u�x���B9_wq0�Mt�m��)7=�KIփ�^}���d,�2;���N����35/1\�=	ǃ��������q�����R^s��Q�^���D�a�1��W;=���r��D��笊��$½h��
ù70p�+�=�®^H�a�n��LJ��љ�>3̓��q:[+�+���O���c���߭?/�����Ef��;ֽ���"�
���y��Y�yH'��j2��~�~�{�ɶ�����R�.�+"��)]-��s��;�r����9Ӕ�.�|
�bt�c7BVJ��7�(R��!�7 X* �v���s.��I�rOޕˎ�[�?}\�0�_کkQ,���C˨�gJ2���l��[)��I�I�g�终a��7�(D��I�[�&����3& �$�th��.���L(�o�: ���Q�@�-R�Cb�z�\)2*x�N>(���B9�Ut0}  �wʵ�����*�Y@�SL��C��Q�}V ]ӥ���|�z�S���YX��u�@E7�r&0�1[� �F�����BSD��\)��4A��^�K�N��l2�3�=��%;ݙ�Eewŧ��ͧ^pL��^Scv@ ˂�~'s�w��5��>�K�2H�L��q2�u�~ڱǴ�����S�D7������B�ۼ�{�! LkL����~�_l3z�2���0W�ğ� f�~ZF3��LіW�^̵��* ��[lQ�Q�/*��,EKX�Ջ@��/��o
�Bw0f��6b�
�����k;�m;�8&����`	�ō�#S��v޾��0`q���]  ���z��F�r�����EZ<���5���r|���D�b��Q[�1�bw�སW���[�핇�Ԫ]��F�a���
�si�k�����G8%�A�J�t�3{�;)9�^�����8��9*�����<Dŵ����{�*��%����) ����R����Ԇ`j�d��[�wQ(-��p�bFX�<�SQ?���s���hZ�yj�ϩ�tz���B��m8�6K��拗��T���ߞ�<�2{�%�ϟ�
Wg�*��V��w��r��lv{���]k$����_6-9-��֯T[m� o���.���#�o�țC��"c��s��[ͥ��'Y��A����k!r�}��5�w��������kMRJ哼�i�*+Ƀ����}�붖dyY��0�B���*Dm��u���Yv^[�,������Y�{\�{�+���;��B%fˬt��B�����Y(����ߙ^��"�Z~eaq{����Kc�Α�q��Ҹ��<�k�o�1}�dU�kjYjP�����r/n�8��='������P�,���l�]�׽�$�_،]@ؽ)0_�|*G�]��[�?QAܽ�*S�x�f^V&�����g=��^�j��^���V��z���O(5��.�Q�������1��{uv�����
�L`����V+�°Xl�[g*��Hw��Yf�3n�d*��;I��bQ���-Kf�ۯ��I;�����?��a� ����{��X���4\�?S�|�+��߷�^��vR���w�Q����j�������"���")ԗ	 �xs��~��ꃠ����U<҇�����E%��Q ����)H �����A��O�T&�W�Cw���8Y����5Iq`�%������Z'�$M5�%�����嶵t�H|�ސٲ�좺,C�z��F��I��{?i��f�6�z�L��ܝW�v��v��{�ٹ��^y�dke���u~����{AU绮���S^�㚚l�٫��pX޷K����pZ��?��/j�?h^\��2�|Ͽ*�ꮤ�%�U-�Sǔ�u��?o1�x��ęWm����.۷��A�T?�`��u�,Ê��?�5(s/��/]�,;ȳ;�@ձ��@�e�T�,H(j��_5��6�<@�� +CL"B�RSY1��T��3���L �ʭ=P!�J��0or	��B���}2c�:�Ve;�6��-v��rK;R���D��M��K�>U�"�����w��!�
�e������w*)�~�"1ݭb$��oS���#[�b���<�� @XE- >�n��Մop��P8���(Ĵ&������@WI�Z��`����0�{�����_�O��u��ʮ&n���/QV���"�r�}����D!�w�R��D�t��"�3�\<�ł�c�����~��'���3F-o��qB��A~�b��x-� ?Z"e�ѫ�n�g�H��V��`��{$�4��qϮ�yi��\%��\�|�J��^9^�p��F�>;''�_�\C���(�n.ֿ�ܠ�TU�k��(��-��8�fwp%�;� NR
�־p3:I�/�1�*�Nˎ"Bn���~���s�l��M;
��{-�5P��ɒ�׿���[��+YU�GSs�;�w����'&y��f������7f�.�Ƭ8���mP;����4P��Ĺ�a��ѯU�������9:�S�=R�0lO�d`!C�J��#M�w���UR���8�J*S��[�.t�Y��I�^?Vh�5�7�^�]��B�����e7i�ؗv�|��E5z�NT�6�n�m�@��7�u��:���O]���d^��3g����y\1a��A����l]��S�Fm<������i���nGET��]<Q��I�|`)��A�@Y�B`R%w;j�Q�r�#:��L$F��v����7��t�"<h�t�����Ӫ��\��#7x�}?�熮4�P�ksDz��N�*ho�>�r#��k{�-��Vxb�@k�77�}��������$v�����9�:�b��l@�8��0���W��b�qZ�U�ZJ��'�$L��e���UdWp��Iu����SfZ���_��q������w�;��v�����٤����wG�S_(�����e��1�g ����C<ЮZN}���~���p�u�
h�V`┫���c��Ω��Z��psNI��x=p?|�������JL��o@����Ȼ��G��m�����@�cw��yD���2X��B����:⍷��<뼶ีn�E^�ܸX8�\p�.imM�u���-���=3lIH��p���H���E���1 �F�Z�5�����Z:���Jhb[qi����aVT�[-�6SӜ�6R%i�/�!�f�H};�S��ڸ�Q�G��ZX�C���k~jV��o�Ԇ{���x	�S8�FJF�(v P՞^�T��^��@`�^u��Cw�`U��,{�
VK6#�4(�\��H����%�X�7xzjo���I�or�-��b �(�&^��:�[A�)���ޯ�#��
���5P���~��S��`�m�N]9>�kX8X�Q��c�D�&G�jSmߣ��sVk��}�J��_��M����]k�.s�#8dQmE!��+��mwU�x�ɽ�W��x!��T���sC��E�q��v{v?�֋��y�,K�m6� ?�;�&��(���vn��ܩ�������e���t�`�M�N�D�w^.�}p�C\��w����V�E�"�{�������L�khw�V$����W?�����M�*�{�r"���x�~O���s��6>�Ē��E�#��=�f�?{��L�ٽ��(�������1��t�u�0$����z����������\�#�k��WΜ����ƙdI���1�T�I���-h������c�0��Z$�BG�+�H&�ɔB v�0ҍ~lrGx��%-�%v�fw��a/�T���Se���+���|=�:��2w�KJ�p�k�¯�/�v!�sk^����~�\��-]�A���?V��`�,��Ji��b��}�?!L�}C�.{��������Zu8��+!����o7V	?�	���q0�WN�����z�@���e��X�<� x?�|���{     q�-��s�m�Egulp�l���W�[f���^���dR���.-�#Q����|�RM��������D���Zx����c�drw�H���hY����٩@6�вF��R�;��&����e�U˪����/�Vj�`��.�6l��n�@�ٻ��(ۮD�E��[nOŔ�&˾�v��R �k�%C��d�L ��u�<q?^M�a�0�Z�d�Ӫ+ѐ��	�~=�0�>�����x�
��1��Fz�*�(}���οV�{��o�b�ָ��:)����, ��wT�qU����G��~t��x�K�� �'6�h'�Uqܵ1���� *������P���X�� r`��2'�<���ާ'�"05��Dw,�f/��������kd���d����y�&v
P��{��qXeIw���y�jm�?,��͊Cz�ؘ�<Y����'�S�$5�{�Nۨr�Ug�Na�[x��h�be弑eu�K/����x�l�lp�Ť����sn��B�V����`�h�@v�����51���<��Bi4���Z>6�ML-�� ?rw+I"!��f��b�H7��������G�:XQ���K?��Մv��g����hD{w��9�����-\��B��qK
��N%�8,.�i���o�����)61��v	k��gL�'oƅ��6h�����I`�_JӰ�\/�1z��m�9��H�j�7�&��<�(YP8��&+~U���E�%Gf�����b�b��7-=�^�I��?Ë��&�%S`���
��Z�X�x�����3���hVN���?�w�g��K������~�z�����~,���m�r�0s����T&om����h���v2�;Cô?u:a��F
�r(��?��ʹ���_�V����"�ϟ��	���|#Q���>��9)#��D
u4��F%��P�BR�b���se0֡��m[w?��T�-jŢ`2�vnǕ�7:���@k���O
_���K�J>�Bo<VS�]2&��흀�B�LÏ���{]+���������Lu2��dO��Lu�;�ё��~��h���i��Kl%2-�+1��Ak���~c&~1�p��L�%ܫ�#HUw���/{J��*w���c������x7�O���(^#ݗ�X-�}E��!%��.�>�yxF�Bie����J2�����)�����_��a���cKq?�:]� W�*�]�{��%K��1W����9����}�:O�|ߋ�Gl����v�ܻ����vLK�J�=��v����9�V[��V[={p9�?�R^��<��/�~�Fo�%������&#��J��;��Mc��]8����y�jz%e�i��}����,�m	�S,�G���g2��}�w��/����1?��;šē�iM��0z�L{ �t��a�z@K}��>�����a����E��Ѵ���2��/V���_���	V���7���U����DVlL�I?�-�!F59w� 4��k��蠋H���u���3�0��HY?�Rb��J�X�O�]d~��y�|.�N���=�C4���̴��F����q������~�)@Q����c14c�����A�5��Q;��ն�`d �R���}��Ny�q�uۑ�Pa�;:1&p'ΜX{|�e�8�ˇn���Ȝ���TO}��]���3f�li?�W	H���]�>��qi=ma-m�UְS"1@%���l�Cv�x�m�� T4�C!ţ�#�y�vi��'9�
��d^`v��T�����-l˗(j�d}ԫ�7B�mώ�5���>����W����E�<�ԏ����6�L7Z��)���}��Z����������v`rz�
�y��X�`D��k���-��=z�r:�B�<�O!ȴ�a���F�\���i�]��%�h�2>�I�c;�w��T|�Xs� YTE�w��<C�Tĉ�*cT�8���۽��Sx��H�s�_��)�~��*�i8�w���'�7���]p΅Xm������O�.��!ҽ�;p�U���ϸ\�{����S��{z**�3Ϗ������8n�O�����{=I*Z�L���3�˃w�����Q\u��1�qʸ����T���
N�w#��`«]��rw��J��������0��.�Z���k4�U��G���P�2$�s��-t������&&��$��D�ʨ+���3㟽�/�V��lB;�ߥzs=:Jp����gf�D�c��5��i���nm!��r�<��pYA0�@��9f ����mme�Q4�Q�T��x\�#�EH�������%�\���8��cʵ5}@ZeQ=��gk;~�T�9,���s���9�3��/7	s�G����<�1�q�� �f�s��4�\H�SS���BR��������WJ�{�ϑd9�ۧh���W�u>m���\�������dceF.,����0uۤ�������4j����()rg�U3�Z��R��L;%Ԣ���t+z���I�&
�c������j<�h�l�v�n�P���)zư��\D)M��fq�e��1gu�Pu6���C��]�Ju����g!�����$Cxr��Ҽ��-a�C�Ƴ�m�#[�g�L�������Ϙ���j��r_�����p0ڭI�P��p�G9ʧ?��J���nVI����C��`V���%�aD=���أ@�$Zx={܉L��#/Β ����v(�V*�*�>��B&йiՅ�"	���:�_~t�^;����6&<����
`�z6�p��E�D>�t����t���):5K�O[�E0o���2�d�A7�:S�0��"���bU����d��:�q��>�S�n��b�$IX����X*�?�]���e���ܡ<���-�\%���"���=���nm��w��W��e$�{��ѿߑ�r?,s�s��۽��ɟ��}�JΗN���}˻Ф./�V�og���sۼKH�����2z{h�=����e�~�'�Q����2e�'��V�w����j��b�� �V��poeb��
�1gs�T�b����,��/��c��xy�ګ'������	fɧ-���];�C��w�R��i��G��lXwf��!2�O��AO����e�6�8\K��� �bV5���o74�O
�G��k,���T���wf���H��m�ض/����,A�y�e�~īo�:�VmsR+���+����S��o�o�P���[�=}�o?�ݨD'<��Ev���9/��&�P�ib� ������ey�~���o"���_:�i6���A�+��Oӓ�� x� M�5�-�p5��=��������[t�*wL[����vb���Cx��4�h@�*��_nX,J&��o�����c�mp�U�,,�]�ѲXnO,���X�ò�0�7�D�67Ӣ �|��sq�s��Q�;���T�h�U~fR]E�n�TG��[�(=jN��eW�^GV���I�o<a�tPr��6!��O������+�hM��Zs���� ����- �(dz>*���~[��Q�7M����-��2i�yʘ��K��~�4o��+�Oo�k�E����?��hey�A���U]�BG��d0Q.`y�@��<UY�6�ă�3�ᨿi( �v���{q��S�Seo;~�	�S7I��/%Ya��]{ݛj�f\q;��F��ϡY���� c,����^-u�@��������*�в���V)���)N�+������@!��S�\��ʓ�6�OU���0w3�sy�}�>ǎ3x��4�}�}�خ]��Gk)s�O���5����Y	S�l����߽{^�%c�y�ýVS}(�
�ؙ}�ؠ���O���-ퟶ��OI�`�мͅCV�<��f.�+�� �?�j���2¥׬:iv D��N�uZ)�m�U�'��~�IN{��k�쟧�����ʴ3}oOw"?�����~����r��/y�Y����쑱~x����~ �'ǿ��_����Et�g�}���ir��\��/,T�+l��Y��y��P?R���E
�G'k�(�    ������������qJ����w�����h=Q���,g?��T�-��F�Y��&��/gJ��#��u��r�&q�����������1�"ĉ�,TŐ���|���A�P���%����3���Z� �q���C�% ܘ�N3��P&�oD`ۣ:M��(VRC���Rн�&MG�����*3�q}�G�n����؞ip����c�l�N�^���s�������ex`c��Xeͤ<v~��}�åƾ���Ꝼ)��9��6�1w�͵�{Zai�v�c�i��Tw����~�x�T��Q8�$� p3��0ZhRi��z�v���|׼���pW��=]�h_I�����K�����	���_n-)$��:7)�3�@)'����V�h�Ed�u�Y���G8g�� Yϟ��β��;[�F��ge/ �); @i�}ͣ��U�c��!�Ƌ�����q���� �q��$
w��zQ�G�aE&ݱey��뢛`ϋx]�����|cp���%�a���}3��E%&�c�0�/$���ZbtH�(B�"����%�P9�i-����X��$���q��a��#_�h���j��7' /���9j��dsl�l�r����hQV�W�O�����n��`o�e^i�8����nY���&t���砏s?^� �^����]TL�3�o��߈D����(7�ݔ�0]�Ǉg�> W�j��]K����s ׶D���>E�*|���� ���_(�RX�^9��f37\�c��	�c��r��ݸӒ��>�	`o�'Z����a���[����qn��nH����1�(��.�!�t͖i����A���w
�Te�'p��R�.��I^��E��˽��M�G"��%<>(k�܆�j�[���,��*�<�!�����>T��V�m�����T�t��V"2n	�;��4�{��N�=�%�<�ܰ�:H�(�0���ނ��UՀJ����!����jR#P��p2b@��s��W�d�	T@���%{�e�l��<�Eyn��&mc�``T��C�jǎIa�l�̐]ڛ1zH�jˆ���B�J�v�'��J������!,�����~���z���L*�wB��C�{I�Ҡu�o�hi݅����E�Ykx�������?��O�����iE���pO县����!ӬԂE%!�0~(5����i�P�<J�_'���/�}jq�$G)�:����c -���tQ��٨�i �~�ˍ�'1�~��v'�rG�Zn��m��Zv��	�����',2�|��s
{�P`.��tE�l��-٢�s#f���$]�^S�ђiTC�sr��/W~�e��6�ue��+�l{<&)�[8҂J���_;cc��KOo V���[�~G~��*q��
�E�w��Ӛz����w����9��nt뗫��[h���n��۷��l>X����c��ɹ�5���7*��t-�^���g�1I�ƾ�km�}sOr�X�	||�i#�&��~�Y��:{#I�cM�S,���`�贂^��9,d����$Sׇk��~����������k1g��*�g�j�TX��e��07:��'���OT����LЁ+!}J9�����]\��+?�g��X�n��NJ�4�zT���6�j�w����H����ǭ�ŗӝk�ѽ_F�4�m<;���h��c��pJ�/���
��`�����*��r��ܩ�QΑ�$��ք����7�_wr��m?{�к__� ��t��&<����y��kX[չ*��Ϲ�"��,�OL�����1�hW{�-��K�v�slA53���%�+Ρ� VI�����l�^��a������i�?�b��Nw�Q�(�8n�r�]�/��\��m��/fgx;���V�E����$�}xl8��o�����|Gp�$ג�&�����I�r�+S�H�L<����nV���UI@I�*�9���9&	�����T�.9��׊d�t���R{_�IKV� ̮\(N�w�yZ�SB�*��YN��BH�o'��s�E�/�P7��}tݐn����;���#-�׶%iu����Ùxh�{t��?����2��H-Q>����s��6��(p�p��=�ɻ10�-����g�{�m\Kt�g����Eje�(����o΁,�lދ��ߏ�̶�7���hVʶ�}�-�h8����f�n�Zm�n[�w�4J$%Wf�uG�`?!8`ݑ�� bM��+�Z,I�xq`f�Y��=g}4t��\��0�����C�%2��4_���H��z�b���J�_�܊V�B����}�-ұ6��h�f�p���8�F�<�����`�����2ٚ��ƪu��^�'d��Od�����]Z���R<
f����D����Y�I^H�{Z�Gm��b� �V^�_%���agpi3y}���ȅ���O]�LYOdi�S&!�Z��M�*S�[~�i��y���r��@-����52ZȂKDO1.����CH�m`�R}^b��~����;G�k�=ŏ�U���bgĊ�/���� ���:�Z��kA��M�J����]FX~ȇ�Ғ�¤�l� \�?����L���t�-	^Z]��_���BJ�;���Gđ)^�_�0߈|���Q����,-������8��]���lK�%j���Y�vJ��_�mw᫙A��՜�ξ֢�>q��*5��Z��h�c����~��%���_-_�Nj �v�e6�ōT��b�ǋy�W����R��
��4���ңp��!>t0���$j)��T�b6;h� !!c�������;:�bM���-޿V�����P��f�l;�oA������sXeњ 歊�S�Z����ߺ�y9���/aV�ICriц4�m�a-Hᙙ�>v��8��%-�`W���n��GnG A��>}D��glX*]�m�u�����R~/|L?��9�����)wB�����t%��5Ǥ�"Z��y9s?B�/�&�ޱ�ݗ~�H <��[�I�AM�e@��M�x��ͦm�Z0�%��^J�s0��h���\{h%2)k��1�Os��<n��Ha�<�;�T~��m��4��;���Ɲ���~�6�܏C���$tc��A;Œ(��Y��w�x5\{%�EZ�؜K��G?hw���.�:��w�߈����=���� �9e�{������"�n�Zf��\���m�s�U����/��&�ov��t{G#˻yZ��lc�?�&ˏF��r��܁J�����e��_=�Y����3/7t�VBL�m���X���N}l;���R�]�����b�T�7c�X"I�^i}���5/�9&�hɻ��[K��"I����I�v��[0��6�K.���n�Rq�[��We \$�	4��?�L�Qr��y��"m�Ѳ�7��}���yH�w�$���Q:�t(�t�~j6�nac�����Y_H��v��&�`5�`�{zQ�lk��M%H�nMTe�����SU��YL����#o�!�{�#:˥���9�c���b���V)V�+*�b]�k��}��R\W�ny�
�r��}�|�2|�/��D��{S���:P�����
��\C)ʅv��*����Olh�'��[P+�$�ի�]�_I��51��c �4�ș46����_�
��;���+�������N�Ż�ľ�.��� �bG�� ��7)n���h� ���D�Nw�UqT�]���*���\���__�i���c�!'A^��y��o�����ÆQy�H"To�v��#����&R7s���T�g���Q��\�=	k��8b�*�Гq' N#mvw �(N9�1ls0�e��E�ɷ>��(&��\Md�G�GCc���g�)�Q�;��	�9F���`��~��g���ң`�2�PT
�u5����D��AT��͟ ��Y��k-g ����<Aȭ�v��Y��2�W�1G�5P���7��ӝ�r7tC��]@��~t��7^�)�S��-=8]��?T��	���,
b%{o���Vv�+���U��)���    "����e�L����6i� �YU۲p�#�dG��cn�Ė6�ck��oN^�|�o�}��a��k�e�|-d����\�K���X샕����ܜE�Q�13���<�W�9ʌx�4W���{2j�9��k�퟾{�U����1 ��-e$��Fw��m�9�g�V��(�@ƚ�^4��+Zvz�>\?`�.�̻�3�V��|�2�ލ3�|�W��v�$~}��]1��q�{;��i}Q$��
���6�ݩFg�����nog+z t���)��5}���$�U�4Wz�@��	EA|���r��Vt��<��+|U�e���@�L������_���_��,��o��/�iF�ku0wh���m�����Wފ�@��/\���4�h�\׸E`�,j�k�G�L��k�o\��g6�{�1r}��ᾆn�1t�2�? ���/s���� ,t���ko�{bq���#�0����	E;�"z��\&���0�)ua6R;���e�?�a$]i�E�)H��H̦�~���1���z4��/��L�/ۙl�XO�Kv�D��.Ϩ����-Cb�f+��G�ql�-��6�ب>G�ʍ���'�Ӏ�!�^�P�+ �Xt�o�����;OD*
.���&�P��UI����r[b���5+Ar
���c�]��v�?DfZ�}��P#9�����z)�)�R�h����nto�
�X9���=����[
�?_� ����Yi, 3s�17�ÚH��^��ߒ�x��-����s�߳�
	��k�	��� 
ć��FBP�e1��[|�@.��h�s�sK��%ܗ�w�f	tW��ݥƷ�s��O{4ἴ R9���v.b�Jkl~B�-�s~�m����6{<�r��ӯ�ZpndR�>i���5��;�����i�/E�wL݆���+����PEA�c��q���ofE�X}�l����42�N.�Z�@�Rxj��?�ɼ�m���O�?�R�>�x457`�y��nM�Fr��`�]\V�9�X�6o������O%���7��n9������I��6ђ��a���;�L���t�~���ۂw֘r�J�K;a�g�mᄆ��E�5%��=	�����*�R�|���OG�B���0iؑI�{�v܏���`!�X�|�S��پ<�}u���[�_C��n�,��9�|�5���Ko�#�)�,t=�ւ��Mxؗ��$!ٰ�ī�������;+%��}���ۜ@(��?òi)z �������IG��Լ��i�|jVo����EY}��]��x�)��%t�ނ�[yU��8��}7[��z�~�!P�	���`M{=�	����f�=e� 
����/�����h�����x�\�i4d,ٚ���W����e�Gs嵍�駌\����/��L��
�Hq���>fmΤ�mz����L�sapfNV̚�ŕtc��׈3o���!��6(�)�B6�pF����^ ���@�r���͍��5���@;���az~��X-�d��ҰQ]�}��]	PcN �rdiX?��0v��o�)��,��!m4�&u� ]s��qh�=�"��'c����;�#���� �U����e����;��I���|��E��,�A� �� �n>/�.U��	�>�Ez��'�r�����	�s����`�kԞ{3*�B��m���Q��� ��[��q�5�5����u�=ۊcihʸ�K0�e�̔�c7���{*�fB@O�ܻN#�D�\��lw?~f6�.�|!��_h��c�ҝ�tC-�b�3�P�H�6 �Q�	����u�o�7����?]�`���XdV���]�I��pP�`�?,��[���~��,������c�v�(筪�b�OY��6?RX�,L���S�Cg=�8��6v���9;/��Sd�:��^�o�sQh賔#T���n�L��ڇ~Q@��{Q�՜����^0�O��r��
���G)Y��ơ��lG����<��V0Q�bI|��r 4��o�EW�i��ml`���X�	�fF���Տ}��k�>�T�@�nVK��������)��KOsbTRьy�#�`j���su��m���a3/���d����17�m:�4�����Њ�ptu��������6��M�� �N�۠,�/�ޏ�L}¶��q��Hţ��;���8}�C�j�&�=�؁h	vEO�S,"G�T@�Ԑ��G����'1q����9l�dj�$�ئg彷;��1�/pp;�D1_8���v�r)�J`�E1y�M9� �V�w0mM���������7����Tx�qf��qq�|Ps����/���]zm
&����S����d���s��`�^�1���5ߙ��V^H�L1_��a=o�����O_���J��ea�Tc��|(�c��*9����|�dS�U=��}_j���y��"��˃��|��S2o7����X7ʇ�����b(\�o�D�5�ހ,�|	��2���ظ��"f^��*����=,���2�N)�i�L���s,܅�ECYh�|C�ʣ���E��.X�Tyܓ������uja~��nJ4_�+�b7�)��5�$UF���"@���{��7�4n������q+`�pl�I���g�U�v�S^ ����
wg^;��kT�E��.�RTkB�xt(������(�X�Q<rE�F+۶Q����"c3�pӻ�{�̾��nW��;�L���ӊ��j�Ҍ�=4�?��]ӿ���,I�YX��JO�T��?���̲�.h�%�$�O��֠��+�,y_F��F�J�'��ueڗ����F�4��u����J��As���]����!�Lo'���#���'�uf��2X����{�1��o�S� �,���V
��⺆�^�T $-�`޴��0��o��a- �s�yR������k�:�jg�}���>�SIW�IL'\�{���䢍#Q�i��{�VVq a��C��Y/N~�������Q�ϰ����f��m1=�n�nw�u��<��*�WRص}� S�Z�����s��͂��3���Q
����JL�'!K�촧�fOdr�����O�j���S�ogט�������c��.��_ȽRk��mo���c3u�����w��{UԅyS�ᆲ���Xz�rc(0�]�$\��>���-�b���~�5�����r�L����U ,����~Q�%U�$|�{e��w��Ne��N/E$����/�P2��2�ec�9cUS0w�d2���d 'Wǩ���<�H���c1�*'�_6�}�W�>0�]�y��� 2���������G�����/��";�������w�-�m�A�I�W���L�ُ5��]pqU���J��{�T�8��`$_u�u�qwE�l|<�i��8�Y�%���X�*$�W�B �.ˍ"���}����jR�+&��҃
����Y�㭎��c��#��YU���/���û���[9:9�*3a�p]��p��b�=���*3o����s89vE���ЩL����ifR��.?*:���+��i��(�t�W�/)�c�$���~)!��*���0<S�b��Yژ�~�\\8�N����3%���?��j':Z����A��p�l���Ʌ ���`6�H�d��~:�G���V!;Ѿ��]Ern��v��܋��ਉe�-���S?� �h�&��˒��txj!*i3�Elb�/�zCG��Mp��@�6 �M+6�ZO��(9)�	�L[xP�
N�(%9x�z�@����$���%���6c��i_�&+��������c�e�/s��W�T�CAy��s-k-�Ѫ`�`˽C��&��0jYRˏxi�8 ��37"򠼚����~�BN�����m��]M����f#[�:*u��FĒ����FR{�[?� �=�\�� �i�=�������`�KBќ4�1X9]7�t82��?X�'f!�yZ��-���r�h,=6˱�f��N�X��d�{V����!Va	��vl\���]OQ(�v�Suz�    7>�w�8�����3V���^�a��vԞL�7��K�Tzo��>� ��X�B��\��h%�?ȣ��{�݃{��k�>��s\�nt�[�����p��&ŋ�i�m'�w�2+�E�`���q��3���X	`�3ӄ�cp	2j]oD�N�;�t����v_��g��6�FΝkŠ`�`�w-p�^kOYc�/�\;�uCL6�\�)��8�h�]،r���5Ña+�6��� ��|�mC�X��)�c���Uu�/���y7f����\��}l`��������5Y�R�2�Zu� �A�k�b�a��������(1����i� ��3%}�����A�H׺�L���_|X]d�] ��5��c�#�����u�궉17��Ժ�k�mr]�F�b˴�S�2_���na���v�|k1��TV}��0�(j?��-�@�=�ء�_[;	s�_9��÷�v��Hј�܆�Z��E"�睼�.W��Ё����PD*�wk��:�/O#�u Qz��e�@D`��@D.N�<��s�if��{�}�T�Ap��ʕ�y��燭P&�����s��ܗ��W8����c|� r?8��L]L�D:ߵ�鋌&Яv��|����q�$�4߉�|�M4����|1�����������W�0NL���\��{��:Or �m@gA�^�G�ׄt/�u�h�m�$�'����_-�:�,���տ�V��e>w1�3@�xQ�.ޤ�B0��.��#�����0c��s����e� ��H�g�q� އK"}���i�qK�1=������We����v��L�ۼ�cc�ر�4�����ď��K�5�H�c�41~�=YL�i�� eV[����W!�U�m�^���C�6�!�W:�vpՇ����wR��&����!�}�8�����q�ثc�BE������v^��'��s7��v���ZB"�[��(9UKd�q�3�%�k`tE�Q�+�Sʴ�L��<?t�c�a�~ ��Wp�f�����(SQ��ŨN[�h#m�`��x1�"c@@�>w�� 1G_�ѐߦA}Xb/>�g}d�{8��ްtS��<��# Z\�!|��X���3s\��=��ܰ�ܷL���%*B;�?qiNɥV�ͣ�3��v�>M53A��4W���u��j�f��U�{_r�������֑ �2\�H0����4�}~�^�����
�G������3�@�Rtc�@�=V@�5�.�����2Y���hNy��x�l��VO�[��Ox�������2�����xa�K��c��o�|E�e�<�b�=�
�d�_]`$���V�Ѐ�Vs�M�+,��Ң���i��ͧ���ݯ�w\���k�����ٜLW�B@��2'����,<�V� "kso�~;�cn�sŬe���UN#]t"�?Y�;Xpxf�p}��9���l^%�m�I3��/�͍7�Q���ͣ��e���[ gz���� _�p����J�/��g���X����Y?S�*`���韬L8դX�ͱ����ңS��E�
=?��53�I�����w͡�@S��|�l~U��&� �nkdd�=7� B�F�F�zl����#�l�jB����P*p����S����p��y��7Ʋ%1&�q7L�3�)��?�[��|����9$�������e'�aj�k����#�A~�R_��h��|`Mn�(Z�V��1��Cs��}{|?x�~�ul"�~�$���YoM��,WG�!�nO�Ic:^Q��f^��:J''�0��]$�X4zL�sˬ��撤L��]I�塁颵%ގM|��u���e[ڟ���A�`b��5�=�į�9~\�Wl��X�6d��J�r��Z��أPcU����^�����"�Qf'�E7�(�uMV��ϫ+��g�<纤����.*��1b[����o�?����.-6��������	��*�;�*}�^V��t�Sm!ۢ�Q k,�2�����'����kX@�E�?�+ �\W";
���?̟��w�t׺?�V�lW0��P�Í��͍"V@� WIaD7��˼�=�O'zd���m�g���1^�
 ���8��4�{ɔF{1���3P�%��J㾞�.����H����R��X�i������P�]
���N��I^�L�O�X��[�ޙ۟eљ�{	I���^-nտ�+)ɽ���_�̊q�2�#tc��>�w���p���J�t�/T�^)��c�MN���~�y�|C�`�4����`v,�z��Ô?y?I�#�ޘ�鴴�~o�q���5f��H�ƍ������J�'ha�vvm�p8��n �ٴa�p�F'L���m��f����ޢ�g�Rh)I4��g�y�w�:��~ԌF��ZM�(����c0�~�Y���Qd���������q��p�~�|��j�v�'��O�dI)9��k%��uo�?��]�ȍNd}J�RSY��������Mv��#��`q�X�v/$�A�Y�+<e7����'r�?tfgEU�d�ݽ���a����0B�;4qL��� ����7���)x�i��ޥ��pbV�*�퍬\2�(��vIy�;|���[6.S�}|J�/;�n_1�5��Dp����輛�O����Ť�!�<CPy\��ѧ�L�?j�s�id�F-8?��Q3���%몟/���%��t_��n��\ykJ#���i��`WS��~#j)����#{
�M�i�á��G���-���e�k���%���a���~ٝ�j��Q�'��V �(�{�p]?�1�G�zGm*@���cvj@+ۛ(�{V�7�b���s�c�e*@]�=�/pY��K����s��Q��]���܂f73��=�P�X��a��?
s%<���#3C>fxв�H����DU-7�<	�Z��m�u7aބp����ܢg_91�(�Z��)�й�vcgٽNWt#�������n���} n|t"P�.n�o��L ��7�=t�����ޓ0T7�م�X�����~�]K��r{ҡ��Y��5RV�`o�*��|�ힽ���A�;j��`�<�x��Ѵ�Go�ھn��"1�$�ۣ��ʄZ��L\���l~�)�t>�:��H�q��*j�f(r\�Z�p�[2�݂hd�@��)罢���,m�#��po��J �W�'�Kc�ƣ����J���Bx
I�?�	f\��:��{Ԧ�1\��S�{��J���~��<�,LT2�`+]�
���y"o7�g�W�r��-�,,�$QS~de�=ƍ��p6w��n �Ȍ)��	~�ƚ���f_ � -(�ۈ��>�pįzO��P���:�� �;p�[��>�h@r���}�*��`����3�H����Uv���
Ю��@�y�_2O��=b�1Q����O�������|�й/�7�p��p�9��a����_�E���s�NεE_¶��c׎?r����Q��X'�Knܴ�2�*i�A9%�l]�~����2O�6~���x���&~$ k�W'ќ� >��>G@�რ�۟�w ��H��y�L�)_�aBȘ����6;���)\8.ݿ�-z�3�n��������=0n�R��.��Ők"����u�Md���������-3�
-�?3�켱z���#MT��6�{s��a����+mo�[x���|��#7O)/=6������+c��E�S��i\G���Cૅ߯Q��y�ܨyN�����|gUV�;6��,�����Լ>t̺�.���ت�A�Y�j�<A��A�&�r��H�IY��2"x�I�UZ�	���W7^�M��x~��ebr<��2v]d�C⢑q�
�����d�$�5\/ft��"�5\�	�FL��7��L��c5���Ĵ���5����y��t�[�y��cs����x
�C&�3��g�ed����7�kR5��T�9��Y��OW�N����)63�n��/�4�i�<z�y��f�:��O��n�e�+!d���~']xӆ�ܧX�f@?�Se��{_(X��a��TGp�w�    �t���M�6Z�yW��-�!|��
����T-,�o�o] _m�����<����[��ڂ���G�@9�Q�E;��t�h�`Q�!�@c��nd�����Rg���]c�iybd��`س�:\H������-�A#bQ���~��C���ru-����t���un,���8ذ����	�
��2f�e}���{-ˌ���>��ܲ�^��e�=c�}j?6&Z���KF�4F���4p%�8��ؗ��M3cB]Z��S�?a�а�1�A}��v�,h�cf���4t��ql�}l�hR�'�(:tዺ����w�G��ώR�c�w]��_A�D�*d���A�cȂ��!=���O����$�t����/����]V�dyď[�~�Y��������]�E)��-�6��C��0��DF�:�U�<4-����ȔgLЛ0/0Z&��8��pĹ$�~����2��9;��V��f����i����e��V�!��,�`Ψ��SMc̈?�A9�6�ŗyy�I�}B;�x����G��挳Y�+�*u�����`�L���b�vL���/�T�]ҏ怇Z)w�+���Ȓ��\�E��K���L��<E9l��
�o��v���1��ǔ1y�-����L�/�= y�ۥ�P���X�t�k����Q��=	�9|`\Y����`�P��g3��؈[;]��bJ��������^���G��E{���`H��=ܱ��R��ނa�hӱ�A~nh����_83���*�TL��=mL�~��rʟ$��a��ˆm)��s�v0gU��̥����|����E*�N�=�٢E�?�8��G8�����#��mQӵ��n��T�Ғ�`�e;pȧ�݈o��ׇgE-����`%.�G�4����ʐ��{�U��j�oѸ~1��}O����:����e�}�`���K;��ua���B���x.�OP�cRʟU���;i^�D����6�SU��cꭢ�{ˍD�i�@��,���-���A�~��/�3Eߩd<h6
�O�e�z��i%u��]��W;�+h@
�?�);'1��p��)��D1ݏ59�5V��?t�V+���:?�z�\��J�x{�O��0��J��bs�6����}Y�aW
��������ä��@*%�_�n���p��rf�Y��qs㼊Bǟ(���S�!�[LA����ߢJ��e��������0s��b�G<G�g;]й:��!��\$~}l��yTr�m��7֗f��4	�5&	v�΍���G����W`l�S�gw�F�h��'�~�D�;���<pZ<�`�v�l>R�<�s��eo\��i/+�B����S���Y��2�f��X(���mm5���əޗ��ګ��e��~,0����{��x�D���4s��#�·l O�R[����)�p��W@�ĸ�朐��7���!�x�������c�+����U�|�앞D�r��K�v�BT#���'\��1j�.��J�j0�
#N����m���,(Ж���H�#o������G;�}���}b��ʽ��̗&���L1#ojl�S49�J�ŋ��V���JS�h�Ao��{����=�_:]��n������J�0{}�y��@p+�����^�����;�/������M�g�������W����"P������� ԗ�xe��}l����H)!���OFHq�4T;,��"���';V��
{�\��-��]H�Ą�����Ӯ��J�����ktTR`������G:�߱�QK�9�V(��k��h��`?�4'�V�����G�k�R|��̄�y�G��_Q�25�7V[�ޟ��� �7u��5r�:LG]x��m����LkI'�N�o�y���C9���4��L2�.�$��4Ied~K;t�o�*#'��=��4�Sz�E��;5@1�R�� �|Ot�F���F�D2��z~���0�k׸�_����j'�*;�e��wX�O�	�ԋ�Nti�ᷴP�w1L�'*��7W$|���!���\u�?G}x��8Xюu�_�&8����*����T�I���3��G];�Й�Wt�r�6|�F*���q��?�o�Ìkm�� ~0]}�3�
�Ƙ���}d��O]�T���S�J���j3����Otyh]�`SMP%�Ȥ��RYfp�L�l���2�����z�������'Q*
B���K�,�?e+�۵?w�[	�6�w1[-\zQ�&�.i�-QP���ʈ�}����}+!vk-:n+���!`%��v���<3"nG�V�(rݲ����um%'��5庴R1KǺ��:�1/��A����O�*E���?�1��uF#����lO��"a
�c�?�B��W��?�]���'�.V�x��yA}��s���&���8�(�vi�%K?�����$58IJ����(�	���K�d) l
9k?~��l�8+8S&��R���.�N��G�K# �UVcX���2�~����$��{Ui-ԢXch���}�2�����ˮ���~�|��,��]��,��E�Ѵ�-]�Q��2����s��U��>Zʾ��J���`w�-X�3�ճ+�S�vuK�cvL�u�Ne?���7�S���R� 8�Mu�{P����W+������!���'�9����y������%|P̟m���0`3��_�� �\d�k ���1>�xst�#{�Q�6�ٛ�F���^٫���זv�I�H�O��x��+m��6j� J� t��M�4�������1�k��i�͘��(�U����w��t��Ƣ\E���B\�v�m�~���Xt�2[d�{�h,�5-)��i�ᛡ�	�0_��	��yG^�� C��w��Ò]�����Jv
�@\��`Z�.�ҹ�J�	�������Vƈ_�"o��R���W�7���pu�E�����ຎ����/.�F���0�� ��qoC䙱�P��T�J}Q�rk�%?����o�����������a�4En�߆�LL�9(��H'�u��$N�?c�=ei�������˲W@�+��L�����WfOVH�ٚ��?��Oex�^2.܏lvd�3➰|�
��Cp �8��nO4�c�Ŵ=�ig,��0Ӻ�vC��B�R�=�2�У�,�(��&���Z �ı�^��YQ��7��ٚ��:/5N��,�Z�^k�
�_��ƻ��w��/�6�V{D�2����;�	~XEa�����i߶�,��}+>�����c�������/�Wm$D�ߚz��իg:I��T�j��}�j���8��d��U|b�K������y�{�1+���߻��fX��Y��x��c�<����'����9A���s�/��ة�s����?�� @�8%]m_@�7DB�U��L� ��z类|��I�����*}�\1�F���Q�N��@�r1�#���l�������Οd��*\��h&�#�~18*л?��u���&MsLA4A����w�gv}�<J�<"t�(4l�uܶ�Nݾ $l��4̠Z�A��y��'�C�t�Qm�c�P��I<�5�TN<���2L���R�J��C�Q`K���t�;7,ߠ��;�J��޹Ψ]�Qw��z�ʨF�p�Awb@id�к���A��@|(��3i<�_�Q7��;��;'9���iD��z{*�<�(�o����Y���-z��3IJGU!���l|��'�3�@�� �H����`bR
��΁rZ�8n��\F���Cy�HOR��="��C=�r�ZŮ<{�'x�|v߀Λ�\�����Pż`GRy��H��)�>a��Ut��/�74� I��Չ��q�ô^��&��B���ا	�_ q��v������G���8zt���+��2�������>���]�>5M��'x�>7m;g�)S�����B7Q�]4/t� ������Ysn��j��61m�/b}���|`AdL�,3�%��(��/�耔���J`h�X�ƫ}���I�Np��.���,晤���,���m��Bb����H�E��/�Q�y'�qJ�d�_�����F2�H���Oɡ�    ��7������J+��d�k �2���@�vĜ�%ث��_JDE�d܃!c�@�vY�W���hB��gv�yRN�J�#@k����F�[��ҡ��3��C����Z!��ob��}j�� B��M�����Y��L��'?�����K��&Z����o-<p�=<��V$d��M�����Y�)&��|4+** �**�1��
�x	�~���;i���ʝ���G�J|��T�{CG`�9H Xt�/-�\W��>�oԢv��'����%����$�Q��J/��v�%�8��%ib���0���p�_R[8p���җ�� Nٸ�B�����xX���Q	8ݿr.�AI���Mr��ٳ�g%H�}+NN�v�7*	�X�Z0`�0�3�7�¿�Q2=@�w����	p��s�;v{�#(I��˼|�{P�c�8��䰡��c��iV&bI��VV��IOo��6$�o�t|�&�BÊ��:�Ԝ)�UZ�OfT�uQx.���m�JY1����+��a��}�� 'I�r�b�f ԡ��O���f!(�i��|� e�:���L��lo�@�]y��R36w����k߾cs�4���	��4re����66b)P�Q��4/b]��qd��0�ȅ���+���%D�HN&��D� /���1��_�� (��B�8��f����}w� Ļ�]$UL�_��jN���r:-X�A0������GgH-3Q"s��sWk ��H��H���9x��˼* tV%����1(]vJ�;ep*�)��-�S���iW��$'"F�[}� -���J.q�/P򳕜��:��;����*T�{�Ta�Fm�S����T�_�.ռ<�����2\�+H����a�vh���]��m��� �����h���M�P��0ЃZ����N;���`=6R��|[����`id�>wx�g���n�4����좹ol~��M��w��c�v����`�%�[o���O"G��X���8����~���=6Ҷ#� �Q^�G�Ͻ��(QR�}�j�2��= j�/����ŭ��g#�< 0�X�r�-�ۀ$�����O�A^�J��Ae�������e�l����e�����\r���8�s�V2l0��Oi�F��~p�Xп��쒸�AGּy���恋�4��8�!��ڇ�:�)E����%I�$�ϸ����5��Z�r���y�ӵ��_>��������Bc���E�Sg��#�g���?�0��t:�ќz�Zݓ`�I,���}�ѫX��Ȩ@���[�Cr,��ӏ�~�C���v"CpoN�؋�"�Z��;ԇ�W���?<Q�dpd)�v���@�Rm����ׯ�[�E����OzD?Y�R�9s�a����>^���Qʹ!���e2OX�$�3N�s��Tm`�>����R�jF�T���H�qOpgS��j(Y��'�D��O�:sLA��a%lDP<8����i��.HG�n���r|�Y��ˬ:��萯� w�*`�R3�gJ����|3�����4:�j�0
����yjG�U�go��%�3�B��A�f�<�6x�Z�X_w�zs�� =�\f�̿>��.� � �|yG�U��!#Alp`�������W��f�����> ��z�ߜ��9���ކ�n�@�'8o�װC��\O?=�>�O�΂sK�ͼ{̼��$mV5�3Y�k���Zg����=���ݤ��IĜN�O���{�Ӎ���{��{��C�}�K_��	�|���<*�QE�!bn�� �|(؋���;�ȣ�ai]�R{�a_9_A�0�0:~�N%7�����#ҽu��Dm~RED;]�]g��^K����L�4u�Z ���ߍvJ��kK�� ��C��-����6.�������t=�C�@����]����٥]|������u�tq��m�����w���fh ���y�m�ց��/p����/]E�0��G��}dqqq���{�Z-�Z�$�ƹ#��Zp)���~�H��[��6O���"����I�Z7oNL����/Tm�}�nɗ�s��M#��[V��'� I�Μg�;2و���!���������l���	��E���߂+���n^{nx�.����o]��,�Z��nk��0B#7����԰���W�ik=������>����^(�����m"�?�F�7:�����m�D�Qtg����ͫ_��|��	K��uF�H��	<��o?�k�����)$xY�N����є4G_���!�8�5B�� r�#._����A1��A�&�����8���Mք���^�O�!��v�I��A� boކ�k -۷#[�+HJ�'	#q��q@�N�;>�	�52��235W��7j����{>���o�H�ȼ-!a�N��v�J[;y������]�G��^A����:�5�W��/�g���;=g�&<[?�.�5�� ���N���$�&��_Mtֵ��IG�YgV�Ǘ*u$X�4��D!`J���O�Z;-gORQ�;��g��I����s�+����S+��!�N@��8���Ͽ�0�9�1
��|~�hl&.|~Td'ޯ�v�� �~���>eE�'tL9�SH��B�$�նep��d�孛�D��J\�!�>p`�\9\�T5�x�۱���t%�6������z8�\��c�n�Mל�q��2�@���?����\�����5^;}4�q�)x�U�.E��G>����h���]�,����<��t����ul��G�84k�U�˝�9AVUl���<�s���C�nn#��I��59�`��[���\�^E=��ۙxl���7�������w��=��:�ٯ��,�O͜�����9�!pq!�c'N�2�������d��
�dni���l��v�Ͻ��N�ѕ��m;1�9P����>�j�+��m���4����|�o��,�R��l'���c�����)`l�7�9p�j�I�f�[�0�V�!����flR�6F5�vŁ�H�̣�<��3m�jk�p���Ԟ�ꑧ�L;�&����0(���<ݕyѤV�88&ɟP���L,	��_�{m@K�8��x�v ���\���Ҧ"��&��Q}˚��ۇʎ���>��F�� ִ���ъR}��Z�U���ko�s��v�5tލb��6wH|����7J�F��̧{셰]*��:��{=.\x(�:f�~zs �|��9t���j�y��o������C=j���}ʝ�ya�|kĝ$|��5��P��}!�p�L���8�xi�'�}��uB�OR������Xd�w}���c`P�L���-�x��� �vٞ���Jq��k�"G�^���h}�#�x+��J���K�R��[#�ſC�si��:?�wˠ�GR��� i�
���������$�G��Ic%΂Ítx>`�aEz�K������7v��86�2r�SRH��3 '���o`�8^���c�ʖ�><ĝ�9�&�=��E��Oݸ�@̌W��&�Q�8z��^n��*�E\2��r�N���=9['+-�)�ѩG��������MI�8�����a�6�O�Un_i�va	�FlRϞo y��	[��[{vb��~�V���:��S�5rl�`�tQr�ҫM�!��-��lU�=�Orm����O��JR��\��O�av�m�-7�}�g��m�y���z1I�_^I s\�l��'��T��>ƥ6�j�^R�]c0����U�q�%���T����Z}7��mZ�R��ŷ�Mk�zk6m%�֯V��sNk�3��z.�e-v� R�.���
�wm|m����p	k�i+�b���u~b�g�tT�?TP˴2���߇�L7��2SM�re��N��� �~��:���I؜���\#���PQ9�3��݄1 �OQ�$5�zW��z]�ˢ�l\�f�/�����-Gn���KO�ᯙЀ櫄g�&�z�wj��pr���}���}}���j�3���MK�rŹ��^?�;� YƷN�}��e�OK�e�������Q��    K�Ԣ��z$����1��Dh�/fr�����í�Y'�=r�ZD0����)���#��;K3,�)L΂��da��g�H�D��ű?~��3&TJ�H���RǚM�W��v�����}�e�h-���N�S�$�����l��DY@ZG厛qwؽ}駛����k�	O$پ�,}���F]-�<�����AI�mN���K��>Nإ�\���[o	�@�W�}��͋tO�����ݥ�������=���%�`/�u�(�KH����>�~{��z�����[��Ҏ�:�B�|�y�U�0a�5���4��r�����H�j��5�v�&2)��#iז��F�=I����<�6-�S%��L����Tr#�L��?۩���GX)�2"�+q� cK�"��t����y��tXݡ	���ˎ��u��!��&E��ߣ��DM�w���p��ѹ��+{��i�bڱ�I[Ic�W����D�
O���0z7��^7v�(�Q�K�u�f�Ǧ��x���N���6�%�F1Q����a=�d���U:���3�R��=�Kuô]���:�����%r%�����D�UV�����	�H�Y�i��#L
I����N
���|�Q���M	��en"��w!���K�=����W`TΞ� ��toW	�$���TW��3����T�<Bl��D��K-��7�M�Os!�ɜg(�F��}���8}ML��2��ʻ���*�zy�'`E�\׋��_���q���f���͝&�e���o@��ʸU�^�������G� ��p�4�ۿ�'���/3Oc�T�-ϨʗA%�0^"nt���9�%l&�)����-G�(�:��I皹�~��Rcȋj"��<@x������@�mp���Ie<���rx��X������iDa\'�/��/��Ǜ����!)���mJh��u�sÞ>�mp:��1�s�Z �e��R1 �>*��_�Q}0�����܇��YǓ�3�&+`�͋_6�#�."��g�16��^RC�*[�8 �l��St��(����L��D����#�;�8����p��sM�.�D�e^Yn�0:+�5��Sc�w�C���}ő�Z��#c����������:�Ud������G���ۄʨ]�{���J��O��ic��P'q�ƞ*m�7Z쇍�J�f_#�/�T;��{������q�ӳt����2kCQ��M���FJ^����Oh���^KϿ�̤��>>��K�?��K{��֑�p�;J�Ҝ"�Ќ�x��|z.>:m�fg�c�.3�7&Dgm��$��3+�'+��'{6Û[D�e]}v�߶gO�|7^<crR*�ּ>Ҡ	�N��*�Iܤ0J2�Ii"��H盝�u��Nx�I�r���%甆q�H������ɯV���L�.#sw�4F^� �\h�-�����4�c���>����m�i�%/��
��Moάc����L����.��,I��,x�]��c){��zQ�֦���`�}�3�	P���=�\O/�@򵶇>ʹǠ;��sw�CF7_�*Ώ*=��7�`P&j<ٍ��x���ڔ���<)�Q���l<T��ƐU���2�F�ۊ�~�f�۪A���mƺ��(�0z�S��Q�xqW��ď4?{�D��+�V�j��C�Ү�Ӝ���^{���tKsfM���Ϗ4�u��	{'7��:���^��b\n
p"װ��i�����BHW�{0���٧���>f�ͷ^��+�D�F�
�p6�u�_jc=eg�P_#ҩ��
,�X5)I���4�{�Os�%e�?g�I���z��^h���{��j]���,���{�u��/�aH��+G�rc,=-b����G�h��47ƃ��'�ȅ �HK�_�2���?����/c`�O'خ�zr��κ��u,=��k��Rs�w��1&���'���?]��G%0��9z��|*�FM�]�N��Zzlo�?�����{5d�d]NU�=ֈrH�f��{��ǌ:��I$ٕ;Ǳ��B�*�fC�p,�.�X�^��U�f�e��+���U�+�v�Ț����J��D�5J�o�+�]_�fT
��e6;���=���p��.�w����_ڷ����繁\�Ü~���6^4�w�jJ9F���>��>�PCf]��O�ջ�O�\��t��Y�z?��㊉���n����֙h�JT���ui|{���n�����T�TR��{�wn�F&Z�^��r�1 ����J�vξ��������m�ǫ���3��槳׆���2�Oc��q�����o�dsࣽ��t���86�+��FNźZ<�X�I����������|��� �}��99rX��Oձ�j_��s�<e���[79���-�nq~]�ٹ�~j�,���d����0�_�yg����f����=Sc�@&��\��^X/�,�!I�Y�u�h)�T^���vi�8��z2��:/wU��_����a_�j��h%4����8���Mr�Ԙ>�%�Z�d{��#k�P�(N�(���Km&A��Gb�00W?R�/��k�#8p�zZO�y�GřGƝ���SeFɞ6��}����>�)�62t�ךkD��ҸcÅ��.��2m��\�x�oJL���2�J���$�1KF��`�T��٧N��ރ��v�Z�I�������%���A�i��qR�rH�}�d/����)��3ҍ�)��e�}9��E��(Щz�Yo��̧_�2e���Y&B��]��/���ON�ۙ�)�V��ןČ �ԗb��3�֋�me>@�tjX{�9bN�;��X\�X�L�%/7g]�^z�����V�	*���,W�مr�21:G2x��(9�@��`ǡ�Sn^w�<�>P����T����N�P�i_�(& �H�f�L�:_��}G���۽o���f�_�Q^x�`�����8Ԫ�.y�ie&m���2�Le�T	q��U6K��4� ���n}��9��I"t�_�Ѳz�3�u��?��[�1�3cg��z'g��0�Jl�e$;-��e�+�%��̈́d����Q�b���[�ف��65ZK�v�V��g�kz7��)iF��k�[V�{����F��tj�D��޶I�j|���B�ޏ�"e��fyAF\r��\�s�5/��� gG�{,>8�����դ����a��z�w���=�GN�nv�ʃ�įq�vZ�׳�G�ɍE�y�T|��:L|QƼV1q�5Im�]��te�-�(`	�in����+QZ�s�;������6���xn����ӝ|	�A�f�z�Q��&�]c�w�s	�_�պN�	�6Jϥg���$�o,������F����N,�3������˖��\�$��|����_�3U��{'��+�=ҟ8+�CY�����N�Sӷnl�
ee�^�Q+���
	��ч��@;������1s�a�<��>6*����:����K�-��g�z�ܣ�	�rXD(���u$���~��;g��K�bR%6u"�?��l��GHo��,2m�v�����

%0��d��u�|F���q?6���=�j�)%��I��^�1Sq
��xJ��q�Q��|���-��
�N�� �h��wq���vm���	if�>���ܾ�Aʙ�u��#A�ql�f�|��)�F�����F�Ôԙq�_�3 �黥���x��j��`g-0|�#5.� �n˵�c	9�u��tL8����-,��i��k�U^�EƆ���o���0��d�%5)��uhU/�}P��Oe3�Jكd8z�����v$�rU��IB���l
�Ѽ���|Zg��v�Gx��� ��y�t�䤗���q�ң%7�4�6��Q˜¼q�!.��cT��U,_r�Z�Z�8��IY/�Z9۲&\�Q	�Dq6B��R4�a)�eV��^T�ךC�k�wt�c�Q�z\��+�!�x\�Z�ǧ[<�n�U�����M�%�ϡW���s���|��m��+ش6��p��
r�l��]��U���\�ڽCk�D )�ۛl@e�&V^��[� z�[_	�u�既2��rvJ�gZ��MZ_$�>,��~|��#7�R�+�¬��ۨve����E�̢G6��`w�m�o��J    о���~e��=[�t�D`1��)�Q���ٮA�+��g߫G�i݇�_^Ua܂Y�~�Z���S<}�9�d�`_�&e�馀Sn�ﯙ���J��^���۪_a$M��%�zi�(�D�M�����r����)�n�گ��vܾ	���b��3N�Z	�Ϸ�(E�;�G���ST�[�(Fj'p�V���]\��B�	��1^VEzH)ڑ��?�&C�*�|��1Z��"�t���;d��vi홮ܘT���h��K��bc���W���e�B������W�I;������é��*5���UV�L����"��D�}�zF#1g���7�?UQ���*a,���+�|���f���Cǐ���@Y��|�s�.>�è����Y��9�TE�������n��'��YYp���=i�~R��B8B<�Ե�i�3Fʝ[���?�}�FŖ�w��O���]��ڪޱ�F	�3^ׅOG��A6�[���'-�>���8/�k�P����m�&��%��ȻRZu��������{t#d�
�eխ�_�V�Q~�bMsqv�R�Vδl���w4;��f��lj���|�O��v9GM�f�I�ӈIVTş_Y����	�U�I!�W&��6;N
�s�O���$u�c�C���=l��Cs�:�_fc\Ci�@q���6/�e�����g�|�ұ�'���(�>�-�\�b�:�!{ � h5�� 6Όwo� �g��Ƣ�g��n�ԜX>ڨ��R��l^'%����N�~��n�W��n��D��Sz߮�:�k��N0� *���9p�!���`'��+�/x4Ƶ`��c$/���s��'w���Qoh����{��uнRs@������é����ܲ+�-�$p_�ri	̛C�9���Q�@��9+%�ߔ��ky���񝚳bI�*��Dϭ�0�ݣ�R7����*�oԷy%"�K�Xy-=�{^Qx���"�t�';� J6����H�%�(���hF��d���ܖl�S�Jvi�!
s^��b"�V�����+]"A��ݿ� �ɡ�}{��fj�}�����y�/!d8/�}�,5cFD�c~.��FT�er4��f�P�rlMT�p������EW���q�1���*��.������kB�E_]�
Y�3a�Y�*ΰ�{�G��c{�����9c�&��3ȁ��m|��t/�U.( ��(���g��E[��:��&~��>�4��P��@���'��9�lLB�g��7�r�N;Β\�ĩU�$N�uB&Px�?2�&����,>�~��;��]β��Vi9�b���]���g:�����U"CK�B �:�Hm�@BMȜ1��4��"��U��Gק����Rƺ^X�Bpz�n� B���� ��B{��{@�Rs"���:�E�,҃BT��z���u����)��o�>Lm'\Z���W�H�#'L��2t��3n�� 6b�R�v��g�I�6Rՠ[
�(1�4����SF����Pk?E��c������D����^g��Z���]�Jh>���1�l��l�/�a���[��`�P�*;;�\7�΂m�գ\�ϙ(�N�;�I����?-I�d�{c��M�8�wx�# ��v��W�Û��~!��ƠƜ螑�-�G��{����x/}��B�ݷMV���@���9�p7����#���J��V��.�쨜+�lľP���SW�����u0u-�����+���������2�>(�&�d��O�,��41`��k�g՘ R铡��:/e ��}��:A�b��ě\ ��:�� hv�*��x�v�Ax�;�8B�;��WO켚��� -����y�;e��s��M��?��>��g"��+�Џ�v&��d]V9׼�X�;�GK�o���J$��a���)c��n������m�@�F����L���E?¨12J��v���S�l�R%��Yȧ�U�D��4�j��v�L���p���N���խ�;L��Ԗ�Տ
P��J��S���*�
�yc+�E�z�ht��{|�襉˥��R����%J^!��=��0�������� T�!o�iG(���y, Zuf��Wz7�4nD(��mX��7�LYh��1�(zz�ۧ��!Ծ��޵�m5��)J���ww� �$[K�-=J��,^Oh�`�Em���-�Ӊܓ�R7�<}��z� -T̴���L1�Z"�˅�x�ĭ�|���}���l�%�R��8�=8���$( �A:n�ގyS�tz���L���+�d�0R��ީ #�7��ٷӲ�H9)��*g	5KD�F�N�m��r2�2��!���������[e���ʽ��e��΁�9��3�Rl'���F���+)��Z߈ ������������qg���aę'~��h���D+ir�����3��n�J�0R.X��� �ԄQA���H3�8�6J���(%�F�)�R�'i�vj߄�,�
Ҋ��`�)+K$��HXS+��΍|����Û�/.�x�XW����=1q
��|O]@œ��
$%?�饼^�'F��Բ���A�u[/�mv�.�}��
,���Uƈ}��su?�	��ةJ�էk'\1JZ�!���(f�/u�������i�[�L}�+�5/
A��;�����fZ�h/��EͿ���	��d�����gT�>*4��`�ک���/���8����~�{u�Ҋ�t�z�L�Z�4�����b�V�ОS��E �}$G�v�2�����n|� Bֺ�U�^���U3]}�3=ץ���i"�a�[�WSI=U���N�_s;��<����N'e6�\�q5<���>@�P����jv��Y(-_MC/	� ]�O�;���8���Yѵ��Nw�*� �����hY����EZS<g)��O�Sx�~|֪EI�	@ǽt���O	 eDV����o��!Y�~@�^yu�i.�8���@���B;�,���k�8 ����3�TW6@�y[t�k?C;�F���|�r�Q�2FXy#r��G'�0��i�r����Bd�/〣��%�0�
���Lo��[	����v2N�qB0��Yʈ�^ܚ���sc�i��]�������V�;�NX�V9�̨���ÀH�����Ȁ0�qO�qDU �*�w�2�N�.����־�t�3�?/4���q����B�@�#;C~��v�d�{���`"�$�}��3m��Jg�v0��rt6@\�Y8<@2�-��ۆ�gWd�`���� w�"E��ٟ�>��c��΍�,;�t'��NIub�Rg>�A�'uWة�_��X����O�, :	ϴ��=vBM@��	���\X�� )p�d'�0JF�oe�	3vJL�^6^�~F�5�C�P��I������"/-��"�4�P7J�~���fꆽ���B�4�����*�c ��I�B;u��g�7@,��#%�$�����~o����<
@)Vg2��"�n�X�"eڇFZv�����x�g����&��'+��9�kU�ݧ� �Y Ť2�6w�)�\�c��q����@Z)�U�@�tEO�ǹN#c�|C��F�<(1����=M�?{����l�w#]�<�0\�t!��̕r��ؓ�3& :vc.Ξ��؇Ix���H;��((��;]��fb�us��}a3e_��cs%��(�z�&��)3�����LW�����=/��1ӑ�p�#c�:ʦvOs��4�[m��7^~�J�%x�#u�K=1;��<�m��������?!?��a�ۈr��C1��g�M����]��w�ēP�O	Ȫ��Y� +6�<���gt&Ȣ�X����P"�w����>�������k�K��λ�n��;#�?�H�C7O�$�aEȊ�jK 5��۟�1��&�M�[�@w��@1#鵧'`R�`��ub��T>n{��>t���?��r�rib.��6P#��H�=��=�#� IV��������4ӻ�:!�v��'!����I��+��:�~�ؕ�Р��O�� a���S�'>�ʳ�O�۳�Y ��_����^ 5;#��<�7o�ٙp @�H�
�V�&    (����\�*�q�e[���TT?ZX!���~"*79����;�茏�U���Gi�/����y�{o�ғ̠S�`?��x�GW��E3�Ww-����h�(5`F5���o�۩��Aj�#�g�آ�#��u��>B�M����r�{��6�d�q��Gtڵ�D�����7;��28���A�ƭm#�ԧk��ڲݜh`c���'WB9uc&���C����N/��@,&�J�W.
����ME`��x^yb%/�U�)�
U�IY��q��A#��1����2��/�[m������Fz؍,RY�}��7&�#֢�ni�j��L���{v<��{{��FÂ�k��S37q� 3�~� I/i����y��4r�)�&��eFW����_fvs/��l�f��Ԓ��C5<�/�?�Z�4yr�;�49�/��D�}/���`M�`�.��is�c�R^��s���D�&,Uϐ�6��ٟ��ə�����y�y|~����	kgB��c��9H^yEխĤ#����ۼL��iK�Xll�.��U�t�?���b3}�k��o��~nܾ��(;
̣��y�OX�����k���;$c�y�_��s��c��u����~���:�Yn�)Ā��.G�ǈ}���S���۰���H
���)�C vb_�#�$�.Qxn&c��J�j�5����7ȁk�Ƿ��Τl��0�%�E?�5��`R�`���G,�SO����4��y�2��%�;�N`����d�9%���}�� ��T8N���D�r9I�U�_!�$�� �P�z8m~�Ӯ�ohGߌ����~Y�m����Ϲ��M�~qm%҇��n}P*���d��K-�0��o��l_���t6}��6�&��UZ!<�W��ݩ������+�\����v�������m�Zt�U�#Tb{8͉�����9R���q������C"棻U�'Ae/�3�'h�99��Kk���	��i���^��^f��k���*}�v�s����J��@C�<��I��v����*f0���u��]
J���,���Ց�)f�.̄S��L_>���vHD���2���IwW��N��t����	��yc^�I�G���."�Ek�r�S|lwHYN�Cz�����_�i��6O]�P��,���r�%��:Xv�c��=V������b��z�x�MܴȾ�i�/�m���׆����v���(���YJW�e�~8k�sʣS��i�j}��S)��㭧�@�m�F/��g�����6��ܺ��j��;��U	В�����w�.p��9��{�������km;��J8ǯ�6�>h���\,�uVyzJ(��Is�qעwJ�7=�����!͚<�Hr���w��9��3���v�v���ް�lUc��# j���Jr��'l;X�r�/g��_�������d}���W�P���5P��z���߬�z���m���@S���i�N�E�kI�{o-�]��,�Jz�2In�H�ʁ�%f�6!�{�ZQ�[Gt-�I�_� �~Bsd�F��=ݓ�?�+z[�-s��b�Z�R��O�
ior�7J~���7���`H9=��X�����ע�Y�6�n� !_���,�>`��y����@rnF�z�W�`A��Yz����kG�,�_����k7ᘅ�u�����	�Qe�~R9p�1N+$���W?M�x#e�`_Z~X�,^!�V�-[���u>]��P��m⫁��P��lׁ��/�ĕ��As�
H8`q�Kϰ��4r�������^�H�Zo=:U�>�wI8^�.��N$b|�B4�E9n�%r����"L�vqrfN8j��4ӗw�$Q��I��V�8����B�:�|�Ή�Í0A�!��Ȃ�rp�r�ڂ4����t�;���k��F�I���-g�|3sXC����}Qk�3xū���^^z��A�{n�!�<G�d�u����Y�(	��t���$O=�;�̀��y�;��c����{�Jz���j7��{W�,�I�K4�g}�:���F�XM9��Ȋ|�,x�琑�y��ч�:����T�����ڙe7I�����	�=����=u)1^է��<���:�����jq�Ů�����XЊ��Ӊ�xޚ�G/F��D�sv�_kXG0��ٷ:E�}#��c� �n��G0q}���@9���"�r�����/��$�W?�Є�Z9}�r���󛦾��I�qF!���XO�m��˦��Y� ��Pa���h�
z�,*���U'sƲ���jU��B�0�B98�2Ψ�2�|՘;'�s �}�ؓ�q'|���(|�, Ik�/c���`+����܋�g�\�̽c�%##倄Sv)���5��͙�nܑ��I�_<�T������)�V�m#�Nfn�$稂�7�Kk/!/�������� 9�F��\��9HD�=��ۍ\���h%����+��p�S,C�z�Q��G���+�}د?q���5)`���w�Rd�R�ݨ����h�#e�>{(�.9@��s���T��²{�y�>FԜ���d)�o��ӎ������ݮ�f����vc�K���{����ُ��ήx���E����
l�]*i&�S���A�������+q����;��e�aͻ*1z.�fSؼr1W���2��i�X<�'*����?\쓿_���V �T��Oh�rZgb8��ܧi���ߴ�Tg�2(���hՑ@����j�:��K�l��cQ�'hG,�����7O�ޙ����.x�K~t�C�$��`���t��Z<iTǁї�v�k`���޴9^��q������F�L��'�����F��R��ޜ��zD�/������pp�S��^bW/$Gd�_��*
�iG^Vg5{�]��\�;��ـ�w���G��h���0gE���΂�	J�]$e�
�Q�w�;����;j�2������I
Y^`�)A�?�ׯ�qd�ǝ�Gц;���M������Y��C�_YG���2Ř7�0�%1^�T�ec�<v�?���t/�YR�0f��N�E݀q�͝�kT��緁���l���)��v:)':�D$M���l������e��ڗg��v�1U:�_�!�����J�>����I�L��s�w� i��4�D&1�4��><K� �ՙ��M�$Ќ����+I�Y��1� ��#vڿ���O�;���О�K��L��
�3u������1F�"����f`��cc��y2u�;�4æ]G�>z�9���iu��`�2L1;]�k'�P�r)��f<'J��G�B>���o<-"��셧�h���brCs!�p��L�Pa�n��?O� ����z�ؙ�SI�-@󃼄�ٟ/i;R=�B�^H��F����>�?�Hwjj1����-G�o�~�O� xh���(��̞���v�r<�ۖO>���9K�JjK��8p���<ݻ�]vj���/���I��}S�{:���?�'�^��{����:G����
�6�1��֙��,3��;����[�����va_+���ޣ�i���~�qV���.]'�w���f!�_�\�nu�ɷ)&E�<^�)a�e�n�#�h�v8�]���X�J3A.����}��������燙g��/ �:㸃�XE�%glͪ��_@�cV�*�n�f_c�]��QҜ�M^�v	-f诋��̣�ɏ�1q��BD��yhr�,�mr6�"�U��IDA�),2�#&x���sl��W��g-_�꣖��Y�.o��kv��$��M���gh�A����s鱡���*��[�����Dj��8�^���atg��Opя�V�؎��n���T�a��8k-Ѱ�k×`��/N�p:��A땟�Oq��Jl�L~@��'�u�۷��l����9�!�qq�8P�yi� .7n�'��I}��'@��2b���,b��S�����4;�C���� ��՘��%5��9�L�����I�͔�
w���
�po    '�NA��M��Ӎ�G������j�S�q�:�zĥ4��;�y��Hƽ�ȼp��Z��ؼ=�4���VR/X9��{�ҽ��Ʊя��� o���W����G�Q�yj-<ۇ_.3i���)ǧ-�Q�ჷy�ޮ�\q؀�u��Ʋ�3׊�~u���^������l�1��j����>�!)�N��_��Fd�r�@��M�b����5�����W���2�p+�����UTBc_~���G=ہ����,��E��1$��C9@;��k��0x(�j�q�y|�ֽcI�!��v���e���}��i]�fa�K���v�@m-��K�x'ڴ��6��a�RQҘ�ӱ!�c�bT��%޷y/#���y`��"�'�����2͢\D��L6�J�#�����Åt>n�>����V����B�/b @�uF��.!1�\��~���{F�9T;�l�������}��у�ML�����C�<���L�uS�t�Hy���%�����-��g�E�Z�An�$xݣjK����a!�P>�(�R��R�sl)�hڑ�_}}0�J���-�$�+ȇU�y e�?iR�	T�qu�athpXC��е�qf9��e{�;�|h�-��-1̑U6��bP�/�k\��M�2z���\����BB9�낲Cf�'Piw�v��� �j�v[�q�ry�t��M��,a@;q��{�m�8�p�ۇ{gl�9����J��2����i�?�iX0��/U��Dg\ڏ�Dh`�ܬP 6,�e;�oG-I�˝!�<u'���r`#�q��X����+��H�0���_|8 �xgz߶�g<�Gϔ8v��$i_����������d�c�$\�Jg�d��֑����Mnv�Yc�V�*Β��҅_p��@��(�ix/��,��u��Ҳ��.Ge�l9a��.�g�?�~Q_��[��)��:�էpE!ËD]��j���	�Ku迩*V��.��+^�aפ��[f($�D�9��JƘs%���3����=V���0�l�YĳІ��7���m��E���wi��v��;רvE�'��ӎ�3�
�H����C�	�����4�7m&�]����q��3��B����i`�%+}X�� 휢԰N7�S{���{ݖ�{B�3Ѽ9�fR�/��1�t�z��5�Þ��ԥ�k�J�O�^�jx�-���,�c^�����%�0�Ĵ{��2�
6ӥv�J���ۂ��*�ɉ3[שG2[�-��^��T���<0GZWL8=D��Nij���fl�
6��y@3�Kʘ�(��-x)�)1����,<0-E�g���l�Ǔ�/tc��`_�`kPD�Ǉ��&���>�&�R�8���շ=FY�ĸg��<@':ˈ�ƣ�ȫ��3�^�&Vg�J��K��U���Wxɚ��e-$��S8.�҇"�y�Z�\4G���Em����w^�����A��y�Ǘ�$!:�*PS;��nv_�8J����/�ދ�1�a�bh�m���x��������YlʳD��<�^{� ��	�n�*%;�&k�૦d�#�cb��V����3�0��dW�ݽh�v�qNp��1`��GO��w��݌�g�J����n�6t��Sk�ܲa1Ւ=9J
g/N�ҟ�۱�ŵ'�+5�T��Z����8=F�b�S�ًT�O=<QQ���3�9���C$�w��
��wb6�Qђ�����TO��6J.�$�_��SE��۲�q'A�媁�8Y���;ŝ�覀���<���$����2}��^�j�K��"L.�� ���nA��M;��<J�qx%�[�����ue�о��E�oN=�<�Ψ7Ċ�[�⚖����;O�+��h+��Ǜ��t��E ���RZ�z��ts
Z����'bW���Ke�`�BΤ�,
���t�W�dW4��022t�
A�����wg�.n��1�۴0�U�KqJ�>�x:wIv@�����,��/r�������I�f���V�]7st�jٵ��������̫�|V�{��|��-��)9p��ـU�1�Q� �P^ّ���z��:c�q[��y�� ��X�B$eTg�^4��!��/5�� ��V����S18�&0����bL*��G�5��d���܌�:���(���>�a��tqS����d��sN��}<;���%�ב��pC� ��,��ҳ<>Qu�\7I�3�p�������-k/}�L�Z˼tu���1���������Z����I�t��f���ͧ�N��}�1�و��}�/z�RE���ah�18FЀ	T�J�K�� �:Z��v���Ԃ�evP��Ѓ�ٷ���:��U�NjarqfY�kT么�ʽ�WhK�,��r�6�'-�~PGBp:P�N5��e
A���ZN�UT���r��j�Tr���P�d|��X��.8���t�᫳�����y�DQ3$��{������ɺ��:��Np�d��-�Y��h&#���I���.�y�0��� u�^��g�2�����m7x�1)]��]6o����,�<�/K)��Wp�.���O���|x���W��= IM@q|@��J~�����,�	�K�����]&��Վ�T2d>��p6���ߐ��ݖU�K��,{�[���@�c���7U�-���B.��c��we��o�3ȭ��R�	�.#z�,���g�{Y����'¢�ϖ�\8�2S�T�l]���E����*��Pn��O���P�rm1Ŧ����7Ȋ�U ����olib��(g�D����eC��*���o���Uv ��ϥ�e@�"Fבd�y9�v���>�h8�s���<�s�ߩ�
�)��¤�k�Tg�X�NG�C��+J������[�`����%�jƲ��}��O��΃��5d��b�
~�"�Fr��Ǩ��.�Bޔ����A��&�o� ?0�:��}��P�}�[�</��Eu�]�;�˯F����r�t�^߽��;�b�^6=��D�@���[aC%�8HC��g�i�R2�¦��n�:Te�{@�L���˼|A7Sk�쁢�(O�>
���¾ͫ����A��܉#�J��,HHK_��a�R.86��!�|'����'�}Gl"eﵓ�q ��k����F�F�Q�;rG���砥.�Cu��{;ݖMK���XL�eA/�*��|���m�d�R�|lwP�8^�W�Z���*�0C�Lc㉢�$�8���U�~U燍�����
^;\�Q�0�m����/*����P��:,ģW�,`�x�ø�6Gs0�_��8L󾵃���}��UTY��^��p_ o��z@��r��[ �[@`�ѵ�*���U��|P�zȥ������c�ĉ� ����|�Y+L%���y�ωO��otl_�B���.�g��q��,^�{�E$ ����m��7o���X8�,�YLZj;p�T�+�_u<�PM�x����<��YBW$�2&'"U�P�����4�M��Ŷ�5�r%�_{t�r��IB~y�Aw1���˧R8<���li`�j'��I5�V&О�_@�E��]���)r���xL���{���SKj)5d�����3~�D�:�-���QJ�'|y�J��"c�7�#'3@6v�pX�>��u��s���{��;�SQ�������͟ �����yH�,�W��%�$���
�̋���X�!u�ﻙ,>P�����ti��,�ʠ3�:T��lf�I�GX=C*g� ���h����}�*5`,�Q���SL#W��>��}�����+�<���(�R�2� ���?Zw�׈ֵ�^�:�h#�I�Ͽ���k�˶�Y�z�S��ѵrR$��0����s�8�_
l#י埃$�xtagw.�-�>�鑷�Ƥ�ʭ���+������B�h����`ٲ�ԅ���{���uoc8�m�j�v�$��#G5��ƆB�W�.��1l�i�G$4�W典#|��?����{�l�����d۷������5a�C�[+b�����uTS�j�ca�����    ��>�ςQ9�C	�]u�sz�,��#�{w�	�t��X*,�N��^X���a�Y����%�c�D���N��ą����i<��[�;vc6�q��ŃN!�_� �H2)��BN�!`�X�D�9�g��!l4P��n6��԰{򵒘�#P8ٜ#�|p:�iΑ\>fj����w:�Y�5����j�g��Ӝ#����D���Ar"l�[t@�&�{�����æ���!�Ⱦ��. �4
�;{'}���Ղ�h�=��>��}�:��Z��I~?���/���ن������� �:����F#�SʱP9��l����u�`7�l�Ut=��i��� 0��V�q���i�k��k��;;P��y|,ý_N�ӥa�%s�V���Ʒ���F�2HE,߶��%#o��u��sh}u¢	V�i���K�~̽E#'�[đ=���	��h��Ɵvb��a���}���ܰ��#��� �ޣO��?r��K��㮣&;6��~�֓,y�\a��6d�yv��#�>ً�M�v������5;%�P�p
�0��|�"vM~켜I�uc�_�N�x��V�`�%�Ձ�;�:�����nd!��^�[?QB��$�'#)��0I xo)�E�@ؔ�fܣ2�\�"���9<a��f�F���2ͭ�4.n=]E��g���vAu6#=�^Hxx�A� �8e�[�P�X(�����1c�r������?����5�����:�ݭ/]����BYƯ�+���G�8Ε�ꛊԇ{�E�x�RI<L2�YZC�8z�K��ھow�
��D7�uO50�W��A�H�Ƭ��}�>�K��n�+����5Bx�n4�����S9F���mȱ������.��!r�
�ﶢ���!NE� ���g��[1]�N��IU�<�����8�H���2����>x�y���TFս�� ��!\��A�c�?r���Q�6���X�жqH��R�z��g�q\�uY��6i�?��iŨ萪(�_"zX}>K5�*m�;�4��'�8��q�����M�oG̶��4���i��q��q [M�{�z�#���\�*\�7l�'��N�b�9���f�H�}���M!�N���N�ԓj�O��M=9��.��'bW?�j�4|d(�e82��6�����78w���S/.:n����E�vZ�V%��~�W���8��ض����&�6��59�ھ����t��P^U�s	�5}�*��n-s�QpXA�$'�j��n �k��ӧ�c����죱�����@r7w�ZC9���,v�2�~�q�zt	�VDSX����7¦����W" �\�U�|��2��Oum��-8�	+8.W�3�?������e�C^(��t�<j=�Yl�����P�x���VoO�n��cڌ`z,�JPHc�	C�NBw}����K{��G�ǲ���DUS�X�vr�^�v?QZ��2�̮P�AH�_��;��aoh��}M�s�����|�}Vj7S�uB�@��n?���]���ƛ�P��k��vs�����P�����2��V�%�<�N��#uѲ�/>�u����U��B ��ľ�@�x�m���]�{���{d"߶�X
.	l�l:��3�p����E���C,ک�N{r����s�X�۷>����X%�G��q����a�c�2���^y�Ջ���A���T̾����O���Vq���r��d�֫��`c�6���8�������Z@��T�ѩʒA�q7���r��Z��:�pÊ�=����qx�Q����#T�rs��{(�[;>��h��7���� �$s�K�	t鲽��{-�a2�e؂Ϸ�q#�y=��ةkO��+hY�����;�S�/wsl4y�.m8}B.|M�����ݏ����5D7-�+g���l;��Pme�V��d�N����7OZXI}����^���C�e��1☤�8Q���G��߀ľ���:	��T��gXݹ�Pj'U�t琢d'/�����tH&�h�ClT<��9b��E�;��=8�B-���o����Bi%x�w-�`$7�ܥ����r�!`l�k��U��X5]�"�{<�C�g��_ݲ�
:2�����[��C{�j�m��g�P�t&�-��8�c|�#L��¸�gC��DQ1�Y[�kR�1���{�fj�2vN�4�l[r'<���Ä������+�S����"��D-�:P���d���F��j���qa�0�I���u$4���v�����,���{΋S�(��C�%��}�OG��-��ԡt"�m�]?�X��\��� V��z�d�������۳C'q�V��t(y��D.c'0T�2�:_%ȵ� ��t��'zq� ��Eh9l�#�Z�N%����Y{R�����ΰ��9J�<�{���9@�l��P�ip�ؖ���S��4��)���ǃ�66$b�Y�CƖp'V�>�Lp����sR�;�*Z�;���p譽_$z����H��H ^X�OR4���RЉ6̮����e~�7�0���`�i�o�l�DB�:@� ��N X1-,��ۺ> .Y�Yq��̧���~+0f2�6y�nf_�)�ۅ{�㏤R�FM�
A�;����ˑ���!�/��L�C��Dy��<�}貪���	�!�sLϡ����ϝ����^A�w���˶l���*{T��-������0�{̚��J̡J;����%��XTg�.�'�qi<�g���' ����|U�l�q����u�������ݷM�
��Mov���W`�*��B����v-22vq���<���J�N,�����Ԋ��es�M��H9�)
.�4��ҳwL(6ٻ�Y.�G��?+11�w�8����~IRj�F7ȁ�9�FJ>�TF|��LɆ�0��΍�x�NW�D)=�)�������������=�ċ1wL����Ɲ���'7߄!FLlh�(������н��N��8E�=l�L�(R�F���Ē�p�,]i!|�W\�`��+*T�UZ1XO	%�W|�-�J�tT���`װ�4�t�d^*^٭T�?F�Z֎��&����I$�u*v���H���e�;�����X��[=�ߪ�z�$���4�S��/,eI�Ay%	�kj	'�{�tww��u��_	Șx%a	��,�|�X?�UBQ�	w���"�3� e��l�0�}���|zKU$�k�
O�ӻ����-S��T>J9�Ĕֻ�U/��:9��N��__��	�L����ۿ�Y���Z�A&��U�A�̳�~�%i��m�&2�"����,��9R�/�G��(�T���%<��wDƱ��;����q��1��Ⳑ��"��e�tٚHk9�A���QC�RJEM?��bN�C`����������aq�ȕ���l�>a���D��_�B��^'M����x�|��l��h_Ȓ{�q��Ef.r��3�͕�;����Yh�{��x�I'{��*�VnZ=7|��6�sK����c}�)��;Vo�P�j�5�?Z�:/�#B���βBO�e[n���m�[�]�	)"�xh�^s̆l����#30a3�a�,2�5�TF'��͂���ܵN���0-���G��=s�S�	Jn���΀�v����+��}��vq��t�A���� ��y"�T��i�a�Mr�0�U7�~���>�k�J]4o�FgE�Ѳ����LÊeΦ�6q�74���P� >Z
H�VWX�2��J¤*��@U��dZ}6�)SMb�����-F�۽^ȹs����0R	�\����?2:���ᖨơw:x2��ϱ��K�x.�XZ�R�����~=6��G����J��R����S�t������i�|���%><�95v��h���:sf�({�t$J�[�Z�������փ:�:�a��o�;1N�o����Ɣ�xo%�,Gu�2�R��	�M�^���Q��@��Q�a�V�ˁ�~�0/�����Bl���������Oe��Ŷ�Z�w�V1�)x۲���N)1!�ܾo�rJŶG��QJn�8n�
8@�����-ḑ���]��On+s    !�m�?�����Z��W�?dU�� 9z�Z0��*e
.����m�����5Z]?*c4<m��y�u����dsD0�j�u��ǲ����0}�`�30!h:!�;ƺ��N�}���5	��v%:�l��\�u�x���L�(r��J���&��"�ιF�ޮ��d�`Y�ܗ����-�����1�~B���1���[8�7W��Rܻ����v�sq�w����ĕHi^X�Y�S�a�ק��:�#*Pa�wl fu�v�<*��[�����4��j�G�Sl}{�����n+t"�@����"�3��+x�?l���T����T0����/��{��l��ˠ�l�?�{���
��9|w�"fN��S�ә��k����c���7c�̓����*��X�Q{qJr���Vv�-��'�Dp�R��Zl��Go�$ž���붬Oh�Lݚ�q>���\5'�m�+3F��fXߘܖ{�'�qVe����J�v�r֝�d�����\-�g�f�B ��b�p_$�}�D+Ye��}�ol��/w�3���J��_F�xf�c��)q��Z�T��f� �N欚�ϐR�����0ӧ1�<a��y��ξ��y���+F]�N).��_A�FRZ�c��k/�7��]���Ǐږҧ0�i^�8Ngg�[���9�����w�2s�}��Ϧ����׽P�/pVٿs��`E�؋ �5����6{!��8���R(���6�X��FM����y;��8�{-*9���0�;����ل �����X$�ou?�Ǿ�ڵ_�~W7	�X�҃�E������ä:���+2�m��XqcB���a�Z�>n���CdlU(��͎[�|��{Z�7�Ҧ�]p�ڷ񕎐��vK���|��L���")�3#�K!�2��&����ES3H�SX���+(�>���QMڎ
!��(H3��>��#\�<����JX��Ğ;��	=���Q-X;�����c7�#?���B���d��W�U�΢<�`��ӝ<���VpE����j��sܝOpw��]�3h,p�x�12�Ũ}�o�i��Y*-�������ލm��T�2K������glj������F;�������e�Մ��2L7�T�k�>�����זvr�4m��I�Jx��%L��w�ة:Vp(�i�M6oև��Ƽ��P1sF�8�c��*O~�Vp����Vx�����)�\�8;��2�	D���S�}�����AN�j9����:wf�����>�Ò;}�K�� ���)Bo5jDNxQ�
�ګm��R�H֬�vRSAc��OM �<@x�T^b"ۈ��,���s�35��a����=z1��ěS�F�z�3�_���n�}֧F��:���~��֍s~�N�u���$nk�x����ױSM�O�g+9��tKF��l�3�	�%�?siA�$�L���k���7��Y��$����Ȏs�����px>��l<i��}x.=8.���Z�fͧ��O+�"<^�6���v����S�A���OZ����ۏJ#�
k0���M��S��2$H����i��W;{3� 0��@2m�2��
���ĎI��'���1��6��#�hm�?Z�e�Y����Qɡ�x����\���0��a3�v?��<�����"�t�����qk1�z��F:�}�$9���b���ya�q˽G/D��#�䀑�O6�"���IL�H���@W�fv�d�9�p�8y�?)I~/�Ye�x'%��� k8�毖�$Ii�R�Vq]��ࠀ;���BR��d7ib�}� '��@��38� K�}���zZD��)eZ�'�Wp�����n��J�eg~��/�Q��`�d3�c�a����A���"V{�1e�sЁ�Дٌ%��Y�%-�[9�RH���$�j�'y���C
?˽r�S�G;��I ��2S-��=֌����vy�7,�Tr��=[tH8}�:sbn�2���'2r(����w;��1}��s[:�`ډ���$X�s����~�:���;w�����TWt�k��d��6�s�Z}�Q��a��[kYP���DnZ�E�m��H���7��^$��7�=���&������+[�y�ρ���Z�o &QD,���6��(�v���=�~��5�LHD�!Dx����ޢ�p�a��S!^؎�'��1k�8��99�\�t�[FBJ>��N����U��O�~��#��,T��&����G)��nlҨ)���]f���*� ���?\�o�I'sKA�@ntߕe$�_܊G߾�9f��*Nܤ�q�9�b�1��*��եN'��@���H�#	��n�Ǫ�s�J6��R�|fT:E�&^�_	��*���nV�T�ʎ�YV�w�'FY�C����K��P���I�cϕkN��i��� VѥH�#ĩo?�Qx#G.eR��Ƶ�#!r�»Z��@�=P���e��]��t�W�CiVm���]v,S�n���&�f֧=U5q�ai�1�=���#p�)cK�����>{M���-�� �������>)�M�&��{���:7ڸ�s'��s$��~A�讻ϫS]0�:�n.�з��� ��~|l�"���l�:��pv�K�:���'�=F� >zM���'�|��Q����r
+�����®�*��rOp��czP�9�A9=o��9'_Rb��`�tN�bY�O�]b�MPwd���.��参�s=U�j����ƆO#�s:����{��yL�%��Ϫz��W�a@��A	�(�"^�����C�Dn��Q l��SB߆y�a�Pǟ1u�6	|M�K�V�l<�ꉁ���Fc���\Z��t�A�8;|�s^_8Y���OR�t����^�?��d�q�~�j���!$�2�Q�)�^���G4 A����]U+3O�#�0 D��H��g?kQ`� ��z�t���\5�ܖ��}���;x�v|�j�A�����t�ձ�BE���˘�\=���>�[v�P&,�ޘ?|h�n�K�kl�?R�݅.� -g�s���.9C�.kա��p���	���Mn����  B�n7����7�w8�Kt��	?��z!/6rVu3:�2n��.:R��s��?+>���`"�j)�A8�uRY�?j'l�I�'͗��T��j�9����bBG��s7�4���Ic|��)l�x#ș_|��&��N�80"�;�8�"-����?݌��)���	��,�6��x��94�ý�/�U��D���/�Z$�r��y����@�	�*YU��Oa�HN�V�����&��/t��۠�j�"S�̝lׂ��&��i^�U �M ���>��bYdtR����:my%��Mt:�ܪ������b�B[�(E���_�f��W:���w���[3>U�6Վͯ�&4Z�u�΀��(��7J����u��i�W"�u�Z~P�4Ƨ���j	��F�?O���m�XI� ?6�SO�g��Z���3r 䣓F7�6�q.*��p����9��8I��ۢX��uۼ��;1����n���:&䗙5d{�6>I�g�-�||N�N��Ȁ$���uOPКc�c2}M8�rc���+%�2�Q��˳sT��29&�ks�A� 4Z��7�n��#E~tY�x�Hȱ��h���p��Cn�$d0��6�@8qC�~&1�o�Np��9�)`Ww�a�o��7s��k���d)^ٹ�ϊ6�m6�,�B~�Q��c8��ⲡn~�C���}�΀����zv)�CyP)ֈ1������a���ٙ����T-���E����NV	�1Z�]f��L}�7�+wof��� O96IlI���m M:=����\<�ډ�b�p��I� ��PR8�!���HZ��� (�V�����ngj�Ʈw$���;��A-�q�JR�LW_��j�:�R+bt��G���vIF[�D����)C�i�4BͶ�J9$6�!�Ɇ�ܔ��坰F�Yo}����N������쓪��{P�9p��<    
l5����g?�$e�(J# R�,Jh�"�%c��V�c�O�I���sC.���IJ�,
Ȩ�.ч���$E��ԲF�>.�.|2��)�� ���
a�1܎�ś�P�[��N�����4��ь�F�������>���0�������賓�˛j$jA�˟�ɋL�t�Oߨ
�y�A�%�U��(j���`;�*yz�AR��)a��سs`��'���`����fũ�Ee�X��ݷ�[X�>�z��7OB
�i訫.x�BP��0���x+W��ㆺ
���������o�I_�w�/�$�$"q����}��1��DQ�'�#Ky\��~���Sa� ����󓷓��)o��QӔ�b=�u�ѣ�T	���ﰼ��i�M� �zǃ.��{�VO��M�g3�'�~�_���cÑ��#�񈙏�=JO���m�nW �͙�!�J[�.�]@��s�6z�M�����3�n���]{�U�0`p�P���@�� ̙ÜM�݉��aJg{�r+�D�����]@yʀ|�7�C����Ӑ�<�ԓs(�M"٨f�
�F-�>!��VS����ڎq{Lݽކ�7F�]���CҔ�:{s�T�h���&�\����g��m�*��=7�l�6	{�:o�M����mT�M��U�u�A��]��C��f�e��(�ǰ
�d
���ѣ��F<�6�.ƅ��gŞ��#��~X:H$�M*�~ 5�6ϣ/��e����2����1�"�J$# +Yɓ\��)�͕�<�sǕ�6�dr�;eg�i}�5��ۙlb� Z��`e�n�0v�2zƭC���ޖP����+K�X��
��m�>ַu���ܽ���Qͯ-�O���f�pڝn��-6[��^d����0����+����/v@�B���k�C� ��2�e�YQj~��Q�8�������r��#h,a	c�B~�Ƚ��-G*h����u�|�h>#�v�8��w��rt")B�-�'>WP&9"���k�vsg���Hė��:ة�r�_���k�F	I9 M���Ԋ�IIK�cO1#x&�^�$t*�;������,��G�[mSA����SE(+;���S���5��'>n�Qqqnў�����0sP���40u@ǭ���0y��̣Ԟ4UsY{MY���"����k��\o<Gl�\����8�}����?�����ۚ�DJS�U��7ap
������j�4��W{��,����o��{�>�]��c�0|��_`�s��A�.���m#��y)Q��.mS&~vl������yj��i���^�K\��P8�p�D���;݋ZX-�*H�/�W&6�P��A(AC�z��{h�5;��5�$8b����]}�3>��n��-l�p
:�>��Q�Oshwe��͈$h���Q�Ϥ����_��i��td��QzQ�oV�a������΂E��/��D�1`aE��E�����?�=tR<��9l�>}�K�b$L�0h6d���R� i�����H�ZP.8��t�z|<��OR���|�9��I|y��s)����B�����>Z �f1x>,��o7��j�v���ݮ�ɽ�Y�4ԩh�oeD���ɧW�V� ���x���z����ȱ��?���KG��RH�^�Y,��9�Î�D.�K�'&�
T$��r?	�����zn��9�����c�Ci^��3ʡʪM ��Gdµ����w]2d��t���B��fO��A}o��³�z���;����A\4��3��d����πd����>*��v���6rg��5)n�^���zF�gm��Z��S�)�l��%�?f&���d`Os���q��]C�߭�L�5P�M%Ξ�p����&;�e�!P����Ώ�Q��j�J9%�y�M��l�g���}j��]9b����\��	܀�N�@�*����|�c��z���I���ʒټ��O��ۿC��fY�Ǯ�{Y]l�n_��޵V� ���8��B���#6���0^�R��	N񴹁3h�R���=�K����T�\�^��-�C�`io�ķ8��b�	�|��+���X���.mQ3����譪��6�WWRF�u}L���iJ��s쁐��1`�x&�r������*�O�`.�d��;|��Yoi�B� �i�ͦ����ri捙�&Z�����e��mٹfb�+��]H�2�8�/�0a/y2M��2r��5��1���x<��e�����'��:�������y�:���7�C��/wN ���iZ�nYeڹm��ڧ�N��WpS h�Z��^F��1k��SO�g(�0+TW����c���L\�Zy���_=xA�r/�\zb����L�1����{���rh��?��ɵT�Ae� z~8��pg{$�0��*rY��V�9FfV1ق�� q��|c����C�pfR��{Nw����W��3/H�� �z��h�e��`ȧ[���|���\��я��e=�҇C�%��A��v*�Y[fR���3���\  ��:uV�<�ǣ��=x�g�e�9x����;�B9IEA������pc�svy������P^�y�N�!LR�!:��c?��}���|7�o���pw�q���}g�d&)�2���\���>�4c������E�8=������d(?�Vk��f��AI�T�nG������)6I��ŝI1��#�>�(����̂�B���^�Ϳ�gl`m�����l���E0C�����?1w�0=�:e�9�AQ�v���M�)C��.y�a�E/�P%@x,Rh��Z�.�^�R�?lѕ��1Ec��X��M��G��=��
�x�ݚe��X�1�*��������aT����e;��;�� ��*O��5`E���%L�/��ߒ�|��%����{�e���4��x����f@F�� �4:Q`����J?w� �ا�^�|��s�'=�������i'�3(�� �G���}
��łB�7����D�9�G����]��q���ֱ �}��"$��� udfѮ��E]�Y�m\7_P�|#����A�>��c�L-�&�t#}�_zi�W��u���Rꡩ���2���u<v^c�sW	���\������&H�.W�L�n��譹tY�F�yu��&���ݦjM7�{����H?w_�k9k��y�uP�����m�Y$/n�c�n���6`-O�~�����K5?�/;[�	�&�{sw�;�8�C�U�0�D�_q��'v�&`��������?<{���5��-u��r��"a��s`B� �G�%ѽ��g��>��c�%�ޏ��J�I���bm����:���[�ѧ5jW7�??� K���b �ο4uRzN��w"�{VX8�㏂�N?��<�6�5�e�K�xZ�q*�sa�D�B|��d#fO�Ww�;ZN�EaeqJ?R�R�Jp"R�!���~ �'?(����?ށ�hS.d�w���1F�WF��3\�пؾ(��o\��D��{%kD�/6��紒!����h��{]g黐�ds�乔���vڢ�^Z?�	�̚,��Y���ƠN|҉X�g�.	�ۉ[%&Þ�r0�B�.�ߢ�j��R�5nlaj��~�i؈����_Ӏ<�y�"!?���I�vI�<��sʮ�XH����:�L��H����c����)w1�X�����'5̍5 y��t�<�`[NN^��E"%�,�lǁ�f~W�
ig�^�/ھ�T6��7���H&�|r��3����ͧ'���}�j�xn�B�����vTu�\z,O��`��r� ��ۏ�x�w�ˏ�9 ��λ���zxڠ`qË���W�ޜ|���,8$l{���\H�m(0�I�����w�T��:�x�(z���z[�'�������#�~ �g�����Z�o������VK�+�������i���ͷ��?��³��ߟ�*�'l�=�rVe�֝��џ�Vq��MXޞ^C�[�W�К����SC$�_}mrH���u��Ic���Y�� #���כ    �H� 2��	(i|e|k�⟉���z���+HZ�Y3=�a_��ឧ�ړ��C̀}"�?����n��-�������<wWu��'��I�Ϋ��}��z�A~�e|�!=�<�FM[i��%��_�&�A[p�f���t���
��]�e��T���cy�2.��~B��;4U7/�qOq�_��{+#��8|��l���ZxnW5�M�����	�5����| �'�)��}��X�}�6���Nk���sۤ�߻wzy����n���y%��.6�!s��O�7������j��o��������я����x�9 0�9�{Y;d��q{}Gj�8����c�}��u�g�<`����y�7H�cT�(��� wA!���z	�g��R����)�� �f1I�`��D]���Ua�@�������v�^��]t�	9�4҅Ņ��Y^p������������:�c��(���������w�	#8��3��¤U�P&�_��������Yފ�Pd۳H����&iI�-Ϟ�'� ��d�B�s���8�@}b5�X�Vλkucz��{�ZzL#|�ri7��K��C�$E⻔��$~R��Q�y�����yk�����RhF�^�_b��Y�����Q�*E܅�^��e�L�g�גf�ڹh!]�f�M��i&Ğ���`-��\�\���o�I�q�H�AR���K���i*� �-q�'t����Ͼ��p -��7��O�r����-�̂���6o]pq�&1��[<�
�+�.�ꂽ��^7�߽Ұ���a�my�E�YN�鷷�퓈u�n\��`�{��蕢#$ٻ��vp�NKD̟����^�$e���ʣѧ]�c�j���c���9s#���>�W���N�0@r-}���Ї���Ť�?����:l�����|�>�q���'8���ݫ�v�Pf?�?�l�f=d�=��}�Mu$<D/�3�@C�ށ�;�Q�X�a_%�^�M`��t3`���zY��hR	=.ӳ�&��E찋����}?4�z�B�����s"���Go�iƱ��F�f�/�w^��ub��$�u�S���\a���Y��@zA�q�����S��
�ų0`���`�������>;~�"��Ka7��=�T����#�js"խ:Zf�-�1�����n����(�}㜟S�X��VI�E��gr�7UˋY��O?��������Zb/���m�>`�-��}	�¥1ӧdp�Q�!�!�)�܏/�x9$Qn.`.�o���Y?A�n����'��>���^ 	(���y<<����
C��ǠW�m]G�K����š�N��@Y����m��:J#@���U^�U�����V�S+�v�J��M�[�j�Yr�+Eڀ{:������@Vk���z�Pv��c�Z��H0�$�ލ���p0�9��Hô�`f�G\����,���;��S���uUq�\v늷�˅��� _�1��i��@��t���%�Z��p�����9A��O��m�<�$��f�^����_�*;u�G�#Y�}�7Qk�W�d�'&�}d�G8<�X/l<IsV�D[�>2��2�B$ۿ҆�9��<[�`�������~z[ ���h��H�>	��}��O@��ZgU�~�D.�	� ��j��	��ѽ��vrR��- )O�rL�����DM�����jtj��H��Ai��cit�:��T�d^\��ȌJf@@OJ3�����m��c�h%��3S��?�T��-���T�K�\&x��$ fZ����5T�R���|�Q��{�����`�,����f�n�o	��jv��x��5�Z�i)z�A�5��K��VhZQ�@Z�i��+�n��x��d�m	r��吸񀯭�K\gJ �3��o�+&�O���O�7z5�:e�S]��~��^Kl-T��HC��|uc���@:����}�1�RUGOb�3L����P/_7��D������CG�_	3{E�m��u`lt�Ҿ���M鿂I�D��Քivu�i '�+��W � �\�8{�Q�x�/�r��jN�w&�:�a/��!R(a/��#�n�D�8�52��P[��<A�;�zj�'��v����=���D�q�������#V�����tWz{�T8���}!7�$�7K+���*���܃���x۟��2��i���p{��B��Lh$=N��A���.�-Pe!�d�ݏ9V]�Ϧ��7���H.b��@L����Pe����w��ػ�cS�_P_��B68��A��sǵ��� j��Hd�΢(�	�	dW�O���S6+Y[�rU$@R��}!;e�_�d�z`�c���pc�c�!��AQ�譬(`���g�=�����]�L������O|)9�Ȟ�&,��O]|C��2x�7���V�l�a�*�BpM�b��v^��;6����u����]P):�}�*R=J<8�n'UU%�vۿ�JF(�����	��4��X��`'V���,��FqJ%?)���Z ���9���I���'�^��V���)�')2��>�qs��J���#T���w�O`sy?RkރR&��<���<vɼ����GLĚ����<c=���N�� �x,��ɁЧ��B��o�A�Ae"3���D"�����u��{��V�p�DVY���������KH�q`�1o�d�,����P2����Z
.���(y��i�F@q;y����ȧc�����޹��l��V�3 �9;��aC�П�����c�}�����+z�i97�[�b���3&t�N��̣g�9���dt�Ʈ5g�H>+H�~���e޴L ��7�����L�<)��ţx
��z�rBں]y�S�8�1-9�Ӳ���gꞈ]ܧ<뗦��,�S�GH`���/���Z�SQZ��'�����c0V����kѤ�����d^Q��$��49M����y�5�zuW��b!�Ǘ �j��9[E��j�h�|caZ����s�`V�l+/���#�>�[�ll׶�w����4&韊���߆	�����D���ւ�7@�9�����Q`×��V�G5��#߾��Ii��3�[�ؗ�Jd�M S�:�î�\�2� VY��a:
�)������p)�Bk�/�2M\!%�
�'������W�KV��4��:�jHn Ro⃠6�C]�����*iZOɇ��7��b͡����)a��RE39�:d�v��SPm����4O!�1 �l���	!{���mzv��`_`*'HNyz�*��3�UΊf�v&�ӽ�Ym{������.�T�/A�(x'�4D\��I������!���1z	�jM��곭��묵8��e���>xLq��� =u�,��t���p�w ��AE��(��p����%W�<��y����c˭��"�و^�����C���E�����\"�ws�4s.�B�z��mk�,T&�F�J����( i�u������wN���D�YX.���i�\�M ��D�4A󤴄��7�nB�'�:F�u�v[�Vl]w�05�p|����VD���m�.]��c@��о�c-^\0E�� yEv��wO�Q���=Z��e���^4NK�M���"7q*����w���~(ĵt�4XI����������/��}J����<��]�絧N����T����W����b�CĈ��� E�fg����y@w��eܧ`N��!�H3���]`Uj+�`��m�+��H�en�Tk�2m�q`{��$��NH�-s����w��u�QgZ�kw��b,c���6s��>V�q�a�f��uľ]�xL���F������J�����f�R$y+����2zÙ1߬�G7�si�  ��=cE�u�	�?��%���Cn{�PY�^ܠ�}s.J�y��n���u�f���H����~w\�M&&�F��:oC�f��H�9>��T2vm�!�b�ɹa�r[�˾�i���:�+�.��-�t��z#�K+]��ߤ�k&n�Z��ݣ�)@���'i!�6:,]L��Ŷ�F�#'q���8��    F���yv/t�M�.�b�j��&g�Or_����$.}��m�&m���s���F4膼��.�&yg��B�i�Y/7����N^�=P�no�j�r��oZ�l@�f>)�-�:M�-�� &�D��9i�b��oYz��/3��`Y�)�Y�ӫ��u�J�rHao��?��ȧ��GݵX����P�y[; �i���E���$A��0�.�;�kw���`~q.��`��:7�z���i��o�jO��� ���1��T�XD�}`?�ͫ�
 ʧ݅��n���I���n�C�	��/;T����.����`яu$xE�R &�=�[�N���gR0�ZS��ݠX���Qo�"�o�(݁'A�DX�$�S!�j�Y`]F�$h�h��YsD&�_]6�`ս;�$pd�įm��u#vraÄ́Z2@�5���Ğ��f���0���)�C�[��&���=�ͫ�b) �)"([�ߦ-7�ش��GU�^�G-�6O8�K��6)h$l{��	u�NH�(E&h'�>݂�lm�_����؆���R\#����E�/~@��P�8�^yw����4���8�}�?��8���c"p�p�LO�l�E��{�o��KK�V�G���v�^�O5�nG>�tE�Vm�l���q{g9k��3�1���Y/����$�4�Ȏ�蠎�d�m��>�
~�,��&zR� d�l�:��T`压4ȗ �*��9!���|���8&���
�(���숓tD`�DWj̈́=>GG���P�\bI`���(�I�4���9� �[�$L�"<��GR���(tۥX�M�^�t��y��X˨�q�&OJ���ƪc`i�nFͯf���-��	rh7[�d�&�a*�י�6% C��3]��B��ڻ7IyN;P^d2;G"g������v�Ŀ�( N�ߟ�4���f�[��G٦	4���(V����F@S켌ܐ�����ʝ;|]���Ӄ`��r�߹���[��B��\��,�J��<��J��*'þ�`����d��n=� ����ִ��(��֮Rq����
�w��Կ�6U���^�jTW4,�:YE��������N���n�k�I��.�N��Z���w>�& ���c�p|�>�υ.�P�f�=+���fX\�u�
ܗCS��S@{�Z�w� �.��=�0�Z
���N�J
���~���	5B�6^÷׸�d�5��z�=�q���%Y�ȝ��}���Rro�߲��+ul��'еݼ�H2)X�Hk�l{-�C�[8�����"��TM|�1��rI_d��W˻:�wV�p�:�n��DP��5d�Xq/��N���ee-F
F��6:X#o
V)�νy�5�U��*�R1�0��|����i!�9
�H�dp?�0��H�d�r�d�;�01��7}��g�-��;sĄ�&q�ԊL�W:>g�/!$x��H��@_�;ll8l9x��L��dF�9U�&�¯g�0���ň�����o�'�;���ya|Mڝ�A��SZ�z֯)ٮ�rn�������>���}"ě����2:�[�� õ��4��x��J�1�]n9��:I��d�K��3�󷰰u�h�e��_��dG��hi�!���ڗP��������t�1��-�9�<ڿf�>3f>�N���M�P�e�L"T�$g��-�_��؍�F�����-�;�G4���ѡ)�-Z(�簹����C8�K��N�ܟA�ʚ�]��~���.E����l
@��9���7~��6ϒ�|�@Z��6�M8ڲ	ܢ�'2����3�$��ʽ���5������g ^/y"�䬝WPk�f��>}���c/��r�N.�_�-��=9\$��{V/���&5-�Ҵnn*i������#1Կm��WU���Pov�Lg0������O�K��QՖc,�t�~�O�r`�[����9�Oӵw��fz�(S2��۩� ���UQ� ��$��]ߖ�^����q������m�Wts�I]!F�!�\�u�hW[�����N��5�<����+$��
���gZD�֌Y�>�7�9�@5��͆$��Q�V�	+A8ȯ�N�����AO���w����S^F6�ӷ'��#e�΀r(}�'��t+��nф}ڲ�^����Ȝ�8� ���Ж#	�"�l��б�'�v�����Q��~�j���Z�(�D�}����wsX41c��C��v�~��	��]\�N^�U�.^W\93�Ҷu�X����Û��%a'� B�A�L�2a�W�J�q7�)�ZtIc_ۖ#��]���.�-�6���C��<t����C���^&�2�붟�N��E��"e|�*l�x�C��N��F�l��|3 BۨiG��^�y
W�|�v3�.o�W�LM�]�9�ܲw��-!���H>W��e:��m�Y�k���-{�;�CT���2X�_�� ���%6�����Fr�/5��><���ͬ_�Ru��!W��v�v��xd�>W���:����2s����[�7`��2�>(��[#���q�'M�Gy���k&��&�iE�s��՟լhI��~�#����KK����q�o6��|�N Y�V����'�����
����ͬ��
JL�4�D[$o�4>�Ǚ�o��}��%ࡏSU&�I�Aw��/
��ϳ��'f$����{�#'������o��',(L񁌃K�&Z�����+ܜV��;K�`�ip����`������|C�\�y^=.d�w}�v m[�/�PA�<q�O��Glxv�se�v3�f:w	F��2��E�s��9�_���g!�����O�����'v�e�\�Z%�D�S,"��sr'׵ylv�_�Y���u��=���q��I�����v�9F���b�Z������{��F),���
�I���1�jG}����p}¨�uSb�{�i��W�e���|������z�hStb���n����������1�v�+	$Qhx�Ǿ1f�z�T�ؗZ�s@�捑���F�2�w�=�*�f[�W}��N����hߘ�)=i��H�oExP��8�:��Qf:�>ɸ���ȁ�r��Rg�M9pe�J?�fSǬ�&9�S�aa̐�V���`0��=�1Db4����!�b��zW��o��Ɛ�"K�g��kw�Yh��Q�pLk|k�'�8�����������ݎiz�rv�#Y��$�[�dN�,yvs�$;��$�-��D߄��rV�,�[ q�Qr�I�!�1���s�<&h�Ml�ͽ԰�r�9������?/c�Ԙ)+v�\^�(JK`�����֗��W�1x9��;m�d�������
>���C�0�V-P��|9���J��Ѕ�7W[�7fb^a����l���#��R}��;v�ڷ���rK���\�;�K�(�b^2�-;E4(ῧ�,��gǤ�	~eQ��o����r2�=̎���YJl�G:o[\��mA)�g�|���M�5>����Lv���[�|o�fm���Z/�����eS�7
P�v��kwJ�Ԍ]��ƦWgY�׳0����1.��\���4����k1��J>����f��q�{�
M����[%-�΢~gA'd�G-�D��ݦx��ڭzC�kU�4k6�=���^�3�T���]66U+�P���E_c��Vc��k�lc��@�R0�5�0�!�Z3�����IY��x��tT���6�6�k��:�_�r�5Ծ�+Evn�$�Ġ�~�"?�"ՙ�����p���x%O��8�z��I���#�{�k�J��F���S|�SOw$F��O�lw��]�#җ�x��9ʆ�"�V��@�t����o�YY)�>�.d��o�D(����иiҜ"t���iQJ,�N#��5L�&� H�t�}���Ѵܱ(kK1(񨓋��7�]xU���s��Ƌ�T��W��"�-�Ƽ�o���1rm;��j���γv7���thB܂S������m���MӘ�W�aU����H��UI+Y��^+9� ��ł�    �Qb?���3���X�|Jϡ{It�|2��$��Y��C!�N�,�Gk�U<~0Z.�	8���9 ��#��������sG(�^sn͇H@���z���ؠ\����ʰ��h�D��.9�:t- 5WG������F�b6V�֞����k��gxKK���6,��F����X������k��I���c�`R��oJ��rR���X$ �)�ّ�q� �w+�}C�~#�+)ђ<�/�Q袁�5��41�ʩ_k(�1��BӶ��?����zr�M6m�XN�mG��Ԅ(�/�]�	�t�U)	��n�Xp�a�CK��:�(S�Mg�2͇y��)���wt��q��&�u�j�m��Ĩ���wLVVQ�� ��!(ă�ϛ|�;�o�߹����\v(yI�~Y�ag�γM$�-�{�1?����u��g��#?����� �a� ���ʏ�_<����d��g.Y�}[9O���5�č�Ȧ�؉�`$�r3���ZJ�
r�g����/�HP֏�I�Pp��:y�O�lspY�-o�j����pi�^����� �E}�Zt/���W�۷����:�/Ϧ?wg�	��T����+M�Ϳ�cWjl�G�i�t�+���[D�Xb�9LZ��ϽG���& ��uQ���N�I���l�3�4�υM��C��ͽ9a����&����߉Nj߈�ʚh�����.��<����_j��)B(���s���'�"���t/Y��yQ���xD
)\<k�x`��)}�0��0�"N�[[�Ӄt
ltf�$5��������/-�D*�0�����dp��H4�u���P<)B\:���'�%�tXԙa&�;1��K ?����L\G7�����e&o"�c��H�cü>X�	��V�o^I⫇��A�V����1	�V�e�1��H@�(w�^0�{�̇$���H?F�-�:���-��� n�\�d���^�vi�ġ?���ڛ��|3:��;<~��I�^�+�>��!��NY�͹��|
:������W���+8��՚�Pfַ5va�"�֑9F!E򿑑zo���E�6������z��y��φ�t_�U�	s��4+4���_��'�H��E��Z9�E�6	�Y�)��\�����%�{�.7�w��p8#r���7A�
h	M����"�C��C����P�.�Ȋ�F�[�l�d�����L���V���E%Ѿ	�I`:G�٭P�e�52���#���mÑ�eB$��B	ǎuk�0�Ӿ]m��=��Ty�!��k>EZ��:P-}���
�p���%�>r�B�UGS��X��F�3 3(�i��c�L��
W�{�}�t]�֣�^(���8t���p��ja���|d5��cHy#���;�)��u������
ƕDY�z�~��3@�������b,Q�[���ָ$X�Q�<Rf��m��޲����a4���"�\��j5��οP��:����:�\*#V�+��c��-@J�c��}{ER�.���qd����4 ��Z�6LA���#Z*��O����w�i������W�������)R�?���o^!��&}a�ʰ��	�!^}\ngp\���Ͻ�@ ��A���
2+�X�c�Y]���gI���u֮�ց�{��{���=�z[_� �t����.g�z�^��"�}�>�)�#��؁��V"�q=���Zp�$e~�;}6R���nY���:@�l����ܜ2l�7����@zu�Q.H�/&�(�u����b-��2���hYŷ$d$.�ps��ՠ5y�����^�v��hBd�p�O��.�O7+-���|�x	϶}�J�NG/�C/�Ji��+*i:��ֳ	=��	�߄��W����p�n���!�7MF������>��L>`��W߁糪��r�� ����퟿1�z���j�=e�7󔚢��i"��i�O�~��� �'�>?%Y���|9��<�0&5$ ���d����$�!��%)��8�:��!����iþLx4�s��)$����@ %�~N�v���U?��Ǵ��!�9O��GS��Ի�w�s���Q���} ��n�P�OM]�Kh-@����]6(@Zku�^������"�5N�о�F�P���c�w��V@)p��,6�{��8xu'8��
�� H)'=B�[�ص�ˤ����5�����/�h(�EŴ^�G�c7>��ŃC7���Ɣ�����C ���bP5�a]���S�S��NSӁ��[/o.���vN��xF���F��(�m�mHl�`����?w덼�=�Δ�1H��ckގ2�s��^��ߴ��\����=��xz���®�2U�O�� q�&��H���H�ܪ�<�(�7�7z�>m��5S��<�:3}+��v���]�-�6���̝>�$�Nzb!�b�y��ő97ї���P�؞��.@���SYh���>s�[ߖ�U$�ɼ�@p�k�yYG���ϴt�P�$e	��6����ʛ�>I��.�u��/��b=E Z�z���"y��ޘf|�Z���ȸ0ѕ�g�������mޓٴ�q�7.��6�>�bc���25����T�?˝� �U"���z�C"ُ/N��x�`8�B��ֈ��m7���� �Oo��a�� ����ؓX%b*'-"٧T%�C_���Y�h9�U@�M/�����7�>�W�Y����	�!�
6������`����j����E��z�h� m��H��rȻ?����F��L�N2��<�_���&>]�8O���X�΀$����y�N^ ��!�r"`�e�b?���'d&�F �d����wNT:[[��=]�9�Cs *�f����h�7enU����rR'�6�g����	ޥ�Æo�?A�k�87C�[W�f�&�_�H���'}���;up�� 5C�*c�r��5��]����j���&���nG;9Iݳ��B�1�Tڬ�S�Z�|t;iHG�߁���F(ñS�<��=��N�O����:���<h�r� ��x��y@Yd;��m�Z�O� �ZM.�������`���-a��;d	���y9h��d���}ϭؼ��r��'�e�F%H���R>�r�Toi��#4<��ᓺ ����fu�C�a�����X��)5��IĂ������}�3�*Υ�s�p�:N ���{��"��dU���f����!?m9�U&�����ʶ������܃�E��,Y��e��5�A8�0�ӌ�?Q�b@�S=m��)�4�ԇ�W�`'��cN<�Q�M�ަʘ�Rq��-��ܥ��|v/�M���Jrm7>��h�O�d��R�et����eѕk琊&e���A�#��@.�Z��י���>�����\n��d��Y<�!\�v)�۝��̠T����0��F��Z0�=�.�A0��ì�E7B,zZ� :��]��_~�.�h��RJgA��U���|��[���x�S@I�s �Y�޶^��U�@��=%����-s]b�Um,���l7�q
�,f���b^�^�N��J@ǻ%��@>B�
�7)�(=�"g�ȳA6%ʂ����$���Kp�����-i|�Fo�z��%�_0����C,��m�n��#���xd;_�efP�"�UJ���p�]&W=Y4	op��!�{���Ƌ���`a���n���+!�JB?{}�v$���<L�Τ~g�� .M�e�\�+�6���}��ڔݣ��&
� ���9�TCI�)���G >z�����֞����F��v�`ԓ��w!�����G>��#xR�<���$��S�-k`�8��f>=�Q'^ɴ3�?��8�:�K�B��\4��ND�կb&H>��e����>?U�Kc�iK{�:�\�ujq+���3�MGɻ�E���v�f�N���������M#��nk^A��
2��o; u����O���l�\�[���ҚG�r0CqQդƐ{
~�����¦�/�>���B$�~݅���?)�g���    ��3���`06�W������+�[�g+����LO����ſ�@����Q��7s��F�u{tZ����F^�S����BV��ї2y��>��6C���m����j��:`4�>�U�%���!ֽcw����c����y���� ̷-k�8jÆU+�C������g�?W�X�2NG��Q\���阺��8!����������)���1<�x��n�"�[׭=�$!�1^M�+�a;q���������p��-��@����5��������8n��Ǉzd����:���gR���8��SإSSBq���2I��7��o�j(Fv �7O8'�_"B����>-�i��xB7�}��t�)�/��p�FЗ���0П���\��`ǃ�oț=������l��1���e %�H�{~�h�@Q�w@�����l�����E6o	�u]�o���n�@������i��OZ��YA{q̛ڍ=
����3ط�~��c��)��r���{�8��H���>ç^�~�|ko�?�ކ�Kqp�rK����Lp����i��+#h,���)��7/��E�ïE����k^�O���I#�_���cq<!n�S�8�����Ft
�,H~@@��3�|ٽ���!���T%�Ż{FT'�R#�q#~�DA�����T���C�}����Gf��5<U���j2{#j��kf�D������Pc�5�y��.�cv��t�����fpli���+�1_��?v��Q� �M���3_�i��*NF�B���v����g�5v2z�N�:tY���>ttt�{���>	��TU#��dR������]ț���yDg�T���9��R���4��,�u�֓��J��YC}��d��3Ȭ��� �f�k�n\�����.A.����G�?���������7��5��\�xj�'q>�$AIۜ�4_7׻���Z�2�r��~�O�)x�E�H����9O���Ɖ�U� 5Z!�m w����(������@z-B��0	9�\�KjDLX��-7Qsפ��"��ʭ��]�~��q�_3�P�A(�)G}�7^A�]?­O�U�m��N��I^!;q�Q�3�:���I�HuflZsu���/���y���Mo"MF�޳-H��z�.��HU3��~���_�D�[#��1��~tA׮��7i�3R7��k���H!� �F˖�P+��=�V���9���SI�2#otnH���"ynb�Gd�!�i��B��L�/�v%��|gH94�J,�]@6�n�"��d2Q��	Z��3�����k|q��i}7�	����u�f�P]3J�=#���A�kGH�(1� ���pw��1�ދ7�����e��n�r�<8xu��)�U��?S�q*i%|9P|�/�r����BJ&��L�أĒ��!��@-��<��\��^�v�Z�	���"���Q	��V��Z�>'�:��[�����{H@.�j��C"2ɿ���ٿ(�g�Ɛ��0��<��%U�e�ð��ǣ�63�IP�*n�f#U����=2�:ں��j#���1�SY��o��v���a�W���X��ZJx���{�)��K�`��<�1Ӗ2k�5�#vq]��09['8�J��B���{��(e�7"9ft�SHc���� �:�x�AR��	���D���gU�B��e��O%71�m�z��#�F�C��}Q7"�	8�|�����5Ip�R7nCO*l���̡VQ��� �
�� eh,�(�>3qc�:�"D�W7�38t].^Mr���zG��`u��ɽ�T��_��G�|��½:m�$t���GT�]`�=����(�7!�A�7i�,0��b_(�GO\p�/�:B2��L2��~?�3ք�������������2�=��S&�J#uR7)uق�mJ]1j���ລ P�N u���A�"�����Q�cW	u~�@�ӎ��6��<�@�T֤5B���SY�AIm����'l��1���ƾXs,v����������X��k�;i�1yi�;yi�}K�@?�,��%.J��מ�2Sd�����C0��C绡��a�;k���u�ChhT������۩�AY�$�}�M�n	x;�+�[�ɒ?j��?��5R�)�raHLC��$���&O/���y�#F���^������w�Wbs���]Q�g6�	��4y����bwѝ�o^��c�>o�N�p�E*o������}�޺,Z�@�"�
��"���.����˭H�Ճ�T��%���5��*Sk�%���i?h7,!k瓊�(�O �U�!�������R\�?�JS)���#�ߺdx�� Д� Rj��}r�}hE�G3,��.'2�v7��x�O�ӁIT���1<�(-Q^ٟ]�t��5L��?Iے���S����mCE�@�_�>�Ϋ��E�TP�n:|�n�]���Sˡ��H%��ƕz�҃%�x�g���N��M��8�Ss�&q
�9�E؏�h��9���t��2��� W?;�_��)���j2��P|r��3(���~"�W/��w9���MJI���o�C��&IO�)���.������B��(��BEWtt�ѐ�Vf��6�]��$�k $9�ڇ�G��i~H/E�j�/����Hܕ�|�X�Y�6�V��>(E{D�F���ۨ�j�]�����	7u�(��~�6�b�ىВ(~�^ԍ�Pz�l��#��2�˳�l-�"�}���ڴ�`�����50	�xn�/nZ�U�G
�|�Fq�	��zqPc���I��A"���{�%�#�fMPG�����_�SPs�9�A8��x�.�����PamP}tq�Iu�J��?]�(�2�}ws'���mK�\Ӹ�f��5@�F�Y;� �!#��!ږC^�(O�^�z�B���WJb�Vԫ�4S+<����k8"M�%�+1J{���g��goJnP��&zM�rpp5pcܦeڗ�6�������Ծ6����p7.-���u��@l�<G0�dUc
����oorr��s�Ua��}v�e�L�K�ʹ,���W�m�� \�I&����u}��"�l��8�Ֆ�^��[��8ż��h��%#OZc��yz�Y_�/Ź��\�u��;���ӵ�����TXB吙2\C�q��2zK?&����� `�n��0wT�C_i��Z�>��`�p���<&i�c�GEH��*a���wҼ��F��wW.�B�O�����JnQn:߅����0fx�
�sx�7CT���M�#ǿiΥ�[��K��e�x?�����[U�fZ+���g����|��I��Y�:�R�z�1�(�-O�A�Ȟ�x}�m�~��Y?,%t�`!]�!:��@�-���
��S`_�w�@�)X+YZ	����KH�Kj�R���	���C] '����G��v�8���~[�\�9m�P��|��!��N�
�nh&.@�莑����,���~�����Po�9RCr�>�⡟�1�U&-�9\�Bͪ�z�S=I�>��N�%�<Z�%v��|4��+��Ak���HH q�\$��&k�P]�a�h�v�1Ce���/�� #��šY�ec��̊U���	�C�zA�{;�)^ !	��9w[�+�hU&�pEbd���o��c���1\	 ]����2��9��j�?H�)�68�I	��@ @����%��I)�<f�*Zn�ORՌ�Ƚ�yF��鄷��;�tkPz�H�����}	-+|�+�z�J�~�%�m��P"�| 9I�m�j3Ǟ���^$�=E�A�yA�.�A�7a��� �mH��R��&gCr-AH���K��i۠q���꼡	g��2v��������T���I����Za`�^z��g�z������i��N*`t���TC&~�1	��A������KCHd��(��V
3cԱU�v�BH5@-����z���Mvl��&O�5vR�

z��V�ى�CJ���b�fL����% ��Ȯ=Hلg`��h���K,    �kp	3����oT�a�ȳ�ow�Y7���??����}���PԢu! 5��>� V��֨�d+޶l����}��I�D�{l�S�K- P sf����l�=u���]f����1�����~�b�>pp�Kn$ǋc���K�bE�����F�9�#����n2��J����Rd֣'pC�V9����|���)�t��!9��&*l ��9�`~b�D����s��
z�l���n^�u����b�J�A�k В�	�s�]�j�O��
�@K2���1�� ��D bF�{N��m6J�c%2F��z�-����BP�N����B>��%&zRm��ȴ�x)�{��3�쳖`Ӡȸ!�5ip����Q$���%�^lTE�_���Rf���뼹�zI���z�Ҏ_�2����fo���ER�Sb��"�N:f�򅀮�7�*�'q���]2�����O�n��w{���e
�}\�n6�X��_�����E�s&����S�Hݨ��c :�T<}ȟW�ؠ?Q]Ʒ��-���/B\�$h�g���%��q��t�;;P�j���W��eB�����7�u�gt�!�>�-90=@�p@���L Ta�>�ȰA�6+�NK"�g 2M��L�D���o�?�fZy�Ľ��x��7K}�� >ѭ� o��a�gG����!%�ȴ�����H.���f�U�r�v�� u�66c��������|3.��9��~��n�a'�/�~Q�ey�=c?�'�W���`;��l�Pgg9�X�[��쨎��$�-]x��x �gv<m�t���;�/�5q�i��I�|t�l�O�Ri6����B�W2fm9���B/�������ļ�%흊����Z���-�	+�wR���]�k�5��S��It�$\����s���WLG����i�������q��<\:�jҦC�`���f��=�<V��dQ`�B�)O��>u��a��k$~�$%ؾ��?�&���E(��{г�fi��y�X��Ku�\����l�)I�~ܣ��������D���G��Cv�ގ���4^ϡ��,1/7�ƌ�2��)�5�>g���]nA�y _!�ԅ}%훼�d��2����jqQ���� ruQ}�WL���CHHZ��䓨� }^Z~"��p˶�S�����囁����r�4�
��J�Nv�⏔�M(��0�P���B~PyA�\�E��A>�,��k���{���!I�{v������g�N�q�Ϟ�R:}}9K�D��Y?A�8U-Ȩ�Խ�u� ��8�"� ���O>f��N} qH(�{��M�'�� ��A��I��30�����`�z�[�u���#��9��I�oF'��>��@��
�P'��Ox��X�B���{�eU'B^v�,�?K�%8�'�s�n��c��>�^'�~J m�kSu�>m�����.�Ywm�o	eY���n�:l���M�WV���LI<`� ��)�q�yKm93qxշϲ̭����e��]��0~��^�nh��j6��/�h���^��7vj�rv�.���*+͸e� �D�2@��?{��h�s(ا�-o�1�'-���)K���Ą֋A�xBNh}���4Bʾ]�Ǥ�aơ$�k"��oM��+�:���-�]�.���v*�tZHf�ei�������{�����¸�9�{�TU]{��웾{ѓ	�ϱ�uC���� u��2#sV�*If����f�ac5%~�W�/.��o����q����+(ߜ��ol�!yZz��3xD��{��bv�Pk9�u�<^���a�K�.hI��W:_L�
���1�����f@ퟘ�'�-������.a��n����#�~�C7���v$}Rș	�=�1�ci`��8Ζ�3���RrOZ�W�J����y��s畑�i����Prɀ��s�2`\0��"���Z|��Ӳۀmb�/��w@ �V���qY��U���zX�MHo���	0��@
0�4^��xŞ��+z.U����j���W��ǻ��Kw'��87Q�f�h�<$}e=�ј����� �:9�l.�c8Q�o�
�IU�Ko!������nT,%;q��&u��˿m@���\���`�9[�m�+;=��TC���h��U�'�@*F�-�zy���O�Ц���O�.�}�6�i�=�?0�B���xQ�T���ôe&C��y��g�^��lM���k���r��,�����$d+APM���J���n��j"�����u4kd�f�]�N��_D�Ւ�7���2̇{N�ɬ%M����QO�h�k�B�L2��Ht�gfMbP��o@����ȡQ�����S�nz4���d�c����vbN�}��=d� Co�����:�ݻ��N5��Z.��.d���[B� ��e�ģNy��Տ���CQ	9�lD$o��-.3Rr`�L�)R�������AM5����	��YW���en�U����tm��5�$&p�S�{�;J�k�0$&������`����h��?�Lq-��A���c�m@��=�6��8F���q�ΰ�� ��a�m�o7�ڇ,;�]ٻ����L��-u2�f(2>�Gu���4/�|[ǐEړد�"ⶄ��u@myFd]�xk,��� V�ar�*�BZ������fC��)�K�d%��G�) � }Y�Æ��P�ܵ����!l]u��U�S &9]�lB��R :��s�`,��� i/����������g�KŔqMsEv�λh ��?^а�ț-���Y�b�u���k�}�1�}n-B�z��(�L[��鮭��ȃi�������ڥ���4�^	�m|�*�K�8��5��LY��cWD��CYB�G�em�W��R�g��U���l��c�L��v<���3`\Fs�%,�3��T���<qx�6<���f�>���-�>����ܷ���U~��&��p/o�ќ�Sa�ig��܏�7��K8#f���:^�W����_�r��_�U���e���F/�a��.;8̮�!~�@.��:	y�裍\#��k��T�4��Kp[�؈8)�������Ґ�c�ChKcye�BtʂY���
��S�����8�0�Ca���.Y��We�1~X�]�� d���j��s=�5
j�B�	|�9,�.�w��u�:BJ��&�1��@���hp��`�����.����z����8l%a �L�I�%���S���ts1��̆�?h��8`!�	2T5�,��V�A��:��anL�w��?Q�g�1;�6v�ʳ��S(��l��G7��f�d/J��1]RE�����kzjs�J��8�R�ͧˤI��O���?M�%�+~\ng��ܿ$�8ւ)�Կ9�m�m�����g�	;K\���;��/�J����J��ap'�P�	�m��R��9�U1���>���GE��Χ|l��/.=�nރo�z���~u7'����1�-����{h<�L�yc�)�ȶ�o\~֡�����M������٫��&۱���!E�C���|8��C��$X��PP���/6�;�����M���s�# ��b����Q���n�2��|�q�ҪA�=wr	�Foa�����a������3J@z~�@�y��!����K量Gg^m�ot�R��Ť�f�4�9��cQ3@����'���]���Y8�����sJ�(���<r�p�y�g�Qmp��'I� �����Jro�U��U��\��~t}kѯ׮���h��5H���3lƠ�٩9}/t6����,w"' @��dMc�Hhz�W�N�xKY�=��aBj5"9}��%z�������(�6�Z�����ל�PF7�zW0�$nR�N$���ֱ�M�����F���d����U���ԴiC�QX��EJ�r!<i_x��w�A����^A5��V/���4�j�͓��T#�	�n	YAHE�j8^�|뵋��%�<�[@ۼ��}��W!N �f�3����9ܺl���1N��L��wW�"�V3�%��)�j�Vo �Ȝ�n�%i��n    Y�9�����Z��B��>l�i/�w�3�lt��G'�@�B���x�,�=p	p?If��8��ij��,�Zg���=��I#�~���X�		]:X��a��m�Oք�
D�3�i�ŤQ(��v��R�C'�� K��fe���\�yp<����j@����Lj*�0���z'5�v�����C��G�{N$��.�D�y >e��#`�vKڼ��>�����A�/��O�8v���ɏY}*l��v+���s@�~�3ErC������BB	���C7L��D|��9�S񶒸�4�,U�0�ܿ�-�걜�J�p����X��:��m-FJc�l%�EYW�{t7�0�M�P�X��"�J�q�~�zy�*�N0 �t�$����*��܅:�"q_Y���#�&P5�>}�O�NrM����K
�CA�G�J�D�Q��u8��Uj��N{��=!���^S�(2��}P�ϋ�9�NX���� 7��¹����ѕf	�
�� ����� ���:�WE�s���/�#�<q������wϐK�����;ɐ/�mj�^�?�~��>���!�>�k���	���_��ң;�v�w7�������y���m!i�L!39�p�8dw�AQ+��:��0�3T�ԭ�����,80}M;��>q�.\�2�	� �X�ę�t��15q�K��Rl�{�cOrL�� 8�}�U�R'���iWY�^��Pb���艮�,}]�"*�6VO~Z�nn=��l��%��{ �Á����#����4�������VmnR�l�9�j��r�h�P�E������B���J�aL��Ϛcwׇ�l�Xe��s+��:{̂�a1������g�aUL�D&�VGmB�b�h3��Z��q$��92@��=J�'�u���U�B`�� �K����C3y�~oX� �)x�>B��Y�NͿ�6��U��g����Ő�Ш�����3��sgO�;�.�`f��j(Ҧl�6s3з�5��)awi�?��Mpi��;@�oص[Bܽd�D ���}h���Gl�<���~a�N�R`�	M�g�r��cǸ��`�5/4��=[X���.x��?����{7��C��@?������/��D���"�=B���,<��kt;��@\����M������LJ������@�$�U�n�G|�^�)$(@����@(���W0(���8��_���F��t1��6�_K���	���Qꟽ��%/ q�C|u���'c���(-���eAH9���[?�@%���I��s����ܞ���-#��阦���_��Q m����~���7��zl�����2`�B'�)���?O�>-QG�5�C���4�W�;�ѡ*��T��Yp�? ?@�R����#٩U+#�qĶ)W�L@mU���,��*�)���wݟ�M@��DX��`wEs*ا�A�Q��s�U R�r����koɟg&�"(�n�/�d����(�t���k@r�U���Gσ�q�|�[jIM��<�]� �ܑ�Z	0�R�� ��"j]	:xK�R�i�H�N7?��F죷��G2�M v-MLvs��S�w������v�!V�ҷ.J �ݙo�?\��� 
�~b7=����@�u�~�B��r�Y�Pb����`q31u�'M�C(���2w�2WŎ@����FIB� u��UJ4�iWyɮ��*�~ܧ/ꬮ�0��0�MWU �UεB��6b�^���Hpp#%e��P������������p�,��ؙ;)*��V��G_��{�ؤO��`������')0��wu	2�I�R�ݻ�O�f0���&P�$����^��������{׺Pv�K�^h�e�=-¾�:`0�b�����c�&�h�=�����[�:�q�zᅮ��W�o���y���ڲ��u�Cl��<x�M�Wd ΃�=^{����@G������I��]N�YR8$�m�K�瀱5���ޙM�N�ϩ��Wf�<�9}Ƿ�<gM���g?\�K,���J�{��.����+S�Lm���2dաJ���n����g�3��_��י���qk%'8*}��
�t�E�;��a�H(ޜY�F}	�>@ˀh�\<���٭?��xŮm�S�����)͸S�q�?ۖk7�5pê>��"�3`y�j����\�?��f�bjX���Kם�ufݶ ��mDj_w��Ɏ�_=u��!�l����p���e}��l�D��+�Cb\�7G�`�7䖳[M�Кqc��5\sx mf�-H�^�� �F����Cw`��{I�����\ ���Q�Z�
�jl�4��a�S��k>9����R�#k��JI�����ñ\�?�_	.g��|CA��Ń� �����y�'��dq�h�h`�+��#�.)��F+�
ꧨ.Qk��Z����*��!A�(87�=�ot��H �cXHFo���=�7	9LLRvu��<�jw2�k/���T���6�,؏1Q��Ç��^��U�:$�{���+,�e��%ȏ�686�D_���yq��i��եq��8Z�ht�6�!_�6�I���ۥ�;E�Gpҡ�,Ai�X;m�0�j�Q�Оq���SU����*.6�@R��'�W i����]�T=�x�[����^g���:0n����ɭ�1>��ߊ�HJW
k.�(�3Z89eBB������ -	��z��iC�;� ��o�����+�� ��1�W�0I
0?�a�Q=����㶑V��סX��1�ؾi���ɽ�{��c�<B�B�c\�[�����4��PZ���=#��9 	�x��(��\:��%ah_^��k�<��g��G��^(*��ȢsJ��~��@a?*��1Y���
2Q�Nſ��uϡ�]� ��۷�vv����녈/�F��LI���U�r��Ob������Vx��#�ݖ�um�_�[�ԃu�eY�TnY�\;��?� @�Yu"0rGw���e�7���m�r�5�W�q˾�~��O6�n�q0=W-�����ȡ����{�ꩈ���p@���.���k7���7�8�7ϬR�}r�<`�-�
���\L������L�_�+�R�_���c���k�PhnCE�|<r�ȑ6��ȗ�?J�2��m�V 'J������
��u���D��?x�(�n��`�],_b��C�(�����f׺L�2��l�:~���%}�GP+�~���.�[�1�~&��?"�w���4�!�=����GѸ�~�$��H9ҲG�ϝQC����Kx�>�y��Ys���"/�[<p��Hx�_���s�F�&������t��;�a�2=��R�GH����=!�\���đ���uA�&��5ŀ�Jˮٹ�ֳY�8����ȣ��f�p�'�:ܴ�!�7��]�3(��-U��`  \2�2
� ����ѱ���~Mp��`rk��J
��R�ˀ���)��;��
���;TW/����9>��n[&�'|Hm�s�	(�!��R�x�\�}����Wt炓Yn�U����^����f�K��(�����O�(ڞi�g�Frr[*��ڇ�N����'��thyD�����~V�Č��~%��;gGk22�M3!)3�k� �f�Q��;�����RY�C�	{+���B�vZR.��-��(�y���m\5#��&�W�k����d��6y�������,O
lۿR�{�lSw
��gOP%;���|�_�*
�OTkT��S�j�}lrf��l]Pm������h�PU�*��`s6�ێYV�����uJ��t
{�9�;m�-{�d�l��y�tJ�t
��p^��t�H�m�*��J��*VԠ�6��-�c>Q@���jc=C���z֢±��+!���X嘵�޳����O�
x��٫��$��
~+VG�'�A|�����XC=*<R�\w���n��,�y^�閔Ju��'�7�M\������v�����>=��.�eF6��;�6u�(g3��������(���,�t�疫\�
JK��    *��gk@$f�@i��XPq�A�xm�N�nz��늴,y.�tg�;K�˽�]{1���3���1wgv��{�	n^=�G]9DZ=�~�Qi����BF����W�@�5���EqAa���	T[@=����s��>O�.�ѷ����5��} ��z�ů�zV�*&���������z�4�|�����h�VW K��u��U��۴P3 ��BQZ# ����%�r���d~�|lw��OL��G*��ߧyr@�����{{�%�l���i�@󂘡;Px�)��F_���/�<�ye��)�N\n���=n;���i���|������tf����吇�7�ؒ�U3������8����/#qf�I�G��s��3�
ۚ34��ב?������HkQ��<"��-W
�V�`��w�h��K��p�\���ͼ��؂UGv``EZ���i!jc�zD'���v�5
v�k��Ū�[��g�ԓ](��ٮ䇹P� �$�o�gkO�E>�o �Uo��&	B�묖��O���*�2���M��Q����*�l�:��%n�u�ƍ��/ч|�����xB�`s^yߝ��r�mm{�#ʪ�b�וQ���=yass�c�t�4BB#ήi�,ȩԢ��֋��-������{��:k�4q�.�6��-�r���c�y����F
�qq�U�P�
̀x+8
��`��Ple�hV��:�kM����2�%��s}��!��w�q��N�u����A��7z0�����������|}o_`�?�<�!c�>}���������1қ���w>]a[!D5%�L`�b|�.�n���	-:�qILd��^|���Zm��{\�n�~^�V��X�U������h�:ٔʔCH�FH�r6�^�v�R-f�*�V܉���9{��q�<1�4G��(Sqf��`N[ˡ0�����Vl��H�ֳ��r���Fy��pv�+.���"���چ��r�����_��*p�bn��k{���o�;w�����.1��N4�[ QY/Y|��bj�y�锚?"�
�HY|/TZ���9�v_C�|N�Fn�J~Rn��/��'���/��?1���"c�љ�w����J�������Xd�~����r���z�Ct������1�u	��ն<���� �z���_��'�����hV�B��C�']۷}����5
x�&O{W��i����Og�>'��	������,)؅�M G��OI��1�6R������g�ƕɱ�9��܏> '����B@��W�%	���'g���E1M���s�*M+S3��M�Z~ξZe��P؃4Ҽl
P�Ã�9��F���]��,�anmP����?�{��w�d�>���S����Vw��^p��5&��\��W���w�^����0������؁V9;�x� ���ҙ���[=� '���8^�˧�~����
�G����\��gP���5���2'8s������@<?M���6��3�Z�n�r/�x��
�|b�����I���%����ڰq��#Ec���0���=�W�34"N���F���ʎg����M�ڊ0�~!g�i|�͎�+�{��T��lzGU�9��+��;\~F�p�
�"��_[�fĝ�_�Ӈ{���<����*E�>���q�����^ϭw�p�q���ֆř��]`﷨[�*�
�r�m�c���OP�_v�<'40Z>��퐵7̸|���p|�Lwy��s�m�[�l���C�Y�RM�P����ʢإ=��G����t�/�UF���{R�ĭt@�*w^�����y�>��뢱(�p���GJ�*{���H�C�e�����#��L����F`�sT�{����Z&��i-H@<8,�l��5��W:`U󸡺����Ώ�����]h\n��2=��m���.'�ٲ�YĎ�
���X�״�SPE���1��l����s����1�����(��������[����ݕ��Xdeײ<���S���@`�
��?�`���O4?>qԒ>�쮵���[�Jti��{E�Y��}�����c��+����p�s]��tE��U }��i��*�C�a�"��µ � 1��M���=�fyJ٥='{Mɖ��Bw|�k.��]n�ByV3̙�vf>�]Zws^UH����4��r����ҏf�g�\��55�q@g3�-��̗�-�+��:��>.'� o8:Nn� 5�REz�Ư|7!�<h�<Xt�A^��߀�0�N� ~]��h휳}��OH��O
���Y��^�x�"��-,��؇��ǘ/�P� ������{��˗yU�q���� �N�FH���8@��ǿ�χ���Ɠ�������F��gP�����n���	�d�1y��d}�:�V%&�����Dm�3���پ��+8�mַ ܩ0�p��캁�Ԭ��i�AQ�\)����ȕH��|bRk��F�w��_A�6��e���"S�֖���@�n���~q�7��8��O �R�� 	��пza���QJ9�D���m�Q��p(����K�F�&g��3��~9�5策K��ʷ�8�<k�+��מc���.T?����u�u���ڭ�z��d7 jB��h[(¿) ��Gz>��'A�F0�K13�5=̴ ҋ���\���o��j{b�|"snJd���?B����*Bg�J�ނ}���l3!C;w`�	Zv����ƐkF��63�Mf\�/�-ak���urv2} S������|����a7|~�I���A��E�>��+ѩ��L�'�N'zV�`�!=�vo�M�(�����ƌh�X�3�=&�v��L�����y�ƽ�;,��൓g	�^��{�	�V�X���%&C*�"�1�^ހk�K���r�?G��y�XM6.���)/�CW�w������':�`�VǶ�M��L�]^+W�3:���lZn5�h�����*�B��<�:xa��G����uYd�_(a������n])���Fec=+rp	{h��d9����5+�[� ]&zV�b������S�̓��s��uO���7g�����2i�8�J�G������^;y���M�9>��iF���m^�W���`��#`�m@Z�Uܔ��h���ڠ� `�+@�������?P�����:�Eu���6x����拮[k!QGy��C:�g�"߀\OtC<r��)T��;�g��p�~O.͞R�l|6I.;	����~��#3�E|L���� �����w�����9��)`g@��S�b�@|lq~�����4�E�'���oŃ~��;���:೽=3�u���ܕ:8""d�,[d�s<y��ݍ�${S�0�-�.�" ф՝{�X�O� l�!�6�G	����/L��u�o� 2	��}��k��J���&?<z��z��[	�����6��iZ/���no*�<��N\����F���vʞMn��$�#� �S�(����[�������y��qG=����4���w��K,H�x��" �,,��&w�.�	GĻd����(5�h����{i�Fq�!����	Z(��AÈ4�Y������/��u�_#�s�(���Ǖ�,7Z?E�1�P8�M��c�x�4�-@�K�ND3�A+���$�����>�A��]���<N3v��F��!i'��\W^dQ���2\���Q�;�7�v����Ga�{'�9p��2�GXsŵ]M���T�vI뼭��̛1O��͋ʘP�OA[�]~q��H\��4"=I9}���ָ�"ך�χ�6_�h��Oi̚����`g���R���FB�G$���}��ʾ�w����m�{bn%�MU䚮��l])�{��AP�`�C��)
�֯��@�-�3�y�<2�EȊ3#�%�{�,���|"���~<��d5��N���yu���"E����t�>^��_Ad�Ov܆	�x��o�C�֫��C�.���S
�,e�>�a�?��ʋ�mn�f�~    (�~u�8z�HA�_^L�A�8���X%,/������X˕�^�;b�& "(�֬���sJ����w�%��+UӖ��'G(�<�'g�N^Z>�,?Z�NY	�N�}�h�r�9_ONp��EV�`�1`��������������"?�`ˤj��΋R���i>�6��`�I,RNz��[p�&�e�\��9���,).�wgP:�C�P:>׊v���N�CЦ�(�]�X�*�db?cX�4��P�f����ԃf����优���,Nk�n��������#�G���1]za���Ai�Ǌ<�o�Z��&��c��8����$vD�$C͍4�E≸����S>A�n������#=������I>��!U�/�vE�}����[��nT��*�}�ٻ?_Z�>%�i؂�x�Y 	]��Z�`�)}p̮\/��58% ���KvI�b3�����)?%-̖W�%"��)�i��OOe%_��+\��g�G���>��&*��I���_z�bF�J�P(���y5`�ۄ����L
Z�"�GY7��@��gl�>�ny?J�O�9TD��Bҳ^�Jej���'�{�绵:��oR2S��eq��D���7�Q�"��ic�R8�I�	�L�ɦd�Yu��2Ku��,���������ͽ1�+�*s��ީ��f������y����ӓKҌ;��Y�S�-ă���� v��]�.�^��6�߉��	���-PJ�ư�Rk�R�6j��~�E3�D��S"�%���V��	-8l%E"N.��g^�ҸT�Cx�_��$�״�A����>}�W���v����?Q--����T\,1�eΔ�PW��0Y�!����}AI9���<V��e�gBJ� 7�w�E�,}|&�9ܭ��uW�3�S��!���ogKj!t{�B�6���LZ�p�J
$IևTYz\�:[G2��L�ًp�B�os��`J�(")���~h�Y6�*@���j��a���A���Ҟ�mҫ�u[���,��p'"�i>)"����0�t�Te�����&�@��Z�U�PQoO����K 3"W
�0
Y%z�x�"?��Qv.��)�J��pJ���m�'z<�E��T�s�Ǝg*�i��7!o��;+�'P�Iv�^O_�/���fFDK���������yT���Y����*ܨ�s�Be[��� �	����T��������j��򤰫{��y����L��L1��ǯӶ^Ga)5���Q�'��'����~�#>d3��6���<h�˅�S����2��}�$"(tCa`�lHs��O�&�i}�u�|bt?\�����*�����m�ӂ*���EU��w�pf�L�w��_h#�'��Jz=��4�/�ҵm'��R�g0G�d ����T�e>g�v��I�H��1��:�1wsg�;�*���F8Q1�!���l^��S}�gJ*�q_7t��?��ŝV��j��g/�T��,����^mk���c�q�U���q�:��?5/öa��H��ss�(v}�a o��TS���ǌێ�*�J?!�i�yM�fļ���3/P2?��Mh����� UF�K=���۠�(����<_6	Q4�%5��k�)�[@��e�l�:�\}���*؁�L�1����2.�qR ��=�h�Y�ma�/��{⩸��y�
���A��fdUE���S3��k^pU����|U����e�I�O�V��.T���+�}A��*�1@�E�h�r�8x���Wܮ��pd����+�R�W�Wqڮ��bU����bhw{|�/�R^�=1iMXk�I�>�g�g.�%E��^(	.��	=��-?��+ڦ_|+k�Fs��-d)�m�Jl�����f�+�;�_�;"@��[�셩���xݷ�{~p���b��J�rΜ;_F
eZ(HF���~�t�B��7_T��.�6�6���]�j.�b/���/T��7o������<hߘ��$,��|FѽJ��̞�Ng��|CB/���V���p�d)[w����Gn�v#lBm/�vS���J���j|��m�Zد�R��α{�G� �5eܬJ��5IWI�_�dX[�L���
�w(1���y�s@���(\�&�5��w��eљ��"�百� �h��k�o��U����f�Y�ǈ�]'f]i.?-n�@�����eg����b�m�P�3�z]�c埜�I�e�hY�^�}��p�f1^�5�9���vT���p3�i���_�ݼf��SK>�t��3T��jo���F%e��w�{��#�!��uY�<G[1��տdɌ��!�{�%ǐU�4���M�	VO)W�p��L�Lq`��|�_w�m�jF�Ӻbv��g���6�MZ}s�I�>2��ٻ ���������O?�}�J6v䷛U�C�9ux�� 3ޓ�9Ԏ3[c5C�t�վJ/��AKZr�(��0�=@�f�<�V[�N��a����̼
m���?'l���1s��qv"�[Bzf=pj���h1��<���`�5�a�P�����5��;ɷ��Q��_i�%W-�u����o�d�����L	f�J��%ܘ�"��0^�F�W�Iko?�h�.�IΠ��y�/-#�<a�τz��v�$lg�p��]��t�����]�~�èHr����vDӁ�����(V����,ֶ���H�ZPW���m1�2� g�L�($M�<k	����tR?"�<��G5��U�whB�U訓s�Fg<ִT�2���v�p�7x��	)���U�l���.ω"}_�%!������8S�+�@�@�<�O�~��ލ���x{7�Υ��ty��8b�?�Q���h'�<y�.s����w��e��|$Ǣ0a�;����]Jg�ф�M�y%c���'�W�	COQ�j�0�MJ'�"*�-:��E� �Ψ�	7ϰ.7���_���%� �J0�撞��}ZO��p�qB_&��K��8%�ʌ Z�P�xgu�a�I w�'�&��^�VB��9��7t=ߦq��=����ؓ����i����(�B��4�Q֯���;~Ծ`NS�Rl�#�݄@��9�����kBcHr�O��t�ư-7�?�xٴbM[ټ�u+Q�Ԥy��Ϙ�YK83c�aP�����g�q�D�DH�I>��=o`�ֈJ<�<���*��w������,2���6M��ܞ/���RZ��P=YC)�̪��O�
y����S�Ow�l�ە?�.��C}N�6��(_]X&�G���>�|>�2?=�m�in�����ZhxK<��Q���$���0�����H ��kr�5��9Ǹ�J�NkB��;@!�9F��-�U�`�F�{e�D��FT�O���'�h�wq�IY9�m�2�T�9�	�x#_�魿e���h�ZFE3��Ae�q$��l�Pj�{=$��*��W��/L)��g��}�����W�F�^�����ZI�	Y��Cg��Kr�n�l58���:m�D����I��d�9c�F�[SǭQwM&э����/Fjv"��&�<�����&�'�J>��/�~�~�BO\��G�SYU���Ze��?��섖�\)��BJ� ���QD�/{C8��Y�K��g��T?xL�ؿl�w�x ��cFqăp����/L�Q�7)5���:>?�b��nP_єϾ�Rf,��(�����:�<�?��y_�2��Ui��6����j�xW�4D�9C'����_�	�6�bp'����g�2���g?��yU�:`O>���cA�q�~F+[������o�ʝc������R�u������&��xQ����b�i��?0뫻���#�S���������L<�q���� �WB�r��*�< �G��}�!77��d �߰����8�Ox0�)�0��u���2�y�C��������'Rbn¦�+ Nw��b�;��E�G����3+${�J�yȚZSP�אyML{�����
v,����N���Lº�i�GEF�#�]>]�0��O����$���5���i����\���3�of�m�A˹��;�s�\,G� 0�:m�ˊ��&    4�=k.=��t��cM{�[����T�
�?�e54�Ȱ#9�^��\w�-���?5���n���#�.�6��t��Ǜ�9%��H�;)���C[�MɈk.bGUء��T��f�F�j�D�m���HI��.�FхQ0yȨ(�ն�~�kQ��}>buf�Z�VӸ����/3ظ�.����bWR�3��s�=�˘R�5pZ����� c��\h���\������}�qĝce{N�m_�<L���ǥi�9��ȟ�O+>cN�~>u"7�u��s�鱗m�K�=�09�+���k�B�Q��>�מ��ˤn|}����]�����k��3*Fl�q���}�9_��3y�'��=h�^�.40-�>)0�J�j���]�*9Н��r�f�GLF��
J��n��]~Cx���^	fc4:8�ę�Pz�,'�F��|�k���F(������gNY�O�ls�Y�aw׀FX>���N���o�@$�^�i.�&E$d־�QFĚ�E��JCš�b6Yw4C��U�\�5�jIh8@{��F�n����rf\�{x߶)�>�[�:H�^_8Q���3L�(�IT�5RT2°L�͍��8�or��(���
gW H�R�3�d~1�5}�Ф4�ʼ��ߓ9̣-�g)���+"�>5<fX/��-}.��:;����7m[��c֝�>7���z[agH[���֮�e��T98�!i��-3_��x�J��}��H�_����&���c���}�ۥ����m]PA��=p|D�_��S@(l�+	r�ъcq8m%W����j5a���¦'M��������me�F�tۧ
,��v�*-bnX�7�ok ��z�Ӧ�|3!?�g����Tֳ�G������dP�h߃}�?��h[/0	{;��q��W|�Π�V����I#s����(�pp�OF� �M&/���IE�Lj�Wݣ�B:n�ho�P4Z�5�ΐ6)���qX�~~a����g��m��Y`��V�G?�5t���mU7��77�K��뙏"*�����F�������Vo�m�����Sk~���HZ,��eP]*�����Z�m��Jw9N��ڜ�ks7�4�w*��uA#���FϤ���쯼��>�������1¹���Z����n�u�@�(���]���~Ӏ[�������>P�Ɖ��Pw��?d�"���Q�u�oߝ�����@'Un)0:$�s�8w���eԝCHC�kjo�#m8��ﲺ�߅��ɑg�D8r�����w2� �˔%O���?�VB6��1p�d���1^F��������Дe�j����L�d�4�B�I���˽|ݝ��]�Gʽ_���km9W#׫����ʕ<�a[o��!^��ܾZO��A��|.�g ��n�w�1��>�	,ɤ�����k�c��M��J���M^(I��\=j����֎�bςD��J=d~�vE������<�斚�-�]��1?mW��WJc:}N��I�o2	���]�����!���@�0-a��.������x�#ظ�#�&�0ߴ�c�K�o:T�H�[P:�n:�%�%�7B�c�a�I�)U�'���,!�����3i���K���+h�%�7��;�P��%8q�j���n��ܦ�gBn�נ�U�E��"$����D�Z���qK (��[Bb�w�r��Z���	w�Ɵۥ��U{PF �ZJ^S��P]��B��@�W�P����`�Y���A�5!�):p�ױڠ�D�{	��J�R	�n86�W�'�05x
��Ӱr����n�5	{h{5Au8m�
M@&skjL$0s�����\8%��<nփ"���ӵ�*jP��=�'L��6j@���t�o�Vi����]�R�]�U�Jt�����|bE��6�� "N�^=��t�dHo����]���V�t#��=�O��|�)B�T$]z�����u���gҰn�W�����F�k�R" ���4���vA�X?)�s�� ������əӚym�Gq>��(��S���;n�o+ރ�����I覑Ox�x��Ga)��A(��)E��D|�N��3S�Apx���}�ɥ��+��6rT8q�
q׭PtFQƀq�2'H�?-7"�Nu��*�nX��~�d��
�8a����8C�,%K�FZ�� �A_���#o�E-9Q�-y��d�J�+`���h.�˘���p��T��rE�9�vBm�DB,�J9��k�n�z��/�����I���TY��^� ��?��s����� -��$��Y�X����ۥ�?��tP�Y���k{ˉ���d�C�\!e3�6N��Q��9V�I&��>Ŭ�N��3�b�K������F��2^Q),܂�R������o��G�2[���V
�G��G����	&��
 ��MГ3��e�)Dl����:���'������7�5؃��9C�i�~F%ZM�e-Jt�e+ю�ˆ�	TڀgE/W�j�#�?k+�OBp;�hO��;t�������0)U�;Iu2����@gώ���prG�����]�3C�8]��ކ�2ǯrg_,t�'�Kص��鵺g�BZ�.$FFn��j&:t��U�ᇪ���͡H�Q�K�/�����\n���k~�z���.�s֐`'�� d��c��k�]Ǔ���kN��Q�ڨ��������?ya���%y��:8�Vqy'��h�f��mt�D�e��w]��!���^g�\�)r�|``����@�<^�x��!y��A4R� f[Г�s07,�r<�a���t�}B	�@9���|F��*M$;N�KErF�xa�q�I���p�7�/���{�k�.�r�����ux���kxP�"۠����#]o�1��6Eo0s7r�JQ�m9s'�pۗ�0��\B���}��x�9�V���/�L3�ZF�ԉs ���<tD�-l���~p�/�g�p_�~S�)�d䈼i=��*>eM�����1���vF�(S���Kȗm�7C<^�3<���F��G�d��<ۓҖ%k}u�>���kO �>�j�<�}*�yi4Ը��"m{�|���ؐI]�{ʫ<gѾc��(满������2��b�R�?���H�������?q�s*|�(,��U���vY�@ze��*�d��`���Ó����A�nWƷ�+>yb���澐f�AV �$�	-/�pY9K���]�e�I&�O��t3V��L��q]�Z�P�i=UŚ|��Uw�������:�ί���|~Rda�D\�@�ڿ��g��h{>1M,6��9t���1w�e����k����V�Z�U��#f�.�C!��Ml<M��Ml\���z��ąo�T��D_���~+���1ȌHFƸ�'��'�j·���i"}�K��%��pTٵ��Wi Ok�.Uڽ঵��fDd5�����o�oD�A���<c�P�����7(�9p�^� �6�<�[?a|;NZTE�"4�g�����;-�u�U�p�)��g�ݭA���f�wO��	3+[	�����gh�3�f�h3~�d���o{��]�Y'Jqs#]�Y�Ԗ�ϑ�vg�*���Rۧ:��|i "#�s�ᣟW��S��,)b�v��0�s�3�|g�c��x�,�Q��,����5]Ȉ���܅r��_;�A �K����~�m����9?K�̓^ϡ���(�9-}�m\�I7�V-�Q�����{'s%]}������V�/PE3���l�f5	䧻p
�׉e�c���	�)�6��	i���X��|��_�����L��#���b=��s�&l���c�h��t���ݟ�l�}�u������\��?��]*�m��}�%�������\�{w�z>:�m�[˰����(���ʋ�Y�4��/I�w	���>-[#��6��[��\�yĜ�yq0sd�����o�ʠ2�RּW=r8n��`t�[e��lp�<�K����u��2��̜�؃-/+m��0�߶2l��-���|)�ߔ��N��f��a}�y��tm�N��R��&����~�b���S�y����>���k�2ڥCF3F[k��    �y�)�|�����jc�Q����x����+ѧG��b*f�����Ep���}
m��i��}�<�V�����W�T!0��IW?ڎ\�� ��j�����t�Ř sq���3���r}��!���F�2�f&�@����$on
���So;Iu���ʰ�����¼����7f��p���=�Bvs�'��u��l���G���$fE�O��E���W?����æ�7*0� A���So�ӂ��c-�*9>�zL8�ຽد�@걺�3�=8wNR������{���6��v����B&��vMk��NZ�X7p�T�o��)ݞ���?&)�cm�����r� ��a1A�y���*�r[l���(��!%��Ҧ��Xg���E��S����Oȩ�)Lw����=�|�-��v�������?�,\��SBĊ��ģ�qw�h�Z�^F��P(P�n}cŹ�eհ���>���/�Fx�P����Y�"���K�Jvg�n�4ձr
���>P��D���@�y���9�L�Uɚͪ(D�ׯ:܊� ��?_��X0L���w8.����n��:q�h�����P��]ݒF3',.�j�k�F%�H�y��/����Zh��gDZ�3����.�н	�]:�{�A�X�wJ�
�I�E^��I�"��$�T(���I6|Q��U�Do��̮;Mz=��^�"Ɉ/�3�t��Z�z���:iI�+*�(Z����y�슎�c9B���B�\��&�إټډ
�į�S$	�&4�EjY�_�±��a.��O�]�B��u�^N�s�Jl�ID����L��h�A!	����@I��Svs|��)Ǹ?������
v����6��I\�g��Z�3zq0��).z�,~�$g�<M�4�*���UF�7h�1�W�[�QGO�e�������t��	%E����e����gi�������{h��9��Z���|�e+�������ޕYӳ=;[����r�7y�=����xA��`������o(��׾9�=M��w�	�+׿BP�ɏ��J����
��`w���Z% 8 ���4(B��tM�T��}�!�Gy64
��(�#A̵[[��	ާ�\��'�쁩�������@0�74=N@�
=�a��vd �k'Tz�0ռ�P�鹠]� Zt��Y�"��k�jU� "�u�����yK�a�z��kE��zx�7=���%�����ga1u]7���gAH	�Y
k!]���-ſ�I��go����>��qVN��]j��;/�Q��9I�.�f���;��sD
Nh넅,�g�:��z��sW��$�{��Z0����:}N��c����o.K!��Y,�����,\�d�<�L2�<=W���V�4W��%%���/vj���/�)�z�.3��K�m���;v5���2�Ӷ��!��Ǹ@&h�]:)�#h�]:ƨ�&�Y8Oj��(-f�3Y'U��xO�)�^7`�>W�T�j/�h��f�����v���#��o׉#���/2��@�c�_e!�lߔ)���M��`v��l@}O l��c���ZO��[6F�_ľ'� Jk������<���]�3xĕ`HiP��5�}�*_*�R��ї�� q���J*=����̩�zbv���C���eN��mȁ��&��[��X����o���a�L�B+f��m�@&a=9d��U�ril�Jk]x��c�iɘu����k��JƬ���4뺙����aq���p�}�l�	n�Jgm_��咑j�\���~�lZe���|�	-;��T��3�a�0z�����C�gܚ
2�&��rO�;���e�Mgͨmu���,[ɸ�Q���:D�xmԞ���6���4nz�P��׶��� @������1ۿ��X���R��a���8��,T�܅ ��㴻�r�ݽ�B�m�1�J��2n�ݜ.4v.c{���x���?F+��3HR�]�Z͗`b[h��|��1� �N#E�c��zJ�k�g8���y�c�l�m���@�J.����Z�#���q5�'�	����<��;IWg�3F�����<�v��TI�j�v�d��M��M�a3���`6�3�$���0���!#�K�BI[�n#��ְ����'�Z��Ɏ��l�\)+�!�y�*O�d�'_uրtw��V�H���/�l}�����<7��H=!4Z�� �n������c�Z1�)�F�С������#e���D���W�~�2]��A�U�9(7r��36ܦ�����~�/~v�M�C�5K#�N��(�%kX���S>�!y�'l�R�o�[�Nz~$l��+���}�t�3��-�M���c&M�N�[<"�M7�����u�2��n�3���!� ���Q��c�q��TC��u~�3�����s��;/:9���:i��߾f�1�b�����bg%c�N�w��#DWq`��-%��Y�l�U�iC�N�	c�
OJ8�b���\�
G�FY�����������X�H����&�����`��%}��z�I�T�a��
J#�$���Vĵ'ǉy�t���`�����InthC�i�b���\@��q��{���!Ԗ0��eʙ�y��` �h�Ysrd���Օ\UAmQX��f��1=�嶂�-�r�z1�Hτ��jF	`;(��z�0߯"���佦M�ј	2��Hzռh�\q\�g��v� b't�j�s��Z&����A�w#����Kݣ�=w�`f�]%�����xO�4옆5���@A**?��=�Ŷ gNih�z��[��3��Q8� ���l�Lw_�l+�W5�ilH�`+�ӱb����ǘ�O�[nB�i�u+���$�c�x'v{b�l}��kD�d���ӎ�6�4��o;�w>��ݞZ�Ƭ�m����/��1;��eᶹ�O4%��N����+��u�S}��� q�n�;$�B��wb�<�+��k�E��>���9�8(�bO��:��Q~����W���T0���Sە�7��T��m����U��|�.GxI����QDe����at&��G �B�䥌n�/.���#'�>�5������1� ¤Vw��wL)j��2��m���yg����fS��hV<��4.�t;�!��/"�� �*R�0i�g�&�}�|0�z#nt���?]�V5r���G�y��\xv��-;T+_�����t��KB���u;W�YǞ3�I���� _:LF�r��h��b���"����iI>�� `��^d�)8n��־F�;�K*��@D�|�+��J����<	�J������ƈ�=fo�i�=�`��> ����c�}�~�[k��SU�r_?<������"�9Y�Zu���nu4��'�M��w�t �A�q�C/�KZ��7�����v񣶟݆���L��3L�S�yړ�{<�=)��ϩ{]ÅkU+ɕg���Q��6�dV5�����އm&t���ۨ�$@�m�8*:b�q��cfY=�_��#�^W��;qy<�f�܏G|Y붌3:���i�9e��2��=ʗ�|E.�jQ(�=U�>����$F��a�nJ���89 �:�]�pG�}�q�Oֶ`ӴZΈ`�MА���lXp�# r¶U�-+�7[`�q��^���1��~s��e|��̴��_i`�L<�J�`l��8w(osl���`�+�@eM}���������n�F�-�d�J3�5�c���;�׃�f��h��V��ׄ�Ť����6!�Gs�mH�/�6>����_w�Lr����PRn�_��,N�k��#�+�on�����<:O_�^�|5���se,oP��r���?A�bD����!v�1�����)3o]�ݥ��8����;���]��wWf�W�q�:��4�0`��*F�y��o�'w1X��ʀ4
�QI���A8A���EX��J߽/hu���Q3�� H7�?�]#� �X��y��P C/E��K�x��~�QX���~Bi�|l����;}l���񸾮dl�U\u۰�����m�d�P�����vb�4íD,v�]�#����Q����{s֨:w��/��◬T�欹>c�    ���f��������x_gr|=�ӿ�W��������w��9�}��1K���t���|��5mİ�o,�0��˛�ɤ�YR&�D���u��0B9����?���l`4�Zh���s|:�|$�1��� 뙓����[�Rhl�Q�����)M���u|��Y� ����~Y��)$��湗 i-uo~�5�r(RxϪu�RS��]�Bi*~��}�lu@�A���(ju{x*��cԀ
�ቈס����G>��Q��gxݦ�	����sn^Y0>��_+��0��0|]�\�;	��!`w�}��j~��~?R� iR��q��{w��1&�����m�J���n�]���1�L��9Bo���*�)������Bq��()��Q�?�xC�YR�(!����Jv��Ư���i�l��K������M�f�ޗ�7�]�U�B��3�5���՛5@�H����q���'�����G�3���u��uߗ+�;�����u���fp�?R;0����r/���gE����e[o7�I�e6M��Q�Z�G��Qe|��ϔ�'���= ��ijBe9[�=� 7O�(��������,��+v:4��!'2z)����8��S{���Mq��p[[�4��<�k���\�� ��F�)u����A��W0��m_��{4|b�)1��Q+�X��`f�x{��x�����{�t��_/h��2��̙΂�n����S?�;�;G ��0��D���P����{WUǘ�$9����թ�Δ�l<�&��Q��څVpS��{��ӂ�@����c-��ʋ�n��ۓ�*��Վj��­���Z���4���s8�����"��o�[�Et6ǃ�P���Z���R�:�|���cC�iuS�W������h�¸�[-{GQ�J�hm5�̍ ��`rC:z���tL�6kgV�����_ҫ�b�a��q��ct��eݻ֖_�
���9|r�ý����o��B
�I��Ӗ���=an��m�o��\L��)Y��s�epSS����z�#�u�G:�CrX�(ݖ����@�ތGm�q���@�����`{ė�s?�g7�b�� �$�E�(��)����O��g�6��]f�ƀ�ũ�Wg��i_�{n�����������캞PG���n�:��GɺaT�[�������]�t[���5��A�e��TO/l����V���@����k�E��H|˸�vcp+G����o�Z�`��;s`[/��^!ѥ�u/ŏ�����r ��E���+x�1jK��_��*s��/ۥ��m��? ض�|؊�")x@������Vcj�Jg~���m�N?��?��<�MP{M��G1����W[��G0���������@�~��~;u�3Y��g���n��ޚ�O��|���C[����-Я�~�9���f�����^��4���d��K.�z0D��4�8�����w���h�=����>�'��nk+�5����,M7Y��1�q��#��+Dqcw�|����ҡ������X'LNtl��"q�g�%���Ë���~��ڦ��Ix7��K<_ж�K��ԇ�d"!��Z��K�am[�U�x���'8��'�}A��б��0mJ �"����5n[��x�=z��_�oҵ�ʔ���=���*#�o�;.����zȂV6���h����Y���eϟn�SD���K�^	{v���/� �@k�=aq/�~���u_$r�.��"�����3`��Yd�\�f�g9���`a~w<~n�@�����k}�O'�Q��i��1P:��ߧ�Jf7�~��6�MCw��\�rbX�;�ޙ��]ةݝ��I
�O���ۥ�0E��Jt#�x���������|c��9&��$hE`r��J�	I&��	�eҲ���L�#�F�G���x������e>m_���5X8�"	�(�}�I��
t�ݙgX۹G���}WUetdty��9��zSˌ��>
ݬ�i!���#�]�o���r��:xa#����z�$1��M���?�I����C��q���l�6b/�.�;��߻ ���������#�\��i�[�)_����R�ӊ���9���γ~�`W�?iV���q�GۙE�M�ƨ��/Ӱn�q�1��u�Nٹ���:#�3�t͞<�`�m���"Ǟ}󬗾�x�ٷ��G�{*��ƨ��]��Ǐu��i�9ƙ7�\]t`�s?8s�Bt��`1g֨W���t��q�� &0Y��6�������ޮV���	Dg��'YNWu8���������7��3���F1�~�J����5��:��>��+��1�����{����X�=ׯ�[�8S�9�1G���c���/D튍�1��:�X�i�p�k߈5<�nu����293ײ����Ӭw	���b�}���3'~t>J��O�{���.r�K�	6�@8ϣ0�ٛl�6�c��,���w���-�G�F�!Ms�]?���Hg�������W��ۻ�O��Sv��a��'�W1@�N��˸(?�]��N�u��3�P����R���6iL�;�v��ĉbۧ�(��?@�:��8�'����b����䏼S5-xZwo=}Rإ;�>⽐/�����f�K�9 ���F�p/������"���]� �Y�}��������+?�Ҟ��!O!J ���AI��n{F� �P�(���z��ĥ<q7��$�[Z	�eu���/j�6m;�����Y|�""�Cvb�o@��v
�^���K��}Z&�����]:��u�nEd�g9�TvQvL/n����ɰvi�j�jq[��DU�b���=ܿ�B��'�" ,�2�9i�p����!��.��`}�?J@5��O����\�`h�m�� 8;���}�^���%~�H7;�5BC��@����O |r� ��*�y���G���+Y������>1"���k������FC�}��yDӀ���]	;M�Z��.,���`�=@�=��艰��ʣ&��7����a;S�]1���9��a|P���;���]�Jk�~��wL}>|��µ�M���	l��D Q�V�;|���N��AnA�#�_۴/T��f��Oկ���� R�K:��ǃ�.��m`ۅ9m_�#*��9��sT�����^y�Xʕ��M�'N#���z�L��`�9�<p��a�Y����6��$4�W�� rD1����(σY�Cvݦ^Ow�xP�[T��,���B�@�C0ҨY;[�9,�K����[�X�	J����_�|����m�,�5��!��Y��M�(JIU=ց.���)�t��C��`� ��u�N����.��6��U��3Zԭ���f�F���Pᇒ#���FK�9Y�� �ۂq})DO��k��ޜ�2{?�4����z�����X�˝8mj~�����AO��?A��'=eYv
;�?{�cɬ_��Y=�V2�2Sr��y�4���i.'q����s�	K
݁h��?|���]B�̲��d�l���?y�?�Y��l��N\��Q��'`�M�{+fFh�i�eG�Ҡɖ�vIŔ0n��n�h���z���oo@��˹���}%�7��)�T�~v"�#���]����5�mzN���<��΍o�VX�I�a�ܝ�����Ɔ�>���K	{�m"]��]�p��"jo�/�yv�zP����sd��m4�N<O��Ɠb+YJ�ۆC����V;�դ�OU�ұ��ڶ^�T����劋A�33�L���6w�L��T�Εqy��w\��e�x��YYq��e�X�JP�ʸ0A.aY)Z6n��i�8+c�k�ioD{Bn�S�Uh?�$d����#*Jg��n���.}z�8��]���x�wL��7�����j}-s6"�RN>>)���kT���p_U�^���S�=�!S����[�֏hQ�w7�q��"O�ʯ.� ���'�F� !B�*��0�6w�E��L٤x^^����<��HB�A�c\[y7p���i& $|�w����j!`    6��N����7��K�ݐ�%���V�7',)���W��l�F��T���n8�p%G�@[Yq���Ś0]fGѽ�`o���/♑��x|
���-"M+D����X�f�����}�V>�=��c��T�����!����$�>����!EZ�#VA�]l}����sn�o�)l�$���/��m�w,Q/ձ]>*6�-�O@8`�7��∝��c�#]����.���g��+E�@Z�*uʰt��68qP��m�,sr�d%���_BZ�|9�.��f=�B��9��~ٹ�yg|uZ�&��=�㷙eͷi��N�3&j���B���>���rk��ݣ������>�re؛?2�_�&���m��.������f�R��o���ٙ@�'���Up�|Y�ߧ�ӛ[5�ma^�*��}ݠ���}t����Q+�,F_HǏ�
]��9bd԰���$��4a("p�ƞ�� ��x��AN�
*>��4�wҜ���<��e>Z����0�.#�����uV�ﱖ;,yKso���� -�We�re���vƕa��3��p��P��ބy^m�<�,�P��z7�NKo=������9]��Tڞ�u�@���iw�ҝٓ�/dLn�x͋�x;���Y��6J�7��8�+!O���c'U�K��ӕ����e�F��rwĪ�&�K�v%n��Ǐӂ�z+_��wZ�{�������F��c<�$�k���/h��eƇR�W��d�>$v[o���u	��@�u8x9mo��9���ZY7Hy(�Q�<�zH��� 5���V	i�H������id+���%&�^GW�q�W�J�0��
��)�=8�����BwW%ux.��[Z���>G�M��O���3�aG�:�����A����m����=8�yT���\;�T��kCs^��h�~cǯ֫;X�)�
�W�:]�r���ާ^��$�a�&9��91�!g���w.�m��\��	RQm/CQd�
y#��tH��}�J<����3Z=IN+Q�b�A[�8Rf�j���1�{V:I�&_a��E��6�Ǻ�F�>O]y{D`ބu���7���;���ў�N���6����4�����<��Y��f��	�p��S�z΄�\j��0�û�p˖��I������W��
�q����Y�}�ZՓ�.5ڴm�w��mw���:(GmI@���#�Cv�\��O�����4IS�6c��'װt�e��-�4�v�R;������ކ�ۚ]����b���V�ڇ;7p�b����8C��Y�{�϶^s�͘fq�Լ�RY{�r�2;��+�Y�-/�(�(�D�f�VKbM�k�c_�:�XŹV�|�o������2B��8� � �vAn&��^�
��V���Q@���\7�����"Ky�sWW :���(��ٸȅ$(<�{��n�G���Lf'���^_K��E��F�B��6��W�N���OO����F����*Y��"���E�0@��;mS{�+m�i�"�@��6�;������HeQx�j���q������$�c�l�L�aq:J���x���%�1L�@�e]����O�aT�����������*��>��yBgI17�'�#ڰ��i,�y��ܪ�뽻��b
�����=��2����̭V!	ө��yx
_��s�����_�y�X����G��>Ģ�!k�U�L3�,�]&L&f�~���UrD�^U��f3+G���(�{x�PWQFH" ����"�"�#���r�)���ԳNY!��Lq����̨.�ʄh�܈ ��^ �P8��؆�v�c;�m���Jx��e������|��͢��'qͼ�>7^ɞ+��^���#��ܔ��>�&W��S�3^�P^�k���@Q�K7E�8�A��WBS�V1�i��"
F���ZAܺ5�՘��{ڗ��X�=� n���w��j�V�� �U�h�V�[�����{��8���X|��v���@���p��n6�;���;d.�u���c�1ĝ�����Z%]8�x����ڻ݉�:l=vw yz�*>�7�Y9B4��4H5�����gMF�Hl�Q�Ⱦ^�}wV��i����rݱ��'�Z�C瀌���-x���o���f��T;O��-��;��Raۈ'�ʌi]��sơ{I�]*vKoa_O�<����z���P$	����������/��qӢ ���t�p��'�eЍQ*H���/V�ψ�Qfqfhv��~�tJ��t	J��9�����ev���K��_f	ù{��1�j��XN��|�M����YjI�e~)¿�̶h���t�
�f?F�D�
��	�G	.u�3�Z�}Fl����5؅D���NԭwwB��U`��q/�c�^ ੘�~d8���#k�}V$:׀ZÑ���Z�O���
��d-�z�n�_86��m4��N;S�M��	O�>�rB������a�%#��m��Qm�~%L��Մ�#?w�tZ�����T�	ه/O�4ި�6�X4;�ʄ�#����\��ۭbS��)�,�5�����:lXLEY�T	U�Aj%~v""Ɯ�eBՑ砆jl��F�"-'TFhmU�噷`�	/jy��e�HT�����L�w̝���<I������Ӄ��%+Z���9��m'j���N�*�[ !�>nz�6	9[Q`�o�<ϚD��
l:�7p�5��ro�ۖ��K��۾IT���&%gC�cU+@=mb��n:��M$4�.��S�6Oz.u�YQ�6N������mǧZQ�m׉t��Zт�Sc���u����&�&w�y�]�i-��]J��YkZ�H]�����Y��]�f%x�u�e����.���b+A��ì/�.V1�E�-W�X�̞�α��(/v^`vK����.�Y�α��S����?A�:�:�b۴:�:�b�yu�O���뽿�X&Eu����6k%��y�'�t�?'�$�Tb��RV]�j��X�y�藫{:}�z��H��rù���w
��v68a�P;��ؓ��3�4����cUt�`�Y;N�}�}�2R4�ه'�5Ǧ��X��ܯ�<��]]���!��q��T�&�P`r@�ކ��E�=c+�?=��������u�S��E�����Cd�]!$,l%��XyQ�z�/��NVAR����Cb�V��$TZ���SfϘuTIG7v��uUe�?!?��[9�[?y�KPV3.�kB3��~�tST8$%�}�E�s,�
��i�.�vQ�;�4r�[�
�*�d`Ӊ�!��%��z۱MV��M���ʽũS��c;p�-�js7xL$�:���V��+:g��ǯ�#��/Ň��}/W�гFN��i�Mh�%���Hv�8���&ھ�n���F���Tg�jL&�D��������,�*����Y�'��7��1�|�g�ch�J���o͙�*=_�cB{܈�{���;���Hm�<��ª��Dk�1���U��_R3��@'�yHG��q:|b��>m�em:��m����q���07�Wif�?�3ڙ�OJ)o~R�ۛ�B�^�x&a���[��PUk����K(7`=7إ��%�������di�B i>�>�y ��dmq���y �.0�o��#Y5��D��r86j��u=��:��!O.h_�Ƈ�cc����t��]btퟐtw�9Q(�j|�֞���}_��✇��';64�3ߞ�S�{8����<�<`p�:��g�F�3yJ��������mH�Z	8�⬂��m���>�w#B	P�~�*��hb��/��uc�o�V���J#�uͻ#�2�i3���j
��ވu��F�k�׊
�}7����	�9��vm�B���IE&�Ռ��;:`{a{��˔	��h��S$;;�P��#=�vԁz��v%t��gy�>Vw�|N�y�թ����=���.�'���R��{m�'�a�g2f���i��9$���YAL9jv]��$K�jY���|�C�>LJa���L��T.����޳��>z�h��_�����|���Vإ��y�5q���    _�Q�M�g����`Ű�g������淂zCR��]_�vq�b��`s=�B--�n��Az�c=f�â�(�������b͒6E���t��9ӬS"�����H�=�E�EI����x�|����F�p���}�o�]�_-�)eÑ�B�O)�r�0�aO�}��dY5�X�p�ĺ��Ө�y��PR2z�XeI� �B�\'�4��G�¾Z.��j" �ov/H4|\*����ٝ@����[��|��i��p����{L�ȑ���aj �� � �|~���B�8ӝl��2���t[��g�A+��$H
����#����N�@�_]�,n��dT��������˨4��p
����0~�־�ϣ?b���%�{���㭤Y)�j�>Ԍ;�6-̇t��Ȍ��2������4y��K�>���(N���(�o�樜�fiҩ��ѿ0��S�0\��Q}��+c��i�u5�w���Qs}T����Dx�_o1�|������go�Wa^^��;��)�G��G�T�t�Ē�
g*�N�{�6��%�ӏb[fa��VS�~a�Cˏ��̑Y3�,�����G��#�7����wl��?Q���t�����i�� �� �WO���� ���J2`�-Ɩ�v��o:���),��J�fX��ey��0�ۼ�w�s����:�мȝ�7E�AͲ�ޤE��]�����a��9.nC�;�X�/p�:�朋Q�> h���)V]��27�23v(�iDG���zuT���4q�<d�5I�|��t�y��Ҿ�jD�dn"/;�D���>��'�e���x�~��)2���IHwVg��R��UR��}gM�HK�r(o����s���Xu���M����9Q��|*$�����O\1`S�'��u�vx�~<ŭ�F� *d3�3��I8�u�5�/���S�AT	V��N|��f�7��'O!3z�vV���r���Xj�)R��:�pm΃��&N���.��k��7k�AS�A���}� /��8\'����)ˏ���JG�n_�S�g<Y��v�u��^<gv1�x�����
���S�2zU���k�&?�R0���@�D�s#��xzt��0R�ق����/De��i�š��8Qe\��wS6I�rfF2}����������i��ts�y*�;}��^WY�ꕣ��������ɼL_���ʟ���]b(����*���6)U�tb[_c�} �¤��u����KmQ�^�����b-خd�ۿ,��4�	�
9���#��ZPm���܆z5�p�.�&��͙��O��c�s=`�>~��b���&alPa��8�8��1bMޮ��#��y�CJ�q;�ævC��T��R��K�v������G(��]��8ZPԟ�����ZP�1.z&o�H:Ͼ�y��)��M�"�4���}�ϓ����>�˶�`3k�;xG_�h�UntOԫ���M�cֿ��#4�m�w?�w�+,��o���p�}"��tO�k<㌴��A�	e�]�j:ʭߩ@YǷ}����0j��'}��4bL����kn7��ַ�R�N�>�W��[H�����XA_��+�l_�֗�{�,��3=/Èٳ]������G�͏U��3/ì{��|l	��i������	=BR1�Dٗ���@ϛ�Yz[���f� �H��g<=�.m�(�ٕ6�i���!��j@���M��7�����������[m��2�����l��!��<�Z����D���Z�#��e1?�Z������J��h�p�/�6���m<��~gٟ4]qx������W+��R��%Uw6�C�c���i�I�Xts��x�LfD��,Md�8�	h�I����@��}�j�*��A�f��\z"{t�x�(���L���<�)꽻W_��~�>P��2�򺈓���\rD~�tj��%�y��,�F���I"��M��C��=.s=I?��e��)}�̰k=��>q������-��G��Q�=₍!dؾP� �Y��u�|��E��q:cR]룭%D�?Q�y����sxQ>s`ߜ���q��O�e-aX�E����@_��<��,D6L^��B�|��ݟ.۾�б�îY�^�\�gz�#�������[�]!6�r�^TvӧL«�����#e��hD3��2`��KF��Y��^u��s�S8��K� ��^t-���b7����^�������z8�o�%� _��oYu�9�� \��S���˹����.�Bnr~�U��5��߯N�"t�_�S��dh; 6;���o(G���g>����	�`�Yo�����������\�ՠ��tGB�1��F�m�d#X�������ZAE�߉.��.4��"�G�E��g`�'�f�.E��ѿ���
\s{O�%\KOl�ʵt_?zỳ]�A<w��֬V�*�w���J�Zn�,�@�7��BrW���[B��E�\8��$�3��?}P��ЫygmY���o%����bmu(��k��J{8���%�!ym��Z)��ݥv�}�ذ߷<�#��-�~�l��l���q��!���>��\��=^Z�"3>�:O��o>���b����6�͒�pr���|>s�?�hj�����8�S�'t�M���h�!w��!c,��)?�e���,7v�Sr�D]A64�{xx>:��)>u)6T�:��ҝ�!���;�`w$n!)����o��?O�j�\Ǩʍ��cd��$1b�W��ݟ�N�mR�����-�D\�غ3:���|�d�4N��1��{��͜�v�w���%�6D��*�����%��c�����e�q]�ퟯpou�a���l+�%Kޒ�"��C񢤈<�0󎱫v�Z�&A� &�Y�_#�I�nA5�,�.�&�m�v���o��՛�0���Ϸ�`�UK*'֤F�j�7�U�Xwԋ.�s�ʾ��H։RR�o�TӢ������{���y��:񃏚G�>�w��v�N3��5���n}��[+q�x����3l(�[8m>��IU�v�SМ�H�x����������[�?n�'?1@q�,-;H�C�2�p�?^��m3�WT��=rq��s����t��V���A�8Fػ�Q�o��N����#7�vn�[?F��.RH�z���Ʃ���zD����޷�;(W�ݏUnI�+�2�Up-���{�x���sJS�#��y�:K��j82���1�Z�L�a�>O'��s�<w�ے����}��yʔ��t�+���/#��^^BR޵ֻ��E�rE�"z�+Ey�n�u�}����17*��7Q�k;?8{��oi���.�R�i}�ܟ����.�I��+vŖ�y.�=n�����=HK�m�W��;���$9BЏTl@lTa�_��B��i�K8���C'���3�i�z0`�H�������#�F=H����� ��
Έړ����m����6�v���ݕ���UŻ[ؾ\�9�������I
[�б�-��ޘ�و��Rӧj�L�^Oi8��/u���g�b3���\Pk����G���U�_�j˘!�%�2�|���k�B����yu�@tm�g��ԏ�o�����ۻ���M����8�z�G�v6֙|�4��TN`�g*i�rwY���F��v�v0L�ڿO#tN}N�ֻ�+av$4�L�����r礩l�ܟz�zrD�>����4�_��[,zy��[�#��ח2�.�0s��w�=�\mj���BQ��� ( �aS;n(]UV���l#��%��g��Q�)���'��I�5�'<q�����<:͑0Sq>�dYJ�G�5(}hSހ�{R�"�UǈzkF�� �o�ƌ�#5R��vG�'Q��G:Mkk}��V��2.�p�n8̞��(I��!��e�e��s�����X�7�D�6U��]����K���;��td����� �}�A�SH=.3���Fa����\cv����=&:e�_�w��Jϳz��7-���]���l�"�~'�Q<I���$���>b4�=k��U���,=|~N�\h�n��g�    HAc�3T��O�ShP���G�x-g��[;�n�3t49xA'!�L�Y�4^È�ﭶ��}.q��f=.�j���E[����C��Past�#K-�Qq.�?A��0��ҙ��r��N��W��cB��0i�co���s���i���Z�&m��{���.g|��������;>�S�a��2К,�{���}������3hWQ����yP������5����F���(���
>h��^`�_�K�t����T�]�W�?�7I�>���ƦJ����Ү��	ǌr����q	�>y�U�`~}�5��T�Q-9�k�D�$f�/����|��N��Je0O{i�ԗ'F�]���J��-�W/�3��4tc?#�R�l��r�N�E�
M�z�!n oI��B��8	�]�z�� ��l��������;9��>�}�\oL�[N�{��$U�;Jm�N�vx��)�;�B�"���:�}7�����;�ZGb?��&��.�o�n�+&�a�U��m��y�ԓbĔ��r�{U��[l��f3])�����Jl��WpZ��[�D�;J�� -i�}��w�X�ٛ��W�v�t�^	~]Wv�)Q
5]�Y�^YNV�<���s{�^�~����J`-��D�s�c���2Az�p��%��΢��\�	i���b��ӢK�Y�v��͓p�!攺�\��o㖶�&Gy~��PO\G����#V1t�� N��HD>h����GŚ��s�w(�,*Ċ
^u	ZndC=����p0>W�w��Q[�Yɓ��3$�Z<����;�N8�p9}M��n�F�$�R��j�_ܸ����xzތ�v�O\<>�c�����*r o�Ԕ�A1���R5�^v��6n(���][,����yx�<n�/�{"��q�ԉ#�9F���6{O]j7\l럻���ha�űS�v����$���߼d�O ͠<����wlb�{��	4��u}���#�����4�y���铙ұ�ξ���Kl��)�!;�=�|O�^bg5����-���Y�g?r{�j��F��L������+~�{
�3�Q��{i����Úֹ����m��e����'�;J
!y�P�Y��W�X��g��$}�G���=Hr�`�� ��Ֆ[�~_�?j\�c��!��[蝷�*q&Ij6����+��P���f�泽�t94@=��U��'��?��
�(�̮�{���p�,Jń1�TFr���8��EdZ���qA�?4M&�ͷtL�5�v&��d��>��㦇ʅ�M4�Wf��~6	����H��a��`�b���B��D�q�k��;@���T���i��+�:�@�'�v59�ӈ] �5��·�C�P-ؠ��W��t5�\�����*';�lI�YB���]���hP��r� ������-��ծ���[���.�Q!�2����ǟ����U��v���u������}\�Yn��G�&��}/���CK��Z�����<&a="}�wZX���d�d����o1���]�݅�C,��7.���yLA��,,�����2����[��;��k��n�P�0�Ÿ�e�" T05��TQ��%�����a+\��` ��B�6���!?#=�{�P^�s�TP�o`K䟟5��9l0����ɤg-��8�+=�����>�=ɰ�t�O�����g��)*�O Ns�V!=�I�9�ޖ�$R�� =�I�8�C�DZ`�P�x����.��ƙ�v���,?b�CȊ��8�ڔ�i黎9�B��5e�����4177���eSK�;4�uN�
�W�tG�Ģ\ij����Ak�� Xdŷ]���Ӏ�n���� ��4���0�H.6�n��Rh��p���Q_�9�����ە4��[�f�gΙf�`�l��A}��r�SmL|��8��)�.��-�qJ��%¨s�=�ڔX>o�weW\�}�F��f��#���'�qؗ����W�u�wd�n��/dD��`�1 ��[~y�.%N�n�P�X�%Eb�}F�&�y�MiQl�E�ϱ-���e���s��K���T�P�^IV"L�	sӣO:n��.T�L��i/<cP�L���yla4^ݭ�4l�}0%b��М7aB:��)$�K/=�4��X$"s�܁ŋ~������#�/��#��L܊��a���X4��h�E�`����^4����i~Aҿ���{��Z��+H����HB��9�h�.��s�p"�iyd!ɚ���iiO��]��Hܳ]%,���\���i~�F[zI�7�?�p��RE�_>��`����V��T/\8�&3�~�ZC1���T͂D1Rm�$�09Ҹ��������������:PB�>>�"�5��X�<�����t�8=�v�"���4��V0(1�^Mέ�%�$f�z'l)$�~��������J�Q��.7���,rH���`�����
:=FDl	ٕW����p�֞��k�)&<�%�u���L�ox����h(�"��I[#�vo��,�L7近��O�.æ���n�F�����Od�;��l�Z$�����76�a5�C�m������ǻ��yC��F�"�0��?.����[�q�@�č��}�d$x����}v��{7v��dg�'.ݗ���'4�D�י��a�YH�B0�J�W*S�l�)s���:�����(�c4C���]{�'��L��_�J5$��%h砳�0s��K�fZ#hL�Η��`>��r��?����:����s��L�<����!Pz�a�ޟ�l����%�y��}�sB��̺������M���¼nU��Ա̌n�.������N��9Az����3�;d���҃�5p�j*��Z_��n�3�U����b���;e�
د&�
�DNJ�B�¤WD�x�7$Ǚ�1��HA�_��H���s��#�r�%����AA�,7ھ��d�r+бZҫj���9���V��]�:�ڪ@�o�hƧ{�ܨ��!.�eR���v�����d�&Ԡ*_� �آ.����e�4b+1''C@�W������WL�$n�iV���h�?;�{O��Њ�ܫf-���)Fg���rx#�X��w��Hh��V�e�`N�K�YK��u;�n�=���	����;M�3�#+��dk�,b�f,vt��s\/�G/V��?jeuD0��,����*ǜ*[
������O��i��p���A�d�|��L������v?5�o�̬��j���fF��w�ڇp��l��U���׮��C��V�iϦ�v^Е�PwJ'��9��'��������Q����s6��ݍ̪��E=-tVkK� ��q;$�3�"�����/����C�nZ�<o
����o�9���/�{�6&l�>���+� �섃��?RB&"��n	��-l�ʣj�o��\�f��R�R��!k�t��F �l���_M�� ���gG������ ���n>���H����e��^(�!}}����j����hG�-��_s ����>k�ȱ��W򍑷%���(;ނE��;����V�Ù��Z�2L���0���
���me�^ڕ�~FĠ˕T�ǹ�����R��-^8V� �(w���W�*Ң��՜���C���C���*�p���*�R���������0!��9���E+H@�9�tK4��j��T��Gv�<�>a*�q���IJ���J�~�c��{���$��� � ��wO�cТ�,�	HV�e%R?a1!��k ~��#�t��ͻ��A���,1�����)��6a_U���%���-�@��a���)j{����cG�`'��u��g/��Y�^z�8��ٓ��1���ѷ�p�Ds�l��}찕0}_��Ͽ�F6�S�h�ΊwǕpX->�/��R*nJ�"�{��X��9bE�K��#հd�Fy���E�ޫ�w��=�eV�_:�NQ�������h,�������W��[�yPZ��]�'gA
A���S@y=Υ�@e���v;�~����,3��oFT�����j�u��KU[}أ�� 8~�Պ�g�@�Q���    Ք�/]�
v�3��k�JS�6"
�6Yƍss����ʘ�	O������ę�K6����딵7��*���:�\i��)��ju����o��n� ���aS�O��5��?k��a�������Ic�&`ygc�(�I��?����Ʃ����n�~uKJV������J}�K�L��5�-.��D���;4݂���~���`�?���Wr}Wߍ�]�~[E�-�j�sI��K��,ΚYC^o�I(�j��r�ۣ�c�4n�gՠ��ڹ9�����xw(Qok����L�@�5`_UG��j�n����T(�N+���a��j�{�����iɴ���H���kc����?���S�̡�q4)��=�VI��Ǟ֭d�]��=���X�	8�C��p��{@�$�i�Y�AbL	o�gG��R1` u(M���@�yo��܎��X7B����+�]��z�'TĊ�`+¡���r
![�V��imj�z�DX~}�̡�7�qZ��	w���R�d����9D��g�3
%a_*u��[E�Ʉa��:e�������՘L��r�&L�(�������Y��}���S�f�R�9$�	��TY!yM�m{��K\�����"D�A��ח�
�B��#�����v���/s��<' kO���v�=�)�QO�'�����]f��y@��asʧ�
_�?���䩌~�o�}��3xk����=B�c�م��X/	HG�Xt�tẄ.vi77�pp8�(�5��kIK��p%��"���%���Hj� &q�nE).��#y'��?��D)^3c��S����%��g��	�k.���Zgp�
s�uZ�?��H�K��JU��	t��&�P��+���{�4w�^��;m��O��*�@YEϜ�Z��$&��f��2�2��������2#Z�J�0�K�gF����*?|^�sd�pρaڿ���6�~�*�X��fЌ����T�	�S�p�kZF��Ү�5D%L�:��v��2�k,n���f?�%����O��K��i�0�/�v^���?��B�*^���ܲ�Z����=�����ο������]�����AkX��S��Q%�N)$���/T�yz2�O0�H�Iy���\r\���i'熝�PD�eY����������ԏ��YX��]�H!�p�C{��F�'RƉ��:āe��!(���O�[j} ��^8�cڰ �K7�xy���5�]����Iy�=��F�,�~�;޷���]�;o�=q5Ԭ'r�˳��=z5��_հ�umoVڞ8]��\oG{�:�:5����.d��,��jr���K6��J{̂��F^ឳ*����Z%�(�����*,Fc\u�{�L�O��)�>�e�'�:K�"�?V��k��{5�[�>��T����{km���B(Sը��3� ǡL�z�����ǀ��\� P��f	 p?��5����4����2ը�v�c���ߧ�nD̈���}�u����=֛u���X�,2�d��>b���Uzc��&ƌ��Zi��V\�=����<=����aV@[�J�H�3�-���������V��m�\�Vx{��2��p���<#ћ�*-s+��x�-Wn���i���{�e�~ͭ���Ӵ�K�z�o䓔��������Q�H��/vMQ�5sN����e���/��Ca�%#��߯��M��O�}J�����[�+/�n3{~D��08ջ`e���Q��0�����	=��[�Fܚ�� � ;�4p�>�~m)�\pku6D���iF��逷ye-_��pT�����(��ߙ�:�e��X�V��'F)��b��.e��6�����zn�L��O�bGo�i���j�~�0۪��s������+)�y�U�`�����-'�Ҫ�:����iZ(�i�6�*���<!�Ֆ�F�;'��:���t��˻1�{wMR�)NBL
ظ/5	��(vC���`mU%�=��{�8 ߎ=v��&u[��nF�Yi�.�>օ�?kR7���6͘�3�D����3�P���e]^�����$c���*c��ǥ�, �@#��	s�t�(�_��k��A�HZ�%@{�s���L!��A:*���ZV��n6%��fa�r�v��d���7D�x�l��n��"��5[ס>ܿ�n�Xd�?�:o��Pz�1��\��Q(̺�{�㊱{պ�p�=|���A�{RyeP"F�~�;|�T1����$u�|u8+��s����
�T��S���IS����X7�vV?Ug�n]��:߀t��,=����B={=:����b����7��$��k�;�#��$��J�I�K ��C��.��Q���wD�d�>7�s�;���*d�E,���|�{�6�$�g���*��E�;�=g!rD;jRD �}�`c�wʧg�7
?��e���]��_65Yl���$�V;)ȫH7�}�� �k���(U�Yk�Hbѵ�b<i����5�jp�ҕh�j[;�XTف蠥��YNZ�Jx�mk�S���y	fZ�r_�O���=�7�-$�h#t{r���X���N5N����`��p�85�͗,��wH�)G��y��f{bx\��=��:��.�f�h����F�N�����ҥ�ií��ln#��A=O���<���t8�Ҫ6�������vU�7�9�gL�5���A�IȲ.<r�Ӷ/$K*
$�!4R��+�����0y����z��F�o�n��#��*K�(x'�es�h�o�f�2�>�&��ʣ���%��I$	M����V<(d4����GO�{T:&w>�����[0�����_��TD�݃�!��7����#��({{)2BƐ4��#�O?Z!�Big-��= �f�R,��>���x�3��s�]�P���t3�x�;����p��<��}c?D,�4�`p�;ʫ���44��\������r����5�:ī�M˓ª�M���F�J���Ǡa�A�x��֦�/[3 D���Z��@�\<6m����q��보�b����E;���V�s�5v-2MQ	{�T:O6�g�'^�~�[��'J���o��G�R5���JZ �X��u�W�<Z�,�T��1��VLD�B�ၙx���z/D�hF�y��.yU�`H+�"�v��]'���2�d���SR���g�m������,#1ځq0>ED~K�М�c�h�s�c��P�B���4��k��^�AD�b�i�-���������j-R�Y��]'&{j�� �38�����#k9Y����(���c����or��H��O�aD\"j�x("]�4��9���:0�P���O���8�R�	�jgX-��n*�:c
g�I@�m���vD:��>�����kzJ��ۛW�E>�ʓ�L��P/r�D�+1C�\!O�`�J$�_DL	��d����Z�
��)���9	"-�s���c��.�	��j�q����5�hX{��[t���OȤ%�H��"S�ĶW8���nB2O@Y�j�EA����Ef�ƽ�;k�D�/���3�V�E����~j3D��-�P\PR\���߈�xS�-�[�c!�R����p(疩.ImZ4OF��Ȧ�S�qD�Hǻ����	��]}[�zD(m�uW�+$0�ޠ���%5���&��$n�I��_�>D0�"����rlt_WE0Q�ۃ���~ia���N����|-E�e��2O�IW��.�x��xm�1��f��/��=�ɫ7� �W c<|��dn���h�  ��ACt�f�l���tq�6��k���K��L∰%�S{���/nc���9�m�v���~��|�Ɯ��#�BM�J7"(l;2P6{̹\C��,A��0p��=�����>��̋���*q}Q{o��=3��'� Z����^��>�Z���D_N�Nd�݀'Vj��NbIG�A&K!7<��Cz���0w�r&���ң*���Ը�	\6��8t�P�D^���ŞA`������+��mJN��͐�N�H@yn���V>�@�0��(�E�k`��N��I���4w�~(?    ��b!�acQ(@�Jnc� ��n��bP�[8��r�Ϙg���d���^��~INF
;��7c0m�~�[T#�b��1���l�fT5�Ɲ�៻k�j�鷽r�s� 7�oO��12 i�;jL��gJE�� �$J�DwZ��|P~&,no��P:ղ\����oq.���'JL�5[�8��n~�ߎ�~,)F�����uU��-]Xˣ]q0"�QQ���ӈ�����f�[��NK�r1O��
^���_mtZ �Ad�R`��a�Yꌠ5�4���T�$� [l��li)H��ڱ�[_-k� ��)���B��b���b�ux������i��d��Ԅ@T��t�/*��Y�S���/�i�sx��E�ь#(�
�(ՎS\3!
�����Pa���ˤ(����G�xd ��[q��$����q·E�����i*��(��x��Wg��_\���D��w�V���[GDD�2Q�;t�kk>�d��Enӵ��e�DJ����,�#u�dEX~�u�+q�2�G�#��:��h7��/)�s��Op�B�2jg4��De f��c�OF_���o��w�D֐2�Ȳ�G̰~23,����C��v�g��׹�_� +�'OԤ��A�=x$�,��dDZ耥:"'��[�DZ� v���dB|D,�MԜ߶��K�5`�8��� �W��Q7�'�z_�!���ʫ˄�Ub���������%����
4���L¹�����1����YR�_�{�6@V:�����<�h>!I �:�~I. %����Sx�m_���P��m�� �(�^Pix��?�a	��ޞ�4g^�y��� �_v����ڣ_���+\s�9� B�u��/�������bF�����/N�C�[T�.0�u��QI����3�R���	��m3��w{|�AtGj��\�J��#���>Zw�os|���z��gm��Q��)A$��.�Z�?l��t�-����Kh	8$5E�=��vW���?(���$)�,�Y��[ˇiW�����A���AԆ|3qW,���r������G�ڒ��gY��ז�~�ў�x������O��3�N]�N�1������ ��p��=~�w<)[�_��������T��[�4��:_�*tKW*�r�E|��1��J3�����2�N����J��rN�"j����wi��eё��3�偿�.ԋ��Y���Y ���FL�J��*�V{���*t@ۋIֆt�qs�*p��Ǡ()ҽ'v@��uK�@Y��~���wm��e��>ԈBdI�ވ�o	�V���aխԌ�S�U)sF��m��k������E�bc�w�)*ܕ��u"{�M�<��Z�[:"lpBO��p���AY���5x����Xz�.��IS��V~�|��ķF�^Y&3��a�/mU��v���-�y#A�����<�?�:'g��pA��ކ��n��pu�!��:3����p�L�Qu����y¸���$���̀ ���v� ��P����9.[?p������ݢ-�~&����&���x��NI(��|`ʖ��k3�����
��s�O;���������t����F����סן�F�[{�o�{���{����Ռ�G<�-%QB�#�f�������K2�l?�֢�? �j�7���q-�޳��&��Ý���5��.�a��E�P��O�[�ܸp9Ea��s���UWnGk�H+������ɹ������<�i����VM��DR����r�p<"1��>�����f'z�����B�hr4 ��-������F���	�l�.e���1�VaYJME�a#�|)b�H����9�53����k�Y�d���F���I>^F6ĝ����^��g�X��i;5��;c�D�`d�et-i���OTOkyXȼ#����gF�� a��Ң$C�9�~t����s��s�Lb�>�=`�|���z�� �s\B:;���>� �8�;D��z�'�y���j�b�+"l%[��ģ_l�
�2��h+�C ������i��jS[x�>��-8��'3�͙���t��y��m����>�=���p �iFe�]!|r���27�}�1�	��*Ύ����$:�C�x�(��!�ЅM����߮��P�6Lt���&�Mѣ_��$OT�fi���׿�������پ����ӳ:{���[��w���"U��j��/��w�(���ҙ��v��y����6�(��j���HZ1������э����<)��{Na�23����n� ?ʐ7��1��7�.]p��bO�.K(��J_sR������=�����&f&�\��`F>�YG�I�8��nYF���ȧ���F�˙��فߴ������[IԎH�/�&iW��h��xsS3�wU\~a3��4`֙�[w ��-�<�ƈl��c�_vK��r���J��Ko̿�t�/l��R�<��Ͻ��BDI���:�z9��֙W�U@�'+�[jGj���@D�P��n}��`�W;�vY'V���+0|�p��z�JP��������t���_r� (k������ݲ�!��.�N}7��`�Ŵ!'��ߠ #�UΠ���j�������p��E|��[��! �t���N"��]�%�L�ӈ���J׏��n'p�G8x\��ޞs���ޞ~q��ѥk?Aa�1QP�r�ny����! J�-�o��lGT:2����l�l�)�V����9�1�_�j��~�[�tF���<q�2��J�{b��_x�V����UEM��X|�]�����CG`ۻ����r���%!�BDp�x�@Y�����̣)���OP� �=�a��;�1R"�"*��.��=�x�|L��lG�Y*�tt�8\��
V����IW.�+j��5����S�L�&��~TN�P�,B$-HK��)!�F�C��A8?�\b�_�8��p��银INL��	�I*��eq��2����u�3�YO(>9Q6tK�'Ŗ�1�c�?����ӥH[���Hk�Qt�|�L�irY<�1óq��2��?�ǔ��8n��Q��6Owv����,�<�_r�nc�����|N�~�;W���Ғ;�.B.)�b�"��\�����3s��K��\�ùS6�#,M��A�S�Z�q�'�
�/���Gp��$f��[6Ȇ/�%n��7HRQA`��{E0�R��8��e��s�QY9Nf��>���A��{���Z���g'��	������?p��&�\��$I0O6[g��I'�v�mD�ʆ��ͪ��v*�G$|v�Kb���N��-)�G���w:H�ȵ���Q���dw�ֈT�������˓��N"�F>ɁSD�\��~�،7NHXo�r�GT0+@��(_�je��YБoǲři�1i#g&[��"Қ�od��k,�~<�qA�cJ�����bֈl���X2@)AYx�ƍ}Z�K���v���aǦtI�E���8��p�A�g$�r'UHV('�p)��fE��G�?2�J%�tH��>٥5��k����.@kx�*qr�e����Yc~���pf�:[�^Qػ������[A�|�b��-^Z���������M�4P>�JW?bl�i�����{��+�˕�_-��>�D,>a5?x?��Ǯ�"m�l������U���~�#��c\1	�;�U�m��P}�I��i�[�_��S+do��g4��=�=*�V��k�x�ZT�hʜ₨�R˷���YM��4a���|�9�lj�1�{����}%$�kB�/9�������{J9��;Ti K�/w�``/yU\aD��L;��s�,��ܳ���I2�Q�ܤc�PD�K�w�����rR3`�	�v�AZҐ��ܲ©�B:ރ_.̫��n8#ف��g�o�F���t�5��L��[5"ިyi�Ly���!Q�8����i��I��[wl������-:�,k�uS�����OljP��Dm��:���a I�#g��ˤ]��yG.7+[?�G$��+�    �N"��4�ę!�3��N41�9+drN�JM� qJ�*�P�֏����?���+=���6�v�����4��5g��z)��D~��ǌ٘��>әqi�����C���0vaw�l��Zm��ɐ�.a�_�K7�/�g_~��UfAX��is��t���PlA<��k��$q�C��v��x����z.y!�]:�{���20f?,!���GԐʭ���>Zk��>̹�L�+�q-�y�;��$v����e��_I�~���a�z{����xc�Y4q����E�d�yg�2��p�r����(��M�-�4F\����������S��pJp������(şF��A�C"3��=v|����r�W0�<���C���}��>�,��1jp�T�+܁ad���!���}���>�W��{��G�y�b\��<˶�{�J��vM����������Μ*>�?�ꘞ�e ׏!�]�yVb?ߐ�[0o��^mNl{�^9Wi���<���Kv�����2����rZ�#XҚљzq���ѷ�}�V ����Z/ �s����z���U�ߔ��6��,�rY5F�^�zk���1S��-�毽���׏*wD\4iE���G/,o,4g$3�����<�25����5o�-i,�G���j��"�}t�K�U�'�̎ݿ��}���/�OD�F��{I8��x�N7��01$1w���{
��Bn ƔRp�)��>}��M��]T0���rh��n�!�܅�[�5��gcM�s]��]��K�㾪�?�V�jO��טB�JYU�"��H%��Kfit4��:�}e�{����"���5��s�|̒Sk|{��%5�O}�ni�z�����7e��C�u����O�q�����0���]��|�V�@<w�=�^���|���R�L�{�i	�X�		�)�LJ-ѩ�E��8�#ox!1��������^�����}����f�����;d����M�;����v��Td�r��v$�;�͢8�������>�e|_�+僪����W�9����}��S�`�@�=FYۅ�TRy0�N��5�qm#������X[�Eإ?�^�$M����8k���[Eyg^l(�ipJ�o	DiQ�s'm���]�����B���ܹ'����1�}
S�CdQh��n��Np��B��(N!�.�GGc������@�40�jp	��L����(M�@&#x٣�+������%\��>�%�%���K��ȚIx|�j?���W6'�^�.|�]���)J��D9�)-��ս�?��.ђR�Tݡ[�[S��m����Q��`ϼ�|�r���LI��ڃ�_	�KxeS]n��j������JLx�������<��u<��{�ůC�l��I�]�f-��~�d�n�<Wm�����wP!��Kj׹z�F�l�}�MV�����]cp�O��n�O�f���,3�oMv=���G�
�jj�84�w+K���k(��M�
��� ;n�s�B�_�]h��,�XxA��D�`�֞��>��3�x�	K�-�/�&��AS�j����F�ŝE���pl�)�VE�N��37-�4���]�#OXd��_����fkp;15+#<�[y��hPz2x-�K�iK�H�ܹ�9�඗g��>���ޠk���؋��A��0>�������� f����&�,�����e�M���� ڇ�v��r%�T���ͥ����,��{i������������g,�#4<�4U����zI����`*~�ԟ��i�����<�t����SX�nz[��_a�X-rm#���/��#J1�^鳐�;�^?�S���B���'�.�؅}�g����?&x.����3��E��!�?4Sv3Kc�׹�D��EȤ�Ы;�*<�[��v�:�%c��y�ѹu� C�����ߕD�G~R]�e]�0Eɰ}p��˿F����^���فM6.�pM���=�V
���M����{�翾�h�4Q��Q����3˔:������Eٿ��dq>\�xi��P$�'��}���bm�����b᯲Ȏ��"-��U�>�S�\K�%�4���h��t`��=%�2���KS��_ʣ
P��g0�P���Q~������Ai`X4�<���to������vݎWY��IxT��2qط�X�]g���[�/��������%���xm#:��.Շ���k��ǚq���GNX`ݤ9|��U���&v��g��ݠ��3GКVUUk�W!�ȳpo�R�f�\��4��3�%�����	v|X:)@E>/�3ql����`�Y��A���gbX)"���n<��u~��I#|U� ����GNҚg����#��4�C;��"v�
��K#W� 4�Фc�ap�ڝ�����J���������|�>F8@����+��S�Z,�vU�]g��jܦKY���R_�e0˝�Y��=�
E\�7#p��*��E�
�%U�}�#b<[�xd�[���4L�`x�$�,(&Ua�y�`�c�@,����W����rV���Ěgm�$~��b$Uf�Ώ]~�S�ҁ*5[3\��PT��3��;r�G�����y���#������ބ�	�x���֡_{�S�G��k`��A֤*��u~�@˧ʊ�?}A�>Hl ���C�Ê>��Y���n�:"}{P`y���ԛyR���� �SA�W��A���ܵ}�ʕܠG|0���+�A�t>�׬Ut��7n�4�v$����A7!J~�����������y{U�ũ��߷�n���:�_�Ð"/5��2i�"�Ёy�ȼY�V�4�7�UI��.��;\��J���*ٖ��
��t��_Czxiߧ�,�>iUHX�2�8-��� C��x�������t�%8���p$N����,@�VbGa���ϴ��d����nAm�	(�jt��~ӭ���;i���P��� ���i�<i˷�G�����^�n+NA���j7���3�ٍ8P��[0��F^����;����[ h�ȼ����cP+%6�Z���&�W�9~�&ww����w��a�Um��8gU�	S�@��?���wAȫb���zt�#}����`/'�ZZ�؍tQ��-1�y�|¬!o�'�v0*x#�̓�q��dZ��5��vx��FHj��0$�ЊiV#�A��n�S�8��e�ݫ]+�G�Y�ӑ��������97b�X����ڨ�P�$���q��[�t���>Mub�"Eb%-;��D ��hֱ�Sxq~�X��f�lY����2������<Zp=��?6u�:���F,|Պ�>��4o׸W>U�[ׂs�E	ы�=��N%�@N��<5v[G����3� �i�2����9{q�^�<�S�V}[d��T����|!��3+�\'ࣙ�Q��ת�>�n 	F��*w�_���l�S2��:<��Oo�m�`Y��QgM���j-����^c$O�;�[�hx���
���'��_xKj����j���w1�o�R���6��+P�����}X�=fs��u`�ufչ2B�Up�v� C�;�3�t��էV����Bʺ�:���j�g"�c�M��{U���]����}�MX�B-���6��RЮd�.3F�MG�-������唹��aD���%������K'����C�x���I�U��'Խ����^��#��[<�3��(���l��10�2���Z�-=~���������x����ްj�;W�V�1x��f05��y}G_|�/�$j�\�j0v�01a���৙�y
�]z���c�����8�q-l��o@K����K;���(��ɍ�AV�Q�W�`�s\�/PI<_p��-w�>z����~7��v�MG�ܻ�;~v�{����5��#��d���>����R�N��T�A�Y�R$��3$7�_�G�5�
J�m���ܮ�nq��2�N��Uk��ӭ��~�nQ�ǥ765i�ԽOC�Y���j�*�N5�~����b�9��a�W�bM�q    lR>R�K�u��|�����Ay$+���r"��Gȫ،�k��ޘ��M�t���e#����}	�݉�,��7b�ӁƮ�&S3��o�iw� W���"?+�b(�I�m����)�\��^�Sr.��-����a8+(�&\�~+�ɓݴSpҚz%�eY���N�:נ4���s谍b��w�0�h�ZG{��P�P@�gO����n��K&)G����X�C	C��=�űAM^{Mc�iNs������dc#���j-�yl]� a�l�|FD0f1E�3�l�����۱l�G�A��^/��F,�dH��?z ��#��A��,�`�뽝A�Ϧ��^w��1!�EM�޸�6�i�%��X�Fѻ�J�L	p9#�M%a�C+����s�<Чn���_�XC���cKo�`��7k�]$��z+�s\��p�	'�?x�p�L�3x�u&w����?�غ�-�9�Ý�ыPW���s�~{���G��_��x��������*����e3}��P#)�e
_Wd��'#7��v��[�9g��ӑի�'��ۋL?���poAc�m��:w��p�?փޛ%��
��2/��`0�}�sj�laռ:�i����mV�F�^���@#��&����ck�AΖ?�߫�D�-;�-�~n�I"�5���sy���
��)O�����Kbgӧ�a2��l�� ��]ԓf�1v�0Dn����q�� \��1X"H�?BMȤ�"zkۥ׺ٿW:�h�{�4P{�Ȓ� � ����A�<HK%�>��?g�V��~���p���v� /��.���,�w�L�`5�-��c�A�"�ֿ,]����I=��~a���q����ܚ�x�G˒�:�i� �N��K��f�|,��qZ�>��o!���;Ɖ���5Ůikv�=_AR:�����3�(�����v�=C�t��i�����,"���Va��7u�$��Ťu�&W�;�Ya,��ȧI�h���D��#�������!�x�}���[
�>3Po�owG��������8�[��pOt��|r���z���!
�G�� f����ly�ݑ�Q���K���r�����Ǽ� ���{7,�{���d�]�����4s��Do��^�3�f
����|7�;�8��.$C`h@�������~�O�|pzc+�o-��a1���<v��y�_.�Ҥ��A�C���v��Zbk0�>`�8�N>���d����5��9"�P͂i�t�!�&�O3��N�־��VuA��U7E���մ���c��r �~s�9�
�3��Cx	by��,k��2[���{;I���T�{10mhj;Ĺ�Um��}�#����d� I�|I�,=o��]����d��ǽ?�����j����]�&U�d8�����Y	a�A�ЇĿ[�@�_ˤ��G��1�����n����1�G{��C7��#�~,G�'7�d�z]�Fެe"���*�v6F�sk�.���a�NBB��HoK\�4��߂��Z7���f7"H������ͅ��bA��f����F���ۺ������ �I�~��k�r�㛜��_8�<(�aW	���=u'�gOJ'TD�p�W���8P���Ë���<�v7�]RԄ��)L�]�Jk���4?�������9�r��@\��d�[�����=a�߃LijJ�Ըe�_{�\���(���Y�a�3�F���ۤY
���'4����i��w|�_�i<mW2���vDE�R<x���o��4�O�{�Q�.C�Ds����OH�J�u#D.@K1�uKX�JP�
��C�ȚUj9�;�ޮX�q��(j^bZΠ��[�vgG,3g,����K���}�k��}��eI��@ �r-��;�����;W-�W��⠿�-�H�0��=m�/�1�&V�NH�nP����-cxi�r�.A!�z�����q�w�׶�z�cWF�Uz�_�"��)say8r�o�BSN��ۿ��=*�Z��&{}�����0����ѽU�"K��>���\ �p3��-ȍ�(46�b���� C�ʱ�	�?U�7icg�s�zӚ�pC�`*�YB�8��6\�3�[R�=���;� �R(;���3���xڝ
����/�!.7��i��,���|�ܦ��q��Xp2JiNC�j�y?�(���w�_Z`��
�J��[o�k�,i�{{�:k�7�4qF ߶v�]p�Tz�PE�Z��֫s��� ��˞������ق�����:�W4��[��׆�-E�7��4^�@$�܊ؔ���θ���fL�
���2��f؅�Q�x�����O"�v�����.Ѣ̱���l�������lL���,����F���=�������h|���nX�C��`����Xܝ����<��L�+���{]�{:C?����yk��履�=�Y]�{�����א���7^�� �m����Ef/��B@&_���˄ݪ�y�j�\Ct�5���r#��[Ľ51YF�#Eq�f_��&
����s�=|Ҫq��o1UO4{�9O��.��-Or�F)�,�v���D5m�t��`-?���*�n��?��ƶ������]�[��
�)��{n{�Nv� #�s�h���>UU�\C�C�������-�fϳ��3�״��קp�,P{�*5FO��9(+�?��F"���J�ۛ�����KY�ifL��Du��Vqj\��먣	x	[��Ԓڂ��i"&��T&�_5�x%ˑ��US���Ğ[S��U]��T;�7bnY{��2XL����>(�-��2f,,�NЍR[z�Is�޹J aNpX��e���׈{暀��h,=0�.?��[`�d���,�x�wX'�7�0��a)zi�uoP�Z)
ڑy�O��a�DفK���V�|S�[;/��%
�)L�i�L�.r����R��6��G���Se��(��ށ�d O�]�]��t��.�Bە�[�Xr�w�e��g�4&��!�̷;[[���懕�_��n�����+��] cEZ�������Oo���[[��s��,	p��˓�����k,X�C$�q�d�F���;��u^��\��`�{mfx�"��T�vm�Q��uFn�z��:r�nb`⒈��Z��L=�5��4����T^ȹ����U���	�'����?@�d\�����;/m����&����@P��~��-�L�I�5;�kDVb@ژ��vS_ͽލd�P�֓+��`��\��1X8TtҢ�eq}�k�Lc���E�~��H�^ ��W�S2;G]�
���Q.�=�Z1�н癑mH	�
;q��ڶ�W=����F�Y��_���K��Z�v\�mb^3j��]��Y.���=Q�op�f��E+�*K��L$tة�D��lh35����^�&'j�c�~�¼�֯�l�k����
�կ]�g�$S��}6��o(�oʲ���0�L�W���5���s�<?��O8GGSgb�[Ѥ}8s'���w?W�p��78�*K8ZPRP�[�̂t�ҤC�+���"no��u�?܈ho� �ITv�v<���f���\���K�eqs\��`c�K�0�2c8�~��}��}����
�[��o��
�e��T�;���kO�������RC�ǧ����Jg���Is)�0�\S�Β8�*�X��}�@<p��R��`�Z�k��K�����%q��{��mͫ"���ȷ�Ź���t�ɚ3��Y��p���Q��o&@�%��1N������O�.����B8_G����w�Ý����[�`�;�����ʭ;�mѬ����i	���`x���G�^��R.�\ߧ�L�vI�R�޸����)]�0NV��G]�{��f?ʓ���!�Vn��À�P�=���\����a���Rg7rJ"��6���|SkN��y%��+K뽠@b��~}OIB�I��KU��gL�w/�����G��鵥��*��o����U�����sCf�_��uǟ� B��D�/mt ��CmT���э=��J�n���)�#\^\���\�`���w��҂��    e���O������W]Q`
X�&�[�xȏț{�c漪d���z��xhٜ�r�e�������F��K�5�mA���M�Һ��=�iYw�-�E�-�X�C����li�-V-��%[�����w}��o���=�r�oœV���k�n�a��mΰ.�Y7�2�E��ooZ�)�����U^���\F��'��8]��O���:3����������O�e�ybO�G���A~�ֻ��fP�[R8�d�/�*sƋ)A���IR��R�3[X֍W���9�� ֙3B<}t���s����Z7���l�׽j� A����.��w�38 �T3�P�^t�������e�{,*�Fl|P�:8��n�]gH@:9JԵ�*�����a��n}������7w.~^������ww$�mq)�/0q=�$�m�����:V�!��D柱$|���f�"ӯE%9�(�ӌ
j����fp���g}���� �zM�	�~0�*>�;�6@���+<d������\����-L'��G�M\������H*�� E�^ӥ2c�^��<(���^�����7���a#�uF���Y����N�V�'!hBw�0&���]����c��
�Ww�HA�؞K*7Ij�
��-���JX��?�NH�"���h��u�,W".W�H%ʈ�^0Ƭ����k���d���dRQ�Q���կؒ(voĵʥ��c�!��:����]������,}-4�_�fV[��ֻt��閬�bhN-��s�<{u���,J&'����N�|��"�=�*ҟ�L
���3M���h�	\�F$!6kF{	��_�/�e�߽���j5��]�{@�#�����/�W ebSy�G?Z5`��.��4�Z�T��ğ~a�B#w���t���Ōj?�Z0:�V��:FBs/���{�o�V�8[̀q�zy��,���Vq�����ף�U/�*�?��+s���_d�g��\0 +E��|5I�p��⼻�S_��JD�M�Ț����j��H�ɜ۠}���k�M�G���\!L�;��e�"��t�#�k0H��)��ڷ�����"�~����):m�wg���Ԛm�4�핆<M��b���¦Z�x�S�ݦ�E�wy&��p�F��Y��z8���C�_&�g��2}Q�����������<C�og��Շc� [�����Π(���jS/�>K��'�,�7�3���������<{�M��{��^w���Q��ڊ�b*�E� qOa���%)���̛Jje��)l��	g�D$��H>�Cm��I ���ލ�Jr�'~�ӆ��O�Y��1:����[���$��r���RJ��]�������^:�!Sh��kp	�b���Ӊp	)��81�7@"��@��ס
 I�}#�Cↈ��vRjQ�ߟ����}¤*龊����Ur�:UT� ZdM̽U����7!j���/H�K}T���:��ұ�������e�C�`���)�A9�������~�4-ކ�����̍������i�^�m�bSOK������mii-�ؿ�%�b���N&,̥.���N7����v�Kn�u��L�Y�\�r����,V�Ʌ�6����l�Q��yN1��Z�Ӷ�)�ی
b��k��QI���<��ۅ�L� D����K�1L�� Jg~�:DĹ,� yf�����������Y�Z����/�c���ݒF�fF�����HҴ?���rLRR�I�[� �I��@I��&ל�Un��yI�&�w&���+@��~n�x�
B�NA^Zi��˽�l���ݿ�3!R�g�j���G'ҙ�%�|}\��vn�G��׏c�w7���z�1r��3�� ��.���`B�@�מ���!N1!�xH_���89�d�x�f�+C�[���·�W�ֹ�a������9%��#*���k�3ic�oH�%���8f�� �>�)�L%$�)Wj:�_�l��*^x��"Ϸd�K��$kyKAI���a��|�a{���3���ڞ���<Jr���ס��*�n�K;KW� v܀ejńa9n
3r��K�jU��5��JJ8�l~*��;�;������"�`���p�s�Z���(O�1D�1q��N)6cxᙥ��k7H>T�m�<��SI�*���_ߔ�t���W�<X��2��z:)<pO����}&��5׳���2��p�q-C�I]��&�v��7�d����)ʞA%-i�����,���>�/�R��ص���J��e1pR]�5ʮA$��s�����g��z^�ŨܢZ���__�%�g�;(����u��֌{8�R�nO��u��w�|��(���ROu �>�d4RƘ�W�ENI�+TU8=�2�gp�f>%�n\OI�T�n�)�����D�&/0 -|k�:�����5+��{I.�4������OK'>I��h�M�)�\���hr�ߖ�q�ĳŅ�d�)�5lg���e��"
/aYl�5{�l%��`�s3��IS%�w��f'��6ִG�(����ld2���i�)f��� �L7�}6�d\#d�t�Lvo�e���<�^�>!�s��X�|�·H(�MExZ�%��7�!�r����%���^)�z��G�-�8�K�K]���-�(&��}�%&�6��c ���؃�xu�P��1AK����o�Ug~�~���*m-��$u��MeQG��B��Qj_����(/ Y�TQ;W1��3��a�Uu�F[h��HTM.��Ļ��8*���R1�"oq�Ey�^F�;U~���bR�u�)�s�K��Gt���`RM���Rv)53�zě트�뭽���]:	s;�Dy���5��W���S)�r�l�/�V�5��J� {�$���^�\��T{q���������1�������!I��(��!�A/Z��h�_����l��c��O,p����8{�l�M�Λ��I��j��E�HsJXx$�ۄ�T�@��}Ρs�*�J��4��U34�@a%���sQ~�ܖqxhg�f���ƱHh ��Aݿ }�81��M���$MBo�1њ�ka7^6�l�es��Ic�M��3��s�J��R]buƬ.iҗ�\i�ϥ�.9R���/�_-u�'-��4�_%�#4�����c�U�x4�
���1���)_Z�g�#p����΁ dS�|D\����"^x��RQՠ�'Zy���Ҥ(��L���W��t����I�N���E���y����Xkc����a�[S�w�R|���We[��[���V}�e�Ƞ��Cs�
�� 
�{ny��*���:B!��6�۷��
_d��m�8�â����6�;>�5�$3���'	���'i�=�e�2/X�<a�J��o����|���a"D�7ikTT�[x�(C�,j�g�7kNO����m���izB�d�r�:��>�Ӭqt��=O^�/�(��W/8|�a�j�3����5�T��9���#W�����d���5H�c	�C���͎"ۃ ���,� ���f	��.�bܖ�/.ܿ�o�Sf�s���<���	"3n>�D�.��K}���я�F�Q˝_,`�5K̸5�K:�w�"D�/��2�\��F���� U{�?zi�%���:|�;�V�4�J 했|gq���r�V���|}}CX;�a�A�}�#�#sw�5��t&zV��X+��:����A�w����t����!��R>*ɘe��Z���@�a�����-B��k�I�%���ǳfz���%�g^��!9@�k�	����,�RU{��7��8��5��d3�azQ����1��:�t���7z]�|���Ўl\:�[E(6�֚M��TI��Uul�>-�Ā���Xi��@wI��
)|���L�A�d����m����I�L���c��� ����!�/&M���������?�<{��I"��h����2�W��eɽt�f�Y��w�����F��s,��樚�|� \��m��r;M=�ԛ�D�{�h�'�j��R.�l��.ZR�-Te��+o]i�X9�^;D�S����Y
��t��B�S�� V  V�;���mM����[ ��ш\GL2� ��S[���t�+95�7D}�@�� �p9��̂���\D�[��Ϸ�JU��x�H��Yi\3?!�֯{����bP����ojA��,�:���GZD�b��K{��G�[�����ts09��VE�s��c\���8��G�y�1��k;���]�#(��y�����������W3nK���}n�YB;�����2&�]o��m�di#o=��tv��L�	b3��7����X�����f�18s��g��=\�����P�L������Ng�)���%ŘB�C�x�
qy�\��tc��*j�Rݗ,��)\��n�_�������,��S��%n���,`���Isw����;7�^:�t�U���c� ����N�s��=���X�b�x�^�V�1�������ĻH�2B�����Fx��(��5~�C/E��6��;�jU7�C3������䞶���f�� [�tMR�\D�S�c몒S�\�{�ݗ*I�Fp!���E}K�t�5���S�2�op]����x�J�J&�]"@L������?��hSH      
   
   x���           
   
   x���          "
   
   x���          $
   M   x���v
Q���WH��K�L���K-�O�)���Ws�	uV�0�QP��t
rU״��$N�PO��{��cH 1�       &
   �   x���v
Q���WH.-*NLI,Vs�	uV�0�QPw�*Z(�*���*8��%��Aºf�F&P�%�g
��(����@HMk.O|V��ʧ4+1��E��b��G$��B��ك0��<#]C�ɆDm�j�%HF[b1�h4 ¸w�      '
   g   x���v
Q���WH.-*NLI,�O�)���/Vs�	uV�04�Q0�Q0�Q0�Q0�Ĝ�Tu#C]s]Cu���5�'Qƙ M1��gf��<#�y\\ �){      )
   
   x���          ,
   �  x���?kA���O��	\q�{��T),c j� �L"~��'���.����b�y��Y�7���Z������w��������s<����n�QO�R��MѼRT��n�z|t��5��W����I5i�n��~JO�"�W�[��w4��=�c�Heڙ�2<dƇ5�̦�^�f|ɳ��:�W��dǗ����^��_�l�og�A����k64�C� y*
Rl�՗u���=mT-ȱ�R����[+��E�S0��&pB�G�N�	����	��̉,��Jh�DV	�C$4S"���!���]��C�=2L��E��fCA��9L�Ct�hզ����J�C*I	�T�!RI@�C�H%�1"�Hx�T(�%RI���`�+p�BNP� 8!A�#B�H*��@<P�h�d�g �p<88�@�����@$P�pp�
gC�3(T:�n[��?�n�O      -
   �   x��ҽ
�0��=W�Q�!�oC'��`�k	vlr����ox��p�4��E�i��w�ּ�ek{�k���)U����8˓�.ң΢� k`MX��6�yKز�v�{`Oسq 
���=ឍ#p$��*�U��(h!~�ҷ�      0
   
   x���          2
   Y   x���v
Q���WH.-*�/Vs�	uV�0�QP�wS��wwTG��������%E��:
~�>>02-1�8��$�i��� ��      3
   ;   x���v
Q���WH.-*�/�O�/*J�I,�,�LILQs�	uV�0�Q !Mk... ��      6
   �   x���?�P���Oq7���458f���Pc!$~����m�w��3��i�K'��;�������s��X�e+vy&�Ӳ�<��6}]o�b���!�����[p�*j�*��+������®y���@kb� �ၖZ��A� �:j�.��;�������y`�6@b0 {����:b9����m����I�ʘ�      7
   �   x��ұ
�0�Oq�B�&M҄N
R�VW[���i�t�������ۮo���p���>�&���8��<�|���xiz�ɜb���B؜D�}���%��d
��c���p�,b�q�UL��>$�mX
�f��a؆(� @* ����Z ����: ˅��eY��      :
   F   x���v
Q���WHI,ILJ,NM�H�KO��O��O�Vs�	uV�0�QHK�)N�Q��񁐚�\\\ ��&      ;
   
   x���          =
   v   x���v
Q���WHI,�/�OL.)M�I-Vs�	uV�0�QP7�P�Q033�Q0�Q0145������cp�B}|����E%�y�E���F�%���9z��� �4���� �I!�      ?
   
   x���          A
   F   x���v
Q���WHI,�/�/N�)MQs�	uV�0�QPO,NQ�QHK�)N�Q���s� |Mk... G��      C
   G   x���v
Q���WH-.IL�/�/HL�Ws�	uV�0�QPp�s�t�qU״��$��������� ��K      E
   
   x���          G
   
   x���          I
   
   x���          K
   f   x���v
Q���W��,K�I-�O-.)M��/Vs�	uV�0�QP��u��W״��$F�PS��s��Iڌ��B\��=I�e�������� �LB      M
   :   x���v
Q���W(H�,N-Vs�	uV�0�QPw,JO�+��KTG��kZsqq 4      O
   2   x���v
Q���W(H-J��I-Vs�	uV�PO�)���W״��� �>      
   d   x���v
Q���W(H-*��K,Vs�	uV�0�QP�M,*��S���+ACKK]S]CC ��������BG���4��Q0�12�IX�kZsqq ���      P
   
   x���          R
   8  x����N�@�;O174�@�?�'$m�jJ�>�\���v�D�>�G��}1�=���t:��,YEi�${��5�J�
kx�,��\�?0iS�DY��.�{��Uت)��b*�b)�WtX��QF�=y����7]���d�[�7�0k�<w'`i'�ר5�v� m>��F��-���L-�-�b�[��}��'�v�O�'�*�����ta�R�K_�Z-]q��O�߸9h!�ݧ��@B+�������Ie��5��s��d�J� �'����B���9Mx6
7
*!�I��K�Y����6R�O"㜫��w���)�n>      T
      x����J�@��y��E!��K�⩖ �X��=x[�AW���@�8>�/�l�`=���7��Yv��
����0�fޮ�nf�t�k��|���Й����?��pHm�1���*��J2Eꎱ��.�m{{�5�8O�t�h�O�����vA��̭��K�s)&�dU9�ho� tA{�p^ҿ��+%�d���>��N9���[��|�	Ɲ�TLN8Si괃'��I����$���1v�HO����3��p�ؠ�ٞ!�)����V�U))13#01���e?����      U
   
   x���          j
   �  x����n�@�w?�mi���$.:Q��8��ѐ�0"����3��J^Ю�	>�D~�8a̎8�����������/n_0����꓃tu��x����	uЃ��	3v9ġ@�FY�n�d�n�{�-ԝP�%z�	�p/���}�1㣅k����y}�~q���������LA	2��h�T���Pc<8� ΞP�9��lj��18���F�Y�ˉcH&��';�1ʋ�Dޘ~_�Y4q�R��Џ��V	
1�.�B�J��Q�Z�E#�ض~�\˭S���5��hU�Y}Ԇ��r�j���`Բ����E��6��Jv	��f��w���vi�.�q���.���J��v��/0-Ů�?��&LU�"x)�p���0ݟ[͙�]5�ebF[�;�'xZ���Um��L����Vo���i05�����ŖN��1Ii�UPg0���㮩L�����Mc$9���;5g��"[�jzS7�_�A���$�D%D{�5���l~4*�      h
      x��KsK�.6���ζE��Q��
@�,	@��`�4Q���� ����8<����3r�����㎶���Vf�	@��ͽ}�w@L�D�\ﵾ��{q�O�v?%������|6�N�9�����G��� �_�3g�
�Њ�I?���e�v�f3i�ǿ����U��'�/�,<ğ�_�|���4b����Z7�_�T�?�A�	�y.��uڋI�t�w��� n�=%ݸg|P[~�́�L<�4.[�e岙v��֫�ߊ�f�����O�^O�©��^�z<�ӌ՗6N��=]�b�c�7��?&�(�¡���w̡��x;���|>�e�Sr���ӻ������Ij����줽�<�z\O�����/ f�X-u�pE�b�Īt���ӛq�נ �C�fԕ����7u� �1�E)���.�1�6&w��mt��H��z7G�7��x�`�<M�B�����/�WIg�9��ՠ׏n�vZ�]��
`@#�<���N��ɵ�~���W��]���B�߁y�{o����5]\����C��s���2�I?�*j�߇�:��2�ݨ��H�%i3�R�����/��/�.٭w�o�6�<p�q^��׃V--%E�a���[���Cr���	g,L^k�I��w�~I���7Q�*n&]����y&-|�����H�w)i��X�D��Px��9�����ԃ;�=!����T{,�儭�*Ѹ&�q���`V�f�N?�A�͒Λh�~p3��KbpI�ƍ����/
U�Wr�M�ZM��JoQFWj	4�ޝ�$�2���"��?p�Y�X����x���է��}6W�����^c%(+��2�%=,ԋ��-ܧnC��	̤.�:Q�H����I#Vt�\��X	Mr7�nRO�eԬ�m�r�i��-��Q���Õ�������x�h�o#u;Q�K�$=�tqA��T��t�!��R��Z���	�j7ƍz� �F�x��y�̻�Bp�w�`�;�[U��L�����3�Rͧ8��o۽A�Җtz@O��h_����_ߤ_DN;����}�1 r��I͝��d�i�>��
s��|F;z'�z%��( h�]U�jQ���y�W�g3lf������*���g�h��Q}uZ�����H_�� ���X���[��&�j@���-d��]P�t�<�����M#xp	�K�e�t��E܍~����T��K����S���@\P��Ci�]Vq�.��X7R�b�>�yP�+3���Vh�7���(Q
��6�Faܸ�/�c�+L���/��W��f���A�Bx��d���^=����s�Y�G�.�֭w��$�^_l�K���h�['Q�{"6�:��$j��D���D���2����w���PW¿)Qu�,�$�I�,��57���
ߧz��h���۠<ߣo�E�>���>�o��%WI/n�j!GVf�u�~ \���u(V��{Q��h�͂�����䅓jJ���oO��\�,p��D]��ˠ��R��
����.Z��k����=��@�����:ӗ�'�eo +I�+[�~�v�v0��l�Fh�
Ya�7ݷ�$z#��6��Fr�Ҷ�f���z���$Y�\�'|�(朻�S�-�.�zg��s��ߠ��5�6�3�K0x����却^ؿ����r-{
s���؄Z��V��G�*�)������&&��wiSk���<��W��l���Uڼ�ePS��3B�z8 �F\���{��]�o��ݓ� K�z��4��g�GD:�H����A<� �p�ܤ�U��W�v4���0�e`�h���tde0�1O��=�6[�4�:��#4@�[�$�)��7��^���=�� lZ}��%��6"��wcS�׊��h����i&plV���״��o+�xARI�M�ʨ�1�0��j����t�
��.3$7�6�!M��d�(�b,�t��yI�PP+���#i���~8�X4 h�f�^I�j��S � ��9R�4�R��f�A���]y�n�i$h5��H?�s?�`�^���*�J�uI��\#t%i_���o�'��7��?���I�nZk**�$7跑"����غ�έ�0��^�J0��Q?0�V�ï�2���_"� w��������(�����ʂx-5�A�N�1�)�Ј�2Ҿũ<:v�����1;aR�> ;]ke���VDj1
�wZb�����b,dnHCÄH���?�N`&��2K��\�T�*�������'��p1\���R���H!O#u���Q��.�F�D�v[I7j0�E����)���Gp�X�L�+��ZԬ�3�"_�sL�%=�Xhi�>�)�m慠"��H�ޏf���a4�N��{D���D�~�S&�3Tepũ�iE`��7�7�)m�s������T}���������0H�ڷ�ȴ
?;�����-u�}��"�"X4꒬�q�-p<�2K�<�]�Ljݴ�DM�V�Ѐ����۶��I5;�x0W������w^f�^��Q\�V��fNk��&?��L�0��UN����o�����nEi-LW�o�T��Pt�]���[��W��L�7U�*��dK�#_��}���.>�J9�4��b* {���Oj�,9�b���1p�������=I�'�$e���xpE�j�4W��VZ�����:)0�2ܕ�rN��mx1����]�]��S0���"b�D�'�!�XA���7��L�Z��H�e(nIH慎k�o�v�x+�&B+S�W �G���E��X�V���T׬g���n;��<�zZF��̿~'��'7��}0�T��%o	�ntDJ�\Us��T�*�)Q�@k~�A�1+�4�K��
��యĮڐ'K���jD!���}GX;w��hv�����´��)��)g���s<_�Ck�l�ϳ��(Kh�n)�> ݚ�_��+_�V�����_ 0ޞz��.���@X+SKo�
i.��|8�Ht��fD�#C��<z�TF,ZG��q���gf!	ݻ`N��tB<&��(1/����c��C>ɾ�y�{�!�	X���9+<��Ydc���6Y�9��Ib�(�AF2+�S������L���mm���B���tW��
z�mJ�Y������T:�A?�q�6o�2+�4~|7�6��ۂb�&���0E�;��`����
�Ti�X�]E�n��yz�,���|�q��tQ�}UJ��H�
�w�E8P�LN��Ƚm��:��,����B������Z�T�[	��]��Q'�����*�O��q�qf�HE�^��e�7"��f-�{2h8���*�c~��֭.�]PW+j�Ͱ�SΆ�\��R����7�]�[sK�:�V���� ��NL��T{�OW�a8�i���Q=��)���%�Cu���ֶy�x|�V������I�X�>q*��.�V,\M�E�`�_��u��>��6��.ueފ�=�A��LƖ35��4�AQ}�k���u�M���`Biy�~1��7�^��z�T)ܘys��g3&�Vyea������/��W�}��~<�O,�`_���9�l ��Wd��Ѡ�~C�+�F-���L�b%�q�9�J��:��Z�!����r�CU���Y��.H����oU~��6+�6� ���G��>��ȍ�r��탫��1B�MI+�kɠ.P'���T�_kE��� ����;�?��9̬�"V���`YE��)���i悼�hQi�W*|��#y�Ahy>{z�X+-|/׊竗U�˲�E����ˌ���N��s�.ܲ��o������"�*w4yg�� �/[�g`�4s��Qa�gf�V~3A.7 �3�<�x}�`Osu�\�፪���5�����4��z��6��I��ޭUi$7�X�э렰@d����o� :�v�R��+�������D��ǁ�j��b�١x]|\�$�KA��#��:�g9�����\/�v���E�����Uu�D����ͤ�������c@;+Dx�\5u�WԬ��U�� ��ee�)�_�j؏^I%v7�o�F�J�V��DRn[]�L    x�@`\1�����WVּ���d��w3�.�*&��ϼ�\"Q��� �b�}_'�D�P%�;�������`Ծ3&�T�n�$E�P��[�R3!|?нD�J�
�X�FDz/۲����M�khG�R��i�Rܞ煞�W��66\�~t|U{T�6[Bz��}��ǪOt��=]W�U�,���ಋ��Sv���)s���
������p�ҤuͰҞu��Zp�VV����&���6O篾d��SV�wSq�}�a�DZ�ԕ;s���A����C� r<mA&r��+��u���k̆�ʆ֡���j��A�9�ZuX9�o*��Tɧ��Y�\��^�pO�
����+�f�\n'Y�
��`�RB���U����1p��j��+�����^$%�9ʞ]��=����Wm	f�lc����0b�������J^dXY���v���y�oS��������\����j�dۇ��v����n��v/��2?H �Gox�n`^(��M���K�aG��`����<�MΣ��S=V��}��V5���f���T]�6��������˧��\��zZ��/�Ҍ��7���o�~�̡`�C�F��A@e��\�Vr����7��R��!]%�vԓ��~|�ݬ�F�O��A �s��I���QN^����w9Yڟ؇����V�*FkL{�ޒ�h�	;���!��B�Z�u ����QIˋ{����5�f���H���l��Z՛?r�LίWɃ�߿�p�g��p�̳`�p+�T�@�CU�;ͭB6�Y�uP�����0?�`W���aԌ/Ќ��,�T؆n��ښż#������L������"���ﴪ^�PX��F�*JzQ�i:[I>�	�lC�G]ـ	�.ȪD�U��5%+��+��ƘQ&���v���� b	���M���{��PS{���Jx�����b,��g{Ս���H+��*�0��|��M��y�,��wڕM��\��;���v V�M��ڍ��"��0<�M�Hk�7�*�W�l���������M4�����Xm{K�ލ�E���K�+0�I�Kښ	j��YFLQL�e!t�S�u^������)�O3���a����f�A��0\D�u@���R�U�f�;}u�@���,{{�`_�~G5܀�V�f�>l����̈́�M(��#j-d��2��JXA�VZ�I&��/k��|�Ӊ�b%/g-nj0е԰�,h��-$���`W����l6����t<�d�ъ"h������Ok�����}ݤ6�H�y��k�#[|"���ZF.e�Md��Zu�P�<_�U���&3P�+C=�l�+�u�XJߺ~�Fdw҉۔oԒ�R��Ao�`���"�s�ذ�D�/03�H���qc��(mzr��$ ��G�@�s�ws�i��  ��[��Dѩv�H��r�{wZ�y�U}� ��ޚ��	|������u��J��7IJ��%�"�> ���TW_ �K�Չ�zr� q'�P�U�2�P.�����m�q�h�,+��9����j��켐Y���W��3O�͕��e�'aS'�qay��H
���_'9����9|����X�H�	���njа�U���e���-�E�넾k��"H�U�e޿[TUq{���.��#3��^�`!W�j7��]fϬY��y*%�m���z�7��}JO�%��
������l�>%�������n�5n�~�E7���D?���z���㺡�2#�
�I����d��lR�;y��V,� ��&�5�I�����E5Ud$�Ա[�X�蓩�`5��A�Z$��5#�Lۯ#��}���1���p��-�\�[�"F͸�*�N���nH�Ď��9��m�\�~�6�c]����M�GW���GG��5PW׀�\R�eA����0��O��&�<#�|8��u��
�2�<�I7.�l�s��?������q�.a[<��r0D���=���k�5�XE�M�ai�H ^;7�;�kcghO�2�[�#�z���K%�������rK��b��Y[Xb�^�$b�������ն�*��:1�2�2�%�n�X>o��<��T��\.�k�@a�i۰R�Dwew�� E��#a�����N�m]�Cu�J"b�e�P�i�v�>��N���l�M�����T�n,���A�G
ն��cx!&њ�,k:p|�#�d���sS�t1�r���i"~ܵb����&�wEO�Vz+��Q��Xx�5�@�@�x��Jue�V�^�8r��]�R�Y�.��{����\�j<<R�k��N8��B9�4y|�^_ҟ/�����!{`�ި�;�`4O�7F���<���k#���-�ט�f�
����$�n�&��H�:�`Uw��G����݉�n�|��C��ۨ�pٌn�u<U�k���Q��R|U���,��/���/�n��"T��<t}�F���ܴ�G�G�?�%(��`�TEϓU�Q�\�Hp4�[��fZS$��m���R3[YK�ABNCQ�V�B�N=R�&ت*HC��C0�ve^��H6B'jj{r��!�'�ڔ��n A��MY�N�����A��x�?����ZZ!�	��%,�1�!��z6$C�b�(R+E�^�e�����|��&�%>��W�U�1�hVʯ��y�l����'�' �X!�n|�vQp�	��
t܍VJ}�u-C��	��4�?A$@Q3z�6M��)�f}��0�K�s݀�P��pO���0�&p0q����Gu7]�R_;�w��uJdo~S���˒e�=j�n�K8�.��Ґ2���{�� ��Ѐ���)�Aw�Ėp|�n5lFj�f4hX*[��/�0�.f���&�^ՕP�����aq����T �����j�^V�i�
���k�P��n7��`9�57S��p%�/�
W�ز�p��8$������+�R���AC��aiV�)КU��k"d�� nT��)(��+p��
�׫���{�a���ٖ����V�/!�7���X̤�M}�Mu@�����b~M̯�����/Pm5�+�F�v���o�i���p+��������ս ��4�W�5���ù%���
���� ؗ��`��{ ��#��V|X
�&F��uq�5��ȶ� =+v�K�
�PF�T�(���.��K��!W�%棛Xc$�W�^�Cma�q8e���Ɲ�]V�p�N&[�!�U)�z�t�Sj��!��O��4�_��	~߸��-�N7���hf'2![Q��R��y�c�V����D4x���Q���N78	��[1i%}5���>נ6w<�c�lV�}]��Pm�%}��gv������W�K���� _駘�Ap���⼖[�ϕO�R÷w�%X��Or$��Q]lQƁ��f\�I�A+���J#v{�5��5�^6�@���f��e��H�K ��3���q7�U�m/���Z��N���gzn9��#����dV��o=V��z����/�E'��tt=��IU����;�)�vڎJ�W��빣s�l�Ӯ:�|k�w"�pԜe�H0�u�V���$M���ܗ�K��4���c��h<37<�:=���Q���Z����9��� �1u��P%�N�o#}�_2�Qu<�|�2ɄH�j��eT`��*G����u	�.-��=��Ie���@��Pj�g�5	�/ =������Ȗ�$]�>���^����%o��6�Fy�1�i+om2e�W�x�DC& �Ya�˸���q�4~�ݭ�\��u�+��ZQ?N�λ��@���h�-��P���޾Oq��x��t:%�-� �B�=~}.iy"E�'<�	,簯3O2Lh����׎�
*�(y�#W�u�@������7�<�����:>e�+��p��of�ê�t�R�[�֮���3YIS\4]r�(5��2ѥ	uY����Ԋ�Up��!�Q㑢U��;\���|����
���5��yU����Ť���l�:�2��%1��D�k@�y�Μ�Z>��ֈj7��~�T�p�O�U    *8��ux8�:������xhP��?b��j}(-[��c�Q�h_�$Q�pו!Q���1��@8�o��z/zw��-3��Ȼڊ���FrӘGV�!�t�W�~�u{� \��	��!�E��	��w�l(���R���8�JQ�u�J>#�_c�����{\��o�(��������~Mb�F�:��hd'��>ZY����"m�o�U���S\=,5���zF��p�Nuծ�C��(���������|���L��/Q>�sՆ���	/�v���5z��,�gK���d���
�4cp9��(Ey�P{�� �����k�q��0(b�z�&�"(�;�GT���S�f�n7��vZ.q�<�C�_�B�vIgóY���Sp��
�I
���Bo[���d?1��@v+,��-�k�|5W��t�%�A٩-��8=GPM�,zbv���rc hk�z����rOj��3AJ��S�u�('W�2� )�eY{v���yry6��V6e����"B�N�������|"Q����Wx�,��E/���J|Ս{���:�e��}�E��a��>xl�Z��v��i\ؕ������
���^���q���R��%#�/��r�-#����J������%�l�}N�7U�ƈ��t�v��G���/���������2Ę�iI�
Y1���[�]�} Z�4m40��}���w�@�1�dU���1W0ڍr'���Hd����CI�_g �)ߎ�iD^Im�>|ku��K� u,5�9�<�:���C���Z>����+}~��o0�}�sL�\��ǩ���}�N7Ji��g��bZN6٠���B��a4��z�g��h_����Vd��6�H�wJ��❾�y��t̜�^�R�b%����f4��R"+�\YJ������~
��N�W%�� ���|��a��"��d��ˍ���l�F}Mc���U���'�Z�ԯ᪷����T���*\��E��W����V�G�a'.�Gҋ˯HCZ��'ݣ HX����2Qm�K�	҉͍�m�e�D���o��L�S���"���F.#�۶.K��IE���^�t�����	$�F��4�9X�Vګ_�*�t���9�6�������J	�f�gYv�e3niF��0��/��rn�;`�q�&��	��4㍢���|Կ�jX�ޖ&鏒��YQ�NT��$#1�����e(�M�QO��	�sU���-S�����|A���F��9�Ҟa �i��!�>���{�b�q>�ֆ������d�ƂO����6ܘ�y9�ю��]����QI�ǒp^�|B���'㡳�S��~�_im�T����@���c������|��0�Sq=�*v�R�ao��:����i�G��x�&�P�/�e�d/A��]{!~VZ��V�L�~�.���,+��p���$���`E���U�n�n1,V@�p�" �T�+�,%�+�y)�T�=ľ@�׊��+���b�GMT'�*ʟ�fM�n[lS6��y�|���A	=�b�3�\�`5�]蓅+2/�~1iyC׃ڠO����h���iL8f�|�^�.k��~�<#�'w�w{���U[E��Ѿ��wѶ��
�k.���_���*Db�M��"����4<�jT5n���Fj`�9�E[\� ��gHrcj�����Φ\8�|��0z3x�J��s��d�&D�J��Z�;�����b�����B�����'��=X�0Oj#U��2����9B�}������M�����`�'��-�b��J�ya@�ҫ� Ƀ��^�����Ӽ�a��3\^h;�P�u�ɮ�f���`K��=Y���YW�[ff ��IA'S�`����C0.+��* �p�v��rS������n`~����M���r�'f=�z:PI[1��M���a��˞�QxbKXhv�i�v�� Ǯ��y��ؖ�^��i�h���j ��6�i��P`;G�B�dk�c�W�Y9�D����N#4[;� ;��lQ�D�����Z����������;�Ko"����g.�$,�ti[���	,x4�����~�}�7�3_���������Ԯ��^mx[kN+�o������:[�vлN
�<S|�0d@M+��\]&IsP��s���Y�%F|\3���GC�����q�t4�d`:�N-nGH�R���}�jlC��/tJ@���t��^#�+��E��hx��b��{�T�=�*ӕ��ܘgv��}�Pޠ�lv�f��V��nA��)���ՍG/aW&�+�:o
#�=�q��.ka�`/��t�
�؊���-z���h]��r�^��mU���%��R^ f�9aUFOqP~ﻻ��?�U�Z*�
�Q���KN���t��6�R��6��6�ҫȥ<u������x�*r�����Y�<�I�\ٚ��^�:Djt�T&�c6��O^}�>Z1�ʠ?�T�I�x���ړע.��W
����#*NLN� t/V�W�QG^�w��sW�t?t,/�N1k�s����	N ���f9�n��i3�}�}	�լ@�jދ�Z�ϖ4�<� �â&_�U�?��������r��!�$������lq;z�n?���L�L���O��!�C��k
�8��K��� ��D8R��ǯ�:g�&�˃�p��]Jq��RBQ��bVzwo<0q����bW�n�/�g�U�nV����e����Yкg��^h�L4g���A,z��P[�$�.cf�B��U��*QT������ �3�~��ߧS��2}��������h8�.n�*	����2�u���^T׽���(��s�'u�9S��D��i���� nFbwV�H�'�t��k��2S��渡9@�G��U3��7�h*�w�@;Э�i;i��հ)Õp&ͨ�܄>Y	O�g&�A+��&!Q��J�7�&��0"s�;F����}�` �q�\�}�=WUל�2P�v}M��Uct���+K"M��O�x�TW��_��W�<�z֞�f(֫z6Ɂ%$)�A�b=Z�zF;Z�J��yz���i����D22$����@�u5�l����l�����5X��)
$�b�a®�f3*P��`F���mSf�2�М��܌ɩ=¦��-���ͭ(���y&�~^�HD+�2�v��_����������"��ٳ�g��c���Z��3��Y�yy]M���\掯ʛi��qi�����VRq=11xWƐK��)M�MA���@ܾB�����Q����k�]'o���,�a^%��5N��@�ZQ�ַ���T��Wpto{f�(����`���r�_�XQE�V�%����|E	�OK��T@u��!�㸦�T{{Uٰ�n������{����6�u3I�iț����n��þ.�w�Դe�#S[Z3�i��e��^�!������-�[m��i��#��s��¨����r?��n��n��s=�*����L�Ɋ�Dʹ�3����`�
�줾��YM��m
���X �������>����0}{q6�J?ʶ9��Iw�h۹�����Kd�k�o� �q���7MSrX�i���V~�*Eۣ�|IU�(�G�ȐY3����{�;A�I��\;d WR�mS'@ZY������u�Nb�]"�0�r�V�4O,�<�?I8��U_�T��ͼ���P��2ߪ���u~�5AAn3y�7�M�M[u��5v��*��sN�lg:����I Ь��_�N��"9�A�����2I���p����f����x�:�64|�p<����v���A��9[��������4�=�����R�--�0)W�{I�	����M�I�:��HM�>�',!)y��I�ש��)J�+d(G�td���vC�(�L�JJ��(�T�)�B�{�;�!5��m���<�|��$+y��>�}����]�wI�}D�W��)YNصw���$	�b��^*��(��Ē�5؈I4'��'�ɱ��y�a10���ޖ������K���\L؉=�B�)��$FY�ey.��    �崙��b���w�C�fRtuloD']c��*��۹��聞�'Q����d�F5kd?���L2�%����q���a��J6�g�ro�7�7��nPa�DD���6�/N�[�t��I1	W�� T�շ��9G���Z���Z�6�[��Zw6��Y'^>	���'��sKgӹ�x��v�hL���Wy�NQmdM��>KU�\�"Xb���04HkQ��F)G9�ü@���Ř����^��lE�5b��k���9�v�P�B�"g�;�Ǐ�p��zK�Q�R!ȴ�H��T%�X=�Q"����wX[O��o�����?��0�A���h��)�'�1u�F�4xN`B�\�$��r�7��[�~PEy��Pi�m/��{g�W.�z���rS-�ǧ���Q2}]���s9C�gT�Y8��段��n��WR��8��DIWwkY<�k _�"lI�{���͏н���QѲ�Л.N�@G��ҠGbY��==��{��n�A�YL�\����$�U'��w��@ay���G�9k�7ź;_�b%I�M֤X�9�h)Tg������|.�ީ�#W��R�h[=@���Ci0�.��Ty����'��;/�b�R>tD8u"������k�xZ��*Ck���^�%8�+U]�:��p��O����h�C�z?�J��Q&8�ܚ�)s˲nOq#N���a$e�5�~�߻W�]���Y�U���Tl�9�\�ANts�AN�u�?̂7�gT���pa9�W�ب��������"v�,\�X��f�#���R�&4�W����q_�bt}oN�g�Dl�6�C-��\��T�'�ftV��nY��Қ���̠��^<�Uqj���3�垪z��u�`���?����q����� �g��N��}�����F_-����t �wT��T�c��w#=M������	61%8<Zp�^In� �C�ٗ�>���������=����֨�X��{J�Z��L3��:��g+B�E>�vn<羞�\�N�)��&���qZd��ic�ׁ��FXr?�6�½t�K/d��q���J���7�[�T4���Nѫ9�=��W麚,�{�rw߁�cf��7�.��(}p�s���7�*e���X�*%#?W{����b�1̲�q�~��)����F� ��� ��Z�(�C3�S쩪�yXH�\�>� M�ht5���C�Xh),B޽S��Q˩�9h��7��!G�4-Z�Jr�jT�U��E�3�mtc�̒`�}���Z/�K��z��	�uM�Vʧ�$J�2��IAp-\Oe<�0Ϧg_�%8�%iP����4�\�\�"�	�R��ָB�d8�
W��.��_b1Fm�4�m�xJ�Z����}F���aL�#,�0���C=�i�Hcy����A7�q�A�N_����x�I��+�F�������pI6+s�F�bwj�ǀc�a�nh3���*���n��|%��J!
]��c��P���%�-�!�;ŷ��@O0�{�-�Z���$�V��)��F��0{>� kJ]�^��P�EJC�q�x	�7�#��sC;��ӓz�;�����P}�_�N��g�;Ι2�c-�Y�uuDMl �Tĩ��h�[Ձm��0�2��xHnL�x�km*�i�v�q��o�Z���ǔn)�LUi�����v�M}�Ҏ�peR>���DnLNk ��.����l�,��뱫�l8�O� ��.{~��Q�6��b��|Xc�'U̩H�]�d�fg��#j%st+N�R^���v+z+��7+�v�B����P�@�~�_ eʕ
k;�q���#�6�՝���Q^Oj�J/.&�p��d8��F]q���n3���-�?β���4��l����G��c��C��,垞n�q�_�CD]z5�{��G��)��\���t>�f*	 �T4���_:�z��(V��f��	��e��B�QwaIv�һ�}~;��q�1|��T�lN���1�I!4n�녈~e��h>ŝ
��:V���C���d?�_�h�-����v4�ó���p�d6��"�*�Q�I4��&��L!a�քM>0퀠FyB'm�����(��h��|Q���7��+p+��[ Z�"��{7~ 0��&�����sw�9(*E�S~SheT/��2z�WL�j�z����a�����^�	���|ݦL�� ��f�jS�6��[�)����J$����*�G�BMAm^m����]P��{.�w���4�v��lh���\Q��v��=�E�F�tߢ�*�4)���Ғ�D�cfw�#����A�;N�]�nA���A�c�q[�lu9���	oD)%�(lx
ͲH�(��Ą=#y^�97k�19��E
K�7+�0��So�͔b��&�l���\YE1�:V%莠��J.[H�)�H9���qJ��\���uu�qF]m��
�,
��s6�/2�n@�<R�oT�b#�a>n�Xp��(�a<�&�:�&��`�+n�k����ee��6f����O��B�%���^�Q���b,��\C����r0�F���W�j@��ᄝ�<�_�È�!�ĩ�o/�+�)��g��<�;dƐ�}�T�Vf����J0�t�$��yƃ��<B���?��WR�e�UA��#���b<���(�#sL&���́b%��u�i&�����*}�JS���7���e��Oڥ���a@�\��;ͧ��?8t�Qp6E��$�A|s^�P��Y#I6�-���tF�����&F��{�r��� L���c�������|�$����#�ϜL~��Q����G�?�I2����1E����Ȗ?pB5:d�����~��k�I�=jŝ�a�����������.���Q�cH�&_o4���?���<2ec/�9)紇X]c���0�b�&*���-�@�u��,5����h�,
�f��N�Z�ZZ���V�;��0uw{I��E�/n������zCM�|6�\��EM⚓�O�j���4�3���a�K�I�)�����F`��w��g�O�1x���
����F��(Vy"����q�\d���G��rz�A��t��f2���&���C`%騀:^a��\^�n��Z�<$��D�
�8��;z����v��6]�KCzi�w��lɂ�%��1�r��c�-�����J����Q�"�f�#��
&IR8�hn�E�X�e\E	y���Ҁ��S����	Ē*���0-�/���HmݦXz$Z�j�NZ���U�0��$��fP�;��Ϧ%�L���A#[�q�H�2S+4��F@�� �����Ѣ�s���-��F��km���v����at%kW1�I�ת��J��7��]+�������(~���7Tۧ�V�2��Q֥4J4䇭��2(,2�8�_%׻�y�8��GF;��\G���9��l��߿��;|�i^��gPj���O�[��k�����Q���-d����T�C׵����=��xN�T�Y�-���D�yͧ�F����j�"��3M�^�?��43�������&Q%�[�e�s]��QkZ;����ӳb`�LH���&d/��Ƥ�}�����@;X!4��]CK�Xc��3�WJ�����$h@To��(vJ"���{s�*Hά��+ ���U�SlV���yޱ��bh�]�h��L3*u�8��UP`��U�V�Ɯ݁�� �	JS�	�3{>%�},vɀ�6�jf���c��`Q��0-�'����C���W�o���l&9�5����?�i�	�AF3IqrP`�/�g�@�'9]RT���_��+��QЕ�F�l�$$�8w�8���i0�w9�M�SJ�}�Z3@�4�]����[E�`�{O�4�B�`������M��q6��D��&��0|�*�9��<��e�QԞɭ{a��:��M�>�H�ٗ�����"��=���a���RT����[�R��=6�s�    L���u�Cɤ��4p��,.���b�?�_
��,��G{��P�<5K�P�M��G�c �X#����q*���7]χ�����Q����=u�tv���Ji���1ڥ�������1��	�j�TT�B/`�!?�mfr���pil(�L�$�m�F��Nl�M�bváİ��Q���0{&^m:~�t��P�v�ԩ�4�Hx�
NV����4.{�X�#��΄��$�ᲁ<s �66z̆�uZ�ڏw�q53 v���ދ~wӣ��[�_:�H�$�*X��k�2�.���JC[t��|�*~~F�}*~:@~
�8+�D ��kNzƈ�t<�-��~�+7����4��͛�OO��ۍ��Ũ<�|%�).˨�]H�:����$'�x�5��?��-Hh�+���� !��ʪ�4�lB.����]�х&:,����Aş��_F��r�;��n����;��ЫQ�$�`L�>s]�QL�����(���,�τSt�+�&ԲO��=#5�2����L+J�f����	�s\s:�|1�{^R*l9=;�8�[6Z1i���J�����Q��{_#�rA�4��G�J+��;8��9VCb8,���Xa�\���l��E�(#A���Y��ĲZ���,#���_�Q'X�='��g��R�˴��-�:xde�6z���q���ɟ��O�X"�>� ��T�*��F���>�j��֢���K�Bʹ�T��@���Ӕ_�����ݧl��41 �= ��TǁO1�O���n�nx}�6��O��H�l�7���D�G&4W�(�#��]�kDkT*�d�q6R���0[V�!BhI(:`L�1�V��Z��+lQgq�x�邈]4�T�=�)�j��o�j���Ո��!FHؖ�D���z
x%j���M�"*?�̓c��|�(z��D*����tT$���iڀ�P>����g\�����\š��H��ܩ-���3
��@x�Ij��r$��z��ge�f��
l�w园�/��^1%x��K� +�St�s���U"�dz��6FS`t�y����ؒ�r	c�j�(Gq}���U�N@��q_��8���]�=k7�-��cn��u��d�ީ�e��2&�m���B�]�������#��a�����{�`�ZeFzg���V�<Y7>=)�p2Ǎ��6�2�
��b<��u�PF��N΂eh�XI�U��{�4���@�~@������&�[�����5\�s��k�����!~��r��#��49O���6����o
�NN�\DO9�k�ڪ"dUQd���	�J2^<&�����#W���o�6ο�"|��o��G��j��P��v�������m���#���*�?Ng+1_��yw��m#j�!�֢�N*�����dm�N�"�/����Oo�3��M�H�a����6�-���b%���?-���L�S�H �Cך?%��c>}5���/��{��S
�2m�8(����}E�~��d�Ќ��'�d���R�I�J*bض��	ߥE*�X���朁���i�8��5j�1~���f����H�052+tBK��ԫ���y�ԓ�����
/�'���k��x���Y�c�E����N~t���{�-T_��jJ�G�8�Ղr���%.�����8!��q:I�Nv���r�h�c53��Lﱚ鍗�R���2�u����%�Ke����N7V��2RN�"ĭ܄v|NK��y�-�����"��ό\f���D�P�瀗�(y��u�V��i�e3�^)��3�<Q�ٷ���cJV�^g��a��3���b����{}�m������]�o�e52�&�����r�_���Yv�2�K���i�U�8؀C�]���b��%g���Բ/��v�Y~Fh�z��Yh��GU�ӀQ�7(iO��	9ډ�_� p�ON��;�5��ňx=Ô��Z�w0�����9&�<�`��|A�;�\��X���Mu�,��hI��,�U�7f�2�)��!�
  � h�T>�����z�
2dX�r�q��Z���Svf�3�����́qe���A�z�yv��o���q���R����m\~h��q̇�=(�f��+8R_~�����gY�!�Guɨ�t�u
�X�e:}�	g��h ��*���T��	�z��)L��쏬:�M�#y��^�q����h��p4\���h��-�$�^I�De��b��e4!84�ԅ�p0w͎�L��7�˚�ϣߎ-����H,�GkУ�J<�� ��V>c�^x��0��8c�Q�8Q=�@��B3^�|�1�I��Z	գv=�ctRL�␀��,�｀����/Iq�G+)�t;YN��ˁ_�������-�V�n���Th��Y�%ϝfR���*�u�.8���/����Gԓ	����ߓ�����|���t$�X�;��G�u���8����=q�4���!�F��㞔���o�6��T?�nz�2�j&��8�>t�"V+����_��7i\�HEb£¥!���G�m� `0�U:�7���(��I��M��� �$�c�@�ߔN���sr-a:
X{&֐��cU��UO;�.�4�q+�,�1�e3p��O��u�<�Pr�%���B#����պ��3�{`��������a6~�C�B�?f�* ~��e�v!J���b�8�⤟�����<V� ��x��x��U��^=�eOHa�nd���-��<c�#�i@M�_����G���]SSW��T��.�r��'�a)<��*�Ǩ� $@�̼�H7�����D"NV���	w���\���S�u�WV��Ù,�6�0!6����|B,���@i[��1���Hg�a<�
D�/<��T"~��^"T-}�v����LתكB��(�X�gē�YN���MP�O$��V6~�����Ҏ���J�B|�i�|���K���C�<�JR��Բ'���'4)�~�Lg�����]�!9-S���<o�l�W��h������wqA��0&����D1��@�_�B-k�Hl��v���.�أ�	˙���������I/��o�5w��É�%>�I�v�9�@�/�N>�j4�0�)�A����,�a	�P��k 'gw���?������'�����|��s!��d��(�VP���=�[�z�<7�S�F$G�jl=�tf#D�����0��m\Ñ��T�F��}�g6+�1�e����Qi��#h���?�p��޽3�瓺�	\�Z �գ���6 s5�X�aL�*VT��T�مv/,a%%ok��ק�e3�E�t������p9�XG���\���[1�_"+��F���G^I�|_���4��*c�b��!�+�M-E;�g	�$�X�6A���*�����(�e{��%P�U�
y v�R+��_N
"������)�E�.�)7��fr�Xx<˨(+�Z��µ3�1���{w�s�A�o�>�� 4#i+�e+>^�jw�U�^�\�R-�;u�b\�p��Ӆ��Lϭ�5u��yh�^���r�C�5�;����0�6�)~�4�3�u2��x��g��?�U(@;UV��P����֕�Ϥ9c]�w�؁g�2iN�C>eN�.�Dq=�籀�F ��~	�/Om�?-@�<]q��:[<N'��#}���u#
��
��j4��V�6��X���*�J�v*���Ey-߁�0% w1����T&HP�tG���p��;�k���Q`21#D|f1�QSW�nsҋH'��u��dr��u�<D��]��&��1߹��^U�V���F����/�B�*»�<ˆ�5�ͱv�:���Or����H�f���u�	X����,#sB,�wu�A7�|8�L�$Ttg1;���_���q*�x@B'4�?���G�ӵr����A��ѩ�3IVV�M����DO0���k.'� �x��e���B�R���o���\���x��ك���M���k�F�T�Nkc�벹����Y}�V6zX`�8�n��&���V�v�����R����1
ޠ�7�k�˸�pTr���7���>��7'�X��c�98+    ��1�T����.�q(�h��܇B�?�O�D�P�#�Gqڼ�Q4nգ����b.,a%EU��e+�Dp�����XU��ݮ��~-s�D�Nԍ	w�Ym����>�lL����l��}r�����sPp�=TE�:�>�v���ZK�M�
Wu���E��$�'��Ғ�.��Њ�94��܊s�:��~7EGA{��R�_�����	�B7<F���	�KT��>���˃���)���FM�n��[C�>VUh&���s�¦�2bˑb�����H���ɿ�3U��KvW�i4��M݉���qiP���r$������`H�M?�bH�F兠�{��K1��p�+�>L�c&�ǳ��V�T�e�ʁ��A9{ �q@�X�w�2d����<LǢ�V?�&�\6~�7���b���� ��K4�K8�^��U��7�a~[�%�`��l9�ba���R껇-�� f-J6\Z�����,�fuDh�%Բ��NrE�c�$`u �V��!���^M����/%e�;s���@*�j�*3i$�����}5�X	��L���R��Sax�H�aH�g`����#s�8s�5M����n�!����� �i�5���zj���w]cDb�6]?'�u�4��]�*�����m�r�A�Qn��J�y�ŕ?���q;Xr�f��e5B�}�A�#���pg�S��$X�cY?�_5��0"��}�uL����Yu����p� ���$Ck1�/��d�3~[uΡ����ŏ��|}�#��`�*+���h�K׫�e��	���l��h�k��ϩa����s��
/
�#�(;*E�1�+0����������
cB�����!�W���o��v*Q�6(F� �muJW��l��ܕf���4pCO����o�0���#�ς!���d�SNp��c)~T������ƅ���k�=5Ͻ6��>~�7l�}4/������'p���<��c�ݤ8n�����\'���-ed������ 롺�N��u��0�;$@Ԗc)����s�?lK�B���챫+�X��r�,f�H�T+���}��.�4a,UC�+��GH@~y���`�Z��X�W�yz�JA�l ��d��,�	��}�CC]�c�a`L@�����}�N*`��Ǽ���j���F[�t0X��F���Bzn��y@ݣ51�+X!��×{���yُC�a�[F��И+�<O�D�7���\pOU�F��o��1	�3���h|p��rĜ G�����]<��=W�,�r:L�S�]E��v�}_���l�l&#�,�9bF�38�z��Yy��h�l�*�6a���{�~j,�s�T&<��h��\��:���Y�8�C���哉-�u����/pǫ3B��\g����9��pn�~t����"�5���)�"��ϱlX��,;��x���X�AB��?���F��"l�T�y贤�$�[�f3)�J��燞9ý�=�X;�x����$
g�Y��L���/2��<������T�D���C�������d�Ц�'�t�qu�!c2%��sU��
W��������������a��t8Z��-
}Z���p�$a�:��@>��C����y��y\ ����<噚i�+��֕%9@��5L���`0�d���U������S��\��H9<Iʄ�?�sB��E��^)$��x:���]���>�a�eo��VE����,�c��p�=�=�7��z-kN^NhH�&�[F�	�4K�3/IR��VM�/�@!әa�
�Q�H��Si�ld|qR�r���\�!W)�Z6���Aզ�q�؃h!�'s����i�hx��X��Y��0>�ژ'�?</O���˨1�uv��M�_��f��H!#�!a>�O9~7t�����N>��=O��X
�A�Yѯ�\�);��
c,�"����t����'j��9������v��zR�n�R�q�L��v>�?� f� �9L�g�*f�5G��.>��q����W���8�5�}V&���� ����l�8��}�m�H��-�M���Pi#@}
:B�����=�fϓG�V�đ����O����&`���%0/d�	8z���T]Z����KV��֧� /}.��Unu��.�5��XC���y p�/~{�|V3�����)�M����&�9v����}�R����{rZ�e���^g}�%~l}�%��\e����=B�M=�\3���f�!�nP-8~��sO�b��	Ů�|U�g��=��������� �,x9�wH.����:��*�Ep�8�e��To����ԗqQ3X`����������鮔���4eFɢ�,����ലz�!+iJ���H���>�&�Y�S��*q��)�[d_Dpi�#���-<-hJ����8��ng=�g���j�����K��,E	H�#��3��9L�<�?�b����*�z7]���>F8a8&������]|�o�ߕ�8������2��af��g��A��Q@�����J��Tb�ե5���UT��1a���5K?�-ʱ:�9��t4y��i`�n�0�i��=�f����QὟ�/�8��kaC���ӊ9�%���8��'���x���f},B��kp=��.H}��@X �����+tdi/�H/g�h���K���98a�� 8�-O����i�n)��j�^x�{RǺ폣�rs��Moĵ�t�� ǃm�8WI+�wӃHQ�^.f�Lfʣ�]�3^K�[=k�v�A���@�o�{0%_�8=>��%�Ѡ�%^�UV��⍿�]�V7�s���}���֟��f֔��ɷJc�\�?����&�#��>r����ظ5��p�C��*�d6%:���JO�8������ox���C���X���V�&q�,�ޏ���)����;��Y]r�-�K���z���ĸ@��S��5���T�/r�����3k\���v��@��~*Q��>��c��4�aY*��	~��8P�p��,��߬�u��(Q����J�ַ�|G���3=깘E�󓒫��)��TO�(��b��̬^.c@ꇠ��h�*����x��,�+�)�~"��t�qJz���-���O�m͒�{��v:�}�T2�W'ȱ(s%J����}Wf��g�������U�=C����A���1@��ś�)�+qӛb��
l��P���d��n8b<y��=Հ��0����{y���q�(	éϦC6���a�S+��EI��=��sgREI���ϕ܀�{����}�zu�Fe�2��6��R�$ǻ�@.��6�c�7�`��6��
��)�#*����c��R6{�%1�V>�ˀ��b��}���K�c�6����i_��GS"(y���-���<k斄p[(R�e��矹8��^��@���S�!��ҋ� �ᖸ��	�sw;���n�O�����:)}5�n���" x��;4�n�!F��p�9UmNц��H��վ@ =�q\��×��r���x��ŷ�L��bF�K3R]D|�/��L~�Ъ�������9z�e�$�T�n��\Z��g^�x\xj�"Zݎ�!���S���sK|�N6��3e�(����-��|É�D�IdJ�
�j��r��|���a ������[�%�c'�|�ex�#w$�D�}�ņ Z����^	}!k0���vvTk��C����y��=G�}tz�-q7��ͦ
緑@��#)Vr(�#�d��2#^�o�{��;��{%hwt?�J�(�͈j9�v�8C�g��x�掄��%���j��]�w��c$���z��J<��K�"!��rƼ��,�h��G���)�Q�����)F��ex�d����=������^^��jQ�7�(k�n�6��Q�1*2�����G�4΄20��ȾΊM=���I�^��
��� -YE�7�Qx`�����)Q8y��7V;�5I�{���Y�
��c�����6����J|�^6��c�U��l��E.ј��p�������    �GU��=<OV8���J�Y�ه��ڞ8*>�sL���)M���q�� R�b�I���J�Y��bhK%F�t�mݦ �C��)ճy6\ �@F4���E�L �L#h�v5�[�}	�׷7}�ZY��� �����9���9��jؓ矐�[��>�iM��肮�u}¨8�#'�0����3���r���춤P��^�d`��B ��=�P�T�9��c4�+�0a�s����rd��/�{��}f�,�e�PH�0�-���ܟ~w!�#R��9��k����Vv��G;J��?�ƺ�'����,wʑs�A��<������/G{�C|��q7����>���FV
���\5~[fM\�K�ᐴm>'��o�:c��/�w7�(�-�HZ�2�d�W�zoh�i�s��������?����]�������?��o3���ʲ������~�����,'T�*��jY�٣�~���n1�=JK�q"�N�e�p0�H[����`N���,��9/���чl<���v����Ċ�t8�g�&U�gUO���,�%���lU��4�7�Cry;�C��tsTD ą�H�^G��10V&�|~�0}XR�������p��Ǚ ����ň	���
.[9	&�<�W��l�lv�O���~�I���7I�0k��O؜0W$/)�i��Y�xn�5k�11�Nr�9�t(;�E��چ��p���4�^�2Í��^��W��v��F����?�'Mg��q�S߭����i��6���~����w+)}���4|z��wX��'N�@V��`"=�����W����7��=�wµ7�3�) �"@j�)��U�eǐ��	��jA��xkJ�LA��l�D5Y�{#��#�ި{����n�m#G��_�o�����{e�|�e+�g�/�DBl�Ѐ��׼��E֚�쫬}5�c_Uwl$�`���Y�4E���ꩧ��ED��H�`��c3�F$m���=;<Zk�\����'�>�[7����W�(p�~��2iǢ�uՍ��^Kl���M#ۂ�wm*��I������!�����?H�/
��=�-�g����H�C���)�J79�z�	�T_@��[�y������ɛ�~u���|�< Yݿ�[���u���b�o�����c8&���`{ו�I�O`>��x�)1�;hK)Q[COQ����8��r����jg�����o�!o[O�N1��q���{^1�ut�RM�ʊ��@U�����Fz���3l�X�DD����U�@c5(��.Wa�Q1D`�|J"�L����Qǻ����x˾NG$�a��U2�b�����Ge�0/b�������o��x'�蘶n�RiP:���W��q��M=*"��Ck� �0��(/�t������$6��`�SV��g��[23��1��W?&O�|\b���σ�~3x����'<��n�4e�~`�W�~��I�(�[�4a����4�f䉐z���� \�b�t����0��LDT�:���.�CHa�i���y���T��8v!i���Ht�	�E~�=J,��� �(�j��m;�ο����ԇ��m��s�v�����<�{� L�`#Ӗ�B�|>�B8�&��Hؐ��o�X1Y�9a�-3�ͬ?���+�V�UK��MfqH~rf7�wa���<��ҭ�>p��g˿��FCn
���<;ӧ��y5�ݹ��ǴyƯ4�UQs<��94 �rAz��^l􁱌�0Ҧ>��v��1�g� �(ck�k�z ���+��
�����3��rzG�|p��t�ʣ��ap�>��HL�͕����ځo���J�Ժ��Y����5V�u:�x�>�7Ή?���KM�vܸ_��4�<:bD�&r�E�� �R����E|�����f�?+�����v`D�S"W��kD�?��j�݄�+��ã�Y�����F70��f��%�Tм��\ΜH!T����`K�I�otJ��J�;=����p�1N�޷�F�㇁��Q�I<_�,��r���Q�2I5�t����,Y��a>��فצ�^PUfء��U%:^���H�r�B(a���W%�ў����k��Ͱ5"hHQ��z��|��٢�/~|�ؾ���$�� /g���6.߫q
A)�уY�w���F���xDl'� t�dQ��Z�6<�{�)�G��!��K����#�I@�d�Y��\�C��@|�0�T�h��>�zα���p�����*OE�ˋe,���}[�.�����͒�0)E7A1��_êac��H��U�����M��6�5��w<�L��}�2D��bL����HV��G��*B��b;�2�&7Kѷį��l���o�\#�{!垩�Тf0Dj��3�Q�P�n����)���A㜱i��+������a>Z\���WI}���W)bd�ė�Ǻ�z�RB����/��v�:p�&���66��Hѫ}�SK�PfPu_�"�hy�Z0�q���zך��:Ռ�q^`�0Lx��� GКA���R��59��>�Fq�3�������^j_c�0���'x�.�v4�*�9@j��b%�����͵;;wp��kգ?��¸EE�8��]��v�Qd�Ɠ����y�L�e�C��B7Y%�'��BC�A��0�K��*2���К�ZS~*�n��XO�o�|g�*Kf���c��6��� 1���x���5np�ڏ�\w��n�Q1CF���+ai%ܓH��?n��%?�X�*&6�Yl��P3S�A��r��N�f�z�6�Z&	g�q�as�1��8���F�j�릓��,T�}F=���A�D}��]�� }��Oψ0"/��7l^���F2�~@!4>���!��J�zS��*�.�|���A���N>��<s	f�Jb����x�����p�Dv=�q<��Ą�A����I_�Џ\3����h�t/���XQ.�nl�zGy�i~2$��I������d�*��_ᴽs{!z�g�y7���*����|�B��£�p����d�\��\W�h���wE9�8'7d��'�.͡P�EC$��t��s��&���12β!o�c�=r���k�[`��t�Ȥ)�d@�b�Q/�I����o�h���ݴ��v�6�l]{%�,�M���wg�3��6����Ӽ����[��E��U ��C*�9��A�b��qn�N�з�0�7���X����	?�����+���*G�B<���0��9��Yۑ�ڐ	n���{�T4�Qѵ N�'<�+��i��&/Q0G�qJ�v���C�0�S�RR�4[Ml:�'�aE��Y��'E|��X��h��S=���y6�/�q
Z6]�3$�k���%]�hW<!�����z���+�[��Q�W-���mmT�<
�q�P���>��rk�(�1���Y�R�P�k��%��T�O��g�9xaA!��h�n&i�t�g�d�L8�����s��3>u���� ��k�.r2�[5�L�ǰ�3p������!l ́��3�5��Ȗ�i*Or�H��y>y(|r����2_<+��m2_="��WC�Xu���]�������z��˷�o���G~z�ڡ�-i��C�w ���0������@r��c�i������|^9���[�u1c�M̀��㪊�0Ƈ��-'�����O1�?TU��c8q�nM'G`�1Cѩ�}�dd����;�W�9�[3Ao ��+�����U�,��S�ؔAA;�v$�/|��<H�\���5'�ʇ��*���x����"F(�h�0]���o<�s�$`N����3�(L���>L��/�&�6��{�߹pMvׯ�?�O��]I��C4�v ���#�i��J
�"�hf�j�4H�Q^$,�S�Ho�N�z3��U���p��Ms��	|����<�����,�j�s͒i�p��Ï�[�������9�:X
��cXH��%"�z�Zꔥ��ն����$��S�02	��NGiH�1�kL�U)�!xL�;�}W�����ì����,��r5-z_�b�)� ��4����RH0�U�aC�    wT���Wpm�Rؾ�qV	d��d�AQ�G���B��?�k�O�
�Y���9kο�g<�6�Q�Itg�N��o5�H8�=�Z%#/RN��wMޕ�"�	U@�a�o�Y��B8�ę��y5���W=��%��وM�>�إ0�z�=GOt�Z��c,�H��9D^�=?<��Y�:\�L�(�g	�����$�V�aS�r�0��)�/��r�ӚO��¾����4`���2�ӯ�.6�0�ss5�1LWt����/b��&��8��$��֡9ݽ7���a0&�mg����tC��/F�q�8�o�EY�rD(a����O�{��¦�u�n��:�M>��_�#lr` nD5��
�(W7�	p7�q�������)�P�Zy��$a8��@E�_^~����j�}�kr��]�v@���66)޷pI���l�t��<�]� ���2��~3�'��Q4�p���L����j��j�S�S���m[R�ʷe㮗�$`����q��`�{*��3.`#�씤�YR����\;�$e(B���I����7�0���������<X�����I��E2�W���g�%p��e�%��_	
������p���
!SE��� ������Ho����{]��X�p�5C�D�Q����A��7�98/n�g��K�WCK����*2*0��
{Y:�j.�9��i���ݧ���P�����Mϱ��()��l8���,gg��;�A�7����۔�KX�$� C��x�9@C�'��|�1���.�,A�R�����s��!�DB�V}>��*�l#�幝n/�w����ovg��,�If(0U7�F��*Q�F.)�D䜡�Xt�^6����A>ò�h=�������\��.!��lH�����/Q�<p|۩��M��{Xpw�ꎩ�l��h�v 7�l��m[gV�-Km��z!��<�!�t��9���Y^�.$��Q������&2V5�TF�2�ܸ��ovn��^��o0��1܌����b��
��� j[�����i��%�y8(����@7�آ��Jհj��;��T^ -�C0��ޘ�m�oPh��BV�f�B�#凾��aV�/��=<B[h���*��6ƳO�hh�^���U2�i���.7�o;8 �`��6��7��]�����FwB��61��7y����\!Bm�����~��X|�H/������#��Pb=�����ۤ�
%ÀpX��������z�z���Oo��?�W~�.��;�E|����_��ӷo�N�N I�榙���Yz���8:d�t� �dpf/a��;1�o�_�:n��xj@eUq�lm����#��,)��[9}�K��
4l��8"HE�0�I�fx��D�˧O�\�Xr����-#>��/��Y�H�)���Lu�KF�ħfҽ
�+'��]���x���2g��luߐ�n�\�I/�P�4��7a���}��D�1J��z]�S�6�ْ)1�_�td&��Jt�������t��)��#��u��xw�[Zq��x����4�w$�PCVj��ټ̰l<�L<Ӎ-ގ���	:������C�i(y�i׳�jZӈn�|��L���3ܐ��~%:975��{4Ɛ�o	���*��@0|�sTD��Ol$�M[?�҇����ė*$"4k�=fd��%_�ζ�:�Yy���V�dpv�@���ZG��	}j���j�W�6on��A�w���6���;�j��hN���������lC-�][DN>���U�C�����sã�O�!�EK�y1�ꋍ����b����4Ȫ�X���������%� X�'��`G@k�Y��`Ԓ�Z��"d�
�:�H��F����S��y3hR��I!dU5r�0�=�TG㬟��ȵރ�t������x٘d�>��쎐#ژ�A|U&
9�t*�Z�5Tj$�� .�����O��M�<�]Q!>�'�l;ya�,UĜWs�i�;��;e��bԦ�¿��"�K���:n�?v��/�n�Ur*��AQY�1]���1����������x����!|G��B3EV�F:o�W�b+��Cɑl�^EU���bzh������d�ۯ�v6�O	7�)����3�S�ȳ����v�.�S�D�YR����-�I��Rn�x6�0��с�x���9�E����h��<G��ZXr2�2�M��9r���8^�]2��d���4-^����,@t���F��{�����d̸���Ѓ8ӓ�;��51�亢m��ۯH�;�祥���pA��u�����4�]��C�Qi�
9Lʹ���tm�����Ơ���	f�G��䝓UE�A.d��_�����7;-�Lc-ˎ��9v*˫e��
���*��Fzc>�,��Q���ct��m%���$�0?l	��n_=O�[�ה?���wE���+9�{X�;v�k_ '��r�l��6f�]�Ř�2ujr��N8lʦ�Ƀ1EU���>��/*���{��1�P�uZo�Y��GGG���(��M1�N�s���1�+����� )+`�Ć�A���z�#;���$(O�qRl�d=�M��W�y��Kk����	'; OR$�z��Mu:�m�������n�B�<��&Ha#�'�$R�������Ţ��X���pkęU}6�
��FW�y���lѩRs�t��N��I،�*Ei�ķ���(�]�Oͤ����I���HK�Z����uM\P�ڷB�ބg�����1��*���� ?�
�c<r��եWN0b�����4'ܟНZ��҄�7����g�	�@���$��SX��Q>N/�V5_Ud";�eR�R&W���F��W������0C")=�B���Fz�S�iTJ�ە�i�6PH�uk��>�G	���ޯ��������P�v�r������k� Z-pw`G&ÂU��J�!�Lf��#VR�0�0�T2����=�g���?�-� �JDAd_CI6T�5�/b�����w ��s����d����`�q<��.�zzh��iU�Fz���
r����J|r���M^���ƒ�
�Z���bp��TOyS"r�뽊�����E);@�%F)/&���\��_*[��������U�z��=K%���O �����)��~��e�����/8�b��mD$o����Nv �ᴳ�1�/I�߄]���.u�Ƣ������|�Lʴ:_���gEU�]�:��Ƈ�a�$-l������XK�a���Q���{lͯ�I�.p�ǉ������'o�k	��-��#��J9}������V���e
�n��d��n=E*�y���L��6F��D��&�v�tk�W����I$X�[�:��Dᶠ��� ��<ى7���pF�8$?�����NO_�X��C�� .��^��Z�Ӛ��E�1�=l[�����n��#G-��B��#a��<����@.�#Ob���I`#�r����!�jn���o�� T��(��]J���8\%~��t_I�R�����@B󍫌k�T�I2��x<W�w���#7�cpreHr� �}.�E1��cI��}�6�rf�9pFr���#6�D��I^��R
�q�yGM�v��B9V�gM�c���d�`��~<�y�/�.;�G^������i��*a�v|�Iդ������=F��֬�0ۦTD�.+�	A��=��z��,P�;����iz�g���`��"�.���lWQ�*"6p�Y�n*0W#ퟞ`�8d���m��Y�BV��5Ʊ����9��|$�-�Ok�#��z�_lc����Q)���<?��{\���#A0�`N��!��u4� �	SLIuu�zu�KS*�S�X�����Lo����X���Uv�bd �ny����n��N�_��V%�)���ҵ�~U���M�u�N&<"�s���ϓJʡ2�;�c��i|���B�7��n|vP���s�t����ށ�9�n)�1w`+o@�ߴ벤��Ӎ�tW����"����hsm�    �� ��4~%����.E�X��g��u'ϣ,��ϓ�E��Dr��~���ܯȁ�0���d��.�m^��U8��ǘ��}E]�\�+�8�{"���G�A���5�J����P|��R�������^������`M��X�|[�4|�Q͏�br
�����>�[��/Q�ݕ�`�\O��]������0�!8uzQ�	\���*7���Q��n���Æm��:M������0�#�r,a����4/Y�������^?�/f�6s�h�^P��&	�����HM�g��@��cř�C��K�tO>�p�3��!�/��^Z����@�����*�Ԑ���4�j������	�1ˇ����z|�#����0o�i���8�1^����KO�Jȇ�4	�%f�ln���� ;�\��q:���uot� �ʩR�^�ߏ���{7�����*��6.s��r�HR�e�;J�Xq�̨�4)/�;
AߤLg�N<E�o��۞E�S�r����'�'���h��,�ŁI?#�m䘏�N?���H�DvW���{����ֈ-2�r�]2ߤ]AM
ި\�D4��	��9^������(Q�1��d�1)��5�X�UO_�4bD剐{�:��ե�*ĥ�M��~
�1#wCŹy�7ֳm�-�hڋ�'�gV�j�.X#�_��U�>�%r#��(P��Z�(��^{�];<��(�F�)��b�L6��8<�ӽ�m��Ԣ���obq���l�=R0�'�m���v��۽�AQ���%Wil*�O���C4���Kt`�/�<9��q|���H�R+� n4EIZ	i%�!��g<.`Rw/��~u�2�5Hե��~u�_�%��]���������0M&�6ݳ,��`Ma(���I��S��w�9
��I����Q�$;�>r����ƻ��Xx몟��Ge�����_�^�$EA�e	d*�9��b�~�6c�d�瑯
�{7�۽������4�:pJ���'�*�26�Ve�]3@�R�?�4A-�-���}<u�b|�.��ۤ�52����}s�9���~:���JG�t�i��Q�.-���Y�WEn��������(⬡�YMY�&Gi�ۧ��"�/��t08�L����\��6?�aG��Է�U2�-�[��z�E�m0��O���q|_ńS�<���H`�yuh
k:?y�Fw0�?�|z?���p�F9�`Z�����M� ����e�9�Wa�㊪R)�!���`�ڸ�IirvU�	�h�Ei!ٟo��VWD4n�����BB�"��2�+���ܠ"�qSd�&����� �]���$4����{7�.�Ai�<��B�F�12���@S`����P���2)4�vE�@,�,ԯ�y�y���,��C�����p������/4f����>�n���깃0���
,��_��y�V�SQ��.D�:�ii�J"����%|��W>W��R�=��q\�q���+�������Nm��k�i�Y�a���i��ƏY`1)�e�,:H��BY1��X%{Xm�e���es� ╀Q��`�9VMa�W8Mo�������:8�zC["���G7_ހߏ?�C歹f�w�dۭ.��)�͘�]����]�T��J=_R�����!��{�s~y�,÷�X¯Ȏ�'R$j�F㩞���ƽH��JɊ�zU=�Ļ����$Cɀ�וW;XEy����Y^�C���j�I��$P��c����8E��3y��Y����J�p)ú�͞�&��z�<��z��\�5ۑ:܀��&w�~�X���Kl�>�)�#�$�\��a@�=;�Y�8����y��O�Zp�j!{��CV�R:t0�-O�"Fu�IGܓ��h�p� ��4K�r�,�j�jC�ނ�,-�\��mJ#a�⫥�s��[}o�]��2w�L3�����4��sM<���,�6*r4�L`���st갂��gb��F*�þ���>��L;��էe�"'.�I~�̰&��A���@�.��5қ�-G�J��������^C��W�&sc��	���F|aS����Y��b��=�ͿÈ��qi�)K�h�#�!Z����sU9��H���kYqD�$�nO�Qb��4�/�]���ww������qbD�l��Ϲ �󵲙���c�w%���<�f�k[mKmP�譚"�JǳF�0�\��=�����/|��d��/AS� ���`�ϥtA����K`�N��'pf�6��,U���L�h��J8�v�o�S2��0h����U<��H��(���	���M�n`(��TLE����N׻��<�����#*�l�jEZ͊T�wx�W�H�����	%x�d�NB�5����'�s�;��g�EjJ�m(O���W����h0�{>�r�i�5���(!;h5��rfDp?�h.����E5�=�>
��|~�.���hV�}��+	93c�{���m�QXy_�����E�m	��Z�RX*^V�
�)��`X���\}씭թ�P녨oș�?�4�\���兞v�^�$vVm�l��P~���R�I1F�ظ�)���0�9�i�1)�>Sg���ކb���P+�t6����~~��!�D ���p�0���q)`GFH��pMHF�|H-[7�H(���7$�=a�w���,}�u%���Ӷ��,�y�_|�?�-nϒ����Fu{�.�m*e[^�ߠ3r�r����]��#��~ �8�%<Ҩ֦���0�G�,d©��z�v�_S|�e��6����U�wl����ٜB�R&�zD���B¨���*����(Up�i�I;7��A$
������:�Q�)�[h���,f�>��_G����<C98�jU�K���
�XfȽ rn�[�͘O�:���0����a�p:��`c�b(C�\L���⾐"p������Vd	�L���RQ_��)�5j#2+��B��N+�y]�٭�[b]S�a$��Ys�`�pR$�	ֳeq��|�bF	�I7�7O�+�N \�z��ޡ�*��{لۀO��Ǳ&��0�̳�z�E��V,�EX�a-	8H�L"��9D�Z�4!�@$&ag���\�4�K:TAh�ɡ�Ջ��-;a�ʻ�����z\b,ړ:z^��v��}��N9�v���E���`ݔ6Uh;Ƕ���T`�*	CU;8�УK"$'��F�QCɂpH�pB�s�Sm3}�'	���:.����AX���������1rCn��v �;��kJ��(�T�
ft�ge�31�4"��_5�L�@^��x]�����p��8��b�A��^��aO?����G�g�}���kн��%�??�F���d���.�I;`Oô�Js4E�YR7@����q�W�W$���#�8#	Cn=��L���f�X�D�|�Ƽ3�W���[5��G)T�cK�����i�ڦ>K���,�����vP��;j�J���h3J[1ޒ�C�4���0��ѭ���CN�xf撑�_Qс�r]Ð+��_A�0�%f�w��V���v�f��lt7xW���,��Yy�K�&stt�^� �w:�X��ƾ �¸�j�����EgV��{�s�a�қ�ѽ��l���
���_��tn�����zW�M����J�l���R�	����3�p)ѯNf�}\���T��{5,ז�5\#X�:V����?f.k�O�i���o��t�i�`2�}{���{�zr����FT�FGS�ya��u�a��@� H�n+r��NsL��9�O�(&�u�X�U
��s/��TF�0��~�+�]_��(�N�I�Qs�ʈ���(R��|o�������`7�}f#p�2��W8B�绍r��{�_��+;�֊��h�Z���33�A�]+�\5�cb��4�ow�g$�[��E�3j����/�2p�@�3��z�wt�[�췻>;@R�4<�׉=�㺸"�1i���S0���h�#)*5�[��gP�a�XP:,��de�ɶ9۸G�lj;��+ڴ��	�����]mbոA���D�;+�@��U[    RTY��^�F�
@�t���JwCB�;���k�'�����V�*�>g�����\�S��^\b�`�P���^�S�6T�تL�kTTDGT����	��98� �`��+g�sTn��j[�
�A0|�\Q���'*���y~���vqz�f�X�^�m�kdA�춊
OU�	�JHC��/���`'���$r���g�-�u�a�\�q��褶� bO���	}�;����"t��6�y�M��q�Dp���YzqG���o�u�"I�"mЅк�K�2!�u���܇!�4���ĖccL��S���'&�v����>'C�4�,�Г���EE'�Є8�Yn�)�c�U�Ct��Q��.�q7-��ϣ��ˬ.	vx�O^�sӡ(�0~�Zu�g!��y�M�8�d�ۯ{��mܯՕ��N;D�c�����趲����Ob*�a�:�;���_[f)9��v�e�6<&+�ڂV�uI�E�f���I�0Lޕ�r�͊Y�}�w�9�}�p�!��6|�3���笖O�VS.Q��a
���?��3`a,H��.��S�bgj ������A�R�}��CO}͔`{Q%��F&ؙ�K�%6��.�Cr��!'��2Y��C�.����*e��d�e`{<� ���#�۳㣃�o���b��M}�ଜ_�Z+p�L7�+��A"w���q���-X��`�:[n�	Ԩd�N�샇��i�����z���!n8о��{�,q�=]�m�w[n��6KV����m�1�6�6���p�#�ؒ[��jPwW��R�8�+��ƫ�`�q/��n�w]Z'�x���:�����L,	-:���_~\��ںDJ�W�l�aK�-�9�!RJ���6�����!V����wK+WL��6j�N�������K����.mu>Σ���.ͮsPUĴ��l�!�j�u��"��!x��0�WX��6�t��+m���<�i�8������Sш��X��ʩ�ĸR����*[-��u���i��vEl�zV�˙!b��<�6sReW��c�2�Xa
��R1�~��	��XPAHN��e鮹����%	`�G	Nٛ��ΐ0Q��8+��葎�}��X��׹A��.�bLޥ����c��#oc�ϑobş@�{k\�:����J�����Y%P�LEhY�{��1α��v�z�*f=<+L��Q��k-��+�'���V�?�}ҋ<�������ކ���ujFI�]�����p��;l���%���9n��_��*<����(a#�/�z���}�!x���D��m6Îh��l��ӛ�5��dW"�� �j��l}m��9��3ÿ{�yw���p�.��&P`\ϯ�L��l��I\Β"�<�ޡB�!l~ �F��M�J�Q�EY��:1��3��l�)����R�Ǵ�z��;���'�u[�|�7�y��k�@�~�lu�;`S~~�o�k<nts�y|��]��Np��ϼH���ָo��#��_O��wr�;8Q>�o�ނ�p\LuO�G�b�y�b�R}Á��7���T7��4��y^B���W�-!��ڥ,
"^)��HCfu-������~4��
P�����A��f?K?����50�5�6������A{��K{��e��3�A�,���;ٜ��켃A�S�=�g���`�3,1���{|V�c�u��'P�s}�j�Z�A@40J^�LK8yh���>��ah:h7޻����G�O5���I'�׏{Ucm�c��y���ԓQ�YlT�C�,Φ�פW�Ct"}�����4�����3�d؜؀c�c!�|a�s#	C�v7vIʊ���,��+�S�����Ζ���䧮�[M[�J�8�����,��W�������������r��9)>�m�>���c��މ������0��4$jK���ĥ�P��!�wЏ�o�� ���b�F����dL^��q�T�N�I��\�5��alpl?��ճ��~�xY��wlx�w�����wok����|��>��$�NI#}�m�)!�	�'\���r����"A��h��sG�:�!����<O����`*: 6��*}�#���tAS�,ϴӥ0���Aߕ��=�7%aT�O�BA���l��d�C�&�_2�~���e|~�*x�rS7������Qt��Ǭ���m�DU(m�_QF������a#,�B�P���E;E{��\��j>�Mak�3֡�"�����4mH[�s����u|��"o�c?���,ܛ����E<7��������d(r{��㿦F�����7���|_��ps�Q�E}K!n����zF0�~�q�H��mN|�#�4�Rw[e��a�P�L��Z�EDC*'���٤�z�������w����馥�����dl::^���&�8�?4w�l����ooc,aZ�CF�Ÿ²K[D�����#a#õQ��9/Ҍ�T�`�ӿV5��!2X�<�S8��جe����/<�ŕ�Kge�OҟJ�BF9iuQ��׃��j?L�z�Iv��2������FM��S����ty�Dz`'�!X���R�M�˘�Nq�[[3��!���Sԃ���/ķ��Eb`��k��@�|nW��r����i�����7��'-���Mk#���p�L�V�9T��z����V��a`����:y3믶T�QM؁ʶ��p/e�fy�{�;_F �Ϭ(lfg�yע��G�)ߓ�꾱�02jǚL��Ó��[PS"��{Jv�����"��BX>��-��Ű�aE�x�-��K���$���Fޔ�+I���"���!ya��38e��0	�5濛G�X�����:�� m��h��}��h�������&�3����7��>�/R��W��/.s�PD�������;��S[�i�x�'�o�5Z��Ȗ��3��y�����}�mX1\�L��=�gX�;*���6p�+�O�J!)�#��pd��~�g܁'��E���6o����ܷ�)�O��˾��E>j���0Ӧ����ǋx:�����M�P]̋�#���y�a�v�#N�Յ��1#L�Fʲ�{�&����\Wh�>�+�vh�y^������,���b&�U�U���|M:F~UyaPr�qA�ra�:����4�#�������m�e�,M�� [��VN������_eLB���:Z��;
G��$?g���|]�(��V�D1	�W�JF��6��56�s#Vpi�����+�+p9VM�l��mt�m��E:�/.~��c]?�߾�I�!�3���S�A"��v����J�D�1|y����n���?�S,�_��=dE��!���ceC�s�+9�jv�����ý���� bP	Q?O�p���G�٢ҧ9��t�R��,�6T�"�U�����$����e�#9�j�.��|<5I�W�,I��|�ۯܔ��=�>xZ�/�M����8YK����g[��#�3ΈWTƽ�3��4�2 9�G��yB�P�{��Ke�;^Xy�>�A۰��x6K-���.�
�r�I�]����$��g/^�'���s_������#(��,�r�����M|�S����X"�{�%z��M��<�D}6nbdu|� ��M�4�� �U��m�r�h�����?+���0���
z�£�{Uu^��I����{�B�0�"'��r�+)<�p�
�f=��n�w�E���=PMpZ&c��/���#H)Ő��fbO��K|�s��,O��6�q�tD+vmDf�жCC�]h��a�݈*( ���B��ņ�Dt��Z�I�������R\�[58���$�V��1}�6^�r6�O���ϖ����'��"��B)/d���7/gZϒq*��xA�bA��E�J���ߧ��n)t��{Ps�kI�����sn��F�^.�[�%�djɦc�e�/7߀F�U���0҈�a|��������C6��5��.5���6읜�]���f�� �N"	��v���JQ5�U���Y���/�|�Ff�ͦ�E�mFHH���YSw	�P��}�9N�����s_	��������?� �#��1�&��W�*^j����7    TdSS�݅Q�*mQ�0cB�'SU�g9Jm/ ė�4�(��>���!�q2b>J2�*��JN�t◉��Q�����jmL�b�ju��i�^]�_�~��(@�U�#>a���9�<Q���c�<�6,O"�hѪgs|�a����.2N_�u���q������o��DS����� ���Լ��i���+������+�gj��2���y�
o>��}��`�|���6����X��ѥY^S8��)�	�J*C[�Y��]A�<�,�+b:[�g������hD���!!�V�g�Zm�B��"���x�Gn�Ҥ�?�ky����nͶ��UR.�Os��Rp^�,��dHN��1�|���"��a��Ў�|^�X_��w���5����¸_V*t�C���������[uw0#l1	:�;�ʰq��U�C����<$*j�7�$�2��	���?��>���S��Z�EQ"M?������m��u��)��^�D�w����n�y���m%�S��cd2���0sT����b�ϋd�F'9�$"TH��>��%66�K�%2t���)W�%��ul�9ĩv����h��K�Æ�"4�ٴ�Q����7�6��u;5�!���k��Նm^')���i�i�=jk���Q��b*$a�לiN _4�Fy?,)K\\{!a5v���O����fդ;�;KIl��R_���x�`?����|��i1����[�,�pf����Q}/��m�;�&����In6�x�c�Y�e�o��D��Cx��<�w���õ����7�޶ao0xv�����;ͩ��y'�A���7ʓ�������Y�A�y�ca��霼H�Y�j�0/0p�D3}C������6��$щ#��e���`"���A�y��斗f����6ξ�D�.*�O���K����Q~NPT�����}]Q���~<������"Z�X%a�f�+��ff�OI���(:+k�/�*�k���ir�%5�O��\�/�ym��u~e�dM��^0�0��r�����MR�o�������b����P��U��|���r�k��	�:@}�U����_fd�,n����HEÀ��RH�P��RW����5�Y��5M���F��O�>���Rs��L:3x�^q�aaO����~�R���\_mX�6z����j��!z�9?<ը��g�qu�y���F$�yt�1X2�"�7�ô>�4>�{գwIV��t|�K����VW�^�7�΍T~pǯ�Ƚ��ɩ8 �΁������:��,�N���1N�A��F�	�������Wy1Iț�/�IqC��@%mp0�+t�nL	�J����[��(3;ۻikj����2��^8h9���-�ܐ=��,�)"ݹ~��}}/��۰@��"�!#��\���}�]����jK���{R�4�ٔ;�uͅ�D��0��v�����=]���yN�l.JX.�!$f~��rzA�wԴGm��XGWK���Ƽ��Bl�B7(��V���wؚ�X�����O�8G  "|^bf^�la�D8��<s�֫n��(�C���$�)�<Ը쯑>l�{�To�O�L��L��ʘ��|)�L�|iG�w�	u��kn�c����TY���M�S=����7��*)bK������8��$�g��f�(-�9;ܨ(򨭛��0�̆8[��M��DE�c��S�t|����W�2��6��UU;�=����`���fz\��Q�i>�ECB��[�#���_�,���3MH�]s��@��@�	��L��)�/t17�d/!�+֤�!l������m�M�h>�����lo؞He�}�Ò���Y��Z��s�wi�i鬦hhE7 ܣ��h�]gŨ��Mrk���J����Z��9�B���[��Y��r�3uoj/��;�.�Y
w�g�Na�9�?�<�LB~n��H7�˼���PU��F��YJ?��gs���΋[x裃m4P|⃓*��=5�9x����`�M�?�}Or��~���3�<E&�,'�)�β� @�f��q����	�6�t��4���i4�f��_�U��0�����K%���FF%皼*a�޷�#�iJ��~5����5�<�p2�J�U��"�[�^�W�&R��*n�Pfk�F�����Ɣ��٨��`�+f�6�լn��HzRUT�/,@����y� <$��ğ���$�m��z�E-�rȕ�	|�Á�e�Ss5w�0�)W�#z���*�i�,=Zi�~�������^���/��..,��ī��bUC�AAp��Xˋ��8�a���j��4���_�l�K��T*3�)^E��dy�����;$r�p!3���o�V��_��mF`g�rM��Y�%���=�B�ZN�S5�s�:4�0�^�G�_�aA�Kh�ٓ7`����t��p GD��Ѳ��>É߁;��y^��~��48��L��
s�������ëq7�V[*F�0͙q���FCg��f8\)l�~�E�2��ł@����y���V���W�]�o����;��L��Dhꛛ�k��V�IZ���F�@���3O��J����e�!Tb��5NKN�
be_/s0����Nu� n�鴺���L7BnwV�uA%M��j�F��\�ݕE���XU������ӍNOb8#I��E y0��^AKVc��<`�޴���/�Y�\l�;`Ӌ|~�gF,�k�GR�������Q<�b�F/���d�."��r�<�I���̠����z\.|Ja�W4s�`�>| aJZ��9��V���ۺ�`�-��|�y�韹�]�%���rw�����Rs����2xT�ţ�T���*3dG�*���eG�����|F��c��ȼgI���4�$��?"���H�K�-�V��;�ގ�+��t9�G�f�l�G�R%7�hL�}��6�'Z���tE�>�Z�P��f��$�n�����C��x� ��;{P	$9G������L�:�o���F��*d;_$M=a]P�<z涱�%���\����x0�#��C���\�Wa�.��x�a��C����Y��x����:1گ��|p�#��p��4#�g����Ӛ|�Z�j�fB1�?�u{��rǙ�n����ӕ��v��MK;�׮��M?�� 	�����g�a��#�^�,_͟֋u��!�&��p�d��Eڵ�yi��O:̵��~mf�h5���ER><�Uu�`:<D�JW�am����tfZ�������4�J�)=!<�ЕvR��:�L �7D��u���7�#S;U�A��V�k��a��.���Oދ��&Ŧ��#��F] 	n��Υw�C��?�ǆU8Tl����BOVP��PZ��;]kB���&9�ʪ?��z.��b��~Z��ҡ�D�Z;�ɤ�{�j�� ��8#O�������rݺ	��w��v��v�9V��
8����	�F��b^Y%�`��0�C-���.�%���,��*-
%	��5ֱ���^F_��:ݰ�2Y���dk��&`��wɇt�ݑY�@o�/p�v*��]ǚ���e-]׉(�4,h�I~���7��!ƚO�M#pɸo���]�~h��t�EN�P*'�\ĺ��зOM��|�>s��O;��us��H���Y�]ۢ��O�;/	�8�����p{���l�{*���`���%� H��l�r����Vv<8=U�Oe�1�&��˜_�V��m��K+ˎGh��:��=��[5T���x�u���Ҵ�;�t˫����q�b������02�Y�xqXB�;���N�{��vi�}�e�H.��3��[\�����=r��ﰕ�?�g�"��*�����ʴ��*�V���d�g�O;��EL�ԛx6����iS�M<��� �q���U�����`�_����
!�����+�gH*�����V��݉�:�O2�\�� <���&.z��ya��\���!Jp%�8�����K�l���Q1JqSmj_G�Q;�mHN�F2k"�}/~+��$E��ؓ���#g�    ��T
���ݸ�Q/�<�
w)��mMo�vHGWv�ۯBh�.%���&~'��w>���2��U����Y��AH���5 �o�l�=��2ɪ�w]��d�U�DB2���{|��r���0�@2��~�>��.�ng>��m��-K[I�.� /���?��(Č+�����̧�n��d��pg���8vW�����?��e��Y��~�͖��F�qU堩!�[Ƅ��1xŻ0����_���?N���P�>��p!�LEb��@$0f:O���O������~�.>�m������{�u����1ܖ���K!4"u���#1�<֤�#��&-�M���{_2w;��ݖX�����9��P�0���k��Ł�.�x޴���ZC�]	O�h ܐQY�]otI:H�H_jѲ��afF�����Y%9�}KhQA���5�02���2�u�C���Յ�v��B��5���0�]F��q���Q�1��Ŀ�t�+�u��<�H�a;W=�z�t���8�~�Fi��Y[�\���K�s�H�R'��/_���s-��0$:�N��5�� ���h��࢚�T��+zW�j��~z���U��ž���  ����f	��R�IR���6^ĩ�W�[��!������3��Q\NGdR�@���hݐL���xP�ID��'Ξ�\��ߧl�2Hyo����w�ɳP�oD�6�8MT���ed=zMY�!�BkB�NJ9���q0��"i?E�_��Ǝp��v��U9�q%��\��6��/�`�/�2;J>�&䯒yE�i�Ep/��9�%���Z�fw ���3`8
eN��tK1K��p�q��ӈ	4�9ꏻ
��`�̇�,�j2˱��}{����=��~]�`X�1���:�\:�tVP���cL��Y�gD��Z��f.C+��wl�B������9z�DJ�b��%+�Q��e ����{h�����٭����*	g�jZ����+LdkP�&�lc+K	ZG_p�I�X@�@��E�6L��7͉�����e
���EI��V9�v���N�UB�_����X6@bF�)]z2�<ZKW�0�V�j�Ł'�@�{N+�_O��8[��ԗ|ȸa���9D��qwf��Mg�}��^귭�iv�ڮX�!�@#��!��n����@��̦�,�}:�7��M�		[�wkP�e	,�E���+R���W"=�e�l�l
^)�ZpXc��\wY�!�,�GU#IUQC�.C�����ܰ���Vo�Q6����u V�j��*�N090r��(�HG�yv�
]q2ס�=��;y:f��љK�H�����TzL��H?���RP�yc����Wp�ҵe+r~Q���R��Lϵ�-��vU�~U+���ma��S�B	;�wB�2_N���S�l�a_E��J/��e1�Jq�b��e���QĪK>S�:�'"�[
�@*�
�ۭFv�S=u}}�u;���mǋo�+������g(sO���?-3������0�B�p!a�᝟�����FI�j�a�&I������f��G�Ӫ@νm�x}^ĳ1y���^Q�7���M'��rjg8Y�}:;;*h�y;t}���+�L�\�\3���;��Ynx;�|�d�z[l6Ů�B�<ZA�kj��0����e�%�ƔV��C�'3R^��@�u���q	��R�W��!u����)��2�.�e3>���5���b���E��V����]ɍ},��C�7��17{k|��-)��a;(�����Ä�L���p�#�lU��%�4������uf��OxѦ]���+�\+�^��Yzg9�ٍ�I�7y�5���9��di�Zd��}/����=r�.�D�S�"|�E�G�3b���w���efz�E�뜉�Y��P22�G����N�l�]�5�W<�9E;-��\,,/�nV���n��]�,��bKU�hP�F��k�]'��4M��*��DQN/�<_�r������yf�⎥	1x+������c��?'/�h��9:� G�fgc��.U;ރC��F�aNΖ��fHd�(J�,f\Mwϫ���_r�m���ht�����������]��+8���*?�7�^�͛������)�ᑢ���2�ȪY��]�ݻ"װ��q�6�KDB�Zb$����/��~����Þ�\���0Ln���h��w���FCf�<W�TDè�"+��ܟ��:I �u���͸G( ���5��6��U�!�x��"M�Ƒ�fX�4��7�牋��ȼ��]�x^PCw��.�z`U�6O�aU�� o�O2�@��������y����C��� �Qչ'�H5���8�+�#�p�uS��h�Fh�J_�{�U���u!)��X+����i���E��0ߔ����>M�?�����^�y{s���df������y�l��	�)2A��3���큇��erS`�]�p�h�L(8S\VQ
�D��m"����+�k�u�����/�fr�5�G�Xj�����b�@�`�HG����O쇝%�/�(m �#�S��)�\�\2/`ԓn�w��N��nmFA#
�w*�G0˼��6�^L{xru��$#X|n�u3�?�y���Z��#�����1�1�ݵ��'�R9��S
�4����)����k�az��v�<�]��y�I�i޵�ھݳ�
��F��q�x���4j�l@���@Y���s�]���sm����Z�>��n���N�R��*�P�,��vH;N��'�a���s�v�ԁ���~	iN�T�S���,)�|�����aj��ʾ犿���ƍN���H�Z��M�L�nQ'K�� ���q���s��l�X&BV��1�%yC�F0FU���Z,�z%����8y˅c��+PXM3�F��������{wR�{n�ne7:���:Yfe�jF�d�����*�d�S�/}�'�ƣ�|놥�st��t�y���^/6���w�)���r�J��.�Q��kN�4���\��v���;/3��Jp���_WD��N����`.���bژ�i�H�1��*�F�G<N�
O�0������N�h'��B���.w�����Sݲ�`|�!!y;*� t\�U�g���@�6sb1a<����ۈ�� ��6�>a�-�����}�Ӊ�fak��C=�B��(�#�/��v�#�m���dl�AMm|�zϓ99)>�m����e�痿��&m�$^�f����* S��U.���UU����"S�?�ϋq|�\bb����H��\
Qr[W�!��`���,�ғ6��j]��d�[�~��R7�]`t��3����8ݗP��e/c��������l���:����]Zm��$�6����Bgo^"���1���h����e�̈O�f���c�ஔ\�b��w�k�8K�Ub����?XE�|��}|��@�6�y�ͦ��[��>$t�x\"���z��r�F=Gn�(;5 #���ܝ�g�]�3�S���^\|��Ǳ��G�d�>Ï��u�T����$s[)r�Μ�
'��S.p '�b�¡G��;�-=�M�$���O�� ��e�m	Ns�gy��[��_�E���ӯb�+z��m���	������<[��D �������V	�Z��m�!�'B��J4�����B�
��)$�lH�	i>��������z>�)�*��"V꾣oO^\�������Yq�0������5Q+�ՅC����.���'}�qV+ �Fzߤ��D)��j+I����j(#J�l�`���F�>��JO���`��������4j��[����>j�e�e�ϣ�$�`ȭF�������hD�S��K��<��_�������H��~�"����,����g$���w�Y�è�?\I�E|��^T���
��J٣�	{��U���0Rf�E��iy���(3Ͼ!X�s�u�N���#���FR)�a���Z�p%ͥ���Ru�HR��a�1&����ҵ��wR:�HR�V�QGm�.ߵ&Q^����sN���R���k��iwW%w�vb�#    �|l�s���ҰQxg���|��U9^�w�;@�#��t��Y_��r���	�{mP)�r	C��ic<M� F�ݒP�XK{�a�^6�V��NO��yK�^�_�utペ��Z�e۰�`NNPw���6ܡ�5ng♩��F����,
[��-�+��|-�Eb>f�P�"l�h�aGc�)w_��K칃Y�����(Z��ؠD�nT�a����p3���zS_�R�����l��׵*��IfJ.�������U���C&�Q��ELnQCRq��Ε{f�8��y�N��s���[~�[je�)�y��uض���t��g���:�_��U!&���ts n@F	|I��0Jn�8O�(7N��A���b=�q8?9$��s���������"��F��cu�����Gpѐ}{�d�<��"O�z7�.rtq~D���f����S�e1�_F�νsg^��@7)ʥ�'3}��|h�L�U�~�E3��!O�!a�%C���8��]p��.w(�	=���ح�\�R�JV�[]����a����=�I�����tU�3�T3ݛ��m���|�.RЧ D50����͗Yg�'��y�A[�P薹#{L6��pD
ϊ~`Z�0��-��#"�꼬��׃}8��	^k���Qo�^ى�[�����-ׂ�5��Z�Tֲ�#��������+gG�P���|�ʡ}X
_z4�Z9(�H�`gIQĳ�HJ��~=�~��ar�N�de�.QT*r�lL�&�|�1��r���rO��Z�u����\<��J��$u}��K�e�����X���R��i��e�%cX�^�0��y�lti�R�e��R���k�	2����i���o�5Xu;���f�I�f�K��;���:�N>3��{E��W�<�iw)�	W�����d��O+"���J�U��1��ܮp�m�t8���J/���!��u�_;�X{h�ɋ�z5��2��e�ث��Ez!`�B}�a����eE8�Qv�n����y�~F�gk>�u�s|0lU���*�E�$5o������MQֽ���Ӫ+��RבLsR�S�����I���k��S�
����:���(;�W����U"��U�
撆>�N����N�wW6p�VB߬1;�JYՊ`���ez��g[#�-W�[շB�$�Šp��I� ����aC��sU���-rP�Z���	�68nT@����ĥ�������qЗ��vq�m,�Oe\�.S+�f�-��e�"�uK:g��_�5�;K�m�Lˊ�}�]#�bҒzV�cZ�H�O���Κu}�b��~�����4~1�z϶�s�|ْU�e.���N�l]��<W�6q����q�h�nr
8�o��Y����P�>*�v�X��pC��|N^�JJq}�7&<��>ӫ��k��{�b|�yBޞ�=$L��=�j��ĤI<�,]̒��*Q;�
�
��blݗ��$�i޳������)�T8�Ȫ474��{<h�<�W����&7���u9J+�?��:	��Jb4�!�l)S�bAx�*�����"Kg�x͓\;0,���3ӳ+p�a�������Go�oף�n�b͍��NS��o��`ȴ#a��6>;s�6�p
���D��M�W��lҩq��P+!�J�����٪X'�q~r+�V_:CPK�;�7���XY�y!���iR�&�ϼ�5?h�KI�Y�f�kc����F� D���Y_ǫ��ȏ.��%m���O8c�6Jp
����3e��yߌ��V�Ӊ����aK��I��b�
X�$��A^�ō����$'Ƿ1S�%A��g���|?����5#��Ip�������kYnI����ڱ�Ġ( �j��my��C����8 �`��|̕���r���w5�֏��z�E���)�o�x]MP��̓�紪`T�oE6�EԹIn��/˕�=���gI�ks;�EM��:�1����'��nf�tR����f�wL)�S�2o�H�SO]�I�̃�]�����(������đ�g�M������xŗ�)6u�'�:*rM^U*�j�[B��&�1��G�cM��*7�����\��`m`�lS%f�Z���.��&ڵ}�+5=������ԕ�$��lBM�q-`�}�S��c�5Q"��gu5L������y�-��}���OZ|5��x���fv4<!��qRXpW������F�~����bz�7x�c�K7�}L�FM��'5�Vg|�=<
8wa�k5�|�j1��s��"��L0����9FZ.�"w�=߷��Ԃ���&���Vʋ	���)jt9-%YH=���q�8mo�n�P�'\�5z��Pr�2Bu�z�]��g��T,ʕ�K~����۫G����������h��Ol-7ډ-���l��4�${�:O�QC�� ^��_8�:�^���o'<V�zM�e-�a�yX��R4t�ߓ�:/>�-�o�v�����6��Z�XQL�`ϩ�E�x�}��lH�k�?ei�^f	�H�|Ǹ�?#�Ʌr�u��e����q��*(�t�H�G_`ֵ������ڪ˷������C�������S�n�A �����R}At�a�p�ic���Ī>q}j��̥lcs��أL�����OFI�l�n��3&0&��cW�� ������2w����?p�G��*+�w����rV{;����X��6�0tZ���~k���[��7��O��'U�	��
N�l*b&u�~�ܿ�!2W�2y1��" ��p���HL�P�����Y�AD͎��F7�18zn�N���K�u��Z����b�� �%F#I�&3��g^���3Cք*�I޼D7�F��fZ�.p�$��F�@�H�_�g���U(���՛<UP��N�R����|A���@>���w�U|q�����i����z��T9g^(��ǎkp���o��#���D�fBʔ�([�c�
ٍi�̠��z
"Y\*�a�Poį/�������"3������<�\.Z��,�a�`�=�EQ�4��p��H�BF NE������-ɵ��jX����-I#rC��MS*c�M�?K�����I �#^��j(�g�e��Yq��nq�B�,%,�Z�{-��Ĳ��o�T����&�)�v��Rޣ��f���7��hE�l!"O���s�����'��L�,$܏����x������V|�ƃ���qR��P�.��`�T�ko�j�hRe�]��c�w�ޤ0���7߁�d�����P�`���b<�S]��x�w�Dߕ��<x{��$��$�J�2����F�{5�Y�&�gy�����ҫfX�ù�4�@P�x3C)��G~#Z]g�p+BKp�G+RX�8`�Ƿ[2�0-�m>1�롞�������V7Se�3�H�䳹>q��X�<�29C�Cݍ�����q6�"9��}8�I6L+m����G�J8��-B@��ݭ�;����k���`�|�@#鴜:��/OF�@�0�Z�U_�%���B�f�����F�p�q��O�jt�X��k8	���^�5C ��?�31@s[���8�SE��!Ӳi���;�b�8���E��t�J�'�O/��ځ��~/�eL/5^dZ��H{"�/g��ԓ�:�3�H�%Rf�cvu��$����#���LW�j�7���慷p��t����iB��y�]d%X�^�e��|i^G���U�T`&��N3�Wg�ׯ&;&F�~RrV�]2.�D�F�R�֧�fӏ۹«�>�'ڹ�E�B�M��Y���"h���w�:����e��z��ٻLWI�L�ݛ�'Q��v!���+k��\�&�S7j�� ^ =�˼��lO*�dM�Q�JB� T=F��j�����F��(`��/�z��)�8� i�����PNͲHb��XW�O�������{Q"��K-e����SVO�[��{������;Q�n\t�
j✹�y���(u�Fo\'؍�B�D`�0"�p��+7�,ɶ�.rgq�>�@yv���x�8�i�A�V\��;�ؠ������u�k���M�7���ɯc���14!F�H���t �  ��e&P�ÓZ��^a�)]9�/>O��hMJ3E
���A9ٰ���PO~ _�/gʢ3Q�%���L��؜�i�Q�tp{
�x p��������c�����<���� 0�}8>F�m�Tάp�'x!7ԍ;�%�j&��7����55TW�<��-�Qs�����Aw������q�%s�,d����5�&��r"��y$��e�kUW��s�����p��ժ@�sy�X0L�Q3�`��c���h+/�?�u7ma7����M9ҫ�L^Ї��u�If����u�9U�ԥ��!�#��1�)}˱�&[��������z�D�[d�*,��8��.�T0a���<��i�OH�3)��סZŜ�d>�B��*]�"��.ޥw�}ݻ�����W�{� �	�6h9����W�l10�-�$�_%_�uVf�Jo�tX`��f�����S�Crp��ڇ�Ĝ�bl�b�\G$�^i���5�����EY�^U	^�zK�@�A��������wc;[0K�_L�:L_�4��|�%>M�����|�~�a��y�eH7QH�jK���IE{_:��0/��4��fg��i�;'��JՉ~���V��s8�����{Uy'_�Γ���И6��êvnqq*�Ĝ�ro�:��ߏ����Z�IV���;7ͧ�3����I�&.S:���e8�Db�2Oܰ!j�YJp�t
�p��.`���c�P�)j�6�x@���u���|2��C�x|�����Y�]a���w�<�����S �,�@*q������m�u[Amss�!�M�~����QY(Cz���=� �3���}�17
>���f������$�x�`[0�@WQ8Yc� X2�rv��H�I��Y��P�v	4��P�!iJ�x �"�G�f���x�=�B7�Q�aU�+k=���#�Mc���`�y���BP�%mɅ�ĜR�SY�-W�K�8��X��Z���ӧ�Z�F��}Ӭ7��w~Cz)[� ��Rz]sq�r�l���b�H��4E�/1-	��΃%<O
pEPN�nlS�3fM˥C�X�#���"&~���)��P���Q(�E�CL��Z:��3���YK���.h&��z3�G��9q�p��E6�C6���`p�;M��,/��>v��*\'/�
Ö���RN_�~9�M�\��K�eh�j魽C[�G�y��Z��$��e7}�-�b��_
��C���j��YZg*�{RrO�NX&a#9gI�}���qu�F��)��z�~65����l2�Y��|I��{,����2��D��6l�k���(��͒'�E��\Ȥ*y���8C5ns�AH����t9��b��qN�����Ui(�-�2_��b�h{ן��\xC3��p��I��"�-eY��!b�+�Kl̀@�,�S\�k�q-7�|�F����p�'�3"$J��~�	۪e�hG�2��3����n����-X¥.�P��6��B-bl�t���zݍ�t�Gz��e��E��������½�!W����QHk�f�.��sҡ0����"�U5��GI��A���n��qf��\]�u8o1��Z�ø(���TM�a�S+g���Dƕ,s4�e�0��2��I��7
�:�:�bŢ��BJ�Y7��	��Yq�bݒ�:v��2�Yk�Wm�pM�$9���]^�*7\޺NI�������e3�
����I�9�e�=0:��\�V��уz��i�����0R�Çz���x���f����:)+5���$��`"�pvu�g<R�0��;�_�ނ��7B��*	Xٴ�g�:�Or�S��>�fD����Ivs���D�d�H@P����1R
T��׺�<�O�u��1B��0�Nr]�㛍�x�8�j-��]�m��C���G����_�Q71	���ϗb]���K'-j�0N�ؐj�Q}��40R[� co�h�b��
��eS��OU}����Dm�1����`��q��CY]W�QRw׃f���r��>'�c��c�^ث�>A)%w&�3�7ѐ�j�&V�I+cAta���"7x<��y�M��;2�E>�n�T0pHe3�����08����U�$\N9U��<�7aWu�[�9{q��4 X�_|g�7�l93��q5�\os1��l�U�����)��1G4<R{��LN*���Sf�)_'�&�!Z��ط��2��˱�Z1x�A7�.����'�>ך������	��&�T��*�܉ȅ���*���"&ШD�J�0t�S�P[ZFCN���M���S_���#E�s��c��L���Ą�>��8������M�a ���t��AW�Z�!�j���:���GL-�[e�M���GNQILw��U��`�	f��3�i��k�S�=�����wU�&Tq��x�̺R|�m�k�=�9�2� ����5c}��6�Z؉��!�*;�Ή�<y�����>���Bӑ=�A 5s� u@Q�dФ2nE���}w���]/�v=�&hq��܌S�Ee����)J���E��9E S_.��x�1)r	x�|��K�"��w8ɧ��n�B�Ն����=�t�<]R4ъS��}D�y:�j'W�D4��J�p>���d�0�����Ay�se4)2]�ɶ��4��G�A�d,'8�I����Ao���5{���c����ay㒡/��;�mM,�Ըس��.��N�������HZ�=��%yY���W���dD9��s�B�4������֎��>�ߒ�n���]O��o0�� � uE�UU�H���s�OF�Wa�mGt�	��ڍ�웜K����y��
��~�f	��_�v��񿽪,��P��+rS�28͍So2�1�m���p��x5v�6�u����:�/3p��R+O=�����)�4�^u��``Ucm0Mc[�<]C�<Ę����q~���`�����s�U�z�p�LDćo�]gW�D)��g~)5d�Է?z��2�@\F�o�ǂ����-�qi�{�sO��v�T�AXP��iz���$+�'o�*?�T���P��Y�>���ڒ������k��������i%����BzQ�i��z�O��hTy_�V��j0yϳ3<����c7\�Xw�p��.bǉ��+X�4��f/~�jd7Bb���12�鳬�X$|��E֯
���7��l�CLyX�����}���#�	�������3�l|R<�T0�eᮊ�gh8 �0��0>�FL�qT�^��VJE�ORr?�pYw
��?�Ptz9���y�VS��%��lY�b-�><��|��<R4!��/s<�gp����t�������Tճ34ᔟ+$fH�j���WF�t���ȕ�&�����л̱�N-��R�����f�T�~&�D�@�:U`AR����q<L�����.E!g��:���2s����C0�K���fɚ����,�'��nZ��f�,u�<!�0�h�8ٚk
.��*.�|�f���GZ��:��f{u~���jP$pM�ݟ���{�"�+4�ؽ������e<��Y�t��]Ġ��|L�҂gH�8A�i�4��߄Ψ�d�)��#�ߞ�7? H�a�E��x���R\u|/U��]�!f��j���P��O���sY���գT)M��c۸����N�iUM2�d  ���o��sC)�x�y�plȻ}��(G^�IU���i�4w�fg��mQ���}V�1�pWo۟8��(���N�[k��"u0͓=���j�����������}�      f
      x��KsI�.��_�;T�MB�xMo �dH ����,�(d�  T%mg16�Y����,�Wcw�fUֳ�vW��?��w��xQ�L��l������}�w�v/��I���1�x�����I6g�&j����T:�q6��/�����~��_&i7n6#���!�p���*�^��~"��]��C����ʗ/
H#&i�?�uc| ��i��	�<z��bR'��->�6��i�DI7�Ԗ��8s��{�.)�˖oY�l��n���:����Y��-�.�E����n�p�ગ�^O�4c���ߓ��jO������U�&�(�¡���1�Pu����C>�β�)��ɛ�]V��_���iZ2����ד�^��I3�t�����񪃥��HX��T��� {�".��5��B���u%�l=�M!�dL~MJ�녮K�p�����]�|]�)ҫ��͑$kō�2^#�)?�&�{���x�pxu�8���m��~t��ӂ碶&O  
��Iw�έ����V����/�����{�*�C@���z<t����~[n���I�)WQS��>\�馗q/�F��A-I�镺�����_�w�j��~�����7q�7��x5h��R�W�6�)9u1=$&=����f�ԯ�qW�����I|���fRP�/(0�gR�Q���T{��fډ�4�N�Ȅ��i~�:N�+�K=�1��x�O��r!YN֊��k�w�p���F�(�����ϵ(�t^GKփ[ټ\�*�^0n-gn�|Q�8���l��j�WW��2�RG��b���&镱�>����͖��6?�ƣ��������h\N�W$K{����ԓ˴���O/j�7p���HI]�u��Eo="���F��Z�N{���2n�ݤ��˨YO�J�4�6��u��J_3�+��+�_ϼ ��M��b'��7)���-.h`�
��3�otC��Q�]��>�3�&��Q� ��H��0���q�w@��n���U�Nˤp�OI?��|�k�y��4� gI��D�\��e�oK=ߤ^�M;����}�! l�}I����b�i�>��s��|F;z+�x%����4�њ�G��L��<ʅ�ߏ3���3�z�NI����t4�����:�~�M��z�/JHW��p�{,�y����T�͖2����wA�}�d�<�����5�$�.�Ò�Hl��� )'�$�Lחʒ�<��S7`�"���	�CY�]Vq��-��X7L�b�>�yP�+��;$Yh��7���Q���6�FaҸ�'�c�*�J���'��W��f��ARBx��d���^=����o�U�G.�֭w���^_l�I�����	(��	�I��m5Zp�@�z�T`t���v��;pwZ�#�_������C�#t�x����~��S�Jo�+t�]P���w�:�e���AߠaK��^܌�B�\�̻��@��멻P�$���6y5В�+�
�+��Ԕf��_��n�w�Y�j����$�Q7A�����8.Q�m�n��$G'i+z�����AW�r���O�8�� nU�vWR�:��a����9>8��V �u�M/�^˷�M#�� �-���iŰXz�x �8+��	��0�9�.��zK�����:񜽉7h'p�����ӌ����=4������qUS�[OaK�D�YQ�V��G�$�[����&��%&��iS����<��W�����UڼSePS"�3��:4 �\û�{��]3h�sݓ� E�z����g�D:�����ɱ:��X�&���f�U�	�L��y.�E�ZW���*Cv�y��둴ق�K���Mn0�� ��|2��pcO�b�j���������[�n�pO�269{����=)O4���c5mǦ�{
�]��AzrS�2��`�z��K���%wC�:;[C��;�����ͨ�lQm!Yɯn=I��O+����h���N8~<3��h1��+�����H1B��<��@�+�m��]8����@���;����>L�H�LB��~��~��B�/�U�-[=�^��F�JҾL����O6o�W�!��M7�5	n�t�H'��c�\�V
ww��^%�PƧ�����UJU��ߎ;�y�����|�a���ӗweq�����e	�J��.h�uH��=��u��2Y�� Lbt��Y�v[��(�j���fҊ���!�!mb���;��zz�vsA;	�T�##����O���b��V->�ag/r�<�@�^�@ +�Itܶ�t�K�mT��ך�B���p�9B��ϨE���*�E=��Vҹh�=�v��W�fO*���|��h6��F��H�G���@L���=e��ˊô"��қ��Ĕ|��y�`ͨ�p��O���J:�:`	�}���U��%�����Jޖ��>՚�JsLuC�׸��i�]XȮ\&�n�J��Nnh=�f�^�%[y�$���S<���k�c'���
83�ߨXvԌ�3mt��f"��h�S��J���W2��A�r,@íȬe�J�mV^����˘��x#��2��i��*_e3ρi��˔1��}<�=2��%�VZXQ�=pm��4o�<I1�K��6c�{�w�_e����	���FO<�w5C�+�^+����I�X�`V.�Q�$p��6�F܆�.�.?�)���sQ0@
�S�
�����\%(���G*.�lK*2/t\��{����7Zɿ�"�h�8"�,2��
�����Pf=�tw�	�!�>���2�'�eT;��v?���iА�".yC0#�cN:���اzU��p�"B��lEY@�6�Mɭ_a���U��d�5��(;ݐ���+�R��{�X�?\���>%R>�Lќ{��+hm���y6�e`�L�� �G$Z����7�`��+ت��A< ��ūS�z�b���V����H��\g�p���>�͈�^G�\�y���� ����nW�̚�w՛~;�oxL�ï��� �K�q��$���%�W\�^%��=���Тf�^ݓ��D0f:�')y���4���H�N�n��6*8%��
�Awp5�ިh6X���e��H�((����L ��&-�iMk�wC�`í��5�e<�������]0�{������誋5���d�ȪtsAAPUQ��^I�HW�.Ⱥ�覇������U򱾾��7�]�[�0V�V�&VL���q���e�]���2�p��4�������J��!�]Fk�<��'^+��D7z�CXh�T�qL�*�o*|�b�U��/VJ���f�S����bcpD�EZ��ʙ�P�5xPT����t�wSo���,-0�/|�a'��+�Ro���r#�m3��l���*�(}g�ʦĠ�K��^|5��g�wǓ���?��E��?ǒ@S�E��
�)�;��`Q�jW�/V�� ٓ��M���� o��BW?TE�*�o��([��V���@m�,d�Hm���X��,��H9�"/�����nJZi\K=0�;Q���bX2�:�\��+�\�T�lŠ�*��~��[x�R�[U��1�Ѣ�N�����#y�AhY�{�JX-+|/׊���U��2'7BE��������H.�"G�������n��';�<��[����3�kZ9Fs�0���<x#�� ��9a���ր]���E�1��er5 )��t��r]�U?�����Xa�I�Mz��&�J#����B�n\=�:U/��~-E�&�!1�3֊)]�\�my�`��P��@[�a�˭P*�.>-V��� d�yZY����s���g�|5�˭]/C�k���Á%V����߱���ou�A��R�oL8+�t�\5ukOԬ�kUb��c�')�4lF��⺊��7J�r%C��lۊ����4h�����z;jeU��;{L�K�p1`�"�nRn�G���3�F�`���u�@A
U3�c{�"m� RԾ�l�����$Mgo�,�̄��@w�+I'�YL�h��n�&��MUó�h��J|z�z�S�S�kX�pop����QL�l	����e�o�2�xQ$�Ut�4�    t�l�2��]0+��\��&[s�1�E��ɘ�Ҁu�Ğ���X�V6����&���6O�/?g�S!U�wS��}�!�$K�ԕ�r����������?��v�O����^�ט#Uet�7U���Ń�s�eʰr�T�)(5�#,��O����{��S�(<�5t�#6W��*n��0��)�v3�E���ſ��`���ch��� �Wṕ�۽Hʀs�*�>��p<�(G7�%�O�vS	�M{�Wt.V�& ��bm�ݴΏ��K3IPL.�l�E��8��E���opjcW	�� l8i������.x`z�D�z'���o_�����-�ﭨ��>w�79�NO�L����g��aO� �	���(��>�_\]<[������i�5G,p����~��; 4�Z���x*d�z���|�7�Q�'E�A��U�jG=����W��Z�$��X���N�����oM�W����B��nkn��b4�T��7�-�V���<(4���Q߾2��Q(ijq��Ի$Y�.����Ń7������V�z�u՗���i����mr�V�M�ӹՊ#�"<�DUlN�=DV�2s�al%=L<$�?�k,5#H4\{>8�%���D��f�H�bs'�1�	�$H�Y{�t[:m�	�5m����v'�u
+�ԈZEM'��UA{ e���w��1���QWvځ_"*Qu}M��!A	���1f�
���n��.(XB��ܑ:�\'�`R{���Jf!���ȴ,��{Ս���H+��*r0�B�,��yn+P� �ٕc��\�����v VU.�����b��0��M�*k��o*3W�lխ����S��M4�����Gm]Ӳލ�E[���K#0�I�Kښj��VL�K�5!t)L�u^�������)�O4��]��6��r���n��!+3�K��M�ϩ�*��fԓ��*�8��#0;�0�aco�>�n3��y���Wa��Zi�%#�w��H�UR7�}O'^�������a@�R��2�߈�1Hv1�'���!"���l�����x4��CE4>��O�ք����}ݤ6�H�v��kv�[z�Y�e�R��t9n᧮��:u�ÕY���)E��-���6�r](�t�K�wn�/p'��M�F=�*/^�֨��f�(�=w�kJN�l�BEV���b��MC7�UZ���\p�6��(��l���%2����.
��"�ԎI�Yns��0�1i��T��K� 1!�wݴ�����_)+�&I���b����A��Y}����{ɷ:1~@O��V0�*m� �Q̀c�6pd����:zP����U�,�Zj3�S��^���"�GO���C�<�5Wr����&�M=X���h)s��k���������c砟�}�MvӢlѓU	�P\�e� u��w��N���������^/T@B�e]dfӫ��jT�������5��0����-�j^m4d�#bO��p�
怡���l6%����O���5Pm���A���03?���R�q㺡�2#g
��I���yb���l��<JzAO�66�c&����e��T��OH��n��R]�9���� 1�ky�l#׌H3m���n�70
�<0�B#x����sY�m�n5㖪�;1�c{m01-�б=r%'���uU�܋�7Q]���Rw@�]�v��u�xP�����*�A!/�n�] ]�̸
�C�`����
{�QW8�����Ƚm���n���V�D�D�Y�Iz�?�Z� P�¢Q7]�)��%x�܌a��]�=ue]n�S�O�K�k$(�&�FC��-E�]��Gl���|���`�;(��:cj�w��{�;�V��[9n,�����6(��9�F	��Ӷa�.)���6K�
`D�ȃ��z�vۺ���X�DI��<��Әݞ'|2�������b���'�)���Xz��S*�l���cx!�ڤR�
:pv�+"*��s��׊5W�Z�]]5U��"&]��܅���^�
��8�x`���x�:�|�{��!<�Ү��,7wZ�L��o.v���c���=լ�O��L�vd��t���nჭk����7j��&fɓ&��-]�C��6rO��by�Iib�X�2Ϊ@I�����:����(X�]�Q�2���
m��C1ܛ�lpٌn�u�U�k�a�Q`RU��aY�/_�	3Z�_��Մ�0y��*ͼ�ܴ�G�?�!(��`�NE���U���\�Pp��
�4Ӛ���l#n'E !���Jl�r���j�w�z7A�Ԏ������ʼ�Il�[������C	O`x���v��WN�R]�6[�m�o�-�ȯHH+���ڠ�l�7����f��\ $��c�R�����Q���OkSgO�ZY�C��{��ڍ�E�\~�4͍�)��҆�J+�Ӎo"�!
�5���Uݎ���@�ﺮ�Eg���5�uF ��iF�шiX6ܬ��Ov�y�0
�����?�/N%n�Ћ@|��wP�>p\-z����Ԍ���
e���ڪ�κ���4��(Tݞj6�~� 4p��Kr�E81l��a#t�Ռ�a�Ѡa�mxl�潄�]&�:��5p��+��U	.5��o�A�EPx�H���j�^V�iQ�
����@��n7���:�57P��p%�/��V>ײ�p�p8K����Jʄ�6}�PA1X��$��6�+y��q=�[Rt�C�

a�
�wW�`�z�һ{�7L�!ޒs7�љj�%
�&$R���)��c���ߛ�����_��.F�����T[�R�Ѿ����+q��������q��ե a�4q8�5���ù%���
���SQ������,� /���#���V|X��&F��u�����ʰVt��*���2)ĩ�-P�i1U`�`Yf1.�XJ�G7���ͭz�*�Z���p�V�|c�;U���]L��5�@���Z钧���yM��@!#�h3��	�<޸��/�N7H��Df���7��A	u�~'9�ke+�GK2�������*�t�3o���V�W�����TRs��<F�E��E��m0�V%`�ǰo?�hW�Q�:i��abu�������J?��������ܚ|�|ꖢ��3��[�z[�.��(k@�F3��$,�&�V�����rY�vL:A ��H2n��Qw�f0�%^�zS��o��*��P�f�Ên�
b��nEI����o�)��Q�n�^)ظ"�Kxхt0]�6R��8�L7ʨ�������F7�(�\��4����ϝJ;+�$q^^�,����I��q��/�X�iRᨸ5 0��hWnxh�:3M�5ګ�����M��s���@�bj{�J|�{�F%���`���Y!"��S�/�� �`W)x�M�	,Z`v�	w|�y��)�߮�h�R�Xs��L8~��Ե ��9�� ��tXTOB
T/y,�i0J��1<[�j�r)����U�Z.V��2n&�_���n�fcU/j��J*�VԏS,�����Q}��!xK�c7�A�zD�7�F�mn�>h$�N	eK��Po���%$O%��������$�0�|��j�i\��+y�u6��������7�<��<�j:>e�{�p��o�c�ê�t��Q�[���\�7IS\4]r�4��2�EuY����څU���!�Q�p�UX�nɩhc�@ZaVױvx9��75`�t��5Q�R�Rfb6�$&�Q� Vp9O�˙;�w�ZP��~�ԯ�
��=��G��U�uYК8�ł��|�P�ϵX����̾ZI���+ˡ��C�8ȳ�p���^����y[ ��ĻZ����&qӘ;U���t�W�x'6x�v3�5h,��p�86,�ke4�E��,���EB�"[�W�q�ӆE����5�o��Bv5�Lʨ���kRz7��)?��>vq�!�[	��i�o�U���9=��
5���zF�=m�Nu��C���(�p������x���L��/Q>�qՂ����.�v�)�50��,�    gK���F���Ƀw�'��s(F�˾p��f�&XÀ���A��+5_qm�����\��TE �����i��]�(1uuJ��%�'fբ�O�Q�+�%)v62�mE(���� �o~z�w��W#�A����m����jӓ��dǢ%fW��:.7�=V�b���q[ێ����=
�D>27)rzŬ�V���vƍx������s+�݊�$�M"�]���*K��qܣ�V62p/�&�X+I"�#���ܿ,���8Y�fP M���,�=*�,⼀���ƧT�!FrN�p�V$'�u��z[԰��A+/���6z�t�7F�
�s�<�
�B�|]�$��0�}j�[{(]���t��5�U�Eg�_Y�r��:HK�yN�=� M}:{�?f���>d�G�J�>O�F�z�8��}p�����*���},�bC�!D21��[ F�YA��|�=��&��馍.R쭒��/E�g6�2'�f]�X��Rw���mFls$�BǕ%::,I��`����}UB�
⢻Ka��);Vȉ*���x�i.�Io�n4-��L~���A��y��^������s��P���/R쿺�F/��2�ceiĐ^\~�@�R?�V��2�LT����t�As�^�� +��6�u��k ��p0���ZY������ߏ$j\ʮ����&�?Gu�n)��ߟH9+��J{�+o�@��CrJ���y�Iꕒ����%��f��,Na���;��������M|�=��� m�%�m��?԰�����~K�X��NT�p��C ����e(�M�QO��p=��\ջ�:�9����t5G�`��g�8z(��^E W�{Ȇ����>���|�O��H��	���͞4�p�7�HD;��v�JxFm4��G�Fi{	��7�mLx���2#�V�`p��ASM%S�G��x�j[�t�7֏	�%j���9#��N��_��(�tЭ}��C74�k�/T|�-��z	�O��҃���"��rN�`�vI�mvX�$Vf2܂��V�'A"Y���T8�Q�� �ץ��X	e�8��KQ�!�J�V���@�5��� �=j��VQ��6�v_�"�f�#gc��h�M�V����M�5�v}��^�h��J8����\j�>\�
���0ᘑٝ��"�,~V$d ���ȑܝ��q CG�l�Њ@��Gϣa��ಫ:��H.jyB���2�m�A�+��b%����&��/�P�ֵ��Z��^�B�x�E$7���>�#�l
�ۓ�
	��m%��K�j3�J�Z6,�����V1�B��K*��F����˞�*sT!����Yq�m��ޞ�4VT�&z�G}�o�l듖@��P��0�C�UѶ���A�^/��N~�i�ڰW�n /4w���$�b�U�D��p�F�K:֕ߖ�zRX�ԁ;X1D��T���z�ۂ��HV�;���M�u��&���n�']�a`�<1Pi��K�z��p_r�ގ=/c>����M3M�Ƿ�
��΅�d��X�E�:z"1ڜj���{`�j�q:>�ѣ�d"�4�X��U}V�O��:F���Ĉ�N/�N6<[(`�g16C+�s!x��r�1[�|�8����塑�.mKW�Q8���E��կ����r������r��5[���ީok�h��-���88�Ab1��z�I���GK�gqC+��\]6HsP��U������t\3u6�GC�a΀�q�t4�a`�
/N-nGH�R��|z4cl���/t�_������^c�+����lhx}�b���E��Y-�,O��<k��=�c0����5��0{�h��@Y�f��NY�{� ��]�-��̉��^N"���=�]PZ�*�b+7�<�h�ѫ��M���m��Y��3���Gt�x�)� N��^����FM;��`�TV(�GTv�o8}�hc�t�i�j�R=��V��kd����u�"�9H�9LA]��#~�ϕe�X;ᅬl�FCAe�=f���������+�_�a��M?Ņg�q�����V������^&��~:�m+ɥ�����ջ���+	�l�P��幁�>����|�F�3,��3�R�*ۄCڨt_x�!8�P�j\�G����� �Ί��J����$oI��(�p�) �J�KB.��[=6g���cv�i��`�`Ľ~�<�}m:=G�(��*��_W�b�8��������.OH�]f�������Dݢ	�Y�ڽ�����2��]��Q\��9Q�Yyv޴�G$;�%�����3�ˊ�h��_�s<�0����p]�̪��e�(�#T�"=4�����3 }����S���1}��������h8�.n�*�o��2�u���XTW�����c�E^��S��0՞FT-�v�i�Ɂ��f���d�և{b�3D�(�DN�`��p�j?j/��M��DӨ��XK�b�혶�F*Ԛ2	�ьj@�Ml�����W���7�u��T}S~k�\�	#2��XT��0��w6�wC�ǩsU���/�]!����\��"��ZFӂ[�2^@�+5�Հ�������B����X�I
�I1;�kɚv83���Tr7��b�//�-������>N{��yT�v��Hv@ku��Yך?��^8U���QWQ��e�sC�.��(�J}�����x��#l�9��2��)q܊���y�g���3�Yt��~R������}Y&��S?��س"c��~�eZ��3����u]����[&���ii��pi��r��ۯ$#�;b�a��N�S��B�N�۴}�`�I7��&)j��XiNޤ��I�È�J�0�J[+D���5����
��M�l7�rO��K�88~L79+��ڊ�*Sr��'1��i����T���t`�;�kZI�7W%]�K3���\���@�7�8�6ja;�Q����Ci�����y&��>bkY���v�]0ٙ�Wj�""��5y{9�VS�ؗ�	�>CS���T/���ۭ#�����u\��$�B3Q3m�L�(�����%;/�:A`��P�XcEH{z9M|;V��s���6L�^E��ѷ�c*F�h*�vvIi����
� a
�~Q��o��<�4���0�y&�ܾg��ш���=�� �b�, �f"7�����|�*0����Йc�Աb2F�-*�먝�$z���`��4��g�X���<�?IH��U_�E�����2PUr2ߪ��g~��/�����&�&z�:C�
��aA��9'F@v3�>NeX$�pXD����רcEhڃ~_��VE�H=�f/)����3���:G݆���gU�"C��np5H�;�#�r�0����G<������Zj��u&��x.�4���CP��:�U������ͧ��7&"��7i�:�b{0�@	�c����b�_�E��XIib��J�Vlt�&�0�����wr�G��t�c%#�ӆ�/���С���)i��������˱��n��q��[��K�k%�HQ�F�0	�#����59�t7�1�&����r�;{���|i2o�P��G��@89�V����'����^��$��JL6B��y�=�L������EX����87�=Ы�$��1�lҧfP�G��I��d�_8�R}�B����^~���u����T�:��褍�S\��y�+]��?)��J��OU9���j�a����!����M���͝��^�i�����Y�8�Ε�{��F�^�����St�� k�v=������,�E����Y�ڗ`4J9���z�'� /�,�w����)���k<]���cι���0@>$�]��9>~܆cE��[L�
)��F�X$������ ���w�=���J�z�f�zk��'(O�/�֜d�+��F�=J�y��6:���sbeY'i(o,��3����ڊ�*�����Iozџ�9�~p���0�Ht�jH�|�R8uП�g��|�����3J�,�VWs�Z��p\� ��+��j��K���ۧ,��5n+f�$�=TrʮG�V����AYB/�M���M|�    ��C)�#�,<�ꃞ��ܦ:���E8�>i.~��o�N�.��v
����<N�HX�)���Z@+y��t�gM�U��F�B�s���1��[��
�qՍ.Z�Ֆ��J=����
�M����PpB+�a��>�h����4�Q|aY��T�-R��p��@a9p�W��[�'��O����h�B�y?b���!e�	�$��v�ܲ��S\��*8IUp��_����f��~�r�wc���);�AJ<׳�R��+R�����a�G]+1��i�U��pq�l�+�����Q���C\�ȡWI3��u)Bҙ��+jkzϸ�SѰ���8P�YXd[�$�*q�MSџ�7��Ŏ�b6a��KkR��3�r���cTŜQ�z�ϰ]�{�����Q�7�rn�*n��ȣ�����N�:���q2��K�}�|�Bҁ��Q���	�,�w#=�����	6�8<Zp�^I.݀0��ٗ������`GIOJ��|Y��iT�~\k���&:����.8!�s�1+�J�˞�W�׃ِ{�#E]4���d[:�C�,�\1m���:PU�3�g��P��w酬;q56<`��h��]��e�@#�]���#�Y&���Ų�W.q�-�1�I@�{��o�r��,qw(}�ғ�
e� *Ti��ڛ-�]+��9��1��nK!���{7RD?��Qg�E����bOU�ͣ�9
���DhNE�˨���o��3w�H��oUgo�²'c��kŅv�k��L�S��\�Z��4��TLLqݘ	�$Vi�����19�����y��^�V�0]Ӣ����ϽL�}R	\ԓγi�׮N�H�J �4�|+� �(W997@�Ԟ�4��P9V�BƋ�D�fC���3XL�P,�T����c�a��F{��>�ˏɞ���l=��V	�W1�!�X[k=�t3��x���J�E	ĝ��Q��`T�
`?���$�@�2�h�+v��{����+�ۘUgR�w��&�O����u}=v
���JMё��RҽStK����3�����,e{�J
o��B�|d�'��3���xU��Z�3�׌�`c�<n�7���Z:YE'�����:�	�w`�5���y�9W��;k�H����J7�����:HmC���XR��������fr�9e�O �N����z��y蛝�jo�0[J+S%UZ�׿'��S.N�i���F;�h=�u�Kj�^,�F�
���6��r�\��Z����Yγ�Nz8�^�R{`�~�(W*�R�����$�h�u�ng=)+�|���f�є�����(J���6#���h2�?β�ѧ�4��l���ȇ@����Lv~�1dW>���f �`z5�y��G_�)��\���t>�f*�,4w*z��䃎㄁H-���	���tB.g�d�`\�=X���n~�ߎ�s�u�4��䚓hn|� �FL�z!���o�ͧ�S�ب��W��l�g���G�uF��=�����^7�$opDξD�6���l��E�Eb��h���Mng��>�-�M:�3��F޻�6�v�k�Q`0�K�$Bs�%�����\�- Qj�����ߒ¦@c��V�.�zB�n:M��;�2�C+e~+u�!+�b�n���g�H96;<�:���3d���U
J�a�8���`�g���~.�%N�r���9��BUl^m2��@P�z��s�͵�V_̆R�������sE���Z+V����ҍm2��(8�4��K�!P����f���6�lR�8v5���:��xq
Ar0Yl�b���x:�'C��RB�I���u�D�	�y�sn�bd�{��oW�ab���-��R$7�$�g��?��(*�ב	AW�ŧWr�B�M	u|��><N�xO��K��l9���M<\���`b3|�&�E��T�C"�O����^l��ۨ͟\�b<�Z�I�N��u��&X�K0�n��`A���i-�����s�2{��=�9M="+K�.��5w����d*���Х*��DO&���~;&a��KE
oH@���T��P�7�(� c��>���uI'�\Nܧr4�2�wD![TВi)���C���f�'U]2� ꥱ��c����y��@�i�_����N:�>�M7�Jߨ�F�*�L�Z=i=Ù��v)�caP$���F������j �M�l#G{ߜ�t��p��B����P����G���TɦAw ��ej1�e�*�J>�s��F���gN&����Xr�zH���NW����JdE���Ȟ0pB5b������Þ����ߣVܩ�9^��Y�O��H:�b�?G:f��7�ȟ���l�Q����V��m����"P��rxc�R3qF���C��:���찔`���^��6Z=,-��V���eW�������Bn������z3M�|6�[��Eaۚ�O�-aj���4�9��g��*H�)����� ��'|������uCO���qkgG�~Ԫ�1�{zf�I*��������&l�u���6��F6�v���/(�y��
C]���zt����R�!���� �U�E�qT����\_�8׷����_�Kk�CEcKVy/�����H��M	�&U��珏2��&�!�T�H��)-erC?,B��J.�*Jś�8��%���g��K ��P1eG�S`y�i���VGj�6��#qpW��w�i�?�
y0�<�B�ѧ|6-�]�D��ʋ3�)��Z�@��h6z"�'�/����;�G�`&7��Wk��4]���$�+Y�؈�M�R%�W��<��ce$��?��?-��񙿡�>f����x4ψ�"��ql=A�O����V�*k۝����-82�A��86��X�A�[�8���������`�9��n�
���T���MbM���#V����/+~S	y\d��1�@�it'�5�RMJy�~�?�{�a4�v�B���+��LH�{��xȾl�ˬ�6.:ⓃJJ�D��ne��s%��&�[�����֧Ӳb��N��&b/��Ƥ��������G�9X1��]c�����Y�+%X����v
R3 �3�wA��/��9n�eVjy��x����)v4�2��8�h�s�Bڮ7S�J�*��f�mi����%gw�����#�A��Tn����̆@�g�]2 �M��Yv��w1VT�+�����{=��`
�z��.��$����=�G8��a:hhf)�|	�����ȳ�`#�K���_�u_~b(]��`��PK*�^�c'��y9־Qi��AT�H�Rb��q��q�Q��JZ�݃�QD�=��\V���2gG������$GX�Ě�^Ԫ�P��(�9F%t&�l����7R��0�g��#�E eg���$7y�PDぷ�"R+JlN�$��9a�J"�F�Q�Gq�o����R��g����ك��.���?��n:|<�tb�t7��ǩ��Ҟr=��ZRG�+k���U󲥾R+�Ѿ,��RHk:���B���.@E1/��2��f&�X.���2��4L����<�`{o���S�]�^=�a�L��t>�(ip�!q퐩U��5���wN�D|V+iD���|GF9=��&GP�%�x�Ԙ1ll��a�48���$�
��v6�L�ދvw��h��.c�A�hQ�1IWWR��!�,Z�J>c�#�>? 3u��"��5��b$d:��_z?���؎��H��r��N˧�9������0oRh�ʆ�o4�I<}���*3C���:.�!+ȇ�衲 *�<����$�焇k=�6ta�3"��kP�l��(�^n~���mE���W�z�0j�B$�\�:s��i~?*J7��A�3�m��J������H�I�8�ӉR�O��DeH���:_�ׂ�
HL�(�3��VLZq?��ҫ�y�pLq�����\�-]��ѶҊz{� �g�ֈ��u���b���e�Fٜz�����ld�xX����t�p��/������V�܀}��e�;Q�w!�2T�����WI�    ����Ц~,r�P��r���;�ϧڞ)��h���rn �T�1f2�8%��z1Y|�1�7��dO<u"�q�S���!nj�[�^ݦ����v9+{E�M�<���	�Տ}��o=zҨT����l�R �a���C�ǒ�r���[cXY�$��0�V؜8��`�
����2^0����S����Nծ�3ګyB'�?D��	7�t�L�J�l�Śn��;Tf�����+WX������lMGE2�H�f���������p�}��u���9H�UL�I�d\}��ڢI7;30H�6���z9M�y��^>�I��b���Z�L�f�������WL	۹��4������ �b��������ݲ\�sp������u��@��� �!:��ä}��pԗi�N��D��ڍx��~� ����M�&
���
Z�8��9"^��Vt�R����qD�8,
�> s���.�S�$H�l>��ʉ'�§G:N�#�p#�2}��n_-ƣ�1[��t�s;�,X�ˊ�TVuL�׀DÏ����$y\|����i���g��+��<�Y��Oj�,�(/�<=�yN��D��ϦUer���z�Q_�U!��"+�J�pF���1�d�H2����N�|��q��������_U��"`F�B��޽ǽo���r��Nn�����J�W��]/ۈz���(0s
3|=�m=Y��㈹������tf��)��>HӞ�%|�9��Y�$);��E�Ӕ�9sJ*do�ZÂ��{̧/�y~�y�c��~J�]��g?];�����?�D�^x�M&#�͊��I�*�Ѷc�	ߥE:�X��Ҷ��q��id8��5j�1���f�}� @�w0+2�sB�I���Ű�J�(O��M�ԨMm�t������v�f��l�������G@��H���B��.�Ӡ��/p� :Y�'W�����y 6��M�����d��}-T��>73å�����xI�C9�/�Z�����T$�j��tcU�'��/A���-h��z�-[�ם���v��gF.�O�G��&�i���3�<��M+QȀ����W����t�����L�$�7����0 �}PlD1gu}��>�6��zs�ڮ��E��e������ݳ�fٝ��.��&��V��`�w���J����O9�e��������I5`��Ă)\��L���oP�*���q��ؿ�9@�>)w�X�����z�)�5؃��2�`"h���sLVy�A�|F�;��$�X���Mu�,��hIz�,��U\7K�2�)��s��u�1Ry���'�$ȈaI��]�j��+O�T�=�e�;*���Q�0,�0�c����5֭����#x'BWH��׷�����MG2ݺ��z��8J����v����,�������j��:��X��2����3q���h��Ux>�j���hEb
�d���-+����z�x��C�I��p3�n���	�֒0z%��E��E�G���ബR����5;�3��;�0/k0>�>;�p�9����(z����#�������]�z	�w]�Tf��"'�wuT����8�Ѩ�X+�zԮ�r�I��WDz��1a���ޏ����%)�eh%��m'�ɒv9��w������O�ƀ�7��"�m�FPp�X�z%�WQ�u���G~Ƽ����L8�_���Nz����%f ]���^ؙ�/8���K�mG���w�+��:W?�m$Z�ܗ*bi�H���\G�xU�`��m�����Z頭'��P���k1N���7Qр�D�piAƱd�Q�n#��z���4}���9	г�p����e�L��Y>'��P���Ugb�h(8V�\^�4J�w��F�me�E>&��l2���.��'��K��D��iAh�~�WYI;7ýFI���1+x;f�'?T)��c&���K~/;��9���ǩ#�|� ��x�P��j���\Un��#>[�hv�����(>�"x�3�;5�~�V��
wL��\N�X����ʹ�0���j��!
Ñ �#~&�~ ���j�6��X=�*DC&�1#�s�����ס^YQn|�x� ¤��gJ�	L��u>%m݅��v:#����h�+�s����p:3��Kԧ������D��2�?D :����|F<y�������TP`��@�*ie��ǿ���+�@(~��S2��t���H��c�70V^����9��d����	�R����?N��Ya^nx֮Ր�).�g��lr�+iM�G��qJn򻌸��D`XQt�Q�^x �/\!���{$4�z;��|W�Q�$'���A[�Y��_ۤ�n�̷ؔ����&��٧|�[�$^�:�@�*|waP��dU'Й"��V�z)�@6��H��0Y�Y�l�(=�����`Y�B���Q�m���c�^�DyN}-Vr�h�2d�؊`]��F��3�����l��ԯ�B5B����?�	X��,{����J�VA�`-+�)�3�����=��u�+� R�rǫ��L]��b}�1�M�TQ�S�&ڷ������J[�:����}�E�v
8R���(�H�7p9�y+JL�Ȋ/������ȋ i�/�~��AfYeL\���6��,�:�g	�$�X�6A����"	� ���eK�|�΃*g� �q�r��/&�����F�T�"d�Д��c3�Y,
�eT��lG�Ay���ܘs`�����ى�D�Og���H�Ī�BY���1�]wU��W2߄-MK�N��=\���t!�8���`M]�r�eR�����P}�g�6S`���JC9,��N��T-�,� s��
�]��
�
X25h����4�`ؠ��7�LP&M�r迧L'�¥�(���<PՔ{z�/���)�����+v6g���dz��l�f�~VhJW�y>���@a�0��V)�P
�R�&�/ʻk��L�)Y�yA���"AjrG��i������^��d�!�3�΍ڷJot���^D:��/��$�۵��� Z�^��d4y$���͝<����z9�72�o9B�*µ�<ˆ�5�ͱ�y����'9�s�i�a�i��:���N]^uU��9!�㻺P���>�Ѐ�9I ��brxO׿�cF����NhD&~R����k�9{�P�&J�[gu�,�&"�*��V`�/��\N�@8�����qq;2�������H��P����{�)��?�KyM=������G�]��D~�6T�U���򃹰��$P�	!{eH밪Dp�7���ڻy@��-3fDJ����6�nX|�y/["��3�#��OnE@�4�T�Kҿ��d�;|��)%LJ�æ �d�2Xτ!��J�ޓ^wKB�WVdΠ��d�������/�56�b�8
���J.30�����o�'�R,����؉`ir�����Ǎ�M�
4D��}tH�%1Yq�#�����2B��B����c�RE.�_�O|�E�����4r��RZ`[�pG��sT��6����	�����)j�x�aE��`8���F���L�#�;��t�Y�U�:Uw�};�t5�_/�`��b,����l鐑h�^��`RhA!�ۺ&�U6~�7������ v�4J8���+聮7�a~[�%�`)�4��X8��Tz~�,�bm���@���K�u��Y��<��L�ֲ��NqE�c�&��D��3����g/����t�sI�����?w��W{U�1'����z���U�Ք���R�/Sa\��}j��!��}|��ʏ���d����6?��y���8�5�eA�b��}��Wa4�]��V�MÏ���2�%���-W�	;�� �f�D>�>��UQ�~�a�#	��b5Q ��������`�:�9}�O%��Jˬ�A�<���k�}�1�rgձ���u�'A̯����ϗ ��rN���:��w��3�8~4^�_S��F?8��`��g�~�Z�?O?��y�Mt�߾�`��vJ/�>���B�0t9"����Q��iz����}_w�4Ac q7����J�_�5��N%���`��N    �j:���G��Ҝ��a����Гmҫw��k>�����w�G�����X�U���i�đ��;��H���n��������WG󀏽��aQ~�]���=&�M�#��l�ANX�o�Mmp�2�(E���
��P5bO��:�B� .ı��BOf4��5�M��5�bW/�����#�Wͯ�F���zX҃�@T�h��]|!�\x�x���� O�&����ن�y�-�uT�����(#�G؛�3�9����1}�?�_������$W#���jF?��'�abM:i���+=���u���
�e�?߫�}���H,�M
t\���l<����K�r�=U��k��3�@�������E��r�"@&w� 7����3�`2�J�*jA�k[���U=F`�f3mf!w��j�c!s�k��&���er�����~j4�s�O&<�^L����^��}y��Ա�哉-�uc���+p�q�#tl��9p�u���o�z?��!�����Х��-P*99�c1�b	Y	����c���������h~X��;�%g;��h6��$�x~�ә{���"��������|K�p&����Ԏ.~�����J9-�:��c�>W��Wӏ�d���fS�`��:X>���qE������8����5P����p�.���hCe	�����uH�A&?���+��.��(�����I����d�^,�����t�`�m.G���L0�o�҂����9���)gF�Ҙ����zN�y��[�+�K3O'p��+���֧=̲�2ʖYiU2�?�����:֍G�5�{��m�ҲV�%v{r<�&`�,�ͼ$�G1��[���Kg��A(`���*<NO��w#Ӌ�:�j`#�*MU�f�ͧ��6;�,��d.c1X��kO2��:8�ǼW������:K�kE�Y�3mp�?oͥ!f1A4F\4���ѻ�+_>�w�^�����w���;P�KS0jJ3K�X�E`�����{�oO�<�WT��nG�H�'���-���l����c���,p0m��?���!�����D����{�w����`�Lv�A p�1k,��q:Q�����"�J�[R�.d9�F��Tc�~�����`�'��6�G����dj�p0@K��2τ(�Zdo���.-t�J���b���칄�]N�����GӾX2㮌r���w��j*֧�"u��c�!���X�_&ˋ���K�/��d�I�z�������ێ�s�(ݴ�m3Ɖ���3C�i���l8��
���o4�u�94�'��(������{<k�����{���,t9��wH.���B�9�[*�Dp�8�j���To������Ңf�4g<�a�P�/��=8#�����c�+�Ͳ�ؐ
�(;�o�;��g�.���"��Mz�����U��Qr�Ⱦ,���G���[�18�p���3ӝ���l�5���6�p��|I>���:��`Jx�@��i��aM�ab�;<�s]h�*Rz7]M�>B8a8&d
���g��Y|�o�ߕ�8K�yq�����3s�F>[6����wϮ��TJͧժ.->����겎	�>�Yj�AnQ��c|�L�Ǟ��14�2�z������B�>�F!p�o������b���U��]<~\�v�>�Xh��_�&�R/�i�x��J�X�<�Y>禅R��{�M5�$#Џ��39�=�|�y~h[�{�a��H�?�>����7��bҍ�
�e�`\%���MO"�b6�dF;���8���{Գ��F��k�&?߃����s���^��3.WYq���6���eQ��n�[y7�b�+�<%p�O	���{V�%��Oi,�K�g6U����qd����r�Q=����z({E�̦D�A�^i�����Z	�����A�:��>�葓�	�z��~��2ȥ�@�*���0X�rt%Ϣ__��*��	q��ާ�iI����,w���;㹱�	�h'8�HJ43�vs5���g��
�j���Qkمͥ�ٕ�� �U��H��s� $c�d���'��X�#��Mm���ٌϚ�hf3%��H�`}�O�>�����ÂP7����0D���{+d�1�~g�g�����8��8*9{�	�3�VQ.~,�fɷ���Y&� ;@�߮�346C]�����pT�B!8e�{�-��|F��xg�d��˳;��@J)c�@�-M��F��g�
�zD��G8�R$z�o���W�/~Rn��t;�wX#`��>�΋iM>?�`軽�g*1o.&%u���O(d�,�R��S��
�J�I�$���?LIQ���ߎQ��	�o�����ư����ǒ�1�:1Τ>[�m��eu�vs�] �DY!�0D�x�R��؞u֋�7�#(I��L�{U��� N(\}^�a7�=�;=���0����{�N=���N8��t��嗲�aX��?͢ڃa^����]��Y7�~{���D��8�*7��M�����]`���1�M��p�Y�q�x�}�LW���w)��u��d.� W��c�iJ^-���[0�[S�}{;M��䁓[����9o�3�Њt�tᖠ7sq�33"�
J�;��z��-�>#�����f��v��ӻ[_��XY]����s���_r����f�K3%1�U��S��,�#����;�k� ��|7�.�:'㨬x��?GF �� �b�ǌlg#�� �_�t*�'�{qNg8��p���[
����O%)�v�����48r��j'��������rp�K���g��V�O�r��%r`�P�-$�@#��eq��w{�g��w��g�Uӈ#Y��T���D���P�%�/d-a2�Ύj5vy��3BNr#���QR�-����h6U����=Nؚ3[��:�ѧ�l��T(����l��;���o�Ó�fD��n;f�Ρ�y���x�f���G�%����}���e�g�9d+������D�:t�����	��3s�nY�A`�!0�;��t<�4�H��U��}����_���/��
��Y+�eӄ	\���QY��]v?&�Ap&d�9~�C�eVl�{��:kS!x�sk��@a���^�֦Da��:��tLX��vY=$�s������ͦ�- �l�l�)���I����_�D��R-q�o������O8��6��=�>��r�)M0-�YY��!�>:�u�7	��M���0�Jd�y��@ć���g�l��rČh���� ����\�j</���0�ч�E�E���	��3��O��y�		��x�������b>]��)�߁ *N���g+j�3���"��0�춤��ѷ]�[`��|R��=�p�T�9��c��+�0a �s���2�Lّ��q��hKAEY��Rf��E��B����]8�LF��b6,㴲�l<�QF��qO���M�8����W$S�Y���>m`�~�?��u�r��y�ه||�1�'O�)P�Ǝ���2��z?�$I�[�XH�ߠ����C.�n���֧��������Pb����r�$�*�h����!���*n�^��]�ƷI�we��}s:r|?�b���q�*TE�o���٣�o��4b�Q��CP�-��Xr�9�^�7��u���_���S�߷sL�F�V��_`3��Y�A��Y�S����X�J*�VU�B�9q?$��S<���pP�aEB\=-���:����$��/����4�V~;.��8 ��9<~�7�r���~�7p�ʏ��#|��O�@�g��|����kL_'��E+&�ac�\�W���J[�½j�U׬)� �x:ɉ�0ҡ�h׷"<������UR!�W��p��We��C��� �>�}�'�S�aβ�|�8ک�V3����)��(��~�5��/+)I���3t:��	��l��e��BV�/�<�.����5G��}��A����3�a6S �E�ӄ�����qQ.:�\�NPV��h>���(Usd�J�!��d�����¦��4$�y�}���[    rŹ��i�$K���^�8��q�I�>J6��S�W�V�.Bߜ�|%��7��S1q.b���.6��_=�����5�)�U*��l��%��Q1B���R�8�7U�\|Y�}r�o��"D�^8�Ҥ8�sa&7p�@��_`M�pW������Aڿ��4F�a�Ĉ�r�WN�� ��?��Z'��hT��k�NF�
C�1&�w	��>;���0��@,'��R�����l8ճ�,���ɇ]g���r��$ݫ����#����ʷ¸�>3)Ȫ���#D,a%y��Mp�lDx����e�A������ӊ�?��ƇG]���>����ǹ�R����=��I>AG�gD[^��/g��\R<&��,۹�ݿ���wS�W�DVC�
,c�����Բ+�9��YuxXu�@Sׇ%�d+�u6z�c]�@��3�{;.p��+���j�kj��;�����0(K�7�]�\N�:w�O�3���g��7��i-�g�/�%A�
�l,��<p��9������r@�P=i��!�/��0�̹�����������o�o-���d*�c.�?@W̦$���v)̣�����.K�^����Zw�I�HcaИ�*si�+|�s
KX�q�����·`���������G0)&�#�������Orǥ2v/.I�@K]e/���]e)y��|
���,[0�T2���.�E�T���[U�����y��_ɴ�Qŭ��gT�&J
*x��T��Wa�c,a%�W�(��,>>��bRt��{�+`�z`�r�K�J��P��k�l��ߒޮ��:����Ks�H�-�W2΄]��|!��z�Ֆ��\uoHBl`����_sz؃�������{g&�	I$%�j�;�T�E&������Zkdo��)P0�3���H.�5�]/�t:�+�i�v���ki�Uw�?_}�����_�)�af,��K�������������.X�7�y*p��q9I��)�2@>X5��e���(Bta��H��>�f���qa�!:�ߝ��=�9�!�/�bbra���V.����I�d{y2�՟y�f_i?��+: 動s�z��^�o7�{��#�����g+��O[ ���6DА"�0�u�'�(��y����u�ǥ̎.	_	�:�o�<��:�2����c���'Wb����e&ɼnv��8�(�@!�����0��Č�Nj|x �����0k�=�˰h�! �	��e�zα��n������Z�̯(^k�K�,���y���0妻{Z�d]�ڙC/�0E�a_�m�|fP�b[��ּ�1D�Ët2�� a�(G����3pm�Q��q�;�=�:+c�I��|��Z�D�)��^�R���ڣm��j��[v�(�����8c#!�+������a1�_�U�I��*f�.�W�ˋc\o�})�[WN���`�����ulb�y�"~�ERNl��{�����p��'�7�!�L��R��ަk;*J�2���<p�l��)�Zs�n�j8�V���\PW��X��-���x�G��dG�i��&���KJ����"g�o�6Վl\k?ky!d
�{�w1���T���)I=��o%k~�'~S�.|�����C��B��!�'��B���a��V��3��a���6jˤ��ÈP���z�]���8K�Y*�[>��ُM��ٙ��9����onZh}P�r�9◬w^{������ɣ���7�}�����	S5�	۴�!��3��򃀃��|������۠iQN"�ݍ��fL����kCoUKx��	a���*Q�2�ePW���&�A�FG(�*��"}�k�֭��A���P��?���}+���.{��^��yqU�]��&苃"7^�ɗ�d.	]F�~�����W�n��n#<��ĄZ2��Ų�)G��O�qs�a����e���'�4�U`����"1��\�ЋcV0�~�:C�Oq���^�ǟ_�e�Z^s����Y1��.Fdh�aU:%��i2L�ô�}�j���CY?��ٯf	�8:�d����0���}�O���
��@{�a1��rQ�I�	߆��`r2i�	���rX����-4�3��7�����ݨo�����e27%'ب��̯�;6�a��������P� ��
`�t H?��ph,��}��fD��,/�2�� د�̄�gps�a�k'�oM���(��,�g��l7F�0iSw7}��j�FlK	K�<����0ҙ���}�T(��O򍫯��#U�1�
���bj(̠�𖽔�ż����aSF��X�x�=��,��l�82Oha�<tG���M�v�t^�M�D��/��@b�����U��K�K9اq��]M�s�l���^f�Ɋ�d�-�E�1wg�Q�?���8��me����-p����1�m�a2�`w�`z�uWm�r�����ߌ�f�/z/���cX�8��^����浒Ł��3�1L0��m@���d:O�ɠ�;>9A�Jȑ_-Ϋy��֏�8�U_*V�yDF��}�g>0��ݝ�{������6��O��: � �w����?:|F���Q� �I.�>7 �m�x{�lV;�o�kG4�W�����㪎�0~���+��m���O1�?T���1�0���C#���ۥ�cy�dd�ܚ��ث���W��5:�u>vy�z�_��?.�T�9��(5̌4�ӕkJ&!L=:}{W�P`%��K�0����9�╼ŝ�.�T1[6_z!ǉ¤W�ܻ����?��Ѩ@�/箹n�u��'���T�u�%)���)�غ&w��1��Z��(/-�)a�7ƿ%p�A"�7��p��B�s_��#=ρ�xK��b���,��w��b�x4�Uqk�.�M�,G����+�z�iaN��[m��ʓ��91���cX3	�!E��-%D��������]E�灙�����ҟ�y�=5.�A�O�Xs�'�w��$:��B�K0�u�YC�vT���9�1��(�5�jڣ�&B:(�� -�ѧvO��&�)�Id־'FwΚ��.�E���ۃ��4S8z� ̪��F`��(�*y�r�K�V��$TQ/}_*d9�i$�����|���{��C2�!��<32�\�Q���8G���>F8}:�g1X��{���Ýmp��Ez/t��6e�bKqa��,u�H�Ho��p6��O+�O��B�w3�Q��A���� e �]Sl��a�s5�!@�t����3�]g���9��x��yD��@�nޏw��dqn���)��i	��/Erh�8�]n��؜jD(a���&��Hq�-ٷ����e:D
z����A�Y�	�v�3n%� �w7�2�L�X�b!�[2�+.�ǜ�kËo�I�xPϽ�%pC<��b���ؔg���X�mh����6tskp4]T	���!3�}��~�R�.fJ]Тu�6�	˔� 裟�0�O����c�U�mqC �^�{*�1.`#�ۓ��<)	�~T�n\*�2�yJp��$Q�T�[c����t0YΝ���;��;���I�\�e2*ֈ�ΉX��E��a����C���-�n���{¢(���w%���+��*1
eo�tkW���P���"�H>��l��i9@��~�嵗����6�z�O뙠S�(�#a<�^�N���I���LL�×5��x@�&��2������_�����,~{C{��|�]/`�F�A�f���]̚���Ǥ��>�H��')2����^C��`�{)0(��(�j!���N�3��w����od7��	��tݺ�-�kP(/@�4��9_�d�,�"0/`�ʋ{َ	���@�-l��OGgO�Η�83`�Z!����|b�� )�D�x+�h5�5Q�Up� E��;�<}�#e���Q��ﲐ~_
֧L#$�̗��8��DOw`/e� ���Ϳ�a���#��p3,t�6Y�6���f�%d`�B/䶅�0���1 �ȋR+s��MI7þ���Yw�$	eܹic=�l`��� ��fr��p#�^z&9��    S�7�C��'^v{:�F��Q�c�^:�y�y���W�NP�7��6Ii�0"�!��1���k�B'_�f�Z�WԸ�~���d}��?��s�������x��_-����|�L�|��Ż��z|�=<�IlK�{���w�C�����y�I�,z�������ĉ�=����d�E��Fz�� 6,q��'�d�&E�)�����߹��7�s�&Rz�n���@n�Kt�X?(�A�� g7@���ώO߿�;%:�)��f��wf�-���h�qp��|N3y��^�,�!�Ko\\>��u�V��0lg��~�姛Q�>�[��,��4�F�f��#��R�X�#��g�'|����'!6�h�z�"ħ�hSa�!+��}���R+n�����L��t�޷b�,���ڔ�F�5z0I���^����H���x��\v�VO���E��d�D��ĝͤ�=]���}y7`�w
���P�j��2�C��dr���x^��$��7�k-EVij�|Ve�$_<�����c�Oĸ�h�DT�b�����7M#�K#�}�Y_�����jHth��|$��G2�ΩEEad�u��|�̂_���*��V���E�$�T!�Y��cpV��Z:kk����9���`�Xzg	D�E�t,XʝЧf[��g;ŷy3�WN.}w9j�PX��Z2�90�>�>u��P+�ʬV�y��V�,ܣssnGp����v�Eb�/E�c�֞J_b[���֐#Ğ	��a�dh��݊�Zc��
��Y{�uɇQ�[�!�T�t�F�M5��g�ޙ��׈0Bs���	!�j�aA�	�Q��ROu8ʺ,_���w��Po���Gю^zg�eGХ�xZ�&�8�t��)��OCM�6Dp���L>�~��$��V�X�d�����2�c�"�,Ը���L��A5���X����R��dx+j'����n�ua(�DH-BV�1Mc��Y�^a�V�?J%}���w\͒��ٻ�ZV����W�ۢ�G�^�l�^Eul�����\o�1� �H��oʪ~���[VcYφ��ک�P�oTj�V˲�M�/����<&�5���Vh��%
.a����g�#�
%w8�Иu�d��vn�K�lD"��G!3�+�����7]�u�Dj�I�L���U�x���MfN;��ɠ��%c��m��đ�4hzԔİ��~����!�� �U�����o����Qi���ׇ�������i{#m���2�SH��^�K��4��ڻ���]������O���h��JaCa�u�*v���`�z�W�ia#�\T�jN�h���}�`z\��}p2���������5��'����Nhܵ�=lU9��/����?�!��&]$��V��F�e�Fl��M-�)���z����SR�]�4�eZe�Y��G�F�� �P��ۤh0C'��!.�cD��/E[%��< �%
'�3��Y��W����xR������˹�k��o�A��K���aN��L���ٛ�R�+p�Y��L�[.�B�<���Ga#��$%��ը��?�W������ӈ3�Qm4!��.G�$���J��o��㍈%s�P�c�"����B(�ϋ�fR����} ;#�e+���tu�}+���9x&췯V �L���&��{e���A@u�p�i�heM����:��h�B��J�9yF�d�+T)�����lX���Z��	GI�K�LM�ɒ6��eMU�[X���I�YGB�0�ßJX�yR¿_C�N�
!ŮQ��?F��޺���3\;�,C�^?���v����c �K�}�M�-��.�#�a��I��
�!�Lu��#� �0�0�S2���=.�y��ݓ7&��}%� �ū���+�u�1��tC����Hs�Yf�1�z��9lښ��H�A*�0��^����o�������Bx�$yW��y�5餂��`~`a�O8eo���-H�f _��n�=~�xG�a{*���+"n�s�K��n1L�����"T�	;�H �'"�. �j�]��;�~Y�=בý�P8�Z��?������?P7��jڱx	���_���߄zPE�R��by����<Wi}�S�%/ʺ��tj<����U8R(��!9�H�!������{l���H�n2
�S�63��6��?�ZK�^l9��qgp6z������ͻ�a'��!���k?ɾ��z�T�F-^���l���2��[|�i�7���?I$ت~�&��D
���Ӕ� �fp����6^��F�����֤���^��O 9]��Y�9I���נ<F�'��v�n��~#�a�L+cC��3�4a��<���a@N1�A�b�k�W`#��G:��B`�\!P���"R�;�P2�DeMpٗ����}%}J���8���p�����=n�U�7'�0�.��\{�{|��0LjpReB�I�����rTbI��}�8���Y3{��6#'���3J`�ҝ^����?��n�uCav�,
���ً�~Z��<����x�kWOd=�eb����&�6��N�/�P��j�O��)�Z0�Pn6��[V˔�c�E2�<!@�}�OL�vG�6p��i:-2�Q�:[����XW�lcV��톅�L�c�O�
���H��'���נD�c�{f�����խb�ql&�i2\ѫ4(�Y|��0�q?���z�Od3��5��;�̓'���l�R=�.�\�F�:�x`ń)��$���y�>����)x�NC/7�ⴃ�;���d�]����j��e��n��]a����9*{<��<�]a4�m�nŽd��!�3�)ek
@���+#3��^�Q3�o��1G��o�t�Up.�b:h$���cϽe��H)��?�R8�e@�m��%E)Q7.Ӫ�C3�������a�w�e������I�e1��Ig��v�Q�^ǃ�b�`0�织�Z��5���Fz�|���E�Z@���X��1V\|_Q�i}��2ŉ3�#�^�i�.�h6MZ��N�i�-��$~+��	l������Z9�,)���iJ��XD�2�j���:��1����O�}l�����D�y��C'7gz�<\���m����Ÿ_&p6�U��KQ���V]���#���%Vm2�S���l�^�D��߄	z#���gE�C�m=�⳽n��'b��TG�g�������z��ij	U@�,c���C��8 -N1�P�3��!ٯ��^Z��U��T}!Zb�*�T��̥�4���oWG%rבDKVw?=g�t��wF�[l�_ݴn{W���u3P����Ir�0���3���S��B|=���4�5�����.=.��129�	~%����d4��A|��q>OR�ĩu,��H��v\T��r�턠n\�9�p�	�������)��T���ϣd��c���
XX�3��<�ت@h`�MZmZ��*]�^�O\�p��Ok��4#�f�ݒ�6b
�'x�� Q?.�1���R>���ѣ��d�9)������z�I��b@剐{�:~�eդ*�%�m���
�0#wŹy�7ҳ]L��W�O�0H�M�/++E���Å�г(C����,}�gq�_/=b��ɂ��=\V�o�Fp��to3��P�tc��{�\�&�A�xE��%��?���%�46]ŧ����K��C�'0�sG�����q|��?H�J�$� �Y%iM�ݗ,�T���IݼX֬�52i�`I�	�*[�ğ�Wp���F���yDc��0Mƅ6ۋ,��Ӕ��QWZ�N]���sx�	�j{1���qp1|��<r�ŕw�B�a�w�m����V-���M�$O�VH��ж@����%2������&��>|�h_p�������Ğ�Ϸ�X:M��Y7N�H�ַ������?�P>M!-�0�ʡZ�����֨Ɗ�`���\qN]��Z���?�XH��=��/�6���N�@�4�*rp�����%eg-��z��7R�\?�D�;�:�#���m���r���[q:�[�&�i���l�����x��'��ז�3�/�b��    �}�i$���V�:?y���`�~4,�br;0��������O��`�"s��d(0'+�n��0��p�;�>��ٴ��Qb��B�?ۢ��"��Lxy|i'<��%�wC����]����!E�g�U=XAs�8�i�<�bd�6�ͨ��#�G�Y��J�02yC1J4<U�Xc�����Rc`��P����[�Ů^�
����)��i<��L?v�~�U���7�Кb!"����ɻ�>�h�q���Z�Z�Z�R�RQ��n��ml��>�D�����X|\��w׫�R��NqT�q���j���^�c�Lm�����1W�W]b�/)�E�+V2�ed	���a��a��3\�\��Y�=�A񚔉(_E����0�)N���q��%��.�i_���Ȧ��ї靴����<��fH@�0�B7Z���Z`Q���zTՒ~�0���/��5k�*~F$>�* Q�3M�������<ɖY@�L����N,��9�2N2l�>�zp5(L-�����=��D�(�S��cF��e����i<���^S�0�G� 㬜��଄�e���HϷ㻡��S�?X�؎>�o1/���J�t�4�w���?� q���a���=].��	V����=�� �SM:<0j�'q#{���#�Id4�S8le�,�'�&�[�n�P9+Mi��Ti$,�z�Dq�#��n��Q�l#S��a&F@9���Ds����n��/ޣ�E;�vL^�󆝛H8`���mu~�����؏
�#���˼J�_�;K��[����$���'��i��g�&q+����V˫�1����n��EMf�x�`�-J�C�!TxJf����_���=-��N��Y�M���A�)�<u�q8�D��F��� U�IWuz��)=O��KF�*��H��S�C:e��r@��k�0�?ǟ��J��E��1{��H�F����8a���@�{�<YO^�0��Kd*o�D "���U�ϥt�#�������/���[^��Ze}^�Z�4�j��Ц��RN2��0h���4���j��8��#��1v����eT;|���Q�p��z�xۗ���y�U�M\�E�q�l�C��~�jbasrY����O/�RL\�Z\z���ۅ��S�_<�+����lK|��|8՘#���dPVf�4s�v5/"�B��������๞s��U1���8���u�طjh x&7��O���"�4��{�nh��Ֆ���D�0�S%�b`��'�a:��G\c�QZ39o�pQ]�3a�4~@i�|n��幞�R��)ά+l9ݐ�g5����a�ίq�S���]aX{v��sRMH��!���I�`ל���ZU������'�|�!:�ȌK�0�Z(7L�����E���	e:��dr�'l���_uSJ�o�t�myV�O&?��MFW��+}��e����*m�k~n�=ʙ�G�w[��ou2�QzMx�3U�n��O��.峐	�K�뉞۩?��	�}vϮúc÷�]����;VB���d,�!���7��$EaP�ն"�vnZA$
��������a�)�����"�<�'��~�2/��N[��j�%���xV��l��^97�m�f̧z��aeL�#�b8�}���З!x)�T �Qq_H������d+���%F��N��ݜ[����,|4J��mvWaM�f�y�� �\�F�^�u�����er�`?�QU1)�k��[Y��tKv���j?p���)N�~�u�������8� ���"[�c� �n��{Q��VtH����T��. Rּ�	a�!���y�~+6�����Ƌ};%[<1v���;���z�~�a��Q�yY�߇
v��mG�qK�D�~��K�L�UJ]&,d�S���0�wm��DHN�������a�r�'�Sc/]�"�2.��y��Aظ���!�z�:�ר�<���X�7�!��//�L+��`�pJ�Ϊ�[b�iD��j0������Ѧ�;
�&&��8\�� �ism{%�:�e<��ا�uXo�3���?g����a'� ��K$��H�(��"Pq�j�/G�͓FL6���ɯ��H���#�(#	Cn=��LC��a�y��&ak|���h%i�"�H#�xg���K�.[��H�z��mR��AZ���]�,���^�P��%��0+�Z)^�F��R�j�d�L�%#��!s妘*�!W6�N|�L��4�097����7�v��㙅�[�C��<��Y5�%��2:zw/�~:�C<Ga3��a܌a=���� FR������-a����&�eT"DM���F!wd�<֓B���e���a3�<������k�=�Εb����ǳH�O��A=�W��2]r��D�R#9Ⱦ�+w�mw}�{�^�<[a�l3�ϰW�:$����'��qiD�h�M�&�s;�����Qhe��i�%��ų�%��b���j�E�r�Զ���0�d�;�+��2)����\_EJ9�U��W�D�M>-�~�#�v\ڐ ~9������{4�.h8�HC�'�� �~-�Ʀ���X�?0Bq�Y�N��D� `��Z�_̋��N�������*q��~#�(>�����q��tS��4��{�)��b@41M�C��nm�2&�)�P֓�#��%Y�u�m��`��X%�[ɐvb%���Qm`-l�o�� Q�n�/P�"E-ŉL�0�+֐AaR�3�)�����w0{_�	�I�(�
-"����ϙ�R397�n�Wط�9�8����#mۓ�ݼDVBt8�����̧�&�A���,�|�lu�0�VL�V�E�P8b�4��r�7�f�ȸ����du���t,ڬP�I������a��x��&��,������U�<G���\W=p�fX©���	<*�E�Cl�9<6�/:Ǘ�R��M_�����w�D�پ�'�8K�o��暴V&�Y�-xZ6rAY&䳎��ԣ����a#�9zY������lK��El�
��R���ZĀ����z�b�)I3a�אּ��ޱ��ȡ�P��Q�/�Q7��gЮ��2AES��5�4�=q���n��y,#D{9���٦���FP�Uo�~�H��kqy��,�"b�+ٜÔ?�c*u��7������Rr֝�ڡG�f�z� u�Epe���I�B>T�j�¼,�������c4p�0y�
�뙎��o�e֫��v3.2���!|��,`]�'��[�o��Q��KG�x��v\˘���D��l�"��1B��49�_�G�b�u����8���j�z<�K?P��R>�Yɼ��P_ ,L��n���g�G���3�9�a7=ݽ�jv�j޽�3q�H���#'���wag��hf0n+W�y2�8{�aI�0�SX������}η 2��G���t�I9�dK����]W��`���	�[|N�ކ�1t��׌fɵ�su�v�[�U�8�|N�AE������`6�;.�C�<I؝t�j��4�*	m�]�H�����Ֆ%RR��N3[l���P�͵a�]_X�a�/��|��q����B��qi����d��?�oĭ�2��Q�|�״�f��M�n(�.��ke�!�j˖giY�o �ܖ������/��}������unJ�=�I��ͳ׹x��X�
j���!��<��U<�-��U��}n��Z!�\� VW�c<Lp�޸t������Y�Y�x � ����-LN���"-G�C:Intaw���`�O b�6�O���d�L����Y��P�5�KEhq�{0*P�~�j�j\5<'L��՟��d<�W�I�C���2M ��3��������Xx��if��a�}g�{hG6@�f�u5o�^1��-�X³�qYo��02އ�|�cw��7o�*ľm)֦PZ8�u]�=�n;o���	�\�u�+���v��M�ܠ��jAp�1��zm��	T���l���v2��U���w��5���me8-PڏZ�P����L�X�y�mV��V�1"I_�Ѫ����ݣ��[��fծ�    KI��|y�;\����E�F��Abv��;��V>�"�L���=�B��f�%��Wz?A8&Z���m+�"C�t���@�����& ^VHe���!�4�r��׼"�0҉��C`�=�}���ӯRR�0�^�����r��Av`Cܷ1�}��[�s���eyQ�<kz�,���;y����q�^�u�=Xy��e��Y5�]��p !��:,0��a� �~LVC�������NZ/�����-��{��qj��=���?e{�c^w�YhԱ��Z��z2�dA��JPM/��I��:�wk�7I�_�6vQC ~�x�^M�Kz,��/,�i$a�[�X���I=��RϾ>�ʭ��l�O��U��������sZ�/��Ҽ�&����n�Ԉ��FN�/���������Gi���yJ���tY�Yj6�F��Ȱ�����A��Ey�W�YJ�tk�Q\/��d�3���o�;��;����n5���v�M-��x����۽�^�����F��4Y7�J𹲄─z�m]?�fY<JA��/WpΨ�9��S��a��$��/��CL���j5�H��ق�P�j��w�HǗ*/�ܗ�0�y�B� ��b�3w{���!l�/�c�Y��"\ gټ��]��byǟ�8,��˒����k���v�}C�+���NJ�02���:T���@�z��r}DVm1����PT��u�u(2���2�ˮ�*�!j8�3o�A��경��wY��$�;3���Q�W��
{���_S�9��&?�M���<��"\5f��{C}]���z���~�q<O��� ��RH������GX��ICܯ�;Dԧ2p�I����Ի�V-�АMܽ;���F�H'`\�4�G��h���T�AAN�y�v��,W��u��*�s�v7AXl�Ra?�$�5O$ad01J/�2͈PJ-�f|��u�+e����ь�N304[���D��N��Zߥ���L��
��aA�tkn�u�4���aN�U��ו6hZΝN����*$�y-���������)����.�ɸ�( ��]V����{���I�<��r6�+�m5���q��np��'�,���%��	���ؓ�q�"~��p^��{�$�#����ۣ�t�ͬ�l�c�oəh�_��7���fW��|�+K[�1-]u��e����,],�!��7��r�]�j����k/C���抮S�8uA���Bp�Ɉ�*1]]���<�1���l\�#��Z��l�7Ɲ=gH^�9,��BF�/LQ}�����x}ٔP1�G�ګ"E_�D�B�!!�|��{��`]��v=�G�y����������cJl�"uI�>���'���J!����e�(d^�갣T��z�����"Ǧ�a��<�ǎA���%A�?r�Ȇf��z��9��q#:ѧMےRp�eI�dn��=���t^������у��U<�X#C����X�i�D|���ee�t��q��a�ؗ�ɠa�X�m�/k��1�r�uϭ�S����6��"�t7�d�ul1��^֬fǨ�����2м2� Ҹ8�ݖ��'|qeh�۳����g�Hɖ����%w^�kD�{¯�!ad�M��f#\>��O3�g�j�)�ÌJK7����P�[��#��
À�56�s�p_e����)��h���,��*����c��߼�?���jK���S��,���%�� #���5V	�M, ��u_�On��.J��4�)�+�s��\�\H������~�p�F;zM�2���J���6��}/]�MkK��գ;�Ϊ$��>�B3��F,�`K*=��󝚢՛8ORp/Q&�4)�Fhw� ͣVhY���/U:J6"�����,�8�Am�}13}!�.���b8G�g�	7�������ᅵ��6��8�S��Zt��R�r�I�Q����>��^mF��䎵ݷ:��_�]��/]6�˖B'hQ�
�J�
]yx���W��$�{$��}�k&,�p�r�ª��M��G{���w��O�d����ܑ%�m\�>�I��Ğ��m�����}˶Ss,�(��0˧ l���1�!����7I^ٹ�,!��-E�L���o�Y�
9D�M@k�.����4Ho����D�h7����y��j{�f��3Z��%�t��2��؛U���c��{�>�1�.��S�C���|��b�����h�T��!Reo�u���z�kl�V�N�FŨ�^l��<K��.a��f��e< �%���>�������9u�6�٥f�]E��k��l�7[3|sx�=uO�Nz4nK��LR�ҿ��YF0���q�I|^�j 	�2��f��"?�*|����Iv���s���;{}|z�sكw�?�~��x��FV�M��4��op��A@�ȵ�[PE3c>I¨�=*�Mw1��)R���埦�}���)V�u�TrG����ͤ?C��0�I�2O5�V�(17��.��(@��|>a��Y9�z{H�Q;��1�w�[���2�h-��O��3L���{�R��,�7�����ld
4��%۫<q����mL ����3���!������򓜺Y���>��]���ֿ�y���2�����,�	�Z����o�o�-�,5��6�ǘ�~qC�m�������"�)86$��*��H�'�/B߯�Ept�~䖮L�����X�	��7T���I5���Y��ढj#���ON��1�]����2A��Gr�h�c6�(���P��w��eiZ={	�j��թ�h�pu=I?�7jq�j�إ���#�{<��8ad��y@T�F|nK�= ���~�'�}�3�r���&y�B�~�v{k�w�)�S{��e��i�Ѿ�D�u�ߩ��K�Ȕq�P���Q��r�H/��e2���n*��d��+��HV�|I��
��I5������%��̲�hG��h��*7c�i"41ؤ�Q����6̷0�뉁��֖|_T���B��(�YM���
��4
��B�Fz���xF���#o!���dk/ �E���a�iVOz�)e�ώ�XkI*�/1>������L�� �R�E2wC���b�c�ͽ\̶ux�N��mR��/�8vS�S��--�U�^ "���l�/���p����5Ke���� �.g��Nsb�eq��F��Oo����!>8�;�v�N�K,�fV��ȫ��U����z�H�}X�M�g�9��$��a�yL���6�.,(�.#Mjlze+��]L��2���C�[��� �1��!��'��-��?��8?�5��}��Z�N%a�f��y�ff���I���(WV�Z_�JF���g��y��j<O�ѭ`���eS��i�H]����'ɷ縻��oe�Է�F�N�GX�hw�p�cTK�[�݇!�L6�ϝ0�������c�,��������Wɐ<��-�����	�.��%��%6�w��6�=Y�a&y�N��� C��YNC��47���r���$���1�n-Y�G_W����@_Ct�k~x�����q}�mx��	F$d�J���X:/�M[�՞^b����E�5:�V�
�a3�2�z�խ�����-�a���+��vފ�q�N�w�	�jT\�Cs��uљ4-ƙ3��E�ϼ �=S���(�	y��}��WD@�'�1G�����mkJXwP2$����VT���lo�NlH��F�ːWy�d�QQ�arE��,��'��.��_��{�b܄9��i��7i��R��7�@��Wo㰋Wx?̔�a���a=s�1Q��a�]�3�w.aW��'~Vv��%,��3?�V9�	��jo��ia�=��9l0�F������R�
V��$�E�Wvn��p�!~@�����$��''�@��8���r���n�~(��C���$�	�8$�nt��m�[aO��/�Nn�a��q<������(�_#������mܚL&z��Klo8,�uʻ��{яc��Ma�e��f�~1��o�E��p��F�����~    ��&D�?�.��G�m�vm(3���ATTWWS��v��m���巛�Q�Y�Fh@�y�� �� 3��f�PM5@���?���,�ӌE��W�Ӆ������0�����il�M+`1������ߨ��{�c�`Rp��0���L��<�X��3pN�=1O�k6<pL�ٸ�I`Ͷ[_�Z��>���:��̰���B����Խ���vy}N��ʯkx7�c�9�?�J:bL!}f����,����Pu��FƫY��F�:#�U���G�!����,D����i�1����V�S��I7�N?�mO
�p~j��3�2E�J^��og��`�#���m�TO� �c�&�߇���K��
S\�Q(�h�9k�D��Jj�%�02�&��M���m��p(S���A� �Fn������X�D����6�8�V�Ƕ�0��N�}V���Ut��J;;�}��QT�D�8xʯ"�IUCc࿰��2jW�jN8xC��s�/}	�z��&ȴM�>�Z�c�+��Z��{\'�jn(�c�R��k�8�뒤�"`�Z[�#�K#�5�/�x;.-��ģ��VU��^A���U�[��7�a�m�f��$�r� Yߗ>�4paOf������Ͳl6�?���
�p3#�ٵ^�f�'�f͊5�gE�`�K�u&h���y�p�Dt�&ҋ�h�<(�AcO$9{��18�_b�m� �Q"j�>��?f8�r
��G^�Gw�uߦC��Mty2���i����=q|�*܅gU/`��q�P E�z3��a?��������)wI���㤞���l�27�i�W`�I;������x�=z�64�0��>������@)тf� z*���t䴯 ����
��P���j�N�ٞcr�L�n�-Xq8l��0w��J�}���Nc�0k��pZ-�$�C0��$�}a0�u�H�*�%��7i.&�
Y6<�K"�+I�W�l
�fF,k�GR��
퉝��a<�b�F/U;�VpNɢ99�Y`Y䗝ܐR��E2�R�5M�tR>�0%����ؿ�e�u���6�x9��,�������
kdqKU~U���\ܐmzy�2��$��Q�oֵ����Dp�{�M2!_��ȼga��3ڦ�?���p�5K�+�%�����u���Z51���Qnڷ~�%QrE�F�ŗ�`#x��W�<�4�#�љ�j�K����g�!�こe�I�+��T�)�s$V9��_�3L��Bڪ�G�a�����k���\��<ɮ&�n�Nn�]Y9r	:OY�{����V�y��t�f�b�Ƚ�����k�n�[��=?r�1�D9�?֭�=��`띚	�(�p��`1�n���ىs+����Q�5�{�鷈>�� $��1�`#} ���g�l5�Y/�}O�p�4����J�i7��	�?YA������1���͓��Y�K���!��T�D�L�kn��7AGm�o�ܲ�g�2;�Κ��"����䃋,¾�n�=&v����ҷ��7���6�\�o�!���I9I�m�B�����7Ǩr���p�<��(ƩaM���m��A�ɚ^IPJ�F��{?��}$�$g\Yf�>�8���rц�>N��� 4P�u��5�v������f���ޙ�C�*ۨ^��}�l{��CmW�L�<����:��<��V�8��8��P)���[W���dk:F}�}i��6�$	��֯���^FW@�>,p�=��񡩺��MP�$�?$�ґv?��Q����<��5~lYX�nQ�eXȎ3�*.㙮�R_�A�adܷ�܈Ԯj?�^ՊSޗ�	�{��5���vљ%����A2q�D��x�k��,�.m#���⍗�y
	�R5Z��p�"fi6�}��+�pK���y�A\����T��"��'��V)���%��a5�(��Z
F�-Xy|i���Ȍ�R��9��'����^*u;7��,���hwb��MU�c��Q"�T]�Ƅy#�9����n�$����솼�K.���� �O8�	Nz	[��v2�g��'l�ŏ�E1/�e|�L�h�-KAd]	+o�����g3�Y�]����^=(������ /q^���N��[l/�/�p�|{&�fAu���N��l�'ٗ����/��:���v�z��ya[�+ːE������\�Xu�m���cT�B��Ƥ�����#����}X<N�����]/>�Uf:��h��U��k(0��wcF�ka�n��0D�5�q,3�^���߄�TXJ�e�m�K'��|X��e����;����<�n ������7r�Ë$�K�M��U�M��8B	/�]2,�Cb�d�'�a�]�~��;���',gp�����$���Ⱦ���wBL�&�����Mŭw
w��ZP��|�ִ����f�G�ԙz���Zi7�;4��w�����!���q��{�Cl�����	���?���I �d*"?h/��1#;1��8�3�a�k
��e:��<]G��t��gׇ[Z�pK憫c/�Ї4"C�
M��DXs֏VV�XtD��~A��S�w�̕i���C���69�d_�0�u�L�t)��5���IsQ�κV�Lg����r�z��@�x"���"~��C�嬦��-�/�7���|�02΍Ų2�u�C�����n�AB��5��~?�]��U���Q�!�O[�Wf���A"g{����^����0m�E-S���{|AC�T�	<_���װ��\�[��}���j�/�E�d(���w^Oq���b��z?d)l��;v�'� �	�n��\6����l�k$��Sϯ��"C���Õg�#Y�������'��!��͌�n��4���N��\�ո���v��V��i�w��P��}M�	��0CY�]CJa�Кo�S�A���,Ũ�_�N�]��!����λ�Cf3|Ë"/t�k��o��5̹������dV�WZo���A�}?����sl)0�	���ǩea^b�~��F]܇!�4����`�|�.�6�C�C���۵���󾾉�dcͧU��Al�|?
��=�\&�3���K-��2&�"�:�>x�\����!��>���G<��@h)�6u�K�$�����o*N��I"&s�N":�.���%5�C�����OŨ	����RE�6��eR0P7H.ѽ=�mk�?��!�}��9w��k�a��Ng�TV,�&wI����[�G+p*"��V���;��,�����!�p˨J���pغ�57�:g���tS���5i��ό8'�U2�s�i"�g��ʂ��D���d�x潯j�����R�K���e-f(-ڼj�7ϣ�ZCjy��.��c8�P�)�c���N4�=۰Wڗ�ϸiwЩ�	�[���L՛��]�Y�~�߶aX�꤬�
��ه�br�E`��/�!��'U^\?�������m�^��ٔ!7�Q�
�p^3Ii8-��dᨌ��{�^�&c�_̴d�z[0���Q�F*�a�*j�+fHN�c'�R4W��,����Ԩ-��QL7� ��Ӳ��d\z���9N����.�>.Nf:�s���N����2�5���P�1��`#�0`�.',�:cF��U�J$��%��s�2�#����0�\ϵ��l�nJMr�I�m���S�>�bU�KvR�=5p����W��\!gEU���B�uB��2\��H������o����ܓʧBj=���Nq��Σ!�TB���w���Mp`���FW����Ӷ��K�>�##/4)4.��!�t��B�D�
�P//��`��e���$����o��[7�y��z��,��SL>`l�W�ŕ�ok��&�?�3��.2��t�Ci�V!Ȩ�0{�V$.���o(�x�d��f+l��7ҢK����g^��
C�g��"�re��~��ٳ�T�*0=���gs�;B9��R��z�-)�56��Ϲ��ڮY�h���n}��Wi~^<�����k���bl�n���4t�p��[.��)    �jȘ�@�Jރ�����x��|��#;7s����Q^ڬkh�`�1�i�-�
y��7�g�a�X�H>!����4g y�,��0��������ұ�ޥG��y�����l��J�Շ!�Qs�Wz~��^w��&g iwh���#~�b�R+��kS��uc�G1e5�[��!ܨF4�ݽ��%��!vT5t)e`d$�c�.M���(j,� mW� *�Bpni���
�y���Ffι���$�l������;L��6������_������� �ի���x��݄9[�/:Q%�(}f�,�z��xV��,~2�����"����CQ��Zx��L_�I������SuE���~���pߏ�D�Y,�R�7p�#�l}ov�w�xԤ�=z�����Ĩ�{YZ�b�소i�(0�1�%�F�nf�
��!§źk0{�gV�f��"�G-ݵ��s~�8� �y�7
>t+	���0����j��712���qH�L�yK}�k�������U��YB����	R�h�N�~�#M���%t��02�4+��C)��c4��#A�>���fY� �9�`T}Ή R��I\���V��Zuh-<�a������^1M�5�3�e:�5UvzQ9eO�H��U��Mul���������s�]]��5�,��gȥ�ȗ���@�"�V,�p�q׏=�)�J�J�mO6�� ǉ�:�6�`�K�G�P�Zx��I䬚����9��{4���E���H����t�|��ýD�,?���Dw�ND��9r�ߒy��t#�M��m���&4���J`�,���GN�ha�S�š�� c�G���mT[�dh�f�^�n'��͋e�1�Mr��)u3B�{J!���.�2!22�,�;�L����9j�];�M�Qw�q��Ć�	���x\�W�D��Un�I^����g�9Φ�c��BD��)UJ�a#�� �I��of'y��8�W  [j%�����i�۠�1�U��:�M�(Α�U:���/��,�YQBi԰��V�-W���$N���8՜��d��vg2p�D�t��_as�;(�&���EA��̐���(�[�L�1���6��7+���'�[,�[�]��z�5,��d��
}t'�����,�L�B\k�>#pp�aNo$&;�(�����xOB�[�7�`����#�=�nQ��	> ��?��:̈́;�:q���m�����/1W�*p�G�O+b���M����J�bɗu��H�1� ՑF�<N~�'�@I�����Ixh'�A�6�/v��8�S��@e<Ő��VSׂwY�Q+�'6��'мE��z�=�?҆�ԇ!���t�ȱq�4b,B6�+{1��YE�p�D�{w�������.81���3B���,�%3rR~��6�|�����tz�8u�~���r�X�1�yQ�f�D�,2t���Ń��;<��]��ƛ��D��6�aUyU��n�8��z��Q�PM�1MF�һ]]�/��Vi���#�1e��g���{�=}<���/�|���&����vI]���d�+0�wW{�X�QN$����Jr�S�W����,%W.3����1̂ ���`���C��CѨ<@ƥR^�zYV{e���~nRA��sw��:rϑ7��;�{Q��FMr���T_E��v�����̻Cг�����~r[qF�'��~���m�~���\=NnחsC���Tz������S8���A��C�уۦm!�y�1jq_*|Rߖ�4'z�S�V����Z�Oݴ��L��
kSY#}?i����9��.-�t`�T����0�y"d�Y��j����!��C)i��!0gK0NHC��T�Dm��fֳ��I���JXK�Iߞ�</���7d�i:��E>�%���%*DE	���n�	O��㬡�!���q�Y�R�ӽ8�#j>S'JCQ�T4z9N�g���~:����D��/��]�F$K�!���]�K� ,<�Ɗ<�!�$NG9"O����o�(~ �=�|�O����#e����HE$�'Y
 ܍"X�;o��>��"���)�֮�2e}�����zAXK�0��2�+&4�у"�=��� $���f95D]F�4�X�T)�?���R�p%�%���u�DR�Ob�<��"��9�SsH��ꨬ�D廖$��u���	�\
_kG�9�vGU�q��iI�{`��唆��7��8)FII�T����ߌ�3��ً,�LۭQ�j��kPS�r	C��m�&���b����"���-��Y_(ZKC8-9��-�z�'>��X���zz�V��`FN����m�>k���3S)f�&�]9@���ȁK���U\��"	1�G�P*q�e�EG([��t|�bNX�L�����-��]�������F��w��c������ۧ�a�H2�M����-�%j'�Q7�Q�fELޣ�����+����Q������kӳ��'��m��4��#��C�gLj�fK�IDc��b_�:���_�4 ���$G�%W~���S�p�/�܌��K�	���	衖W�>�����^	��X�U===9��1Dƞ&9�\�&�&?��3?�����se5��Z�eU�o�,�q�ܑ7�"�� ��Y�k�v&�-Mo�]<�tC����Z�#pg�]����>\�Oz>m��9����:��oc���Ax��ߎ�#��"}�3�a!<�L^��~M�w�}�A��zJ�JO`}�2ğ���mQ���b[�7�#Qx�XK�0��4~j	�aA��cݘ�Y:�S)���0�` ���N�־���\g�|��[���Ȃ��"�k�Fkn�]m��Y>�/=�z!
�0�'�YR���
���h�S��) r���dmČnT*�s�P:�H�D��q�����h٨����h����I��X-��k�<�jINzF��fq�]�ɗ�K!���02�ɇ&�D��{�q %�k�	$����4oR�\k홽\���5*x6O2���s_�j"d����mY�]��C=R�.��+I�*2�ѧ58|}O��Ѐ���1$ß�ܦ8�e7t���"´x�����������p�,�x�M�(�e�*˘�U[^�! ��x�a�ۮ��D8�Qvs^�r�h�n�ラ�=�s|-Զ�zS�bp���
�SRx�wŝ���"�%w^V��cR�z=���%ή���Ⱦ&I?��?�O���s� �<^�b��.��V'L���9w:�S;q��Mռ5���CVu��*��شұl���o��oU�) �Ǡ/<��q:����ak��j�@�9�
;Y��Pts��y���21�YKg����[�j��ܣ0��rx�Z*4�Fy(ff!D>[m��i��)e!vSB�l�E*k�m� .�����x�0�n�[Ci��2󥤁�}�3=�_̼>����`�k��vE���S�ڔ���ΑST�j�\G�w0܃��kx�te�gD#48���hY�F��U�m8�!�L�O1#o�)��� ��E������x�&���;b�B���ggG/��ߥK�Y��~fJy���df:s*䠛B�8\�K��	j4�;��ݤfO�����-K@{S^ �ǃ���J��>_�&���0��\t��h$<Fkz��0��D<�%�v��B����,���<�p`TL�.�LϮ�Ɇ�g�v^�=z�}����6n�|ۥ�O߂��`�h�0��oHj�	�Sx�g&�,mY�4�E����B�.�j^[�P�e�:N�Qqr�^L��t�h�hJ���6bO���>|�DF�$����3�p����$uۚw�����:����λ���Q^��,��;S��zã+0��Q�4�l��-p�3ԯvD_z��� k��>9(�|^^�j�a��r|3�QT�>1�P۵@p������GA���Ks9+�]�ې���n6NmSW�I����%q���4vW�9-F%F��R��-�C<��~��sz1�R��!�L���ٕ�J+�`M�s�)�3d}5�d#Q�r%��?��5u[{}Qk���P��lR�+�Х����}    �^˸��p#�������N�>B��� k�����\��ă�h��fOm���
�h�
���(XH����|3G�s�!f"o*ąh񈯵e1����i-�����;�����3��i|�8
�P���mB3e�4��d���J����6'h�?L���MG&UH�@M���j��}!�4֕�^�mI+�~�t*H�៭2 yF1�r��C�e���v����u���J�K��aS����}t�6F�ִN��a�'`ګ ����k�E�U�xJ�p�a����BN��o��}�5���+�_���V0��v�}�G�.�Ƀ��W�'+P��՜�L}�D��<~��L�A[�S�_/`gW_�ED�����ݕ,[F$��A�GJ�.=�i�����և���w����8&�X߁�REM����S
�Q�������.Ë$&��?qA��4>�ι�U}�.�Ym:!���$�i�X}�3̺�װ�3Ҩ�mj�]���C0��F��U�|_qx B��Pc��������Y���lsJ٣˥>�
��v�G�B�S+M���1���>
�
��zvL`L��m�x4���<+�ϭ�k#���&�~��~Y$��n���|��mk=]�'�������_-������y���!�N
8�F�K}�ݼ������"���1�g�Gr]����m��(?dv�`q��:���������ZٷoŎs$�з fJ�V��$�]�K�Tr��;a��ۦf{�D�v��7˥�i�k T����{��8���z�_ס�Z:NoӡN�α�#�ug:l ,�w�������N���X�c)�q�u��S����h�ǚ%�7t�O@-�P!�%`\��̓�;�T��E�J���Sݰ���^�x�_�,>�����~:���̓b�-�x���� gY1�����-�1(�ژ����KQ/~�Q0���^�,���T3���alr�鏋���x�@xG~z�B\�� /�8�y��*���P}?��P�<.��bE�boe�]�����4ܯ��z]�������+L,�L�F��T��-e�Iji���!�,gI�x����V�DШ��uǗf�ެ����y�k�m�f��*�� �)68�d��Lo�.�r(�:]�`#��<oUK|�ؙ&������ۧ�U�z��-��{��{r$G/�ޟvmè���rp�\���o�`vb����8-�q F�%c1������c̖�s�H�U^y�o�qW	��ʠ&�ᆔP2�9���Kї�p#!m�1I˙����������{i��B#<��Փ���G^��4ݿH��=#��lJR���p��d6,��w�t^�Q�8'�1��o�Q�X�/<�؏��)#A�j��E��*�Sa�)S*#d���^��U�+�ɗ��)��nC���F�J��X�Xo�Wp�kYy<�sp?�38ܢa���ŧto��ed��r�`�j5:>��f�Z�f����ސ/Lȶx��pB���E�S5���0���B��K�%�)?`53� �ȏg;�7;�1��o�O�l?�>�����J�w��'9��V9I�!�������`{ �;��t�O������]�r�F��+zG�*D�_x�*-��X��(oRS�A@H����Yf�Ejf5�����~�M��H�&e�+.WZ��.���9�d� c����q�V@����<��mf�s�W3��}"Otrlk�G��E6�N��: 
u@;�y�0���.Gb�"^&�2�w��$��1�}<�n��zE4o�1��V���xq��[�x'b%V]%Ȫ�4�#4ը�ҡ⦨g`����EU�x��c��hy�
��,
#!9�u����_��.��EE`c6���&�xIY=��*�M$=OHS�(WF�ijb��IuЋ�z�:g�7��B�c"���W(9��Jl�D�*��Yv�O1�^�j��+n����|�.���]?���g���Jz��t����ʷɯc��10��G���L¹�a&���4�¤�V-�9�/�'$�hM�E�E
���a����Pm�ћ����)��|w	��y�4
':1�<1.j�nOe�.��g�O7�lH̵I��h����Qb���*ܬ�^u��㤩������{��~,=S�Y�*�$���7j�� ~�q�8�԰��1�J�囩`b�8�?��<
��2Ǎ�+�j�+b�ko �$E^%g.�҄�����ag�F���w��7s�y����{	��`�(HZɼ����ؒ�j�hM�&u�x���DL���9V����(�����NnL���g��[0U���Rr�!O�y�"#p��"g�:�X�
�ϺH�L�Ȕ������磇=	���5�=�~ث��9���e���~��֜��b|�|�K�Y���*���Ү�q$��<��O����M���hA-��[>�����:l//�TI��4��F������oO=��8f������
�λЗ��6l��*EY:ݒ3�Lru��Я3H'��9�c؂����vOw�ɋq��]:?����;�7��ʂ�$�ܒ�t�7��<�^Uމq��c��^�㶸yA�c�AԏeS_���ۻ���T�K�mH���	V{������L�SXs0���Ԁ��<-��=N;�kfO��җj4�����'�%��������#�t���u��ɫW�k�div�mfƸ�<ǜ���ƝaX!�Qş�gVw��|z9׆sD'��a9��1�J+�`]�����w ^�������]����o�MR���!���%��tq6�����I��k�U�3���[�Ȓ|�y7?(�|����=;�w��px*�P�^��ه�
����1�`�j�ߙ/F��[ϒ�j3lYOE"[��0��&�����}�UV̰������� 
�:8�8�f�&��B7Ű���(� ��m�������������Th��r��DU5%�<����1��8\�N�f}��s%!yy�̏Hg�t�nG���X����14G�|�ҏ��s�(����6�������X00��P�����G��g^K�%�-a�w��ۃ�Y����o�r曆������������x�F�p&�V�_�F�(K?:��=UݔM�¬��s�sA�=a'PY KX3���R}'�9*�7ԧ��{�Y�W��6�$�5�2����W%�<��Y���0���zk���(+�q{H�(��I���٠Vz�3d�6��MlDT���}	R+�!�N���5h���zO@��e�&\A!!yן�������Z���$}j��V*��1D�x��A�c��'��U��<�)8��"X�J��1��<�� 5J�G�"�Y����(v"wc�t���5j�����-u�MM�/;�錭'���R��a\/��^�s�2�����P�IQ����%�����H&�ΰ]]����L�\�v�(���j.�QR`�g�<�b�M�:�A��j�����T��j$�P�-Ӏ�J��f���A��p�RsX�J����V�y�`�T�b��T�����'f�n[��b���́.Y�5j�6��	�49�M�8/G�
r�Zͫ���1�<Z\�b�f2�"�E��g&��EC���aG�z+�%�X����B5{�yV��7Eru��J�"����VO��0#�Ӝ���-��}�����-8W{#�����fM�|J5��$G����ּ����Z��� '��?] ��@G1�$!�]�Xr��1Z�u���1��pL�{��7����eDg�U�)r�p��vֻC�����b�?�1[�.�~ۃ��mpa�q����^`���A:��("Bq�u��WH����Jj�P��r��l�V���'������jFI�^�ˆ'+$��s�;f�,1Z���r)Xpgs�I
�VM�X6#͔w�Mʅ���ʐ!�"[� �/d�R>��T)ݐ��Ϳ�6X`����vL�a@x ���Roy�o�Jt�j��2�xR�u��w���ȗy�N���M 3  ���I��-)��ICn5�yA�ʹ7Kj�������1�8_&Z¤��b�"a��}�;(�x���b��Ov���B�X��D���>�UOҗa ϒ�%���q�Uߠe��.��dd5cK���:�Z�2r°to���)�V�����~�	n35[�cb�&�^�PRܫ����7=��8^�S(�t	�E�k+X�O���y̓��{;b��&�5��_�'>��QC���$7�����?����YV���N��R�h�8uzZ՝�gY��̪.	K��M5N�s�,����Sc�诓���5+p�%�A�	��2��C�D��<D��j+�ZO�Ӕ˺��e�j�Ͽ�t�������E����;�
��"���}�}�E ���jh�\D"�1�D�]�X�� ��0�%����B\u;ud����;Ľ:�z�;�s����vꌊ\�h ��Xx� ��F��_@�"��%ET�5Q�4P�����xDx�N�q�[��<X���;�������n�Đ�1���ay킆/-��2�FOk��U������<\�<����ӑW^���0�&�����}(� 8'�g��q1l�����ޏo?��n��=O��50`�m������G�W����$����v#6��'���Mr�0����kϵC�������x�
���ӫʲ�	�kJ[�B�'x��4�N��tǸ�E���ӗ'�!���]%SF��ۋ����LO�B�S)�5H]u	��`hFҫl��N��3/�1�/���v�_&��]�����a�A�9%�����MӋ��
�(e�̊Q� ��������`�S��o�t���=ʹ�m��
,�%%�ڶ~]M��;�&!o���J]�ݮ��w�/j���b���ѝoC:�Ig[J�Ώ��1�"����}�����<�*���5�<;G��W&�����@���kp;���dP��ҤnU]�-2r]C�����~BĈ�mW�V$|��E6�
LQ]=&��C���a�/L��3�	t�&�dPfμ����{��R���>��)
<s�%���=/Ab1�#���#�A����1��.�M���m!CC�瑣���yZ� 6K���Vm��YTxy�yQ��t���~&g����ι��ox�(~J8�W�?U~���@�������
)ȥ�&��{�9�]���V� N�k{�(B_F�D����*�����7�=7S�ԥ��LJ��N�~^fn��z|�c� *|I����]r�h�e*�v�_�˴�ζH/
c�JǑ��Mx����t�%�P
R�Y��@��R�n/�w����@�g���g\s�?� Z�D��Dȇg�:S��������o]	�K��&�$�Ai'&�??���Ц�|0>v�<)�LJ_F�0�"W��+T����^:���,��CL�������\�� ײ�	&�N��;�ep|�7y�5��!�E���o�˹�%���r23F��L81�x�<c�#<�ʕ�r�	���Ш�|[$]��j����-����euq�j�����O�ȋ�ޫG��?���7�����      X
   P   x���v
Q���W(�,ȏO�I,NUs�	uV�0�QPq��tvT״��į��: ��9�������a�@ڸ� ��)�      Z
   f   x���v
Q���W(�,ȏ/HL�Ws�	uV�0�QPq�rqTpqu��W״��ī�I�s��Q����\\���Rm�"��/��5�������� �8f      \
   I   x���v
Q���W(�,ȏ/HLϏ/NMIUs�	uV�0�QP�u�u�Q״��$���#������� 7�0      ^
   V   x���v
Q���W(�,ȏ/H-*��KTs�	uV�0�QP2}���5��<	)7*�ws�"J�1X��s����_�+H *�*�      `
   A   x���v
Q���W(�,ȏ/H-*��K�i�9��
a�>���
�:
@���S�����i��� sH�      b
   T   x���v
Q���W(�,ȏ/(�OK-�/Rs�	uV�0�QPw��ut�R״��$��I��qz��z���\��z���� ��.�      d
   
   x���         