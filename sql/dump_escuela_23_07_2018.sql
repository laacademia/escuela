PGDMP                          v            escuela    9.5.12    9.5.12    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    325206    escuela    DATABASE     y   CREATE DATABASE escuela WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'es_AR.UTF-8' LC_CTYPE = 'es_AR.UTF-8';
    DROP DATABASE escuela;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6                        3079    12435    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            ?           1255    325207    sp_trg_ai_cursadas()    FUNCTION     �  CREATE FUNCTION public.sp_trg_ai_cursadas() RETURNS trigger
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
       public       postgres    false    6    1            @           1255    325208    sp_trg_ai_cursadas_alumnos()    FUNCTION     �  CREATE FUNCTION public.sp_trg_ai_cursadas_alumnos() RETURNS trigger
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
       public       postgres    false    6    1            �            1259    325209    alquiler_sede    TABLE     @  CREATE TABLE public.alquiler_sede (
    id integer NOT NULL,
    id_sede integer NOT NULL,
    fecha date NOT NULL,
    valor_hora numeric(10,2) NOT NULL,
    fecha_alta timestamp without time zone DEFAULT now() NOT NULL,
    hora_desde time without time zone NOT NULL,
    hora_hasta time without time zone NOT NULL
);
 !   DROP TABLE public.alquiler_sede;
       public         postgres    false    6            �            1259    325213    alquiler_sede_cabecera    TABLE     N  CREATE TABLE public.alquiler_sede_cabecera (
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
       public         postgres    false    6            �            1259    325218    alquiler_sede_cabecera_id_seq    SEQUENCE     �   CREATE SEQUENCE public.alquiler_sede_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.alquiler_sede_cabecera_id_seq;
       public       postgres    false    6    182            �           0    0    alquiler_sede_cabecera_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.alquiler_sede_cabecera_id_seq OWNED BY public.alquiler_sede_cabecera.id;
            public       postgres    false    183            �            1259    325220    alquiler_sede_detalle    TABLE     }  CREATE TABLE public.alquiler_sede_detalle (
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
       public         postgres    false    6            �            1259    325224    alquiler_sede_detalle_id_seq    SEQUENCE     �   CREATE SEQUENCE public.alquiler_sede_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.alquiler_sede_detalle_id_seq;
       public       postgres    false    6    184            �           0    0    alquiler_sede_detalle_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.alquiler_sede_detalle_id_seq OWNED BY public.alquiler_sede_detalle.id;
            public       postgres    false    185            �            1259    325226    alquiler_sede_id_seq    SEQUENCE     }   CREATE SEQUENCE public.alquiler_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.alquiler_sede_id_seq;
       public       postgres    false    6    181            �           0    0    alquiler_sede_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.alquiler_sede_id_seq OWNED BY public.alquiler_sede.id;
            public       postgres    false    186            �            1259    325228    personas    TABLE     U  CREATE TABLE public.personas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    fecha_nacimiento date NOT NULL,
    dni numeric(8,0),
    foto_dni boolean DEFAULT false NOT NULL,
    legajo integer,
    id_tipo_persona integer NOT NULL,
    cuil character varying(11)
);
    DROP TABLE public.personas;
       public         postgres    false    6            �            1259    325232    alumnos_id_seq    SEQUENCE     w   CREATE SEQUENCE public.alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.alumnos_id_seq;
       public       postgres    false    187    6            �           0    0    alumnos_id_seq    SEQUENCE OWNED BY     B   ALTER SEQUENCE public.alumnos_id_seq OWNED BY public.personas.id;
            public       postgres    false    188            �            1259    325234    alumnos_legajo_seq    SEQUENCE     {   CREATE SEQUENCE public.alumnos_legajo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.alumnos_legajo_seq;
       public       postgres    false    187    6            �           0    0    alumnos_legajo_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.alumnos_legajo_seq OWNED BY public.personas.legajo;
            public       postgres    false    189            �            1259    325236    aulas    TABLE     �   CREATE TABLE public.aulas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    piso integer,
    nombre character varying(60) NOT NULL,
    id_sede integer NOT NULL
);
    DROP TABLE public.aulas;
       public         postgres    false    6            �            1259    325239    aulas_id_seq    SEQUENCE     u   CREATE SEQUENCE public.aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.aulas_id_seq;
       public       postgres    false    6    190            �           0    0    aulas_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.aulas_id_seq OWNED BY public.aulas.id;
            public       postgres    false    191            �            1259    325241    caja_comprobantes    TABLE     $  CREATE TABLE public.caja_comprobantes (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL,
    id_tipo_comprobante integer,
    activo boolean DEFAULT true,
    dias_vencimiento integer DEFAULT 0,
    es_cancelatorio boolean DEFAULT false NOT NULL,
    orden integer
);
 %   DROP TABLE public.caja_comprobantes;
       public         postgres    false    6            �            1259    325247    caja_comprobantes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_comprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.caja_comprobantes_id_seq;
       public       postgres    false    6    192            �           0    0    caja_comprobantes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.caja_comprobantes_id_seq OWNED BY public.caja_comprobantes.id;
            public       postgres    false    193            �            1259    325249    caja_cuentas    TABLE     �   CREATE TABLE public.caja_cuentas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    activo boolean NOT NULL
);
     DROP TABLE public.caja_cuentas;
       public         postgres    false    6            �            1259    325252    caja_cuentas_id_seq    SEQUENCE     |   CREATE SEQUENCE public.caja_cuentas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.caja_cuentas_id_seq;
       public       postgres    false    194    6            �           0    0    caja_cuentas_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.caja_cuentas_id_seq OWNED BY public.caja_cuentas.id;
            public       postgres    false    195            �            1259    325254    caja_medios_pagos    TABLE     s   CREATE TABLE public.caja_medios_pagos (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL
);
 %   DROP TABLE public.caja_medios_pagos;
       public         postgres    false    6            �            1259    325257    caja_mediospagos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_mediospagos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_mediospagos_id_seq;
       public       postgres    false    6    196            �           0    0    caja_mediospagos_id_seq    SEQUENCE OWNED BY     T   ALTER SEQUENCE public.caja_mediospagos_id_seq OWNED BY public.caja_medios_pagos.id;
            public       postgres    false    197            �            1259    325259    caja_movimientos    TABLE     �   CREATE TABLE public.caja_movimientos (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_operacion integer NOT NULL,
    activo boolean NOT NULL
);
 $   DROP TABLE public.caja_movimientos;
       public         postgres    false    6            �            1259    325262    caja_movimientos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_movimientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_movimientos_id_seq;
       public       postgres    false    198    6            �           0    0    caja_movimientos_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;
            public       postgres    false    199            �            1259    325264    caja_operaciones    TABLE     �   CREATE TABLE public.caja_operaciones (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_tipo_operacion integer NOT NULL,
    activo boolean NOT NULL
);
 $   DROP TABLE public.caja_operaciones;
       public         postgres    false    6            �            1259    325267    caja_operaciones_diarias    TABLE       CREATE TABLE public.caja_operaciones_diarias (
    id integer NOT NULL,
    fecha date NOT NULL,
    id_movimiento integer NOT NULL,
    id_comprobante integer,
    id_sede integer,
    id_medio_pago integer,
    id_cuenta integer NOT NULL,
    id_subcuenta integer NOT NULL,
    id_tipo_titular integer NOT NULL,
    id_titular integer NOT NULL,
    importe numeric(12,2) NOT NULL,
    usuario character varying(60) NOT NULL,
    signo integer NOT NULL,
    fecha_operacion timestamp with time zone DEFAULT now(),
    periodo date
);
 ,   DROP TABLE public.caja_operaciones_diarias;
       public         postgres    false    6            �            1259    325271    caja_operaciones_diarias_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_operaciones_diarias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.caja_operaciones_diarias_id_seq;
       public       postgres    false    6    201            �           0    0    caja_operaciones_diarias_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.caja_operaciones_diarias_id_seq OWNED BY public.caja_operaciones_diarias.id;
            public       postgres    false    202            �            1259    325273    caja_operaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_operaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_operaciones_id_seq;
       public       postgres    false    200    6            �           0    0    caja_operaciones_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.caja_operaciones_id_seq OWNED BY public.caja_operaciones.id;
            public       postgres    false    203            �            1259    325275    caja_parametrizacion    TABLE       CREATE TABLE public.caja_parametrizacion (
    id integer NOT NULL,
    id_comprobante integer NOT NULL,
    id_medio_pago integer NOT NULL,
    id_movimiento integer NOT NULL,
    id_cuenta integer NOT NULL,
    id_subcuenta integer NOT NULL,
    id_tipo_titular integer NOT NULL,
    signo integer NOT NULL,
    impacta_original boolean,
    envia_sub_cta boolean DEFAULT false
);
 (   DROP TABLE public.caja_parametrizacion;
       public         postgres    false    6            �            1259    325279    caja_parametrizacion_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_parametrizacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.caja_parametrizacion_id_seq;
       public       postgres    false    204    6            �           0    0    caja_parametrizacion_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.caja_parametrizacion_id_seq OWNED BY public.caja_parametrizacion.id;
            public       postgres    false    205            �            1259    325281    caja_subcuentas    TABLE     �   CREATE TABLE public.caja_subcuentas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_cuenta integer NOT NULL,
    activo boolean NOT NULL
);
 #   DROP TABLE public.caja_subcuentas;
       public         postgres    false    6            �            1259    325284    caja_subcuentas_id_seq    SEQUENCE        CREATE SEQUENCE public.caja_subcuentas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.caja_subcuentas_id_seq;
       public       postgres    false    206    6            �           0    0    caja_subcuentas_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.caja_subcuentas_id_seq OWNED BY public.caja_subcuentas.id;
            public       postgres    false    207            �            1259    325286    caja_tipo_comprobantes    TABLE     x   CREATE TABLE public.caja_tipo_comprobantes (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL
);
 *   DROP TABLE public.caja_tipo_comprobantes;
       public         postgres    false    6            �            1259    325289    caja_tipo_comprobantes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_tipo_comprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.caja_tipo_comprobantes_id_seq;
       public       postgres    false    6    208            �           0    0    caja_tipo_comprobantes_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.caja_tipo_comprobantes_id_seq OWNED BY public.caja_tipo_comprobantes.id;
            public       postgres    false    209            �            1259    325291    caja_tipo_operaciones    TABLE     �   CREATE TABLE public.caja_tipo_operaciones (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    activo boolean NOT NULL
);
 )   DROP TABLE public.caja_tipo_operaciones;
       public         postgres    false    6            �            1259    325294    caja_tipo_operaciones_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_tipo_operaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.caja_tipo_operaciones_id_seq;
       public       postgres    false    210    6            �           0    0    caja_tipo_operaciones_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.caja_tipo_operaciones_id_seq OWNED BY public.caja_tipo_operaciones.id;
            public       postgres    false    211            �            1259    325296    caja_tipo_titulares    TABLE     �   CREATE TABLE public.caja_tipo_titulares (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    campo character varying(20),
    activo boolean NOT NULL
);
 '   DROP TABLE public.caja_tipo_titulares;
       public         postgres    false    6            �            1259    325299    caja_tipo_titulares_id_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_tipo_titulares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.caja_tipo_titulares_id_seq;
       public       postgres    false    6    212            �           0    0    caja_tipo_titulares_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.caja_tipo_titulares_id_seq OWNED BY public.caja_tipo_titulares.id;
            public       postgres    false    213            �            1259    325301    ciudades    TABLE     �   CREATE TABLE public.ciudades (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    cp integer NOT NULL,
    id_provincia integer NOT NULL
);
    DROP TABLE public.ciudades;
       public         postgres    false    6            �            1259    325304    ciudades_id_seq    SEQUENCE     x   CREATE SEQUENCE public.ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.ciudades_id_seq;
       public       postgres    false    6    214            �           0    0    ciudades_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.ciudades_id_seq OWNED BY public.ciudades.id;
            public       postgres    false    215            �            1259    325306    clases    TABLE     V  CREATE TABLE public.clases (
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
       public         postgres    false    6            �            1259    325312    clases_asistencia    TABLE     �   CREATE TABLE public.clases_asistencia (
    id integer NOT NULL,
    id_persona integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_asistencia;
       public         postgres    false    6            �            1259    325315    clases_id_seq    SEQUENCE     v   CREATE SEQUENCE public.clases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.clases_id_seq;
       public       postgres    false    6    216            �           0    0    clases_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.clases_id_seq OWNED BY public.clases.id;
            public       postgres    false    218            �            1259    325317    clases_profesores    TABLE     �   CREATE TABLE public.clases_profesores (
    id integer NOT NULL,
    id_profesor integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_profesores;
       public         postgres    false    6            �            1259    325320    clases_profesores_id_seq    SEQUENCE     �   CREATE SEQUENCE public.clases_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.clases_profesores_id_seq;
       public       postgres    false    6    219            �           0    0    clases_profesores_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.clases_profesores_id_seq OWNED BY public.clases_profesores.id;
            public       postgres    false    220            �            1259    325322    condiciones_alumno    TABLE     t   CREATE TABLE public.condiciones_alumno (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 &   DROP TABLE public.condiciones_alumno;
       public         postgres    false    6            �            1259    325325    condiciones_alumno_id_seq    SEQUENCE     �   CREATE SEQUENCE public.condiciones_alumno_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.condiciones_alumno_id_seq;
       public       postgres    false    6    221            �           0    0    condiciones_alumno_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.condiciones_alumno_id_seq OWNED BY public.condiciones_alumno.id;
            public       postgres    false    222            �            1259    325327    cursadas    TABLE     �   CREATE TABLE public.cursadas (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    id_curso integer NOT NULL,
    id_sede integer,
    anio integer
);
    DROP TABLE public.cursadas;
       public         postgres    false    6            �            1259    325330    cursadas_alumnos    TABLE     a  CREATE TABLE public.cursadas_alumnos (
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
       public         postgres    false    6            �            1259    325336    cursadas_alumnos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursadas_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_alumnos_id_seq;
       public       postgres    false    6    224            �           0    0    cursadas_alumnos_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.cursadas_alumnos_id_seq OWNED BY public.cursadas_alumnos.id;
            public       postgres    false    225            �            1259    325338    cursadas_cuotas    TABLE       CREATE TABLE public.cursadas_cuotas (
    id integer NOT NULL,
    importe numeric(10,2) NOT NULL,
    fecha_operacion timestamp without time zone DEFAULT now() NOT NULL,
    id_cursadas_modulos integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL
);
 #   DROP TABLE public.cursadas_cuotas;
       public         postgres    false    6            �            1259    325342    cursadas_cuotas_id_seq    SEQUENCE        CREATE SEQUENCE public.cursadas_cuotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cursadas_cuotas_id_seq;
       public       postgres    false    226    6            �           0    0    cursadas_cuotas_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cursadas_cuotas_id_seq OWNED BY public.cursadas_cuotas.id;
            public       postgres    false    227            �            1259    325344    cursadas_id_seq    SEQUENCE     x   CREATE SEQUENCE public.cursadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.cursadas_id_seq;
       public       postgres    false    223    6            �           0    0    cursadas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.cursadas_id_seq OWNED BY public.cursadas.id;
            public       postgres    false    228            �            1259    325346    cursadas_modulos    TABLE     b  CREATE TABLE public.cursadas_modulos (
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
       public         postgres    false    6            �            1259    325352    cursadas_modulos_alumnos    TABLE     �   CREATE TABLE public.cursadas_modulos_alumnos (
    id integer NOT NULL,
    id_modulo integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL,
    orden integer
);
 ,   DROP TABLE public.cursadas_modulos_alumnos;
       public         postgres    false    6            �            1259    325355    cursadas_modulos_alumnos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursadas_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.cursadas_modulos_alumnos_id_seq;
       public       postgres    false    230    6            �           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.cursadas_modulos_alumnos_id_seq OWNED BY public.cursadas_modulos_alumnos.id;
            public       postgres    false    231            �            1259    325357    cursadas_modulos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursadas_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_modulos_id_seq;
       public       postgres    false    229    6            �           0    0    cursadas_modulos_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.cursadas_modulos_id_seq OWNED BY public.cursadas_modulos.id;
            public       postgres    false    232            �            1259    325359    cursadas_profesores    TABLE     �   CREATE TABLE public.cursadas_profesores (
    id integer NOT NULL,
    id_cursada integer NOT NULL,
    id_profesor integer NOT NULL,
    id_tipo_profesor integer NOT NULL
);
 '   DROP TABLE public.cursadas_profesores;
       public         postgres    false    6            �            1259    325362    cursadas_profesores_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursadas_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.cursadas_profesores_id_seq;
       public       postgres    false    233    6            �           0    0    cursadas_profesores_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.cursadas_profesores_id_seq OWNED BY public.cursadas_profesores.id;
            public       postgres    false    234            �            1259    325364    cursos    TABLE     o  CREATE TABLE public.cursos (
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
    orden integer,
    cant_minima_practicas integer,
    cant_minima_teoricas integer
);
    DROP TABLE public.cursos;
       public         postgres    false    6            �           0    0 $   COLUMN cursos.porcentaje_correlativa    COMMENT     �   COMMENT ON COLUMN public.cursos.porcentaje_correlativa IS 'porcentaje necesario para poder cursar los siguientes cursos que son correlativos';
            public       postgres    false    235            �           0    0 "   COLUMN cursos.certificado_incluido    COMMENT     l   COMMENT ON COLUMN public.cursos.certificado_incluido IS 'Si el certificado esta incluido o se paga aparte';
            public       postgres    false    235            �            1259    325369    cursos_correlatividad    TABLE     �   CREATE TABLE public.cursos_correlatividad (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_curso_previo integer NOT NULL
);
 )   DROP TABLE public.cursos_correlatividad;
       public         postgres    false    6            �            1259    325372    cursos_correlatividad_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursos_correlatividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.cursos_correlatividad_id_seq;
       public       postgres    false    236    6            �           0    0    cursos_correlatividad_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.cursos_correlatividad_id_seq OWNED BY public.cursos_correlatividad.id;
            public       postgres    false    237            �            1259    325374    cursos_id_seq    SEQUENCE     v   CREATE SEQUENCE public.cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.cursos_id_seq;
       public       postgres    false    235    6            �           0    0    cursos_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.cursos_id_seq OWNED BY public.cursos.id;
            public       postgres    false    238            �            1259    325376    cursos_modulos    TABLE     !  CREATE TABLE public.cursos_modulos (
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
       public         postgres    false    6            �            1259    325382    cursos_modulos_alumnos    TABLE     �   CREATE TABLE public.cursos_modulos_alumnos (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_alumno integer NOT NULL,
    mes integer NOT NULL,
    anio integer NOT NULL,
    orden integer NOT NULL,
    id_estado_pago integer
);
 *   DROP TABLE public.cursos_modulos_alumnos;
       public         postgres    false    6            �            1259    325385    cursos_modulos_alumnos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cursos_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.cursos_modulos_alumnos_id_seq;
       public       postgres    false    6    240            �           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.cursos_modulos_alumnos_id_seq OWNED BY public.cursos_modulos_alumnos.id;
            public       postgres    false    241            �            1259    325387    cursos_modulos_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.cursos_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cursos_modulos_id_seq;
       public       postgres    false    239    6            �           0    0    cursos_modulos_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.cursos_modulos_id_seq OWNED BY public.cursos_modulos.id;
            public       postgres    false    242            �            1259    325389    cursos_titulos    TABLE        CREATE TABLE public.cursos_titulos (
    id integer NOT NULL,
    id_titulo integer NOT NULL,
    id_curso integer NOT NULL
);
 "   DROP TABLE public.cursos_titulos;
       public         postgres    false    6            �            1259    325392    cursos_titulos_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.cursos_titulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cursos_titulos_id_seq;
       public       postgres    false    6    243            �           0    0    cursos_titulos_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.cursos_titulos_id_seq OWNED BY public.cursos_titulos.id;
            public       postgres    false    244            �            1259    325394    databasechangeloglock    TABLE     �   CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);
 )   DROP TABLE public.databasechangeloglock;
       public         postgres    false    6            �            1259    325397    datos_academicos    TABLE     J  CREATE TABLE public.datos_academicos (
    id integer NOT NULL,
    id_nivel_estudio integer,
    estudia_actualmente boolean,
    institucion_estudia character varying(100),
    dias integer,
    horas integer,
    id_persona integer NOT NULL,
    titulo character varying(100),
    estudia_descripcion character varying(200)
);
 $   DROP TABLE public.datos_academicos;
       public         postgres    false    6            �            1259    325400    datos_academicos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.datos_academicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.datos_academicos_id_seq;
       public       postgres    false    246    6            �           0    0    datos_academicos_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.datos_academicos_id_seq OWNED BY public.datos_academicos.id;
            public       postgres    false    247            �            1259    325402    datos_actuales    TABLE     �  CREATE TABLE public.datos_actuales (
    id integer NOT NULL,
    calle character varying(255),
    altura integer,
    piso integer,
    id_ciudad integer,
    telefono_particular character varying(30),
    telefono_celular character varying(30),
    telefono_mensaje character varying(30),
    email character varying(100),
    id_persona integer NOT NULL,
    altura2 character varying(100)
);
 "   DROP TABLE public.datos_actuales;
       public         postgres    false    6            �            1259    325408    datos_actuales_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.datos_actuales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.datos_actuales_id_seq;
       public       postgres    false    248    6                        0    0    datos_actuales_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.datos_actuales_id_seq OWNED BY public.datos_actuales.id;
            public       postgres    false    249            �            1259    325410    datos_laborales    TABLE     R  CREATE TABLE public.datos_laborales (
    id integer NOT NULL,
    id_profesion integer,
    empresa_trabaja character varying(100),
    domicilio_trabaja character varying(500),
    telefono_laboral character varying(30),
    email_laboral character varying(255),
    id_persona integer NOT NULL,
    profesion character varying(255)
);
 #   DROP TABLE public.datos_laborales;
       public         postgres    false    6            �            1259    325416    datos_laborales_id_seq    SEQUENCE        CREATE SEQUENCE public.datos_laborales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.datos_laborales_id_seq;
       public       postgres    false    250    6                       0    0    datos_laborales_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.datos_laborales_id_seq OWNED BY public.datos_laborales.id;
            public       postgres    false    251            �            1259    325418    datos_salud    TABLE       CREATE TABLE public.datos_salud (
    id integer NOT NULL,
    cobertura_medica character varying(100),
    apto_curso boolean,
    observaciones_medicas character varying(255),
    certificado_medico boolean,
    id_persona integer NOT NULL,
    id_grupo_sanguineo integer
);
    DROP TABLE public.datos_salud;
       public         postgres    false    6            �            1259    325421    datos_salud_id_seq    SEQUENCE     {   CREATE SEQUENCE public.datos_salud_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.datos_salud_id_seq;
       public       postgres    false    6    252                       0    0    datos_salud_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.datos_salud_id_seq OWNED BY public.datos_salud.id;
            public       postgres    false    253            �            1259    325423    estados_pago    TABLE     o   CREATE TABLE public.estados_pago (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
     DROP TABLE public.estados_pago;
       public         postgres    false    6            �            1259    325426    estados_pago_id_seq    SEQUENCE     |   CREATE SEQUENCE public.estados_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.estados_pago_id_seq;
       public       postgres    false    254    6                       0    0    estados_pago_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.estados_pago_id_seq OWNED BY public.estados_pago.id;
            public       postgres    false    255                        1259    325428    grupos_sanguineos    TABLE     t   CREATE TABLE public.grupos_sanguineos (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 %   DROP TABLE public.grupos_sanguineos;
       public         postgres    false    6                       1259    325431    grupos_sanguineos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.grupos_sanguineos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.grupos_sanguineos_id_seq;
       public       postgres    false    6    256                       0    0    grupos_sanguineos_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.grupos_sanguineos_id_seq OWNED BY public.grupos_sanguineos.id;
            public       postgres    false    257                       1259    325433    ids    TABLE     ,   CREATE TABLE public.ids (
    id integer
);
    DROP TABLE public.ids;
       public         postgres    false    6                       1259    325436    inscripciones_modulos    TABLE     �   CREATE TABLE public.inscripciones_modulos (
    id integer NOT NULL,
    id_inscripcion integer NOT NULL,
    mes_modulo integer NOT NULL,
    anio_modulo integer NOT NULL,
    id_estado_pago integer
);
 )   DROP TABLE public.inscripciones_modulos;
       public         postgres    false    6                       1259    325439    inscripciones_modulos_id_seq    SEQUENCE     �   CREATE SEQUENCE public.inscripciones_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.inscripciones_modulos_id_seq;
       public       postgres    false    259    6                       0    0    inscripciones_modulos_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.inscripciones_modulos_id_seq OWNED BY public.inscripciones_modulos.id;
            public       postgres    false    260                       1259    325441    modulos    TABLE     �   CREATE TABLE public.modulos (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    numero integer NOT NULL,
    id_curso integer NOT NULL,
    porcentaje_presencia numeric(10,2) DEFAULT 100 NOT NULL
);
    DROP TABLE public.modulos;
       public         postgres    false    6                       1259    325445    modulos_id_seq    SEQUENCE     w   CREATE SEQUENCE public.modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.modulos_id_seq;
       public       postgres    false    6    261                       0    0    modulos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.modulos_id_seq OWNED BY public.modulos.id;
            public       postgres    false    262                       1259    325447    niveles_estudios    TABLE     s   CREATE TABLE public.niveles_estudios (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 $   DROP TABLE public.niveles_estudios;
       public         postgres    false    6                       1259    325450    niveles_estudios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.niveles_estudios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.niveles_estudios_id_seq;
       public       postgres    false    263    6                       0    0    niveles_estudios_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.niveles_estudios_id_seq OWNED BY public.niveles_estudios.id;
            public       postgres    false    264            	           1259    325452    paises    TABLE     �   CREATE TABLE public.paises (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    nacionalidad character varying(60) NOT NULL
);
    DROP TABLE public.paises;
       public         postgres    false    6            
           1259    325455    paises_id_seq    SEQUENCE     v   CREATE SEQUENCE public.paises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.paises_id_seq;
       public       postgres    false    265    6                       0    0    paises_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.paises_id_seq OWNED BY public.paises.id;
            public       postgres    false    266                       1259    325457    perfiles    TABLE     L   CREATE TABLE public.perfiles (
    perfil character varying(60) NOT NULL
);
    DROP TABLE public.perfiles;
       public         postgres    false    6                       1259    325460    profesiones    TABLE     e   CREATE TABLE public.profesiones (
    id integer NOT NULL,
    descripcion character varying(255)
);
    DROP TABLE public.profesiones;
       public         postgres    false    6                       1259    325463    profesiones_id_seq    SEQUENCE     {   CREATE SEQUENCE public.profesiones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.profesiones_id_seq;
       public       postgres    false    6    268            	           0    0    profesiones_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.profesiones_id_seq OWNED BY public.profesiones.id;
            public       postgres    false    269                       1259    325465 
   provincias    TABLE     �   CREATE TABLE public.provincias (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    id_pais integer NOT NULL
);
    DROP TABLE public.provincias;
       public         postgres    false    6                       1259    325471    provincias_id_seq    SEQUENCE     z   CREATE SEQUENCE public.provincias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.provincias_id_seq;
       public       postgres    false    6    270            
           0    0    provincias_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.provincias_id_seq OWNED BY public.provincias.id;
            public       postgres    false    271                       1259    325473    sedes    TABLE        CREATE TABLE public.sedes (
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
       public         postgres    false    6                       1259    325480    sedes_formadores    TABLE     �   CREATE TABLE public.sedes_formadores (
    id integer NOT NULL,
    id_formador integer NOT NULL,
    id_sede integer NOT NULL
);
 $   DROP TABLE public.sedes_formadores;
       public         postgres    false    6                       1259    325483    sedes_formadores_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sedes_formadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sedes_formadores_id_seq;
       public       postgres    false    273    6                       0    0    sedes_formadores_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.sedes_formadores_id_seq OWNED BY public.sedes_formadores.id;
            public       postgres    false    274                       1259    325485    sedes_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sedes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sedes_id_seq;
       public       postgres    false    6    272                       0    0    sedes_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sedes_id_seq OWNED BY public.sedes.id;
            public       postgres    false    275                       1259    325487    temp_ciudades    TABLE     |   CREATE TABLE public.temp_ciudades (
    id integer NOT NULL,
    ciudad character varying(200),
    id_localidad integer
);
 !   DROP TABLE public.temp_ciudades;
       public         postgres    false    6                       1259    325490    temp_ciudades_id_seq    SEQUENCE     }   CREATE SEQUENCE public.temp_ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_ciudades_id_seq;
       public       postgres    false    6    276                       0    0    temp_ciudades_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.temp_ciudades_id_seq OWNED BY public.temp_ciudades.id;
            public       postgres    false    277                       1259    325492    temp_personas    TABLE     P  CREATE TABLE public.temp_personas (
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
       public         postgres    false    6                       1259    325498    temp_personas2    TABLE     8  CREATE TABLE public.temp_personas2 (
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
       public         postgres    false    6                       1259    325504    temp_personas_id_seq    SEQUENCE     }   CREATE SEQUENCE public.temp_personas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_personas_id_seq;
       public       postgres    false    278    6                       0    0    temp_personas_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.temp_personas_id_seq OWNED BY public.temp_personas.id;
            public       postgres    false    280                       1259    325506 
   tipo_clase    TABLE     l   CREATE TABLE public.tipo_clase (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_clase;
       public         postgres    false    6                       1259    325509    tipo_clase_id_seq    SEQUENCE     z   CREATE SEQUENCE public.tipo_clase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tipo_clase_id_seq;
       public       postgres    false    281    6                       0    0    tipo_clase_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.tipo_clase_id_seq OWNED BY public.tipo_clase.id;
            public       postgres    false    282                       1259    325511 	   tipo_pago    TABLE     k   CREATE TABLE public.tipo_pago (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_pago;
       public         postgres    false    6                       1259    325514    tipo_pago_id_seq    SEQUENCE     y   CREATE SEQUENCE public.tipo_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tipo_pago_id_seq;
       public       postgres    false    283    6                       0    0    tipo_pago_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tipo_pago_id_seq OWNED BY public.tipo_pago.id;
            public       postgres    false    284                       1259    325516    tipo_pago_sede    TABLE     q   CREATE TABLE public.tipo_pago_sede (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 "   DROP TABLE public.tipo_pago_sede;
       public         postgres    false    6                       1259    325519    tipo_pago_sede_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.tipo_pago_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tipo_pago_sede_id_seq;
       public       postgres    false    6    285                       0    0    tipo_pago_sede_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.tipo_pago_sede_id_seq OWNED BY public.tipo_pago_sede.id;
            public       postgres    false    286                       1259    325521    tipo_persona    TABLE     n   CREATE TABLE public.tipo_persona (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
     DROP TABLE public.tipo_persona;
       public         postgres    false    6                        1259    325524    tipo_persona_id_seq    SEQUENCE     |   CREATE SEQUENCE public.tipo_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.tipo_persona_id_seq;
       public       postgres    false    287    6                       0    0    tipo_persona_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.tipo_persona_id_seq OWNED BY public.tipo_persona.id;
            public       postgres    false    288            !           1259    325526    tipo_persona_perfiles    TABLE     �   CREATE TABLE public.tipo_persona_perfiles (
    id integer NOT NULL,
    id_tipo_persona integer NOT NULL,
    perfil character varying(60)
);
 )   DROP TABLE public.tipo_persona_perfiles;
       public         postgres    false    6                       0    0    TABLE tipo_persona_perfiles    COMMENT     a   COMMENT ON TABLE public.tipo_persona_perfiles IS 'Perfiles a asignar cuando se crea un usuario';
            public       postgres    false    289            "           1259    325529    tipo_persona_perfiles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_persona_perfiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tipo_persona_perfiles_id_seq;
       public       postgres    false    6    289                       0    0    tipo_persona_perfiles_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.tipo_persona_perfiles_id_seq OWNED BY public.tipo_persona_perfiles.id;
            public       postgres    false    290            #           1259    325531    tipo_profesor    TABLE     o   CREATE TABLE public.tipo_profesor (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 !   DROP TABLE public.tipo_profesor;
       public         postgres    false    6            $           1259    325534    tipo_profesor_id_seq    SEQUENCE     }   CREATE SEQUENCE public.tipo_profesor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tipo_profesor_id_seq;
       public       postgres    false    6    291                       0    0    tipo_profesor_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tipo_profesor_id_seq OWNED BY public.tipo_profesor.id;
            public       postgres    false    292            %           1259    325536    tipo_titulo    TABLE     m   CREATE TABLE public.tipo_titulo (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_titulo;
       public         postgres    false    6            &           1259    325539    tipo_titulo_id_seq    SEQUENCE     {   CREATE SEQUENCE public.tipo_titulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.tipo_titulo_id_seq;
       public       postgres    false    293    6                       0    0    tipo_titulo_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.tipo_titulo_id_seq OWNED BY public.tipo_titulo.id;
            public       postgres    false    294            '           1259    325541    titulos    TABLE     �   CREATE TABLE public.titulos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(500) NOT NULL,
    id_tipo_titulo integer NOT NULL
);
    DROP TABLE public.titulos;
       public         postgres    false    6            (           1259    325547    titulos_id_seq    SEQUENCE     w   CREATE SEQUENCE public.titulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.titulos_id_seq;
       public       postgres    false    295    6                       0    0    titulos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.titulos_id_seq OWNED BY public.titulos.id;
            public       postgres    false    296            )           1259    325549    usuario_persona    TABLE     �   CREATE TABLE public.usuario_persona (
    id integer NOT NULL,
    usuario character varying(60) NOT NULL,
    id_persona integer NOT NULL
);
 #   DROP TABLE public.usuario_persona;
       public         postgres    false    6            *           1259    325552    usuario_persona_id_seq    SEQUENCE        CREATE SEQUENCE public.usuario_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_persona_id_seq;
       public       postgres    false    6    297                       0    0    usuario_persona_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_persona_id_seq OWNED BY public.usuario_persona.id;
            public       postgres    false    298            +           1259    325554    v_sedes    VIEW     �  CREATE VIEW public.v_sedes AS
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
   FROM (((public.sedes s
     LEFT JOIN public.ciudades c ON ((c.id = s.id_ciudad)))
     LEFT JOIN public.provincias pr ON ((pr.id = c.id_provincia)))
     LEFT JOIN public.paises p ON ((p.id = pr.id_pais)));
    DROP VIEW public.v_sedes;
       public       postgres    false    272    265    214    214    214    272    272    272    272    272    272    272    272    272    272    272    272    270    270    270    265    6            ,           1259    325559    v_alquiler_cabecera    VIEW     �  CREATE VIEW public.v_alquiler_cabecera AS
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
   FROM ((public.alquiler_sede_cabecera c
     LEFT JOIN public.estados_pago ep ON ((ep.id = c.id_estado_pago)))
     LEFT JOIN public.v_sedes s ON ((s.id = c.id_sede)));
 &   DROP VIEW public.v_alquiler_cabecera;
       public       postgres    false    182    254    182    299    254    182    182    299    299    182    182    299    182    299    182    299    6            -           1259    325564    v_aulas    VIEW     �  CREATE VIEW public.v_aulas AS
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
   FROM (public.aulas a
     JOIN public.v_sedes s ON ((s.id = a.id_sede)));
    DROP VIEW public.v_aulas;
       public       postgres    false    299    299    299    299    299    299    299    299    299    299    299    299    299    299    299    190    190    190    190    190    6            .           1259    325569    v_caja_comprobantes    VIEW     U  CREATE VIEW public.v_caja_comprobantes AS
 SELECT c.id,
    c.descripcion,
    c.id_tipo_comprobante,
    c.activo,
    c.dias_vencimiento,
    c.es_cancelatorio,
    c.orden,
    ctc.descripcion AS tipo_comprobante
   FROM (public.caja_comprobantes c
     LEFT JOIN public.caja_tipo_comprobantes ctc ON ((ctc.id = c.id_tipo_comprobante)));
 &   DROP VIEW public.v_caja_comprobantes;
       public       postgres    false    192    208    208    192    192    192    192    192    192    6            /           1259    325573    v_caja_operaciones    VIEW     9  CREATE VIEW public.v_caja_operaciones AS
 SELECT o.id,
    o.descripcion,
    o.id_tipo_operacion,
    o.activo,
    cto.descripcion AS tipo_operacion,
    cto.activo AS tipo_operacion_activo
   FROM (public.caja_operaciones o
     LEFT JOIN public.caja_tipo_operaciones cto ON ((cto.id = o.id_tipo_operacion)));
 %   DROP VIEW public.v_caja_operaciones;
       public       postgres    false    210    210    210    200    200    200    200    6            0           1259    325577    v_caja_movimientos    VIEW     f  CREATE VIEW public.v_caja_movimientos AS
 SELECT m.id,
    m.descripcion,
    m.id_operacion,
    m.activo,
    o.descripcion AS operacion,
    o.id_tipo_operacion,
    o.tipo_operacion,
    o.activo AS operacion_activo,
    o.tipo_operacion_activo
   FROM (public.caja_movimientos m
     LEFT JOIN public.v_caja_operaciones o ON ((o.id = m.id_operacion)));
 %   DROP VIEW public.v_caja_movimientos;
       public       postgres    false    303    198    198    198    198    303    303    303    303    303    6            1           1259    325581    v_caja_operaciones_diarias    VIEW     �  CREATE VIEW public.v_caja_operaciones_diarias AS
 SELECT cod.id,
    cod.fecha,
    cod.id_movimiento,
    cod.id_comprobante,
    cod.id_sede,
    cod.id_medio_pago,
    cod.id_cuenta,
    cod.id_subcuenta,
    cod.id_tipo_titular,
    cod.id_titular,
    cod.importe,
    cod.usuario,
    cod.signo,
    cod.fecha_operacion,
    m.descripcion AS movimiento,
    m.id_operacion,
    m.activo AS movimiento_activo,
    m.id_tipo_operacion,
    m.tipo_operacion,
    m.operacion_activo,
    m.tipo_operacion_activo,
    s.nombre AS sede,
    s.id_ciudad AS id_ciudad_sede,
    mp.descripcion AS medio_pago,
    c.descripcion AS cuenta,
    sc.descripcion AS subcuenta,
    tt.descripcion AS tipo_titular
   FROM ((((((public.caja_operaciones_diarias cod
     LEFT JOIN public.v_caja_movimientos m ON ((m.id = cod.id_movimiento)))
     LEFT JOIN public.sedes s ON ((s.id = cod.id_sede)))
     LEFT JOIN public.caja_medios_pagos mp ON ((mp.id = cod.id_medio_pago)))
     LEFT JOIN public.caja_cuentas c ON ((c.id = cod.id_cuenta)))
     LEFT JOIN public.caja_subcuentas sc ON ((sc.id = cod.id_subcuenta)))
     LEFT JOIN public.caja_tipo_titulares tt ON ((tt.id = cod.id_tipo_titular)));
 -   DROP VIEW public.v_caja_operaciones_diarias;
       public       postgres    false    201    304    304    304    304    304    304    304    304    272    272    272    212    212    206    206    201    201    201    201    201    201    201    201    201    201    201    201    201    196    196    194    194    6            2           1259    325586    v_caja_parametrizacion    VIEW     K  CREATE VIEW public.v_caja_parametrizacion AS
 SELECT cp.id,
    cp.id_comprobante,
    cp.id_medio_pago,
    cp.id_movimiento,
    cp.id_cuenta,
    cp.id_subcuenta,
    cp.id_tipo_titular,
    cp.signo,
    cp.impacta_original,
    cp.envia_sub_cta,
    c.descripcion AS comprobante,
    c.id_tipo_comprobante,
    c.tipo_comprobante,
    c.activo AS comprobante_activo,
    c.dias_vencimiento,
    c.es_cancelatorio,
    mp.descripcion AS medio_pago,
    m.descripcion AS movimiento,
    m.activo AS movimiento_activo,
    m.id_operacion,
    m.operacion,
    m.operacion_activo,
    m.id_tipo_operacion,
    m.tipo_operacion,
    m.tipo_operacion_activo,
    cu.descripcion AS cuenta,
    cu.activo AS cuenta_activo,
    su.descripcion AS subcuenta,
    su.activo AS subcuenta_activo,
    tt.descripcion AS tipo_titular,
    tt.activo AS tipo_titular_activo
   FROM ((((((public.caja_parametrizacion cp
     LEFT JOIN public.v_caja_comprobantes c ON ((c.id = cp.id_comprobante)))
     LEFT JOIN public.caja_medios_pagos mp ON ((mp.id = cp.id_medio_pago)))
     LEFT JOIN public.v_caja_movimientos m ON ((m.id = cp.id_movimiento)))
     LEFT JOIN public.caja_cuentas cu ON ((cu.id = cp.id_cuenta)))
     LEFT JOIN public.caja_subcuentas su ON ((su.id = cp.id_subcuenta)))
     LEFT JOIN public.caja_tipo_titulares tt ON ((tt.id = cp.id_tipo_titular)));
 )   DROP VIEW public.v_caja_parametrizacion;
       public       postgres    false    212    302    302    206    304    304    304    304    212    212    302    302    302    302    302    304    304    304    204    204    204    196    196    194    194    194    304    304    204    204    204    204    204    204    204    206    206    6            >           1259    349364    v_caja_subcuentas    VIEW       CREATE VIEW public.v_caja_subcuentas AS
 SELECT su.id,
    su.descripcion,
    su.id_cuenta,
    su.activo,
    c.descripcion AS cuenta,
    c.activo AS cuenta_activo
   FROM (public.caja_subcuentas su
     JOIN public.caja_cuentas c ON ((c.id = su.id_cuenta)));
 $   DROP VIEW public.v_caja_subcuentas;
       public       postgres    false    206    206    206    206    194    194    194    6            3           1259    325591 
   v_ciudades    VIEW     �  CREATE VIEW public.v_ciudades AS
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
           FROM ((public.ciudades c
             JOIN public.provincias pr ON ((c.id_provincia = pr.id)))
             JOIN public.paises p ON ((p.id = pr.id_pais)))) s;
    DROP VIEW public.v_ciudades;
       public       postgres    false    214    270    214    214    214    265    265    270    270    6            4           1259    325595    v_clases    VIEW     w  CREATE VIEW public.v_clases AS
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
    cm.anio AS anio_modulo,
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
   FROM (((((public.clases c
     LEFT JOIN public.cursadas cu ON ((cu.id = c.id_cursada)))
     LEFT JOIN public.cursadas_modulos cm ON ((cm.id = c.id_modulo)))
     LEFT JOIN public.cursos ON ((cursos.id = cu.id_curso)))
     LEFT JOIN public.aulas au ON ((au.id = c.id_aula)))
     LEFT JOIN public.tipo_clase tc ON ((tc.id = c.id_tipo_clase)));
    DROP VIEW public.v_clases;
       public       postgres    false    235    223    223    223    223    223    229    229    229    229    229    235    235    235    216    281    281    235    235    235    235    235    235    216    216    216    216    190    216    216    216    216    6            5           1259    325600 
   v_cursadas    VIEW     %  CREATE VIEW public.v_cursadas AS
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
    s.sede_descripcion,
    cu.anio
   FROM ((public.cursadas cu
     JOIN public.cursos c ON ((c.id = cu.id_curso)))
     JOIN public.v_sedes s ON ((s.id = cu.id_sede)));
    DROP VIEW public.v_cursadas;
       public       postgres    false    223    235    235    235    235    235    235    235    235    223    223    299    299    299    235    223    223    223    223    6            6           1259    325605 
   v_personas    VIEW     U  CREATE VIEW public.v_personas AS
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
   FROM (((((((((((public.personas a
     LEFT JOIN public.tipo_persona tp ON ((tp.id = a.id_tipo_persona)))
     LEFT JOIN public.datos_academicos aca ON ((a.id = aca.id_persona)))
     LEFT JOIN public.datos_actuales act ON ((a.id = act.id_persona)))
     LEFT JOIN public.datos_laborales dl ON ((a.id = dl.id_persona)))
     LEFT JOIN public.datos_salud ds ON ((a.id = ds.id_persona)))
     LEFT JOIN public.grupos_sanguineos gs ON ((ds.id_grupo_sanguineo = gs.id)))
     LEFT JOIN public.niveles_estudios ne ON ((aca.id_nivel_estudio = ne.id)))
     LEFT JOIN public.profesiones p ON ((dl.id_profesion = p.id)))
     LEFT JOIN public.ciudades ciu ON ((ciu.id = act.id_ciudad)))
     LEFT JOIN public.provincias pro ON ((pro.id = ciu.id_provincia)))
     LEFT JOIN public.paises pai ON ((pai.id = pro.id_pais)));
    DROP VIEW public.v_personas;
       public       postgres    false    263    256    256    252    252    252    252    252    252    250    250    250    250    250    250    248    248    248    248    248    248    248    248    246    246    246    268    270    270    270    287    287    248    268    265    265    246    246    246    214    214    263    214    214    187    187    187    187    187    187    187    187    6            7           1259    325610    v_cursadas_alumnos    VIEW     <  CREATE VIEW public.v_cursadas_alumnos AS
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
   FROM (((public.cursadas_alumnos ca
     JOIN public.v_cursadas c ON ((c.id = ca.id_cursada)))
     JOIN public.v_personas p ON ((p.id = ca.id_alumno)))
     JOIN public.condiciones_alumno cond ON ((cond.id = ca.id_condicion_alumno)));
 %   DROP VIEW public.v_cursadas_alumnos;
       public       postgres    false    310    221    224    224    224    224    224    224    224    309    309    309    309    309    309    309    309    309    310    310    310    310    310    310    310    310    310    6            8           1259    325615    v_cursadas_modulos    VIEW     �  CREATE VIEW public.v_cursadas_modulos AS
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
   FROM (public.cursadas_modulos cm
     JOIN public.v_cursadas c ON ((c.id = cm.id_cursada)));
 %   DROP VIEW public.v_cursadas_modulos;
       public       postgres    false    229    229    229    229    229    229    229    309    309    309    309    309    309    309    309    229    229    6            9           1259    325620    v_clases_alumnos    VIEW     H  CREATE VIEW public.v_clases_alumnos AS
 SELECT c.id AS id_clase,
    c.clase_descripcion,
    c.fecha AS fecha_clase,
    c.hora_inicio AS hora_inicio_clase,
    c.hora_fin AS hora_fin_clase,
    c.id_tipo_clase,
    c.tipo_clase,
    c.id_modulo,
    c.nombre_modulo,
    c.descripcion_modulo,
    cm.nro_modulo,
    c.mes_modulo,
    c.anio_modulo,
    c.activo AS curso_activo,
    cm.modulo_vigente,
    ca.id_alumno,
    ca.id_condicion_alumno,
    ca.nombre_alumno,
    ca.apellido_alumno,
    ca.dni,
    ca.legajo,
    ca.telefono_celular,
    ca.telefono_mensaje,
    ca.email,
    ca.modulo_inicio,
    ca.abono_matricula,
    ca.fecha_inscripcion,
    ca.id_curso,
    ca.curso,
    ca.descripcion_curso,
    cm.id_cursada,
    cm.cursada,
    cm.periodo,
    cm.id_sede,
    cm.sede,
    cm.orden AS orden_modulos
   FROM (((public.v_clases c
     JOIN public.cursadas_modulos_alumnos cma ON ((cma.id_modulo = c.id_modulo)))
     LEFT JOIN public.v_cursadas_alumnos ca ON ((ca.id = cma.id_cursadas_alumnos)))
     LEFT JOIN public.v_cursadas_modulos cm ON ((cm.id = cma.id_modulo)));
 #   DROP VIEW public.v_clases_alumnos;
       public       postgres    false    311    311    311    311    311    311    311    311    311    311    311    311    311    311    312    312    312    312    312    312    312    312    312    230    230    308    308    308    308    308    308    308    308    308    308    308    308    308    311    311    6            :           1259    325625    v_cursadas_modulos_alumnos    VIEW     �  CREATE VIEW public.v_cursadas_modulos_alumnos AS
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
    ca.id_alumno,
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
   FROM ((public.cursadas_modulos_alumnos cma
     LEFT JOIN public.v_cursadas_modulos cm ON ((cm.id = cma.id_modulo)))
     LEFT JOIN public.v_cursadas_alumnos ca ON ((ca.id = cma.id_cursadas_alumnos)));
 -   DROP VIEW public.v_cursadas_modulos_alumnos;
       public       postgres    false    311    312    312    312    312    312    312    312    312    312    312    312    312    312    311    311    311    311    311    311    311    311    311    311    311    311    311    311    311    230    230    230    230    6            ;           1259    325630    v_provincias    VIEW     �   CREATE VIEW public.v_provincias AS
 SELECT pr.id,
    pr.nombre,
    pr.id_pais,
    p.nombre AS pais,
    p.nacionalidad
   FROM (public.provincias pr
     LEFT JOIN public.paises p ON ((p.id = pr.id_pais)));
    DROP VIEW public.v_provincias;
       public       postgres    false    265    265    265    270    270    270    6            <           1259    325634    v_tipo_persona_perfiles    VIEW     �   CREATE VIEW public.v_tipo_persona_perfiles AS
 SELECT tpp.id,
    tpp.id_tipo_persona,
    tp.descripcion AS tipo_persona,
    tpp.perfil
   FROM (public.tipo_persona_perfiles tpp
     JOIN public.tipo_persona tp ON ((tp.id = tpp.id_tipo_persona)));
 *   DROP VIEW public.v_tipo_persona_perfiles;
       public       postgres    false    287    287    289    289    289    6            =           1259    325638 	   v_titulos    VIEW     �   CREATE VIEW public.v_titulos AS
 SELECT t.id,
    t.nombre,
    t.descripcion,
    t.id_tipo_titulo,
    tt.descripcion AS tipo_titulo
   FROM (public.titulos t
     LEFT JOIN public.tipo_titulo tt ON ((tt.id = t.id_tipo_titulo)));
    DROP VIEW public.v_titulos;
       public       postgres    false    293    293    295    295    295    295    6            �	           2604    325642    id    DEFAULT     t   ALTER TABLE ONLY public.alquiler_sede ALTER COLUMN id SET DEFAULT nextval('public.alquiler_sede_id_seq'::regclass);
 ?   ALTER TABLE public.alquiler_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    186    181            �	           2604    325643    id    DEFAULT     �   ALTER TABLE ONLY public.alquiler_sede_cabecera ALTER COLUMN id SET DEFAULT nextval('public.alquiler_sede_cabecera_id_seq'::regclass);
 H   ALTER TABLE public.alquiler_sede_cabecera ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    183    182            �	           2604    325644    id    DEFAULT     �   ALTER TABLE ONLY public.alquiler_sede_detalle ALTER COLUMN id SET DEFAULT nextval('public.alquiler_sede_detalle_id_seq'::regclass);
 G   ALTER TABLE public.alquiler_sede_detalle ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    185    184            �	           2604    325645    id    DEFAULT     d   ALTER TABLE ONLY public.aulas ALTER COLUMN id SET DEFAULT nextval('public.aulas_id_seq'::regclass);
 7   ALTER TABLE public.aulas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    191    190            �	           2604    325646    id    DEFAULT     |   ALTER TABLE ONLY public.caja_comprobantes ALTER COLUMN id SET DEFAULT nextval('public.caja_comprobantes_id_seq'::regclass);
 C   ALTER TABLE public.caja_comprobantes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    193    192            �	           2604    325647    id    DEFAULT     r   ALTER TABLE ONLY public.caja_cuentas ALTER COLUMN id SET DEFAULT nextval('public.caja_cuentas_id_seq'::regclass);
 >   ALTER TABLE public.caja_cuentas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    195    194            �	           2604    325648    id    DEFAULT     {   ALTER TABLE ONLY public.caja_medios_pagos ALTER COLUMN id SET DEFAULT nextval('public.caja_mediospagos_id_seq'::regclass);
 C   ALTER TABLE public.caja_medios_pagos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    196            �	           2604    325649    id    DEFAULT     z   ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);
 B   ALTER TABLE public.caja_movimientos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    198            �	           2604    325650    id    DEFAULT     z   ALTER TABLE ONLY public.caja_operaciones ALTER COLUMN id SET DEFAULT nextval('public.caja_operaciones_id_seq'::regclass);
 B   ALTER TABLE public.caja_operaciones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    203    200            �	           2604    325651    id    DEFAULT     �   ALTER TABLE ONLY public.caja_operaciones_diarias ALTER COLUMN id SET DEFAULT nextval('public.caja_operaciones_diarias_id_seq'::regclass);
 J   ALTER TABLE public.caja_operaciones_diarias ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    201            �	           2604    325652    id    DEFAULT     �   ALTER TABLE ONLY public.caja_parametrizacion ALTER COLUMN id SET DEFAULT nextval('public.caja_parametrizacion_id_seq'::regclass);
 F   ALTER TABLE public.caja_parametrizacion ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    205    204            �	           2604    325653    id    DEFAULT     x   ALTER TABLE ONLY public.caja_subcuentas ALTER COLUMN id SET DEFAULT nextval('public.caja_subcuentas_id_seq'::regclass);
 A   ALTER TABLE public.caja_subcuentas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    206            �	           2604    325654    id    DEFAULT     �   ALTER TABLE ONLY public.caja_tipo_comprobantes ALTER COLUMN id SET DEFAULT nextval('public.caja_tipo_comprobantes_id_seq'::regclass);
 H   ALTER TABLE public.caja_tipo_comprobantes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    209    208            �	           2604    325655    id    DEFAULT     �   ALTER TABLE ONLY public.caja_tipo_operaciones ALTER COLUMN id SET DEFAULT nextval('public.caja_tipo_operaciones_id_seq'::regclass);
 G   ALTER TABLE public.caja_tipo_operaciones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    210            �	           2604    325656    id    DEFAULT     �   ALTER TABLE ONLY public.caja_tipo_titulares ALTER COLUMN id SET DEFAULT nextval('public.caja_tipo_titulares_id_seq'::regclass);
 E   ALTER TABLE public.caja_tipo_titulares ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    213    212            �	           2604    325657    id    DEFAULT     j   ALTER TABLE ONLY public.ciudades ALTER COLUMN id SET DEFAULT nextval('public.ciudades_id_seq'::regclass);
 :   ALTER TABLE public.ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    215    214            �	           2604    325658    id    DEFAULT     f   ALTER TABLE ONLY public.clases ALTER COLUMN id SET DEFAULT nextval('public.clases_id_seq'::regclass);
 8   ALTER TABLE public.clases ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    218    216            �	           2604    325659    id    DEFAULT     |   ALTER TABLE ONLY public.clases_profesores ALTER COLUMN id SET DEFAULT nextval('public.clases_profesores_id_seq'::regclass);
 C   ALTER TABLE public.clases_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    220    219            �	           2604    325660    id    DEFAULT     ~   ALTER TABLE ONLY public.condiciones_alumno ALTER COLUMN id SET DEFAULT nextval('public.condiciones_alumno_id_seq'::regclass);
 D   ALTER TABLE public.condiciones_alumno ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    221            �	           2604    325661    id    DEFAULT     j   ALTER TABLE ONLY public.cursadas ALTER COLUMN id SET DEFAULT nextval('public.cursadas_id_seq'::regclass);
 :   ALTER TABLE public.cursadas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    228    223            �	           2604    325662    id    DEFAULT     z   ALTER TABLE ONLY public.cursadas_alumnos ALTER COLUMN id SET DEFAULT nextval('public.cursadas_alumnos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    225    224            �	           2604    325663    id    DEFAULT     x   ALTER TABLE ONLY public.cursadas_cuotas ALTER COLUMN id SET DEFAULT nextval('public.cursadas_cuotas_id_seq'::regclass);
 A   ALTER TABLE public.cursadas_cuotas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    227    226            �	           2604    325664    id    DEFAULT     z   ALTER TABLE ONLY public.cursadas_modulos ALTER COLUMN id SET DEFAULT nextval('public.cursadas_modulos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    232    229            �	           2604    325665    id    DEFAULT     �   ALTER TABLE ONLY public.cursadas_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('public.cursadas_modulos_alumnos_id_seq'::regclass);
 J   ALTER TABLE public.cursadas_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    231    230            �	           2604    325666    id    DEFAULT     �   ALTER TABLE ONLY public.cursadas_profesores ALTER COLUMN id SET DEFAULT nextval('public.cursadas_profesores_id_seq'::regclass);
 E   ALTER TABLE public.cursadas_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    234    233            �	           2604    325667    id    DEFAULT     f   ALTER TABLE ONLY public.cursos ALTER COLUMN id SET DEFAULT nextval('public.cursos_id_seq'::regclass);
 8   ALTER TABLE public.cursos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    238    235            �	           2604    325668    id    DEFAULT     �   ALTER TABLE ONLY public.cursos_correlatividad ALTER COLUMN id SET DEFAULT nextval('public.cursos_correlatividad_id_seq'::regclass);
 G   ALTER TABLE public.cursos_correlatividad ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    237    236            �	           2604    325669    id    DEFAULT     v   ALTER TABLE ONLY public.cursos_modulos ALTER COLUMN id SET DEFAULT nextval('public.cursos_modulos_id_seq'::regclass);
 @   ALTER TABLE public.cursos_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    242    239            �	           2604    325670    id    DEFAULT     �   ALTER TABLE ONLY public.cursos_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('public.cursos_modulos_alumnos_id_seq'::regclass);
 H   ALTER TABLE public.cursos_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    240            �	           2604    325671    id    DEFAULT     v   ALTER TABLE ONLY public.cursos_titulos ALTER COLUMN id SET DEFAULT nextval('public.cursos_titulos_id_seq'::regclass);
 @   ALTER TABLE public.cursos_titulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    244    243            �	           2604    325672    id    DEFAULT     z   ALTER TABLE ONLY public.datos_academicos ALTER COLUMN id SET DEFAULT nextval('public.datos_academicos_id_seq'::regclass);
 B   ALTER TABLE public.datos_academicos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    247    246            �	           2604    325673    id    DEFAULT     v   ALTER TABLE ONLY public.datos_actuales ALTER COLUMN id SET DEFAULT nextval('public.datos_actuales_id_seq'::regclass);
 @   ALTER TABLE public.datos_actuales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    249    248            �	           2604    325674    id    DEFAULT     x   ALTER TABLE ONLY public.datos_laborales ALTER COLUMN id SET DEFAULT nextval('public.datos_laborales_id_seq'::regclass);
 A   ALTER TABLE public.datos_laborales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    251    250            �	           2604    325675    id    DEFAULT     p   ALTER TABLE ONLY public.datos_salud ALTER COLUMN id SET DEFAULT nextval('public.datos_salud_id_seq'::regclass);
 =   ALTER TABLE public.datos_salud ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    253    252            �	           2604    325676    id    DEFAULT     r   ALTER TABLE ONLY public.estados_pago ALTER COLUMN id SET DEFAULT nextval('public.estados_pago_id_seq'::regclass);
 >   ALTER TABLE public.estados_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    255    254            �	           2604    325677    id    DEFAULT     |   ALTER TABLE ONLY public.grupos_sanguineos ALTER COLUMN id SET DEFAULT nextval('public.grupos_sanguineos_id_seq'::regclass);
 C   ALTER TABLE public.grupos_sanguineos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    257    256            �	           2604    325678    id    DEFAULT     �   ALTER TABLE ONLY public.inscripciones_modulos ALTER COLUMN id SET DEFAULT nextval('public.inscripciones_modulos_id_seq'::regclass);
 G   ALTER TABLE public.inscripciones_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    260    259            �	           2604    325679    id    DEFAULT     h   ALTER TABLE ONLY public.modulos ALTER COLUMN id SET DEFAULT nextval('public.modulos_id_seq'::regclass);
 9   ALTER TABLE public.modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    262    261             
           2604    325680    id    DEFAULT     z   ALTER TABLE ONLY public.niveles_estudios ALTER COLUMN id SET DEFAULT nextval('public.niveles_estudios_id_seq'::regclass);
 B   ALTER TABLE public.niveles_estudios ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    264    263            
           2604    325681    id    DEFAULT     f   ALTER TABLE ONLY public.paises ALTER COLUMN id SET DEFAULT nextval('public.paises_id_seq'::regclass);
 8   ALTER TABLE public.paises ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    266    265            �	           2604    325682    id    DEFAULT     i   ALTER TABLE ONLY public.personas ALTER COLUMN id SET DEFAULT nextval('public.alumnos_id_seq'::regclass);
 :   ALTER TABLE public.personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    188    187            �	           2604    325683    legajo    DEFAULT     q   ALTER TABLE ONLY public.personas ALTER COLUMN legajo SET DEFAULT nextval('public.alumnos_legajo_seq'::regclass);
 >   ALTER TABLE public.personas ALTER COLUMN legajo DROP DEFAULT;
       public       postgres    false    189    187            
           2604    325684    id    DEFAULT     p   ALTER TABLE ONLY public.profesiones ALTER COLUMN id SET DEFAULT nextval('public.profesiones_id_seq'::regclass);
 =   ALTER TABLE public.profesiones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    269    268            
           2604    325685    id    DEFAULT     n   ALTER TABLE ONLY public.provincias ALTER COLUMN id SET DEFAULT nextval('public.provincias_id_seq'::regclass);
 <   ALTER TABLE public.provincias ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    271    270            
           2604    325686    id    DEFAULT     d   ALTER TABLE ONLY public.sedes ALTER COLUMN id SET DEFAULT nextval('public.sedes_id_seq'::regclass);
 7   ALTER TABLE public.sedes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    275    272            
           2604    325687    id    DEFAULT     z   ALTER TABLE ONLY public.sedes_formadores ALTER COLUMN id SET DEFAULT nextval('public.sedes_formadores_id_seq'::regclass);
 B   ALTER TABLE public.sedes_formadores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    274    273            
           2604    325688    id    DEFAULT     t   ALTER TABLE ONLY public.temp_ciudades ALTER COLUMN id SET DEFAULT nextval('public.temp_ciudades_id_seq'::regclass);
 ?   ALTER TABLE public.temp_ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    277    276            
           2604    325689    id    DEFAULT     t   ALTER TABLE ONLY public.temp_personas ALTER COLUMN id SET DEFAULT nextval('public.temp_personas_id_seq'::regclass);
 ?   ALTER TABLE public.temp_personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    280    278            	
           2604    325690    id    DEFAULT     n   ALTER TABLE ONLY public.tipo_clase ALTER COLUMN id SET DEFAULT nextval('public.tipo_clase_id_seq'::regclass);
 <   ALTER TABLE public.tipo_clase ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    282    281            

           2604    325691    id    DEFAULT     l   ALTER TABLE ONLY public.tipo_pago ALTER COLUMN id SET DEFAULT nextval('public.tipo_pago_id_seq'::regclass);
 ;   ALTER TABLE public.tipo_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    284    283            
           2604    325692    id    DEFAULT     v   ALTER TABLE ONLY public.tipo_pago_sede ALTER COLUMN id SET DEFAULT nextval('public.tipo_pago_sede_id_seq'::regclass);
 @   ALTER TABLE public.tipo_pago_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    286    285            
           2604    325693    id    DEFAULT     r   ALTER TABLE ONLY public.tipo_persona ALTER COLUMN id SET DEFAULT nextval('public.tipo_persona_id_seq'::regclass);
 >   ALTER TABLE public.tipo_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    288    287            
           2604    325694    id    DEFAULT     �   ALTER TABLE ONLY public.tipo_persona_perfiles ALTER COLUMN id SET DEFAULT nextval('public.tipo_persona_perfiles_id_seq'::regclass);
 G   ALTER TABLE public.tipo_persona_perfiles ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    290    289            
           2604    325695    id    DEFAULT     t   ALTER TABLE ONLY public.tipo_profesor ALTER COLUMN id SET DEFAULT nextval('public.tipo_profesor_id_seq'::regclass);
 ?   ALTER TABLE public.tipo_profesor ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    292    291            
           2604    325696    id    DEFAULT     p   ALTER TABLE ONLY public.tipo_titulo ALTER COLUMN id SET DEFAULT nextval('public.tipo_titulo_id_seq'::regclass);
 =   ALTER TABLE public.tipo_titulo ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    294    293            
           2604    325697    id    DEFAULT     h   ALTER TABLE ONLY public.titulos ALTER COLUMN id SET DEFAULT nextval('public.titulos_id_seq'::regclass);
 9   ALTER TABLE public.titulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    296    295            
           2604    325698    id    DEFAULT     x   ALTER TABLE ONLY public.usuario_persona ALTER COLUMN id SET DEFAULT nextval('public.usuario_persona_id_seq'::regclass);
 A   ALTER TABLE public.usuario_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    298    297            _          0    325209    alquiler_sede 
   TABLE DATA                     public       postgres    false    181   ��      `          0    325213    alquiler_sede_cabecera 
   TABLE DATA                     public       postgres    false    182   -�                 0    0    alquiler_sede_cabecera_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.alquiler_sede_cabecera_id_seq', 2, true);
            public       postgres    false    183            b          0    325220    alquiler_sede_detalle 
   TABLE DATA                     public       postgres    false    184   G�                 0    0    alquiler_sede_detalle_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.alquiler_sede_detalle_id_seq', 3, true);
            public       postgres    false    185                       0    0    alquiler_sede_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.alquiler_sede_id_seq', 8, true);
            public       postgres    false    186                       0    0    alumnos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.alumnos_id_seq', 9, true);
            public       postgres    false    188                       0    0    alumnos_legajo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.alumnos_legajo_seq', 6, true);
            public       postgres    false    189            h          0    325236    aulas 
   TABLE DATA                     public       postgres    false    190   a�                 0    0    aulas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.aulas_id_seq', 4, true);
            public       postgres    false    191            j          0    325241    caja_comprobantes 
   TABLE DATA                     public       postgres    false    192   {�                 0    0    caja_comprobantes_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.caja_comprobantes_id_seq', 6, true);
            public       postgres    false    193            l          0    325249    caja_cuentas 
   TABLE DATA                     public       postgres    false    194   1�                  0    0    caja_cuentas_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.caja_cuentas_id_seq', 10, true);
            public       postgres    false    195            n          0    325254    caja_medios_pagos 
   TABLE DATA                     public       postgres    false    196   �      !           0    0    caja_mediospagos_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.caja_mediospagos_id_seq', 7, true);
            public       postgres    false    197            p          0    325259    caja_movimientos 
   TABLE DATA                     public       postgres    false    198         "           0    0    caja_movimientos_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 20, true);
            public       postgres    false    199            r          0    325264    caja_operaciones 
   TABLE DATA                     public       postgres    false    200   �      s          0    325267    caja_operaciones_diarias 
   TABLE DATA                     public       postgres    false    201   �      #           0    0    caja_operaciones_diarias_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.caja_operaciones_diarias_id_seq', 1, false);
            public       postgres    false    202            $           0    0    caja_operaciones_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.caja_operaciones_id_seq', 8, true);
            public       postgres    false    203            v          0    325275    caja_parametrizacion 
   TABLE DATA                     public       postgres    false    204   ��      %           0    0    caja_parametrizacion_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.caja_parametrizacion_id_seq', 1, false);
            public       postgres    false    205            x          0    325281    caja_subcuentas 
   TABLE DATA                     public       postgres    false    206   �      &           0    0    caja_subcuentas_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.caja_subcuentas_id_seq', 1, false);
            public       postgres    false    207            z          0    325286    caja_tipo_comprobantes 
   TABLE DATA                     public       postgres    false    208   �      '           0    0    caja_tipo_comprobantes_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.caja_tipo_comprobantes_id_seq', 8, true);
            public       postgres    false    209            |          0    325291    caja_tipo_operaciones 
   TABLE DATA                     public       postgres    false    210   ��      (           0    0    caja_tipo_operaciones_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.caja_tipo_operaciones_id_seq', 9, true);
            public       postgres    false    211            ~          0    325296    caja_tipo_titulares 
   TABLE DATA                     public       postgres    false    212   u�      )           0    0    caja_tipo_titulares_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.caja_tipo_titulares_id_seq', 6, true);
            public       postgres    false    213            �          0    325301    ciudades 
   TABLE DATA                     public       postgres    false    214   �      *           0    0    ciudades_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.ciudades_id_seq', 1, false);
            public       postgres    false    215            �          0    325306    clases 
   TABLE DATA                     public       postgres    false    216   `      �          0    325312    clases_asistencia 
   TABLE DATA                     public       postgres    false    217   9      +           0    0    clases_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.clases_id_seq', 7, true);
            public       postgres    false    218            �          0    325317    clases_profesores 
   TABLE DATA                     public       postgres    false    219   S      ,           0    0    clases_profesores_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.clases_profesores_id_seq', 1, false);
            public       postgres    false    220            �          0    325322    condiciones_alumno 
   TABLE DATA                     public       postgres    false    221   m      -           0    0    condiciones_alumno_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.condiciones_alumno_id_seq', 3, true);
            public       postgres    false    222            �          0    325327    cursadas 
   TABLE DATA                     public       postgres    false    223   �      �          0    325330    cursadas_alumnos 
   TABLE DATA                     public       postgres    false    224   �       .           0    0    cursadas_alumnos_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.cursadas_alumnos_id_seq', 16, true);
            public       postgres    false    225            �          0    325338    cursadas_cuotas 
   TABLE DATA                     public       postgres    false    226   �       /           0    0    cursadas_cuotas_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.cursadas_cuotas_id_seq', 1, false);
            public       postgres    false    227            0           0    0    cursadas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.cursadas_id_seq', 12, true);
            public       postgres    false    228            �          0    325346    cursadas_modulos 
   TABLE DATA                     public       postgres    false    229   !      �          0    325352    cursadas_modulos_alumnos 
   TABLE DATA                     public       postgres    false    230   #      1           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.cursadas_modulos_alumnos_id_seq', 60, true);
            public       postgres    false    231            2           0    0    cursadas_modulos_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.cursadas_modulos_id_seq', 72, true);
            public       postgres    false    232            �          0    325359    cursadas_profesores 
   TABLE DATA                     public       postgres    false    233   �#      3           0    0    cursadas_profesores_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.cursadas_profesores_id_seq', 3, true);
            public       postgres    false    234            �          0    325364    cursos 
   TABLE DATA                     public       postgres    false    235   �#      �          0    325369    cursos_correlatividad 
   TABLE DATA                     public       postgres    false    236   E$      4           0    0    cursos_correlatividad_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.cursos_correlatividad_id_seq', 3, true);
            public       postgres    false    237            5           0    0    cursos_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.cursos_id_seq', 2, true);
            public       postgres    false    238            �          0    325376    cursos_modulos 
   TABLE DATA                     public       postgres    false    239   �$      �          0    325382    cursos_modulos_alumnos 
   TABLE DATA                     public       postgres    false    240   ~%      6           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.cursos_modulos_alumnos_id_seq', 13, true);
            public       postgres    false    241            7           0    0    cursos_modulos_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.cursos_modulos_id_seq', 10, true);
            public       postgres    false    242            �          0    325389    cursos_titulos 
   TABLE DATA                     public       postgres    false    243   ?&      8           0    0    cursos_titulos_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.cursos_titulos_id_seq', 1, true);
            public       postgres    false    244            �          0    325394    databasechangeloglock 
   TABLE DATA                     public       postgres    false    245   �&      �          0    325397    datos_academicos 
   TABLE DATA                     public       postgres    false    246   �&      9           0    0    datos_academicos_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.datos_academicos_id_seq', 538, true);
            public       postgres    false    247            �          0    325402    datos_actuales 
   TABLE DATA                     public       postgres    false    248   �?      :           0    0    datos_actuales_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.datos_actuales_id_seq', 4570, true);
            public       postgres    false    249            �          0    325410    datos_laborales 
   TABLE DATA                     public       postgres    false    250   N�      ;           0    0    datos_laborales_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.datos_laborales_id_seq', 2216, true);
            public       postgres    false    251            �          0    325418    datos_salud 
   TABLE DATA                     public       postgres    false    252   ��      <           0    0    datos_salud_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.datos_salud_id_seq', 539, true);
            public       postgres    false    253            �          0    325423    estados_pago 
   TABLE DATA                     public       postgres    false    254   Q�      =           0    0    estados_pago_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.estados_pago_id_seq', 1, false);
            public       postgres    false    255            �          0    325428    grupos_sanguineos 
   TABLE DATA                     public       postgres    false    256   ��      >           0    0    grupos_sanguineos_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.grupos_sanguineos_id_seq', 16, true);
            public       postgres    false    257            �          0    325433    ids 
   TABLE DATA                     public       postgres    false    258   \�      �          0    325436    inscripciones_modulos 
   TABLE DATA                     public       postgres    false    259   ��      ?           0    0    inscripciones_modulos_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.inscripciones_modulos_id_seq', 1, false);
            public       postgres    false    260            �          0    325441    modulos 
   TABLE DATA                     public       postgres    false    261   �      @           0    0    modulos_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.modulos_id_seq', 1, false);
            public       postgres    false    262            �          0    325447    niveles_estudios 
   TABLE DATA                     public       postgres    false    263   2�      A           0    0    niveles_estudios_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.niveles_estudios_id_seq', 1, false);
            public       postgres    false    264            �          0    325452    paises 
   TABLE DATA                     public       postgres    false    265   ��      B           0    0    paises_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.paises_id_seq', 1, false);
            public       postgres    false    266            �          0    325457    perfiles 
   TABLE DATA                     public       postgres    false    267    �      e          0    325228    personas 
   TABLE DATA                     public       postgres    false    187   I�      �          0    325460    profesiones 
   TABLE DATA                     public       postgres    false    268         C           0    0    profesiones_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.profesiones_id_seq', 1, false);
            public       postgres    false    269            �          0    325465 
   provincias 
   TABLE DATA                     public       postgres    false    270   4      D           0    0    provincias_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.provincias_id_seq', 1, false);
            public       postgres    false    271            �          0    325473    sedes 
   TABLE DATA                     public       postgres    false    272   �      �          0    325480    sedes_formadores 
   TABLE DATA                     public       postgres    false    273   �      E           0    0    sedes_formadores_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.sedes_formadores_id_seq', 5, true);
            public       postgres    false    274            F           0    0    sedes_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sedes_id_seq', 8, true);
            public       postgres    false    275            �          0    325487    temp_ciudades 
   TABLE DATA                     public       postgres    false    276   �      G           0    0    temp_ciudades_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.temp_ciudades_id_seq', 43, true);
            public       postgres    false    277            �          0    325492    temp_personas 
   TABLE DATA                     public       postgres    false    278   �      �          0    325498    temp_personas2 
   TABLE DATA                     public       postgres    false    279   ��      H           0    0    temp_personas_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.temp_personas_id_seq', 654, true);
            public       postgres    false    280            �          0    325506 
   tipo_clase 
   TABLE DATA                     public       postgres    false    281   ��      I           0    0    tipo_clase_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tipo_clase_id_seq', 3, true);
            public       postgres    false    282            �          0    325511 	   tipo_pago 
   TABLE DATA                     public       postgres    false    283   �      J           0    0    tipo_pago_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.tipo_pago_id_seq', 5, true);
            public       postgres    false    284            �          0    325516    tipo_pago_sede 
   TABLE DATA                     public       postgres    false    285   ��      K           0    0    tipo_pago_sede_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.tipo_pago_sede_id_seq', 2, true);
            public       postgres    false    286            �          0    325521    tipo_persona 
   TABLE DATA                     public       postgres    false    287   ��      L           0    0    tipo_persona_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.tipo_persona_id_seq', 1, false);
            public       postgres    false    288            �          0    325526    tipo_persona_perfiles 
   TABLE DATA                     public       postgres    false    289   \�      M           0    0    tipo_persona_perfiles_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tipo_persona_perfiles_id_seq', 1, true);
            public       postgres    false    290            �          0    325531    tipo_profesor 
   TABLE DATA                     public       postgres    false    291   ��      N           0    0    tipo_profesor_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.tipo_profesor_id_seq', 3, true);
            public       postgres    false    292            �          0    325536    tipo_titulo 
   TABLE DATA                     public       postgres    false    293   �      O           0    0    tipo_titulo_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.tipo_titulo_id_seq', 2, true);
            public       postgres    false    294            �          0    325541    titulos 
   TABLE DATA                     public       postgres    false    295   ��      P           0    0    titulos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.titulos_id_seq', 1, true);
            public       postgres    false    296            �          0    325549    usuario_persona 
   TABLE DATA                     public       postgres    false    297   �      Q           0    0    usuario_persona_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.usuario_persona_id_seq', 1, false);
            public       postgres    false    298            u
           2606    325711    niveles_estudios_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.niveles_estudios
    ADD CONSTRAINT niveles_estudios_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.niveles_estudios DROP CONSTRAINT niveles_estudios_pkey;
       public         postgres    false    263    263            
           2606    325713    pk_alquiler_sede 
   CONSTRAINT     \   ALTER TABLE ONLY public.alquiler_sede
    ADD CONSTRAINT pk_alquiler_sede PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.alquiler_sede DROP CONSTRAINT pk_alquiler_sede;
       public         postgres    false    181    181            
           2606    325715    pk_alquiler_sede_cabecera 
   CONSTRAINT     n   ALTER TABLE ONLY public.alquiler_sede_cabecera
    ADD CONSTRAINT pk_alquiler_sede_cabecera PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT pk_alquiler_sede_cabecera;
       public         postgres    false    182    182            
           2606    325717    pk_alquiler_sede_detalle 
   CONSTRAINT     l   ALTER TABLE ONLY public.alquiler_sede_detalle
    ADD CONSTRAINT pk_alquiler_sede_detalle PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT pk_alquiler_sede_detalle;
       public         postgres    false    184    184            
           2606    325719 
   pk_alumnos 
   CONSTRAINT     Q   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT pk_alumnos PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.personas DROP CONSTRAINT pk_alumnos;
       public         postgres    false    187    187            
           2606    325721    pk_aulas 
   CONSTRAINT     L   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT pk_aulas PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT pk_aulas;
       public         postgres    false    190    190            !
           2606    325723    pk_caja_comprobantes 
   CONSTRAINT     d   ALTER TABLE ONLY public.caja_comprobantes
    ADD CONSTRAINT pk_caja_comprobantes PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.caja_comprobantes DROP CONSTRAINT pk_caja_comprobantes;
       public         postgres    false    192    192            #
           2606    325725    pk_caja_cuentas 
   CONSTRAINT     Z   ALTER TABLE ONLY public.caja_cuentas
    ADD CONSTRAINT pk_caja_cuentas PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.caja_cuentas DROP CONSTRAINT pk_caja_cuentas;
       public         postgres    false    194    194            '
           2606    325727    pk_caja_mediospagos 
   CONSTRAINT     c   ALTER TABLE ONLY public.caja_medios_pagos
    ADD CONSTRAINT pk_caja_mediospagos PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.caja_medios_pagos DROP CONSTRAINT pk_caja_mediospagos;
       public         postgres    false    196    196            )
           2606    325729    pk_caja_movimientos 
   CONSTRAINT     b   ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT pk_caja_movimientos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.caja_movimientos DROP CONSTRAINT pk_caja_movimientos;
       public         postgres    false    198    198            +
           2606    325731    pk_caja_operaciones 
   CONSTRAINT     b   ALTER TABLE ONLY public.caja_operaciones
    ADD CONSTRAINT pk_caja_operaciones PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.caja_operaciones DROP CONSTRAINT pk_caja_operaciones;
       public         postgres    false    200    200            -
           2606    325733    pk_caja_operaciones_diarias 
   CONSTRAINT     r   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT pk_caja_operaciones_diarias PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT pk_caja_operaciones_diarias;
       public         postgres    false    201    201            /
           2606    325735    pk_caja_parametrizacion 
   CONSTRAINT     j   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT pk_caja_parametrizacion PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT pk_caja_parametrizacion;
       public         postgres    false    204    204            1
           2606    325737    pk_caja_subcuentas 
   CONSTRAINT     `   ALTER TABLE ONLY public.caja_subcuentas
    ADD CONSTRAINT pk_caja_subcuentas PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.caja_subcuentas DROP CONSTRAINT pk_caja_subcuentas;
       public         postgres    false    206    206            3
           2606    325739    pk_caja_tipo_comprobantes 
   CONSTRAINT     n   ALTER TABLE ONLY public.caja_tipo_comprobantes
    ADD CONSTRAINT pk_caja_tipo_comprobantes PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.caja_tipo_comprobantes DROP CONSTRAINT pk_caja_tipo_comprobantes;
       public         postgres    false    208    208            5
           2606    325741    pk_caja_tipo_operaciones 
   CONSTRAINT     l   ALTER TABLE ONLY public.caja_tipo_operaciones
    ADD CONSTRAINT pk_caja_tipo_operaciones PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.caja_tipo_operaciones DROP CONSTRAINT pk_caja_tipo_operaciones;
       public         postgres    false    210    210            7
           2606    325743    pk_caja_tipo_titulares 
   CONSTRAINT     h   ALTER TABLE ONLY public.caja_tipo_titulares
    ADD CONSTRAINT pk_caja_tipo_titulares PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.caja_tipo_titulares DROP CONSTRAINT pk_caja_tipo_titulares;
       public         postgres    false    212    212            9
           2606    325745 	   pk_ciudad 
   CONSTRAINT     P   ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT pk_ciudad PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT pk_ciudad;
       public         postgres    false    214    214            ;
           2606    325747 	   pk_clases 
   CONSTRAINT     N   ALTER TABLE ONLY public.clases
    ADD CONSTRAINT pk_clases PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.clases DROP CONSTRAINT pk_clases;
       public         postgres    false    216    216            =
           2606    325749    pk_clases_asistencia 
   CONSTRAINT     d   ALTER TABLE ONLY public.clases_asistencia
    ADD CONSTRAINT pk_clases_asistencia PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT pk_clases_asistencia;
       public         postgres    false    217    217            ?
           2606    325751    pk_clases_profesores 
   CONSTRAINT     d   ALTER TABLE ONLY public.clases_profesores
    ADD CONSTRAINT pk_clases_profesores PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT pk_clases_profesores;
       public         postgres    false    219    219            A
           2606    325753    pk_condiciones_alumno 
   CONSTRAINT     f   ALTER TABLE ONLY public.condiciones_alumno
    ADD CONSTRAINT pk_condiciones_alumno PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.condiciones_alumno DROP CONSTRAINT pk_condiciones_alumno;
       public         postgres    false    221    221            C
           2606    325755    pk_cursadas 
   CONSTRAINT     R   ALTER TABLE ONLY public.cursadas
    ADD CONSTRAINT pk_cursadas PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT pk_cursadas;
       public         postgres    false    223    223            E
           2606    325757    pk_cursadas_alumnos 
   CONSTRAINT     b   ALTER TABLE ONLY public.cursadas_alumnos
    ADD CONSTRAINT pk_cursadas_alumnos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT pk_cursadas_alumnos;
       public         postgres    false    224    224            I
           2606    325759    pk_cursadas_cuotas 
   CONSTRAINT     `   ALTER TABLE ONLY public.cursadas_cuotas
    ADD CONSTRAINT pk_cursadas_cuotas PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT pk_cursadas_cuotas;
       public         postgres    false    226    226            K
           2606    325761    pk_cursadas_modulos 
   CONSTRAINT     b   ALTER TABLE ONLY public.cursadas_modulos
    ADD CONSTRAINT pk_cursadas_modulos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT pk_cursadas_modulos;
       public         postgres    false    229    229            O
           2606    325763    pk_cursadas_modulos_alumnos 
   CONSTRAINT     r   ALTER TABLE ONLY public.cursadas_modulos_alumnos
    ADD CONSTRAINT pk_cursadas_modulos_alumnos PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.cursadas_modulos_alumnos DROP CONSTRAINT pk_cursadas_modulos_alumnos;
       public         postgres    false    230    230            Q
           2606    325765    pk_cursadas_profesores 
   CONSTRAINT     h   ALTER TABLE ONLY public.cursadas_profesores
    ADD CONSTRAINT pk_cursadas_profesores PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT pk_cursadas_profesores;
       public         postgres    false    233    233            S
           2606    325767 	   pk_cursos 
   CONSTRAINT     N   ALTER TABLE ONLY public.cursos
    ADD CONSTRAINT pk_cursos PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.cursos DROP CONSTRAINT pk_cursos;
       public         postgres    false    235    235            U
           2606    325769    pk_cursos_correlatividad 
   CONSTRAINT     l   ALTER TABLE ONLY public.cursos_correlatividad
    ADD CONSTRAINT pk_cursos_correlatividad PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT pk_cursos_correlatividad;
       public         postgres    false    236    236            Y
           2606    325771    pk_cursos_modulos 
   CONSTRAINT     ^   ALTER TABLE ONLY public.cursos_modulos
    ADD CONSTRAINT pk_cursos_modulos PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT pk_cursos_modulos;
       public         postgres    false    239    239            ]
           2606    325773    pk_cursos_modulos_alumnos 
   CONSTRAINT     n   ALTER TABLE ONLY public.cursos_modulos_alumnos
    ADD CONSTRAINT pk_cursos_modulos_alumnos PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.cursos_modulos_alumnos DROP CONSTRAINT pk_cursos_modulos_alumnos;
       public         postgres    false    240    240            _
           2606    325775    pk_cursos_titulos 
   CONSTRAINT     ^   ALTER TABLE ONLY public.cursos_titulos
    ADD CONSTRAINT pk_cursos_titulos PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT pk_cursos_titulos;
       public         postgres    false    243    243            c
           2606    325777    pk_databasechangeloglock 
   CONSTRAINT     l   ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.databasechangeloglock DROP CONSTRAINT pk_databasechangeloglock;
       public         postgres    false    245    245            e
           2606    325779    pk_datos_academicos 
   CONSTRAINT     b   ALTER TABLE ONLY public.datos_academicos
    ADD CONSTRAINT pk_datos_academicos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT pk_datos_academicos;
       public         postgres    false    246    246            g
           2606    325781    pk_datos_actuales 
   CONSTRAINT     ^   ALTER TABLE ONLY public.datos_actuales
    ADD CONSTRAINT pk_datos_actuales PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT pk_datos_actuales;
       public         postgres    false    248    248            i
           2606    325783    pk_datos_laborales 
   CONSTRAINT     `   ALTER TABLE ONLY public.datos_laborales
    ADD CONSTRAINT pk_datos_laborales PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT pk_datos_laborales;
       public         postgres    false    250    250            k
           2606    325785    pk_datos_salud 
   CONSTRAINT     X   ALTER TABLE ONLY public.datos_salud
    ADD CONSTRAINT pk_datos_salud PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT pk_datos_salud;
       public         postgres    false    252    252            m
           2606    325787    pk_estados_pago 
   CONSTRAINT     Z   ALTER TABLE ONLY public.estados_pago
    ADD CONSTRAINT pk_estados_pago PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.estados_pago DROP CONSTRAINT pk_estados_pago;
       public         postgres    false    254    254            o
           2606    325789    pk_grupos_sanguineos 
   CONSTRAINT     d   ALTER TABLE ONLY public.grupos_sanguineos
    ADD CONSTRAINT pk_grupos_sanguineos PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.grupos_sanguineos DROP CONSTRAINT pk_grupos_sanguineos;
       public         postgres    false    256    256            q
           2606    325791    pk_inscripciones_modulos 
   CONSTRAINT     l   ALTER TABLE ONLY public.inscripciones_modulos
    ADD CONSTRAINT pk_inscripciones_modulos PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.inscripciones_modulos DROP CONSTRAINT pk_inscripciones_modulos;
       public         postgres    false    259    259            s
           2606    325793 
   pk_modulos 
   CONSTRAINT     P   ALTER TABLE ONLY public.modulos
    ADD CONSTRAINT pk_modulos PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.modulos DROP CONSTRAINT pk_modulos;
       public         postgres    false    261    261            w
           2606    325795 	   pk_paises 
   CONSTRAINT     N   ALTER TABLE ONLY public.paises
    ADD CONSTRAINT pk_paises PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.paises DROP CONSTRAINT pk_paises;
       public         postgres    false    265    265            y
           2606    325797 	   pk_perfil 
   CONSTRAINT     T   ALTER TABLE ONLY public.perfiles
    ADD CONSTRAINT pk_perfil PRIMARY KEY (perfil);
 <   ALTER TABLE ONLY public.perfiles DROP CONSTRAINT pk_perfil;
       public         postgres    false    267    267            {
           2606    325799    pk_profesiones 
   CONSTRAINT     X   ALTER TABLE ONLY public.profesiones
    ADD CONSTRAINT pk_profesiones PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.profesiones DROP CONSTRAINT pk_profesiones;
       public         postgres    false    268    268            }
           2606    325801    pk_provincias 
   CONSTRAINT     V   ALTER TABLE ONLY public.provincias
    ADD CONSTRAINT pk_provincias PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.provincias DROP CONSTRAINT pk_provincias;
       public         postgres    false    270    270            
           2606    325803    pk_sedes 
   CONSTRAINT     L   ALTER TABLE ONLY public.sedes
    ADD CONSTRAINT pk_sedes PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sedes DROP CONSTRAINT pk_sedes;
       public         postgres    false    272    272            �
           2606    325805    pk_sedes_formadores 
   CONSTRAINT     b   ALTER TABLE ONLY public.sedes_formadores
    ADD CONSTRAINT pk_sedes_formadores PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT pk_sedes_formadores;
       public         postgres    false    273    273            �
           2606    325807    pk_temp_ciudades 
   CONSTRAINT     \   ALTER TABLE ONLY public.temp_ciudades
    ADD CONSTRAINT pk_temp_ciudades PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_ciudades DROP CONSTRAINT pk_temp_ciudades;
       public         postgres    false    276    276            �
           2606    325809    pk_temp_personas 
   CONSTRAINT     \   ALTER TABLE ONLY public.temp_personas
    ADD CONSTRAINT pk_temp_personas PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_personas DROP CONSTRAINT pk_temp_personas;
       public         postgres    false    278    278            �
           2606    325811    pk_tipo_clase 
   CONSTRAINT     V   ALTER TABLE ONLY public.tipo_clase
    ADD CONSTRAINT pk_tipo_clase PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.tipo_clase DROP CONSTRAINT pk_tipo_clase;
       public         postgres    false    281    281            �
           2606    325813    pk_tipo_pago 
   CONSTRAINT     T   ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT pk_tipo_pago PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT pk_tipo_pago;
       public         postgres    false    283    283            �
           2606    325815    pk_tipo_pago_sede 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tipo_pago_sede
    ADD CONSTRAINT pk_tipo_pago_sede PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_pago_sede DROP CONSTRAINT pk_tipo_pago_sede;
       public         postgres    false    285    285            �
           2606    325817    pk_tipo_persona 
   CONSTRAINT     Z   ALTER TABLE ONLY public.tipo_persona
    ADD CONSTRAINT pk_tipo_persona PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.tipo_persona DROP CONSTRAINT pk_tipo_persona;
       public         postgres    false    287    287            �
           2606    325819    pk_tipo_persona_perfiles 
   CONSTRAINT     l   ALTER TABLE ONLY public.tipo_persona_perfiles
    ADD CONSTRAINT pk_tipo_persona_perfiles PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT pk_tipo_persona_perfiles;
       public         postgres    false    289    289            �
           2606    325821    pk_tipo_profesores 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tipo_profesor
    ADD CONSTRAINT pk_tipo_profesores PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_profesor DROP CONSTRAINT pk_tipo_profesores;
       public         postgres    false    291    291            �
           2606    325823    pk_tipo_titulo 
   CONSTRAINT     X   ALTER TABLE ONLY public.tipo_titulo
    ADD CONSTRAINT pk_tipo_titulo PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.tipo_titulo DROP CONSTRAINT pk_tipo_titulo;
       public         postgres    false    293    293            �
           2606    325825 
   pk_titulos 
   CONSTRAINT     P   ALTER TABLE ONLY public.titulos
    ADD CONSTRAINT pk_titulos PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.titulos DROP CONSTRAINT pk_titulos;
       public         postgres    false    295    295            �
           2606    325827    pk_usuario_persona 
   CONSTRAINT     `   ALTER TABLE ONLY public.usuario_persona
    ADD CONSTRAINT pk_usuario_persona PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT pk_usuario_persona;
       public         postgres    false    297    297            
           2606    325829    uk_alumnos_dni 
   CONSTRAINT     Q   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT uk_alumnos_dni UNIQUE (dni);
 A   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_dni;
       public         postgres    false    187    187            
           2606    325831    uk_alumnos_legajo 
   CONSTRAINT     W   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT uk_alumnos_legajo UNIQUE (legajo);
 D   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_legajo;
       public         postgres    false    187    187            %
           2606    325833    uk_caja_cuentas__descripcion 
   CONSTRAINT     k   ALTER TABLE ONLY public.caja_cuentas
    ADD CONSTRAINT uk_caja_cuentas__descripcion UNIQUE (descripcion);
 S   ALTER TABLE ONLY public.caja_cuentas DROP CONSTRAINT uk_caja_cuentas__descripcion;
       public         postgres    false    194    194            G
           2606    325835    uk_cursadas_alumnos 
   CONSTRAINT     p   ALTER TABLE ONLY public.cursadas_alumnos
    ADD CONSTRAINT uk_cursadas_alumnos UNIQUE (id_cursada, id_alumno);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT uk_cursadas_alumnos;
       public         postgres    false    224    224    224            M
           2606    325837    uk_cursadas_modulos 
   CONSTRAINT     j   ALTER TABLE ONLY public.cursadas_modulos
    ADD CONSTRAINT uk_cursadas_modulos UNIQUE (mes, id_cursada);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT uk_cursadas_modulos;
       public         postgres    false    229    229    229            W
           2606    325839    uk_cursos_correlatividad 
   CONSTRAINT     ~   ALTER TABLE ONLY public.cursos_correlatividad
    ADD CONSTRAINT uk_cursos_correlatividad UNIQUE (id_curso, id_curso_previo);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT uk_cursos_correlatividad;
       public         postgres    false    236    236    236            [
           2606    325841    uk_cursos_modulos 
   CONSTRAINT     d   ALTER TABLE ONLY public.cursos_modulos
    ADD CONSTRAINT uk_cursos_modulos UNIQUE (mes, id_curso);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT uk_cursos_modulos;
       public         postgres    false    239    239    239            a
           2606    325843    uk_cursos_titulos 
   CONSTRAINT     j   ALTER TABLE ONLY public.cursos_titulos
    ADD CONSTRAINT uk_cursos_titulos UNIQUE (id_curso, id_titulo);
 J   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT uk_cursos_titulos;
       public         postgres    false    243    243    243            �
           2606    325845    uk_sedes_formadores 
   CONSTRAINT     o   ALTER TABLE ONLY public.sedes_formadores
    ADD CONSTRAINT uk_sedes_formadores UNIQUE (id_formador, id_sede);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT uk_sedes_formadores;
       public         postgres    false    273    273    273            �
           2606    325847    uk_tipo_pago 
   CONSTRAINT     X   ALTER TABLE ONLY public.tipo_pago
    ADD CONSTRAINT uk_tipo_pago UNIQUE (descripcion);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT uk_tipo_pago;
       public         postgres    false    283    283            �
           2620    325848    trg_ai_cursadas    TRIGGER     {   CREATE TRIGGER trg_ai_cursadas AFTER INSERT ON public.cursadas FOR EACH ROW EXECUTE PROCEDURE public.sp_trg_ai_cursadas();
 1   DROP TRIGGER trg_ai_cursadas ON public.cursadas;
       public       postgres    false    319    223            �
           2620    325849    trg_ai_cursadas_alumnos    TRIGGER     �   CREATE TRIGGER trg_ai_cursadas_alumnos AFTER INSERT ON public.cursadas_alumnos FOR EACH ROW EXECUTE PROCEDURE public.sp_trg_ai_cursadas_alumnos();

ALTER TABLE public.cursadas_alumnos DISABLE TRIGGER trg_ai_cursadas_alumnos;
 A   DROP TRIGGER trg_ai_cursadas_alumnos ON public.cursadas_alumnos;
       public       postgres    false    224    320            �
           2606    325850    fk_alquiler_sede_cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY public.alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera FOREIGN KEY (id_estado_pago) REFERENCES public.estados_pago(id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera;
       public       postgres    false    254    182    2669            �
           2606    325855    fk_alquiler_sede_cabecera__sede    FK CONSTRAINT     �   ALTER TABLE ONLY public.alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera__sede FOREIGN KEY (id_sede) REFERENCES public.alquiler_sede(id);
 `   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera__sede;
       public       postgres    false    2579    182    181            �
           2606    325860    fk_alquiler_sede_detalle__aula    FK CONSTRAINT     �   ALTER TABLE ONLY public.alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__aula FOREIGN KEY (id_aula) REFERENCES public.aulas(id);
 ^   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__aula;
       public       postgres    false    190    184    2591            �
           2606    325865 "   fk_alquiler_sede_detalle__cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY public.alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__cabecera FOREIGN KEY (id_cabecera) REFERENCES public.alquiler_sede_cabecera(id);
 b   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__cabecera;
       public       postgres    false    2581    182    184            �
           2606    325870    fk_aulas_sede    FK CONSTRAINT     r   ALTER TABLE ONLY public.aulas
    ADD CONSTRAINT fk_aulas_sede FOREIGN KEY (id_sede) REFERENCES public.sedes(id);
 =   ALTER TABLE ONLY public.aulas DROP CONSTRAINT fk_aulas_sede;
       public       postgres    false    2687    272    190            �
           2606    325875    fk_caja_comprobantes__tipo    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_comprobantes
    ADD CONSTRAINT fk_caja_comprobantes__tipo FOREIGN KEY (id_tipo_comprobante) REFERENCES public.caja_tipo_comprobantes(id);
 V   ALTER TABLE ONLY public.caja_comprobantes DROP CONSTRAINT fk_caja_comprobantes__tipo;
       public       postgres    false    208    192    2611            �
           2606    325880    fk_caja_movimientos__operacion    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos__operacion FOREIGN KEY (id_operacion) REFERENCES public.caja_operaciones(id);
 Y   ALTER TABLE ONLY public.caja_movimientos DROP CONSTRAINT fk_caja_movimientos__operacion;
       public       postgres    false    2603    200    198            �
           2606    325885    fk_caja_operaciones__tipo    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones
    ADD CONSTRAINT fk_caja_operaciones__tipo FOREIGN KEY (id_tipo_operacion) REFERENCES public.caja_tipo_operaciones(id);
 T   ALTER TABLE ONLY public.caja_operaciones DROP CONSTRAINT fk_caja_operaciones__tipo;
       public       postgres    false    200    2613    210            �
           2606    325890 #   fk_caja_operaciones_diarias__cuenta    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__cuenta FOREIGN KEY (id_cuenta) REFERENCES public.caja_cuentas(id);
 f   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__cuenta;
       public       postgres    false    194    2595    201            �
           2606    325895 '   fk_caja_operaciones_diarias__medio_pago    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__medio_pago FOREIGN KEY (id_medio_pago) REFERENCES public.caja_medios_pagos(id);
 j   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__medio_pago;
       public       postgres    false    196    2599    201            �
           2606    325900 (   fk_caja_operaciones_diarias__movimientos    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__movimientos FOREIGN KEY (id_movimiento) REFERENCES public.caja_movimientos(id);
 k   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__movimientos;
       public       postgres    false    201    2601    198            �
           2606    325905 &   fk_caja_operaciones_diarias__subcuenta    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__subcuenta FOREIGN KEY (id_subcuenta) REFERENCES public.caja_subcuentas(id);
 i   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__subcuenta;
       public       postgres    false    2609    201    206            �
           2606    325910 )   fk_caja_operaciones_diarias__tipo_titular    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__tipo_titular FOREIGN KEY (id_tipo_titular) REFERENCES public.caja_tipo_titulares(id);
 l   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__tipo_titular;
       public       postgres    false    201    212    2615            �
           2606    325915 $   fk_caja_parametrizacion__comprobante    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__comprobante FOREIGN KEY (id_comprobante) REFERENCES public.caja_comprobantes(id);
 c   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__comprobante;
       public       postgres    false    2593    192    204            �
           2606    325920     fk_caja_parametrizacion__cuentas    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__cuentas FOREIGN KEY (id_cuenta) REFERENCES public.caja_cuentas(id);
 _   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__cuentas;
       public       postgres    false    2595    204    194            �
           2606    325925 #   fk_caja_parametrizacion__medio_pago    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__medio_pago FOREIGN KEY (id_medio_pago) REFERENCES public.caja_medios_pagos(id);
 b   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__medio_pago;
       public       postgres    false    204    196    2599            �
           2606    325930 $   fk_caja_parametrizacion__movimientos    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__movimientos FOREIGN KEY (id_movimiento) REFERENCES public.caja_movimientos(id);
 c   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__movimientos;
       public       postgres    false    198    204    2601            �
           2606    325935 "   fk_caja_parametrizacion__subcuenta    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__subcuenta FOREIGN KEY (id_subcuenta) REFERENCES public.caja_subcuentas(id);
 a   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__subcuenta;
       public       postgres    false    204    206    2609            �
           2606    325940 %   fk_caja_parametrizacion__tipo_titular    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__tipo_titular FOREIGN KEY (id_tipo_titular) REFERENCES public.caja_tipo_titulares(id);
 d   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__tipo_titular;
       public       postgres    false    204    212    2615            �
           2606    325945    fk_caja_subcuentas__cuenta    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja_subcuentas
    ADD CONSTRAINT fk_caja_subcuentas__cuenta FOREIGN KEY (id_cuenta) REFERENCES public.caja_cuentas(id);
 T   ALTER TABLE ONLY public.caja_subcuentas DROP CONSTRAINT fk_caja_subcuentas__cuenta;
       public       postgres    false    206    194    2595            �
           2606    325950    fk_ciudad_provincia    FK CONSTRAINT     �   ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT fk_ciudad_provincia FOREIGN KEY (id_provincia) REFERENCES public.provincias(id);
 F   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT fk_ciudad_provincia;
       public       postgres    false    214    270    2685            �
           2606    325955    fk_clases_asistencia__persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia__persona FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 Y   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia__persona;
       public       postgres    false    217    187    2585            �
           2606    325960    fk_clases_asistencia_clase    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia_clase FOREIGN KEY (id_clase) REFERENCES public.clases(id);
 V   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia_clase;
       public       postgres    false    217    216    2619            �
           2606    325965    fk_clases_aula    FK CONSTRAINT     t   ALTER TABLE ONLY public.clases
    ADD CONSTRAINT fk_clases_aula FOREIGN KEY (id_aula) REFERENCES public.aulas(id);
 ?   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_aula;
       public       postgres    false    216    190    2591            �
           2606    325970    fk_clases_cursadas    FK CONSTRAINT     ~   ALTER TABLE ONLY public.clases
    ADD CONSTRAINT fk_clases_cursadas FOREIGN KEY (id_cursada) REFERENCES public.cursadas(id);
 C   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_cursadas;
       public       postgres    false    216    223    2627            �
           2606    325975    fk_clases_modulo    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases
    ADD CONSTRAINT fk_clases_modulo FOREIGN KEY (id_modulo) REFERENCES public.cursadas_modulos(id);
 A   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_modulo;
       public       postgres    false    216    229    2635            �
           2606    325980    fk_clases_profesores    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases_profesores
    ADD CONSTRAINT fk_clases_profesores FOREIGN KEY (id_profesor) REFERENCES public.personas(id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores;
       public       postgres    false    219    187    2585            �
           2606    325985    fk_clases_profesores__clases    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases_profesores
    ADD CONSTRAINT fk_clases_profesores__clases FOREIGN KEY (id_clase) REFERENCES public.clases(id);
 X   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores__clases;
       public       postgres    false    219    2619    216            �
           2606    325990    fk_clases_tipo_clase    FK CONSTRAINT     �   ALTER TABLE ONLY public.clases
    ADD CONSTRAINT fk_clases_tipo_clase FOREIGN KEY (id_tipo_clase) REFERENCES public.tipo_clase(id);
 E   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_tipo_clase;
       public       postgres    false    216    281    2697            �
           2606    325995    fk_cursadas__cursos    FK CONSTRAINT     }   ALTER TABLE ONLY public.cursadas
    ADD CONSTRAINT fk_cursadas__cursos FOREIGN KEY (id_curso) REFERENCES public.cursos(id);
 F   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT fk_cursadas__cursos;
       public       postgres    false    223    235    2643            �
           2606    326000 %   fk_cursadas_alumnos__condicion_alumno    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__condicion_alumno FOREIGN KEY (id_condicion_alumno) REFERENCES public.condiciones_alumno(id);
 `   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__condicion_alumno;
       public       postgres    false    224    221    2625            �
           2606    326005    fk_cursadas_alumnos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__cursadas FOREIGN KEY (id_cursada) REFERENCES public.cursadas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__cursadas;
       public       postgres    false    224    223    2627            �
           2606    326010    fk_cursadas_alumnos__personas    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__personas FOREIGN KEY (id_alumno) REFERENCES public.personas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__personas;
       public       postgres    false    224    187    2585            �
           2606    326015    fk_cursadas_cuotas__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__alumnos FOREIGN KEY (id_cursadas_alumnos) REFERENCES public.cursadas_alumnos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__alumnos;
       public       postgres    false    226    224    2629            �
           2606    326020    fk_cursadas_cuotas__modulos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__modulos FOREIGN KEY (id_cursadas_modulos) REFERENCES public.cursadas_modulos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__modulos;
       public       postgres    false    226    229    2635            �
           2606    326025     fk_cursadas_profesores__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__cursadas FOREIGN KEY (id_cursada) REFERENCES public.cursadas(id);
 ^   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__cursadas;
       public       postgres    false    233    223    2627            �
           2606    326030 "   fk_cursadas_profesores__profesores    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__profesores FOREIGN KEY (id_profesor) REFERENCES public.personas(id);
 `   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__profesores;
       public       postgres    false    233    187    2585            �
           2606    326035 %   fk_cursadas_profesores__tipo_profesor    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__tipo_profesor FOREIGN KEY (id_tipo_profesor) REFERENCES public.tipo_profesor(id);
 c   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__tipo_profesor;
       public       postgres    false    233    291    2709            �
           2606    326040     fk_cursos_correlatividad__cursos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos FOREIGN KEY (id_curso) REFERENCES public.cursos(id);
 `   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos;
       public       postgres    false    236    235    2643            �
           2606    326045 (   fk_cursos_correlatividad__cursos_previos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos_previos FOREIGN KEY (id_curso_previo) REFERENCES public.cursos(id);
 h   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos_previos;
       public       postgres    false    236    235    2643            �
           2606    326050    fk_cursos_modulos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursadas_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursadas FOREIGN KEY (id_cursada) REFERENCES public.cursadas(id);
 V   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT fk_cursos_modulos__cursadas;
       public       postgres    false    229    223    2627            �
           2606    326055    fk_cursos_modulos__cursos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursos_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursos FOREIGN KEY (id_curso) REFERENCES public.cursos(id);
 R   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT fk_cursos_modulos__cursos;
       public       postgres    false    239    235    2643            �
           2606    326060    fk_cursos_titulos__cursos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursos_titulos
    ADD CONSTRAINT fk_cursos_titulos__cursos FOREIGN KEY (id_curso) REFERENCES public.cursos(id);
 R   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT fk_cursos_titulos__cursos;
       public       postgres    false    243    235    2643            �
           2606    326065    fk_cursos_titulos__titulos    FK CONSTRAINT     �   ALTER TABLE ONLY public.cursos_titulos
    ADD CONSTRAINT fk_cursos_titulos__titulos FOREIGN KEY (id_titulo) REFERENCES public.titulos(id);
 S   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT fk_cursos_titulos__titulos;
       public       postgres    false    243    295    2713            �
           2606    326070    fk_datos_academicos__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_academicos
    ADD CONSTRAINT fk_datos_academicos__alumnos FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 W   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__alumnos;
       public       postgres    false    246    187    2585            �
           2606    326075 %   fk_datos_academicos__niveles_estudios    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_academicos
    ADD CONSTRAINT fk_datos_academicos__niveles_estudios FOREIGN KEY (id_nivel_estudio) REFERENCES public.niveles_estudios(id);
 `   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__niveles_estudios;
       public       postgres    false    246    263    2677            �
           2606    326080    fk_datos_actuales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_actuales
    ADD CONSTRAINT fk_datos_actuales__alumnos FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales__alumnos;
       public       postgres    false    248    187    2585            �
           2606    326085    fk_datos_actuales_ciudades    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_actuales
    ADD CONSTRAINT fk_datos_actuales_ciudades FOREIGN KEY (id_ciudad) REFERENCES public.ciudades(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales_ciudades;
       public       postgres    false    248    214    2617            �
           2606    326090    fk_datos_laborales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_laborales
    ADD CONSTRAINT fk_datos_laborales__alumnos FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 U   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__alumnos;
       public       postgres    false    187    250    2585            �
           2606    326095    fk_datos_laborales__profesiones    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_laborales
    ADD CONSTRAINT fk_datos_laborales__profesiones FOREIGN KEY (id_profesion) REFERENCES public.profesiones(id);
 Y   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__profesiones;
       public       postgres    false    250    2683    268            �
           2606    326100    fk_datos_salud__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_salud
    ADD CONSTRAINT fk_datos_salud__alumnos FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 M   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__alumnos;
       public       postgres    false    252    2585    187            �
           2606    326105 !   fk_datos_salud__grupos_sanguineos    FK CONSTRAINT     �   ALTER TABLE ONLY public.datos_salud
    ADD CONSTRAINT fk_datos_salud__grupos_sanguineos FOREIGN KEY (id_grupo_sanguineo) REFERENCES public.grupos_sanguineos(id);
 W   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__grupos_sanguineos;
       public       postgres    false    252    2671    256            �
           2606    326110    fk_modulos_cursos    FK CONSTRAINT     z   ALTER TABLE ONLY public.modulos
    ADD CONSTRAINT fk_modulos_cursos FOREIGN KEY (id_curso) REFERENCES public.cursos(id);
 C   ALTER TABLE ONLY public.modulos DROP CONSTRAINT fk_modulos_cursos;
       public       postgres    false    261    2643    235            �
           2606    326115    fk_personas_tipo    FK CONSTRAINT     �   ALTER TABLE ONLY public.personas
    ADD CONSTRAINT fk_personas_tipo FOREIGN KEY (id_tipo_persona) REFERENCES public.tipo_persona(id);
 C   ALTER TABLE ONLY public.personas DROP CONSTRAINT fk_personas_tipo;
       public       postgres    false    187    2705    287            �
           2606    326120    fk_provincias_pais    FK CONSTRAINT     }   ALTER TABLE ONLY public.provincias
    ADD CONSTRAINT fk_provincias_pais FOREIGN KEY (id_pais) REFERENCES public.paises(id);
 G   ALTER TABLE ONLY public.provincias DROP CONSTRAINT fk_provincias_pais;
       public       postgres    false    2679    265    270            �
           2606    326125    fk_sedes_formadores__sedes    FK CONSTRAINT     �   ALTER TABLE ONLY public.sedes_formadores
    ADD CONSTRAINT fk_sedes_formadores__sedes FOREIGN KEY (id_sede) REFERENCES public.sedes(id);
 U   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT fk_sedes_formadores__sedes;
       public       postgres    false    272    2687    273            �
           2606    326130     fk_tipo_persona_perfiles__perfil    FK CONSTRAINT     �   ALTER TABLE ONLY public.tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__perfil FOREIGN KEY (perfil) REFERENCES public.perfiles(perfil);
 `   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__perfil;
       public       postgres    false    267    2681    289            �
           2606    326135 &   fk_tipo_persona_perfiles__tipo_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__tipo_persona FOREIGN KEY (id_tipo_persona) REFERENCES public.tipo_persona(id);
 f   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__tipo_persona;
       public       postgres    false    287    2705    289            �
           2606    326140    fk_usuario_persona__persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario_persona
    ADD CONSTRAINT fk_usuario_persona__persona FOREIGN KEY (id_persona) REFERENCES public.personas(id);
 U   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT fk_usuario_persona__persona;
       public       postgres    false    187    2585    297            _   o   x���v
Q���W((M��L�K�),��I-�/NMIUs�	uVа�Q0�QP720��50�54U�Q020�30@U00�25�25�3�44�� �R74�2 !0��ִ��� ?��      `   
   x���          b   
   x���          h   
   x���          j   �   x���v
Q���W((M��L�KN�J�O��-(�OJ�+I-Vs�	uV�0�QPw�qTp
�W�Q0�Q()*M�Q0�QHK�)��B}|4��<I1�d��S��_������%FH�@��a�f��cH��s��#�l0��襧���⪧ ����g0qq M�p�      l   �   x����N1E����R�AT{Hmf��K��U
B����H����}�D�,I�{|�|C�ѿ�������E8[�a��	gs8�����I^2!�Q��z�6��/���=:V��\�F�Ӕ7!��i.��^s�5��F���ҡ#I!�A�Z�fu�q��)���٪h�Y����b>[�0���Q�Y,��w,���4GGϫ      n   �   x���M
�0��}N1�*H�����: �N&ݖZE*J���!�Y|�ː������V�ͻ���G׏�м�*s�`�\@ȁ5|����(G����P���	�%��>��6�`�x��M���Ā�̔���.E��%2:K&���������R��L      p   M  x���KO�@�;�boՈ��<�i�dI���m^b5F���F��ŅKm���O�X�앱�����Z\,������ZV�j�ި��:i�U��yT&�Β�j���yW�^��?$�JR��3�3Z�s���6 n;ʕ��0��&'H'
��D3R4q)���jQ�W�&�����y��)3C����!}Af0&5c*Sbm�Fa�=l�� ���� ��M����Q'�r8A8W�{����'��0����2Zm X�8+���cI���@v�l<�4cj<h��a��^.�����W��jj�`o+g(�܀,C��Ɏ�lc_��g���/�V{Z�~      r   �   x����
�@�OqwHPf?���"7r&fFi&.�H�|�n������pI��I��no�2���=�Vu�dyY=��┠����d��(x�Z(���q=Xy�n�b�s�t����ŎL�L�xV��O�)˾�}�IK9����p�"!�Y��X�� c�F�R�	9n`/�{~ۋ��U���      s   
   x���          v   
   x���          x   �   x���?�0�Ὗ�*�����SL�z �^bW���""���&��H�[��G� [ e5<���R���Z���\�ͽ�Z(���b,PZ*u<wvϾ�"��H�!�xpG(1wĞu��k~3�f�FIk�e",���J�U�Us��]9���y�R o��,H�~BO��I�#���w�~�e�L��>8�]w���里� ��s      z   �   x���=�0�὿"�
"�-8��Y"m�\.��-�E��7��bփ�����ІQ����6���T���]�t�����}8?�If�ϧb�����>���O�yAK�~��(d�a��k>��0p��7(�j%�?�RS�U�ɣ�a���L���e��L.��r���Q��ȯ�      |   �   x����
�@��WqvH���8Nvb��m+&.�H1��N�6��ޏ��6ҩ�v���rZ�"��ɛ�ꊲn�.�2�`<a�Pņ7$�(����>����:���,��Jg���du�P���GZ��S�R/e�
i�3��R�a"���۲g"E��'6Ϙx�;&#�-�Oj� ����      ~   �   x���v
Q���W((M��L�KN�J�/�,�%�9�E��
a�>���
�:
�@�������_����BIQi��5�'i
vuq��c�1��Ρ�>��d4) �?����?�B�L�f9;zQ�$3���\�1]�� �~��      �      x���[��J�-��_���6�w�O)*Kbm��N��z;�������w�%I�v`V|3���]�%222bŊn�|��0������������������������=�\����?���q�պ��v��?�w7������X��(;�/������$e,��7ܗȨ0�*cr��s���9bb
3��й��W����m�L�*w��0��n4�,/�5������p�6��V��(�s�MD#"����`��3��fGkz�ݡ�n�i���H���=&�e��c�������i��l'%���g�S�4������,sVl�Z�v׸��L��������Ru��U��y�zp5ibF�|s�o�x�R��*#}��lO�7�0�n2M���_Xln9)��]?>��Cv�-:��ޤ���2�<{�Rd'���]J՘��NG�q���mk[��O�b��J�'#:�$�,a��bZ��~�%�jř��_�7�e�dYƂTtX�+^���U��B�t���ѻF���%�_�e]
��g4,q8����Y��,��.�� }.�ҏZ��5F���F/ff=�.Q7�lmA��F� U�C�7�,&�X�������3I!�����������tօ�M�p�})�&��2.�2��{����7?���FI�/"c�so���dE����5�ё���{AO�m�T��W��K.�%&�޿����@�M�Hs�"MOL*�Y�6Z���l%��ҙ�����t�e.tRXF'����T�_0�����H��a;ܖ�\ȇ�T��0/7�*�dK0{w�i����������_t�g]�� R�Kws��S�~�ّ��A'��y�^T�<��*��Q�QcF��0B��{z��E�S�Zl���Wg����=�m&�,
��W� ��G	��0͢ډ��a iߦ��w�n�q�IivR�.~3�L���NL��q����D�Qa��g|��[�`s�)�G�v���wq-9oEh�7A��p��41���k�A�g�����^��\zA�����xx� C����b��_ț�m�6y{�����X�����ߞ�EΙt�6^��� �ߟ���C�Cy�D«[Қ�r}�>ƾF��懜�1���+�i�ʈ�hG��8Y�ѹڞ��ŋ���4�Z�+�}��Fa���=W�F��G���g�cz?^-�Ev$�����#.n?���	җ������N�����W��C:�IG��.c~�^iّN��p�:L�M�D:���^z̯Q�8p-�����g���l����L2l=5wEr�.�G4�+��U��<��l�����:��`ٞ����^�%t��LC�7���6�l��'y��7xt�������>{��~s��W�����4��#��� �hY�wD/���!e�7)�M	��8�5Mr2(v�e{w3n�LK��3�4��ۤ�c]_�d�:zK���,I�?��@e�w)��ܬ���YּIZL7Y�W�������9��0�
��Z�<�k���%$�,��Y.Ϩ���ߦu�E��8���4PψU9tѢ��(
L�9_u�ӫ��D�bN���r�ma��D�*��%f!8mEy����3��y/�wgq�K��m�|u�V�SYQPP7� �'��Y���/��*�V�~�6pe9{��y/�"��L�\�(7���Rqʊ��%*Zg1����/�K��Q��Ŵq��R7,���/8��[�t�-�S��&����PO��.߁Miyq2������|��2��'��P�V�I.+)m�M�Y��������%a��W��8�W`O#�W=]O�l��p��z?E�)���iMw'�4���y+�Zt����
W�&�o�M׆SV�}��Ş
��
�E�賙V�	���nD׊L�>xYU_ڮ\tI5�tx���L��W$�յ�����+�������f�>[8�5-C|��/�לȚ��ٔ�Y��כ�Y�����������b1b7
��Z	�n�L��W}��w�'�)�o?�cF�į`r*�-��p���+6��㊯�4��-��k���-r��!Y(����b��[��gD8?f����Q]g�{|`��턹Ro����9�2L�%Ϥ���n���LS���e}��Iw?�/C��a]�-���8��>��(G <G�q��Mc��5�G����Z�B�`:��甓��Iа���kZ���n�l��|�b?��r�٥�8��OӖ����2�R,��������foB*z�q�A�sN*�Cu쯳�t�ckph�];�Đ�v�����6�;~�QNw+,�������D_\H�8�%��ۻ�����n:��葋<N��,f^��)w�I.y9��ju�˒w�V�D��^�����9�� 1JOuZ7����s\�lE�m�aXu�*���.�e;���v�U�cE�nWՁN�ޥ�/�EC9��v*{ٙ-P�y���	N���AQ��
�+�Wg�~�L^O;/V�LC�������b��%\���zj}x�9y���mh��]��"��T	�S�=F���-�mT�Oq��}k��}W����0&�������E
�_+y~�cW{��M���)4}|��
ۍ\�;<�8���\�<>����;�k7�'�J*8I��Hl�q���[�@X�z@�R ��+�O-�\���O��',U�K��?\���e��]����($Z¹��Ñ[O"�>(O�+y��db;�9-v�Si�	<D�Ӻ��2�������j,��sb�6^G����-�բ ��"�C�p�*�2��]��ɞ�]C5�7��!�^�v�cPH�#����	�nKqp�I�Ǫ�(8�5G>�7%���oѽ�<�ӽl�X��!>=��ɤq�I�� �O�������1(V���)$���	g�a�7�Y/�9z���X�R.��R]�ب�sk�����+��ι���G�d[t��W\}�G|���I���^i�u�P���p��������R�3"5s�K�5�^B9�� +�F�@���|W>ugAl�Xz3ߕO1/G�~GC�7��g|�K�"��):u���3�ރ�R�	]�=���C�	  4��T����[=�:����K���=����=��d9�g��w�_O��T+�ڃ ���۲�ouT�{rY��3,oETT�j��$��D� ǓiN��KX��+�;��������A��BK)j��H�N�}��Md# *7��ć�D1k�@rB��M|�5�_`ǧy�M�iXFr>꽕����'�EIUO}�|5B^c;"eO���>���q#?���0��������{!���2���D��^��� ;�)�����,�����T⫰W&�24A���Kgю�sQ����%g��Nq\k���`wuW�9gl��2�����4yOG:-�1��a2����f��YpNj;�#���A��C4��%�<̜�;l�%Y5P��ꍍ�w�S
�.Ac��I,8U5q@¢m��z��W�o���i{+�7dT���Y���U"g&��z��]��?\��}�o�����yw���'aT��{�����[q��*H���'������,�)�r_n�\$���[}�v�������B�5��v�i�ފ�?�(p`�U��sѩI�z�De�^|ب�)�`
�U)~?����ڊLC�Ø��Y$4@k���D��q v&���:*�O ��t�9|����$"�!E�����_��4-p.	��]�C��vJ���p��S�Wk������3V�����\}p6���+7\��q�0���f!�Yb�%�����p���&`�ީL�O+;aOʢ��ti*{qIR�="�RS�G�P[�vp�1��rM��ʹ($���wgX�����Q��7}���)��bƢ�l;�F��8ֻ����� ���sRN���.�g��R�3��Yn�s�L�
�ΦII� Dgڙ��һ��JW
k
g�(�2^������h�x���n���w/�����:�=No�|�2'X��T��GkR^�*���ڻ�z�W@ץJ��E�t����<.�vف"���Q!Ta������Q �q������/��%V1Q�rT�.��K����}���@���c�U=�"^S� "g<���"	��    �m�x@�%�.t����`_��.!
t&!ij<+�mP� ,g�L�9z�ק�I	Js�a�Ģ��!?��4[V��=��6��߾xj\�0���N���ct����,�iq$7Eu�
A��W������V�ܹ�Mjc3,�Th)�}]H�"�n�8]u���a5��n�2
 �8�a��Ӥi2TW9=�;�H�S[�D���e�{�Rނ��Z���8�8Kۉ��@%��Oo�}���Z��L?W��#���-
̹�(�X/\p�t���ߐI�Y��c�����e���|�w��4��%���u���f(�ś�螝�	su�;x�F�֡2����B��^!��A/9���y��E]�&ыa��b^zyJ�[���Pg??b���$���Јf�M�$�i�F�[tZ_�"ۤ����+9��v�p�-՞�a'�}��� ���x���HSt-��������lN��̏���e��১%Q��N�Tc٘l�I�EA��Y"L��DғXحLY�����$e�D¾�	��撾�)a���)��ݧ�#�i��h���H�s�=���G#�tL��=��^3֭�ل��,��T�IȏT'ˡ�فJ�aa%e�=[�bj@�U`�[��P=]���(�jjCXM�U���O.����$�}�^���+B5,+���B�S䁿|*B�t��J��S]]����O���s|<��m�rS�������Qr:�I��� ��B�ߘ®H��C�Ѭ�j���R�_q�q K���r��]��|I��M�s��
�E�d"����{%lx\8�D�Tκ���r}[�g�ꮵ�Bx�d�L��
����
��%�e�m7*��&'�,��ԤD�L�-І6��<
U�3:c4�$N�L~^�3 �ƖJ�F����r�`����6t��|xp=ΫIN�׻M�65�+�2��+"��E����BF�����X6�s+�%㇎�7��M���4u��d���7�Uq.��yu�R��V����D 8y�~|x�M���O����
���h���f�Y�~%�A�0��F3+�i��M�0��Ui�`�Nyh��Ro��.����1&���_��KV�Qɚ�Ǘ4��r��5M��lѨv�~��M�V�ܼ��ɹ%|�3�R�9U,�
r� ���_��k��n8�r���3����c�5�Q�K���i.B4p��ʎ��g�t���9+p����i95���"IA؀��Y}t�4��	��]��j�,���ߘ��;W[<��.� h�Ϝ]���é	���Y��ݫ������H�ϕA��G-Ds�Z��-���֡�[z!�g�FRZJd�(�\{�*2�p?��C[M���WCA�7'Д
+�?+��AQ���1�:����OJ�.�IK$�2�>�X����E�ώ*x��|ݼ���/��Rc�.瓨&{)i�%	X�N�J�=#t>��~;�߃��)�y�Ў��}d�_�xH;�
CH0Մb'7v�Q8s�wdh/Ӏ\@���%�uWa#�ɓG�Y�Ȥ82<�_�c�J�.����*���̩�M'RG�} ��3gJ�+=�c8|�K���P�|�
��'�L��Ù.�D$���������$�*j�c�a�͒�S����K�����ЍÜ'4Ń�l�E s�9/v2Fn"�"�8fF���m_Kv�pQ�#jR�N;w��مn���X���k�b����%������I�7Jħ[z�c�	�����q0�4�R�=ac�K!e���!Ŏ��Y.�b+�v�Nj��k�X�bC}�W�S+_Ї@����^�d�A)[p��	�h���j��������g�|�;�|�hZ�i���1�/���x&/+Pc�^>T����6�S-��1�/��2����61[y��BQ/���~�#�8g�?Źܰ�Q�N%~?�;�����{?�p9��ق������-�(�
�� �=J�B�\m@���?�������������/����K���ɡ�ݪ6~E/՛dl
��\H��.Pξ�m�s���s�Z*1s��s�|_�2�`��Z���݊�a�n����Ϡn�M���8�E0Xv�%˅ �r)���XX���v]��d��������уR�X�f��Ů�@-%4$#�;wN�a[�?�d��Y�ȭ�H5�u��~�����"޽�A!�$c�?�J�<Ǔo^Ny�� �l'��?���9������!�r���.@1'�HB�T�b�yoݰHڼ�<M΀��<]C2I�������/B�S�6ӵ�I�-q�e�}ۙ�N�m�nlR]�ޖRL���!^(FQ��E��[л���3mY��;b�T[ԗb{B	v�qNlw�M#�߅dG�!���oߥ�wn���F:c�ʛ�F� �!c��� �D!?p���4�w�qU�����KOE���d�59�\͠���X����K�ٱh����BSc���Q���u
O^vL9�>�^+$��Sz�9Β���(A�c�ǿ~�av���ۥ-E���B�P�<%�}�-ʎ�;|/���!�I��;���P,iB�7��������!�#�1d�EHVKj^0�.c��ʅ����G���ߎAdҳqju8��E���d�F��p��igܓx:��(d�a=��vd)}������m�.T%���2�z��1�㫳�Ύ=�e��,�cC|SF���	�d�`�/�}���Wj���Oe�,ơ/�,��H����O\"�Z��\8o�@���m���8�|� ��)��M
׵����4Ӧ�<���v%���#U�N��>���d`Thhk>8�方k�:v}7�ᙆ�6�#����)㫌�~���ͥ 58���i�k�� ē�1iя^��F=�K!Mp]�?�;���6-��"�s�d����mI�М[Q�,����Ҳ@��(a+EH=��Mg�D���p�7RQ�k}jt%���\��q�~�0�B/N�5J�J��g���q0��r�� �wP
<~/d���N�.~.�ݨ�v�:�q�0eu'����#�8���w�Ơ���@lPT(���ɲ��XWU烝7͌i�`��	+j�gr�SK-̔]
B|DI����uʰ���D�e�N�#dKR��KR,x�'�nw}\�<-C�ߺ3R��<ZԘ�_^�ʇT�fQ����60�	��n�N���5���AA�9�����Fӱ�����r�&��lj�E��di� r�(��q,}���+�fv�/1uiR���Ə��;|�E0TX�b�:�8�y�lX}���^�^p�vqv,�̟��nR�ᱴ�g�X���o&�Q��������E�8+�������b�^C����fD!-�ݛ�΂���b0������iV"3p6�������-�l뉓D�Ww ��%��e/O��Ȳ=j�N;�4�AӅN��!t�i16��md���7r��MSە��_��ڨ�%HZ�Ռ�1q���Ӥq؎s�c�F}�S"S[>�8|�׫�@�ⷤ��!d��j|"�O7\�@ОN;2ߑ��g�Y����ɧ��0�+xC��t�#ȸ���,r�='?CH��aG�*H��$�QN�.g���Yv�O��MksЦ���M�H����?��,|�9�t�Ėə��r2�_�{ٶ�I��e�S�7��1H��?�@��9 ��[۞� `�dYR�y��Ň�hI��\e��q��!��p3��ڞǽ��_M��5v�P�G	��[�{��:~����[	��F�Ťb��|'H]���q	.+�1ܥ{���{�
eP�f�)Hc��鯸��}�X!�(B�j-1�	�k]�6q�����C"��qbߦ9	望̥t����dq��#�(�_~����E�~����i�Au9�ߣ�	uX�����'A�����u��G_�&u.����%�(p�8�~������A��Fae'FE1�|�3�v�7�9�t��*y���L_ݽ���mιDG׶�ێ|jpf�{t��*8���x.-�V���{$F?tSk	�=hki��Y)��ݘ̀'�Rp�璨sѕPp�����\����?(Ŭ/�jW	�C�FC��(�Q̰�    �k/2�\0+�@�Չ(<��6�&$�@!��eZ_�c(���l}8�aYN[.xӯ�z
I��gH�xX
�t\�grN����̐�h5�	�ۏ�C_'����ȤL���L�\��e�M�_�¬�o����h��K�f�'w��a7�2���$��Չ��|v�� ףH2������ԎF��	R��E��[�$~mk�G#Ѕ�34-�_3p����Q��Dw���\�-�Q0z��	J���k�O������n����g)�}v���r��3���ԜJ�6O�=w�vT�����֞ߨ���r��0>�aRA�iJo�0���4 ~v%�h|e��q�K;u�(���о�K���T�L�����Q��9hR�t�|}�р.0/Ɩ �LC ����2m ��� ��_��=Pi��f��Ҳ�t6II~k��$��:��ʌ�a��LjuH5�qm���D�¶��`�5��Փ\U�Nګ<:��.�g��b9��N,���o�n�Yټ��|�|��E�8���Z�q���B��jLrL�Oɏ���{(�3�D���B�w����`N~�7���o��S^T��hSoЬq�k����=G�9.#aS:	�L��}���/�b�@Ӑm\L����No������˲��}�KK�p9��DU�`^e�mH���V[�����^n�|�'���"�=]��v5�C&�7^bsOM����g��b�Tp+<�<�ճT�\���yƷ��U�K�fy��+K�(���5iw$c!��\0į/x����>�@�|��҂�~��l��$��pҊ�4.�3����bm覧�4��f���J�*?J|�M�I���y�5�)>$��C��ɢ:Ż�[��D�L
EU���Z |U�[B\~�9���(@��j�z_��4�00�Pjt�tv��-��>g���c ��,�J�>G������W	��yL�wXm��B[v�I��Y��6��Z)�"��\��]7Y2g��;���j��s��]�@�|�Z%���K�`�s'e�{�T���ޙ>՘���N*��������}�~����"��Jw�=K�/�v����0Q�����7q���@W�Z��>�g�`ͤ�&^��eq׊�����_s����(��e!A1Pio�7O�����
��U7������U���+���&�Kp����������.a1	஫��}��6�w:��j�����M���A�čJ�Jܬy�C*���
���EK�H��0C�l=W�n6��Fc�w�$1m��Z��x����I�^�j[��sFo/��D�s�J��dȰ�8'h��X�s�Ύ�V��G���!�*��r��x�(�TD�A�c���)	 :t�8f#�Φԛ��s�'IJ|(\��篞�7��i���Ţ�y���
��d�rZ��>g���Z�fwS�ş�9i��T�3`@���J�Ďl.�X
�?.�E`�p+}0	R����G*��!ױ�3>����	�^t����|�A�o�\�ޱ�!�/)yz���%�1W�;LiUU�r��m���{P;VfF15$����-�2�W_���0������}�#�/M�2�3��z�GG�JJ`���3Eo�x�\�F�a9�`	�2���FUA��ϔ�^�w\�D�xڴA:$���v����`Ue�n�K�N-�{�	��4�Hh'���ÄS�/�VD������Zk�u���(}��@+��b�>��ϡ�,�����e�w�cY�����[ZBa�x]���7��=��d�X~�ht�+D�u�����.	@���,��ζ�(�@��]@�C+ Ta�&a&�\^ޔB�C�-qN��Oi5��᜼���~�ep=������P��ȉ���v^.A�l1H]�$����H�&!��Գ�����w��rHE�}���+f�n8������|~޲Ӽ҂�c�V���B�q8Z���0�%38��[�]-������+kj��lOy��v�G�l�k�(k���7�Oɯ�����B��̈́l�u�v�	���ؚj�OG�4Dӑ3W��J�HtS�?���(���ǿd<܇[�U�0Eg�������o�;z�C���%��n�??�T��e�N��mm�tݕ�r�����"h��^� l���S�/�cu(�LX�?o�|Z}��j�Ws�j2���Z��:�>H+ר�����ǵo�Z;p���~���o���:��+����_�k��x�(�tl%���3�a�PyX��[|��ѵ�A[����Լ5z��e�^�A#�ﬧ_M-���.>�E/iH/yt.�������O*��1!�h�o�g�?��}��t�� ��01���h!��)���c *�K�O<��˜ ��*p�| ����ܣ�MQ9ņ�ة>,e�S��[�b��'������h�]�7h��5�ݳ#�,V׼�^�GR�B4i�.L����=̒��A;���R��$,�l�_�$d�|��>�loX�7ʆ�y\�E̞��y��{Nqӆ��0�w����{l���آ���->�,f��΀O4��.�5<��,��;q4�ۃQ��ۅU'�Nl(���=�e,k��+fz�A#������o�0'�$"�{���I�[O=t=e�ZYf!����Z�k��ei����|��OonQ��8HS9��]M$�*:��Ҿ�in�"���Țo�丕U!N�Nӱ�5Uk�sGی�N�_%t�Jb�*����=�f-����ȫt2�B������W��8%��.�fWd��z���½�๐�~-��8tm9����8pa'��|�n�`���I��v�j��P*���dZ�I��@{��#� <9�Ae@OE� 	��HJ�묛�Qsd�\;K�?��F��J!W�t�^�m���h(*H���5t�ı �y�S�mM��Ò�n�{\��&i��؄XAY
@E�;���a7�r�خp���i�dM�A~�g����D�ofJ�,do�q���^wW9KI��* sS����T�:���H�D�㮡��b�"8�}q�ੋ��ʹ/��#�8���j�?��=���M؇d�^ �ռ�"fB�wߦ9��j��/��]e�7Qqj��hGnE;�	��㋐h��v���N�g��o2�{�D�3s�#,L
k�N"�qH���=�WW	?��_�+��:g�^9����$YOKS�^�I�`!��|�[����C
w��#W,х<�A^.Q��Tyb;\K��]�������s-iH0`�{�h���o��$#��1�fQi��'�������.x3���	V����Ũ^T)9����}�F�D!����n��?)!{ Ƚ�ia!�|6:���t�a-���J��%ib�S"�&���[S�<'�?��q�+�!fv�.����؞���t-��X�9Gҿ��G�y)S3���t̊WgL��\n��"����:���E"-a)����t
���y�D��*�8<�� �%�R,��4"1ƶ�#̓4�,��M�'wQ�t��{*	�\�X�ⱻ݅���ƃ�qQ+��.��$q�`�����Q;J>x��B�:-��Wܭ��[cx���y@�¡�֌@�!u_�]��>a�)��y�����+|/i�5��9yj��+���2���������HhZzz�O)��p�n��H�3������F���-C %\�t��Y�.��=��Ρ�m��l��J������k�>���Y�rA�9v��Ҡ�ck�D��ߋ~mh#�x��.�ྣk!D��0�5�D·������h;�xɲ��$����A����`]��z<�먵r��r���Q߸#�h}�9�\A��vW��_������w��T�0�����Ӱz�9�Χ�,��������{~�(�ܠ���-@ΰ�(:�b�&��0ta���f���%LKI>dg��d�U�'9#s�*�?���U|I����&�t�*e�������r���عVi}td�%�9z�o{�����
�"p����K�/x�� �C7�-#H��/,u~0#VC����u���S���%�ƹ�Xf�=2-��U�Ɣz�ZlE��\6�ǋ��GP7��3(���� \�    A�u�y���®\{����GNHN�ε�u�R�����f$`������r*�c{���7̣�d�_��9C;=Ǵ��J�d�!��.�]9ݜ���y(��N'����*3�d����b�T��w䬡dxBꑼ����YD��D�J�ޔjJ�a�����Վ�ႊ��A�8�C,�C��2̶T[���x��q�TY�+���`��/XH��q�m$7m��M��b-���J� k��u��-G�ڰj�	M�$�"e��u�V�ڵ����u���5�P}�P�lF�i����r#.F��h����ߨs�f�QQ�ަ�;�.�P�����6M��+'���F�GRB6�y�R&�~����=]��p1/��h����;M(g�b4Oz�;s�"rI,EB}�久NF+>i/k)�S l0	P��kd�EB�&��Oɡ��n�����6���ߣ�I�!X&pC�ǔ�
�!��1��Cw���I@ú
%�$�3Y֠H����!�:<S^<[�+qNպQ+g=��fp�n&?�7�.,(��*��͊��:؂ch��"������4Gž95sٹ@��樦r�z�.��A �>0�;c)��
K�u������N��"�/�Ԉd�[������ŉΙi7�3T����rpo�����)@��,�����A"�ieĈ4;
����@lw|��nQ;$�ٜ�F(�������i����1vH]M�q�D$&���x�Z�~{�L�����Q't�<oCH��?�� $��d�[�s�r�ݤ�|/~��Tv!��������=����$��#�RE%'O�5����ԧ�:�������bx�����&I4�R~���A�P����YF���a�SR\S���I���#����ݻ��x`�Y�a��ȭ�o�R�ᆮ�V��
X[dpYa
������bp�c�SW�����)�zX�3,�}-63�ƻP��ns�Y�4��|�'bNg̕.�M�Vf
K�!݊�4����m�G׎#7`�%����-�d��$�Д��Mh�`Z�Ĳi~t�*��>�	q�eQ9�~�G��tܬ��	������2Pbd(��TksݏC��l���5�z�O����z���Z����M�#�ߪ���N
�5�_�8��.i!�k�C��.�/e�7�>�.��`B��+5�赢]	�����X��b���_C{?��W j��2������p(�M�q��{0&���)�1���`hW="�tFS��#:���{~�h18��
�ga�J���pP=�U9+G�Kh��,��SKv�rOMs��_lK��������0�Cb�A�I�Q:(FƑt�8՟���V�=�	�CUa2���ÅAI�A`Lp?;���D4�����-���K�@{y>��U�p%D�:��l��%�Z�?쐟 V�F(
�����W'R�{_����'��/ك�RDA6��������y���5[���w�䝃ca�T�ͷ|"���-�z	�((����O�|�a������Y�/����Y������p�C��q�0,��<�D.a���1�'��#���o-y @F�ɠ~���:��Λ$ʕ�G=*� 	����t�NAA�wA	� ���x+v��[�h�ط|�{�?��B�a9�&gv�݅m,�ڤ|��U"���ظ��}"rՆɜN>�!�����D8��0���STf�����Oì�w�4��G���5����[ҭ��t}Pw(
���|��"J(��'����̝X\�+r�͉;�o����,9g�r��*� $O�?k��G��+%���H�6<�*j�ͰȜ3ط����<uEhϜ8���Dv�^�%�����]96��?$<�`��x�U�0�h0u��W��k��D��j�|�s��Ed8w@}J�	�	�7K<tٱ�?Oj�t�$,߉�K�!X�+�!Y�� $paq��������B���f�'����b� So���iv��dN��a2�t��η�آ�LJ�Ѽ3kQ7��N����{Pbˤ_��u�;��iA+��qFR��0	JC�&��~l���!��UK,N��k���;�Y{!��s)�@hb:3U	�q��U��@�p��T{�xStK�=�k�β������2�<mTxR��ѰUUB�%�ݡ��r�L��w?��5Y����N�aJ�D]�8���`��*u3?l;#�_�$���Bpn�1���^���%-�Z,�x��lg�'�O�L��rbI�~`�f�mu�
�S_	�����"�R4TM8�5E�˴��f$g��U%�oI./��!5 ���5�a󐂑%8Ɯ��ƾ&�����xp���"��`�O:Ke���`?H����W�9�u��yx�%��؜κ/�E��#��r6��gNmm�{�T!ͻ�s�B����T!r'�`�������I?���84�SZ��-i ��L����>�`����0h�9�'����\�w7$�l����Н�A�8oōV�z2�����/\A2�U�a���7�>�a�$$(����0-\i?�$~��YS	��Eƞ+Q�W�0|��H*>~���q��EWA�D���0�YZ�2HA�s����r��4�ǵ#��_�y ?n�����F��ɢ��\�8���ߝ�Q+��E~<	T�O�� �bH�~<#�⡉��M��ܢ$�	����D�n}'�E��7K���uŲ�c*�C�8C.��+�����oQ�-:�N��
�(i���B�^,Bޛ�Ń�eB�wA�@��7�i�4�l�R�BLR�0/p
�[��c��Z5[f�)��B幽A%9��]��j���2Nw}8����W'Me�V���H������O]`H�8��E���_� �xy@��I�.�|�0繘��-�9����T��#�AI����)yrs���>�ʹ���v]�0�����w��xN���m���)~�p�`أ\^�t|?����a"����1	��ؙ�i���u��wzc0��5β�k��vc��+]ާ� �����,�Ό"�%��h����5��Bo͠5�Ҽ��!E)ʔ�Bv�~�S����fG�|�1����T�e�s�}UK]U؂Jn�N���*F��2�:(����Y1��hS�F��Q��O�G�x��2��-@4u��g�TRӸ��.'?G�)C7�J)t�ϘjǱq����D���X�VQ��v�XH�J�Cr�����ʏ��
�`���`���63:�kj
���:�������L�C����xJ���X�
	�G��Ί��&<"y��]�n]�.�.>��<iN'��#҉Ce�y'�1��3I�j�'�:Yd��t�
�����\�rK֚����lҔZ��1�"�'1�!�#$��(aʤ�	������. � Mx�;Z	dљh�>>7��"�9&]\ګE�r:��q�_ԅ�h��*
�P,��*����%,S�,�ޤNZ���	�<�'��4w�V���`�]�@D�8��h�V�,I��t88$=q�Nt����fG91���D=�,�K�~<$˾����Tt6����������#�,�$q���K�Q�/�.�ށ�}�cO��_h��ĉ���~��Ws�0%$�#�g��E�裄,�����8O)us�&����IF2t]k�D���[t!n/}�!QJ��p��K�ɲ��	~�zt��2�-����q_Z�,����s[
��p�{�WP%���ԇ-z���2�l����9A�DIЂ����.R�?�(^<�βRc�u�Q=�ߴW�i ��3��Z���� )8����T�hN�9Jxo�+	W�t��/]�J�����%�+ N
�3ky������:�4��b�S0h�ݖlm���ǡ�Wn+�5����<U����E{�O�e�x�7�MK���<ob�/!!T
�F����lٔ|#��Z��B6�쵱�zf0��7f&��4Mi#y�βǜ�| �����p�"�.���==��~�ĵNy���2�W��@ne����Ͳ����cꎁ ��������|J��6�*���q��Q��,bJ]$J�-u*~    T�U�e&j3�QHJ@�+Ѻx_>u	�
X��*Hp�.R�q"��d���"I/Z.&�;�jr�d	U�+������ǦB6�L�,�%`ؕ2�$E}{R��I�M��<�jgg>\��T��=QJ���.�M������lI�l�?V��k��Qc/���#����0X��'��^Ȍq������!aW:gK��r�}����䵿4:���m�1Q��kp����_�΂�N�I�K�z�"8�<��=�e83��9H5����}	Ӽ��Y�@;��2"�LG]�u�;�������F�nb��(�=�_��p�n)� ժ��[+�^W���get�^ʱ[B���V��e��>���T��J2yz(�.���!���'��E|ðw�;���aI��R�O$�u�V9>Sx�*�$t "!(�iز�&~K�A8�=F��B�5��F�ƣ3��P�HyQ����7|}���K^#���3��o�?������,�3��G�_�[&Dzy��on���{N?�pE�ߍ���!RQLz��8h�*8�0�L����7NB��� �<A�TB�%$
~�Zh�#����r��"d���~̃�Ϥ������|�\��o��ؙf�\�c�;U�Q����Ϸ.i	v��i�b6Z�օ�7ha�I���9��{���#�:>�l��N�E��RE�E���vI�f�<�[������B
}Q��˨ͽ�y$�-�F��*�z�H��%��QDmp���K�����������Wf�I������T���vElA6*������<���p�(N�?s�S����Q�JA���?ױ�sW�ː�|����m������9P���º@"q	2�}P��K����aI���h�,��[�����v�#ѱ�A�ӎ	P��k�7F��E
�����=�掻����2�0k �2���0�B�!�����=�?0	S�"���J=^�1�����;Y��2�%�p�ѳj����o�|�7�"Ee�C���u����ˡq�<0��#��Rѵ)���|���2-E�����"_��դ����Nu�������l$��w��wA�^t�����Xʢڰ��J{;@�y��|j��d3
��\��� ��(����X�̖A����Y��a�!0j|����_������Q�����g~n6��4Y�u���;��To/��1!��և���R[�8,`}��H, 6μ�8��/�h�`|��"�$�j"�^�R�hp��|�sԍ�6X^��q�%i.8�Rщ|A�������Wu
�Ka?�ZnL;� h��=���}��
�|�:Ӡ��6ڍ�6���H�|���/�K�Kˠ�?�}2c���^�z�u坛�;��%mh*�&�&P��a4پ��o"����wFt�pLw#:�^j�]	MC������sI����9��f�ږ�����e��G�3_�s�2��A`?���=18C��
���t����6ﰛ�a9�]����9�����mx\�|q�O�9�OEe�Fʩܗ��kH��[-,C]��'��?f���_{y[��!r���8��=��H{���F^*D^� ��������.�U� c��J��R����ྗ�2:eH#��A��0c�o活[�*�/m�������R���S�Z�RKOgw��̞���;�D&����?h_����O)	��䆟-+�UB���Ed@�Q����=�'î2�ٻ/���4z�,��נU7��i4�yuLlR��&cW��	aH$��Q��F�mT+Q��m�ދ���'W�&W�_�E���ӚWmt�'˚WŻ�NM�dV���d�.Q�{9��>���l�Imq�{�iZGa=}�$�$��w��J5�P!{W��ݤ�ãю<������3Z�,���e�����Sߛ� �~q�љ$H�q�.���<oqڪ�f�-����_L&������J믖5�:zs�0un����;�Im�&� ����F�O�D
�4��Ǵ�s��+�\��4�F���Ps���䃂����JZ;ïs�z�o����X�E�,:�E�il"�}��$��:r${��81�<�5�钑�y<Ǿ-r����I�E@�^��,"E@��XO�1���;�~}��@~���hLBuL����b�Bc�]������W�b���6��|u�qƗ�:��~�X$�[C�/>Q�j��S�yJ5��V��.��	|B�f�Q{=E���@�*�d4;�����e ���A��� 8�t�O�;g���%߷�7�%a+N,�Xe�1�ް'i�6�p�EZ��̊�K]����I���};�4�cK��O�UGOg���@��#�[M�飧��C��v"	j0!�/�y�>� ��' ���2���^�$��?d �h�42� ���
T�qg-�=LƲVXT�ʥU��\d2L���>(��A�@U.̃c��+�یB��2ܼe��̒.���&(�����->�i��l_��lt5܃�,���� �F��_3ڃA���ZX��+��$�u���K{5��V��Ŷ�:R�7˞[w��(�/xȋ��cr��Ke`�w2�A3�����"�2�`JW����-�Bؽ�T�o�"l�IH&9��CA�ڤ�s	��^^��B�媔��t��6�R��^f��{>�=+���"�m75�:1�#U�m��-��J3l58g@���a9Gp[�CJX��3Yiq��[�R�
=��$�P�!>�Ry=6���m�.�S��	,��4�vC״�da�8�	��Y���:�w}��$#��p��G��C�p���������I�:�]d ��6>�`�3�]�Sr�+���!L������%yũ�!A˟T�iYg�������9�
7
� .pBE(��U���r�gP��)��<�q_�"��,���Fa|O��n�(n�fwa��e	m��4gE4��4���T��lo���!|��H��G}m��KP�Se�Ӆ�It*%?7�d�y�n'�-:v~ڸ�m
6�3�
Tv ?xk��kQs���I}��)O?��t�G�l�"�!�x1)l��
��7,l}���qY�4H`8�#�bɖ@h����.�Fڽт��3bѹO毶�WR�( �/�ҝmt9���F���KL0�q�ε��"��d��),�IJ�~�MA,_-ȎYn����W��^>�/��L#/[jc׎�%(�=��`θ��l�,b��H����}Ŀ'�x�7�y��h�/��.M�(%�ܡ�
!$;-3C���բ*���*���Г&X Q���n'*�S#�8�x.{���2N�OB=������G�>�5tW��Գx�V�Q ����PPD}	��#���h?ۤ(�LK�ɵ�E�n<�V�;�z��`�C׆Y�,��^������'��'We���}���@9麒�O��F�)�9��F�O<��`G����)��ʺ@����7�l)��T�*@C��,'���KP�κ�T,5�DW�ޕ��?A`I��	G}��F��^���0���}���H`�Ý^��%�0�d�Jû�j�S`b�y����������a��Ǹ$��Y4��EU�F��s=R;�����J�@�!�'A�˱!rI�5��@3�U����"�(G��O�q0MH�c�`<8�*itWܷx�5v[s`)~|1�R��y_��_�j(�^slj��E����
��l�M�#�#�R�1o�,�tB
�DxϾ�	�~��ήnWD^W������5�|��0���Y�SA�
���Ȕ�/^AG�}js<�2��!F(Ψ�ߗ���Y0R��X�+����FFlos�.��)��	F7��%�(������Ўw�u�f�K!��?��zs�*��{���U����=ekN�Ƨ &�ǅA��W# �P�I?�~[x˾ܢ������W���r�$�ڜK�-@x��׾^��e��3Qc�x,z�2��e1S��q�n���[�����    aY� ϫ�u�t�V)���'�\L�߮�<;�9+~�2�
##�g�^H�Y�S�RY�(���Μ�dZ��7G3q5��4�
��-:���O�H��|?+�[�\8��{s	���-�a�ozDҠ[�+D%6���K?jW����E�-"�]s��j0�M�|Q�J�{�Q
6�ߋ|��ѿ�^�,�\
�>�!��dk�צ)R����$� KP�sO`�xde]�W_Sh���(hpY9���F�B��,W!��җ��nC��hY�dC]/=��-Q���I$:,sJ;�["l�E�>�����h���^���a1˔�l}P� T�d{�m�5��˪�c��clA��q� �늓 >��`yj\,9X�&6IBGw�h:��Й݃[���ՆQ�Y��p�G�Y�w]�87�5�07������%�+��	�4�<��z��:s�?�\�2�C�A2*m
2�N�٠MH�pF	�X�hJ����iV	]��Ϩ6cjj	�'P�nI�ըOjǉ�L��#�i�}���/��]{4�C��O({�Y6�ޜ�o�m�ܳ{�)%�)6��Q�F���h��eړF�a,_�[t�O�(�����@�^F/�9����O�
�4�/�^8�=��h8S����nX��H����0����?|R��m��v�����foR����-sc���Zw������,�b�'p3�ô�R&�.7��;��WU���3�IF������0[l%ΜK�E��G�	�	��c�*^UW	�UБ<������f޶�gN�^Ȱ��k=)\½��r�u�ڕO�B�\_�EOg��8�����?��$=BSÂ�|��� ��A�]��Y�����W���r�5�OM�����M����Eʫ��"�����ڄWF�4S��%j���*\�R��g�0����,��=g���	8�z�?܍��1$b�vl�A<)o�υ
��k��4+8��k��T9{��3��f�mٮ�+�;�;mE��Jb����B,?Jo
��~pt^��/ߏzX m�����9�k{�ة\�)|߭a"c�k(�������i�d��JR4�F���u�DN��+��&vO���^1�Y�,K"��5�ɠL���	5��k���s��flֳ�ـ�L�qŗ�W�p��}<-�WAPf����K���im3M0$~NPD¢��PBp���	��U����e���@!���Um$�}_9Ԧ�;r�@�D!�`,$�t�����b�(L����J!L]!�8
H�5G���"A� �P����+`8�����,Z�˭3C�h�i�-��ᶿ5W	K��i�|vAZ�C�8�[R���T�5Zƒ�o�mKX��T^4YD4� -����-ܝR A@J��7���l�TB
����"c_��w�
`O]|����@���.ܚ�0/��k	3������"S^񺛝�Ls�����.���O7Ǔ)�Z�4H����NT�%��`\�O~7q�{�1����	a�g�/v����R�4T��eՓW(n��Q3�o���k���l���u�H���YM����w YQZd�����"Cc�-1��i
���J2W�'Ɓ(nM���+y�m���B����G(&��\�K�34|��M�#�7�Yf?
��Aɰz�}�]b��Te�Up:��\-Ɛ��~��(A(Pp˓_�i�ѥ<�p.���� Y}$�G�Y�T�z��O��z�kp��f����m��:H��Bj�ێ�P�wtMO�=�¢8i�-y��;� �aƛC��d��e��B^%U�m)�d'_���z���g�Y5�"�O�8��`Y��x{�	�	jN26
*<��oQXZ��Ja��u�^��`�( Z�\���<]��}�su��i�xa���f�cL��L��į�S"񗨳׎Q��8~u*;�>DZr��H�?���O %$������xwl⑴��GýSm�;4��-yG&���L"�.�Q�IQ�b�R��tv5h�v4�4L�'�9w>Ff�?���ˉ/��&�:5�>h���ؤ���6��``������#w�1ԔA�n $�.6xD�]QH���h�Ѽ]� ���
]E�_Q[�>!ˡ����%1��E���I��M����[�7!��/������S�B�2��6R��23��@�m�R�_���XR���h��o�Y�t-1�*�eZ6���"�"q!�{�Kz��)nG� 8dL��hz�	]K�+��M50E��1�K6�,�`�`M�n�({j�������WV�o	��]ݞ�&��)�uk�$'ˤ����F*@( Þ1�A_�lG��+����HR�]cȪD:��N��=�Au/�᯦�h�����S��>_@�LX)��Ve�,r����y�2ɨ�qK��Rr�'p����`e�_ro�R�;)a�e��8�V�aX髱$�0hs���b�RgG?Y$I���iWP�����'1ķ��������LO]!Ь��, ��W��Û�m琪�@�(�Nh��d�pJ�	`�AE�vE��iy�E��ߤZU����2��Sx$eʑ>�m9���o9�(�f�n���aH���M����c1�J~̎=�Rg�%~�>�%��dJ������1��m����f�Tz�
<��s[#���נ���yOe�󛏄�h$��ր�q^ey痳�|�p�)(���
PyX��j�~$xz�TB��wU ���Z�t��(H���5�y����z+f��DZ�i(0��C�굴::OU����%��*��m�aǸ6oUO2�99�!��l�J�����JǢwڙ��#���r"���ih�+���F�>�U*<���A4%:ݑ�K����hP-~�ޢ�s�9���_��F�j���c�#���{gr)�H?uE6li��lG�r�T�����/�LVI�Mj�n���fd�e1S{lOd���RB�وɟ}��BHɉ��F�i��|���O�����qa��,����hM;��9��	��Sz>��H�ۮ��_���Bf��M֚� -�9���I��k�Y�u_���ȩ`FIb!t�h ��z˜�������P5;KO�T=�Eu����T�2�[Kx8g=BԪ@�\A�����ԿS#jqq��;�Z�����G����!n�Yg/vb9���w|đ�����lR.X!����3�	�Rm�ܜ�IT,�\�"�mm��A��Q��^?P:w�-�9i�6>x�?�>tn�Dߙ�푖���a�	��r�.%���ƽ��q��|_�a{I#Q��B] KҒ���g3n� P�ȿ�pW˩8)[�4��S����7�H^�N�sz� @��1�B������$�t�6ƻ~5���t�m��~ə��o����_W�VNd���ݦ���m�\'g�vx.�co��Fe��K�e����,S�������9L�s�=O� ���	��ða����{oǞ%�実��%C��by.��O�����)C�-� ���w>pp�WS��y���ɢf�4g0��W���������a�,jqJ.�0��Gs�m��"�	�D�{�8j���עV� �*�[5,�<q�$�����*�� �ux;.�Q{G�J�i��=���Stu��n��r�`����d��1�*�$�ކ��w&�7�-�����/�?�^V2c�{\�D<$R�%��t�aG��:p�'��@��#Z��Ç��FG� <�r�귃�R �0��&��#ؗh�aGr�  D��S靐�!=���4�����P��=(�b��<^~hM?��V�� ����o����7���$�ؓ�'�$E��~�6lE�'W6>~f�f�	|@I�w��*:V��;!�-�H��.Ke�D�:��+�A�|���I�C�]o�
N�D��2��t��`R
·��n�v+"������<�t�_��	���`	�T�"B�	!D+ۅx�2�P�A�뾅;/K�9E��&⤞�|�6Pmz�ɑ+NL2(הszD1y�9��??i�����Ӛ�7�!�(��ps�`T�4?�����l����̮N�i    ��#��	�ZUA���w��a����8��L��O�l��s�/i���)��.r�|�����#�ep�]?wj��t�j�v�z�8�V�8"./G�޻s�Cو3S�.,�K8}����85��T3��m����B#�43~���÷E3��W�z]�5'�1n�é��1��lN���Ŋr�{I=l�����$�5n�޽\��M�8Ľ+8ӑ�	Gf�xb�����w�￨!�M�h�o�(,*�6��Ǐ|�gܤD3������Bg�ّ�c����<iH5�o^��`I(~ym|{O+�iζ��yˢ��|Hz�9aֆ�+D"��iL" K���DA.��D���(��F���(B�"^Q��2*�F��r)��`YZ��L�S�w�`�R&e�`�D��9���]%�����'Q�|�A@
��pI@=�A	�+^���xq������H�-���n4�e��n�ޠ�E��k#<R�9���.>���`�q�'�L˸����kqd
y�2��y[��}=_�E-U�Pd�(�M�߸ᠷD��vS�T���Z'
���
1�i`E��&�g=	*j7�Y����Nm�@Y罬��QZ|H��Z�տ`V��ك��l^��=����.Ɨ��G�b6���U�<�4+~��4��nc<��9�}��/"��kj]����~g�ΉD���PJ~�sS��Ә�2���)�[���݆�7,M��^|��@�3�C;W�u�%����J�¤��a7��}5�[���p�,�Bx����l �O��#e�11�D�F���t�����|.�n�A$ �{�i��E�%lF����b��"?�4�ۢ��C<�;�3t��y�vqw�P8$6�I��M�����
.rs_��pµ	���m�����\Ǜ0#R������]PC��-Ȩs�(���m���?�Y�p���/\s�A �R��b�אʷ���@?�v�e�@1�n��,R��@�a�P�ġ�͠�������P&	O"�d(��15���1�.�
(ۘ�}Π4�'lK~b��wü˕�\�{����e	�Ѣ喝Q"kX�a�n*���Ვ��0*�
��RX6�a��`?��l����}���5�M �Dף�Vǁ}Oڨl+{bt���*��V��A�_����R�(�<�F��2��eE��!Z���4�"���lQN��1���g����-�
^�z�:-0B��Ah�2\/���G��2�����n*�� ���\L)ɏ.��w-�B.�/���Z�#(���nT��?.����e���O�0X W�/�u<LO�ෘ�j}��әDA�uʠ��2��
����2}�4��K����$��kxMꉉ�4hý�Td*i��ֲ��{��õwC�A����>=p/}wS�#f(8@F Qs��4��e|�}�ց���-�[����v9%И�%�TJ��p���..uh�F!!h��](��cJ���)�F�hVfW7/J߄�(��=h�x:��}
W/:�z�z�^BG�9���La�^9��tx�t ���Q���LsC�`P�J��/�^9�S�D�+)�������!j�x�dd��Z��흰
��Ȃg*�����y�+�����������Y�CRzr�/�ɰ?�.�!7��IмO���DD��o����8.U/H�O	�ᖫ�N�R0h�I�c��	�ܽ�����Aį]�-�rP#�|���rz!�32\�v����+�3��f�&tR'Y3���c�+]%\��"A�7��b�B&,�D����d�#�����L302)�2�6n4A�&�@����fRBZT@��h��Z�4-H�2��I�zG�ё$<EF����� ���J
��c��(�k�Rh1s�Ok���<SQd�S*I��G�RN�X�Z�����PG/�EH�r(�Č��֚�(�,�������J�g��5,��
��{���G�8s��S����PǓ�Fт];���K*^Q���!@:Qh�)�9^@}*���]���W^q��F��-xo'tjj�$�`�bh�KZJl2��]��Qh�N��)�y<,�k�8(Gz
a�h����E-8}ŒP��ުzv�4X
?��[���pUg�,�b.m����}�����Z��:��K'E��a�i��w�/��9W�;V��"��.$+EtW
i���a	Y�{8������.Xln��	�,���a'�{�p�h^�i�js��=�/��k}Rq�H�"C+,jYU緓-���a!�7p1���,�C�K�����vӋ�N�|����u�Դ�t������e
���Q���kgL��[�:��&���u��X}�7u����͊�N�{�����KLq�E���ZeU� j���^͏E�>�ڛF��>1�7k]bF�Q��u,�A����ãP�*k;}������@u�ik�:.�W�Hi41G��΄��hT�#X)�[��紧��T�Ch�`��#f��Gѵ��6pZ����g^.�m���9�r�~�iy?�٫�1qV~[F������jm���L����5#�O[b�c�4$�د�ё^�6&� �b��_� �>)��ۻI��(��R�Te��7�=e�e-ޟ�McH2V��{$A�l5�I�_���l����}��f�	q���	ut��������Gx���ݶ{[��!串�������Pv����_�/��_�g60&/���an�ݸ�k�"�Аk�\:�r�&R�"���`<������@G������O��8
}H�����=D��e>G��]\�ȧ�q�N�=i{�Y@�N��aF�uzsZ-N���y��!����z���(��d�F�V;��mF��,c`.T�K頍��hG�B��M�5�ʰ��7���T@v@�3;��%jRu9�S�9Z֧ҋ6E�a�:kv�j��)	0�#���@
�֓/��MA���V�Y��� l�O��nc��qp�Q|=g)H^��P��`���e6���
2�ϧ�nw�yEH�-�%R&j($�&��!C7E�@̂������\��=�8�C��?qd��Ɖ�΂��V�SB�[�FMK���R��*3���t��<���J�O��6u&BǢ�x�M�KhGqY'I�(��·��TC�{.6n|��3��|��4�ެd��C�5�`ڋd8�(��}���ڿ	;Bc�����*T�0Ա�b;E|h��T`щ�.�ξ�V�Z=��Ak�P������K1?VLyV*M&Ȳ�c�w�M�Q��9�I�dm��4m�Pi.�d��R�9^���ps&s��*~���ε�W�S����^��e���4�#�����L)�x�@MczEeZD-�؝���U}��p��KC����8�f��	mH%4��5������,�g���9������LQ$!�Ȅ����V���Znwٷ�JP`~"�a�[m�	�V=;T<yFA@Nf�U�����^.a�F��-�8U�T Q4�?�~{BGO9dβ���l�bLʬ�h���M6�P��ڭM6�$���}��=���QAkl��Z�'Fא��ۏә�M?�{	Bմ�-v;p�f��z4��[�ՌoV�\E�gC��.��"���$�k qbuP-��J�#���R��E��f)�еj��:j)	���>ş��r7�Dl4�4*#�ƨ$ՒҠ��H�Z�3]�"��
��4���2��Wd{]���[Vq�U�;/(�(>�<-�9A2rT�>�i6l,��9��R����@��qv���w,�9��J3)6����av�.���q���
�y�|^�;����緀3��E��r�`u.*��@�cU�9���נ��1-�1*�����'�[GY�ch���l��Ъ���,By�|#f>�u: 威&*�d��ɂºk�AM�E??�5/��tOƚd����p��H#�Б�k�U0v��uNjk�9�^�Ug�6��d������ؾ�g���E��k��%�U�����84>%rav����Fh�P�-���h�4��    Tp�+�,u�O��dH�GYe�K�Lö�J�(ߢ�J+'gj�y[Z��OQ?E���NJ��"�*�
����ZUeL�I$W���{����_8���̴���3p�D^�:A�L����b⢎�9(y:�T�tD�T�1v��d��V|$ல���?L���)?Z��	&��)'���Z
��z
#����H��Z9�6o�%���r�ꔐA�1��[Ȑc�6��hf��H��b"K�fRo��=܆1�XШ.ܡ����
=2�v�Q����	ta���<��-��9"b�[� ����)Z�伨�Z_�&��Y�-3���W�� u����=ѝڽ�����a0;5���)�����U��a�;I���l�^��-$�Ѣ{:�S��y�;67+�7#ݪ�7dXcC�HTXp�������Ė�e�mɚ~6L��oK��10{m�������)�uV��1����{�SL�T.��^����{K���d�n��tаև\�іn����g�P��Kn	�[Z�SPba}�������Ib+_>E����/�!m�2J�<��DQkC[xnjZ����`�jZ
I� @2�dS���.�{�]����Q#eZ.Ap�a�o�����2^3,�lh�T߫eN�ٲ3�I���,�(��Y��Q�Onm�}�|�kKsa��M�P��Ss��q\�i�H9��R2;����쥑�j�<<����'{���܆����C��I��	��ݠ%!�h[oYUP�Ҥg�J���f$�v����U�vQ�>l[�ک��\�6E%��hb49('!̴�9wi���`��LF�ԏ����㼶,\L��'��5~�� e���s�yJ�⛪��{��Տ�F��/&�H1���I��y��w�J�t����0�*e|�WqWA�5�~W��Ю�9vfa��7���D�n2AV(��)�f�`p�I"��q��5�����(#���z7�8��2I~V��~��O�>����@i��!Nf�^7�ڂ�^�r�$=�B�,߮A5���a�HˢfM]Y�`�5�s��`���1	15��8�aj, G����m��[�fS��s��%������wݜ����S����T���]A5w����w��;(�W5C7\�Rq�%�P��꿢aG-���l8^��.��OGo���'�fo���mv�����QwC��]Ӛ��Û��4[���B�r������v����P�h�2ܐӵO%XQ�/���
���5��N�7���t�s4���st�͵R�is��xn�\�ᆱ�~�Ac?%O��C��)���@��6/�Ms;d���:9��@��.������&O�D�P�����!$��/�6�,�Z G'N�QP@,��e�/.8��$�5gz^��{�5����y�$��h[!j`�n	�G��R�t���������Z~H.��~��w���#$�x�B����ݯ��/ �i�'��0�̣��"7o7}���e=�ʻ��Xz�֜�ؕ��S�๜S��h�^\�V�Y���siM��B��ēk[O&�o}'~�޷m��R��Z{�ģJ-F���@g����޺��QB�v��!د�%����P��8Y;�LIjT����a;��+�З#Oy�����Ώ������*xjȿ�w8F@4����f-L�-}�m ��@�co�ȴ�kl�Hh_K���Y���⸷��H��p�m�����Mg���Tf�%�iܑ�Q]��--G��Շ|
��ic��a�j�%
|��h!�A�ln�y�r��cttAD�[,��m�(��
NCk�5�[��n��u}8��J�|1�=j� ޔ�
Bg�{I����tacR*���Z�M^	a;��!8{�ӵ�_�����t��c�x/�k	��T|�.�rj�Qp@3�x����.�����,�ͣhި���ײ:��ÿ3Q�h���udVI G�G)���Y{������H��;�3��L����(�钖�_ �L�l�e�yq�yk�cgE"H��<ꠎ��I�����A	O:?%�A��Z6�FX`�5���-�G��-�����0!<!NM�j߁�K,�`ãu��2�56t�?k����uI3������_?�7�£p�/��o0�C"1�ڙ6�$.��xݪM�?��|�������T�΄$)���+r�L�-�^���o���\��o����4�2����|�b�1�
���ŷ�S	�a��?b����S��q�ki����4���¥7	�9��^��(��������\�&}���Z>k.`��!u 睰,�v Od�� �������"��������5M&�pU�0�&tJ��x������R9�ӆ�mq��r�ڙa�ӵ�����	���AVw8<.���7Ij��h��̧�m\nWz�`y�ۨTFU5�ᳩr*���Ssqa���6�ې���w��5���i����.���5'�b���X�� ��Ns&�!�?q,����:�V�a�m&"#m��P�Һ�j��s���)���z�;%��'S\��ZD\ql�Ӊ���$�Q76��:��OtuO�~��1h
|���o�H����a�?9��z�B���d���Q֦Ơ�+U����c�&�����5�������K�W��@�܈cM`k�i`ȚH�0u�m�쬡I�T|e�~
�t��h�D�!����ۗei�9��<h���?��H�r�a�Uilv��:v�ZC?�q��j}���a4a���KS�X�T8R�Bı�^(�ĵc�L�l�$T�e��=Mcw�y&���n���h�cݯ��Pi�]�	c�h9��xPj�h=N�T*�a;�b�)�m#�F죠\����.,a���w���H��f/��~��߿�x.�7�#ܖW�6��9E5=�j)� �5^߃*0���G��9Q�AH��8�ͷO���N6�
����8�ᔜ��{P���-����l�&�Q���Cޘe��E	�o� �Ӫ�-�hf�if�7���P4(�vA�/��Q���&]��y]k�����fCAΉ���u�~�&���ԙm 9�'�Y)�14���7�rh���o�dC�0_b��4�7.�h%Wr�<�!��D;k�<�u���J�D<�C�g6��a�H�G� �٫ ����v� �H'^×��k��E�qgm�9�Ż�LS��1R��G��r�<1�²��VN�|P�-��\S����?<��n[�Z��}�<�ܒ��;*�X����:��J\�Շ��������$�� գ�=��=�ag��xχ�};�*�����LF��x��"���ŭ����
�4���M�=����d�>=/�`X-uq{5�.{��r���P�;ho�Һ�����Q
c�?�L��DU�*Ё�%_ ����M<�
.����,��MR���%��x�_)J�ʶ� �-��s�g�s�Y4�����&��.ܘl����g���u����ݮ��11ehlnC�<��M����g��ֲ�;qnN��[�(��7���I�2YĜ��Q��W��7��h�oӢV9\���$͟$'��=9d��+��u���,��gO:�7�W�ڤ'p�أ��^*�zNٛ��uD�h�� ��K�`���;q�v��,��ڙ�!���#Qc��m�d�Rja{����i,�V��lH�F,3�m0���6l�"u�uo�1�T�#`�܎·��"��m|�����U8Z��.�ϡ'���BX߷�iq�����%9�&|_�x��=	�w�o�Ix�Ɔ2j_�M����lG��Z��7���u��k`�ص�T�rSN"v��W���Y�h�O���!�O�q-yDǥ���w|6�ܬ8RI�f}a�c�Pja�˘}W��Z;�S�lϔBci�΃,�~�<���Q3H�,��'�(|� �A�ХX�pR���};�jJ>M�p}�F4���k��q��~�!�6�]Fo9E(��d�4 ¹�N�"�\
�Hs���x�wDN�BU;��i(����UZ�� �LGʭl�D&��)�7����QNi�$jZ���3UǠ ���oM�<`~�î��K^P �    � 欥8� f�ŗy��n��NC��9~�79��w���On.����9�\v�c�/�c�=�d|�P������Լ��ѫ����Yɘ䌷~���N�R�d�x�'B�e'!!����-u�%+J7a(����~(Ap����b	����&��F����/�]R�%�v�=u����uC�x���"��o��Jn����8&v���� l1{���U}o�
�Ck���$s��m4�O�m��t����0���O�qә����6�j��5���%�����,���YF)��lG�m�.�)ɑ��M�?��d��L�Y�S[ɺ�-w眩�6˯d)b^�épP� ��A
�ݗ�}q]�x,��0n&��h�臇�ρÔ~�G}���1�4����"��d
-g�p�K���}CMf�p��^oB���(R)���n�m�JZM�_�!�֭y,�:l���_XC��`�\�6��7�D
�9�J������ H�6_dk�N�)��K2za��:zJ]mq��Ã�g�p�`��C�ޕW)��1
j23N��n��ڂ�@�g(8_Ԃ��CQ8�JOѯ�i
�p�����pw散������'�˛�6wo[�X�-����H���<
���{�<0po�qy	�������{w�
 O.��vt��'^Z ��K���"~}@��$�P\U�O;hA�B-���kbD�)��_�߹�+Y�s�L~bq�2��2P��l�9%/K�5���iHgJV�x�鄊��C�V.�4��M����b��TuN��.�d��To^�-���(�7+����ws�#J���+�����x!��t�|=�3�B�bB�7���2�tr�"U�x2M�z��Q-�R�@9X$}����$��Ch�����=����r,�5�c��u�-z��T��*R����v�E�V�ݩ��鴁6>����Tɋ/Ǩ�Mnna�I���qƄިT�DnJ����\�@��O����yڋ�:΂_:fb0�O|�I+�$����쵄����'f�(�e����H �1Ps��6�5�'Ɋ��H�c��vS��O~p�g)3�O�*?+�H�������-��~��@��8���v����gwt�N�48���� gl��:��蘽	�T`G�O�1���.,�pR���Dy��f*�g�����(��Z�����_Yր�'������fڏ���yq�9��p�<����Q��i��5�V#Q��$Q���,q h9%�"I�\�a�K����EA7�M!��z���Y!�S�w)|s(C��\�?v��\V�Ǚ���N���t��:96&�F)W�#���)�~!{��Jz�Ӎ���%��̳szd݆	b4�8�!���a�#+�n1a�>=Խ�A�h��~=��ƛ#K=� �vE��ӌNɧ�4޴�L��%�r���Cz6�L����M6\}
e'-đ>�a�IVrhv��嘉�	+7�r�]*�A,�Ǥ�y��$���+]�S��g0-��n~� 8~����*Q҆у>i��r9�X�EZ§J�G�cB$�e�6��<븨71��e�Wy�g�w�,��f�5p�I�;�m�wj�X�Q��R4>�_%��yP`�A�����a�5�FUpy����"|f�I���H�_A�v�P�x7|;�N�ݰn��z�Z�.�;\����D���4%�8t}*��C�7"�4�~�I�q�S�R�&���;Q�%9 ��DEA0�	��PR�@A�5~n��@��2�Y���K
�r�`�B�0�/�Z���ā������y����8lҹ�h�I:�s,3�o��3�`��:�}8j�,/`"H���g�y���%@�= �al�>�%gEXƳ{+�k%��2��D���*��c����O��##q����`�8o�zO����n�L��t�G;���R$ur/���R�Q�J�]��m\s�ꏀqR�'+^&��8Ny�Ă�?%9�jȆ�t�K[�I��պ��!�Afz�� ���ʠ�s0h��Y˭��G����]�?��Rr��9��ř'Rg��� �#>�Pރ7H �� J�8���WϬ���އ�L&Jt&�2���P$v�R��a�r�SK����jl�Iџ��R��KLUM��[���g�v����k�Z�и��iW�-��s�)��/��@�Cח�B������!���#aVݔ��L��r��fI�(�k�'�k7	�"P�������Hz��H��R�2F�&;�BI�O�( ����k����5�)��yw@�]
#��o�\K��B�:(mmbR7�+� >�͜��:���6i���"���hj�i�?��͝:Y��S"�\�M����΃Z8̞=k���������A����Pg�p�4��+'��6n��T/m�sjW�Ip����tD�m���1H/�x��Ψr`+���]�	x���M��b��� SDۨ�#"��v	��h<�AJ�h�z��I��{x�qP��]��z��+>�|{%��!f�L<����>U9�@�|h��Eqr�f������YnZ��c�6Ǳ�QC�untKR�@�20A�pބRҦ�H� ���8�B2q����c�.�
՚���G��{vcrp��I%���I��c�+�E8��Q� OCʹ2]L5ӊp):���Ӈ9s�P���RΜ��~���a{�y���޹����c����Mc9����L0�7��m,��{ӄ���Ʒ�P%s�%�����7��J������ݪ}D,M
&��;��ԗ��`�t��6��z��ګZ[�Uw�&�M^F���=cD���v�
�dڝ���tY�B�RҶ���'��H�鴌�o���y��'�N��p��:
�����)���ER�I29��w�Y���]��K|�k!qQw�f?��l�p�a��I�U{��@UR/>�[�zIȇv�Kۋ1�(��3���'�����W&�P`N�3����?�����h�RKe76o�y/��d��c�A&�7ďߦw��ƛm�m �'c&V��m:�$��m҈6ߏO˨Z0�T�KT�p`��	*�$���<�����*G�P$I����<����͓�u&h�ۈ�X"l\Y��B�mH(g��{I�
u.���7e� 6y/�U��Q�H��a��~.=X��S�B[c[�h���Q�,1G�Js�:���n�m �N�޿0;ӵ.�JnZ������)�	gBJ|���E�6I�T,j�;�6�c3g���f�6���$�|G#�:.]�M�.S���GB�z�q�I�Iy�zb��������

�0�s���R�a}q����0�z��� I�r�z��w|)�ĕ_��I2W(���RK��<K��M����R��i���$����M�B��.�)~�Q��R?"a@@�vp$.���"���V�����4V(!!^tM��tρz���=�>�;P�J��W.y�@��Ŀ����M�h�t�P-�U�vWS����aO��0� �}5cF�qx�`HP?G�-�o���&�S���-3�^x�D:H�s�l�D���^��DY,�a�J����4�:����z��S���2?�1���7�D�ͥ�|��n�yύ���?5�o�v{6MET^�uz��e�trt)՘��Kq�z.��D����i���u����J��8�`V��;b��\�ǐ�|us��0�nԆc(�@ű$����z9�ks̺����UHbW!%4�;�ksN��D�D�_Qޞ�J�ls��d;T�)�&$á��M�J��:�Y�tD�]m�(W:���Spd��6����}`�O��Oŧ�7�A�5�7Z%u�e�d|0�Y�^˧�~���H9����.��r#.BUӕ�^�T�5S�(�.nMµ�+	��0��ꋔDrW�%�RT�m��
7n)IfGN��&��0�T[�>
�h�>Y��\g�T�כ-�m"\�J陉LF8ݶ�?���qEi��O����	Zjp���Q�޻���"؟G�yQj�Kl
��_
UK���    ՆW��
3�����M��޺?�2a�}�(1�4I���2�8�5I/�ء��<x�\YMv�>L����s��oe[A14�i
��ɚ�q.�?��=f+�ȱvn8�ԑ_K�X�}%�C��'t�J_���TE&��&���ONK�M�{|���tJ�ﺬ�D(������ǟ"�s�7�������i���X����;�][Ĩ瓸�ķx��v+!�#��&y��ߟ�HIJm����b�I�d�ћO'p��cʅv6a�?�~}��8��N
���FAD����	@�S�C�H'��0<�˒>�<!�.�J�LI2��˗�!��f$�K~Ҟ�_%�K��'⍰��������UU9�Ӎs���VAR�8M����zWG��m���-��`����
��~�<�̳	�c��~���7�r�
fEp@�3�7��GT�
HN]2�҇�BZI5�3�^?��0*)YrDr�s��[q�!�k�G�&W��SH���4��uI8!1���fv����"Q�%��w�GӪ����eٶwe�)�Y_n�m	r��#�F�	��(e@��f��Ƚ���ꏲ&o\&�J��	*��Q��fW��p�j�%(�t�q�e��a�f�J���?��cQ��2�����С$"��J1�.u����	z������WŮ�:u�z�3��K�NM�������P��/�ح�e�9 %�$�[��.P�r�y�,��Y����G��V굘��s���g�>?�g:��P���'TkRo��v�n�|�jL@S��)qc�nk��D���M���T�@���!�o�Y�|�KE���9��PJ�����6�4�:��:�>�)��>�H��cJDe>����kD�H��L�Wv�H*��徸�ZA���}��iˆV�������_ޤB�S}�迗>�\�T :���1%P�9P�r��:�¶/��Z��̡)�p�OK�8E\�N9(%]��d�v�#S���*'b�-�{P����R���nš ��]~6ݰ���56�� =�z�����l�� ֎$)k	��S��>�5�u`b�*�Mn�NE�}|-~�_C'��)���������(���o��]�k�(��T����t��Z��ݧK����~����D<a^,]wk���{Qs��3z��յ�8����Nͼ\�%�ƞ�c�]x�)� �I`39�E�T-;�'a��~%��6�6 ���e�RΎ5�§��"��(Ԫg��ے:>�(?&���	(��f0���aRT+S��¢vS�L��R��h\�>��!D}�X	qI�->ω� �!�K�o�[��zA��A�8�%�M��BA2�Y���4,�[s�KA���OiP{z�P��_��`�]�oSo�!�T�X�]�JZ>ήo�rfwK:y]�N��G�j�:������gj���0R]�L���5��$�2i]��u�.���b�LG�q��o�& �is�2%��-���v��T��p����]�EG@�:/���p���?e���h�l��%�AJ���Nҥ�o��,�5���E�YBŒ��.@n���#�@�H�g�@ �a��U�ȗ���r���A��"��ܼD3��R�88���ª(\�4'�6�$��y��3x�Q7�^�tN{6����ҰT�D�:
cH�ޓ'�Om�b �2�����1���G��2�6�fg�T���/YM��Pg��K�#�";�ː=�gh�X�����oM@t�ŗP�M|�s��hn�/�^yQ�m����#9��~c��\Q�jӦ�H�|�6��	�����fY!%�i�̺��m����hX)V��Q%!G@%le��I��?��H�;�u���.��^��������A���n��Y,,+�T��z��1�2��n��	����-D/�g�5C��e��M۪ KJ�c���E�
��ARR�S��o��g�4�����.Y��tnU���ָڵڞ��h;�^a,%��:p�( �(�M�[�����Q�ߜ���z{8�?|�'G�O��p�����NE|Ej���0��I�!qy��m�1��O��j��9>ۓe�9��_o:�$6G}oz�8��I����B��?�N�C|�GA\�8W����͚�Ym)��@U+��n% Ǒ
��/�Oƛ"̜!�λ�}�X��Gv;��ѐ03��ܜ8��N��� ��8����4L%ާ=�"��?R��U).�N��U�v�S0���[����`J�.�r^����յ��i�U� ���V�J�'W��Ԩ�l��T}��o���]�bW�qud	#!���m���)Ȱ��Qub�>�h������Ѩb�ַ��GQYm*l��I!�Z�[�S�8��~|�j}T�b���$��H���uJq?�V_��$��U����|���^�Ӿt��bi9��w�"5�m��"*�Đ� ���F�����p�����l���t� @e\���uVwڅ)U$�f�\��i�D���I:&!��v���2.&�� ����2��=�Sv�r	�1hn�i�yp���.��`�ࢂg�N�3��mܳ^��l�mٳ*���D�j	��H�iD�� �Eg�P� uF�B�6��]4�����7i��jĘơ*���f(�aG�J@k�ΫD��#5��䷌�ϊ��U��e{5�3u��^���S:�[�,�� ��2�Xz�ᮏI�x��P������)�ҽ���GK�L�V񜩢�ʤB(F�r�>�ز
�*��9�i9"B��̮aXMaX%�p���r�f"��Z�@�����鐰�
 9d�y�m5�Cv��ǥ���ֲ�6�<[��M*U�f���P��e7��Pb߶i$��H��i$��2�R�z�^��LʫJ���(@��/�D�Gk�b�i�%���٦T�	D.f~�.�a�&׬�
�^�"��+ut��WWLԂ.޴ĩ�u⬸�	"�
�/"��;	E�����d������z#�9��u7�T����X���M���B�J�W�ni�B��e�!b�qXD	�����^��w
��	1�ڞ���`��{�`�D#���f|Lo���G�ë>	������N%�DL�B�,S,����ǣ���x�^ʣoFo��nQf�9?X�p���s�Jm�����h��C��)�i�����A��[�Ad�@�<�'fbX����𴲟�ɅY����.M�q�s2�oD���@����͒��Ԯ{xgK
w=ܒ�P���᮪A���F�j���HVY���,�!�j4��j�2�6�%&sHf�2^���X��R/㎮J��(o^������[�rʩ1҇��T	���r+*k��5J_�_������l�_�X @ac-i��� �l�������d���淆N*��/���[��6�8���I%�O��-��~.Y��XS8b/�_>��
;G�]_6�8��UQa�s�g�nS��I��o����8����mH�eL26ۓii~��[�4�&�a���e��~�M���B��RRz�,kU���y%���U%=��'R�,2P�J�n��ۄ#\��I90��LR�g�_�"��&�����n�Zh���f�H&�o��m$�+��i[[PR�,>t�� �J���f<�0�S���>B�h#nw�)����>p�=�MXǌu�X��"�7#��:��u�P���@��P���х'�4�\7 Z+,!����a��e��؀�aՄ6��fCT����RՆ�c
o����?�i�E��G�B���1��qi\o{�.�-@�nt��ظ4-t*"����Iy�Ҝ@@����>|��j9	B[�D�x�i�M"��@�c�m^�Y��͖����&Q�v�Ò��G�I�8-���~���L�϶q�Am6������I�WCՈh?5�A����sv�.�_�,�sȭ`��.OY����2�,�m�<�6w6)�!%Go��A��_�1����G�m��Q䜛�a�ֆ8��un��D�:>��1���D��U��a�ޔ�0���&���ZK�y�(���O�d5��=�e�<,�����B�S��-?��(�6&�� ۏL    tve��M�g(ȏڲ��DOs[(���J�\[:9[(Dxfo��KR3ݧ�'l�$¶P�x�,+�c�}:�b����n����J��\�4SO|5R!Mȩ(�:g�m4��F�&�a�L�H��ԋۄ q�Ŷ�%��`�J��Żg1�~�)�Hl~{�9 6�Χ�@p��JP�2�]�d.�|6�5~՛�G�܅.� ꔒ����|c�C�^�[�_�/��X�^�c�y�a��;Z�����ބ����S�˄S>��K(�`��|��!��M��O��C�I�
�X9P���b�DfI��%�#_D���1��{��^E/<�	b�ESDDK��%����r�a�l�p,��
���Q�2S{�r6o��p(����8�͡-�L�d~��̍n1]!���]���9����)*��g-�s)[�v0�\ؕ�r�rꐠR9�ij�����Lx�}q,�Zs�*��Z�Z��/K��eCY�-�0�`R<롞Nx"��K��&�T��,D�{�֥7�T�U�����rD�P�cm�8ʱ2a�,��XD�v�����U�>����Z�yw�0A�S��,a�-�矅-V��:=l�+D��i:o�>���K.�m�m ��E�	!�4�	���.4�&~^���^=D-8pTJz4�7(�$�J�K#
�nS9VT\�7"0y�0�iS�+y�������kkۙ�t��KT�UiE�{C�7�����$9��.y�`t4|���♒�Z;�!���i8
0j�s�}Р�rT��v�:�6����#��\Em�A�����nGrIqcP�
	�Kh�J���������k3{���(�fq��=Z�����?�h��I~����Ѥ3���g��8�J���P�\�ѽz�V�3��l�����h�^���\n��
����p��c�~�(�?���2	�^L�J��Ɂ�{۔8U�������u�'��޶�䂯�N�HN��{w�A��� GI΂(-��8%���{�bV��Q� ��[�&�T��v��#Ux}�<wq��,[$�+��l�0��q��8�T2[*����8r���y.Bo���AK!�������㤢Y�� *��_�� �ؽ;�p M�|4�X��]w��(���'I��Lz�M%EZC�;�JAX���9i�(N�q��X Ή;3.�̟��$2yv<��M�=g��1�ъ�sIv���p *�s
ˣ,��7���r�m������I\{��m�&)��U�Ŀ	$�ܳMA�0�c�z�MMJ� W��H�`,c�q�'�e��1�:U�q�4�S�֛��J|T���+!.�{JLh���u[�T�ŝ�^�w/������=I(����6ٰ'�Á�ƅN$O��⯠+��ǛeuY(����Pj�ǭ��M�c3�զ��߉�D���\��.�>��Q�4(PJUa���P�G��3�s5�@1I��
C���(g�Z��(����M���#T���`�̖�R�Tm����xi��$�ۏD��ڔ1�c(Ev<f}0B�`T��kܴ�)E\��C?�#�]�Q�z�H��/
�R`�yh��$�·�Cp(���H�zU�P~詒��
�y��� >>ۊ���d/Dm�P!�����'*�#���D@������r�����z��K�z��
�186��ꢕ:�P�Z]T;�?O����gN�W�cQ��Z�a�{��1B�)����WӃ��Rf/�-��8[��]��zK��Aa~0]�Qgg�F?zL�$���b-�Ŗ{�w���7��MOʩ�x�5����R�%�I�On~���i�Ar��qAW%�2A$?����6U\��]G���US��t�*Wa��q*^��� �D�ʄ�s�N��% \�������Two9-��X����4.��mg:�����k!K�
�k��ʬ��!�U��hk���8�8�\q8JP~s�s\jUB-�r�;��o�%X�_>EJ+L�9Jn��:eC������4�4������!$:�
\�
@�?n��,<��l�j�1���v���v!��`Z��z��|;�i�Po�2]� H�C������0�JՂ.gY�UoZ�ck�7�t� ˗3����xD�a������SN��n����,#�.�s����PY�uޮP���`����3��q���f��r�<,��z�1qע�a�����R?)P��҃�ϣ�����������"������}vNl��`��hV����!�-�9?[փcZ�%79�doA���	�]Ze��f�mx* &]U*LO)���0^C��\Jvhu��Ɛ3J��i4$�����m#��ުv	�[��T}�Xt&���9��ǁ�06ሑ/���Wca3Ʌi�{������M�rx���(���`Vp���(�`
�4���z5�nT��L R�꿻�92�t� ����[<�������"{ G���ؽ��ؿ�/��$�
p B���1E�P��\��b�� _?r[ �t�~R��h�)=���^2��h�	5�M� ���,;<f�y�U���C�c��.7fG�M��O"XJbе��nS��۴2������nx6��B]��(��A�;�XK��j�����ғ�)G�-���S�)}]ǁ"T�um<?�i*u�xk���CU}����U����I�>�쌧��G�d�U�����6�Ci�o������.���[���$� �۰8���!���~�,�F���X�F7[L�]A�7ſ�RV���u�kG�Q]�X�܎�Qf���=wl��ո�WP�X�<;m�:�
٫�]���=�(�V���,�LK܋��	jDw�d"&��cTB��^�%)bǡ)���r=v��ַH��Q��z���|o���0e*@�^n�����ݡTd��9خ�C�ǒ��~Xҏd�n�5`z������\���C袥�I�-�ɻ����7P����V��Z?rZg�T�X��a<5 ���(�ԋ�^��z��<ew�˳6�h���S�Ĭh�!sX�S�R�G������޶�l�=j�aǰR���/x���E�r�!���{�`R�B�ڻf�$qW�� �RS���amy����_P���?h�д�^�G� �7!��,�ܙ�{��":�C)�q��F�\�4�c��Z>L߯�Z���Wj������jo�>SXm+���{��߯�U�����*��U��oZ�J�\cz-�}��	m lf��҄�%�)>�
�t�*��ӯ^�fŪZb�*=-=�"[>���B<�J�.!���GoR��i'��Jp��e�[9nE޺�!WOWGr-�w�ۨw2���<�5� �5B��8_h�P4��5a�g�D;��b���PR�G����W�A��9�$���8�\^v;H��4���� R�^ r���x`�d��[��c�%3.�;��W3�8��Ѷ���U�wL��lu����(��cXS����8$J-A4őHR��{	+��-��%y�l��_���,���p�8�� �0�.\�iB�G��H2)�sbz(�*3�!⭬L�0H�AR/0������3��N*��1�:[�D��E�-M0?
���Ib/���(S"�5Gy$Iy�/�ЗG��&o6{P{l�¿7�R�Xs���k6�t'�e&+�^s_.�l�-mJ�}�Ȍ> �В�r&����d�zÊ&��fbY��w�>H`��>?&�b��`ې\��� �gq
~�6�D�3�wߓ*Ls�#�����;�_N�*�5�Q�o�˸DC�k3����-C�|z�́b� ⟼E���\g�*�P/BP�E4�L/�t�\� �z�	��o������*�	�%������t��}q��wsZr�*�HT�Oˣq\×�������$�6v�]�x/K��;MȪ�ؑ����L��B��d`��+��U��/k����em�R���6D��gP$��J��GgXx��G���e>�'������v;KY�
ktSj�9�&�mFz�V}t4���Ii+��'
6!f�+�$߆��.{�~ʚ5:�ӟD�U�hV����O����滴?@�JZ�]H���Ui    �'����tb䫷���a ����P��v��=�O	{ا~s#������E%�L����%���_�:O��3��`���N��e���h��aL�t5�u�-�K-��K��u��C��w��?��|[0�%��H��a��>wQ�_�f08�c���׺�4-ZnFz�6�LzN���=����e�01��fx��Ķ�t{nr1��x��'���=����btpo�O��7e	�~ـ��c,#�T
1՜� �u[zf�ݣ�;|hk��mv�L$�>m�@����\�m��߼�)�	<��s�Ҹd�CK��{⢰��;���A���6,���6Z�D��yi��ڍ��6�7�@��g=n�G[Ʈ}}��v;�˴Ԝ߼��1}��Oߦ���9G�?m�=�����[>� �	��ou�g�t!�3?p�F5� _�?ͦ��04N
7/')l�RO��'Fо�0
G���~s�������?�& qG\L�)�h@v�~�D��4L���H�6�/�Ev҄�URQt<�����F�#��5~_拠����)�~͔��@�M�!�e���0�Жǳ�o����!�a�W<>�������e<��H�|��8SςTg$r��"�@U�����V�:u�u9��P�7M����������Up8�k��`:� L �/\��	c5�$kM�4��qH�!��k��Y�d���͕j�o��4���扔*K́C�hK���Y܍�܄���Eמ}0�-����c4]G��w�N8z���x��ׅ��A��F#��1���K�?-(*��8�⺲���O�-S9i��_n��1 }�AH����rH�d	�ÿ����A�K�B'�0ҡD��@�c���q�1��I㰚�c�8������im�"l�q�>�֢�(�؄�y��W��2��mor� |�M|���п�_*5Q,ib��t��ÛBe�9f�ҳ\�?��Ы{8v��y�i�.T��|/��B{Y��EoՕ�E������Ҩ�*� ��&��J5I���8@��Z�.l��~=��:�E���\�	m]fnMM@�u^�$����Q�h��<����D�2��O7[֢�H��@�I�wѨ�l���xg���^��B>/"���Z��C��t��)�*���F��2��܇���M )&@L��7A$����l0L����g�a0�9l����S�h�{�-{^�Q�Sc��㇤\)�[\�haL)o �b?�30E͋�׻'U`3T?�)������(dhnr�:���G��G��Q����k;MB��=-���W5i��(��C��r��ȡ���g2MC:��q����4@ͽ������}ƸDi�]s?n ��8r�٠ �d�ъ_4:�Ӫ�Dqm5	o�����Jꏛ�8�?�J��UaQ�?����N��S��u-����'��'��(	��v�f��h=;h�w�5�!eLcR�1�O�,jq��IBv����p�ϑ��#�������TLWH�Y��]Z(��+iB�6Y�W҄�W�T���:?���i9�c�r�9��s��@o��Q#ʱ�+�d�I����F�]��D�	Y��2�ZS>Ǡ�&6�м?Ћ��wݎ�ȸ,X�vЄk��:���
Jʡ0���XDS8V�ɬ�l��>��T�7E��K�O�7��&�X�Z���g�C3����ì�!�C�Zd��[HN��j�1��_]NW�0����<\�-9a�d�>�VS#PI5VC���8��ڌړ��(��yD)���[z�8�i$����֖StZ�=H���2�ӮT�ɛ���I�U���!e�T���(�}���B�����F��i��H�� ��QR�6�����W�uP�m2��&NZ[���`��g�`oD��P�<]4��$e�c�r>���Rz,��9�׸YH��+=)��0���K`��jl(�iw�ޒN
��Fd&	�N�%�p��_��E�~�A��P�yl1���b�rr@&���*e�!����%���ʘ{�DU�.��Ĭ��h�w���/@qk�}�K�J���"B��!�+B 	�߲�8�:�/�ᭋ5R+��]ZCj�^jtG�'��;�o�oc�^�zD��+�R���2�(��ǉ�$
1X1��1%_?����g�����5M8$���0�,DE����S�nB�'ך�4���i��M�����Ғ��ٲ���-KB㉋z������w����!�ג��N��%R�t�{WL���?��Ei�{�!0r?Fstӆ�4�b��w���Z!_�����ݍ���ʵ��c�n���\l��^�}(Yg��7^�Vڭ�K�9ço�!�"�d@��`C�({�璶@�1�b��2&�^l����m醕��~%��Ă߬�^�	UN�d�8��Kg���2�Z﮽�1�
~-�t��Q����%x�MD���~I}�?�ih�QQ�� 1�m������ȣ%]�p�C���@�(F9�(�Z�8��LI�VL8J'-�S$�Y�)�`�s�=6(@���Rs(��I�  ��!5�֮0�6�i�� ���N�W;77S-k � ��jl�r���������m\z��./���0�����%��?7�"�	�D���$n�/Ӓj璇��~L�	`�'%���`�t���u��W�U�I�DO1���u�I��L�Q=:��y1�R��!�@ ��9���ŷ����+D�����99:I�ki}�]P` �K�aUAj`��-�s�����+�RXA� �}�S�p!�G�EI$pq%�]���(��i�,d��幘��ِj'�
QZ6ӧ��S�u��oֽ�v)����`�ן�\k�ؠ?�H�s��W��qyN+B��lw�0�_m^�*�q�k/8��O-���u�ro��w��� օ7<̶a$�xH�H]����ʹ�Z��QHo��}�rm<�pV5)��_���Uִ�2&Ũe2�3�k�pͤ�\�Ф�([U����n$�XR����۰a��� �;K��<��%~��?k��s;V�rή�O� Lי�8Q%��&�!� �]:��3Gq�3_�g���J�B:�Yk_��_Π����%4R�]1� ��a�����<�S�X`�"�S��(�<����&���E�g?*�w����$�6t:
p"����vPBM��.�8ğ3�l
�>u���#�#r��ޢ��r(Hi-�U<b��	w��A�KURt��两ܴ&E��o6G��m8{p��z6�ֻ�Mu/A ˯���ߜ(�v��?D�c�	�D�E�	�2a䪽�o1۟ .�S�`I
�ډ�{���N�t�_��Q��vQ�t��稱�*d ����%�0��^�ԫ=��m=�u��6�tG"I�~��UY����ga�J${TI��Aq��jP%ل�ɔ~}��ﵘ���\ȫ3&s�򈞥Z�u/��4Kkv�?�a&��""��P�5�)]U�ڰ����KD�S��q`$_$��}�`��ܲ��cw��8�s`�WWĝȡ�h�������4����s�<�nb��Դ�&�*���*)��?��8Dc0)]�}9|;K��|��˰H3Sm�Uq#F�Ҵ�ҧ+E��Cgr��٧-�澴�3�u�8��ZzD�I�5bJ]O�r��	B��nH:(��iyD&��G��!�͛&Q	�z����b��*�z�q b�z4����?����+�9
���g-��^Ϟ|�ShuMK�R�W4{�Q������X�D���C����Z�7T���ϥ�">�[���T�M[�:��P'L3`�~�VO(�Z]A��ɪ�CN��ƢCА�ç,It�y���΁CH����N�:�F�&@����(8��'%&���;�E2?R�?�!m�b��o��&JZz�dV������f�Hjd-��Z�0jj�mW%�:�:����[jqo[SvݓFL̫.���]��]�d'�����7�d�/����ë�����#>
�_Og��|z�j    B�#8���b7ᮢ,����jg�ĞJ��q�*��Cq���ǲ,@��˪�on|����(\Ji��j'�iU)��s���Ⓐ�Ad���&u��9 ���~pC����t�1�dH�?��u_r����k��j�iԌ�7)Ɖ �m��(&A�-��x��󪽸*5��%2Ӟ2�V�JG�lk0��+�H5(������<A�#mVI�QF�U���`<��K��Z$�B�Rq;8 ��Q��夸��+�:(�ׯ�-E��:�&"~Eb� ��`kzxk��G;�h���ŏߦ~cO���z���ѸO4�����41�0�o�D�s�WۉbC>��MF��H�?u���o�C�����)�X�p�}rF��a���6��5@���lG��#���&ߛvYBV�v2����*̬6.�<kruY�k�j����t�:N�0x�*X�ǌ��d�̬��������8�8���y5}��,)7S�ZuR=6Z�����$��^j��Tkg[Eϛ)�:�z�[��+aݗ.ܢrbC a����H ��i.����~j2�e�����X�z� �Q�DL2qN��iLz�$veL �Ω ��L	����O�d�b�֋�9b�ز]d�
�8n��M�k��(�ƼB�Ez��t?	��}3�{�$��7."����%�\���ǶQI��1��́Q�e�H_,Q�JJL����\�_�RM�CA��l��{��?��P����G����e��m�~ԧ�K���ѭ�֔��[LC`?��6~]�)o�$l1nD����-����aRsh���9�Odhk�����6e��B�8J#o9X5�F�O1��j�G)�`�Hv99���ζUA1�z����Q6s�8-%�勺ʀ��o�z+|�������W���RQB߫��@���ϣ��9��Z	פPG�vSo�b'������$����#�K��;Y"�տ6o�9��aֻ�?eV(��S�U�LRLy�v��i��_�\̀b���'�_&�R�'.�	��$*��P��h�ᯅ}��΀"��$3	�Y~53m�Q���E����(w9k'K���8T��!}!OY��Ni�>�Ge߷��=�E���v<��k'��Uv�,#n�ZIa_�'�{a���7��+���8ڦ�X��ՉjC:�������*x ��%����!�Ce�,&YR�3���/8�����2(�a����:7��%�m�k�!���|.j�O?|>�/cH,L�1��)�3�e�/��i�~'���&ƼE�=Jd���>/�Uz۶j[��#{�P �٧6�jBHtD
6��!�F�T�5��qJ�l*}�(:���V !�ƹu�b�PO�%���G�6� �?oz��Tgt���SP}�c�P{��������3.�`�Z���r���(�}�!�����ۮ����蹣��o�:�k��b�/G�8��N���%=&�ihm�^�xޮ!�m�1t~|+�Ca���B����_M��a&��B��8�躰�9b����o6&*1�v�U)K��Y���s��:���LT��ɥ����Si=n~�`g��]9�#y�P�*��d�(��G�>�%:{�V9��v���c�+���Rk���0��z��c�PHbo�%�^�T��i5��Z����+� ���3�G �׬�2GA�>>4%��fwz�0"�6��&��ƃ"�{g5�h��J]���\�yVcI�$?��P�sJ�X�5sl(��R_�2x�#L�Ô���H��؉A�ퟵ��V$�א\��F�b����JƋ=��%�AՀ?��(��O�
���P�)��飕e��O.f�Bb�rg�Y�璸?�����Z�~@��>�n�O�ا����5��	EsJԕ�/�ӎ�L�v	I �ۄ��K\�E�9�	�D�H�(T%�ɶ�$T7�T�ۖ7+Q �Ϧ���3��H�!@_�G�uކ��4� ���j�Q��\P�� ���s�Cݰ%�%�O͸�Lx9�):>�qy*�9�^;|���;£cᰐv����S��4��t����2	�4�:����D9�(��#����A��S����Ş<3�\�"��8"qv�Pb�߹$��7�Nj����})��1�!���,@Gy��x�n�6<�iJ�M�|o�|ƾ__�)�Og����O�]�WóX�Ų�|�\��q�ޣ�����r�k�w�t��K��k�=C/�j�HYhK�7�tqb�o�h-���x�H�xѾO�q����-�nR�E�DS>|�Nk熨U��Eʮ`��ؑ�h�Z��=��G��r�M(i�C�$��P����~��C霋'(T�H*
�=���ڌ÷ei9�)�+�X���A���\�#n�.�|u#HRu��{|9�J$�E'�Q�u�I ���khI��+�9辤h y�`G��+��T7+{��52zf*u��a1ME=�����M;#��?��0�@��ufƑ�%7J1��~��8�[y���ƕHV�]}��l���ڹ)�F�U���B�_�w�K�n�-��X$���dX�-����MC�$c˱�n eY���Ԥpz:a0���e�x�Kg�x�R��ml�!���L��1�Tۏ���i�3�8t0)���m��Dlˁ �D�愽��q0�g���i[�X��`�viUOԝ��T��*�꣐���u�~�\a��$�L�o�Z����U�a�g�݅��k�Z@p�S@��+�_�e��;G��z��OՃ�0}�]�G,��o>u0��2��C�?Rz��b[�ѿ�Z���H�:M��÷����=Z��mHl�pČ	��������#��w*�(��-7 <Vv�o��簌�Ѥ�@Iv�D��[/�&�[�a���c<�W�(�oZN;�8"y�a~��&4v��0j��v���@�a0���]�\���^֫kE9|�ן�D�eJ���o��QxP{�T��x	�yq�a��_&��?
iفkr��YKU�cZ�T�P4y�Zg�4a$�g׺O����j��<�H�"���^|e����{bK����ve�={ ��ѽ�)�f�x� ���U&���:^��G�!�ID娖x�V�>nCv�v�J0�И�]K?n�T�bˊh�GęS��������
�|ޓR�M�KHt���8&NS�Lu��ńs�GK�9��C�*�v�tz{�xϢ�s�lc�F��P2�i@�>@��vU�r���d��P|=��X����9�M��|�+���z�!��G� �5/�L#I��V/�916�Y�a�80o��ż��'4�-���K��b��Regv��L�q)?�x�èNp(�m�E��-�E9`�_����s�g�X�]�	]`�_ɧ�҃���K�Oqa�L���ΰ�M�A�뽧EN�a� ��5m^�s:�+b�Ń��)L���o�	c���o(�$i ��!���{��;> ���Њ
�y5�C��<:��p����K�l�?{~�)U*G�'����������O�P��a�3� In���m�������
"<Mk�J���EZ�Q������/Ô���9����]����niޔ\���k�����ܤ���	��˲b�ߜ�A<�d�s�!`��:���ՏRy����L��$z�5��jBH�)�{��v@ʏ�\`{�V�Z��N�R#�Z_��*e���2 _����m��"i�蓯�j��n���Ə��ţ��@�+����������ٳmC�n�2��~��Tl���пȹc^V(���{�,�l2���J)"��]/Rhfu�����i{�Hn�RӺf
�#�o?9��yAo���{��<\�E��\B/�h��S�M�pڵ�L͖>U�mZۍɮ���o�R`]{Mg��c�+JZ<Дh96�%���8�������B��2�҂�[O=+Zơ�8z�u��?�f��ţ담���M���yy9�ǃ�@��Whb6��nӻ�f�D��_����(����nz��iI���^��p�F7(��'�w�m�2%�q:B� ��#&�Gq    d����8�foOI'wWY�%�q���#���������2R-h�xD�����HJ���.Z2lI$9c��Dr�y�>�ۖ1�ތ��a��[����y����q��k/'Bݓ�*��� ��85@��lK���]���O��~���D�TM0A��1�~�-!�]$E�	�, l{��h�;v��)\˒����c!��I�����(�Tx]F�u�I��~A�5	��X�?�r�c�M0Ad��)�6� 9�������%�xcvW�,F)��x�aU�)9uT;��Qu�Y���6���w|7MgN��l��(�j�������5�C��v.�B
���YoS� ��&���(s3�A2,���tVG�"��bBa������9hA$�Z���8�X�����p0g��8��#���&1hH��h���.��'H�N-Ҡ��{h�
�y�Q"����3:��@�Fw+y���-���)%JʙrJy�$���N[4BL(�	��foyc��$5C�,�!�tλ�F[� �WÁ�͆w�W;VT?��| aj�hq姧V�̲(d'�Ѽ�lX���;��~�8TTM����1��o~������=z�&=;�Sw���e$֫�j����q��G�+�%����0���k|�O�{E�o4m�j���h�OK����C��ɋ@���z_m�����J+�SF�[�x�Ԫ�;қIB��t�'��*��l�d�>t(�8�z�g6�l�`����-�x+s*`��htOι���Qc��
Uu��$�GƠJ'�>L�:Zܮ��$�V�.�{马&���o-˭�����sH�:��_�%G9�7��H�_��D��	��G*������z�a������\�[Rs��;����ߤe\�{3e��3��(�cFuʷ�Q�h-R������7���������?4?4K;6����#�d\�c�^��&�n�x��� ]�uʦ&M�u��-��QE�T�X�����.�l��k[�p�!����X�c�����']�%��ʭ��G��b��1��"b~�o�K4u	8��>ap"����px�7nϧ� [Q⁲E�CB߹x�t
p_G3�w�e*���Z��V�)BƙE�w��%���*D7Dk�2�]rUp�mR���2��O�x�\�ni^%��O|kY�Ժ�#5�i�dj���hr�޴%B¹FJy���#��,L���·i��$���e�wa��`{)]��7W�>�*�p�c�T� o|9/� b󊢟S͠�Y
�퟼��9��1v����2����O�d�C��`{U�y�,�	��P ���MH�F]���?ر�(�����R�O�}Y�����H��fg8��C�q�)|�؄8�v#��El�'Y�Q����<j�m^ƞ���},&�Q�m���~���m���g|�h���L��t���p�J�M���fCB�����xa�oy��Ȏe����q_oɹ?%��2S����7G��MKxP�%�*q�ɚ(���s���z�y|���5�x=��;�'�s��#%N��;��B閶�>[Ƌ������$h��mhR�Ok�7�jDSV&��#گX���ߒR6�.�#���G��s/��!eO��ߖ�0����N?*q@I##�uM� D���rj����X��:d���S^/���#�=�������#=���`�r.�g��
t��~Hp٤�f�bY1�F�b�%rM���5��ZL��B�IL�0�$�D}�I�Y؎p�ԡ�ꄲܰ'U����+,Z��?��?6�*���ALT�2�Ϝ�"����
�Թg�UNQ�&HC:{�O���z�z��bWRl:X6��^]��)̂�lRB+�#��@���/.(�Tݨ��J��Ɇ&��"m�����vI�1��� �|�E7�5).��e^��
һ�����/ˌ���H]-��{�8�}�i~Wrs����[�8%��d�G��?��HY:�E��`x�)+���Fr�o������q��Y��$ǕdY�
{��	$�IQ ��D���I������<����\G��b�T��ʕP���M����N��C=�1�Fd@K;���a9���Db9��5=�?���b��Qŋ�[���a0yD�Q;Df7\FC�#o-���<5��B��%�G��鐆�p�ɵ����+��7a��~8�D��L/ҥbU�`�Y(0�Hb�Ak�  �:<�b���{�uH�W�'u�t(�lZ����~�>��I���;2T��;�3OK�-ȩ*�dS�R
���-�]R��T�] �����G�h�`��ZO: �.B�@��~ʌU�	Df�L)ܗ�Ȝ�;w���I��'��XLB)Q��ypmra��*��B�t-��H��}83�fa�ԋ��a�d�>vq��^lpVE�c���~��`W?<����DDN� GSx�\OBƉ�n�U��� ��%�^�v�-lD���Imf��Ŧ{�	L �E��"�7zg@Zw�N�*�ž�����Q�Su�-W������E�~�})"K�'3.,+���$¬���M(S+����1�E�|��;]�(L�L��.��N�Ĥ��-7>�A��S������p���^����oq��J×?���3~@PNi�2i����S������.�#�>i(�5�F$����o b�Y2�ӿtUc�i�q����IW�T7��K�#��t��<O�c�ְ�T����b���I6s���{����g����q��1��J�6�������t��ۨ�m_��01c�|���Jhǘ�e$�D\��ċ"���W��+��x!>��ZП�K�	#I�I��=�R���{�0*JU`X�v�/UT��YU:t(�!�H%�����BJ<:�y�|�ǯw��,�*�0�p��JQm���[J�&O?�b��k��xVh���H=d�6)�&�C��� �b��D�/5�~_?=�8�K	\�^ {�2}�z���Oe�z���2*}i��^�{h�U&��F���~�^|ش�7�z�<8*z!�w�atkU�R'}�؃g&��K��9E��5��Z�����JN1dY�������I`�3�C �u�(���`����<�%�ϳ+���м�K�l�G)�>��q�iTԞ�ld�n�z	��ښ4I����/Yb4 ����.�E3�Q��1e0��w�R��<��ɌڭI�鰧������j��O3��oyΤi7��ҧ�OE��س��ׯZ#r�!O���^�0}��p�-{F]�?}ķֽ,]���$�'��믃	yf{�H8�Py6�h;�����p;:Jx��O/.jB	O���_vD�N�3lF>؈�>��oe0�.�i$oiGwD���T��� ]��Q}�*��~P���j贎+��*;D�';sV���jo��P`ʪ�f�V��SV*RA�F��9mH�c~�����Z�c����gR�0��`ܫ
"�`�ͣ�\�0�@
p�rh�r���5�֮뇋Ӄ�r�p�r���y��\�x��M�[Q��0�6D�Kr�J1���%���M(,7yn�̬����VGb�[��45��9(L:-:4'J�'
����paЊ��u[R�hҲ��,�~�k�E��9k�­�\b�}�֓
T�g���������?�W���c�K5F	%�Z��W��\���ߏ]�7�"N�Nl���'�4qf�[\��z��s���-�_���e�C+v�/$q 12��*�H0�WpR���IT����ñ������;R����gN��I�4���f�$1�D�2X�������)�<�af���P�s�jU;B!��Y�?M��e�%\ ��"T�îY�u@ ��9�������Ix�&�H��VW��&hoo���~Ҕ �e/�X?��gh��[�%���@[�z���%���@įEc���9�a�n�����Ǻ� �9�UV^�ԃ=K��*!�є*���W��*�$���$k����2"՘��G��d֣$�:+3n�Gul@-���2%sC�~�p�R{��I����+%�(������[�>ڀ5����S���V�!��j���    S]Y��R*ui�����Ka�>��W��\��W��(!����O_�*vZ��ѕ[&�k��oCF�
(Φ
��7|��/�=������T_��=ֽ��N��\�C��G�C��������e�՗j��L*�g)E�JJ�vP�e��Z����y�lCA�����c�6��v=0�^y�5L�<�7K����Oн��K{{�{�$K|���9�ѢѲ�CPH^�KM4�e������[U�e>�d�|\Q1\�]�î����}ON���
�L��fc.�0����,��ˣ�ޭu,�>^���v<)ĳ�4���I�<�h�����.�V+s����q4%ߧ Z$U�@��Z��"��4]�`_���]��G�[���v1��D�X�v�2��L\ ��	�!��=�Xz����*�%Y�j�dB�E�Zu��P���:��y0e��Uh�ߵ}���U.'���[}B؄�]N�`�g���N��;�[r�H[��ز0AM�]�#u�,�"��~U=DǄ�"Hj�uA"��1x�[��D���a�.��+�ݮs�,r�bCK��
��n��� IY��OٞSz�r(�Dj[�HZ7bl\=�8�f"������P��(�	^�'�x5�ES|�{�t֍�蘠�0�����3�PA{�$��ݿ�s�hTMF�=�k����@D6�#��'�9��l��tJ�B��:3���E�"� �u�����yZO�k����o����5���R]H���gt����r����+c�@��F�����i�QN�&�y)���>|��+�H8$y?²�<����T>�����I����Tz�8�UB��뎤��*�7�����Ѓ��8�2�����!���q���ܦρ�er|��i%a��jqyׄuB�*z'W�P���"{�_�(</re��ocI�"��׹��wmU���I�����P�cR�<#U��U�q�ĖN�V0wM�Zy�Tw?�� ���@�$�˛�~k���E�7������I�n�XBˤ�K�I=^�*�3��'�%���]� P��Y\%�<�*Q�k�v�t�!ﶊi*�|�t��FG����Hm��ީ5�S��C�T�Q�`g�����j�e� _����:e��t���#�u'�84�����$�)�gm�ڃS�q�YF�J�()��-$L��X�|#T6�r����f	�N���1P�F݆�T��6/0ՔHܪ؋�����P5�ϡ�q����(U��Rcϸ�K�HK�dbf�^&�����f���,�a)���A^��*��7����gL�۞��d2��v�f�9���wU{i�˷c�3��0��g�9��u8xF�����٥�t��T[��rL��BE��˅
��ճA,�v�
�4����:�������˱QT��: �I��:
ت�,�`���=����'u|�G՚����fH"T��G{<�(D������=��9r�Ӆ��ԯ��Z&4��	���9�
�,�����K�*<
'�!�&��1Nj>��k�J�ǵL@���YT� 5��k���(J-�L�%@qA/��=���d�������2_�(��>��0K��'82�d�T�m��F�IL��?4���g���ļѻ,z�1����S���w�&Is�!�v��y����D�Ԡ#s^���o��5��k;�myN��;"�V0�����<�%1�5Win+� ]�R�i{�Hܦ*���p�u���`�d��#�Z��;�Цc.J~v��!�a-��U�9�T�x���<i�at�&Ue�@D�����S"�p��|tLLQa���`N�2���:�'҅�j�x��3Eu���b�t�����4
�G4�VliTi�H�j���L�B��(D��F?}8��3�՛�T�{ZW��d���@.�.�*��&!�GO���=X�,9u�����`�a��m�̀�.�W;�#~^�˸�,$ѵ���_��	����ݪ��h��+���Q�XXgU=T�X�b�/� �C�����D�: ZJ/V(wt�ѥI�/؊��Ra�>��YJ������O���H�d��e)yO3~���$�������ܢ��!	��z4ck�>�R�6�Wi� 6Y�&����o^s8�Ī�X4,���NC`Z�,Q�9���,��eqL#SOϖ
�l���� �^��f*��u�Ц��ì�mt��s�f�`t�u�������G���-c�N�W�Åa�w��^.�S�E ��-%M�!�P�X� �Î�?I4��5 O]�5*գ�q�5%{xV��\����w���ђ|� \�v�������,K�ʠ�=5o'D�G�9�-��lOQlS�G'hb�2
4����*LNЄJS3_(�E �	����D俊�=H�Euw'��E��1o)�q3�6I��q�6̌�a���ez(�U*��V��k]TR~j�*7Xgh��P�g�E�)� ����۱�vsY[�l���B�Q|����=}F�u��8`�\����h�F�BK�3�=�{�d��`%��MqR��#��V��P�߻/OJ��Kt�
��c5�N˫]��"��'�N"�=��d>-W����r�(=?q�� R�� �Ѡu��O@_�#�j�;�f�ҳXS�A<����h��<�*�������eΝ�e��6�J}RĒ2�T�U�O,�Z_x�
�H�mm`��	@P�����ҜT����h�]htHB������1�PIf�Dh�O :�	��j��^_3)��^8����H1)U��@8Қ�2z^Go���@ɺj��uXK��V�ZFPFھ��Ռ� d"H�&�s���z܅��6�z>`c[mP��r�FUJ	$96X�6��.��=��E�O���X�����qC|���g�R�k�qr�������qQ� ��i����/�Q�a�6��@e"��Æ�{h�|�;(�N�.�ǇM��z�+�_ȭ�"��u��C��L�uS�8��br���ߍ)�K�P�v4HZʖ��k{��r�#o/��+Rx�96��H�g����K�`4X��]y��H�ՏK�q���������D�g=5����?�xm��� �ԃ�n_�nrܓ�C��{ ��иmInt!(�l�Z\���b ��W��;�ut%�`wJ�V�:Ȳ�i>��1?�{����,�q"���ص DX���;㒏�-����_E�u�~x {6=�c���\=�Cfq��z�|^���E��ǍD뫡R%�)�B���2s��3\��X��,A���Dڙn48d]�1$�a~̢BcK0K&5}�)V�S�q��ޔ̑�TyW����� ��c���/�T�����s���7��㢪��`���<�zF�i\*����̑Q���$�~ezl|�f��2LS��$��q�067?-��;�d���K�bx؆d�ݚi�v4�NLpǖ.��	Qu<��ꢽQ�j��g�j�A�x���K��y.A
��6q�a���-�({�ۢL0Vw86ۧ�Ҿ-$w�:9tQ2c%�>�!=0۔Pw��3,��Ӑ|����i{ �-�z�A��	��R��z���Ǵ���C[Q����M�r *efkר��񦚖�1;�G���HbL�\�Q��-^]?�~����@��,N��o$w��T����*��-a'g�?�2�b�H�R�v �,�$�� x%I�UE�����'�@��C A�(uek=�ш���q#�SZ�DK����O�Ὡ�ƪx�Rw�ua�c7Ţ,��(�S��Le꣏���� =ә��%�-W�U[�`���8N������bǆ��wOS�D�8n ��٤��.`)���>%Gi�%6��Z^���c�l8�g3~��^�{#���4/"����NIuvB�;������l�}�m����CA�l���Cs����54ixڬt��C LvB��l/k��6O��!�p���
-�L�`yo�L�,(=��C-ۗ[wwT�*fNc�LƜ�}�����͘���Î�%K�j8`J�3sР¹���    Ş%��t�I�/T�  �.k"���)�>bBR%>f{��S
W�	 LK��X��}������q�5c&�T�o�r��S	6�2���������emܝag�,6y��
�}2f��o�Df�9=�}׫g	�9���Z?,qI~q_�\l�_��}�X�g�l�M���h�W�~ݷ��tf9Ysͻ܃p�~i�i˔��Z�EY}�\`v�\a��mʳBV�gD�[ 
P�<J��������F�����r)��v�G��x����M��Ϙt�l���RR�F�|��F>��!�r�]!�d�p��p��d����\�-B�w$�� X9(���>���\<�sZ)k�U���T�S��*.�S�H�)�1�_��bM�̜��x��W;��2���}�B��v�w���������tB�g�	��1�c��C�sO�Jy��h���)]~�����Ӧ���cSo�;/��`�*�����>��ȅ��噥S��z�u�M���$7C�Xu��}e5d��l������6�-��H0���`��� ��¼� &����]�M��ig�
ϛ��P�&��W�����I�ڔ��0_]�a�J���;��(t�9NoY ��6آ�?v����n�m���8T��jG=�ﹽ�|	���1Uv{�������̒5���}aoi.
���W3���}�"k���0�_���m����v������j���	1GP���4�7[����`�x��L��q�!���	X����2�c��ң`�4��-����2t�l���X5;��}Q7�IaBl�I�y7ļg�C�p���o�ŹEy*��W��Ī��F��^�Dg����Ɩ�\�3��s\�G&�^�xw�����?�4Ï�U{�6<��1M�q�#���q�� �u�"��q_�(���L��^\]�΄D��G��Us<��|��{Z�Y�:����@ ع��Dp� R��B%4'�m�*X�8&Y #lT\���&�dù��9����J+�5���a2����`��G]�%n���x�#������7՝��� U�[/�k��K��>)�_nYR>��ڲ�z@�b�$	'a����Ü�l
"���dW��5\FP}��B;])�uWO��ZI�iP&�f��&�ևsc���C��y�߇��*��}Ϛ�����؈GrG#���!�3�^�`X��G��c�]�S��4���xSyI��iG�(´4_�������T* �V��/����@��ۇXyh/��}��E���y���w���Zj'܎"E����kQ�x;2`��I���7����]�4c�_������g�1��a�lIj�(�`)n�^���;�.��.1}Eo�0;ߞ�������1��}TĢ������j�J���=@0g����F��4@
.s�Ji7hX���a@�Q�ESq�$E�Ukt����E�(e��[��_15=��< �x�����F$}��4S�uy�˪�r����n��l�ZGF�.��C���}���Z��pލK0(Kπ0����n�F�lQ<�Z{Ё G�v�����s]�KM%+����j�>���6uk~8#@�H**vP�����!&�m��T��t���������37t�'�r5"K ��L"�ǵ�%�b]����'9b���WI�
Gt����k����	�Bg���D �C�}-�m�g�Ȣ��kYmR��j��l"��o8C�$)�)�{�\������w'��7�R�q�X����3���E�����}�n���Jq�lL�έ��]($�^2���_ώv�/ �%g�Hū>ڞ�:M� _�|�"�P�r_�Hي��~�iE�F:n��"����_��|��K)���9SH�K�w\�|��a��L��|_�Y��=wSΔ�4t{f�~s��L*��7%s���A6aΤ��>.��2~�D��dL�`���ʤ���w��%��K;��)91�u	���Z��}7#� x��R2�VSH$�L�a�L\��+��sf�n�c�����$a��+�?O#8I��[5��z��Y�>?����7/��X�F�آ�'�i�r>�z�1��jbpK���o��ݖ�68(�EO�x`ma�������S�#�k�nh[� ���yY�o�c9*�J۸���Q뫽�d�s+G�ui�Z���ݶwv���U.�����R�j��U���c�Rxt؅Bd��h���pL�0�8�L��B�W�����9�5�d$�]��w��K�%���m�����R'S�B3P�4�YZ��������3�*�V<wϣT�J����m�8��P�}�$V�b�2��c��YO��_�?LD1�s�NAN�]+���w{�9�$R�CM]@��wq�$jw#Nk�
G���s��S�&��*&���{��+��O>�V�2�3^��Kn,�.dW5$��n��5ܒr�&��S�1a�-�QBd_.��깥,R�p�릢j�f&��H��(ݮE�5Ix�o&��.?q��h�pIL���I��t��j��"]z\��4����bC�:� ʕ6�i��>|7>0��ˢޢ36��4(���лŇ�>f�n��ĝ�=J���j_��y1��sz/:pX��R�	���jϱDe�����+gl�' �s�|�*1�y��f̂�I��Һ0��S;����}(�!�.�<���u��cH��\��UY�`������mUM���e*z�w�>���BT�kG� ���y ����jIWI�4��5Lx;�A�YU��\�Gh��њb�O`(�d��'���+���*���@"U�&��ܤ�pHW2ؠd%?��OK��YBv%�x0��ïn�2�-��U0��?��m�R�Ob�x47=<�뽐�)JH�d5�sI�]�{�)��&;@O���.	�����-�*l�[���&��{��v<a�&��Z��f@�'}q��/�&�s��k�mK �54�z����zV�E`��mm9�'R��!sf��J�i�6�����=-ߡk��..��j=��e̜�xv�`�[r	ڨ|[ؾ@�"�ل	�8��D\�7��tC`�rmL{Vu�kO��l������q<�CU^\3~LBg�er���-h&���uL��ا���f뤯��%��2���y�~R�Lӌ�g�Z\x��V��Q�<u=l�ʡ]�ĭ������J�t�E�[�g��5�%۾�����/
c���ako}�)�$6쓆v�<�o��'�C��$y�=.C�ϋo��'ܣ���ڜ"y��j��N�~{�_�<��V��Ѧ$o7�?I�T�[NP�dY�d�M�Ɖ�_t�r���L[ך���Uhn�1fSs���U��¤�q�"���ن�XH���{s��+^SŴ��n�A-u�(B���qTL��3�1��Y-&���Aq���;@�Mc�(�� �Ҭ��8'g��*a�u[��PJ��n��|ZW�t�}�}N]cm�l�}�TZ8��O@{#/1�'�a�M���;[m-�:�D��(�lb�=R�n0�+ؐ�� c�+G;��������eSf+��i�bSek��q�i�@�aG?�;����U�Drݽ=`P��]�o�K���e�n�	}�=�6�ta����tM�?���_�P`�O��qqMF�z�d��$~�ii����'�wxJ~/.}qQ!o�v�G�U�v��}�1k�=������ �9%*��`�g�]�DJ0�u�Ƭ���WムE+�cG���9OL���]4<��'��O��7�<�j� EH�o-��J�.����%Z����a��ݴ/E����!��u5#5�E��ڑZT�E@ 괡���b��Ȁӆ�P�;gv��N�%��x��A��ǧ����XvrM��א�Hk��(c�0�K��N&Ţ�S��Ӵ%���Y�.�lKᬋzH��#�l����D'�������4zܚ�HekB�oW1�d7\�w6�=�'fʾXӇl�1�O�o���9��Y,e�Jg',؊��g��.+<s}<���9&@p:�XvߺNf�$DY"�\��,�$�,�F�ڻ�t���U    ��	d���d׮8&�y���v#a����%y����ӌ<qqE*<��Ĺuo'S\DQ�)HSD��8��51��us�I�WOo�/SE��aq&��\_�o[56і$�7�:�_�v�x�-,߆��O�43�uY���<��-6�^�I��Ĝ�Z"�+6��C+���-)�^\\�tp��f]"��t׊�(��@�x���7FI��m�^+ȹt��������W���ף�~��&F�/�/�
�}2-hOo�{r+؜䄥�Rc�Z�������(H�^��0�j��j��0�T$�Ͷ>[�C:O �?V6�Q�?��W��s6:s���3)�5.�&X�RJs�O��Z��X�֥�{:�F�Q<�'��t6?�����Q�<�%j)��̋���ҟ���E�v���r ����OݭJ2,���%�\�Д�ӊԟ�!�el;OK6��I������1�]��s�,�[�3,Utjt:�d��� �vmGj 3]Rb�1����ae��m��}����8���%�f\z�G�\M ��;H�R�Q̣J �8���'�QX ��������I�WX�a�+�8�L=G�v��@0W�(%��g�N,�����ſ6*�:2u
@Hje_�Z��e0D1�ŝ��x�)v��]V��`�.Z��� �s
���������w3k:"��5�b+����C]�Yя%@e$�;q�� ��O��U�Ц�y���ջ��>�W	q�9o�,%m=Hr&��,h���{@�~2�����ٍ����`(U��u�rR�`T� �!3���߸A��v5hwqN1sN��~��ǝě6��а��R�gϤ2�4׬n����^i�@�%SDn�V(Fe�Ը8>>)L�����C�,3J�r�Y8A
�I���z>f]�˰����͡��Lj���յ���{h���*��8`[��ĠN�4��j�G�@m/�Rj<� 7��ԝ���.H�oR��dHƔ�a�O�� ��1+۲WW]Y�嘧7�oFf��lǫ�9����a��Q��5�x)�rъV!g��Ԭ'8��o����ޮu�,G��[�f��ǤQ�hI�l$�ֱVEm0UHA;q���Ҩ�(2a�VG�!#���~/�Q�J����)@p�o�ע-�/���k�N���s��LQ8<2�l��w%�B�8����gG'���(s�͸���Y��4q,n�6$_SI`p��D�8����Cx!r�{�5Rd���n�n*�\mm�ω~^�+�H���������b��TF�е���p�<�y��b�h�Q�J��|>�KpeY/���=hg.ؕ�ʎ�|��q1��<h��+����-���e~�< o)$U��r�CR�����%_F)!�)*%܎Eo��)��6g�{�շ�,�A�e�W��?�"x�|��L�������" �2E��Qܠh[��H�;k3A
�j�:"��VR�-Z�`'�z�8B[p�c	�$�6���T���hH��SD��K��0�CR���H
Z��dta�C"���H>I�rZ�d������J(�W{s���R0�2Py�COr)�\������?M�#!�^(�orl�^́��sf�E���{t4N{��6h �w�t��%��ӁJ��$��e`�XR��^�.�Ê�mI�('�,�w�����AD�=�B�t�W3-��F!��`��k��?*��F#�(huuv����I��}�X�A�>V}J�����mB�+�� �M���E$}[w�E8�3֦��P��(3�Z���Q(���Ǥū�ݝ���YQ��Zw�s������,�oϘT�����t���&���4����/G˾��A��&u/�D{qL�Or�Q�Nz\rTxl�c1�f3����^��P=(gC��G�kN4�ҵ˳dfi�ʛ�s��V\%Q�ے�A1���n�-�SZeQ���ܗp��\�)�}��Uk3�*��I�����Y��)�uK�Y�yT1��(������.l]&��(�Z��v���rm�NC�8F�����G�pK��XC�2�7@�"{�{���8,����gF��K.��^��eNI�vW*��S��(J�j����j�I�8�u�z�Mx��x@8%.j���[�R��/���>�����伳��@�1�5�<埿�:@y����9>?��ڵ��=�\{���y��v����H���@N}��|PS���^��*AB�ۼ�\������9WK��u)�{��u�y�gM:}Q�D]�QÓЯ�����k3W9�mG+�~�W�_�{3�,1�|��P���%���e��g���QYk�H0D�BB.�_�V�h=���I�zM1���A�{�P����'���HdC�Dϊ`y*X+J��(A*�{`�����4/�#_�b�����5�jAŴ�K�a�|B��V��25����@��g05tK� �59���G"C�}�y!'�g��4)m%���)��C/��.uL�:���tBR���~s
��|.NI�xQj��c��tN?��9���2�P��z8�R�iذ|u5�`!s�g�be�p��ՄwƷ�?��.w������a��F���n0��V���	E��ɽ����k������$��os�Q3��ɍ~^����lW&y~갹���~/Wz����Ć/	.�,E��Fa$%�k����dX�k�L�Dm��A�,B!���0�˗k���f��9U�
D���M~����i}̼����v��/��R�u[E��N�Mn�i�n��6@`'ܗ��S�l�yh�W�[����nln��G(FnW�h�a!^қ�xl_�$M g#�9ZW$��o((t�t��$�C�����za��y	"d�i,p."yCV@|�G�턅��[q�[��k����G��D%�p��>R@}��+ k�I_8Ko�Q�����2����`�g�f^�� ��H�������2x���q�\��|?c�k9����>�T;�`�x"�Ge���˿m%�R�IL��i����w�CC2*fjn�%�.-�8�<x$'r�/]sm�C�y��67`n��,���GY�t-?u�v=
`5�g�z:BKu�����n;�s��P|����)����͔p��o��8��/�bv9:�ԍ�4�s�y\�qKJ�І�s�/#�V��PA��F*g�)��ӏ�ʃ�-�.��P�wu��X.���U�궅@$�'�����*I�!q:V��ʩї|�m�� H`Px_?�W3zA�T��W}���,�F���a
�����`=�:�{�]}�'��r�%荵kv��&��7�R��2(O��Nx�xZ��Ӻ��v�܌̈́O�a��o%`'SL@�B0�V��dhlN?,����0�n�.<��Ǝa�b��F�u�)��'v���!�~~���⾁(#���"�C����R\�X�{Cq}}H��B��1�-
[� � c��a.~|-)�A[�N�DyB8�Ϯ'�Dd��V���e������\^$7f�
bΦ�w2�5%�0�_��0�-��(��}����(�׾����1��\� �C��J5�(��.��.��/���UhF��h/�"�U���g��'���]�Ue��0F1�kbG��0*w�,�f�T ��b�Q�����hf�؄SP��xT��h:�<|zz��8k0Fܯgl�	}D�@�TC��4U�A��Gv:xF4�t��Jh��ġ�SY/cQlJ�������Ʊ<�g_;4�����5�� ��-5�Β��F��\ >��'�]����g:��5�N1���P-pr
	3��-�1��0��;�!����.�r���1�qZb�%�5�]��j]�כ�o��p$�kͱ�2����>.÷%	�ëz���T�dHD���?'��\
�p�8�QO3�m �9Ԧ3�f�*�T�@U$P�5]5E����g���2��$�wO�%&�����M�{��ѱ�l쯐D�snb%T�@�E��<�_jr�&c6����k�\��;�PZ�aG�y��y8殶l��9W2�    b�e�dw������AyӲ;��.���ݡ�<+�T3���=�S��5}�-���kG���\�`GQ�Z:]��r=�~��������z�k�"TK�%����]��(�T0j�����0@B��A�ZSAǵZi�[�[��X�K�|�[�Q�Q�1>�>6�a�΀b�u��Ǐ(��v��gV�G��
�9c��1�7n����SݽLa���~��v��:�W����j�N������-����(��0z��L?,�F9�˵�xά3\3�Gl<'�٭����_��� œ��م#B�5ؔ��]�)�:|�mJ}��R�P�9�ٱp�g�T��JW���]ӹ���U�n��1Άч-�(JL���PŻW3�<�Cf�bO��#H����2��� G�?���9�������e�e���("+�>Z��wU&11�$�?/�l�����\?�
���ޘ`�"��ƵB���ȋ�O��b�K�sLT�7�ĔW���xt�{Z�cs����mY�Z(�ٯ�-����kT#�3X�wsA���ъCl�k�=Y�.KQIb4��D�;�~������ֵ���]����5�Z� {q��w�3Y�^Wq[xb�)��U�dd~�ׇl!�������"p4W�T��P]��F�Qo0��<�.�����N���ä1���τו���G��N�&�z��1�:�9(�j ���VHdr5筒���jK,�^����0��=��ro4��b��oC���ظ��lJ�HR���N&lJtM���6$U7�t{@��p҄��.�}cM�7�.��X�<cnp���^�ihR_� 8� �m��Cߟ7�-�㳅��]9'��p��@�`��uh�_Y�#8�翽Wp#��{��ɰ&��߳�@kS���ch�}�vB18ǰ�嶪;����C��;-�Ahy~6c��?��]�MiL0���2�����f��MJ�Xc(QmB��?���i���8\	͢:@OH�Fț��I��c�(�H���ԯv��Xf���(o��?��EVE��mp;j`V��/2xT�tr�ǎ�{}[�#1�7�z'��&�����x3�����7�Ԯ��|n��jF�����5��N0U��aeLo��Gݛt�d{����Db�� �}O@���<�����̘��}��%����g;���`k�uAlyW��<Z}x�[!�<ZSs�I�5���hM�����v/Ji��� F��M/("@�N��I�6�ѴLP��1��	:#l�R�{(������H�O0�zv�&����=�_�A����0��t<����^9c2M�ڈ�H��7�5��k?M�D���@�Q��	�oB�(�]{��׾��z�g��U����L��l�>y����}��Ӌ��b��(�p�X�l����x-x
��%�ױY�$рM�:Q�g�_�ٿ�q�z,����{��4@ � ���V��S6X�̅�:�$��W����N�(&��麨;�<� v���r3�z@��v�E��
+G��!�E�[ۨm����D�4
��G�� ؈��I��+*n�Ze}�O�7D�G�?�=m�P����g*xRjY'�[Q��dK��}t}M�t��9l���.%�=�40�]�,�[�9%Z}9��%!�4�vw��yQp�j^�x"qQ_����kQ�&ȥuCH��T��	�d�>�K�݇6B
���b�t@Z��-�_0�����z 7z�,��b>�J}ߚ��5d?O&����V�ʕH>"EGä��Ѹ�/sS��굈80c�$�lZ���4cb��b8�w�9ԧ�j�=qjZ8��H��f�ͫhTw�f^1��ԫ<�<�xK�ʋʅ����{W��o(�%C�\(۴����l���Ʌ�[)g��ZO�4S�A�Z���ad���?l�T[��4�=*3e�n�'�i	��e�}1��V�1̆e��u(IZ��ī:6��G��z�'�,�g��*�S���h;}�Li��R6�`U����ز�R{(�,��hv}����O��}\j�����#��ͅ���1Jq}=4% @��;���~.��z\$���A���ٸ��B��.E-�0�����C5�.#���*S$2��gx7Nj�~��D�jc�p�q �J��?�TH��6v�Y0V%:��#X��0����|�+�U:�Ƶ[�c���xCt���I蜟�0��ul0��<�3��l���� 4��� 7��F�^uv��4��MNW��ڼ87����e��B�����3���ˈ�_[L �k�#bh]��D��ȳ~<��Q����L_}��껒3��T,�E�Eȅ��ߜ�bt�8��rT���u�"W��_5������/�h��I�#c|w"gŠ��׊RBG��u�@M�.�H��� ����.��yI��L�6<�钺��g�j��V�3?����Q�/Ɖ�
�W� �c�yDT�֕�nsF�@���ʩ������`��=�Q����"����GV�k��YF�����Wq�N�H��%ԣ����������>��[��`,�|����c��q�b��a�ǅ�?x�h�(sx#�Nbn���TNm��!�7BꚌ$a�$��Q��
DC���<�HL	>$E�hg_+N�����?��b�}����:��ծb �	n_��Q�͙�Z��/_�������[��� ��1�`���}�ɬke�0�ߠ�"��e��ܸj�u
&E�q Di��{R% �������Jש(��6]�k�E�V��R�rM�f�VtOU��s���	龣����K���11't�Wz��X�p�/�����>u7]������s�4��e��9�,#�`�F#ߛi�9{�Z��@��0�}s��'X�W��G3���|�JcO�-��ue��}�u��L�gg&���;��w�v~8�NEg��?���:�Q�4��ؽ	�\X�����:;f��y��yZ�p�;]�S6?���s�����'U�އ�qMqTɋ>E�!ƹ}}��;�l����������/�{�
���E�B�Z���x$,��)����������>Z���J�a��ï��8��jP������&Ap��F�����[��""cߞQ|/�c����磊��\��Q�௲Q(�ͅ±��K�L�w3^�e��P)<��0���[V�D� ��Y��̊�,�G�E�G�� �� �����}�'������^FHa��5��o�訷=:�u���R�ͮ}��77�(���u��KuJ�O����9�+��-�o��N�4���	)���5����}]/ćLQ���Zi�3����H)���c���HQ��9`�eU���F1�wJQy?z&�C{2���5w�.;�C�mH����!Ea�fM��H<����dT
Q���\��݄Ko=:�p̡sJ˓l�Ng��vY8/�[�HV�Q�������:o�s��N u>ё%,� ����]�����E�<+�lo�M�
b$$�8��˪f���u�;�&���g��c���� ք�$��2�)}4�S�L�_��h;hq���f'b�u�ՖX.�Z'7���K��᣾��l�Ԓ5�<�y��h�2y0���<����0&����]K.��I$~2l�Q~=�˗���0���Ǔ�X�p�{u�&�(�TR�wuBF�E�U��Q�F8' �:�T�!����
V���3�V��k�E���ނ/t|{	&���m?���V�����m��׃���/��/���A���(���(���6cB���j<����hn��,����^]�Y���,M�Cѷ�캙
KH�{r� �&?Ḫ�]��G_;N��:���>Z׾8�˧��- �����~�]Z�,Q�����"�z@���
��L�?W���"�$\��Ei���E���Qp�����.��2�6�(��H���D�9IK�Ƭ��bYIB���%�Gid���T��X_��]������O�h֍崢l�9 ��#]��7�F��    $��y�1)ɫ!r�y�X�BH���Ϯ��GV�H�=��i�7���G2�(`S,�H������$j��]yLE�A��XzA���x���&��R��E�f��y�%]�G`��/>���h��>
����C�d�3�]�0�?�A�q`˒�%�n~��ж�V�\3�\~���vI1h�)z��o�]�Uk_��Uǌҫ�.���'u��a���R7V�C�2v.uZGYu�aHtpa���8�����j��E�)�={�H=ײrA>�8��k4�!Y�6"�BZ�f!�l��D�5�����sT�S��qJ�[�������\9h�'�h�!�oB��t�<ۇk���
_���,��VS��<���} ;R�}$a߉Q���;���kmH�$�uN�S�����䂰<z.D�&5��c/��� BL��Q�(��k>��h;֬��0��;�]h�g�T1���E�b�'�ʣ�ܳ���g�i�_ܱ"=�N�=2��pU�?����xp���;�v޳Z���V��=fHV���mX/k��������U%�k}Y,�B8�-�vu��"��U�|�"�]�kn>�`�U�5�	)�@,T:<��dB!MU�U��>(���~j-Մ�s����w�-0������Fi,�p0�$"�����9�Ô�F-��A��eK���A�E.-���<1�Ny-ԃ� �g��  �3,��+�z��f��&:��\v�1zE��D�&�#iZw���A"u�:!r�0���>My��_iR7܌XY�����e6�I�����a9=�� <�-�������*����
��ђ�?C�تo���5��#)�(C��ܩ��$�qN0�T)�5�G��&ѱ�I]������JY���w�f��Ͱ���&e�1�x�z�0��5�����p���|��R�\ϊ�K��6��dcz��?�1eZ��rou�`&��}�7�F��!> Z����;,�#"zg��FgS(�pV���$ �,Y�V:�'Ů~��!)Wzh!A�|H_�	9�i���1ć�M��A؋4t�T��f���<\��Ѵ�K�����]"8��$w���:I�����:I��~N�t`��l'����-4���M�GT��<N8�bG���q9�fz����}�����f��Ⱥ9�A�6����g��(��6Og#ȹ�T$��ȩ=Di���y�i}b�����:6ܮM��q*߄vT:����,��B䳍shv��}��C�/$R��%pl��o��W�(0K�N�\#ө�x�$���ִ�cO�z*���}�,��=�7�`D�Y��0����֗Z�?�ߏU��A�b���7DV��G�I!�|�	�`p%�L��d��{�]rS'fRn���j}t\o�8�R_\�`l��k+qdI��u�0T|��u���@�W����@{zĆ���`��ү�T%����,�K�Yk��}���xH��범�_tm޽�a)=�Oȿ�z�V�"<;�l��|P���
Yi�
�iZ0�Zb�ҿq� '��s@�u��A�g����DE�#��̭t��v�T !t}F�|$Λp�e���P�#u�muf]��h�S/<;�@�x����G�2��L���<L�Xee�k)�;F���`��#mvf�嫙�\[�j:�E@����|��Z�8L��9��ɷz���J�[�S�B�譪�Ec(b>&��F.����U&^����k�p����p1Q�B*���
�Օ�pD��7˾����3�F�Q\h�l�.LbK�\�O�3,��fC���.L*��j�)e�/N�q0��z�)۞]�.��s)�wɅ�O��`~Ֆ���f']���r�k��˟uM� Q�7����X�8�C��V��&טZ�������L]����d-h��xCb��Ƴ��F1[ec�g��[����=�M����~>[���PG��<[��li��7"k�.9]��(���#&;�5�����ܬ��@4����\'�2�an�/�@�t��
�]���ˏ�h|��<sL�ȍ�[M�S�����ݎ̽P�����f�9���r�\��R$�x�5	?Y����[l8���
L��ɝQc�ֽ��=+ګ]V�>
3՗z�]��?��}��	;c��t뤃��<6ױq��GC�,\p Ob�9��D݆~wk����F�_1��8���;��J�����f��p$K5��P�vrM}��t3�A%H�}��=���r_��Ļ~i:�h��
#y��ro}�F��9�������n<^��5;׻n���0���Y:_�]��=Kɴ��F�	[Y�:Q�	�zvoɤӼ���e,7�-��	@����0&m[�h�-��������:L���P��Q ���XbUI���K�=1��BQ.a<J-�o���F�Y?ZNG�ئk���4����H�J7�\��a('#vG��א�ߨ3�|����P�)-�-f�(jW78�&!w�T�0��ܪr��ǔ�*;-�Aȷ�_��J	K�\Z~σ�:o�F��T*t&�_}m^(I
�<1����,�Ø�3o�Bᆘ;�^w��겁���Cjx5_�H�sH=[>4} �O���{p�1�����b�n>{�k��;1_=�!�E��)�(�`8I��]�����{��������k׺��"��t�;���[0&/����p�jh��e.jZjP���#iy6c��dUt��� ����(C'tՄ�܆X� �aR�{���
�HE�9�6sx7Cq��Ib�96��FN�	8�3��0O�٠��Xd���%bnA,��Ȏ�̒2C�\_(fHT��E%�(nr�]\cl��8�8���AZ�_a���nwR�ʶ
њB����ݐL�#ր�q,ݗ.&B�R���GtrbU"U����j\ݭ�AČ_�I���W+H�����E��l���O-��.��H��i�K�3����N�l�\��%"��9���1�ˆ�{t�K���Ԋ�_��s����|?0!5/�~�V�Z��d�4g�_Ȭ�e�V���=��[K 1*5����l���5J%\=�D#����P\Cev)����TS��x~� "�^]���>l)YM��G��Z�a}mWO�Z�D���Qډ����j�� �%��iu���4f��j����0��4����Cݤ�1�>��g{���Dݤ?���;}n6Ͼ�$�I�w���l�����p�ˡ�S��d��f��(�!s��;`%+&��Z�`x#h�R������KKA��]*���㴭�4M���vh�i�}�Bd����E̟kF�`�[A�\��� hy���b�)�U�C��,Z�c����*c���m���#⃑Ȩ��c��-�����h1&�%�SR������c0m.9�L1�,��b�D��S>���Q�^��5
��}7��Ū\�g������ Jy����(� ��!u}-5���<;B犉��&^o�Q1�}�_�k9�G�Z������qz���j���&֥VYnSB�����AKoJ�Q���c�~��+Ĩ*�jҢ�H���
���0��F�lEZ��	a9$��;;b���R�L�Ђ��	�g��H��Hw���D��0��'�ɘ�_��'#�)�*�� L��=����A=�w|�`�9�$�`ln��BQJ���~v_�(�MK�� g���M�Q� |��~����bW>J*-����V��sVA��:VHBͷ��\e��o�N�qP�
�u�r����4wK� Z���Et�9�?�2M�c~}�P}�2V*�j��4���G���.Y�Ɣ���f҇&`�t)��XU�ms���6>��g�vi�wF�!bcO*a�
!��(�16�G%%�(�q�t�C�먜3�ͷR�(̶r<"U">e��%V��Rx_|/߮�RY<I�j���V�d|r�c�}}�����F�a�����z��=�H-O�GF �ʔ�?8���z�)�\(�N�m[�CQ����u�a���Dq��Fch(I1y�
��b�xw�    �%v��Q�{�� �o�(��i�Ȇ���7�td���?��@W꣙��N��ХJ�n�o��x%�0��*��I��H�Pq���;�{&W�b�>�(��3(�및LS�����`>�p�����L��d��J��X�?�4�ۺ&&�0�����+�@<�4����C�|`c]�p�^��גX{�}�Q�])G�J��O�8�GsLIp�o����K��|�r4�ԋ�d~\yB����R|�����u>2�`Ix/�rV�U}.�2���v<"N�i�����B1��p�1���v}qaUW+$�t`e6M���sT��:t�-�l{�{5�����>���[��%���w���H^��ܳ2B�� �*
�}?���ồ5��v=*LT���q���L�o��b������.��+N�5�^f���z�z�8jX7��BƏꨳp������,��47�|�xr�ܰ|��4VV8i����~��o|�:&<�'3Y5Kyr�$�#�6V��&�V��g��P��07�pA�G��:c
�N��T"���Q�?I*��]���Ò I�G�q|��b�ک��.����r�{t>�_x+8�4�	5���\��.��XO���E�E)"ʣ���("S��4��f;�Xи� �9�!�k۱,>���<�w+#��TƋ���Ge` ��$@�S{�\�f��9��r�.sX�z�Ky�	�pX���
��H|�7.��HGA�4/�h�m/T�\�H8W8n����k��5ZJ����R�l���qY�{�w.�JP*^:B�!hJ�͆��|#����O���N�Z*C��{=��6���<�z3p@i�~6�c�ah8rq ��m;sf&��V��Ȏ.si}Pd���A]�W���F���90�%s�e~F[f����z��A��ho�,�xu�i�z.��9�ש��G;�Q�|3�Y& `�
�����O�Qa���!�8 .t}��^��ֺ VY�pήF0�%�_�=��@1��ژ<��.^� �|_���KI�R%���U���u�ӭ�l]��v-��|��a��!5i�	Y��e8Z���m�7�������_w��*�t�,�Pc�(���Q23�[�V�����
��7y��n�y�:Slp�V�*�8�i�3���qD�u4K��U���vQ���z�x@#���Ɠ�ح�g��W'Hǩ�/W�Y\HGsZ���!�Q��e��/��38��ɳs㚎�C�lG����	7;z;c���H
Af}�QM�-
���T�/�f[��Gی�J�-��7B�B9D:�%�G�ls~jp;<M��bm��3GLq�x0e��!Ѯ~W/�&8�C!f �a��q��.��P9�AS(��4�9~�`�%�`���GR��hÓi�<�(�ʏ�["�m}�+������}���a�B�:^�T�A+��U�˸���d���FmuF����|����� i�a��a��?V|�Q�o�VL����O=�I_n�r5�K�^�=�A�{_z
�S%��{7֝J��(����C;�QS��kYHV�q����\}����$T���tM�
���*���B��\#��M�ڳ
�m_0��f��~ww�-�%V������47*'躴�Vc�#؊��Wp_8�e�j.���J̫Џ��f���qqM'�Y�@��c�|֫���>�T�B.�ƵQJIl]���d�6>F�O	Xu㌣��P���r�}�<���EO�s��Z����ZC0`)�&� Aػ�I���s��C�$�u��|G/U����n)z[5α]=R��x4��K�O�B��xk�!l�W��^��~���bʨ�]m|�x���f�T)�T�"p�J����+}��P�6�����٪$7�p5"��.�O�F	��g���a�_�(���Fg]���qm9�(��T�û���(�z���Q���N+)��i�auWu��50�b=������Ұ7��'ؾ��������|�"�~i$�{n���/rg����$(�R<���p�"�Q�v�
WѨ�(y�	���an'��=}������������������U����-�A���2�ߦ@�����lz=%�
�U�e)�h����AZ���k����]o1��؀s�iR�@�^\��
��zQ�j��4SxS���F���&�6��l�z��@�hz��ǏE)��2�_�a{�f�����1��/��#x�'8�9��̑�"H�˿��G���S����,A;g̙�1�#��TP����ˬ!m�H���O�
Z>��U��H�(�P1�ˏ)m� �F$o��
-�?�Dy����89�|�2��bbi�����%b�>,8��b"ƛ��v̳�v��L�r�<�ޅ��Q�l���O��_aP}X:wYs�Yq�:I��ލ�[�L<�O+j�xwX&5��wsX�
y3f���&�Wg�I&~���H%CD r0�L�u�X�t���bls�6ff���z�[WO�$��b�%>׮nFݠy���HD��Y\]�ғT�g�uF.ߎDw�����J�X5���~c��ަ.'l+�)�p��kL�p]��C��|����S>	K
��y����\ �.o��5��_xP����]��+%K�R�0�9S<p�7�&�m$������R��6�H���`L	:`U���g�*
�<T�N�\ [��<s�l%�����tr���[�kOc��uY��	�g�5�c�N%�(�r����IP4�;vj�p�֮n%��/��HR�Sx	��n*�_LSMM��$��=��J(վ�n1�[��{j��͹J�����j������4Q�����z�Wk.@s�l�N��g���+��T~�ŗH�U*��W=!O�QD��R\�]����̖���'qd����R���j���נ��xp�����@�b=�/u��5K��$}��=����}�jM~E���U��.l$��>2�%Oد��=��GS�������&>2mUwM7|;���M�ի���c�G�t7���.�ʍ� 1L��b��ݎc)ک�pO� ىb�xdeQ�L7d%Q_��%M�a!���{75�ik������5`Kq��(Q��3�<T�������cV�wm����uu�����w���ڕ� �z�lL�\ܷ����{���I���2rl����=8�*��lG��39Џ-,c���(�q�b�";����w}���*I�X��p�b�U����D�����D^��6<�"t����*c6k^bzؘ����]#���
E��4�[cC��sy᎜U���q������O>��'N��G&�(��n/���c�>�>�qU] ��`i��{��=��,��NCZ-	�:$��o����R����Q+�e[\�zjSA	{	c
 �"�����ox�
U�Ъw8���?4��f��.�s'I��'9
R���ĕ�b�<!�ؕn��C�X��qC�iK��/v��p�=Ѓsf���dz�T����Xuָ�i�����R��a�,j]����\9_|#�"��ڍ�H��t�=K���3���1+��H^V�K�̛I0���E��3�׫�k̺C!���T�����Pf�ui=ޚ��ѽ�z�ǧ"}�]�pZ�i���6Ay����9�6�Y�0��X/���_��Z!؋7&�@�F��+��Y�ʃ�+���zf��'�����R_d]{_,�\����jQ_7�E־|�i���Nb�MP�>���l�-f�8�������$adg�.+]͐�A��f���jI®�]GcU�@�g�[�M�����3�s��ٿ�I/�p2_( �ѐ|�O������8�����	���mμ�r�H�+�@�U�M�F��0�P�"��Z��~��3�d�<��������H���̮FH�3��=����9����kM�DI�9�n�ۛ)�8������-���]@[B���\(��V�5�SPqCu�Zs������=.��o�G��m7JiW�4��� �E�S�����%5���o*���ʝif| ��g���2�Q$1���c�-#*Ϗ�vl�ټ*]my[��ޅ�+u�کxot��k~q}o    ���a���� ��&p�U�qZ�����E_�Vh�`ݻk@�z���G|�sz��k�ϖ�=�^L�5�pb��I�$�9y�g �+��KAJo���08��wN�n|������:���QM�����}�۔+�Y� �ol�Gb�}_��k,�ȁ�FO�b~r�F�.9��H9���tͳ\u�����I�HaBzƆ��\ư����5�~�1t���;��* i�@G��	Ы�͂R�(��n�+X�Z����ݻ�wP4�),�G�� �ª�;z�2�_|� L2l�~p���i@Z��k@Nz"���r�$3��U|B�x�,7��ĭ�w�Y�&;4���B�o�pXz)�s	!��)��B}W����frN,��$���m�Θ� O��	P{f�}a���������?��$�q�D�d�*:5��X�/�DϾ)fB�^���T��*?�8:��@�h��o~h�~5���k�����-z_�.���&*����'��uM����?���ۨ6z'\w߉�f9�xv�'��ƻ;x���fa��b|t�6��2bX]8��<��/}]� ��F��q^�^�����Ǆ�����k|%���鞮[졀�*y�t�ϒ�,!���<�P�6��e�HFǴH����Z�GDR���O�T�V�T�w��ޙ1�׃�����|��՘V=<��Ca��F����	ML�HEv=cZ�%��*�F�6t�Bv`H��s���'���ߛ�d�⡆N��Q��Lr6����,D�OqR���D�/�q@���/��������P��%�$�"���D��.g��_ϱ��v���!�%;�Ӽ`*�wOHV!���}�6�c(8�N+]Í`)� Yx�%�����[\`�Y��E���t�� DỦ7SE��¾���(���0)�~NS2���MK��*3ޔj��9S�>ƴ�e��w߂=ʂ]���j�yxp�YDQ2?�]����!��yHІ�[��N��7�.IY 
��a���կft"�z~��H�ۅ IT���&��"��e*i���	b��_�"t�Aj����1�Ơ��&_==d>hCZ,�c9�s@���o�:��jv��|�������B4� 
Q��(e�q�׀�.:�1i$
����v��7U����� ���9"vk��Q3]�..8p���v��8����TԵ��-C�TQq���ŝHӮWRŰ�N�w ��CX'(�����K�?��	���),��ER��MC���"㲀���Tkb�v�����A{�4f򉫢t��B�U�D�Ǣ�/CG�J�5㵹� ��}��yuas��m�ߢO�� R�h�19�(y}�lP.�`�9AK����>��t�.M��_v[�4i!�DT��.���$��y��0F1V�$(�O)���u�{߈0�^m�p�A���۔��K;=}�.�L��n��G}]�۰�Y^��:;eJ�U��tݕEҹ�<Y��8���c��e�60�F���S�0(��La0��b
N���E�QR�9�Wi�����(yDN�{�# �D+cD�p�腅.���(t�h�1��H �ca��O���r�[��3`#NB2�3��\��I)���B[p�'��m��PK�ml��~��N�[�$�����K�d@"���F�� et��j}	����?���I�`������A���:�{�о��[Sd�$��>�}�:��>����5���b��,�e��4���X߶:�"D0��q���u��v��x�}�mgl �����Q���$��O߷y�6�Wŉ	"z��ܑ�Ej`o��h�m�(`���8sm��#�Z=��]̡�,��ԓ����y_c�Dr��0`b�ŏ������CA�
���QB�/.����g�]��d�_Ѯ7Z� �Z&A�Bs������J����Y[��cEW���K��Y�t&�Q~���Ap��yv1�e�^Q�����7exR�|+�N�����J��ɗ�\��%��j�>���b-�l�6U09�=暤��?�~�/��Y�xhN���������ƣ�RRMt@��4�Ɔ�L!�G�A��4��� �w>��K£Ш����
��޺%�:�1)s4�ky�U=��귋�%,���hbS��ou�\=�v�gogY��c���%	�t��N��3�H�ސJq�QQ�屧၈[�/��%���=e�����)Q	Hi>���E1�e�E����0�xK���S)$U����S����cM���;��N}��5�9�ۣ���g�)*� ��=D���r���^�S���- X>[�����i5<��QVR�l����B�����������f�f��7
X��0=�Y�@���{�q���[�k�;GfY�~D۹au��.��49�Ϯ�^ڊ�-�z_E=Q�Z^gx��}	u��Q_#xmj-��ӭ�Ch鴵�q̆˦�p�D�۱�����:i�U�k4�;i�D*��v���dR�
������9�mʹ�A��� $r	��4�f9gzA�4��f�/�d�o5@�e�Q@�C��O�
G�������{�mB/��Yp���X_i�v���X�Ǳ.���I?Bp��Q���W�=���|��ܴ��.	�,�3��Ů(t �Mܿ�a7e��Rܠ�?TD�v�Eϱ�┵�Z���>iTG>���B�����A�_��*�yX�8��u~��"����b���bLO�J�Ya~���:�@e�-���r)�x{[�/Nr������xP��4�����R5E�����	��*��֛����Lft���m�o߂p(�
��s�r.G��#�H ~T8���c�"<��TIq��;����J+�ȋ��)���|)�����A�i��fj����.���6N�����*f�!��W��Xef8����3`�,����;���a�UxQY
��;D6v	�"�l����k1s�bY�n�%� 8��N)�ct�<5�^8P:t�ħ�X,�?]���{���ia�"�B�n�W�āP�J��x	��CJQ�KGB茊�γ$
$��J�?w�C!4��Ȭ;�vX-��Ƀ�M1&칤F1���c%�U皖��ԩc����(\L�Th �O�+wGqH9I8�����H���R}?���o��+�`�;�R�>.$X�rU]�u�ˎm����]��5��;|O�Aۏ��G�`���V^X��[���[�ZM Ga��Y����1����X�2�R�ԏV��!Q��1�RpD e��Ղ�^$r�G��h�(��#g)�o:0Ne	��Xŝ��ꙩ},e����`Y�xm4v�z/�Ji�� ��|��~L��wf��}kw��|�V⇊u�o�KMC|!^�̘�M�S*A����z�� ��*��?���[$#=q��"��Ut��kB2Xo�t�J�������ޙH�u���8�Y�a�j�D-7).��c�oX[�ռ�L�>��4�V@QX�b����I)K0�y�����~��"�d�D'`���U���h��4!���[�,��f��n�]ͣ�q�\%_U��qa;�F�RTܚ-c|�<����(��6��S2Y@0I�fn�*�p�����챷�p�ai�l���$�9��Pv�(�f�r<�	Q��A��e�sz4������Y�պ���_5Z��+��ĲV��B�(R]����ͥ8��^|զ�*�q_��CG4 ��:���\�[Y��{)-�TV��{���n��ģP�s�=�*|��� �U���d[k����p�,���G��й��W�=v�k����+�kp�F"Ʉ�����̷��t;�7��9�������Dn�H����_���?[��\%%��7�+׾f6K��o���@��e�T9�-TGC��U�C�Ćl�|�~E��r.�F4S��`��R��)��([Zl�Y�(��S	�>IF�&E���9�=A�w���I�����B��i����{�ͯ��aUZ����VV[t�of�(��No��J��R�>��@�[���[�?����g<l���:��2���|I���5)��
x.����א�.�MJ�6�Ŵ�Τ.���Y(    E1������g麎4���kL�"�2������L.�.��<�����YA�*'�O����ܥURՖ��D-��JV�{a��J��Fi?�E
A-�Zh�~��(�<��rӍ$��N�����}v��Ra�*�ȯ<��YQ�i�k��bpk7��_�ҿ~��W����#��,��:��S�@���³*�e����c�t�+�lU�?��P�����h����'�.
sVK�1v����~��Pď��,��s�$SG7��߾S_�
�[P檞նQ:��r�5D��@��;<��ʘ�
�5Z�I䀞5�R,ֻ��`:��}[��(��޾ͻ�1�^�#��p��d	D��~����À�P�4E�d'&W�NC��5N#���m�0UqezQM���K;�f��҇[�C�B�׎��T�%���a4���-a :�+��,> 6X�U��Kŵ�S����.����,���6�I-];У}��v�%��P>�r�&�|������nƆ�)�{	?�ٷ�LP���ty��0�a��YM� ��y���I�`+��x����B�sV��4��0�\�w�Zв�n7G������:ss�_����F���T�u�b�~TA��$�d��:����͔����j,(t�d�q<�oͅR���a�J��[�����6f�>��DO����_�oIo�GEGy/+����Xt�?U�>=ȈZ|3�U���G��տp'N�{<N~�=�ڵ�y̎~�陠��[��+�}B�Ö�KG'u�/"X �66��m��G�_|�r.Y�t|������|KCGy2E0ߧɥ�%����^R���>:_ʼI�R<=RcHx8�d�z�ãa&�����1d��6��>�'�Eą�̾v��9%kG�O��gU�[��7iQ�0>�R�����; k)���9R�?��>S�>��윎Ul���1�ΡX��tjT7^����[dpY$	6��M��N�S@���P6������vIj)��Ȣ1�]�ŷ�җ���75h\��d�MC׍�`Zl���"ҹ�Z��5���0�M��G���,�8}"��sQ��N�!2��-}7[5<��0�P�91>��n�Z���s7P�ub	�~|�|c����?�Avm�4#���2CF-�ZB�vW��MS��v!>�Kf: ���r��'J�Kq��!ֽ�3��ω�2
���ͧl�0S�A���u���,(��7�����Dc._{�鯵})$9��Mɵ�?��Ԛ=C
��IE�g�ф�`�����iX��T*�RF<�{k\�K��A�s�@m����qp�sr�76̒q.},��"��\�v<��i����2r{��6	.t(��H��^8�̑I����|x8'a/���;�B!ƨ��-3��
U"x�.�Fe�o�Y�g��@B�8j�Z�������ط�wT靧����f)V���`���8['N
.x��Z���u�G,.tK�6����+� [���ɗ번応p�;�(S����l�5��X� S�n�-���u�"�}0��4`8��Z��D���7k\��Y4!��h�FIs�u�������R�"��c%�D��o'���ºL�!���>��a���6�j5�3jakkrl��H��Z��,��"�u�W�4�s�cڪP�(��Q�`U��F�j-���@�Pĳ�r���Z�����H%�U� �>�|���. ��z�B?FSk�)���f�-$�`-��q0U���n֢"t4L��[��=2W ��*��d�{��ԅ��*�Q .���VP�p��M��
PK۲�`:���}a)4v�8��W�7��u��k�슱2�^�����t5�j(/�&I;��v��(���0R�^�,V�$f��(�٫�j�0���s�:��j�S3PC���v�Ri3��B/�h9h��Y���X���=w�! ��S��ޚ�c��}:��<����_)�G�XV�3��U�@�c.�'/b��P�H`Zc����ɇ e3M�uB�ey��3u���XF���8[v���/��0�ӥ���L��\��vR�ua�����k\Q�|�2!� �z�	d	C��Z��ڷ� c#�St`�� �V<��8�x��uz�X÷w���_���ycމ�1H5O�4
#f' C��Wϴ=�B��O�,+ɭ�pkq�w�=G�A@���5Y�c�bd[�@}�?@��,��[�#�������o�ٗ/��j�-<����2��}�v�6���*���nR����q�ʏ�֊�:\�fuU�OV�t�k#�����y��|D��SZ�d��F��~��s�QB�J�,�ء�92ۣ��ka�&�w��z������9Mi���TM�yҏ��~oT>�ԓ}������և����QƑ��?������<��εG�5a3X#Z8�q�+�>�G=�I����M,�X��s<��n9��a�8_�e�zb�O�w0t`���C|c��^'�B���\��������^W��SʞKI�ʇr�X�NG��%�|�4o���b^]6�13����A��Ϯ�R2M�=�� >ͭ#	��s9�=�L"m7�19�Ģ �$�]��c�<���G22�N���*��]|C�{s�sE��O���k�ΰ(G�'%O�雈>k��6E�r�8��D#o��xB묟��ߧ���B��P]��IS�z߯��	^���2F߽q��d��_��Ȩv�5$�S8TI�9�B��w���>�t,�V�H����� ��q!eXa�}"?����gtD�:�#� :���hCF���	NK
�cv�e��OQa`���-���DB+Xq�TiX�k}���E�Ús��>�����G#A�fv���&��&����R�˴W!߯Ե��4-{B[-��p&���ѐ���ҊI���(Ki��&W��o��p���4�f�����N������0?�=<�Dm��G⁺u���mMM��t�n�[�t�1ծ�H\bY����tA��~^��*K���n/��d�}N0�b,�A��-֋�h�����t&�����G��0�T��9����0���c�W�ook�E�""�M�<%3'J�����������tΏ�*"'���k0�� �`B7�	�G�W�t��Sa^�]�]|,C�bL�)'I�{8�4�I�,�K����f��0R��"A@���5Oy1����Ɍ�&���	��?���ugLW}E���ɘ�Ҕ�n�����0�"��!�О`�<����.aN	F��x�;�MƜ��Qm��Ņ7�LpJ�<��P�q�>8�V2p�dˠ���=�c����2�V� �l��$�َ����츝n��x"�q;�/F���v������_����ȉ���h�����Q`�jx�����v�ngn�d��]V��0�۱u�^�w@��OD[�HR���2����XH�3�����̜9�{�|�-I��Bp�9��F�M�r±@�p�L���L�سN�!N��*D8��5�D�Gn�k���(��1��;ӛi�xb�`g�.������3&R�[4���������#x$���?���V�ϼ"9e�pr��I���`qF0�,z"U��7�j)�)C�t���ე��������AI�zJC�6ivE�TQ߲��ќ4�����e�����;pm���}
uE*,ܕY�,��v}�y�4uc?�&S��J:��*:���we(��t`�Y�sS]|Rtl��mr^<L�	@*�F������9���|�Ad>:���H��)̡�0;�sZT�x�z���4��
�o����>օ�+.�5��ҷ0�Hӆ!=IX�=�>Y��!��æm��>�xԑd��T�X�+�+]��5�R�oLibU\W�b��Ī�<oq]�	V)&����3���4K���G�<�UE�͹�Fe��_�Q
�J%�4Oj��ᨶ|��٭��g/�U�Le}5�1��5F�W��j%�Z�ϙ�ϙХ���J�#�g�ƙ{��C�lM�˰@Q꽼D���w����EIm��S��гԄ�"�l��Q/ӗ5���ȴ|�9�����թ���+}N>c��b���]̪}K���k���3�:��9��    UC8k�e�T˘T���Î	h�4�EkFr ��_�bV���
>)�/�{��Nz�x����ĝ�YDr#Pᙱn��mm`�X0��[��}0"�	$�R�-Yv�2���̱�}�0��x>�� ��E���#?H÷On?O��Ca]����$g>�Y`�$�]��������[|�?���h����6;=�����s��Ǔ�耘����#��DY�i�7�r1�����31"�������d_|��_�kKou�N�7�4j%%��8{!��6U|$&�F����ؼ�j]�k��Z��╾X7R���~��p���	_Ӝ����aKc���y�Y�/����q��/����X��Eͭ�k_���T+��sG}�)�PUt��W
�����~m��zh��_
n�
��i�AX��S�zLs�U=_�kb�*�>��h���Y. <��r?�y
WMƩ�g=ov߮�M2~ו�Lt?��dΊ��H$�9�L1������d��2�ת2g�S<�󸟊wS�O���	9Yeb����s%K�'+L��$��Hmb��a�0��U泛jџR��|�Mxr�����U���M��a�":��>|R�&�,`R��S��q����Y��+Z+�R�#<�]��=��d�_���Rr殞[`�K��Ն!��N����)�]��R���h�Txq����Ft�/���e4�zVO���Ij�[z���;�ސ���o���s���뱧��ͱ�-!���bd�zׄNktG�G��=aib��ܨ0n���]�����J�B�(���zR�M:?Lz�� ^yژ�ڷh�l4�E`��~��ʊ��<}[�v\���h�~�>��S4��x�toѽ�`�����37�:�O7$�]�Z	~a�>�Px�hȏ����">�=�g�Q����d<������@t�K1�W�}��h,�0ڿ�k�����Нa��W]	�Lq���V��KQ����Ņa��X���E}�uWs^ᅕ��k\�9~�y?d>��҃³�'�6����`/��]�|\z����"]L��0��^��!it�-2����"��4�&o�)uq<����c�y�G�t�5�GK�m�=xP�E+�9es�t<(7�t}D��Do�9ŐЩ0�u�WJ����W�b��s�:��+����������Lq�]��7I�s�.���=1��}NG6�l8�Lz n���2����Ժ����8e�3>$��w�7":��]��{�7蔙$����֓j'��cXl�JB\k�_ ��e&���w۷V��!�>���n����[܀~�`r	DÔ��,l�����S$��F���WV�R˷K����WC�f��Ҹ}2��\�����FT�g�lg�u�W�ۣ��68!�.�H����R��.��*���t|ߥ��  �3��|�邁5ۧ������h�_� ��5��R��:�:��:���	�w�����$1lD]|y��w���/����H�0��?(���`o�pAo:8;�K;������6Ս�ųSڸ�6�g��N
��^��
Mr�U�����c]g˜F��瘸k"V����ɐ.AC�����X"i워��T���̴�.qW]Oc*Ċ���;㣨�z���a��S�:Km�#I��T�1�yvUɜ*�li��;�&SYf˥?�������4���s�(�*�l�o��y�V�٢/�sM,�e��c�I��t�E��r��4���Q����h�v�6)�7��p��u� V?�~ �(�2��י���qR�ŗC�����V�5d�JuަLE��R^��e��:ح�C41�~��ӎ�D�7���h|�I}�w��[�����YH�ʰs�p�_�+t���R+K�E֤@վ#�-7)VE��}WR�T+��4��2jp����9������i�&,)-["�	����R\���õ��!O(TM��栤'�o�	sC�|q0]XN���#��n�����8$q�6$O
��j�z���&�e� G�x�;�J
,L��Y+�����'��hM��ӂ9��FY0B��z��L� t�.��?�W�\t�F/�h�⣻Z�-(�RX�T;���IF9J�&�]�-E����%B99Q��׎|���9D���0w躆���+`v�^�\mI��-Ѧ�@&�}[�K�o2�O��0Α�8��	������K��$��~������U0�t�n�x�H��2b�{%/�^Q�nx Z��`o�\����7���Pk(�+vWT
���E�)eѷ�'�Q#H|�Pt����=�5��zz�g��-Cݦ�5&t���%<MVԏn�I��m�5pҸ��$o�EF���@��d�M[9'���E�)��haA��4h� l��܏��}����7j���v���ێ�Ǳ���)��0�s���WQhĉjʶ��Y��)�[mm"л�I&����GR�����Ԟ=���T�`)JS��7B�'UNQ���ײ��怔��I�T�p\yE�RQl!5X�'���n��	��<#x�sP\���q����4y*+[O�O�'��f5�X�e������5垑��J/��
_��Z�	��8��(T�~k�T����K�bT�0�s���d1�_�w�HD���gdk���I I���Z3��6�g���]��EmiQ��d) ���`)������o�*~}c��s%��Y�0և�+�����r�K=��@����~�gG��T�a6�>5�{e�)	����{��D�H� Қ�J�}�F�C���vl<XP4���������hX`W!��fM��/�FvY��Pʃ��1_7�h߭4H���C����"XG�)���<�ʚF}Ka��wyГ?�[�*�/zJ��^�������}��D�����,L��)�BhI���]]桮ӭ�yK�t���'��B�h�ǧ]p���Oq3���,.���*��u�k�����5@�d]0�<ֿprW�f�D��T�p�_e�ы���nyurmU����8�p��e���O
�~������b�^G�j^����9<�QMa�ݗYD�u��e��c��\.~�[����N�������H&���_�TI*��c1��⮝���®�<�gw�>�Ò�9�����&�]K�n�n����$��h.�b ?�A���'�]I���U��#I��0�Ӥ(�蜇,�����^;����A=�A%��:?ޓ�֟nX���3'�4tID20�&Mp��H��w߇�d�H/���9��Ų���:��<j�%}8��(^^V���/�Z2�%�ۖ��H9��ӷe��~v���LKf����T2�%��v�Y5LsMs�yץp�`_�,E������{?�^ m���W���a~��J���)�Z�K�6���G�Y:��1��-P6ӻ��!1�u_o��V"g�Y��&�����d���pe�kf1��p%\U&�����x�J�Wֳ|�W�'x,V��HgY�֬��P��2�����.�&T�M�\[l��.��Z߫G`���Y���ڄ�k��q�k��e�����+Å,/؞�~I�xGF���ɗ����Z��0�ԌKf�^K�/�{�K��������oȇ�cj�J���N�r��w3`����S�f���څ���w4vl%S^���m�9<�6UHP��4��ٜ i��/N�5Q]��4,.��ꠑ׹��m�S�����U��S����
I%	�;)��`�gb@%�^u�� ��xf�o{�=N-W*��'ob	���L��L��ǿ�`�����r�	|��2��'��9�qz�G�%���/��y^��
�G��A�Ίi�p;w��/
���s�NV��9W�ls��_3��nGA� �|�{|�Ƿ6^�s"Y��_.w�	>��Z������F��U;a�\Փ�s�*��9-ѯ�%W�tX5�dQM�ŷ8��[s`�јR��:����P�|o�F�������1�������^��>��7��D�8�y���#BW�x��ߕ���V�ޞ�9�S�G7���U��lU�W���:�D    ����ǀQ����P�&o�.�i#g�������p^�-�i��{ ��Dzݦo/Dj�չ!6��<8_�Dw��e����mq�`�e�gcl�2-�7�e�)����jx tB��:Sz�&n��&�]��n�nX�:�=~�j	�TCU1�%u�,��]Ɠ�n����T&����aU��eO�ł�7u]��i��b{Yy�cOd���±�j�1�Ec�GԷN��	s?�Z��Y��[�S��7�k.ю���@�N���/j��	O;_l�����/�.���J�/��?3`GY���\,&��v��O|G�I��i��I���:��)P��=59�|~:D>�ӆ�J�nŔ���ߋ6�_V�jk�;8G��5_\��ƾ�P�q�a���fK<w.f�.ӐR���ت��B[����(ܧ���B�(�BaW{
nL�
̲�yHG�A ��픠He�|������a�z�[��!<9:��	��Z�������pm���#ܝ{֘qw����Sϭ��9I�^P���w0Dxt>%M���2���b�5�m((�9h�
���9h��D}8$�/���F���O�G2��r}��D� �e��(���O6Y}��7v�m�0��D{x,����~�� �����{:������j�Ԙz�����gT����f�Ď�Z����|3c��Ͽ>��1��QX��C���̚�1�i��4������=|�����fe���){��it5$��,#�6z?_��2ݠ�-�@2�}
]�;�5��W"O5Se��.��b-��:|EG#��Fa��"����ֹ."q�_���>��կ��0�lOe�k����(������!��zD#o���4��,ssaq%��T0�+=j�'���P�p�K6}��h
�$�O0UBt&�ދ�I�~�MZ�T�u�y��kYP���$ƏC����J�`����f�Kʁ���e����O�x�������j?����f�>����BzjP�ѹ1�%s������&V��z��R�)������N�P���f��gJa�H��.(���	1Z����c�nu�1	�.�~�}
A�ΚY��n>���Zo��B������\33�����Œ���(�b�v$C�2�O��ϼX?���m4�gts.'K��F�K�:)0�h��&�D����`�g]�b�/�It?��j?��iC�v�5�]�a� �ZT]�"��0�:��2�2X�`15tk+%�W��&�#I�ܾ�������2� I��1ͭ+)��,q��"��D;�Օ&LC������o�*�����J�RtI�����+!�_�f~k�qUW��p��cC�ᶦo�iгŬ�$S�Z>�LhQ��{pn�PX�Z���o�&K�Z� �A���D��=���X���,*ge��!�J�5iB��F������i�*x�1����LY��_�D�l��v�(�D���ަ�'�]V��R^��rY���]��ls}�=�ۤz.��x�Y�]�`⮍jRI��b� �*u�έN�D���
���=)$�(I��,'��֟��P���]{�t��ɑ�ު�U�W��Y�z܏������DF#Q��0Wu��?~0kg�!x*UB�^򉛣�gP� '����>(:�{�	t����Α̎��[vL4��f������u`<�ɬ��%� ��Pd�����f�G�r���%c�KU^a<T��u�!>��(�ӿ<i�ԧ��~4֑����W�) �����$5|bڊ0�� �0m��;+��,\�7G��S��&UMx�z�h��b���3��0oEy<�<��5LY�F�c�0Y�!�KO��&D �	SV
4�_�N��}�{�(��U�N�$��	�����Q��;)�-�[��f߬4R%�I��ƪ�>�����k�+j,�t����������Z~��'��"=��T�/��S�����`NgS����3���T�������_�b�ѹLa����:���\.O��1��>���A��z���Ȱq��t��׆i�W�Z�fkG��oilѱ�}s��޸GGQ���� �Y*F�lbbKԻ��AA�Un�����G]���iҋϏ��X��(O�9�}���繋7��'ɕO��T�"<�9�0'eҦ��w�"mh�+Z���F�`J�L�>x�7�[6^��Vt�R&��_����QEӧs�I(�$�}à��08�Q��P4�v_=�њ�Nt]=��2h�>�_�
I\��䡣0�Gx3�G�ʓ��(����p��ж��V��8��4���ħ��Z���F�t���#<9����ԁ�C�M�Lۃ��4�M\�Yԥ�|��!)ݩ��#��	q�J��Ws|"�ꦋ&��v� R��ѶC�p�R?�kÿ��`:���s��Wk6����&��X���اl�xHA|��Dm�e�wAo��>�Bb/K���:_�}r�䔢�b�^�n��;���_T �Rj���a��ޘc��N�I���M�_�dQ��	L&I-!�K�C��}�e����1Lf��Χ�(��f��W�v>�?���u5�!gv�qY���|`��:�4x|d�ۖ:#���;7�.g�v�jr�2avR=�sfu�v{�P��i��
��й'Ƙ)��"Da씋=� ="�`���RЩ\�\ǫ|��tD��pYۇ�0_�"BmB;�]w~`f��^2�����]�B�P�H��l*�u�4�����a���Sǥ�n	Ƣ#��Շ���#$���siGK�{������
�P�H�L1ڠ�c�2
C��ʪz[<��D3�z�%�A��%������&�sK�z�s��C?ǯ�
3��>��MX�k�x ��M?�;�Y�xaT�1�^��eA�*�RM���7�~�5�'VZ I��o딃���$*���?$�k�� N�<zP�u)S�҉��0�^�r|$��0��ݑ8~X�=�`͓�2F�svQ8#!��������Rr+�F *�5����(����?�������0�4k�Oܤ��b��~9���t.�x`+i	�v���&��s,��;|U���K���C��-��!�0�W�}�e�dO5G�뼖T����j���фbBI���$��1���M��k��}efj^o}��!J����S;uJ��Pk͇����W�E8ʡ�vםs�4�%�E�>��Ʋ������P�w���^"���Ň��p;��Sx%��z�K��q�p52%]��]Jo��e�g7��D��Nb�<�ӑl�� �w%�p���YMB��$,к��+>�3����s�����zt�M����b��?�~�'Er�p3P�i�؅��|.�b���ﾜ�:m�j�����:�\���ܮ�~X?E�G�6�iS��93qlя�����|y����q��Ww��wֆ�8]�ʻ�|�ƣq�;�<��aruq�
U�n=%a*�z��!��µ��>0L*��Ҍq�Tjo�������ڮw��ySՇL.�L��r9���M-�hIO�(4w�Z���t�|��Q��9�����X��p4kW]���d����Xys���d)���?x9��GCǒ�%2���K:�W�����9]I�]�Iu��̆p����\����9�*,6an�9S}�����˃ǗT@xPI�lv�L����vf�M�_(���K��s:$���0��ݘ��"���9Y.���Ǉb��у'�7����W����h12�~�aG�AqnLr�}�Bt��\,�4�� �[�:T��<��JCE��QS3�8S]mF�b2��N-e��&q3Ӝ+x ǯ�Ô���@-T��\�����/��NY��?�]ȞﹿN�Ѥ��������w���36�I�3�����ǚv�Ь�/�����ӭ�N�Pt!�y��8=&�¼��f�
��8���dw��ǵ�$U�"��Ck���]h�%�q���ɦ��):��-�o���/-���n�&�Ѳ��G.%K�����q:�k4�|�?�Ht��np�]G���1�trU����>t��G�ԯ��t�ށ�    rM�Q��3Qm�o;�p��V�i:��OZ�<��3E��^��‎��5�!N#z��C{��KZr?��i$(¾M�@�Pn���h��9|j"<fiƉ�Q� ��w��d���r�Q�=��.3S��Q���R���tJJxl��՜��?D�?4��u�ѷ�����P��F�T�7����ܩ�#h�.������ ��@7vT�*��oK���h�j�18�U���]�0�E�:j5cR�8����� ��m8�}��ٷ[G�w���W�>����7�=ęP}<2�}��#��7et�7W�Y&Lƺ�o�_>��x=��$C�X�q�@
D���):�$��{O��)� �a2b���B��-?��G���H:I�Y�I��Z�I�;g�)7�F$8���P\؇`	6w��/@b7��'I�7^�h(i�� ��1���D�?�o�/��5�m0���
����1D���[S��v>���S�1���D<MZvYڪ a�g�T;x۹@��,WB��k��..�9;�K�
^���P���k���v���)^��<��p�=Nw�޷����2c�a�[�D�E��ɥ8J�����IS%�>^��v�S�Y��w�:��ɂr�@��b_|�9��	��:�?�w^�,���"�aU��z>�A�����|Q�?:�b������)+�1O�1���SƵsjھ���f�(�}L��=��1SA�[[�<'.�a��m�A�.�B�����2�n+����R,�xdRq,>��=U�$��P6&��e�|�]����l}�!�5�Y�Y6���np�қ�Af���"!E�� B�aZ�+�QC�f��F��JG��YiqX�����%�hmP���.�F��rݒ�a���x)�̩3�Z�(3 �}�=y�0�Є%|v���%B@7ǖ3��������(�����0�~�c��4Ƿ=,�ɹ�[�e,�v	�aYj��?�\z� jx��*�:�Ӓ"0�DN���@�2kv��A*1�5[M�($X9�`��p��m���N%	�L?�OF��}�N�?��}]L9��9H\!���`�E~�Δ�j;���SB4K 7�HTН��*�F���q���GS(ߔ����{_*L�����i�z���:Ew����h��V���1+������V���=u��c�����z��n�o�g�p�y�n�^��;�NHk�Zm��VY�L:�����s����0�
��(���s�)���ܦ���K��H�3��;h8(g����*}Lm�]AC�t_�R箵ʹ#�^}�?�g`���(Ťު�\
h��M�Uz�.> ��\�u���|��(EW�	]�\�7��}+�a$ˈ�s�����4�i��Hn*�g���2���`�q$V��)����٬G4 �_��=w���x��Nk�I��/�o�:0�E�����~M��1��jqK�WQsf��g�>��$����men� 8JJ%{�ǪJ_h�j~��K��A�)��7�G��ے&AP
�m�#aj�:�=���p���]TTz��N�j�v�;���z]cc�5"�3Ѱ��ϝ�:�bC�Bp�4nr��a� ]T,���S�vJ�=� �L]Z�F���4>(��25�Y�������3a�6�j�`�x^j�j*+h��`լ�ݏ��`ډӺ��pMZb(Ji(�u�wΣɴ��o��� �ϬD!��g1T�|�����Q��_�@ψ�s_?{��"E8�w"��y���]<�9}�/�K��>̉mD͎B�o�5H6u�Q�c@�Vě{�!ԁ~/��os�ڴ$nᇍȂC9�5�;���1[�X�K'�~���Z�������I�I�u��mX���J���e#���=(���Ҝ��M�ֻϢML��Z�jB,Jv뇫��G�!.���-8VH`�sz�PUk� ��V�y�nbE��'id���W	>�B|ы/Dq���s�D�m�)7��8c57ӢB���@��[\0�h�ٗ��vL���,%��n8�B�ǴT��4T�.�1.+�[��L%��0�f�X�~p�d;P�zR��0����#Q7 �O'�F��G�{���f�\ໝJ�[�xp������Ų~�O� �q��"B�����Nꂵ�7v���4{ G�b�����{C�U:��P��Q��f�o`'�#y��:�n���`./�ˢ��Q}�$Fǐ,X��V�јɻ��;PR�먍$p��W)�%��޷H�8@R�0?z�yV���P9�a���S*��R�R����Qv@lAi���(��i��{}v���ͬ.��~z���f�m"Us�S�3f�������߳?Ewp��xS�k|P�c-�F�3�w�}��S����'�F�*��v�h������6�-���Y.�H��ԍ���ݘl�ܑ��B���;�Ra�l䂦Ň!���9:�O]�#�����i��+�p$t�}f�Qdq���ɐIa�,N|쾨��Q}�x�n�!H���O{=�0E(���"%�՜8v��ѷ4*AK�]�`sQ�0ߨ���
�5��u�&�.
c�Ѐ5�'É_�4���%@b������.����_��to���η�E�F��M<dz�£�ܙ~�o���V�����X;�͊NA��L#h8|�&/G�G� ar]��BG0��.o�9��!�>�?�R� o�\\J�J�<��X��1�&$޻y��� F1_�|bW)9���^Y�)ũ�]k����/�j#����P�0���{Hl���9�F��
<'�[�B�~'���1�-���Q8F�ߗ��_��m�
�a��U���'�^.f��pt9�<�Q�E(v�>.�ە��j[�jl�EQn�S��}��|����� !L����չ�������f��Hr���C��i�p�}�Fi�
�r1�
��/��T��wؙ}�����m/�!��������3�	�;F��)� ch��W�w�0�M,_��ً�\J��K���d&���*�I�(��0�:s9&�~m�-��jp�+��|�6���s������r�|kjB)�J9�R�e6H���k��Q�z�G��\�o��v�^�swOo��{�<�YoFE�=��v�c+D�4��-[���Z��K���k���gr�~3򨛱<��
���Y�f�[S�8л�%�s�J� E���͆`�0��
'�Q��N,>�Rd��2m�4G����;u�-z�H���Y֋��l?��F������.ց��^�L��f�ע�g>ko��uj����t`��YK]�r4��1^=�t������ipmH�5;���<i����r����c�`|9wAZ̤�<�_��=�HIꙈZ0��y���t`�eWϋ�M���Go��{-ǋ0��P��֍�s�`�˟�`3(��7Y_����p=�`�j���&Ak�t�j#O�����r:d���ϙ#���2� ���)�q@7l���saV�o����lD.S���	�N�Hֹ�sͤ*����8_(��{�8VV*��\�ɭB�s����F���2����K��C
֩8�7~W)Or�\�0<ҽU��TC����f��˶�`���t����8���
��|[!��v��q���c��$�O;�ƭ�h�ƨF(��"vI;:���׎�Tb���7�g�8T|��i�A.��pYK4�㹧Z�A����p:0yq!�]N�&Y7�;�C�"A�[Z[��;mu.{b�o+si�9��H�g�>�"M�|�Q&W_��Sѻ69A�D�]�`���8tpS���ɷ`u){�Q��2�͆��G�C�E�cN�^kY
����^|S)�z���<wN�R #�o�(����h��5ߝP��>���w8��5-J�����4ܝ[#�($ο���Gm_��ʋZYfB;Ӣ��	Aa,��
�	q�f�g5�N�Җ��ٸ/R��Ϸ^�`����U�I^ɻN/݊�B��.���m�
���k 8��׊ԙEL�K盎����Iu�R#�=�<�v���ޗ�:�q#���I����1!��sI'�1��SY�\M.���䨋���K����'�?�dt    ^���p	ew���mf�]u���x���-9��޹�|A�R�t��B���M&f��)�Pk�` ����� '��ə�<���;v�I�yw�����|˯�/��;2�� �)�K|<�;�=:��kxN�:
a]����ǑI��7	-pY�\���ŵ;R��ѥ��K��Ѭ�7
0M��8Z���ۑ=�Y� �(���U�%;P�I����H�c����9�ΩX��	���	b�e�DS���e��bl�g��d�����AX�AOʝS��������y�������s6֗X_-H� �g�İ��c�0��Ɏ�{�8rK�ՆO�Qd���,$e�R�/���q�F��� �x�#a��շ([m�%l��s��5�"�]�(�IJl���\8�iמK��5f�ə�͉�S��s
�Q��o?�������x����V
�Q���%�"l���}�a�
T�!�R/�)$; 4Uh��[Qi�K��/�*��D����k>	������ٴv`� ���7��^�08���d�y��:��SYЈ>���E���l	X�d*uX��D��g<�V��@�����������J%� ��K�6<��zu8n����x�8"Ɩ&��:�(OQ���K�@��P�%�� OV�W�W��+GC;�oU�������0��_�"�=3��]N&�8f��� <�ӻ���Rh�c�B�(%�',j�Du<�����]�������LB�h	n�hv�$�vMK0�7bf���YK��!ܣ �@ �6�_�ɍp�Ǝ��[��A� &c��|֫t���0UމKsi��ꄮ�iIM�HX��9~�)Lk􊴇�PY���sM��t�桋)�ho����w��#�<�ٹ��.����� �����,([�a"�Ԍ[��N�����&��q�W��ck�4 '��1�O��	�Dh�����C8&z�.y�0Oi"��f��p�W_���̲���1��J���;~n߼1y���ؙ5�G�iEқ-�QbX#*U����(SJ����Z�G����>)���;4;n]���=(�Q��Ϥ��}�x� �b�@��> }��6����v�g�w�H�KrA�m,�s#{.��g��2c�-��8�S��/l8q�Q(�ښz�ƅ
?�]�� Cׄ�k�3�1�<�h�N��f�gLq�|	�f����,=a����Hj�I����	����L*�;8n �!�N�iF���$=D���@n�����@??��x�.���|������P;L��e�7�u���������=��\�y���/J�vғd~~��A�=C�}e��ng��c�!�K{YC3D�S|D|ߗ	�q?���~�4��GߢZ[����sI���S��oo5�����`bgkR]�GL�����f����[��х)�؎�h�G���%�k�]r;Qp�ԑA����el�} V�I��bZE�����9�4/��(���P�餪���E/��2���K~|Vt��n�q�ʂ��-{��XB�X�N��҉$�4�6���"ɀw%K ��[Wwq�Y��e�3$���э.I�Ps?�R^����4��x�Y���P#����'�δ�Q��A�&���3����{�S7�h�γ���|��9�a�z���zѤ�8���f�"u�����B�+B�b�"���嫷���1Kq���3=;�x���V)$�Gb�^�n��h�_pW��y����9 �Ԓ��۱t��"�v���	��\��ʾ�c������A���R4&pWM1�` �>�H�'��{��S�1L5!� ��1��j$5�R!*��U�'!Y%���)���8�-|O�O(A4���X��b^��W���o�CG����Ϝ]�h;G�u����zH-��� ��(� �ͷG�������B�|�M�E���IN:FQ���P�_��)�p<T�����Ԃ�]�9s?;����0����dUD��f�_�p��;�Z��ʈð��Ip�1�0�Ӊ?��Cf�j�I�⛈U�;�W���?u;�!H���2���|f�n���]�`h_zo���t�Ԩ$�,���V�� �p��P��Xo��^G��TZi��'�̿ķ��!�7�j����Ifw;���y��09�3����6�F��2At�"s]�9sD�5;����T�v7�D7R����3Q*g��S�v"[yu�+SEwm��et�ɠ�2���sc�=ڊ7nA�Y����?Sha6���c�շ����A��u쾉i��_�z.2�J�8��% Q&���ܸ���P����q��_����j��6��l{���&�d���p��8�~^E%߁���v7�\s�I����uT;����@a�|���� ��ru�t&����:0$�|ɠyY������n����F�_��+$��f�!�Y�>�B�^�*�G�����
:�U,��٭m��%,�v�9q���"gڔ�����wlz����,�Le0�/��� ���n�\�����u�;�LR=��*R��ح�L��]��ib+�&�m'����:�NNT�,�٪��|8����͝>i8�T?z���n��(��ߣ�s��L�Y[�0"	x&
�0Wu��S;�����$�5��И꾪
є;�]�niS���[�;h4�n�����Im����x3KEf_�}��s(�x̎��8L�)����$̈́~���ad��I
1�%=%�*��v�XVՃ�/�%U��y���ӡL$d��42��
A7���HL�����G�t�e�h�(�?�ވ���W5L�(��[=#���P�F��Z6���N"n���L���b�Q�Μ�'��4�J�����B�'̦��@jv���0��d�Am*��Ǘ��&K�T)^�"X6�/G,�j����X�.G!R.��c�[.�9��0�
�N�W=��OLWq;�eĄգ?�NS��tU<�?��|�[[�k�����7�T��}n��=̖ǅy��\�����1&5~&����`�t�O�f�V�aq���]�T��y맧��ﮝ�@ɏ�I�C�ߺR1%x'3=u�f�A�MJu��>�^`q��S�XA� �u2e�n��r����~I<�#���+�U}b��½S�uV��#5�Ϸ�� X��m��7��h��EȌ:H�?�\�T�>�@I,Շ���}o��Ie�6�����nH��b�'o��V"��5���<$� ^���0����d�u�Ue^)N�Z09��C8���қ�c����-�FI�'f��������^���L0Db�v���D���g����&����P�W�4�w��n�@$���XW��558�AH���?R�ƨ�IxL�s�+M�"�|��q�cbmⷻ��eJP|w��O�O���|���~9L=1�wg�x�&E���|~G��4pt>��a}{C��D 9yu�f��#wsq�'普�/݃ T��h�sG��d
�q�t�_���1�$d/� �#��_�G��d���~9��ԃ��'������q�j��>�����4���  �:�X�O���fg��ʴ�9�{��=ǣ8H���+�qsN��?_�g�J {�[��%(!��[v�T�T8+ϗ�V�W~�)t����o�U�$��6��NL@֞D ��j��ue�}L�Sj
���n�o�
d�9�L����ߢ�]gW]mqܪ韪k�s��MO4;>)	b�v�?�^�/eH> .�E��H�	9���
������G�]�v�!��~�}�b_�@�lT�wv�_o��|�} 윯7��4�M�NEܴ����@���$A@m�}�D��Y0�SD~/w�5�3u�\�D!*w�����D�2���ݜ��!��H�o%D��C����fm�i��w��2������x�]�C���_��!/�"�h@�*u����9{|�����1�cqnt�NO#�����_F�\�2l�~L� ��O;9ŷG�b�$��|��w01@adI��5�Dq��7���gӿ�!4�s�z�'���r��-@!&<�R�c�á#z�ϓ�� tL�    }�֐�'�4��T���À��Ie�c-$�v�^\p���2=�$�N�j�^0(LGo��N���KE��$��~���������׶)	�um�IK�O��7�#a>�.��	�Ȳ�}�D(����%}On%����I�5f��W�����Z5�7Lm�j��gߓ���.��7���s&6�֚ӛ4Y��^�]�57�9�h�vZn��6'cF�c_k�pK4�)���u��;�=T�ɨ��ѡ�_��)k�S�{�g�g�	�Ev�'U	�׈�sR3w�ѷ1��m��Q�Xߴ�!��Q;�/���YR`E�u�i;���r��)DQ�8z�+�;
n����#�iD��z��t� +��.���]}r~���u�c6�L��*�����^
�N������E�˃%�vs����e)�8���#q>����tB�	�n�y�"u�ru
*�-�Y��0��#Z��$���;����ݗa\2�� n�d
)�.t�������9:$�O\�<Z���OmyÑ���Fi��O�()D�a�~�(ŔL=ֹ�i�L	I֋�g(�%��ߧ�),PU{��ͮ�d������r��T��/��pA�d>(�vͮ,2�Kh���9�w�����J��`]߆0t��S�ީ��ڎ�&�aI8e�Ko��Ǒ�Tf������2�U$�\0L��]�g��]�\hK�X&K18�D����z��sE�`2����/*�� ����QT ۚ$r�ޭ8t*�%i�����bh�~m�Xo	&a6\B���|�R?��Գ·���N��ŗ�:<%�O|�8�����-7瘲='��p�=�HE.��֎ފD���R�zP���[��h� ��>��p����9�v���n��s��Cmza8H���V�KR�,Sj	�ɑ^����߂;Rˉ���ʇ; ���û�c�;�7W���$� >��F�;�����?�W�ğ�����D����[�07�!�H
�x!���,4"�8>�?>[���������}�"�1�J0�������E�0(��	�����;���` �%�q��@S;��:<\'��e�1淙��}H�i�����UR�D�M�����T��+1�9�o&jRX��_Y³��8���'�)������B?���5T]Kz��~���˔��a�>?�ֵ�6�8� N	�.0x=�=D2��/��'��;�V�����}J_
���)z���n�0"J�}��.q�'w���S�;i
�TfIS���Qf�F��E昊�Z�㏾����	��}t=�̎q���\|�$4e9 �wmt��DTYc_.k��U�b��I��ܙk��FmJ����kQ����1��V��P��m)zi�"ew��s=�lަq>��X���跚�����IO�}����~2��%qK�'���s�*�kz��Y�R��%z��A��T���ᓞեW��1=�&��E� =�̓��'5��Gߥ�"8�BN��+�W�/�w�`�FK�����wFJ��Fo��z1
ň��t�HkU�	�v�O'�m�w���kǵ�Ν�n��^� �kN#AoΗ�D��#����\J�)p�oi"�$g�lrpI4S��|�B�_'�nk�4ms��W[�t7ϖ'��ޔ'����~��h�c�4�����*=$?��<h樒��39m�舼�;o���)�x!YI�q��q��pz4���"�P��M��E棏u����2����+����L�]ҕc�9�ʷ�L@��
Yr�}
�P���|�\�T���'ߛQ��Js�$9WH3��Gj�����[��#�C�R�u.7���o��)>K��%Pl���}�����4Y�C��XJ��$�Ƹ��ړ�� ~�����VD8���f���x%����n�]w��/�מkDvop������@��ѹ�V�"�TKk����M��so�n��F����$Y@���ӧ0�n�0L�ܚO�Vw}0��y���b���,߷�v��h�#�E���Uׇr�䱉�æ]�av����~�-l�I�@x�\���xH(�nFBq��>Rڵk��+�+^���'n�w|%|j�x=̮����������%[;����>#���mn��
E՚��С'��AU��CƋ�n�����Sj�v���L�O�OpF�j�,��zɲk�Ē4�;H9E�*�Xd��Q�b�k�٦4Z�+v`H"�������&���=�RqB��!�p�$���-�K?�hl;�3�������b���P���(̤ÀW�0:��\K	�~rD��&�ahN����r�G��������+	05SXI,��N����|�5$��s�UD����_�oM/��E�c�y�6k�£�a�@N��P+��N��6+��s�gcT���KB)����c�k��޺hw|z��H� �4^z�PrC��('Cyp�߄��v�0]�v��W�	�8��ZɘczLI���szLI��7��`��x�B�9��xΏ�}ֱ�|7`�G��[��Fi�j��D�a��/0�u]��Q��8�����} ��u� LΉ4�;4��5��7S�UP�GSY�+�n��P>|���7�1�5�8�Pe����ƨ��ע0ƨR��9#S�������S��p4?}<��÷�BT�`�+?5?���s��{z�������Rm ��Su�y!�1�}�,�ܵs�\��O9d�O��ﯙ�ڕ���R���C�s&���W���>�&���K��q4�u�X?u\r`X_{%9�Â�;:�w�׼��W\F&��'hF�o^�%ήT
�h,8��"�&�0e�O[(���9�F1V�3���*ڍ�P͓o�&����6���A4FJ)��w1����-�^�����=9��p���[�/J��y��; cH�_h	�ece���Dp�R�'���ue�Ho
SF�Сc�D�TQ;��A#x�'AH� �L5m����}x2� =(�,��(�Pa�VI9�9�N�u?��p�31���0i9,�/V.�u��ϵPjW3	Cd���`��sY�A���i��_S�z�3��GK5>s�+<�,�����6Y�_=�D.{w$׃i�}�z4����u�cڱd�v�D�׆0����������|�E�f��������[g�9�!,h?�K����xh7|���ꤞ7�Ѡ�N��T*�O���D���������n�ٱ0��EǾ��|����Lf1���dA�v�u�i���N0d��H"�&���ϩ��h���l����g�+,>�q�ֽ:��I���mUaA�'uq�J��Tt��}p��]"��`�o���������� �*����H,4R�c�BlS�CO�� �p�t|�k`B�J.�A`�C��)�n���p^��Q�����C�lP��`�j�zс�Y��x��o�9�*կh�0ݜ[^�v�50�Qӗ�~��SQ�g����h�^y��'�۟n���AXպ8�aAԭO;~�T["�����j��.}�'
'BwC�������/a�5�^��u]\��S�rN[�އ\��	���[/��~u�<�t����W>SSB*>N�$9�V~���k�驔5��������S2�-�Bp7�x'n�(�ꮯ5��������:;a�̦^�����
�������^������&Wa���f�����k�I}�9 ��{*mEqj�y����aN@���	:�� *��"����c��{$��D�,mU��hr!!�9	�c�.���Oe�(��7r��B��eZ҂���+w�r}W��a��O��JI�0������ί�ҝ��!S�}E�i3�@�ְ�/�^��b�+����<x*F"L?N ��%���U���K/���n�P����a�z >��h,|?��p�-�k�6#������Q�q[A�*{��+@���3�G�B�7`�y�����X\!Џ�P�>��^�c����N ���2�+`��0�-��ir�Y��#�r;�Cx�0ė�뭜(���Դ۰>�/ߧbj��\%ƅ��:��GT:��.�"�Xe�j�	<����p&B����h����`�� �w&r:I��    �<'uO�X0i���u�@��	�tC��.W%�X����)	����)��]�B*�dߊ&
�[ul���(0�ڈ+&`Tſ��8F�q�9%����v���_�pߥգ(���ά�F��9|�"E������k�z���,f��u��z8f�T<��!��Ǵ�$����A����_(�s@166�7��
�ӡ-M��� ��}6���v�b��'S�I�V#��y��R�|_�vZ_�lB�D�Je�$zv�y�h��#u}C)��H��WPy�a�����,�����{���J3�0)���]��@�bJV�u���g7�[�
��SQ8��x}�_cd�_t�#����f�ƙ�"M�s��5�vI�0@i [�
!
@��h?|_sWL�P<U͌�5i���X��8;ɅF�W5��	���2&������]:�*qm��PjAຖ���T��!����� ��Th�̎�Ԩ��.��ԇ"���K�2��i0�J	A��4<<��a�U�q(P�B:
���yJv@�	đV�;��c������4R�"���0�H(ޥ��V�YѸ�ismǸ��S�ˁU��֙|����N���ur�cb���p�8��X/��1Ym/D�A�(�\���L��-��H(}L+jbT[�c"JC�7i/<�������W��
����rɮ�X�T�ÄO�*��k�ѵ5Y�G!�*?�l�XEDҁw��]��3̏u�|`t��L����zh�ǁT*�:�n:��������7揮tՆ��.�=M�<�D��k*�B�����F �Y��ϧ��<rc����\�t�������5�޹(��ZBT���0L������G񣝖G��:���KIuT������#B������n7'�)��cgui��|���9PL�l!e����L��2���i�9&�G�{H��c2zN)�}���t�^1�M��}��yTM����0:/1���yVM��c� ǁQF|���;=����1�>M;q�N�c=�N��
:��#�ehB}CX�o�����sz@�����J�۾g�c���|�{E�_(D����Z�7�G7������t�&�L���:D|���R鹽u�~�(���g�>��qu�0Uj;�;4��Ͽ�z�(s��>Tu�HSOX�'l��::/�Z�أ�:��ڲ���-����6	�y���9=__�u�BO��58,=�?z_����'=�rX���3N�R�:x:@��C��q����ȝ�q�o#6>�o~÷�4%�h��ǌvj��qX�҅tH-��r�4�߉b
�n�ѝ�T&,C�1S���v��Hc�uLY���=d�[Wp3cBH�a�'��1%t��G<�B��a��*+�1+4�����w�
q�2f�ƞ��=|�C���ע�>tM���t\]��ҏ4	�VU�����Ͻ��:ϸn�>�6�&�Ej7~��Ig������GZeG霷x������k���[�x��R�LK�1�-�h����Yvx������.� \+���.�O�œ�	fX[�מ���~u�s�dӅ�nΡ�,�>���JӚ>���{��Yǂ�A�w_�}�NƬ�ua��������F.�_AR���v��K(��Fv�VF���?�����T+�����O(kA|��9�D�@,m��4�M�kht�ӕ�V�5_V��gy�8��5����G�nԪX����
�]�2:��V^�Ij� ���AM�3A*빩D����>M��s�I�D��$�u�ݓ�'IVQ~�k*� �3f��9�:�ȚC�.��|l��.��"^=�eu�HyJ�� �@��(}��A�B3P.��B�4�I�<|��t�u^-G^
�r�%�Z�(4�)zU�9Mq�I���P%��I<:���AL�7�����Q�v21}idh�Еe����XOYL�,�9�i�����'�q����k��QF4�4��1��Q���%^��÷�tT���[���WY�>+�O���)�����%5!�ئs��V�c(���Q��z�un$S\��gSw�1jKT��4ܜ�X�<�h�;gbm�Vzm��7�J<�uvn��>�޷$�T}F;<]�(����z	C�4����hY�q��u��FV��sU��%z�o�b�:-��K����:8W�6�n�w3�&$��$��r$��dP_qД�"�k��d
r�uB�pT�1o�A�u1	�j{x'$'�+��⳶����T~�s�P��H����%IJ�]�1;�$�~���@�æ�N�NgM���'	/�1�$��ȅ7����c�ۖ�qm�o�R�]z�e��]<������!n��;��<����W�H�X����f�]��?v[�v��NF$����4�BhUL3���n���![��������+	j}�j���l~����5�V[�U���.��V
'l��驛%"�]�O7]�˙�H4>���[��� H�8M};���+t �C���C�Ʉ}��Bx�ۜ�L((�	���*Q/JDD��m��C���z�=�7S�$C

���c�P2��^��i��%@�!	���C�A��P��:3��-���>����u�c��=���O��AR
����4��ϓߑ��m#��D�\g�I��fN�@W�v�J�P��#�mQ���
��="�Dk�?ۦ^�U�JdL>��L���I�-�wV�6���Kj�ˣ�oS�3�3��=ҟ|t"�DӚ�'���Qz�]4�P.q�9�y�!$J�u����уH53J-��CH$���nha���x:a����<R�����|T�_L��Db��u��.���q������H�Ht����E�=��|i�Z1`Hx~����@�k�P�8KG��B���n�P�Ă�교$�K�O�٤I�d���G?m�m�`Oj��ѸJɯo�e1Z|)��?�6�D.���d*	[R�6�JB�XMb�D�1(�3�j�?K%)��t,(w��#��nU3�.T�H��[�9K�1���uoԏB��X�h$�|��z�\�+�M�v�EVK�͊����2�|($����-���t���6���=�(H�S�0OЄ�T�>�j����+�H�s��E�a��o��|�v�Mc�ؓ��vۭ��УÅ��'�3�m��"��v�!+�u�Z��[�6j���c�zJ\Xk<HT3Q[D���TQ$�:�ycê0`�]<;�)ILt��T?G�=(�&�+���x�䱫?z~N ��哟��(�/(<O!J�4�飨Ӌ�S�{$�����gl`�]BC#e"J~�6x��[i�!a
�w�J)��#���ܱ�.ܛ#� �.��j����M�2�Nj1OBt���C�p���Ѽ�f$�-��P^�Qc`D�s�Ջ�a��҅��zE�=R��۫{�E�ϫQ���>�օA�;^q�@�{���7��~�(��@��Cx�a���}^Gv�_�&Pń�y�_n2)�8��e��p�sйVn�����`�rT1/KP3W/�N���oo�H8r:��3N&���^Yl���)�KM_5K%~�KK+�����܆�w�8�B#�A�]36�X;\=6Rj�k��u�������R�E��6sr$����1��!�tߺO���O�nWcW� l�N�����|%A��<Y�sQ�à�m*A��6 &[�ɶ�E>;��֑c��nb`2΄c�K���Y=����}��[m�)�yޣ7~P���#��)|��1��l۔�]k\��Ԟ[x�ݳ���0PC`�^ �|��B`���HJ�^���^���Pd�CP^s�1 9�� ct�K���݌��R���5 �@�+��4�pHe���0o&���x����i��Cor��z�O�9�����;�#�Kw{9�,������BkF�_�2Z_Ɲ\� &�f�~�(��	��dh�dkڗ#م�qX��H�]!]m�d���=��>��׎*=�����jB&�](�2>Α��P��a��Yl;��QL�.�i}��$��J��Z�����z.Ϳ�(G҈���/�ԏ���j�<�B��0q�h-��~�i��B�׏��Ǆ���    �_fIAӞW�d�zT�ͦ���{]8.&tl�!ױ9�r:�\���!��I�6߹@z���_lb���=$^ ��\�8�Bg��Y��v�Y;�R��!\���X0��8/g�A.�?��3��,lc�rZ�mm���.�p����?��P�E=LScj����l�( T_�IŦ'\[�\�:���.�i�i~����.��<&3i��b e�D�D� �Em�o(�&�1��~���y�[�Y�?Xg���!�z�U�C�6!X��Q4;@$�]���^f�m�Ɉfu�^ծ� �u{n�j[Ԍ�5N���iP�����k��Rˊ �����"�s�	A�Q�Z��׎�϶��̏������b7��2��"�u�_���cT;d��0�FG�,�	5;Z����iۺy. �u�|�3a�z��1$#�-W��$�T?9���ǻR�]�� RF5�	��n�L9��U��h33Q�{�O��1�]�{�kt���kar�Y�!�e)v�~�mQ�{t��C(��G��H���
� ���Xf�m_E�;ߠ�H�T�kW���nȪ��J�^q�Ջ)� �
�U�qH�ʞ���s^Z99��Q��Fo{-B!��{���ٽ S��l�l�TV0��R[�%�-���Q��QEJ�Q��Z��m��^0�{?͟���DB�>/���E����K�>�������e���hf�)�h�3y>�nl��_��Nv0�DD${��n��B���׉mIE��:�ɢ���^����(D�/�ObH�V�-6���q(ZSc5�E�M ��K����Nt ؆�Fa�(�u�#/�!}�Ba�~*l��3�ۆ��r_mc`S݆�5��H����`6΅t�(#��+MVV�8��BN�o�`�6@�M��gQ�$���W�EV򏘼�x˳HKZWX��a��+��D���Vϫ�!����,g�-"W�%��E���C%�I�7��$	 ��I�~�y�B����c�D9YjI �uH�e�8$O�qDb��G̖1�YTfuF3	��?�D�����m4�WakD�s�L%���~&�$�u�Z{x����I��!�;Aq]�t1e;�R1[`<�S��W�{�F���F���(��	R6L�v��B�5n?��2[$Sj����X�3�ǐ��)�/��a'�^�n��R_M.���DB�$m1�Ⱦ2��1�e~�Qvy=L�ì��܂�2[����ޘ%�\�Ll���ta��ڵFRĀ���\k��u1� ���.���x�1�V"�	s��j�F�p��`��y^�52a1���J��
��C��(ڏXP�+�x&��m� $�� 8h�c
�}Fş��H�+w5�Bڭ�+kz��]���BR�w��8J����zI�^܇�#���� �Z�WEF��%�W ���^�!��fT��5V� c	Ԕz�.u�2W���B�Ƙ�X"������������)��Ŵ8�RQj���6��`�S��5~�_�����F�ڤP ��wۭ�*���������ȓZ��a��U�u��@��a{^ï�ޕ~�H��c���i����6�7{Ӹ&9�`0��d�F�i��7���l�r�e�B�F��.s�*�>26$q,�B%=��"�lo�(�O���6�I�p�]������r,��#�57p�~n�	�Q�Ay�����=A9��Q<D��у��;���(�w�t��
�	�q�^��5PH��Ğ�q������[��R����o)g||�'��q�!=
����!�	�\%GJ���ϙ/����UiA���@�F"���f��/�2�ӏ�e��"�MG/]��d������v*��A��4/��ףp���� ��{o Є�N���q(�+*�&z1�{��9Q`8C�0�
y�ͺ^�q���1v�~���cUl�ILz��7��q�4T%U��^:̫_�#��NFA�{�Z?��K=��=���;���L<���RP���P5 ��yX��y�<�l��;����?F�$���#�^m�)t+�4P��(g%
X��w�]�[��4Т��O��T��;��Iy��6�p����S����!'��ʵ��:��ͭ�}l8E��W���P�3�KV����fL�QQ��i�=o�-�G�>���wm��]^�p0V���Ȃ��Tt�n-���Cs��ce��X+.�h�ۣ�؂v5�����ڿ����sÅj �x�/ky�Mf�����������A��I��SO��L�(�O��k	�E\z��E=��F[K���=�M���c�7�Ac����$�M_���
���E�6�2F�;�����ζ��m�lHu@Z��-�(�г8뙋)�S��~�G�i`�:5�ouߓZ�CÐ?2���7��1�C�ii�QDQ{=P�y�T�;nA1�h.`�?1{�X�o�u�1W�=��Q��>�d^?]�G��C�<�#"e��1r� Y�Iv�L�m�#6��矾�mÉ|]*�:���Ĕ7�Ej�j����t}��������o�� �G�l���JJ�p��M�.�{�v}�o1���&AE��H�A�	���9��?Q!fi�(9H2��#Y���q��p�q&�q9X��4���� t�=�k*���[d%���"�q6#H��^Ǣ���c�
�0h��	�ѵ��>m�����s���rn]�� ;��"ȇ}��WP��Yc��$��z,$�xm��6̖�O40�ef�����,(%���:h��.]�Iՙ� I�
����h�t�'շ�O b�{o,�+���yAl�Y
-BZy�7'�҉AV�gB�������W����ц@J^_B/(m�z̃��A�M?�����r,��
��Ú�/pp�NK��V*�H}k�1"�iO�dDi�죇@���t!�R?�,�?I�U�ZA"*Xп�m��c��Ɵ�����@��J"�8�LlC�Nf7�@��_������.d��c��t^��J�I�;ж�Ҷ~�4���!cE���ǵ�L
3�$��p��b/#7t�['IM�ŕ���MGSa�я��o5�����6Q�;?� �MW�� U�W�Y�
�00#����j Jp�V��w1�S���
J�0$P��:N�(��I՟�z(ϡ�L� �5A$_m���;���Q� CE]�O����E9%d��Y��[SJ@hy�C���v��ֶ��!� 
�vK�]��)�Q�{��B0�?m$U�IkR�^�veʇqMjɐ=|r��Z:�xP�H��k��enmSl�
��h+3j$�"�J�ާ�>�G�\���a~���6,Ut�{@;#U�$�B/N�h���x�q�
,I���n���:K-�Eζ:�.��k��lc�&K��R�os�b]�c����l���A�*�)7j�T�����5��b�����쌕�@�����s��+8�q@;a�ݩm5ný?Pr��	i�S����;�-��lD����D���lĺ]�$�a�u�S�Un�&����_;�$>�#�==P���Ko�#�/���N�D�FJv�	L���˫����dTfD6B~�� ���`�m3I�j�cH"�o�C`b� �jC �$��lB�;�{,�ws�וv8{ic;U��	����l4{����m˗e�k�XB2��	(�Y�Frj�lO���l�ٞ3t,�������1Y����!C��C	ɱk�ާ��	�g������ن@A����^�)q��vkE�8��('x^�T2��'�a���B�T�&�	�M�Q䉀�����!����-YVZ0Ш&�\�`X�pm�AX����	XEh\����'9���N#���D%Z�B�i�O5�~���m��:l7�>.�ߡ#�b�����n
vlۯcwv��=��ն3Ta=�v[�,㫷��b{Vڪ���B��A���*a�ĔNV�v��B�-���Xū]�2݁8X���`Y�}�cA��t�$�W���gTTov}Du<�5��Z�P��)Hר�Pa�ˌ�u���gi�j@k����Z�6�*>|�\Q�ay���Y�)m �O�����Dw    ���3���G�5��G��z9�/��[��&=ߍ�"��<b�8�x~r��hG�T��jS�������i2us�{�[�P�r7^� C 6�t�]�B� ��Q=����m�AsL1r�2���oR��tH�������~�D�aO���P��(i��=	Y��E�mf���@��]����(�ȴ��	�ځPkg�r"�5Pq :(}i�J�ګ��U�]��)�F�m��${Z������]8�ɷ��O������c%��XIXr-��p{o�BgYm���Fm����P���s+�[s�d7�A�E����Y|���0�-�ϙ�"��M��&���r=�{�%�DBo�}+3�@�������H�hB#�*R�����1-�R2�񱮆�6�F�:�1.Ks�����ٷ6��LXA��M,�3��ˊ�B=���Rڄ%ߙ����D$�{��u6RK~>ՂH�$r��=�(洭�c����0��	);�����%���H��X(�`�W��O?$��˛��:��2^�H�}�&����eD��e�� %�hW��(�'a����F���k��{
kW �y?�z~�%�n y�<'���=�&�!��8�6�+I%F"��&�-Ҙ�ߒ�%��C!ɶ���������W:�=�w��"��?�Dc�6���n���m��"ʞ���O�n�
Ҏ��Or�I"�����N�D�+��4��U�Y9���g�/�Y9L�r�L�=D���TQ�D�J�]�+��[b���7�D4w	4$�nw�\�8���d�0e��y|�1��>�u[Il���Ð��8-C����OU?	�L4���GfrV���D=On��S�I�
tӵ��v��R}�$�A4|���^�$�U����ޯ,?��D��]���h��j'�!ㅹ��[�*R��rq�&�K��Az�k��S���Ikݦ�8TtYX�1��_�;7ssX�P��v�#�uw$rJX*���s�[Zp��i@=`j�A�]�� t���}����f���9!�D=��[}�V���ҽ�p��.3H5,WDR��-�7,_���\������q:t�>�ﯽ	�*fA�a��{��p��̋��2Iu����B������r�I������īף�V$� ��ky��J�c�<`�T"��X&�kP�R�V�7�����'����S���_� �E�3�F9�?��>MZ*����U���
!�'k54ʽ�p��1@x� t>@r���{���T��5l�3�Ur��n�ES.@����r�T���ə��xS�>)�������
TAi�T�=�5Pc2���$�M#7�o�g�ɏ�گq�Q�e�p��T����:M����	
%|v�n��@����Z�9�w�t��?�q9j���P��
(q�k�+�P��݉����DZ��g���	r-�s��ݛ�(�u#�rߠ��Ӷ���;`�bi�Ħ�ν���w.���"��t׭�QB�-C�������ѹ7	+[��G�ϕ�(�i7Q��E�$S`�ͧ^�#CD��cq��Lu[=����-�:��X�^GI�E���x�2y�{>���yX��̨���&w��̔ q�(��=���#�*хv��q?)=P&�a7��S��$RB���J��f�-�d�@�	_4:�CN嶹g?��|Q�׀�J?-��0t4%JS�Q����j �����ˠ�D�QY7�1��N�S���Ƃ�Ew6#�2�.��}��ʘN�ٰ��.�4��]��V�����T�%y��8�:5�i����Q�N:48B�u+-h��b��#\��?Lh��sRP1E#��HR�w��1����s�GA�����(�_*ûI���~(͠�^BJ��4��H��P����K��jX�D"�tbp��.��E5(���(�V����2;x!zw�^�I�[Rdv�h��A4J�;�$F�Q�ٝ��>#��g��a�ǻ���aZfy�0bR�m��ɵ�#�D��郹a�~�bԫ"Y?�kwf�����Ѥe2�Jl�c�"}@��ܷ��-�H*M��� ���Z��B��[߻e����]��-���z�U��L�z���hFR�N�j�*=���+HA���zPQƄ��}pT��g�'2��Q�rl��I�B��&y���t�n�w}NGa&5)U/�����WF1��l��j�3���֟��gʿ����w	���ۼ��*��u!���آl��r���P�F�B۞����\g��p��P�Z�����%��L#}��K�هf�(Ү�I����n �>3��+7�Z�6�w
Q���p]�7���.�(�����r��I��Z�)#��D��)?�8�tl7��,���
�L��פB�ʘ�����'هѽ�0���}̢�����Lᨱ�^-�>��l%=S�Ɏz[/�'����;���p�"�^�,��m�Ť;c��9HZ�RΤW�U�B�;4PtW�P��GIi��{��J_��1���d�(A�:z��;�&�E��>�w�Tt둤����~GTn�dOF���,����\�m{v D|����2�HF��ݱ>{x��/}(��I�n�Q.��BM
p� �T*�S�?��"��Ё�]�a��sP0��P�v )����߃}�.��r�(�AJS�����R���Mύ=�t�d�8;�94�.0�<}�W6� �*\��G�vt��]Γ�=u�kt�q������WP9�iJz�o)H��-It*`�~B����P�3i����y��k�<h,�s9���V���6$y��>�*J5Q��R$��y��,4���U�Z�ݦY�N3����<�-�E���좎�b��b�4$k��`�6�Hf�K�J�xfT`T�m�G��z R���Vc�I���<C�(�4�6(���KN��Fri��Tv�X�Wݾ�Ŷ������N �>�r.`��^����쯹kǅ��I����Pʡ��@;���3ʹ��J�u�k]BK�UT�T�RARV��Y�Q��T{4<g�1~�����Y�,f�R���I:�`Y���TH���,����$��K��{Li�.�%-b!��7�G2�W��ݛ�w	���'���2�L����2G��R��/�ٮ�%G��ڽf��R��Gba��Ym�{p��UE�HVA0�;]��(��$o=˒?{�<:��)�z-��c6�c7�?��n2�$;C'za:�B*���Ԏ j�S��~lU�1��3E�V%���\ER���D�A�2o�#�D��*�:����2�+E��
ݿ������P��TCk�@e�o�<�AT�s�Ȋ�����H)-�Á�[��(�v�_O�؅��iWK��tL�+J(M���c����j�?���[�C��iU�*�<�&�E��kn�޶0�D����s�Nw56 ��~m��_��"O��h�ޥ��j �Uɲ���u�u�|�F���������G�W��(g��~�O�|��ݡ�_�#�u�d��()��>���������r��1�>�ge�Fyt#�5=����@�s�3�ݑv��F����h�L��'4���H��(A���qdq�(8�ۅ��:�(;��Iu֕ފ�si~�9U��y��\�켟�� �m�i,*�(��PX�R)O�,N%�V��%\3��D��΅\�H�h ��2��y�A��Z���"�������t�K�Ȑ�zn�F	�E�+�ɒ��Й�F	�ʢ�,a�P(�d�������>b�Χ�B�zK��hB��M��,�n�W���,��,��Ta�>����_�r<i&:.,C�����uUYw/��+4�����_{���i���R�%	�=��=f���@:{O)Q�2Ky�v {����7A(���J�I���g��HhMs��&�!�V�,�TӡK-�2�Lf	���1Y�M.�,�\�Ŭ29C��d�	S���3�TE>ty�YF�/'���J����u��47��5�0��K���h!��tћ9,�h&���K���c`��2�p"�C�+'��֣��;4��U-�<?A��iYs�^ 9���]4,C2K���=�+���    [s����{	9F�T
��0b�A� 9��8�E/k
�
f����&���6�}{o�!C���G55*�'
�,�#�HY�i�Eh�wE�J;��̿n��u�YNs�c�Y'Y�ZZ.�*����ūdg2��?���\���a|g~�
f$�U�Yx6'Ȳ*�I����wA������
nT(�Jjl*�� �ާ��PS~Ĵ��_K�� ��s��&�G�=$���@�p���!5{�v��u�ݛ�
w���?���xS'���!p���xr�5�+���`���T
�=���OS���r��Qܩ�����"�kL5�6b~�3��E'V��`��a�a
S���d����rT�o.�h*���笺��HB����	�7BSتKO�_�p��R`s;=����i�8ѣ�8���IgPب�b�+��C�hX���\��D���ϥC۬�-�(pP1g��kg��&���p�h¦�L���ǜ�f�LELqW�����ͿG��qo]|;��I��I��I�rPX賵�YRS�ʣ��Q1��_��c<�!ad55�2t�	���<��|>7(���~�˂�5j�(.h�}�u߼�!�V�*Z
��a�aKuk�T���؜�w�\�T��y����ݤ:+�$m{l̅��ry��}�@��k�:J���3��BN���ɏh�W: J}�����~)Ezp�=)��8�J��E<��|+/ҜN�P����"��یBT�y9mWǚ��3ݜ�R���v=Ivx�g�:�q���s���C��$\���L��d���2��$v4bw���A�7�ѝ%�C�"��[YR�ߖk'#����w�{ة{w���κ��ŏ^�yI/c|������~����h"ʁ�/.oA= �m��&��Xy��a�� �{�7�� ��?�@��:�i��`��A�V���P�yx�s{�W��1���ʘ��fA�U��ذia��;R��R�/:��'\M��ʏ���tgRM��,${� �� �r�n-��'_��]�"�<��t�RsR���k�	אifHaB�@0��4��mv�-sM.�ӯ/�Z8�j�`��H���Ͼc�#���s�G��
�%&,{f� lڅ���&��j�nn��]�ο&
?�k{�,sɞ���T�n4���MoJ[��P�����7^l�.x�c�2=���ܨo\R!�����sb���Ew\���t��泥)0�y�� }4;�%R��F:oKw��������*�������@n�_4�Ru�"��mT��8K�M�;����U���8�ni=��� �e��l��0'g����-�x�kS#��׺Ϟ����m�x�CH�;�%|�Ru>	I�=�G�v;�P����~0��G����7gZ�<<��{ ��/��/+�peK� ���w�3����[j��K*0�	YmP&w���,�C-Np���@7�n5Ӑa�Q�	W�)��_���Ti)0ڹ'��%�Jr)R~_-ݧ3�����mS�����zvW:����s�>7
B��1�YN��_i�Tg��
�-���'�7(��a`�<A����'?|�a4ɽOt.�g��Y{��ل��Sߢ캨B���&l�X+|vF����_cd����L���J$,g�0�pb���ֹ���c6��ln���&l��~tC�t�dto�j�Qf3L�ڔ�t��J�#w��xQu�J!����R�t4ֵn/G"��E�BI�j�2�f:�B$�έ�
�h�G�R�tFR�Wy��i�<]ȸ'��U9_�l+��Q}3V(���LK�cZ�C�(�Q^"�o~	��YPP�7#;Q#�}�]�����EU��#-���)�]L��LU:j���D/؂݄5=��ދʁ`�N�/�j��do�ot�L}�<�e(Q���2�o2a쯯�{>;���~�=S� �mB�pXk�H��>5G(=SѨa�v�lP;��UH59
��ݍ��Zw�N�0J��`��	C��֍���$!!�{�N���2�S���~ntP��t۞=6�q�n6��G���]�['��>���)g�cf��� �+�w�m�o�Sa����u��4r�����9��Ms��W�\4�A�=�.z*�o�P9�ePr��g��-��9>�I���|��짽�,\>�xVbLu?�?�\���y��9����Dy$�f]���m���`����	oc�!/�U�,����r��(3]^p�AO���ɑ��J���B�݆�/��D��6A,�m�sR����qhA��H{Hbt$�&��Qd�|�������c~.��p���k�O����?8v'4�bP�aU�s��B��_c�b����<T��js����$�V����U'�c�B����D��~T�R�6��Rn��=M~�g�޶��4����z�h�/ax�%�>v�L�"�=�p�����6)3>)���ˑ�UaZs�Ii��3��"F��>�|��:��S�⇔a\(�����5��5�&����:�@vP�׼�C��KZ=����X�0bި�����!ڐ�~/|�C7`��N�x��+�yg\�Z ��qPL�����2��ܩ"�-���S����XB���`�"s8��c��e�^m�x(�']�ʞ�<m#W-P��罟\K��T�#J)o��j�lL��<t�Г@p2Xw�� ��t-4Bé`Q�
��"�kz#�`M﫧�'��O+Ճp�x��c���7�S6�����a��l�-ㄺ��ɡ��dCk����q���8:$^�<($_^���'S#a�fq?�	�u���Á=��Yg��&IQ�pry��Ɓ�=��h�J���M���$��H�0j>��1u7~d��e�v���e� 2`�u�҈� ��.��z�d�	�6o^�&�[HyN���WCp�d�PNe���*)@o��C
����;���Z+HM7 �'�ߤ��R� ]	/K�^3��h ��[�c~���0�{��;���wm�V�89O��l�/�㐢�!ΣǊ��v檆�b�b����z��~p��a�L�쐴9Y�BU�
-BQ�!�겎�b-Z���)���nO��3�v�y��)�TH���p+T��܍q`��?���~�2�y��d\�����ޖ��p�jk��pu�F��$�F����H�9�ʪH��e�����l�ފ~7�j����]�S�������#�@8P�!G�G�bu_J{=ԏޑС��ɕ ��c;`5P�to<�Y�F�Cm��M~�ۈԌ�b=Np����wN�cj�=ܸ��������?�+ !*jIo `���~��m%�Є�7�3�H�|�'W7@����� ��m��dPr����,t�ڥ3�^�&.���!����pP
o[z�z_��p`���K��;���J,�6z�A��_.�gAf����<x1�Ĥ�2��auP�M�`g����~6�_�r�?�#��6[��r��7!p��Z+�����:r�����P����k0�=�AKA�������m O�*��\nh��~���$���{��Dt����u��=A��/e2l�P�4��j[w��ڛ�$��������n�6w{n&�L0�ni/j���Im��M�Й*��t�Wh�mB ����z����ENo-�A7�=�2P��,�ǰS��R�H/��t��H�cB@��J�m��芊$�5=��a ��)���}��+�Ơ(���$15ʞrd�u�ڳ�W����!!����&�d�τd��f[X�k?K0��lc?�,����mÄ!�>�'��%j<_1x��{aԿ'�S�ŷ�'vր�6cŸ����2��L"�;˧��|��G
�}HS#�u��vDv�@�&wq�60~�o����B��*�Ru��&tp�eP��㼻������.���;�������v�_c�a�)���n`��R	 �"�9��"W���Pr4�W�ݪ�=z�!��})Nq�ϻ�*�0(���m�=���e�EP��a4;�8-j�?��    ���T@9v�/���޶���S ����P��5;&�暍���xL�՞�^�޼�V�d����9W�W�����X`�!�l�@7s�vhێ���9S��͖�����2O��KJ-���`�1�L�e��*|r+5���?tCo٥9V�P�L�ń�}�7	��/�5�:��k�-�1�����d	g�E����p�pov5����������s��0�������.�\�	�G�F��aۦY�[F�^��v	$D��ެ�����)�p�_c���	X���
5Cǝ��e���K����{�H��z���X5�D��l��� S�ٴ?Ǧ��`�	�$�Zm��R|ݺl�Ţ�P���3V�P|?c��3V�P�X���og�!V�8]$�I����_S"H�]ɚ3��9���%H���$��]k�{;jϢ�(��?l��T������g|���Em�_�z����ޚ~�\�{�_S= ���6�G��I証�p�$z���R��p�z�Vb]��)�J�s"(���O��H�e�=�hB{���}�����Ɏ1� P�}�����}����f��k��`�ՍĂ�C�fH�D��$��1B[�n���\���Ӄ4��݋�|hAdxF��e*R<cw%	U�ϑׁV�vW�d��+��1��b��#�JR�� ���b����ID�� ���R6A��%�Q$A��!x+�m�@C��G�i	�C�+��q��0JN�!&O�7��� 
Xm;���e�T�P1��t5n4�v����k|�l�;�!u.H�:�-���]��?�U!��Ԋ2��/���!�M�3�f�5��%5J�s�/��m�5F�A���5�y����z����66~F��vn�ۗi���p�V�i~���u j�Lx(ӯ�c�K������D�����?�C���k|�D�w��ι� .S�a����.PDXB�0с$8j�j���	�=a��h0��!}���m0�����_�^�_��hʯ�u�;F=�;�)�!��7bjC�G��\����!��:��͈Cv=�6���؈o�h��>(�>��x*�n��y����G�ΓqH����G=�8G�j�NxF�W=Z�DH��u�2�1u
�#F�U~��F?��������[�9��ѠKGgkb�u��k�I�F��R�C������?���q]rJ�HB~+t��pE~��V�`P}̏d�_�u2oJ����B��=5�2`�8����2����ݑ{���q8�1#=^��y��~�ɳX���cQ��^�_��2վ���B�e۪U���˶��ˣb��tVGx-�2����p}Ϋ��J	��a2��J��@i�!��G�م��F��K&g�]����<��.\C��c|(S�z��߫U6�Y��{;��?��k�b�z�pH�a���,jM�/��6:R!wq����8��A臀e1�RB`C����ޡ]M%F}B��Ł#�`f�
�����Y�U��Ԋ��`�e��cP|b�n��@3��q	����bl%Q���Z� {A&�htyP��4��8\�ԓ�_����MS��Ȼ4�^{@��2l���]`<˯��#9ε�&e�->��[��*P��]+/Rc��gİQ��0���:�;2����^� '�Ն�Й�2�a�\*�����N�-��Y��+8a߉+T�����C�z�U(�-��w�N��@�mhQxi<Y���fT��*Aet��W�ڭ��|^���(@]$���%�}`������3�C�S�=���#
j,0�]��m(���~�&�C�(u@�?�e�0��۱Z	����`�?|z+�Vێ�vZ�<d0�!��v� Q���郒�~T��E=���PJq��Eiu�GW�W�2B�,�5�P���u����4�8z�y�~q��m"]���0�Eǩ�����L��bw�'��q�,�������B.��Qc���t��x>AƷ�S������Sq�F��ŪԤ�D���z����V��ʧ���p��dT�E;��y�)�Cx�7�� ���i���-�_�
Qc��0��K��{���+��5��i_�H�`�d9|�V`�O��uý[V��Ԥ[��%_���^�Z�[�P��@�b�ύ��K�^�G�0Ft�c�m0Fq��c�ɂq��t��7�$�[�J�JP�C ��l���t����@��Vi��6�h��f�O��u��T!���cz�y����g���������D�2����(!������:�,�p%-혒sr�n��殽i�L������xi'0�Y<�����m����GeB�"���00_�ǎ�w��|@=N�8S�P�K�`d�a���f���������@��'���mn��Ӽ\m���R��.�m�1�����m>����l�G�ټ48��`N���7#H�,��Ga��6Z�	�����l��ƹ��9:Om�`��,�Dq�&�<����!���i���Wv(~�2oZ1��]܋T����_�D{p�06hq������gU�;$#e)\�O�-:��S$�i�R�cٯ�,R3�}���,��$�|�m��֣r�� g�H�-�hw�!ǅ��z0ُI&o-ԳC�1ixtmG��zx�nCkz�&�5ܝ@D�3���m#�;��a*�����f� �$��2Zg<�2>]�5�&���|�bRIN��q~�$�-���D�ZLK�^ �h�S`O6Na҃pr���I�f:t��k�Ҝ����W���'����k^Ԃ���6�Jr�e`]����N�d<�8�����_�W
%�>�ᶏn��ʶ9Д�L�8��h�´�� ���,[���چd\g��%��|h�`�Ws�[#@�������lɍ-�Ls)�g�ŸZ�Z�ɺ*�����[�͠H\�b4Ͷ{u�u*b$pݍ�:c\�ޛ�>�H`� ��N��jC�v����@}ClF^��hߩDj/�-�lg��<��T� Y�"�lC� I����-{��}����p;A�'
ɶ�n�ȴ},[���u>]{㱏4����IEM6��]{f��i!���ĥW�A������6����Q3�]� <Y�n��=�q�	�� �v�籍I�m�m&ص�v���e
1@���آ�6��>��%�"A������~+�g�Pk^����}���̗]�Z��\	��ڣ��kC������b5�������!]�E�Jw��7�;)9�q3�1�q�3�9������,?���-1hc��,t��4�u�&c�g������6J*(w���8�LPFPx1E�9�L�q��Qo���9�>�ߟ�)Rr��~j��vl!�)�OV�Ƴo�m�^z)����H�v%���MNTnrJB:�Î�hy�!Id.۳�&�H]��=��:EΞ*�&"F6ۼ�T:���`�3���;��c"j�����p�Y'��p�� R�'�iX���u�%��ih��(�`[�J��ET���8��ߣV�"Z�Pg��	��")�k��J�=Y�����h5��c�)�u\�~E�J٥���ot۪0���.�r3�,�lߒ��0�����!��-�RU��H��������,J#�D��b�S)hq�e����4�Za��goÐJ�'VL��-�D�tRƚz�s1��KL[���by�n�9��O^r)�h�� ����BJM�~��{��m�i����Ɠ�
cJO������6�� ��ݠy�90B	���|%"�d/�.j�n���[���gk���gO��ύD��6��T��pz(,5����g��r� 4�yg�웰̡��k!�4a�w�#�A�i�ڧ=�?-In�/���`��R��0t�-��_l���#d5��1��k��)tں��q��s���g��D��x7�̋����(�	�$^:�A��l����w�X�]����a��V���gE�;H�\��H�@�ٗ���]����2?�h��WFU���m��J����Fۮ� �E�h��Kկ��,    C�(d8K2�:�k;�$0�֑�O�5s"�ɼ9���>�޵ud������`#��n�&R�����ŽpY9]? 0��t���z�"7į�o��`I���qЦ�'��Y֗zac.�O��8%�^��6�C��t~R�nR�p���N6S�)rD���2]�A����W|ܼ3o�#OD��_:;��	a>2䇈���/e�-[��2-�\�`�����l<����ɐ!��Ƚ������}�@�1�	�7D�#�����E �6�?X��g�
���@ޝ���Ў����?�O���.m�Ibſ�uF������~�,9�ٔ%q���`����D��2���_��g7km�̳�����F�����e���N�4
��S��n����l��!�.��[Y������4�����f��ͫ8�N���ҙ#�a`;������?��?���j>��V�oڞ~�����`�-�v�����"!sD�m�$�i 7��L���gY\����𿊴�zM�&zbM�h��ɐ+��W�ڢ��E���iy���Bwfg�bM}�Q��ʘ%� if�K��с�ʗm �[��������f��Ѻ��D�r*��F�'�7����BJ��2"��ٴ�H�-�C��f:�rQ��@���$%�P�����6L*OM���+_��r�"ٴ�IjZ��JiAA����H=�Y���4��6A�����R�;�:��G�AF'.�Z��=)O]�d"B-	�4[�T&�e��U�-/<.��5S�`�J�ʐ��B�<��޽j�g�e�]��4꿢@㗊�B��Ty�c�_�� υ�� ���`�:C{�e��
2]��C<�*���K����k_!%T��ٿKz��|�ȗV������o���k����W�V�m�,�b��b��Jy<�SнͰhF1��:z,�}��YtA����2�HÐׄ���+"-������M'?L';���'�e2�8��Yr6-k�%��Ϸ�*Q�h7h�;8�P��?�-3�f���w�E�ڱ�ɷ����%+M(�e��l��߲�)}3ܬ�|j������L�[3�<7�����*[������Ю�֛7�O��/��ͫ�!k��[�-�!��2�ϥ3$;��_wT6y���!�KqKmK��_��i�<G��k��m�nLӑ¨~�)�E�hx*�&t�~aʒ�u�ֲ��9��c�xT��ј�I����'hҶ���ׅSc!ʣ���w�'���*�@�
�b�؅���-�)��8Z��;*�lHq�����7�X���D%���G�Y���@��{�9����O��FR���L��.��Dl?���s#�&�.$@������U��̊)��-�_�M>�e�����Ѿ��vm�dV?�U�NF:���B�D��-�DT!I�:�8��ӵ�%�%M�\Q��l��Ş�!+�E(e�`�)�T��4G��c^���f��u�6w%q^�����t���[=��޶C]Z�t���cO�̤=H\��
g���!�ӫ1���s���e�L�B hiĂ�b�H�BӐ����@�t$d��F%��%�oA8S{�d�p���>��	��y��Z�Pc��|Eh�E	5V_n�>�hG#�.{7�"}��ֵ7�Qy�穠���1|��Z��K	�Sb�l^lΉ� �s�X���<�o��F��j�c��G�rz$�����ӗ�/R�
�|�"ه�g)����}QD��(�:����3$'چ�a����V7ͶM�t�1aP=M7�f�P��ݾ�8J�}wY���ځ07�݆T3���n����a�]Q� �&(�>��s�u���ԱsS��?0-1NS(#e�/�tX'f�s��Æ���e`OQ�Z9-�j�mHEX�r_�snZ�2�c�J�~h���p�����W�;��6��L֤07be�@�k��R!%ǣ���q�h��#?wٞ�����d�`ů�X�Pi�T�ֳ��ֱ��#����/\ꦡ����������	��f[L�ⶑn�uC��a�����(�]���1�N�8b��Q��	��n�͡Evn�>��Л��9l�lX��u�l��M�b�)~K5����K/�;��h�}�P��/�e;���rΗ�J�H�BQ;����\8S0��q?�,�F�����No���a��m[%)I;��1�غ���Q���s4R�Ü������ �D��A�l�}���1�P�n3�fǘ9eBi�ř�x~r?ȿ��+y�✆a,���8�yn��.
��e�m�0��}�˾(��w�p���8
ӯ�_���]���jl6S$LL���fE"+�O��{�Jm
eRH��bq�j
'��5�>�HҳԂ�iИ��b�����U�*����{�[H�Za��iݥ{cD��Z�#�(���1o�d.�$tϘ��G�1��Fӫ���hx,��P��$a��4u7�
��7����S��lk˼�}UKa-ݧ�Y��Z�}7���FJ>���ޓ#�c��;vo��ONh_��W�yK�y1��)�{.F��v1=��_<p��+%�͡����������g�m��O ��7�{o�)T`�� �����q_>���P��mRm��a ���T��d�"-� #�Q����EW�ј}TAQU?�2�v�َD��DX7���
�2EY����xH�N(۠0RC`���I�\���j���Ca�~�3`d��\JQX��:�F/X�eD	���1�O&+�G�B�8�.Jo����
�h֘}Q��[��ڜ����l(Q� �F� h1��3E#2�_p�1�`�ø��lmWCCd��<��?�R��rH_6N�
 �ӊ�f;��7�D���d�)���V�HMZ��� "����V����h8k��<S����F;n�"�V�A����j��ܩ�t%�z<�ch���p��}j�K����V>�RC��s������6�$�#�\��
������a��ތ���˫�͔�Pb {����~�N�����Y�+4��ٻ�tR/1��qzH����%&P�@�i�m7s�P���fAJ|%�)5�$��3%%�G�u2���H��D���ӡ!��lX���v��L��Z��.���O�FH�*��*P��`�/y��zb����l[��`�)Cye	b<�o���G���Q�Q�2����_�/�`B��a�#y��_��/�x�`ު@�oȑ.e��2�t`Y���y�]���

����VJ��G�B��:���&�dʭ���A.����^�E�-�X滠&���R������TJ$@0�;^X6qA�Y`7x����mBD~,�n��1�DW:Y"��:��j��݃��m�!���n��-�)r]ȯ$�cq77�H0��������3����UbO�+^?��6��[Mpȃ�����
� �`l���i�4�%���!? ��٠8�������,���/�[��}��]�ܧOV�pRr*4�?�6�PP��6�&�"��e&���臓��/D��8���o�@R�!��1l��S������o��Z "����q�
(u�B[���c}<mK�	+�Y��qiд���Ccx�꘾_7�!�^�i̮A�F��P�b��9�"��]�:V��������<=jʶ zΫ�sL3����|���s�o#E=?��0 +�����A��#k�N��\|�>�#��z��y�޶1��w�H��?�"<��\?�F��_��
Ì�s���/�h�h8���M'��x@�s��81�r| KB
�&� B1��|�vavkFY�=[�|�M*t�Y߷�qp����:����w��T�ݞɛ"�Y��G����}l;�V���ٱ�yVeT�<׀��mH��=/�C�:����$4"�w'��fÕ~���~�z��Oo��2No��[���GI������6�d�rxAM/�!n�'�D��g3n�$���:}67�J�{#��3"J�B�*�P%�e�AM��[^�at�y���+������䮒ݮ�ip	�gՃA.&������d���	l8q����C�����v;JS    ����"fV�	&��bF�H�3�մ~��9�5iC��mK�4��������^����+�o����F;�C���M	ً�ՙܸ*K�O,"=��������-�eh�����۲^LU��1)A����F|��������S`��\��t����(�HW#��{�z�y���(ߡ��v2���헯��y�ck�5��qio����Zy)�{{J+�7�9��|`ɗq�c���?�4
�߫PQd[oa�QI�*ɬ�ئ�۱��b�߽��j	�UEl�h�9Ib�~<�kj��*��ݙ\�"�'4�z~I(���Y�8z��O/��ew���P�ҭ�l��4��k3�Q�?���D�#���/�+t�T�[�(谪��\ [��bb�2/_�s���l�<B����4�(�Y��WoD�U1�i�;V��*%އ��S.�ti���C!��4'4ɦX��yHW2M������"8m���U%���r�z�U���@�U�٣��@6ּŪ�U�n�-�k��
"��b�����:���d�[�cm��\�.۠��k����H�*�^�1*���C�������v�b-5���/n�sT{� ���S⾪��f���a��h�W��������kA{R��}s=�)p�A���#���ś9Z�ģ������Fh�N��c\~����Q���'dFO*�:=�Wh#eq5��C�n����3kP"�,G}N$E�uo�H��*RL��>�Oa�������� v���n��s�"�f��R84�f��������^m��Gj��Ci�Nb�`-T����БT���!�5|Pq�:��﶑�Y��`��8�ZS�,Ok���I0e�/�C؍y�JQ�0�r���@�C�v�ќ�T#-8�1u"�(c;�R�}�f4S�5�c�vϟ��T�Er��ߊ�д��i�(|�C	J/뙕�X$�,,��d�����>��Y�@��<�*l&�ɬ��uJ���Ϋץ��O�~����� 	�Ih?�S�솸w��*�fb�,��tՙ��3��m��:�n��5fK�o��h�Y�|:��6��M���`��1���嫳zԡY?&��(U�����W<Τ�^�<�6�u3Qku�����TU8��C�sE1�^\Oh�X�\���M��T��+���)���v�J���u��4��v��#�J7kNM]�^j,���SH��;bE]5�Q��ϻٷ�x��-	�.�o�ٞf�>�ֈ�Fj
����U��̅;�B�)�0?��U;�2;ط33�52?�3��)�\�{�i:��vI+�-�?�ܴ�C]�0�U�z0�����á�����@�$�Z�,�}PSV�DU�;n"�mشV��k��G�]s��Hܶ�u��������I�x�9�S��;!}�@�vj6bB���ڈ�HP�'Q뺉>�k2R(��r��S���H~�G�!���!=�"�CpJ��7��c@��V�[7��O}��"1`S�K��f�n��"�9�ZM�i��nΑu?0���=6�Ⱥ,89�+� 'E��23�^���A!d�E��sd�qCO5Nd�����H�܀�B!$xgh�y��$�Ј��:��m�]V,wc�)nߪ�ƶ�u�89���H|ۿ�Mv�n��|�&���P�2�5ſ�0w���=|qT&���i�z�֘�QPƁƆ�f��6��e����jG�+>�����������zƼq0��u�`��I�U?�~얓1��`��b��"��t�F:?m���Iɸ?�[��y�ӸHu���T���"=�I���(���KcF���Y�vlKC�����ޯ~#y��y��f|�F�%��y�#:M�����7�R�a�����HsˑA5%���T,����;��u��f�F�ݻ�䡬@7���'�κ���Y�K_���$^4\;~�b��8�� �MK�V�ϙ;*�AZ�Ǽ����M�i�����`Qyk�s%����g �;��p��*�oH��i�ʾ�V�K���B�)'�(7nQ��}/�POl7w�v�����(�b�k�quv���P7����c��M҉�ʽ_�&9ZOf9��"N���'�5F���]�j�0,2�;ކ�����0fΰ@
r�)�rO+�!9�5����R���}EZ^�"�B~4�=�G��El}����D������i9���ct��`�Ct6�j��B������oqZ�F����r�#SU�!��˼XGQ�xa[��F����^󺑂�^M�o���Ǭ��T��rݜ"��XJ�p�#��Kg"=�P��;b� .���Z�`G��0�� �g�	�$�Lsi���Ui���U=h�D��i�U��e�n��N
�ҡ��������3��������܇<�а�T�%>kX��J�i��k���q���+���t$��=���=��7���������8��aYs�]�����%_�sIX4 � ��rٷv>�q/�ua�OB!�'�Nԕw#0��=�L���нm�u�u鍣(��.������\�eF%�=y	����6��7�Y�����/�`�8�!�-�����rz�r�{`2܍3"�q�p�y5u��@d>w?������E��?I�*+��6 �޹��9ȴ7���?�$�7�Sg\���D{ˡ�y�7А�-�aR��;�/��ͤ>o�G�Ⱅv2��u���m�@%�a���DX:��f�i_ 5�E��d9]�8�AN�r3N��K� �մ�{�����ɑj�ү |8��Q�|�t�? @�cq�,�-lMŷɏ��1p��Q�_�©
o&O#g�@[���F�Pд��J[A��Z��b���h�\^
��A���H�|;C��d\��l��k�����,�`0���7w7=�
�ޛ?�z���J�Sc�դ-����M��n4O��u/�2`�C:a�1���\���{/�!$�,j*�1����.�D�#��M�b�(���G�A�|}b��d��RT��5����zM�N��5�bM����V�Ö��k��^�|��[��кzM*6�����#A� ��I���V�G*ÿ�8m��H�jm7�eUԼo�q]�??sv*Q�o�ؠ���5k��n�Q���V�l�������G7�.�MV� 	u�7�vMV�����!޵v+�Ҵz���#��B�\K����a����D���LǞV��y�?_
rj�Z@�y�=mk	�>斕��9RtM^���l� ��	ْ���n@1�� ����<���]én�u��V�T�Q�I�"���M
%����Nd�5�'T��6�E~*��	7�9}���#�M�:o�z��#p�&�ۆ�$�#���P��#d-�Q
�>w�m1�Y/b��rؐZ�1$���"�����+L�0/�e� �{��v�%�y�b�����5�l1��D���8������KA��Z�12�|�����[�ذ�h�^tm�x:��\e���2�@i�x�"g�
T_�`��gذ�w3�|	�N���ݤ(I���a�tFZoG_\�rV}���l7{���%1���L�p𚜝	00��Ϻ� �Xu��L���F=�73`&��e�,�V����^n�9�	^~���!��>��{����Y���/,R��]d�6����5���atQ�H�[����s�:����\�K�㦜���:A����?rkK�H�HG�߁�%J�����ذ(QW*�Q;�&��.��4�Hy�-HyE�-V}! ����{�D����9��t�M��ɟ�o������ݺ�h��lmKo��$Bl��05ͧ;�ދ\y�����P�3�(��na��G�s���R>�B��;H+t�I����i77^(��
�&�xQ�� 򠦤��h�TYI=`��5�>x�����_����X�)0Ju#2O텖i4�љV�"� B���w��к���X�@�Bg��vA�Q���1���C�$�:ӎBJ{a����
�j/ �nlt�oi�~r:�
�#r7꽀�Oj��9�R(愴ث��؉E�Mk���6cf��    F��>V�䖝���GR-�#�^�SY2���۲=z�x�	���m�O�7�FT�b�B%�b����8d�����y�����֍'���t�\U��\��Jr���p� �n����$�]n��j�8#�ޔ(���Q����P�0v��=�@u�[V%�Ͽwy��^����>3*�Ӳy�&���<��A��͒�ħ>;�t~�/*�<�Pe1�D���B
��W�Q�x����VmO{��"0�H�vBp��)D=8�(�aE&� 	ʠi R���?�I�MiO��t��(����"�6E����<'T�Ҡ��,����IϾ���N��x����Qg����˄�`\��������21��ɝ�~�(tM8%P�S���,�/l��G�L�!����P�X1�XkgH�kk����M��I�++�i�(���P�����G[��nZ`���U�ܰ�09V��}uZOYBPY�RQ��ڝ�i�N���4�F�QA�2	���fz��rv�*Ӄ�<�*r%J�@�Ί�*�8��TI"�$�UE�;�p�����pF����*I"p�rT���C'�Z瘟����
Q��r&b��;�{ t~-3	*=�.l���=R(���)eߪ=��@#ѝNkO����B
���6.��}\���$�����p��A��Ꮥ��4�Q�c5�m��D5mw�CQ\���ޥ�(��8��P=d7�]���LH���?���Y7��_�����uT0�����.�1�?��=qZ�D����n�1Ҡ���2|a+b��0�����]q�$*Յ:ˤ��e�o���&� �5b�/�~�4�J���+�*8�԰G��<#���ӏ���t�~WH���]wٖH%=:j-���6��X �ä�G�yE�(C�������x��q�|T�p���v˘0dq�[��	x���2~�	Q��?.���u��i���8����L�q�4vn����t�M��_��/Ƥg��t�fQ֟^�TE`�䳛��@l�b���'�(9���^\a\b��fK�G�6a(�ޢ��n�|{?Ю��J�($���Kа,�]�|'�@�+��?K�e�?wG(U�]�2�H�U&���%&
�%��?R,��d��E/1=����ǂy,�Ƒ�M�Yy���@��;ÝiP����=3��W���`/��Փ���n�'!��ӓT��;�wG6�p���hL%*_i�YIz��X���Z��KI��^�ڛ�����8=G�ݹDq�Ȁ��Q:�~��C�A�؞�������`[*�W�[�C��4W,F=��zZ��7�������]��	[��D2 T���/q�>?W�߶�؆���٣���P����H�z�i�7�c@�[�s�	�z=H�~,�&���� ���u���Y(O���w��G?J�A����o��L��Og�鲚m���P<9C��5�4	Β�=t��.r҇������7ӧo������;����X��:�cbL��F�Rs <�m�N8�ՄJF��x�a*`�W@�S�a�����g�D39nM6�_��,=� �nF�U��[[*��P I���1v=1¥0�!i�0���a�:؏�Q�iB�w(�\�S$'���V��y��"T1Q��>i���U�#��"n��K��*�Y-s�8�(t�5��u�bB�T䁂��ϫe�a� $pkv�D��
(�u~��!T�i���ç�z+��E[�#=N(�MK��Av�zQ��k[?���P��տ[�/զ|�)�@������7Yr\G�EE���@��!$1�K�*6:'��?��;T�c��㙕U�+��: o�;�,�!M��ԟ%���4J|C-ˁ��f�@*�JUY��a���M=���7;<P��L��� �xJ�֦�b�g��e��Rp��2L�;��
A��wA<�_0�Vf4�
dKa�� )�wט�Լg��P��lS�?�t%#e[r�eua9�<zEm~��T�35T��M-7�~Lb4�a�U��0��\�y���ڟ#-�,���V	�T����-E�%�:q�a��sZ�<��FSEy�����ؔ2�L/����@%rz`��7.�0��~u��yx/[�m���Aa�I��CX?MX��Ҁ>j��:��|Gp�a�Z�4��5�L�i��&[���j���X�3�Y�+t��ó��?5�{`���Q����L��O��#��ϳ�nW#`�����ӳ�J$�sZaY�mce3�.������2�3^�e5��]����g�w�"��u�mU���"����PY�b�P��m������[Z��;9�T�����Щ����-�%��?H�7-F�r�A�o�%�9�N8��=b)S�Uo��0C�/�7�4y�e�n����v�7�K�̕y��E:9��G(��|��
��f�/��|�r�jz��0/Ψ��/���P��F&c�C�(yd�*��X���!���j����싧��-k��/;����f(aa��;�lߑ����l�6}P
��k�Ja�х�!$���7D�����}6���2�Y]dJ�L*����$G]><��q�Z"��a��A�Z�~��XK��������إFa}���߳��P|f^�d ����$�l�4��P�����YW^\U��?n��-�X0�P�_��&�����i��vs�T��P)��x�WVg,NB)��&g��}�� R�N�e�6	��a�^�b)?Ď�L-��O����vU�������3]�@q��f6Ϛ�����L��)}?�0	��q�2�
���kD�w���
+��xۧ��E��\g��Gu�:ԁ1����F,�7Ɂ!)��t��e�tޖ*z��F4�a���b�� ��v韫L�ZR��])�]l�����;�c�(��ٖWʩ�+(���(��(ޝ�m��b�m���w+�6�v���P�����غb��p�^��_��&�y�3�Ol�+�k�E3g({�����7�0a�N0�v���I)�����|h�>��/F�����7��+�Rj��� )f�/t<)�<�$9���ݙDQ5�U�?ۉ�Q�8ر�=����q���H�6ǻ8�����Q���|֘�J��zS��T�&y���HńX`=a�.D�iy]*�ݙ�;uJ��8ji�� �q��<EA���fl�+���幮���������R����zơH��ԒZ�?���&��>�6+������gq�M�q�՘��8m�t���V�"�IEX��e�m&��1_���W��3]aI�I+Ȱ|z��3����γ��ɫdZL�T����aO9Ԙ���F�i����}��ڈwJSk���*f���]�Q���
�����scX�]�*���%ѷA���^��Rl���Bx���b�띯D���+�@D��6Pc7_&h�b�RY�Yc�ku����i��˶:� ��
�ѭ7�"��Jr��W��l��\��&�t,��|�0���'�׀�	tx��]�X���Um��L3�{���P����Z��E�ڼ�ђ�L�!t�<w;�NUr_WV��Mޙ�2<������f����o���Z�V$h
�?zR5�Ԙ  ��p�;��J�f�y�� f�v��t�o��g����=8��WL�9%��f�v���d�p�;{Ş|G5 ��0�4�g`��Dկ����0y
�Ѵ����=Ry@z
w�(�p`���\M��pF ����m��C�&��ß_l�����A��)u޺N4fN8�1���9�8?�c֤%�P~�^~"���4k�ja�0���[5���cF���TO�����(���^s%6w`hЙj5M���n&��e/t�+��j���$�5&�������b+��^OF �Z�T{�mw�ݪ�^��GL.h|Fi&�qO�q�M�*6�=�f�ɯ�D����M�6�6q����E6U�3"<����*�c�%�%��1`��՛�.���=��t����Z�D
V��a������_W�8�����I1���a{���N`��W��$���Fj�:�8������r$��z�    �Ys�u5�D��<�@�{�1-�^3���y�a_%�J�1#Ҙv6Q`I��A����n��?��� =^��Ϟk��(�9E�o�6E�3=X�7�Q��x���6]EM���^����Lal��sP���-�U	1�L�e4�]��T������ӯ�x�{��O�"�Z�9�4EL�A����4�U-L��o0�ݲn��~��(L7%��0�V��8���Bc�� Q���W��KI��{ID�B��Hi����fY��M�6^?c[���o�xӫф���$Ϸ�w��-�zg�-��q�҅���aO�i��������1S7��$aS$���i�MOL��������u��/`îR�����^�A�ӝ���&�<ebe���1���6��J)��A����d�Bm�o��}����m��S��P��|�[�p���"U+���(9X��P�e�o|jԋ�Q6�kl�y�_X�m�cT縯��L0�ǲ� R�4�̌_�bG��l?�)���}�5��P���w3T�8"��J��p�%��Wg;�<�\j�&SM_Su�D �}�C�@O�,��\U��ԻNǇ� Ю�w`���z�k�Li�u0�G0�Ԍ)�����?�l��:�h��m�*ֻZKf��@mz��q��i���v��E�5�On�4�;Vt*�fW�'�%���h�k ��>e��fW��6��͸Eܙ)TaU�X��"V���"�!Q�u��5DC<��u�^�^,w����u?��`ziژ�(J��u����f�,��2��$�&K{��7F��]9�u�z�qe%4�U��ؘ��:�H����OP��K�h��F��,��%�������d�
0?hǴ� ���Cvљ{����=���ַ�x��z��mq�2~w��}�4R��*�Ӆ9����\���>�q���(�h����8�]#���#��R���*ph����Ù����9�k�9�����G�W��ݯ6um1W�cM_��ܑp���K��I�l�te�j�7��U��t2'~s���i��.�B��Ӂk���/X�m����ކ�j����� 3���pf�m�0e�NA ���b����w��w�����"o���҇W�������Z����i�\ַi�H�%����_6A�(?�o0!����j���Y���v4a�Gn��7¼M�K	k�X)�v��bc�S"|U���_s�������0��;��Ǧ�����i��M�PyZBĨF�!M�)�!�Pc�r��1��ֿ6Eô �M6�m�'Т�w���<���1d�:h�Q7��<�V�j�5��٤/9��J�û�ن����pT�b�(��͂e`������a A�l��&к���ê��Rk]P�p�K<F-�a�Jo����,)7-)�e^����٤jޤ*LRa�X�b�0�O���"f�`K���L�E&��'(饨8����>2/�nt{>O�ʝf2Mmx�~�?� �`'��Е���awM��ZW��Rk���9�HW?���C!*H�ק����h��i���{\��zȲ]�۶��f"A�����A] ^g��l)����`X�a.E8�#�W�5Q�:K�����r}<'	U�!��}�5bC@�	J�ޜn5�_�Q��٪t����i���fZ�����{O[�����_�J���LCx���v�%���6I���I!�m��Lb�V��A-Jo�"7�[��$v��N��d��1yq�	�_�*K�n�p���	���絛jX2p�W2x�U�D۶�󖼼l�l�C�*C�pW��A�#(��lP�
���}s�Q��Ѧ`�<.��;а��j��P��ڀtdګ��r�t�=�&�p0m߯+S�k�4��Ja�g�x��]7��=�ox�k�g�<�р�)�~�:�`hݼ{@Jr��h��~1��3���yW뽉� ��'�nh��SHݍ@���ylCl�PC�%c/t��@�^c��W#����P.��@5w�Rx�}ѝ�|�`�	��#�s?K�${�U���%ܮ��U��ʧ�Y)]�6�í�|�@�����tٮ��u��Q�]�M��k4
�_���g�/`��3g[)���MR���%:�H^�(���.�/��sN�g3�3&�`\�i�-��ﺽ����tySx�I�%{��0�Fn� ��<UK	��%�tV��n�p����At��هJ5�n39��0��ڕ9a����%�8l�e�{opQ�B"i�جGxw����fs��"5?��h}A��`���M�8{	��>\#���#��g3}8*I�q�Kj+~�E�v�C�����?HS�VTr/�U���߹�~C�<���bv�a�����*�>6�P���{��aB��1"��,-�2^�lں/��0�߬�h����`�s�)8&�>���`����`��+\��5y�a���H3���6���z;��_7��B��{�q�93�kᛉ�i�}G[l��sj	�4Ƈ�����i1��<ZM��k]�`W�Q���~����jW���5�Q�G�D{�-��h����R4RN
+J�(OS@���Z|�<,�k�8><��q#����i��&1r�w��"���U8�U#��Q�5@�`>�������Z/�2�6��5i��o���\�3�ƫ���%��+a������b<�0m�.La���/w����Bt-�����@oKvm���&ߵi�.�;/��L���A}%�v�L��l�ٯT�_��t�
�|/-����<}��LIY�j��hD��V��Q�j
Y-I�S
+bK��g��J�ç��8��ڙ�Xؑc{\;1�,�h��ԕ*�zhМ�S��÷�2ЯcXHw�jD�S! �����2�dB�����";j���ִ,�Y��K�[a@�ޱ��/N12���1����fp��6j���i^�����uz٠'���ay2V�'���n��r�����`E�H����K�R<���c�)
p�����{K:= p �<����<5駀���tǚ	Q�јMx���,�8��(��lwS̠;c&l�XU�J4i��^�Oy���~u�`�� 5A\�V��=D�mZ]y���Fd
1�3P�.ݧ7��S����,r8*�[ eP�-�	��e�@�A[$\�p��{<:[\�;4E˘����,��1 ���w[���jGbHa]��9�HtJ��-^p@�_��6,����7a�q.`�iL� ��8Ŀ~`�ϹO�
��	Kqv��� ��.M-1A&M'�,���]L��5���l!�G A5�s��TO��7�h3>����Mǻxx�H������)S��e�r��U�ju�4�[���s[���)�A�u��=r�����~�Y=����*Kd{�ʹrI�Ie�_�i���-�����ʲ����ʹ5{��0�]�.���^�Uq"Jv6�@:��P�(����]���"7u�}�O���V���?�'�ޫ�84�!-���+�+&ۊ�6����vZR��=��9L��#ۛ6�Ka8��A\LҜ�}�ƢrI�)ZM?
�\�
mx5O��G�u �[���������v�TLBm˵u����J�m��:-ή�P���ш�W��Z�����J���@���IUhxï��
�P�_��j���;S��)� ����>z��3�h~��IհTx�b�V*�C��%�[T�`"u�p��䪵`�	�pf�I����c6-ڱ��XrǪ��V��b0��Q�8$�[S�ѐ�}�E�_�vgwtIT�&����ך���Ą,�CA�"N���iY��瀸��&�R�L���+���hx]�D�c��1�Ea������^��̞���<��[���ah8�Lb��3��	z`lN����ΝxY���ӫ�o��5���/O?��,f��_�BeR�C�^�!�B(�ͺ�2)�Za&�c2�TI�]86�Xh����A5	Գ_���)�L-������G8�tH�bd�ރ�0+��q N����̶�aF�J貍7�3DX)�     ����T�|��T�	���E�[ r9=�}�J��7�J�J9&������*�|���p�r��{��GG��ll��2L�VAg��۶�x���o���*v}�ep$�f�� �Z���)��ŸC���AH��Wĩ�aJ��k�
�` �ن�=li��z�Ӵ�Y潩�:q.�����Ԯ�A뭏I"*�B�7�B�li�:�^��ٽ-�7�dcY�bӆT\3����(I�ƻ��?�i_���f������ύ	�J���Ç�e8�a�>��
w�P$����ʓ�q�U��"�����jQ�7��Jk-\s ����s��Z�0���"��U�.x���2�Ӳ<d�Xm0�/1��?�Ia��d��|���F�E��.�&F�>��lS�Z������E�w:~�4�����?�+E^g���Ԓ4��Z
Q�_Ƈ(����V�Ft<[��S�'�q��v���W#J�����Z��l��lǱ�<*�ɂ�Os���R�s��P�g��5���� 5Jvp}F��nD��h�~zk(�>TFkADw���7�ͣ�V@XZTNyu��q�(��ߧ�1�����:�%W�Tf�l����&�6���I�ё�S���q��K�ks�Z�|�fo�5�,>������K�hr��u�I��oR�f�2���|b2�p��#�;?�0cʺ$���/	�W/I�9c�'3"�48�4�	o�9�����ٽ�ţ��������G�ȉ�����F���9�^�(go�I;�on�~~&N�:л#�ǁo���m���fp韬P �i�J;���*�BjӃ�e�V���J�Q�	��&&A�!���xcp�@$:��P"�I��Z� �b���"�����[��&�y9��tX�Ru)�c��+bLx�Kb<��n�ȱE�J1���-�M�<A	v�h��a^�澰�4�u*7���RĨ���9ў���<�1�R*E���2��W�R�4�����FӲ@��2��\E��1Dd�e҄Rp]��EUU��Ԋ��~·�_�"M�����k�H^�s+��Z�k��p�'xh%ԯ�����:�\��H�	r ̈́���q��O���8��n~���9�5O��{��m�$�T�vy��&W��d*�d���ߘ[�&A�4��^[���۶�%�7<�t������S~	���>���=4��:�aY�x���yCy�Ⱥ�6�;�a���a�
w����Ynh�P�0�\��US��Z���i��T�7�6/��B#�>�P�r����*���%Y��
l�?�2�D��q�}[VKIH����~!��c9N�������6j j"ær'�mWx�<~!6T�S�
|���|�$�W�x�QN�L@N3�TgcdUf�ݺeY{�/�>XO4c\'�?���_/�~�m0]� �aX:𖫾J��YF����)oo�����miv���ϢqZQ��/O�e�$^�����A���|l6�R��0��k�L�{Y�ۜ��J-V�G������`?�6���������)�Hmiv���]�A"y�3��k�"3�@-�h��^�~v�l_l��f��Nߧ�s���0�v�;�e�5%a�}��r?B���bm%R�I�:n����>1T�%M�2	��:su7�QQ�������A��&�횈���<�I����mR�.�B[�Ϲz���נK&�����fr��"~�`���JG�Ď�'���r�i��=<{J*��m�y��cp+��f�\035]�Z���5�ݞa����i)�������%*Z`jz\6������-XH�wKԧ8����!�4
·�UE�
{�q,m-0�i�l��R%3�~��~�l�@H�6������r1"G�	���)�)&�L�f�ٛ�u���MP9�V�t����wݿ����CYM�OC���-l
[�j1ژ�<�H�_Td��,���.09&�W�J�Q�=�T����o���؏{J�~kv^�ÜH� ;���n�9��3�Y��[���fU	�ɡ�H-	(1�A`�}ޮ�0�(�]B�]`��̎i�f�T�D�Ý�,~2����С�}��sբU�Lji�����*R5D��zN3p�ͦ�;�B�}3�S�������W�4N���mQsӴΑUF���Ze�~1�����ϱ�l�W��lh=|�o64Ap�bKWo5�����J��٦'�e��C֒B�)0�B�up�M_*.�X��._JUh^T��*A�c|D-Rd q�_0�P�eqc0��A���+�ܣ��<��Ƭ�,�`C@KɓW�Y�W)0��]бy�&�.�q|#Tk~��3߽Q�z��{ʆ����\R�O\SE��y�����igR�Iĩ��,:y���-����|ƛ���F�y�1-!��	���g�ղ�5p=��3�p8�v�Φ'	OGK�+�4�������84b�c��u��K��I��޴N8,D�k�d1���MA0������1���O��/<��eD*�;��v��p!\�OiVW�՝W�KLZ ��`��8�邴�������/+7u؝����B��o������|.�3��ު���ì��?W`���k�F����5S����0��q���_�;��BV�^f�kմҀ�H��_�u�E�tghO�k���O{��l(���RM%�В
��U,J]�_��IC��)�-�Wb���/L�:C��3�-=�{�V~����_N< 1��]?��Es�3�A�O�a{��]��b�73�n倛,^����P� ���� ]S�EihDz��cv���)���͋�����Y�[y���S���T��taKQ�xY�2�L?�	)}0EKd���?�B#��Mb$Y.`���^��E�я7�S�������:Uu���twK��s���2L� �X����l��(���~\M
�SŠM����T�	(�-)9 �� ˽|?������6����+�u��
�]M-3���vǪA�?ġ�����d�i/{�Ib#j9�����#�������b�� %]���a�Ϻ��<��{��m·Ԧ*�yX��%��vY�3B�_�G��#�#�I���m@�rҠPV�����nj�8�����H�01�0R�P��,lw�M0��k*}�{��W�$6�OI=
��4�e��b�V���evN����`O��w��A�$Xt�g٠U۴!ߊ`@_�r��S˛��i!8�t���BuqhA҂�U��N�����8���p�7��sxM���2LW�s���� ���18O�;W��� d� 8;>�U�.Zu���e���Be%m;%�_��pO*r ��y���%��z@{����x[�iK걘M�Qa�~
嚅�B/SZ��77��<%�3�E�S*��D]��3����]��U���[���Qw��F�:��d`���x0�N4S��z��iN�I1����-1)mn���4��:��k%��^�"f���M*%�k��b�8�M_�
��:&~�bH:�� ��p�52�j���t�Rl�&6優��et*��r	�]P�;Ά�.���,L��}�Jf�<��v�+��2���m�K%�X�i1�V%�X���J.�~�z.�toTgʙ?go;�U���	�e��<��̔/��_eB11A�7ðv�C.����2���g�C~�� �(f�����H��	��m�`�%��Te-/'XH�MXa�%	��ha�<Vg.��V���rc�e9�(,����F*��9A�lH� m�\�	�9� ��%�W�hTE��I�y^Q�#�g��>�Y,�1�w��WJRJe�2�w[ �".�	�����,��Ld�$�@�z0f�/�ƣ�s�SR���1�0bBI�T ��Cq���a)�=ڤ�`e=�ei�N%Q/�PaL!����aZ��%��-��
bX2��S�PE��!$��4j6�d�����b	O�����HA<g�HM˖��S�O)�i/���t���F*`��35�Ϋ9�X!��6���J�Ե�(������gK����	q����,�8{.�y"�o�U�kG���?Zy0"��?W�G����]+l��P��    K��Z�g��2��0��Nil���:�5C��&����Ȯ��O�ĺ��u#��[زJB���N쯲}3"�$̇Y�h��$��7kܢ��P����QF�O�-��Q�D��0�Q������5���Ċ�����x�"����A��q�Do+G����e_6Ϣ>�v|nn�6,�.>���}��st§�7�je�v��~g�IU�F�K��>��ɪXũ�׌�?ݘo��?q���4�$�%���	�2�"�JR����\���"֋��a����!Ъv��p7=0u��B��k�KU�U���瀊ԓO��	��Z�`�]�X��������C|��"�[0�R���+V�h��#�i·^Ah^���q+�չ�΋�����b'/9��u}�8�����l�m��jW�T�Ӭ����xd1m��:nߡ�p���.v�|�&�z�RO)*&�݆�7h�~���<'����?��)w*�?�v�*߿��S����{���7�(�����w
e���]��9^e��ť6��Ӏ篨o�2�]^N�w`�z0~K߽��u�臛��W�P���[�(S��5T����/�'Жo���Rfgˑ�v��2h���Rٜe���N����EA5��?�'�ɪv�>2hJi��9�,�\戴a��t�����0���OmQ�:Oo���V��9%�Rc	3�{M3�f�6��ni�*����ɖi�D<�%�"~n0����;ɘ:����e-N�P;�Re�D��Yp�(�jQb�>�����jb|�#��]�uw$p��J I7����4ߦ��9:�x,~�m��8WW���N�Ws��������P�?G ��=�q�.���;����jf��e�mH���hi��Z)�8���K��i����4<��0sR�F�*ʆ�8L`�ɉ�ZM�*�C�д���6��#��1p���7e��P�I�4t�)���Ev��^���ybo*�JU���dt&f������.���YU-Qc����xt��5S�@r&X�dH��75\�L���X*��ݞZ�Մ���S^�H���u�	_��6����H�t�q���P�H�.�_gN���#�]g�h�w3�)�h\����dC�W�2w���=&��.�Z+X��R�@���'�h%hZ�,����O*�aw'�-L���p��\�{ U��{w��j2n �<Zq��B����K���X�u{n�O����]������$(�u��Nު��Π"؏�&�K���{K�74;�&�U�|%<�A��RL�M�[#��rO��p��W����F%�>@eqG�{��\
1�K��Hm�^�Ȕ�5�L��3o��h�6���$�&�$9�S� �Tc�2��QY�M�o�0}�=ǫ�6i~����hp��.Oζ�Q�B��3/h�f��`���f6Ġ�>�C"�R�$ְ�� D�B��hb�d��Z�$�p*��W��J{���(ʮ����xڞg���'�4����Ѯ�7ڳ害ס`���N�qpi_9 �V�r�_,#�ɓ䅧���d�i���&C(�(�9��)�g�-\������ڟ�Z��" zx�}����lZ�̝�1�j�36��{fQ-�{�8F��H�m�m߯I��!Z��ϱ�~uv-8�}_7�:��`~����)D�Z��"��(­>tIf��aFz����߬X��_XQ6��ydk�FU�"��3Sj��D wW2!��Q����'�^� .����;�l�A%��6I��>�G-Q��;3o8���g��]mZ֮��$�DA�g7Q���eW�τ�A���ኛ���|(\�+u��lfWj���h�H����щ�gm)��&5>'"�����H�����<����3�.L��K��#�i)��#Ӻ���yDt�D�'7��{��9�$gw��[R��)j����ܮ��<�ʝ���s1��P.�K������00O���uy�Qz�)꒞x������f�%�e�<l�ק[L�k'=̑�\��;�a�o��L��"��W�N:�G�g[�0ә͸����Ӟ5S�����ꮛM;�s���0]�����"�_o3e��n;@��16؞w�a�_��ڲ-f�VxC��`kդ=�����9I�8dGw?�ՙ�$-f�r�Ue�T�a�f����p��ͦ3YR7���r�jV�k� �eHz��M0�p=Z��j� �U���s݁Or{ �f�tT�ͭ���g�,�No0N��d���ç��v��I1���gZ��h$��qR�걔�d�I��87@)TB�a�*��Q����{Ȯ�k8�q9�{z쳉���Z�6O�݃��EN�Di�z6:���N_<8d��%��%����i!���)�"�>��뛨y��T�:e��0B� �!����/��!��w�����[��y�V�o�X4�[�N��T[b�����͛j�CTG��y�6Ӵ<$a���;>U��Pr0������\�H��-�[M����.��"�y�z!��g
y[u@{�'~d�6 ����-�#e�h[S�N��6'1�xw���0i �4-��Ƒ_L�U�K�^�-~�
���-63���΋�孍�B��� ��V�a)���tc\�t+Td�U����Ļ[�>&��k#��ZӼb
�����]Q�R��~9cAc[��[2_�}ja9�B���$��T R�����0��P�pYX;���D�_�8[L����;8+�їҶu$��Y�)bl�E�X&ŭ������_�!J��m�?Eg��6q3&Tmy��-��Q�iִ�5D68�<�2�\}�"�~[6�m$���-�S{����n�R���n8�_=0���M��2�#�$Rʷ�9f���������>:�O�
sf��R.�}KU��/�V����)>nꕪ���^~mEK)�����6Xq��]V�x��߇s�p��0*�-^��u��4f����'������u�0�/d;�Ԭ7	+��0��[L�E�`�]�&��h����
^��������=��7��:#[�����!y�{���+/�:Q)_^(??��Y�}$�bܚC����LR������ra���W�S�9@�_���4���B�GS���a2-��8Q-Y��rጷ���T�ݺs��1���1E��d�[~4֥ug�a����u5��t�>��_�����`�&UT��|髨�#���U�]��cE&K=V��e�Dt�;t\Ƣ{�:L�$�~�A�ި�&�����
&	!��Ljv1�8y��S��_lZ��;�Ė�a�3��2�����w�:��.��{�������,Y�'P&qh�/�_�|=��J�$F5�������(a�hL�u���]�,�Byl�Z�(9���f�vy{ zL_��R�yÈ��`�5��{�6�[8+����Sd�/���L[X~��� �-
Ҙ��0�yz\6v��k�JR���O����)Ho�y�޿.=�0?8O��7E�&q�'DpM�	&��A���@Z����d��H5yV�p�3A�B"_���t%���_Wo�����~`&b��DZM"�qZj87�`f���pK�*��U���'�8p�@����BK�f�VLm��8����Fw߶��.���i@�l���.��(ٵ��	�6Y@_�����	��ث�v��%WLW�/��d�5��
���=�u����p7�jո�8����OM�0Ӆ�K׭�X
��6o?�,���Q�_f���9�����;�x�X�ae�������Z,_S_�v�����#	+5JEn��Sz������k$��6/h���0M��	�i�o�f�}��_\<HJ �k���$dqg�u�-a���Ъ���<���KM�V�tj�È�I�2��V��|��E5G� �^�d�/1��˴�A�p��4␚~��R9-=Pײ��`_�2ɍ���۝k���s4�e�ē O�5j7:L;��9�z��!���L	v�<Ө � ��N}���e�r)���ێ%&�(�'l�g��,Lh9=g��g��#���wR��aF׷#?�1�ȳ�:|�G@�@��;����a �w�B�    ���'�hW���{�B�P�K������T[���=%e�C`H|z�|P�(��PF�`잾eogHX�u�U���׾7I��s�/�#+rֳX��3��H��i\V�?����f��8O~Y���0n��e���U�0at����izg��mʑxT2�%��[OP�ɏS�?�(�DfRPI�����;]����jŠF17o�����W-V��}������˛U5M����I���Wc��]���|�!\գI��`W�~!���N��X��g��$�j���wé�Oo�������W?XU�:w<���L��5z1�͕n��*��:[�,�V��ܦ��k�m�/�/��5\��WR;w���6ԧ3�pSW2�n��Wqr_����8���Lr�G��R@j۷j Mmi mi9�^k���Q�:��9�:��;=�Hi�P�3��0��t�p��q��4.�K���)\�8_Qr�W�^G���1�'3x|�mw����9܀�U*o�zo���=uR/�{�z@m�ao���-�&y�,�TS�`�Y�ڟ�S��ݚ�4ցi]���ԛ��*`��(�b��i�	 ��W˪!�IR��yC�#�{u����H䋹����1T�us��*<O���%� ����z�L��u�>S��F$��.Đ�Uذ��J�������f�4��b%�Dݹ��������f��M烗5��#�i%i���-�����Mʳ `�k�/�ǘ&���_��e70�]=87ٴ��Zg��&��K,p��Q2�Z�
�hWf�-�R�6��ǔ����^/o�y7�<.U{d�7#��L��fP���I�(�����L ���F"��>����$�քY����5*��g8"�yz�Nj��%����&��ߖ;�Z"' �4h���/Τ��}J̦H>�|f���N���|��{���gg�-��4�P
�y�>�l��W�SRm�3�Jv �0Nf�w��h\vn�P:�1��u�	�q�lQ̃Ay7�#�݁��b���T��7B�\�,��z��W?��V�I��`��Ў%�����j��Z��i����ݘ�Rwp�0{�Qώ�yG�S7ڤ:����@l�@m U�(��,g�i��C{��L��3X��'��7<ܕ�I٪��k6��X��Q>?ϥ��b�@P#���0�{2����0���d"b��v^,y��$�4ӂ�4�N��9��Y����ʻI�"��b ��kUHFRۼ=ݷMa�a1 �l'�9L(����@y��� �#h��;.��k��\1��ׇ�����S�
��A��^1�<3�6�.X��E�6��Y�{)$�����T����^��4[M�ˆ6i��"��
�N0�Դ�A\�k��`��E�(� �I�K?܃-\'�'9/uwu�:�O?o&�b	��u�=~K�mnB�i�Oj�|�w�B��y�d�I��錝ȋ��St�ʉ�`抹�����2m��2"%�?�F:���y%����2FX���Xr�r�1>{�uԩ90�/���:�A�0m3�k���<N�6�7��p�~L��(�Vz�r`�?���hL2�U�k� ��$�!�S�9�3��۾M" }OH�Ki@`v
�n�BE� �W�-�/贡��׀��w�¤���y�+}�����%^�Z��D��=��j���Wx�!S%����Ä̄q��U-��{nW��c����rz%�Ґ��nU���0�%W�e��G���-5�R�Η�d����-kc5�	}m�Ҩ�C����ڏT��ѕә9N���+�~O8y� �� hh��I|�?O=��_�ɂ��9B��Jv H5�>]p��4����������Ҹq񃅡p���=j����W��u���U�H�Rn]I@�G<|����4���[/��%����G�!|�闻Xy������PNs��y[�A��|H=�o�;&�C��7G7?A�x��r�㜬S��X?��� Ǆ���n�1q���o��W�~�\��[SL�޲٘]�����ٱ���m+�rv^�}�%�	�[�"c�/�/uL�]9<�w�b�K���?}�������'Ȁ�/��|,5d��{��hf� D�ORh1�Ru����k��Y��*ԅ�wKa�/gҲ<�K?��R�%�2�a�&�)�Tj�O^�;����j��A�mU�?�g�]�w�8TJ���߻�՛$���[���[�%�Z����oъUH2��.��Y���`\���p*J7�x���]AM|k�b�=,%�'����PRj1-� �l&�,�|��.�*���w�TЧ �����i�Z���1��X����`?:�(I���s�P+���9�Д�v���eD����7k�������1�Ei#�s�6!ऱy{��'u��$C^Q���[��t��C�m_ip���4�4��axB�8��|�%1r-��G7���h����Fy+�<��h�5�����:��bagHX0d�؇�{�L�����5���r�f֜�Pj98���ja5@���ʴ�Z���TK��^�#,6�Z�!��4<Sqz�^���k��k�a��G[5�/��(�����8e�����S1>6ۙm��95�km�����i+�IS�Vr����-��%H��Z�&E���Ӽ)qY�v���F���J��E�_��}S窰���H�C��X�`�h0�v�CT��ƞ)���X+�?�FjA���H���'�;ھ�l͖��+�,m���*��ٷu�G�V��0��Lƿt���`����D=wr15��5ۜ�k�r�y�Sٙ�����w6S���Z״��	5��"ll�b��꬙֕����0|0�<�9M�~l#�!g]޲���c�w8���4�����3�L2V_�!�	�f��"*���,E��b���a@�l���1��	)���_�~X�����}�㴗/�g7~5v�0�Bu:J���P�7��)����	/:���ŅS��Ŧȸz���z�J-P�̱L5��n�mR{�>h�s�f]��e�P�24��p�I��ƥ�R����=�h�
P�D�����#9=���,�`��ݦ�c:!�u�����[��)���dj|T��f�h	�V"�	�)��~\��D���=.�I��\W��eeJ
��;e�������
��a)]�zܵb`��#8M�g\��L�Q�B���o�˩�ւé�`�q�zS
6R.l��tomi�gš���lk]�_�gC@� ���/��H ���i3�����$�yb�T6��B{��m �ό�槆���<����X���������Ƀ$o���+�+��?{�&Xf�M�VRu�Kx���2	Y�@�	w�U��4�������RG�[T4=��mΪ^�\Rv8���X
��[S����B�A�ZH{0���C� �_ӯH��|���mA��9�a��k��ct�����Tih��:SZu.p?�k}�<h>MM�'/ٮ2�b��;uR���3���� -��bL�6H�+jb�mnRH������ڟ��u�S!����J�o)�����N3���Ӱ�:��"1BH�<=��qT�*����?.�	� 6��Q��rs8�qȠZ����?���3H�U�����=N��j���MЊ����2�|PہX�ԋi��vg��O�o@|�l�Km^Ԧ�Uؖ��e���_~���PGtZ�K_�O/�+���R�P=�#5��\L:at�� �~kszYp'�Hy�ҩ^`�H�z5�N��xŖ�칋G/]�Es?��1�.��p��S�M��b߬8rL��`�j�?�;�.<��Pc5��;"�RoU�I�.ZW.Y&������,����g�ṸVӕ]f�D��F�0r!��5�&�Cwc�x2혬�Ţe�6ņ��6���,ݪv�2O�*&�7C���a��~A��'"�w4�� Bxp>��d������V���F�ذ���^عTG�,��u�&}`!#�K�H��y��x%�Y�/t�Fb��w[�-Di�0I1�(��y�f�Z5L�    �`2A=H���p��p�hn�$\V��U�:e�<�p]M�ye�[�k�Ϧ�yI�#乂�<�z�lz�sFO_��`P\,����q�s�%{�6 ��
�F�_z�*9����
A����*s�tWρ��GЮ��7��LO���ZN+���N@&6$�6=�U��t�#��Z�*a �rWO2�z��*z��R*EIo��B���cCJ��C��f�P�q��Y͛�1S$�O�(�w���h��y��n6�H���У�Z?�q?��-�?Z�R�)���(͟���h#Oս�Z���G��2��^=�?1�c�q�VG7�����զ.5'��C=�P�g6�l\����m�`�*�ڟ7g��`+�׬�s��Ј�aU�&Q��_��.�k�vyw����h���*��ޠP�7I$�EJ��'~��03y��Bzv�����Ʃl���]�9T/E�uμ�1ڄ��\�j���s���{���:���.?i�Q#T�0��!�変R E����1y��Xczb�)�XJd��`_�����(@��2���sO�h��p�
��L�=�
�Řh�aC)�Z�O۰.|��:o�?�����?N�C���}8���P������$j\�?X}�[?@}��]"L�l��0��_�sI�-P5�v�:mLp�H�Uu�}x,��?�`�+l
x��/���~��~����(νr�nM5�������=�0�o�tU�u��%Ve{����r�6�"�����fi�`��i :���ٸ7��s�X��B�ia�`��B9u�! ��; ^+ t0��A>�9V��
Sdn�݆0ʩ�~�/��2��5�p~�¤FT���(Qj���R�:;y��@�#��Y��<�7�b��q�^��v�7+R{DzN�<j��e�g�6��<�m�,�!fg$��U���c��!%'���[�:d�����r���AQ�!^{�v,RR���P�2	���[::�J����G����yUfq���P�L��#�2;6N�\�UqL�m������aU4��BN,�1���\��
��e���ooD���Rg���<�^%x�G�mk7�!���糪��뤟5�F!���pXt�Y����e�<�.h������T��|U	}F�xBS��-BnB��F99L�8����y��1'a<T0��/<�^�	��;�AO�%�]6��]8����t�j��k�����l�^���{q�F�.E}�7�Э�RȺ�a�4	�����"��$B��̲$%�	݁7�~�DH���}5^�u�<21��z���Ȱ}|x�u�2�N�ǉ������0I�� O�����`~�Lߪ�j�(v: 3���M�&�n��4�$��pӓ$Q���)O�����rw��,S5��PMt�<o��=�M�f���7��̴O)&�FH|�����0� �D`դ^�G��踛�J}���/��%�d����a�P�n�o䄩T��ei��A����Z����V��e,�-�k{Ls?Z�F��8��gn:��M���_�|oA����a@en?���M��	=��
�Y��Ѡ�#��}j����R�,+P�ps�q4�vK:��C�l�!ڛ��)WXE��)iE��_�po���R���X4�?��B�7�{��_��]#�o/U���E�x�@�֓uH诸t0�.6�h<��Ey��.�g��g,��S�����P��cXG}N~���D�+W�(��,����^����2�����=ᡧT��l��ZMǹ��b��(�i��p3�	��DcF������!2��0��d�"�����A7�=Pg�� ʱ]���&Сg:#���+��?�lDy�������/�2t�,wj�CfZN�.�ɸ���ꞓ0j�0�H�4>}࿝���3�lYH����MN5)8b]q��¡?=��&G)ҵA
%�6�SEܫ�ƃr�s�g@{�\n:�}�6+'�_�����?�Ǵ���P`X��͆tT�--;u�3��0zy�?o��a��h9C9l~�%L2��U�v�X�燗q����遖ϺE��^6IʽF?��؄)����ֲ�e$�����(M���$�V��b~e�������4��u���\b[u���qh@G�@�*k|�l@�bT�z�V�zԂ���J�я�T�FC�JC�X���X���%�:n��bs��`l���j�*gwX��|�@8��i�ec� ��!��F�7.�~�VCu{lV<`u4�>����f�$<�n�/����1O<�"�J�ŀ�r��"�ԵZ�����O��8�=�p��֘��mN��Ԃ�������j����/��I�Eo�e5�n��?�pR���-Z�^��e��xC��\{*nOF+Z�FUpZ��N�qE�dJ�L�xM�^�?o�_�����O&CY�*ѩӉ;��7ҙ;�2��8�p7酋Ĵ��u�<|I�Z�
�L��O�m�i����Ў�G!��G��_>=(a��N+@����~� Xy5�і�)��h�RF;[��->�����1OJ7�0H�R,P̑f6׀��ҟ�J#� ;'
F���<�e�0|�ݓU� ��ڡ��o6��t�}�e��ߪ��bN���j��Z(qD���2����g ��\�|�W�����*P���� GT_�JN�P�㝚��U��j`�s�-0�2ޜřrëq_���r�6�Jڏ/�F�8�TZ!����e�&2��'7ܪ����{R3=�eɏ���4Y�<�qʼaIR�8� �)hAxb�i	���`��*b����Ź���]^h�.̰���L��`�i_�i�8����r�,y�\���J��ި&O+��g��C�L�~#I�[��F�0���លmSQO����d��I����u
���c��R� ѣ`�����%6J�PX6j�l�5���L����`�m���V{���6�(j���<@C���7�g!��>�@��������(?'�h��Lo����(�MOE�W2q� UJM�!������(��<�B���{8.3��\��<��2�a���ULv����4���a	�x�z=�|]V�Euц}�c�L�T��'�*?��܀
}\l�9h���P�l��i!JZ
�b[
(+�}"��b�9�v �,��߱�g3t|IChg6JQK	��6�Gۆ��I�,6�Ɖ��Ij�?f>�`��;�`÷��"�*�W��4K6AXS�`���ŪYKn��G��*������U�!��z�V�جcCa��� s�̈�*=�������G?�)c�-�N�qe8���6�&�LkmД�'n@DoaN&��r�q���6�]@��^��<���Ei�P�ǩ27�^I-P�gZR@�6��e��zR��"H=����v�[���re	��u�i���T՝�,7��9��6�6);H��TguUE۞PW��Ե$?�46�"i
Hy 1JR% �������u���YfI56/�z�@LzҞS��mjߞS��k�r�s��yc����8�����x��.��u�p{>�lcR��|P�θ����o�Q��Q���?m���*Wd6q2q�>�� ~�V�� ��zk13���٤(�����ņSVS�V�^�En;?�p=���BЁRoօ��0ݸm��ܸ���0+��H!���҄������-LvO��7faӚ�<`A��O~��R�/%.MG��oQ�.����6S�ͻ��)�nmӕ"}��]����I�j�MߊTi�K�a�o�ܕ�]m�*le��"�������ֶ��H��h
���ڶ�LU����2��ζe���	>�Oa��5\��n���8n4�� X _n� u���6D������X�_"P���r�2Ug�6t�1�a�"��&HӃl �h�A�'а���y�"U������q���F��ρ���q�EV9_m���鎪ߧz��}'F�0��d�>�>x���U���t���b;9ܾ�����jاT�    n�0 �,�v��ز�[{٣N)Rw)��8a�|1�TKF���'7@����F���{��Z(�����}o(Uqt-��r���/6%�����H:�_�N�|�[z`&�bS+"C��o&e{2�6�a�o~�����1��#w3�B�.e�e);"��@lK}� B{8��(m0��2���?� �.���8#@���s(R���F�_?�ce4~�F
`�}tWo90aPow��m-��RJb�@�H	7 ���9��9`�3�G��v#����[q�A�qjR�A�D�,L��4T{��H\���݉n+I��-��3%2����y���Cyb&n����$h
<���d��qp/���tQY^��NbP���`8�aLŏmC0	\�Ψ��]�&`R�D ����/L^jXı��=�Vrd��J
7���}=�n�h@��D,��@t�0V1Q�3%cC��
�L٠�&	�f^��eA@M/[x'"{SYⰾ�gݙ
�����t�*Kl���p����D��C���mq�ְk憰0ۂ�+�h����p�.7򙶆{� Z��P��nOOe�z	h|��^�\�{�t��1~��u��)]��˸m�Om�۽�2�VԴ�g��8�d�m�{qu�-r]�Z�ŉ,�n`����1��V�\'[A������|z1S�ZGr��	�qO��o�n�d�.���_�4�j�.$�:i�T�X.Ý'���[0���/��0�4<���`cG��6Lk�L؞NR�o�JHY�%��R,�� νY���f^u���Dæ_F}����,s�}R�ւOC�]z�\}��z!bk�~�w�S������*�r`&N؉�^��Y��)cD���y�҂�8�����:���Ľ+� Új���ZbPR�`�VP�o��l�65/%��X����Ä�4�Ec�r�7S�e��>�'ζ ��-�������EQ+�}�AK�s�uRvĶC�`��J��<�'ZHX#��x*:�\]�9�N�!v��6]�J�'�_q����M�<��1~a��~��9 !�U��y��wV�%�H���Z��WB�x�i8����w,`�`@�؊������1{��1�e[5c<I� I$���h�
pT���+S��!i�^�F,O���@���8E�M/1�]��RŜP¨�!��A�4�%�a��+�)�@g�V���������Dz(8�.����n�>�i:���'�2��
Ҟ�&��<��"87�z��F�h�����S��I,=
�LW���N��� �ly��1I����Q�1��i��5"�#feZ#U�kV�>������
�P2�*ܒ4�A�r��L��ib�Q@w��;��(:�j��C��D
���m9q}�m0 Jݫ�v� !�S7�N�(���c����i��<�NLЇ��Ĳ��,)����7	 ��b�b��wq�L�T������ݭj18pz�{��P#�.�mH_��X�4��o�n����!�Ad���oP�a�C�xJ��+C�a�}�'��=}C���-d��l�E����6�Wc�i  hS� K�ϡC� �vj�To��ʫu��V��/���"
$+�Ȓ&�P���3�W�g1-�^��E����T��&K!y�����K�!���@@q�մzNV�Jƨ�4wz�_�'0o���s��A��'�B0S5oK��@�i�������ȋ��HJK��E-�d��tK3b���q��d�P�8�ʷ�����p�V� R+�gE�<�DC\��/@p\��P���1앃��1��q��>����IT�'�s��b<�*��R��7ӞHOW,"�#PWR�� ե��پ.&�>�-Tn;=h���F��#���c ��:�Tm� ;W��0ip_��а(*P^{)uЫ:��.� �M�{�
��U��Z��j��LY����Byցi�RHe�}��t(G����d���<j�ޗ è߸n�0�P�8W�	u:��/�E,������wھ��P�s|�q���4%��<5E�!!D5�&a07��~�y��'���u��L-�y;ѿ ���ҥ�ci�.b ���~�CЎ`��&1ÿ��2�M!�NU, �V8��CD�)���$����d�f� ꋳ)nC���.\e����$��w���H���1m5=mgI���ѩG�d�A����TC��I���\{w���/
eԦ�i�\��2��&Կ�L��N���({��9�˴"L+��Z�Э	���p�!��C�������+�D�o6S���Ǯ����U��
�?2v�y,wپ�RK�b@�w�H��eygYP�Y��.}j�4mn;��U[-GNI]���vx�3�:�\Ԫkv��:Qb�{ ;�{,��uI��?����W�$�q͙ E!*�"�YvH�A���� U[S �5��dx(c��r?��Z��E���-��Ũ�j���xۏ���W(��LR?P�m�P�qz�p�v99�r�Wl�1`����7N��?QKQ�G�ڇ�D�G�M.u h����,����]�,��xh�M*�KDgؼ��%��D��"�y&�iQ�Q5�&�%+��l%�����؜ӣ�|幷U� �����S�9SEg�-NQ����mߣ�-��m����n��(Wi�J����H_$7B�%垁��^�����dFk�%u�i�ɛc����#�*ŞW=
1?�+V��A�_���985�z�d�	�J6
����&5fs�u�>�MJ�@�#�4�rF��W5B�:�'��w���?m'��7����r���F8i��
����1�X�C�
��~~��P������$䧇��
lЀ�<'��n�Ug�+1?��Fq���Z��Ec]Q,/���ziȁ����&�"�k�	.N�AI�7��*t���Ľ<�N�m�ܘJjU���m�³q5\�Gx�!$7��� ���U��a�1��\��I��$-,���;����B� Qg�<�Ll�ӇǤ�!�HK�Z@O?���[�����R������ᆛ3m�����褏5����BH���a��~�Ե�b�ղ���e�����-ס���M+J-�a���*�?ޠW;~�.�'K���ls�S�4;?[H2F4�1����)�2Ͽ��
L��w�m+B��/)�ܥ.��cf��D�~����v�x�H �E��5Q��H{�H�%vx�����#�c��
�(|�m��
�.}���Z��ُ^hm*������D
�B��Nlo��뷖��#�K�5�Np�>~B^�4x��f�x�_
3�O�"���]&Їq��^�M	=ް��دXL>��K���m�i0��q��l;}�u8}��15�t�n�����Rs�UH����8��F�M�}��	+\|��Xt�ِ�?��Z.�Q+�#�|��M�`:�C�~L���@���_��D�C����לLJ�8,��;&/U�*��O,�
�Q�vM���� xH�t�p�����F ��B�ȅ��fc���	#��L	S{�,4Mz����R��:`g`�S�C�Q��D-��;@�0Ym�!�q%*N� V%��1 ]&��F�\ܰ�'
���x'GE�Iܽ+��"�S��Ȋ��z�c��ڥTg9���3���T/��/�яLʨ�(8����Ѷ!��.���3=R/}��v�c+5:p�����]t �Z>��bzrَ���;�f5]ݓ���Ũ�s_^�#K�~_��+�8թL�=�\&{��CC/�j�~6��}5�������c�:�g�Xу��n@w9]m ]4/��{�*<����y��z��������j#�iǁ{j!x�u�]s?���Q�z?.�ֿ������
��/q[�vӞłZ�ц����t���m@-�.�m�V�w-�5&}VzI�V�X祖D�Z�xN/�n<�5܂�,x�o2���~�N���8�8���1Sՠ�j��
<_?���
%�^�o!"��-h������L�٬�R�oP���    3[\D����+��� 6�1g��H.����׃p(W؜&�>K�_��q��6$��X���O�p����fg�bN�"7��,X�x�� wnD��9ڲ����J�"���g?Z1J��|���bÖĦ/�����Yw�L����*0H����u�r&�^R�Y�ue����/"/�<���+�'0��}�6��`�B�L�j@(�����>P0�u(�ӫf���옊Ӏ��
�i��7@q�����"�����F�gz,�C����=���7%� ���͆PĻ�?��Rc�x��~�}��d�e��ͬ9��
�c�"����'�%�n\�Oe�0��j�݊��c���A�*�ۤQ~�"�=��{�v(���EA��fħ�R~j��Dg�`v�8�]�iK(��V
y��4����^ӥ]���w�}�bQ��X���P�>Q� �5-�QA�7�Ȥ^cA�J(P_�����[�T�<����Q	�9�'Pؖ*��^�e��Tu��B��~��m�I!�(�g��l��6^���ڏR�%���ۈ�~(���H��ug���-��qK$�z�~�[F�����Bh��\L�׹��Α�yi�i�{g��!�~�r�lA�XO-�䲞�<~�:Xg�����-�����aal�(�b�j���o�S��h*�nG1�5-D���X�a����v���^�����n�\ֶ�oY�R���Ü��� 7�`�����qi��f����ROX�k{805��M�z$��u@�u�����tw��O�_J�C�~u�?$Ȫ��
��lE(���VF[����v��W�i¤fr�I�N\D(�o(*�(�#�g?�ˬ��YZV5���
mSƮ�Yx ��s��X�/O�9�u�e������	�-VN\� ��G���(��wG'y�=n�V����?��)v��n��w3{�����ap���6�䬟���F*���8ޣ��x�����PÕo����� V����!qr��Ub���q7�7���<���Лi�}��=(Öuo`?��?$��E��F�,�K	��bC�h�|�o�D���;�z#���,=�e;Y��qSkHV��E~	�t�"����zy������.���"F�.=�}�.�\J"�}1���C�1H^21���7�F��Lt��p���I���T����A7�L��a�	�u��1�n��$�-�W�`	�~14��ɷ������8���l�`۞"a�K�lX��#gl8�L�r��SB�p�%o����yf���6����hbV`�(����#�]��q��W�&5��Ґ��ő%�ly��� � ���Ac�����ݕF�$������JJ���X��<\���L\<r��Q�R�x�n	�Scɰ,�r/i�`�!�?~�S��K[ʩ,#�2Ue3�K	�6܁z�T4�"����%�g�&4�����Paacr�&\� )����3	ȴbG��l4[�z���i���.E*���xoޔR�]�7���t���puy�F�u���ٺ�@�ECi2������t\g�{��m2h�.�6�c7-x��"�}�bǯ�`�⤚}-\����������<8=�SضJ����e��q�0�k-���b����X��YE$t�����m��i�Y3��ݘ���=�����N�0���x�cε�b8���Gd1���;�ӅTJ�����>f_6���h#z���4�=v7q�HG4�bU�Uhg��.��@���*����>���UfМ���@�����8��k����6��sX��J�8��U-�� :�V����fpDʛ�
=���=@N��5;��d?�N���C�2��L~�ͽX��Pc9If̬��<�K��rS&"���G�b������bG����j�T�x�n~���R�:2��������J����:V����o����W�G�i��Z��h�I Zc����9T\�
o�^wJF��}��ei�,��]x+��b�t+�.1��r�	�����m��7�C�ꔤ4�.��VH�H�h^������G�C�ms@���Ȕ�i�.���<7���w�2d���@�HҶ��$�����$�*H�o��C�J�x�oP�M�4�.����J@��(�:)Քt�
4<�er�r�X=T~����Qi1��o�	ۚ+-D����Z�dt3^��YI+\5�l�mR��s󀄘�� �fS�[�.��:��n������N�7�)����g��קU
{[��
���:b[2H�^e�8��xŽ��[	��Q\�Z>�ëļ~��QU����*�Ԟ��r�9}NZ���qut	Q��qnh�1��c+�T��C0���'ve\O�M�$G�p��R�Yz'�YW�uƂSU�Q�Ԇ��S&[v���:�7,O�<���Ks�fMx���y �����Ņ��*��\А�J}��!���ܽ�ieȝ;��K�B�ݍBf��7���J#���%�>��µ.n�p3�J-���3@��U(s-4у��j�mǏ����kD����f%xKV5��E�#�FP@��.b�S�e4Q�f="��]�0�K�δ��*E�Nv���Z3����j�u����z���}���VM�E��п�W�2���yA\Pr��%'l	���F����V��&�c��Z'R����ߟE�f���/vr_�����KZ�(�Q�4+�E��P�ɻ�Tɣ���d�A2v���� a��Zf����"��.G�fos�9�����ےKD���z�`�7B�%��T̴��Ѓ�S ?"1~����d*����.�g*'l�3�.�2��ߜ��J9��(��7�������˦!C�LT���q�u���"��t'p@̎��$ ��w�_���V�-P��Z0o3�<C��k���>���iDLFl�~��mn�>��I�j�����~�:��D,6��%j�s���An[� !F"%�g�qm���9���}y��R�U�{Å��/}�,_�umJ�D�j��LiK���l�S��#)Ec�H]�R{�e�V#�!�H����V-��,�.�U	>t�ɩ��H�J����\b��= _�QF�0@h_�V��&pC��?�l��Cbһ��И�C��/^ؐ�� ��v	!���6�'ƐX�����(��q��vzW ��	�L�&��b��j��W3�n <�H�h��0E��R�l2_o�S�rt���1M��˂�@,j���
�{��:R�u�Ұ�lR��@4I�0+�IH��>��b!A�7�	- Cp�0���ν�F8�~�&��>5W��-,���bxl�o���>O���J�ǿ�^�n�T�$��7mtڈ�]k�Q���H��<�&d���{���y9�Z�\;6�}C�boݗO�X�6:1q�P�إh��'�����N�HSV'�G�Gv���:4�Q�NU�˺���iϿ�&���uD�W]��D����S�=SL�����w9{M�.F�����#��V�>�(P��A(
��$�x�?����0���cn�U>*��x17�KTa�[�~�J�lg2�B���a4������en���+�T4�(���B51��F�g<�Z$Qp��D���m<-hq����~���e�<��#v��*�@E#m��� {��V��q�cY{}^�5��ы�̛�:���wÜy+��W�_��fѻ{��s��t@�Pٽ05:���%D.�.v��ƨ��%�#:�J�l7��(��3.Oz�m%2L�F��"��VU"��<;��q���T��>W��q�����`|�C��B�E-o7_��94��ϝTٶ��y�cݷªE�`���٫g�fA��48:�J�����.Y*=��u���&�K{��cٸ�J]t�5L��Y�.�^���\yM�	�)z��d��r'��4��M�O�������Gξ� =�/K(a�Htl��K[)��]���[��,r��6[mz ��U�q 1��	 �]����ăpS���P9���.    q�3y�����r��i!w I��&*'MA�{$pqk��b�2�e�|����3�a�'z�k�X��Hf�J$� �� �KZ>��ۛ��l�Db8M/�W��+��$"䤈�]R�g[��#���_�7B�1PnF�m�a��u���K�����J�L�M7��&RPd�Ww�^t"��ۗ2d���X���VPg��/<�r�������A��F����W�(�2>���"4���6X-XI�B,��*E�WWf��DH�j�Y$�Sґ��2��0�$����1c+�Κ��_�."�i8��A!J'�����
�5b���3&A,�E'&A'�ЁT�6_[����ɥ(o٫�b�dע;
!��r�׈9.N탳d�ubH��]^v����vP�����^1�"�ti��y��唻�w;W����a�D��w�&�L8���1!d�
�G������#�^�f-�(B���j4:�߻G�0�` z)�E��v!��� &A�?`x�X�D3��mA��zr͘�p)+���u�����s ��&�Q 1�ʢ���ep)�12t�SE��żeh��K�6(�W wY�?�m�0Y��.�wq-q��@m_�G�,!$3�	��]]�z�[�ȬȢ�!C�n�0�	��<,p�˿���˟�4\�<׽�|[�:3�L"&'<��f*�磊�wP�d����D�Ha����Q7y]���W`n�Jm<=�Շ�YƬ���FzHD�u��Y0�IDh�Z����W|Z��l�ct���5b
1���ґn*E�{o�	��U���5�[�y*�$F�g�xZ0M����	���k_�V�^��J��)!\��2*LFb��?��g��f2-�d��+��4��7��0���%J�f������>���9B�,�y,<��j����.mhv)����m:�[ـ�Z����t��(��`���2M��`]Jk�TH���^��6�>�K`!ҹ��N�m���!/�W�Η�"#�r=��������}���2����ۄ�f�/��d����C@'Aܿo�%.��B�&��[i=�"#�z'�O�-+dH%�e��J0��{O�� �C���׈*����/P�������a��-�K�cf:���hߑ�S�--m��6�g��<��^�)�������S�ݥ!(P���@���/���
�"����=��@]a��"�&��1I�1k۞ic����;F[j����۝f�~�]���K��Ds�����|�D`�_��,^��4I���²K2�51>�R^)ȣ]����Ờ���AJ��?vja�����Nt��f)20��lպH�>������¼��'Y�����aq�쇀8F������ʧ@��@���(�d+/ 4��*����?(�u��_qi��<��٤��4�%�v�����so5�:xW�>�*lk�TH�bB�TH�����X��?p+��-��

��Ԙ�"�a2�DF^���� �$5���&5ԢƬ�I�h1K#Y";�6�Vp-mj�-(#5�?M
������s�b�"�]bjƷu�Qp��oY���Ԩ�YC�|:�2nS;E�O�o8�3V��T�[vZ���.1�/�G�I���y�&�������7!�*3�^M���G<,�3�G�B��_�P�,B�wq��%7�(ZS
@��X $@�$bi`Ŀ�fP�N{9�|X����Sh[ ����i�`ڝe*��nW'�' %���j��~tg- P$�k�GT��9�!�!N��[�E��Z��q�z��g� ��>Q�uƌ���"��4����5vY*tx��4�e)\�r���I{�]B� x����B�\�%�lF$ؑ:�bx�`ݾ)6��iT���"�^�IhY <L���|��(�`25o��P��.�����_���$�aY���O#CTa;��vOT��D�{�0A�1�DZX�����`WFr��.4S4��6W����7C�)v1
�騣WJ�ޕ��W��q���|'�u��E�t��+@�Q�/<'�Rd�:j'�epMdC��D @��2��� qJ�.��ӷ��9���ba�.���u�g�'j��.��ۅ(ߖ���b���hh��J'�Ww=R�M��K^�&�	[��p�ϙG^�.<h>��jA��r��:��n��������V�2�<���s��\��3t`���l�K��R�$�5;��̧�J�e����vҧ`׃�I?a���J�H�bIҟU�_R��������@j~zk���G^��v�#s�LjPD�~ 
����&��?���¸��&�@yi�v\����9��7d֥�%HfI�tv1�~�po� ��*����H+n ;�����{���jڗ�1$wYz )���(�ǖ�FN�Ib$��9{,�"P)Jw`��ѓ]����ޡ¢�?�]��>S9�+w��~�s�EF���Z:A�{�(��+f+�G�8_�����a����?u\f8������|غ��a�Phണ�۷C���e�c�c��x��ǃ�F&�"�]���|�-E�ч��Ec����%�"�sd8Z�\���op7#���8��s3��k�蘭1�YF�o��:F,�K!�M��;�lx�y!�8��	���\C���$�R��KP~D��?��N/C�d	f����Q��􈂚��3�2HS���<��ps军�Kd �ϲ���-\^�r�}{��U�����w���2sI/�K��T��R�OfO�ƛ�U�̆��&�_��E��p��+(F�9N:�b�O�|�������z����;q&:v�k$�*�LmC��QF%���v0�R���]o/�� �~�R�x�І
����<�6�Ǵ��;�����@R0��Z��f[(��&}m�b�u���1:�c��-ȣ�D��R��/hĄ�R�W�Afz�Xp��YB��R��k d�sH\�?�>�خ���<\L�مH�xE�����xpe��.!pv|�E1�Zv�kP�sJ�C�(�#��Jtm>���T��q6�l
LODx��$�5��^�9��hM�t:�̝���#����G��|�����C���S!=�m�ߩ�%�q9�y��$L1R�SA��{	Ȯ�l�B����A�8ΖT��ż�?^l/��$�8=�+&$?��х��4���.��׎�]�1aV���i/o����W�ֹ^��F����Aۄ/c��S?�&�k Jm�&m�}<K�����=�[S����u�ʾH���]�(B�J�-o������ظp�s��`�6f|��s��ixj��Q2"�
�쀈�[� F��ۗ D
B:��	�~���B�"De���sX}L���aX�����n{�n���{�ͽV,�hC��G��:C׉I)Y�}��#F�0�hI�����1!Zr�ϱ����2�b�	v�˺�0���#��\5r�x�7����6D����G�o���V��J}�D:_�:�4	����9n�K���z��￤�î��1��~����tM�pYf�6���gs[�j��(Z6��A�q�H���V&{ Ĕ�{0��.�~:៏��F�b3�N9��ۥD�=س�h�6�������Ɯ��X."#�Q8������	0�m��=*�L�m~�˩�a��,ApMRE��v�׸��S%���9�R�5��_������.;�Z�֣���<�k��O����C�5��~��.N[3Ͷ��Гw�[�09U*gI�͒�
���,��!�>ޤ��.�s�����ڗ�Ϭ;jC�`A7��e[Ww���N�Q�!27�ZH�uY��TCj�+��v؅�m���.nń^���Z��Z
G�d���F^�����-k�~���"')s ��]S�ޥ]�*�<k\�!3�F�� ���7>km�]�}��v0��qU��fo����#�H�wH��7<S9�/��WPZz擌aQ�[2�Q�+����i��o�d�t�!ex6eC�e���)�w�Ag/�T�m�%g�������aU(���6~��?���4�syl�-'�M�M����p�~    ��'ܓ��=٩��BK�5/r�	\/�X���������L��}��ۄ�-W�X΂}���ǐy����v��n	�\]��VhY��$�©����Fe��.�S��ˊ�%d�d��X����2\��ݩ�1�� ��[X?�K��asW�L����B�r���b��� ���.�C�'����務��2۲�#�����{�Sl�����~�.�3~B����H�����6�O0Nl��Z�M�)����tZ% �m�>�7���Y�	���S}C
U?���hY!���+}8�+��6��ùh�mfg�Z
/6��.43��K 2[��/�Bt���X���`��Ӆ�RhX�bUp9r.A�+�B��(���aA-��:�z1����� ؚ�1!]�� 
�a2Dƈ�'��BA~�ժ��_$���|@l�ٗ����BL~�	0h$� �� �a�I<��=+9Xk�cj���p�BtlW$�>%�<@D��굂֒��g���� {���؉dl��V!�!؝�gT�r�\�c���o1E�����P8o0�ȥi�A��\K~0Ϧ�T�:��/T�U�J�H<�B�`�r�Զ�t@�nKL��^;̙*d�k!��i7� ��)"�:�`W�H#���BA���u���A!i Pd�%U(��ǲ��	�*��ª�k�Zk�c��8`��P��smL U����bx��م�k-0]�{�x��O+�.�;*���r��-�p���A,(+Q|�ej����Km�
M3�v����,��M�Uj�-�׷��Ew =RCž~.mq���q;�Xȕ)��]�R)w*abrj��f��#��Hv��}�T�`�d�Aש�Q�r'4�x���qb@�H�4����2w+�
`�Z9קh������FL�r��$�H� ���y�^n�O:��r��ɴ��zΕ��i����A�Fڼ��=\�:@�U��Lꤾ�q2Nχ�.�*�ܴU�����.�Gd��N�7	0C�Q�Z�bu��%	]��4D�\��)`������	MK`
I�J����B����|bθ�Z�L��O,�x ���̤;O̒/c$���0�ƞ��
��LbҬ�L/���-y+Sa>�_�%>��JiBk��+ B�Y�e�5�"�.(b �e�Y����,03�~�JbWA�T"K�9,貺4��R�HS77M��ЅV�OG�z�0�Ӆ�C���bH{��Rb@�d��2��x���,-(���pN덹�{�h�z��yW+���*�in��p�^(��T(�H��_���gţ��� Yn�E.j��I�c�m�_q(sU&�X���v)�JW(�څ���	������\
�Ѣ����\�q~,�N���?Rl�	�*�}���!�����7g�m<�43���-X���"������e�����f�"��a��Z�����	v-�v��`�9�h=��� /*۬U��0�� 2��Ǆa�-�uD�k�P26*����l��2�eJL�#�jӁb�}+dZXDmkM+�0v#�%&&���1��>��-�܄JRp�,�c�J�E�3��}�i�'��],�_p�,9�*C�4�,��#F��f��<��Y�)2c��@������S���RkC䶰�g�>��0�H��u�P@��h \бoJ�B!���ڏ�j�\�f��0���i�倐R/�;�	��VV�Y�/��0?A1b��?�	��J����h���_ݪ�h�k���$������OH�J3�4����� P��&Dl�Z*��ǔ�W�Ͳ9�̡��dgR�69�͊�&��q(�e%�%uvj"�`���`vr��ee�钖)�;c.�ݽy���?��s��A(-_Cꘀ2�����)shO���9T���͡;����PX˱ϸ)2Θ�Ckb�`BR[d����2pO�^�"������^+�=r�ӛ�{����r���ktX���h�;e�&2��^���t��۝�ÁA��x6^�p�U���%4~=���u���mK��,ʤ���3	c/T.����m��š�v?�u��"�0�A��zzl3�� ��'_�I���(�š��N�e��+K�0O�ԗ�r�_ꈉ���=����R�W�v<s�]4]�˦��� JP]ڐ��o�¶��ц�X92�Rr9�%���kLu�6�M�g�2���r��#���S��"�)�.J2�o�(�91.��pG��8!г&@K��i*=��i�a�%Ӟ�	ъ�^��n��Ώ���mM��]1(��kkw�"�v�*���Q�ț?��'�PN�5mH�B�!�{��c���o���o����ن����1��Iđ #�ΐ/���vPh[rqmy	2��|���8����b5�2���ѺꜺu1:jFU�(�ӻ��d�a���K.�y�F\;��#	�q��Co�Jl�sf�;A=�}!��L#��������`d���K6�	�L NLyd͋�r�
�%
�H��T+��lK��r��c{�[ʍaVEĨ��n�r����$b�Q/3��Fw�	�|��.�賑�Ԯ��P�>ݬ�.|y�LT� q���a�j�v5lG�K<�����kY��qB����s�+��
#y��
���>�m�W;m���p���ب�Oز�r+�q����#�>R��K_ב����K�; @\��1V	7�DC�u��j� �\�mn|��Z�:?�uN.+���G�qD4 t��,�~�3�9�p&�4��z�]�Z��"���`��W�t��y)i�A��A��q<�\YC[�1�Ǽ�/@D��x��{�7\�����XS�f�7ǝ>SL�&"\����}s-�/e��pEb'w(u J���� �������'�A�����zPF�2��(�f!�%�+���N\dՃ�W���^m��s{y����KW_>�1%��f��fr��_�u�o��*۝��-ȀI!]�/7L	�5��6Q��ZĮK�:�.*A���\�
=���#��]D}����*vn|�w�H������߯�M�t���:c��)a��V	�8����"�E	�N�rr��禲�ޠ��5�ˊiF�nTg
x7ax%W�X���t*�\O��Ɓ,'Β@ٶ�.��=�r��~_�TqA*IZ����U��'�L�����
nK��m����\~�����NTKu�D�����ŨO[`��m|�ʴW;��+�G�͠��������pJ`r_4��ޠ�B��]�Ɍ�M��lL.�ʔ�3�b*0��D��_�Z���^����϶�:�Jp��7���\(�.�_�@U������W�F�/)��Jo�]HTgah�	�묩r���H5����� ׎��0�&��W�F�t�I ���)r)*�Y�̀�m-��*�"h3S�Y��=��a��ܱ�_2&�I�o����ǡ�j+��j�i�&�����/.42�b�-pG"�1Z��^�wRUF�#�j�JI��T&#MX�⫲�7�_V�+�Gmާ���\ʃ+ڂg������]
S�0{�[WM��uR�z �F-�m�+��D�n(ӼU�Kqu9�n���J���-T��J���K�5xτ	�~�B��ƪ:����ga�1�*.-���ǃ�޻��8SG9��6�w��L����^�O����,��ux]���L�h�R�Q��.�z�2F1�i��X�;^-�WXd�;J��%l�Y�rC�P!,\��n��M�D>�n�i.�P��W��ZA��%X3�qM���!�M�mt�k����Ũ�Sn;����h�7��IA]!�aM/'("��*Wr8Vw닐�D�Jf��z ��sj���B!F�9�oJ�l�ӿd�Q$��A������@�_�Wmhy��r��nP1[��h!a�h���b`\U���۵nc(5�iJ��[q1�5��u�T\�y3 ��b;�����cz���9Bs�'��B��N�m�'���O�&�;��9o�u�?�����>��xy�[��sa'(�c�7������2/��o:,Pq��˽�m���i��}�/4������H	4��cƎf��    b��2B�ɳ^��_P�ELGZs��HAlF�#����"rӾ�g�T��)S�C�ϡN�t��G߽?Ki�mQ���j�<���$����ϑ����\��_\gY���djX�r!�G�:ۑ���l}�q��D}�d�W�����c���"]�U�~�a=��^�՗ D��#�z,�޿U�c"1���;���u4��өt��[���)G�o�%ӫ��b�������q'��a�U�6Ci�L2��p'lm�o��׀Y�#�N�)t$�;cB4ݽ��Ѿ�!U&�-VM�DI��8 ��%&$��t�p�����T�@��t�A�|��Z�쇜�l�b�V`uZ����N�BB�#����J�S�{ ���r Q˱�90R�_O�l���'UV�;r�5x6��֘�rY'������Oau(r�L`��+�R�uӯe~�4���h}�� �~z5����J�]U�5KZ�ts��f��X:��JqA�������?��pL������p ��+�.RK�����9t~�����ʪ��/�ZLHvp��&d�W��9�rQ����0�9`�M�	9�hPF�[�h����:��P��e�Q�x�����]:| �bP<3�Ȅdf��X; (��#����$Fub�Q$�̖b�`~�/$i�2�Ʌ荽���:�\ �a����k�+�_��6̓���m�M㰆���Q���'xf���y�f�cd �*B�ŝ��~��2Y��C)��;�E�Ma�\l���o(}��Y�m�eU�ȶ2U��V���n�8��3q�Q�,M�?���6��'���4W�"����&���*�/���z	�dEn���+�j��d03x~��5�V����,c]B�r.%���2�����̍�[�\�_x+T;�ʟ���&�����,��t�C�6�+��)����;��X���O'L,�� �qs�Y����|��hd:J8r��՜�<�zF�Jt�/ː>��f�����bR�2+��Q�B�����|�����[5\w�����J�"%�@�9��t�����_�.�V�՜��PQh��f�Vi��'7Y�;i�3
I-�˭�2&��i e���y����R���cn�/#G�x�S���b�"릆��fk{^�^�u���0�e��ma�O,�3�hl2q�� �5Ʈ�&�>��HE�/��mĠ��IM�#��{a��&�!V�������:!��l�M�c���*$�䥮m{���&L%��>�[hƊM��JϽ�4��?���񀭏��H�mV'@��c|/]VT\��N���k+�v.���K{�z�s�%D��Nd������7q��Ĉ�f
����ưQ���	q��w���C%nZȷ�4\���1y�"��8�:���'`�m���#4\	�W��}o^���M��0�@�d�y	�i�m�
�s@�x���h��u���������f���)e
����}��a�ؔrj�����Z�����1O�T�4)�ʌd)E�{Q�u]p(tyU��ˉ���4R�J��F��5.ʐ��w2oMD����V�j����1J��P-�'x����Z�@�T�	��i����L}�C��<��͛: ��X!_�d�/�w�8�H�Xԇ���f�E����BU�ֱ���i==γ>'y_��X׿X��d�E�ͺx���S%v�x㻕+]a�r��߇�ށ��
n-��A.>�=�כ�;|y��㒓տi��՜�b�?��N�#��m��]���0ٰ��j�,U���H�� ��鮓����&m�iN�# eA����	�jd�dVl����F��	�b���WwڞڋokiB!��/�:zg|�܇�}��?�N��i��5��j���#�D�y��׽8/ye6���!����5`�t䜨�ZZ��@^�����w�3�g���>k n|Nt�m�2a�H���	��E��l6`�v}8� ��g�_��";63u�u��6?�cl�Q ��r	�5���'�;О6;�A�}�E"��r6<����,{��6.�r9�}^Ҽa�������,�:��Uڞ� ��G ���]�r5��F�@`[4a�8����AF˷�i&�{����M���V�Y}�4@�3c>���c��I&���ȍQ�
;D�ku�{k�������u��u��
x�|�7RRj3�"j���n'��.��+Z�[���5�K�t������g2�}��},R�3��p��K��m��6�CVͼ�JK����6ׄ��7k)�Q��j��"	���V��Bv������Uʸ q�K=m�\�,��\H��
�[����SV/"�b{μ�"4��̳�a��B1�.n�n�:�}:�H˥�_���,��T.x̲���
d���J�H����CVw��?n��#�k�$d���T��a�j8}��y�!-��x�-��jm�j�c΀I����5��v���y��e�<����bm�(j[ޡ-���N��ۖT&K�-h=�-�D `6����r�b+�A�_�t�w�=a䳑2�Վ3��濨!�aV'���f�֋ô	��u������^gd��=%#	�N����'/�p�VrM`���������2`t���Y#s�Y%�zؔ�"�K����ſk�>Ϫ���h�����T���T^{���2��7��z�":px��b����P�fcspA�{erov�k���t��_��E�~n>�\H�f��5�J1]a�ې�QB�bvJ\���,t۔qc�����Tk� k	�#a�1�F�M����5�ֲ^ۤ3�޾�e�^wv�z�q����z������n[��7ݵ�ۚyhմ�]!�e���i����OYxb�2Cm�'Qye"?o[}*?Fm|��������k��#�������Z ��xgƠ��J+E.q�?�<RH�@�t��eM��GwW�F`e�픛Q���Rv����]�0&%鱣��I���ݪ�O����:\���N�4�o�=�G/@��t��ߎ+.w�����p:.�P�V�!~�;G��!ܤ�96)�]���,u�����i��27ܯU����I��<#w��,i�)�/����wyBf�,�uY�孝��(��4���Ȯfj�!�2��L̬� ���/����
%��L�����}`�#��A�0�r�[�+�L�J1^Z$S��唭<��fWmޝ<�z���C/�.C^�M��Q�a��ds̯������D�2�l����+t\���D���$DWD�whS�RY(vX��j������
s���{|c��.�fe�;�+�@a���Bs�r b��)��.�sH�N���%;8���]�/�#�]
)BZL�!u�A���i'�zf�A�}蔣(AA�z@������ur��@q��+0�rAB��s���Klou�'� [Y	�#j]�9�j]^c[ŗq b $�vۂ���#��j�ty�I�c�r �Ӊ��(]
�}Q|�ٱo���Į�@ߴ�e���7�vP�3����;{���c��^��0�R�V��&����\���!/�B�u��K���ݭ��ut�����/'����78C,m��1��!��&5:0t:�::l9m��:��-)D�ӡ���6a�#����p�cצa J��%�_q��]�6{��fPm�_o]OjiD��a�Sh�̋K͎Q 	a��;�(�;��k�9Kk^�; ��?ݨv1ޗ��0�d� �����������w�G�����-�-^P.5V�Ĥ�q"���TH���ԅޏ��E�u���u�/��iU��&6�����􂞶��ޯw��i�l��h^�:�F� F��^Sl4�6�0�AA�fg�/�q)j4�P��@y)dI���#A��l�� C��ߓь�M������̐`�ˑ�!��H+����n�b�̺�������<�!��0B��^����6P@�D~Z�2�X��\��)��Y�C�ʠ�4���/]�GV?S��zC-����q��%��SQ=�q�/�KL��ЩǼ���ZO�w���le����6�8X�0ۘ���ʘ��j�=�B�    ����8�Y����M�	b�%_煴�#���X���}�r`�Ʉ��,����������=#Z��������P�*3Mlx����f�4��q����!���*qȓ�1�/�Y-L�T{/����ۈ��xQ�A����ב�B��Gc�C�(��=�s	�&=g�;$��E���6���?ƥ�����ÀA�]AV����J:�|C�8�OBVl�r8�b�S��>�������mojr�{���p[N����ɇ���(�<s�X��M,���Z��JgL�CH�cyn-��/p�A[�j7_�3���2�v��$�2+�����wU�TC��m��k�?B	e���iPfξ'-��ș�F5��
֌	'%ݺ�C�//L�����̿P�ۄV�F��rۃ!㔡�P/�m��,r2,s?<-޼�윫�ۣ*0R�%	�G

H)UJ�)�� +���+�K�-�dUCm$2��/b!Y����̛����7H'ei��gj{��ѫ ���ȄP�.�@�o-Љ� �^�5	�j� ��ƥ�n`��j��KSܞ���wO��:&oa�R�di���U��wnۼ�ڿ�\�Q��cP�[�#˥��睱e	2j�*��S����'�.#�D�$����
N��f�ٽ���^?��4�7p���H���V��k�	U\jJf�L���|	߮�D_ڎc�AQy"*�� rt�P8�þ3ծ���4�+Ш֨��#) ������F?�dm�����?> ��YI�#C�j�ߺ�2�Tb�I�,���L�=���,i���Lv�\��-�c�zY戬i��*]!���
9�A���$�i�2�>Y�0��^wV�fd�~e&�,�a�$.��q5�βG�(��lM��q3��W
����O����A}1���]s��l��D$��aNʁ�T����U�X��&B�@�ê�M�� �㦷���C{��ޠ���5gU�[�e� 
Z� ���ǆ�c���>sd�ì9�k�Z	zu_���n�:YRh|�����$��ǹǶ��d\�-K�q�8`�n#6�����{5�զ��V12*�7�)�7�bj�^kR���B�҇5&B'�� Հ��y)�Hy���8M�Ы�����6~ctF����.��J��Fk�K��^mUx�m<z�oodaC�&�:/䘆l�3�)�f�˶gFC�ԗ
�[i�M���޽Փ|%��S����,��(�ubS7�3�������s�R�4(�U�R��[r��T[��"�CE�~�i�K�%?˴��^+�q[s.d�9�5��,�k�L�o ��)d7����A �%r�|m��d�r������n�l���,��wD�2c��3,�:�����-�*WZ�B�������?|ʘͥ �:l_��g�<��je�~���r9#,f�2�c�S��7BJ�Ko�7�N�<^�����*�6-[���}��{XG��86�cut�k�_�U��rίmBJ=��2z�����]ކ�7`���;BR	�Y��Ar�.�v��t]�&������㧦m�n^��>�s߁?�o@�Z���yh��x�E�w��&ȋ�G��6dA��w��C��Ҫ��+ ���>Ww����_(8ZՆP��A��T�)I��O�,�M� ���RU��is![����-��I}F��������J ���Mȫ������}�+���-�.�'8H���܅��z*�~Z��F�`�b]�by�l'�J� %5�Jg��t���:Ì�)���Ŭ�EsE�Wp���!=��Z��Z��������̐�	��)`z����E��̂b�^H�C���Zlnw��a��^�o�cv5�j���Vm?���_�/�%6>��#{AY(���.�c�n��0��>��'�����&e|̫�}�4^T�G����<�](	j���SoD4�.�Շ���zV��<;�_uE���s�ܱ4��y9��p�gH�g�k��}9HF4�e}q'	���_��'�m/绩U>0p�4���}�a
���e�}H ��f{m�c�L����٪��`����KN��=F!�4�¹��?��v�P;M1������`a/�R0ExP�F�C�(@�(Qϋ?ع����c �|М ��!{�vʞ�a��^6p�Ҝ���W(�q�{�)�$V�Y+��9��L��d��;5m~-�0o�J���I�X��8�1�R���,���V����l�,��0���f!MB��X;^���\�$t��ؕc���6�po��Lm_Y;�v�?��q�El�ܞ/�W\�x�,��׳[��S�>F9�!�X���a��e,���޴�o�U�bb���rtCJPv��1��+|gk+(t�B��ґQ�19��
�Y��6�dp����i1)B�W���p<��� �Z� b�;��P��+��d���������<c�`J�Z@1E����q0�&Äp���i��ܛ��`b
�`�*q��)�,��͍ �O��CJ��%��b}�a�z���@���Cg�q�t�t`�,3���r9}.�A	����M�9Hs<��rF�C p������T���_�Қ����m���i��~���{�KU`ʁ����PFv.1'V�4��n�=���B]�U�ӘG���"���2=�O������+j}OaC��*�U�r�(BOz�"��EWǉl9���R��c� XΣ�>�)4Ԕv��Qj�/���˒����Vp�J
Sp4�)��[�/Di+����Ls�}e�aV���i�ߺˌj�Z�8el	��_��r���!$Wvg���2GV����ҤJU�d6Y�WE��
{-j�ݾ�����b�ކ)�-� �%$�;ǩ���&Q:��iE�Vv>Jb6c�7}mT�VϨhu��Ni�/l9���o��n�$��M�<�Jt?SB��+4�ks#���-�K�*$�^��E2\�!��o�iX�<�RT�~b;$`>nf]@���0<ĆeX;�*�/��x���Hw&{3F$��ox7���m��� QqA. _L��-�	���G���<�N�Zy5ooyVbr��t�z�/u��sL���޷�/��K��z��H���؀�`v����P���I��F7��[F,؄�ZP�J�3�#��m�r�%�f�Mt���d~�Ņ��}����nz8,�+��������ԬJ���$�fr ؔ��YH���kHF~`+�L��(^�0�閶+�<����%�}a{�gP6Vʐ��J'��������ȳ��5`��X�0��?�#�5�+�E�S�Xϑ��Y�!��`�С�"��f���h��Ι�)/���.�~9��J��tf�L��-�t3�>0!�o%@��wT�5�K�Δ2�%�<$kE�?� �����򴜘��y�1�dP"���u��Y�:mkP�̇pǘ��ȉ�Mv�Z	0_����M��E�����Q�����o!Ltw(1_r��ͷ��ڠvВ�&w�5Nz���h_�Bzi���%��Bc�#�Hu��mF�6J��H���o��5�a����YV��7��)��.2�Pf��o�J҆��zb���&��xe���?$��+���e�ݪk��:O6���f.�����pf��:NF�)���xs�qX���Y��u�d�a������ڶ�k��}��ry���B�Y�������e.I����z���0%��<>��˰΄nw�о0�e_8�N�u�zȊ9���^�#�V��� {��׆znNvo���	ȼ� �w����L:$ͺ���,��g�w�\�Bu������#��]�P�D_]�������l<ξ�D�{��*`�\:�1�R)�e	9��wu�pd�-a�
��b�f䪹;����a�(5�N�&�,%�Mj�R���d�I����t,	f��D*e{�f!z��g���^	�3��:�ボ��U�V�ms@�H��k
@�+q��^T-BN�:J;ޥ���|8��+N�Km^�j\�:<��@�}�M��pE^ U��'M|@U��tJ�F��    mO�+��ݯg�>�L7\�!�*k~,�vKm��x�VM����6B�+���~9�x�}�j_�-_qV��3���A���pөV�~��^G�C:�-��S��T����0���r��	R�M�I�sl�Lǡu�w�� �j��4Jy����{r�������"�s���,�^П�=�}s��G���ׅ-�[����e��aM��-��;����� �<ʙ��̚��m��*�>���V��*:���te@Ʒ�Y@ �X��X�V�y<Q�B 0*��4)|�3�n*'�od[MW3>��q �k:�9�]�v���eX�#)Ef5�Q��"ϠM�U�Ta5<N_s?�X��]�����b�f�������ۂ-�䔨Agȉkz����5%dwR��r��oZ��:t ��U� ���U�c1(ڇy;������Fer�q^��:R1��EB,�2çd��|�Wb|rn�F��U	��B��+�T(&\�#
H���i9���+B�Vqr��L���Pa����u�/��0p1���+����@�w6�yW��+�Hx#*c�����5aW�%���;�ݸ�V6"���e0�����2��6�W�PN�S���+	aެ��Q1�M���T~H��&DCݔr� *�)�0Y�$�����*�b�9Xt֩R���Zŷ��ӡZt����%ڥt�=��P��׊+!Cla&�����k��<Wu!uKh/=�SE�%�+����N�������I�*�@Sb������?��Px��߅�i9i����?���0��f Ȍ�Ƕ7B�����ݲŘϢ��B`\70�c%X|�2�;�-?6Ȧj.Fx�$N�ۀi�CI>r[��!h�M���0r��񎭈;�>ӡ%�,'�r�1�Av�lB�e��У��
�%�/�:V�Qol=aa����؁����3]��	�Q��A��ΐ����/וQ��N��-���O\g3�\�����\5�Y�4=h�1R
g��c��ʱ6�-v��XCk?��(���m=朅S#,赠k��8]lփ+%���}�r@�ti�<\p)F�hN.�b��3�_�������:�keq��c��_-�N���<�树�w�7���������˷[1`�:p��qs4������'�.�^/���*v�k޿H�1�0Z%q��Ŋ�U��MÈ�5�o����{�ס��!�^���Ҧ���pO �p;/� ����feinle��:ĥ��V��u��H)�.�<L��sQ�8Uf�v��\�0�M��2���Y�ŝ��ރ��*E�����x���B�h��aeUi���Ҿ�ߡu:ؙ�-���������g��!)�}�ʾ���C�d8���H��A#�Ҕ���G��<�@�eD譛���v̉����֐T7�ph���ڄ���qh�Nex��>m��x� �56��l9��{��3�Ə1pM'�jV� O[a��Ė���Y����)s�Ve� �ݢm�gP��t�l�e�*3�5G��޽��o��t���.�P@Z�'h���#���H$�{�o��dd�����U�j�sO�D�pDM���ԥ~.��w/�
����2?�O�{��d�B
K�@�6���ӆV+��P�=�=�{c�P�)���$S��4�L%^��6,9$��E�SH+~�@Xn�W���s�o2Vi���p�v��F�LÍ��:����	8Qn���W��&[�b��6t �I��`�Oz�i�[e���jΡcw]�����b�p�c�c��p>�pNO���GaN��dD��4g������mW�,��\�g�%(E[��s[����Pʮ��LT�}"�T�EԾ޽��s����;��ܠ�a�E��HmW�N��5�����$�pm��B�&b���]J�g�)���e*N���)h�O�Evk8��5z=�\@��}�}�m��U�
���62�2�P�rx2�F�
��)���8J�:��٬��t\�{��/��m
�{ż���dtd��r����
/M=~�o�M�F-�����sxl�`��Epi�E�w+uᯏ��8|�e�L�nb��+o5a$2��:~���)��E�E��s�%��B�p4��p�0c�w���Ʌ���(T�l���������څ��~�Ň7���qVWV	���n�U����T}a�zyH����+�5�؊n<�J�f+K@I�_]%	aq�U=&d��矲W�\�3����ĴU��~���Ka �JD,�/���Y��;�g(���N�����Ra�L�|r�敢lI���E?����]���6_!ӫД�T�i�Zw�:���ۙSwP�������W�E�Z�9_��v�]f*@6����r�Gelx�]�L�{[���XX2�d#.�ۉg3��ݳ1[��þNd��V/�SjB�N��~,��C�Y��k���I��6���/Ǔ�3�H+3�X�5�6\���Gwu�Mц��vb��l m�ͅ��S�����V08�:�l^M��?�PFH9$z��	�%��4��S��h�\�`Lr�]�P,��O��nľ��l���̻�e��L�a.w������2���+ZO���F?��^����T�@t (�Jb^����ݽ�l&4�t��.n9-�������r�#�V়�����ڀ5���ltP������ܬ���t����Oܸ���-���|��F`��#?��ē��}A�%��l��beu�d�.�n������r�}�?�P_��zV��;"�ud�7�*dχ����i��1ͭ�®�"�Q�|�tw�`�r��H=��M֐��T�����@$%��0�dؤ\��)8%���崹��
L�u�T�~ aԃj��� �<�A�@Xk�Els?�V"��Z!�����m�g5mb���X��h:�}�LJ�J�YO�ޙ��A㇛�9 �t��и 1��惥�Ǐ?���!����r�;�.��w�[�����!W�E���ҋ .+�%�������$e��]��2��E��wN��,�����Lk�Ց�ȮÜ]֐4x�� ���	�T��>n�k˵��QϺ\�s@g����ݑ���x���ٷ�K������"�|-?Z1�UB�0��C�e��G	�*4��X��+zp=�Z>j��YԨ�g�L>f�<FU%}�ab�Ժ�y���0ݔ��i�Ԋ)�8>��!=]�q�A��%���ֱK�iOwA��f�?X]P�P8H�����K���0��;7��(��>ξ;��}�m�k��闗\nV���\�O���Ё`?�6�;����j�%��B�e[�P��Y�`�"M�?�F�	������
~~`Z�Z��O� /��2B?K]~
J���vY5�z/'3!T�m =mӦ���!eh����Ӷ1�#w "ӂ���(����XS��=���E����)t����4��lnV�^�R~�GZ2�Vz^����m��<�k�C{[�!�?N˛:�0��z�/J^ϧ_�:��p_;�]2�c�(ب��/;��(CV�J�ݿG7S��ڇ� �������Z�#z�Y��R������rf���F$�b�u�}`=�bɅmk���y`p1��;�wQ���@�vQb��q�Q)��:�}���.���Ҁ̴E�9���
EeDe�&�,;�v����XfT�$�ŭ�B�ܝ�NH2��G8�ǀ����D�|�3�� ���PO�l. ������^�ٹC֑	&�f�L�66�)����-vY��Q&>�㐛�M[�	f�ɖ0��7���g�&yH�N�c��le+�u��PrF(�^=8�J�� � fEB�?U�Ӣ�Y�֛��������A�+����m&��J �ke����sVt3=v\(�����B��{���Y�"���ۺ9 ��B5g\Q���b[ɕ!����(�~zX.�@\���q�Ϭ��@��K�f�\��~Y��E�5��>��D��(�WdM�n��w�*#�f�a
#����OH�8�}6f�G���	�;��x,�{��    ��n>������Tǵ�����u.uU(�2p�B�/�C,���u��g��`j4a/��;�1k�T�����\W���qeN3�s��r}#�IeDFHs螦���ťi]\G�ڴ��x@����r5Z�s�߁�ɁUy����|=��|���lαؐB���bN��L��Ўp�����3�qv���D��Q��{	���`����H}~������d����u&��Tw�؜~�f!Φ�����<M�ચh�_���{J�h����h1mqxk�1����<UN��c��q�%d��.�������Z__�U��T�t�=&��f��e���,��,���`¢�l:� x�����5!�K8�����h	`/v9e"'���T���$��T��Ҹ�ܳ�qj�e}�.z`�J�/p}���t*do��s�����]pV�R�]ʸRYF`��x�u!X&����q�~� ��RJM~9�1!��s�:d�!�G:�g�}���	��]F�*�(/v�
��~̉s�ǁ �/0L 'B���FR�����	���A��|s��~��R6��F^�4�`�\���<�N+Rl$Gf!�dF"� B�6b�,�;Bf�����f!a&0N�w���p��n�S�&#���'��]����B6�8���2�L�YD���6"p�Ӏh�a c|8$:�?/4���2�X�~� �8}O�MIc�]H�ü$�/��V�!#���� �;о�
�D;�A��|��,��z���$m�	��	�C�FH�����7�	FpW�>��n0�(�6�7��a�Q}��jwaG$X�[v1��+��YW>X���W��ƣ������j~�NKJ �v�����b��?'���>��˓Z>��6�bԺ��)��]�t5R��A)/������
�@��q��#|�q�Bv�o".y�]Blo�t{͏W�Y@��K�,�n��:R��b��l\ I:y_C���J
����Q�������О4��煺��akቝ��jW�����IѬDst#o�!���s!#��/�cWrQ@%��yJ�;��t�#p�mݣ-����߮��{v!�)*XM�U��=J�u_x�1WR�2���2��W�o^L���PY596&fEׄ���<U��2|$8w�u�:]&����T���X�����2���r0��i�s�t����%hD��	d�.��=��/���Y�]����l�^�J�un�?���#��f���/�A�=���r�Ӟ[v�?#̊�BN����@P��xa+kc���	�O�fYv���?�F�AHǇ6g�3�L�||��ڒT�>�e�����ɐ�8��A-��ط��Ml�"Bv�Fi��G5��{�ټ�I0MM3�^��aS!%�0U��w"x�%y-�u��2�:�oՂU�oW�/g�@�W<��Q-8D'v!�O��qW��lh�5����æ���e��Qpk�{v|��:�<%0��M���	��qw���R�>ؾ	���iRe�LͬL{RbB������"��^*R��<;C���ixUA���T�0U��Y�	��$��"�WQt�0t�U�	IM6�@M4P ���_�oJ�Z��7��f7�U�+�r˔y��o�̣�p����x^ְGej�%f�eʹUag^V�V�e�O$Z-Sn�j���$�Sfi�?h/3��������=>�����0]S�ӶAb*}z	����pi p\�.����bRL�>�%�2
��O�J�;Ln��w��!:�D�1V��,m\f��R����e�)��>��4o|�W�z
8��`�0�
�P��D��iw^aw3�Yx_F׉L��ϗK,2P�_7�afʤ9��龜��
r�_tBXm#0�'��Q` �D��K��N�ej���o�ʨ���ݬ��u+d$uO��EHc�V�� e�s~�u+��:�NN\�ͣ����h���������5�C*�.�
	V�	�
���9�}+i�1����Y"��d�KH40�Y�6p�~:W̋h3MyT:t3�)�$�@�F�ra#�0�DQ!P�^Tx��=Of��"��I�SV"yP��i]"����i�_)xA�ʼ�0.��F˲��a����!��8%�?���"�gאw��h���11e�Ì��l�i�ʈH�UT�>�ЎΣ5��^��a�>�0�"�p�D.:�2;p�kX����!w1�{ �km�����*a{ߖo��͹F+��;�\�e���}��N��1��$�U�z�ˊ|��94���ۿv�V��m��9\�H"?'��:	��LnN7���d_�@����@�A��*~6Ӧ�����\�	�:�kuly���2����e���3ҳ��1�iκ.���wG����ĕW��(XBg;J���#Ŝ�3�����ծ����E�.���s�D�h����<�Cb<�K-��fvQ�iXf��4��%�o
]��;���"�u��y���"@�^'s���#)v+=�0�7���c��f����Ǖ�hcDi����Ͷ���T8:���U&���h9�R��+12�0���>��M���H�U�mu�3�J@m������c���X7�w[�O*Ɓ)�u�x |Aa9W4�k����T)%����u� �m�C��6l%���k�����΋�~z�^��i^�*���U�4��w؆Dާ��+a˼,+�*_6�����~W庶�ӝ.[���䊁󷔎ɘ��g�v.�*���j���z�����:p�7t?(O���c�U1P��wf�Nj1ї�tlĮD����R��_���!�\$`X�%�]��K{���L(r[},oE���ɘ7F�'�"��-\*H^�����o�+q��|�N2cm+@U��j��S��+G���z0A�E�G�伉�-���U/d�tz��#=��=�*���6އ9p"�5j����t:��D0�I�ٱ�i�Fg��YϋkN��ª@H�������u�͘S��\?���jG�7�c�fv��mρ��}1VM�q2�`��+}Ĝ�Y@.I�g��ybR
�W�.D>_.(p׊�����'��(��P�����c�-�_�����ѽy�uh�2�V�Wlc$�u�=!"��N4�?�:ź�&͋s�/�/a�D����Zq����:H`@C�����+�(�s���"��]L�o����M3��y@>�����cס�"Э�d ����}:t�L���Չ��eWd��� ��7��U�'W��a"�)'�1�S�,���Ś+�F�g�Q�,z�y�Y�q4�W(s�k��T�H*�l�S/Pc�U�{��$�����#	�p�{�.�LW���*���,XWvu�D�P��NЭhl!J����"Ě�u����j�ZM���hJ��lC���X�$��9�	�t�eƎ4ЅoB���s1o�v������Y��BY�"[��dei��PjA��c��u18��6��e�>�0�AlV����g�42�3�{Yu�"��D�O��Ybl���>t��6�m�ҫ�&�U*c���B��uQ"�qB� 
�"�#�Ӕ	�����I����C�ն��;K㰡�-ꈮM�]��|�3PF(����^��8���#���_.���>����r��)��u
.)\��J���`�+d%u��Z��M�Ǟ�v=�H��>�鎤΋Z�3���S}.\�}���A�K	G6�4��1��OP���1�I	ЬED7���[�E�W�/�bM��iŹs�O��zo���͈���q� �� ?W������\(�5�,������n k��}o�K�ҁ�._���	�ŭ��a���*�"�l?�0�0���wq�l��n�� L�-�]�����fC�~O����I�߯�+:i�>=�Q҆O�j[q�=���lގ��W8|"��}U2�����8>|��H���q�����u[��jxr���Cv��'��5���(J�Hh�z�5��Ѩ�lӿ�y�:�!�0�=R�)�p@I�@�e=������B�b�H���d��5nJU	ތH���Q)�Ҳ    uS�+�9sO��cI�9�ΐ{�Tخ�Xe>���Zƛ��R܂�c�)B
LHyRbB�T}��p���2�'�bӸ�*��ѹr ?��`����ڵc�X��<��r��ryaqKSx�Z��R�����%kv���Pp5��3�<`�(s�� ��l��1�6[6����V�79@ue��"���Q��a�� ՕUئ��������6�����zg�Z�P�f{;@ve-���h;�S�ij�S򼖕�Î� Еu�v �2j�xA��K-�m���<f�J�\�3�@W~�0!G�犯dk.�<@t�9xЍ�GD�xk��<`r�9��J:��U�*a�F���K�lD'Y���5H����*3��W��B�P�Ky ��s��u(�[g =`�~V�p o1MhZ`�UK�5�#�U}��g]I}��,0_����TKL��T�[���f�&c��=98�*Ƿ�J�����hP�E-�98W̷6��+L�C$�`�p�m!��Y�,��� 5��`�u��fA!����7����esl5�O���2+R-,����D��X�
�ڃ���ӬI�a�Ԥ>�1MR�-Z��P̯iY�+t�{�{غ#��^[�J�#2��]j���
2�Gj�vQt����E�	��u��@lɹ.5���.u��t��J"̨GuN�����95�!:L��T��8���2f=��Z���<9���)�9����9��z�T���~��>�}��ܪsj�-�*!�9M�4"��:Ըx��y�ZTv�N�.�*K��Mç������H��u(�q�֯����
I��mмt�	��������`��ƹ�p_��A�h����k�Ѕl�y?]|Y�&��ME���C�=΄��u�{��6ݻ~�gN`��=b�XW�R��J5T2^sz��ݽ%�fR	��ǜX^cy��1��W��W�#�z���_(Ab,���┨�~^2��!��~6�����0�U)7�_�[6�6dZ	5��"I�4�2n�Pۜ�$	�����8&B�.�k'ͫ8�s!0PF�	R�﹒͙Wqr�1�=��Q��Q�c{�����-9��آ�⻾��_��e�Sٲ�,�����	���̚�P'bb��4��@�kq����l9T�vľ��b�n���Aq	t֐w(�qۏ��+����m�ҳ~m��P;#L�~�=��������s�����A~��xU�`XZ�į~�����=����]����s��-j�D�D�a���9�b��[�ˢH��-m��e���EK�V';�oT�]~����\���F��kE�v���qU�.Ԉt'�&c	~�iP�(�}���?:[�vQ�00	m
;�H`��۬vT2P־����I��x�����g�Ҹ���8�q��P%�����ב�=�B�Ͷg��&��6>Xp-��5w�w��łCX�:��y��	�@s��7�G�l�c)�'BhA�����8*Mx�'P��/5�2kF�nL-��.���S	|�Ls.�0��U<fA��Z��e��W2�c:��~o�D��,)��x��%X�e
.���H/C�����Y���n��(��< ���IW����#T2���qp��+s]��Uο����^~9"KKp}�ʹ��,[�F���}���������=�6��V[�)7}^��ާ�C���R�
��F7>��+��Vv��bj�KL��;�n�8���d��ն�cx�!�sʸDG��}HV�:�Dһ�1�z}�1����t��}�lI��3_X���Fsf&݄l�ۺ�B��d7/����<���c��Ć	e����F˷(�'f��.|ko�Q�����ٽ�mش�� �h�Ĩ�9��_�h[��<k�̤[%�݄�ot�s�<�yCcj��?�	th�D��vtK\s�w�.�#Q�e��B�1� �g+M!A+�-�,E6$d؝I�X��
����-�L�I����7��GW��a)��݃a��1�|���r�,lÙ���QG����ߑO´����x(�*
�w���Y��kf$�=�3�HM���M�ȉP9�p�y���å�%���'ʢ��4�k*b���!���؛T��d��n��,�Fƪj��.� ����D?G��� (�t�R+�4v��0�!��`� � ���7å�0T��a�ɒKa$g�)��T�(c�FyP�G�J�w۱r�����,$��9� �b�� �mi��qђھInZ����JY�����4ؼ�"��S��`4�E ��`X2��+��>^�[�N�a6��r	��L�9�	\'�U<��1�"U�W�v·��g`9���BBϢ��z��h%WB��R�v���ݲ^z�u��ǳ6 �W)7:�5���F��9���<D��}C��f~��{����4�R����W;�}�I�P�E��4`0p\����е��\���i��ɔ��r�/�dZG�B��T!ؓR�U��e$*��{����4������^P`Qc�OSZ����2SC@�Վ�m����*���?�&��_!��1}�zs�H��E�MP�@C��ݖ�ǧ��
�}䒇��eP��@���:����2��=fM����1�ȵ�����#G�J�y��kM�P1���:���An�2,B� i�$���rȍ�'Qq�c�F�C�i���>� ũ:��=�2��4+.|J��=Xգ���Cw�A�+.|l��D�m�YV�1$��[f��$�	9N&'6!��,G�(G�43�N�0{D��X�K��Qe�i������X��� �7�������e��R3�;�d�AH�X�QC���P�'o.\���q�d}Rw���Un8e�V��s�Ǵ�A��=���ӷT
��U��gD�'�SCd0Q�<O�B 0�ʾDf9Y���� 6�I8U�QQÜ���m�����hR̖d��e�TF��H��֟m��%�dL�k��纪,�R��Y{���o�;:H��	I�&��ySXV�������9A���A���>))��"R��|����Ix�D�JK�^�L��:��?L�8U��kKs��-S,\	/OXP�QG�hR ��GA;�P��I+/�|����F�LSp1�a1zgS�QD������.~�{mlg�-=�3�XUY��"٭��M��w5F�R�E�U�Jm��|���Z�x/�ؗ�KV�%�ӳs&9{]>o�_�<�zΎhlL�D���>15���s�E����L2�jݭ�N�`c]*��,�2I�LhU �q�4�|��7/X�u�F'Y���+<����,M���>������#������ܷ���?�a��FI%;B�bm�_�-��J|ܦ��3Q��ɢy�w}�숪У*���p��W
DЍ�Z`�E�v��a�܊*ץ��%�?U�W�[G	�Rf�C�H��t��P��럄N���e��v��]�w^�ä
բ�ӣ�Ag�B�^{���pa:��7���3j�Y�{�����~{�i�{U&/�G�-NJ�s�7��E����l
�⸮�l��s�1����O]�X�#/�{�:�H���f��U�����U+���*��Z�7����v&�٫2eO��C
h
A�=r4�����k?v�'�٩�b	���,#����4��۩�����=~�[~�T7�Ø�j��jV7>��� ���烤8����y�Y�,�X�E����Y�N���Ͽ��4����=7�\���[��Ѯ��� �t���k)�����+M]�����qdJ4a|=����I�_�1���Fܞ6a�7a�� �E��f�h���r�G�ƻ���t�K����K��T,#Z'ǁՂ�U��TG)ub:ڈy5���HQ+�цF�f��4HW��9F̠)R�w��g�$�ٯm��:͖�N�W�W+D[� 1��u���$h��m�R�$D��m[���&����ޕ��c�m#��
����11D���Z �֞�~�:CdQs�js�K��R������:�w�z|+�J��C�l�I�Z�OB�������&��p�%�*m�[�M�{7������դ��fH!�%�Q�3q�Hh    �m/b(׌���H���2��d1j2��2(�g�~iE��eeX��	~����&iP�9s����C��w�>L�_����	�&=k.(=x��k���ذ�M&�͹��Gv�%��C��\Wy���"��0j���,���\[�䥁�SnC$�kawVhTKi̘�O��(V�eӢ�	n�z1&%����\��9WY�Sh�I]���)95����B��l�h�7�+-o��o�>���ݲ>nn�E�͎��u��}��*�Y�&-+�'��;�2]W��رTJ���ģƆk,ߓ�؉jqe�$1��h��]i�g\LG�������^�~Vp�69�DQ���ґ��LÎo xC�5�X���}�ɴ�0����;��ߧ�4��9}��g����������C�d�����vy�eV�z�i��������2��_�]mm����:O6sToc�ڸ9��6g̢4���E�t5\� �y����Ŗ`p#x�Fː {r�û�4�AjF�V��i��6t!�!�JeJ����%�Rg��=Շ��k)v8�q4���S���Q ��4��[w��]�i�l��|��[�&`�[�@������9����C/�ܜ#�l�j(tSն��iV�ܣE�Y���$��&��-Â�_b�[�8�	V�j�׉�+L��#qY'٨E�P�Fؚ�([�GR��!d�YP�I�  ���4)�o:��{�m_���k���סIj=�]�sd�$���k��F?�%��0ʖ`I�&U�z}fL��M��/�\1���e�F���%j���>ɀ8�m�s�ʰŝ:Y�nf����X>v(��i�<�M���ޟO��{{�/�%[��3��7i�����0,��i��.S�{��'�Rt.�g@����H����_vΠC�l|09�ۺil��!�'��s��3��l8�)�����2"Nv�=��R�i�!�l务�f�/�#�L@�|�>�/�S�<X`BI����c˕��J�Y4j�ї6�F���=���J6���f���2~����#p�i�10Π�&��a���H�����pi�6N<Yw�sF�<)8ϙ����&���ӥ#�@�2�-~*�1hA��sJ�E�4�a�"��Ƨ)���� `��@��^-�6F���[on��ui�|�X\Ŵ���/F?����(m'�zu�/��[��/S�'}�PW���f��}�%��dB]������v��Z�Hc]�n�ҳ`I��V�����r�J%|�����K�ˠ��G'���!*y��'�(��X���#��u��:2�����]����R�-gRI+�^����e�mU���D��)[zc���q���Ό
m��Zu춬ϕiG��w��B�>�渞Դ��;�Xp���>*o��孵C�2k��=�:҄Lm�4>��Q뢱� ����s,5�eaZ�z
!�Y,k}�3��q�/��=����h����a���}c(���7��6�[p�-
���䃨�4Z�`��Y�L#x��}M��sD��/%v��`S醘3��d4�5�����LX�O��s���R0?�^�s}~H�1����~��1��[�wY��v��o]xj��P�e�i\u��@y�Nk!(�������K���q'A*-��t`g�ױ�����PZ-��,�lB��oY^ۄ왡��&c��V$6AS	�s6�=^�������թ���T��O����[�z�^��v��&m�eH��t=l��`ʍ��>.�9�+��O?,$�Q�
��q1>��Q*�z2�)q*6��=ݹr����e����6}��i�2�zޏ7�_(�ƕ�ꔐ&��|�!�>��^��@lk[�������Ĝ��I�re{M���k_��2�ҋ�~�+���ŌB���mG�Ÿ7w[,������(�����{�r���sSׯ�9�ɂ���υ7�]^弱�� �B.�}���j�l�s~Vw�~�}�\�v�CX��#���Q�&#��p�[��뗿?m?/4��.�FRHjƋة)��<�'C�"���u�ۆ�HE�)XF�{�N�{�%5��U`�SRT&KV�Q�����%��z2��]aO&��k?���6���*<*��!�#�ͫ��_���v��	��6aA����(G�$a�2ݦ2�K7�L�I��vzv����t���/.Ң�(�nଇw�oLo/W�P8�(u0�P�)/Sn��f�"�Z��xw1�W���~ԅ����f�,\n��o`
�k)4/���@���D�^s�L��ِb�2�Q�����~@�����4_�|��H�b[���v�����;��l�i��Y?M��R�;1C����x�֕�n��!]�i���Z� n�۴\P��Bc|�ݤu�[E�	0W,({b������k:�r[�NG�sa}_M����N�Q�$`�=Q��&o"��O:)P���ge�>ǖ�߿5|���$���ڞ�&"�R��dQ�F]�纭{���c����&�YH���E���hS�(���)=����H�ڪp����U.4�Տ/���V{�?m��U�%�G��^zp�Z\Os��F��M�ڡ�v&�p�,�ã��4-�'^D�h�74Q��&9����eW<�*�N�]�Y/�a�A?��3�N�2�zN�7�>i����f}.�9f��rw���vﰯ�͑�z�ڕ�'ĭ�%h_p�ds@��]N_7)�u��J�E��y2�s�ii]Jz��:7�&FM�l�B�9���`���
��¦�Y}����g�m��\[gj�HR����hU�@�~��	�ңM���G2W I��R�ն!�4�5�L�B�L�='Y���k��L�j"Lm$��Gd�1�/'���ƶQ�]d.��m8�-F�om�_���9ۖ��n�4m)W>���K��4@��(�����\���X���S*C����ǲ����\���R<��[N3�0.}M/e�F��5�Ҩz:��}���M��4)��� �	ޠ���֔���_��Y�\� .w�<˨EI|\��Z1�W����V���r������&F��5	 e�ƛ���(xʃW�p���.k�겆'ВpM�����xa]n���g�c3&̥�qk�#)d���o�sfܮ��l�W^pi��ӥ�,t���9=wAf�}=�K��/�����pw�#�׶�}<h��� ����:S�� �S$R���.~tPN��30�t }AFR� �a��j�i�F����ߞ���ړp�Ƃ�:�֢���V�XO������Y7��7�{}:R�~�rz�[����F��6��&\�08�i�������u�F<O��+n"4�������&�dX����/����j�����b��UZj��wX؁p02��U+o�?���*��?t&�@���q����1���6K<_�fjWa ��������M���7�9̰��{��7����[7��&G���2t1X0�r.��j��#�EmY4[L�J!�v H�ϡ3�-=���A��j�:�1����	��h����<� �Y�D��~"ImKُ�$���/=��R�J�3=ij�vHs�TXz�OKsS�lz�OKm#]�a>--l�9̧��i�.=�)�,,$�9�ӆ<��E�D=b��5�z	�}L�!FHMB\�z2_-m/�KԛOME��XXD�-�c��l�5�4�S��>M�4U�{�f�,_'��u������vJ4g�%Ӵ�b���e}%
r��"���LU���ζ�~�  =hb��Q�?��-�L;n5:�b&Y۬����bIؤ��r�~��v���MC&*d���O�xY�<d�n1"RR(k�r�M:�iբz���+�͗�(��K�iM\E����w���O�OE9G�s�6@|�bDG�kh���5�4Bz����D&�2�碬�_��T�k�Ļ�c'������O��f�#�諀>ޝͲpU�:�=�n!l��N���*��eZ���"�vW�b�/�h��VnS�"4�
^�)�M��� �����;�=�p�ez>�~%���    � �fkT�q*z��ť5ߥ)a2,�jnY%\ZB�������j�=i�#��nU�r�������j�N��G����M�Ot�]�X�t��EZa²&��
˸����ϔ�íR�b�nDV���"����1������7����'�,c��~�*Xa���܅���yЌ�b�UJ8�c��
\Ǽ�/��Io�W���g���cQ<QMɣAu@[�!�%�k�i�x�\繷�E���k�#4��p�Lڜ��4�^�02@@�}ľm-]a�/܅����"�`����k�~a]n"��e���_��8��և�������q,����`�-�7ÔB�6\�g�i*ʵ�vk����a:B�US.y�2��K2�6��Q�gԻtBEXOЏ%����0˰Yl���c�o��>7U�`�����5~����g
�Gv�lz��$;op_êPϘe��[/X���";o�ׅ�`��qmk��IU�o�qaK��Z(j�2�l=�_�_��);o�[7vSfgI=]�/�+X�O˒��)��dgG�Kc�k��0�	4O �A����L�h���\��S�֨1���Éi�8���׷�9)�""Hq��/��نo�4��٦г0�-Aly7��!�>?�g �G�����u�ϱB����B,���%(��Bh�<���q�]K,(��7L�4W��^�5�&г�֓��jz=��˻G�����u>buOp'��E��E�2��w�.�I��k�.�m�����b ���Ս�F�:��?��������0Ӊ��z���0z��N���bķ|�t�q�����O~$0h������}���Ep�F�\�'8��h�Ǚ|Pa�v��DWr:��p���d��ڍ갣���Ε(~�#z�����w���e:�"ل�״/���Wd����*m�iYb��+�)/�l�jM�dQ���M;��--�H"O�DT�:����E�Q�

��E���V-Q�e��aF�"t�ZpL[.�>�P��}�'-$ѳ�7�⨵����Rӓ_SD�����}���*$�b&�����$_���r���,1������n��R����־;���F�L����v���TS��4�"�j��B��a2r\���װ��+	Su��Ur���[*ZqG��ah�)��`/H���R�✪9Ƀ���m/-s�i�5Sy�7y��r&���� uܝ�(��*ӿ�}�J�Ep�S�8�5�>OL��~�Vjô�.b��~,��a`�_���V��s��{m����~d�������u�C;��oވ��A� <��;�f���zwM>9��(���I�[�&�+�d��k)���[7�)����OY	(��מ��=�b�SLݚ@������F����#���%F��5
|�]ז��1XAG(Z��2l&����ؙ���a��2L'ǎ�ԨP5���&(��,n�I�����l�����p�1A:�K�H���%��WI�Ң��B�Q�y|��PHP� �C�//䴋��$��t�;�aÁ���ZKbҡ�%a+J�Vy�
��g���.l�J��փ|H�������ɤ��X0eJ�9oC7�����%e�7Y� n���cO�Z���H���G����M�]�^]�	��/;�B+
V:���:N��7C;����:�������.TJ(M/����*j�g��բ ��ݻ��mDH��yy�z��߅��;��጑�Wﴒ�6�6�o�sO��\�T��*���GRJ����]�AM	���T8�me��̖����̦��vӢ���H(!M�Q�r�ߤ���ǭ��M�S`!�Ւ	Ñ`_�R�S�m�2���T��9�YXY��sBEPWM��A"&����9D:�]z��T��jN
v�*�X�sǰ��<PH���Y���´��ñ����V�A�6l�
���u��Ft���	�q��_��I��0�8����k,��sƇr�wi�K�>�\Z�$��J�.�v4�-���1y � @�3�9��(����\�ߔs:E#�������C�?k��b���ڡ������b1X{u���G�.�w�����y��͏
�^L�)tC
�����Ҫ��y�A>�؏7�
N���r��r��'��}7��4}�:���݋swxv/$+Ȁ��WG#��KV�C����C�g���ӧ����ᒶ����Ԟ���I~7�#�S&!����Lk���ګ�
���Ѩ�����љ�}�H���I��(}�(�L�X��.N�����s���Ԏ��L�6ٴd����і̙ HJ�	���-�r���W��`�*&�lw/���>;�i:`���BЯ�i������Í�S�t�^�A\,R�A��+	b�t:W9�O�%�ffv�����>��
�Z�qt��L��=�%�ZB����+xg%�t!"���P%�o3�6�L�`L�֢xT[,�b&������ڗ��{�|P�2)��7:�(QQ"\
x�3�
��5��t��Zhp�"�[�w� �����gQ�|^k�^T�[(t�ǧ?5�Bql�uO�ѧ���vc@�:����C��?�W"������+��WTz�s������ �>�c��6�@p�-��bRCH3;*�f�h��'�[�����#�E�M�/�L�ҵ�0��5�]�������!�������{���ږYyDH�kC�ө�K�\���{���N�hŃ���� ���iX��f
~V.V�T�>e+(��$��o��\gۉ�!@D���6��4Q����?ܸL� ��T���L@��2����ه��%��N�/�YE/�Ǆ-*i��9䘾 )8K����;s��l9�*`����o
 	*H�#u�9�d�+��=)���\3�齃脿
'Y	C#�PP@�,qL~d��\�zN�h2����/`�����wJ9��������v�RjI*v0�x��Xs�U`^����isd�h��n!��(�T)C�BE��.�{{����~�o��"5(�ג���#V) -��@��i����"�ُ�\��`8@�.���H�#�E�0�����?��R^Mגk[T�jgy�x\ں��n���[i"KF������i㈅�U�eڱQ�"W  dI4>u	>�Dux��`?`���]��+�Q��R�w��t �9��4�/�]X.M��ޛ�}������=�E~�n��R���L#�s ���!�@�J^��
��`�by�7S2��Yj�kW|C��־vhL���H~�M�3��_�I�	j���L�ăȥ���,��p��-�R��@�L�X�:�~���a�'�0'�R�w$����M'��|kC�Ce����OKtV��<d�hU<�cI�����j�!R�b�͟� ���B)�i��4�]E��qݪ����ٍߩ��~<�1I	jz_��L	���p�=U�!��&�?R�����U�B�����-��
x�2-�r��t�^ݵ�2�<YPR�´ܓ,TW�E��@�X\�P'�
�������Y�0r��R�FD��2Wp�}/�͵�z���(Lĭ�� W� �J��&}͵����}�,a`�+���l�F��9�q�@)��-��`R�B����j������Co�v�\�b�q�D��=���9q������T��a9�9�5{�i��� �g\���eŊ!%���$)�b����ȶL6�r�Q}T�J�]����7��~:�iA:�y����ZoSJe~�olg1*e��u��d2���R���
,��wQ�3��¨���N\^���h���������J]�}������
3����/�ҙ�A�6Ţ(�����4-�5�X�nU��bv�*�����Zڭh���;g����a��?��\Q���B�5�\�z��VnA��Zg�{t0�KsKVB�=Sz�kX+a����P�������BJ8ߧ�ty��a"/:l5V+�g��.�ɔ���#@1+�զ�\�
T����p9��\='S��I�%P|r_�`�y���Z�th?����Z	��lQx!\�1��r$ͦ�ަ�    r�8��\�O�"�|�w��nޛ#zx�C�l,�� ݸAǁ��Λ�.�=}�eH
�>WJ��:�^T\p
��R�s_sBwF
�#���{��:��נ��p'��`���V�2�x��e>��"����)̋������lu���{�����<�)���7�P)*?���rR�TM#8ͳ}��%�����v#C��Q&9�	_%��·Q�2W�� �����#���6�%	6�NAi�7i݆���u?�E^ϫ1����|��uK�-��-��y�^#����C�^��v����E�*´�L��R��1қ*2M0�� Z��l�+�a
�J(�*���8�XC���^G��>��bۈ����	j���B��n1\�J('TЃP��Cu��,���S�kԜp�+B��NY[:W�T�2�0Hb�M��n�K��p��I7���񀛓Ҫw���V�n�p�t����k�j#,Eu7�VZ�ˡ�[ng���\� w����BJ��õS�g�9V&؇d�^�O�4@U�@]�K�7�������)���]��ϛ������>����J[	 )��yy�K�_��$Fs�w7�B�0.$���ӹ0c^zD�o�NTӖxs�$���P��KF�qA��&��D�m;{���AB��HDlC�Dg���7}o�Jpaµh�q�ط��̸���8r�!qb�|�Me$bd�e�� J�%�W*�;�4�j����/Uz�����ZA�޺v����pwo�P��zQÇ�@)��D�TU�\����{�`O*�!����-yOӝ��FA������e"ܝ4���]���d���A}	{}���ɩC���ބ��a fHJ�(�&,����x���?֝;_v넲�m��c��5g[��Ԃ�-����W^�����:�����3�#��v��k�J�'����k�r�KS@������{�hϻ_J(��D O7�A��%�uk�A�vD�gq�{�n� 6�8"y���vDLPR��?����];ؠ��r���ٝ��& h��/a"9��s���&?(��A���C�jA	2�Jc�:��s�y^�Y\\[��j��ӵ��3H�H���&D$���p����;���$��� BJ�����΍D�N�mb| �e��%恢\�~8G��_�M��j]��RR�����03��"R��Lų{ R4�T�U�2��O�u` �N��Fn��  �����z�pR@���#�a%ڭ����b���V~O-ΟҺ�	��|g��bHߦ����ҟlS��cbyJ�#$A�i��~@i8����)����Y� �����8��Oۆ����0e�g�A�E�>l���iǖH�N�qm;�>�c�@KcXD�ƙ\3�R1���Uo��Ԍy%H�9��A8�2��rT�D%0��|��4��9���ځM�dR�6��$HT;^��L�A��J��0�zլ0��t�@� "�Zw �1�P���Hg��d�9i��J(��H�)~�ݸ$&�����S&�2Bw�U��l2�\�+˨Ϛ�����2ȴ�nO�Ն�A��<��C(	�?�y����%~�l��%=��[wR�̀%�7H�UJl�7��g�6�M�zVR�A����!Me�_��4C^;��0��l/�E5v���F�B��e�h�W#��lt�)r�d�$ӵ��Zz�+�h����+Q&������k����*��A��ﮂ\b������9��T�D�b|�Q���Ƴ��OҜ�s,��!ڰ@���48yҠR�wn��\����Z����4��@���"	� ��*�4��D�!��zI���{��Ĺ�-��Xhz�6l�!Pӓ�k��FEMv��<�j;�`O��|�=1���}���4Rz��v����;|/\ى)�-��*n��m>4�vd�?��~�L6$�<M�Lh#�-�;j������4(1Mj9��(��e��H�tф*#��c��3z!��O�N�)X 7-�Ok�D�9ؑF�wպ�R5\�sR����I�/,JI���lB�����J�&fj�G�_>M�rHW?Ȉ�~����6���b�nԐ�����E��V)��l�؄��u5��nͪ��>%8>�r���H�`1�n�WC���a����-��TH���;����ˤ�| ,#�y���x$\��g�s�A��f������K��ŵ�ui]�q%�3����2wͱ�X}��z�=�upǢ�Q�@P��(�c�،��X�R�*5�M�����A�O�!.�c���۔�A�8J�<�-���ިe0��"ۈW�s��;�%/+���p��jan;Vመ���uFZ��.S@33	�#��A����;SI��7�ܵ��Q�H��Cd��6�l�_��٩SK	����n�Kвխ��4nF�V�}#y7�ОJ�ϝQABk�*��`]������"R�����*f�I-�V1\�H�L����B"`�:ZeH-�m.8,@�v���h���t��s�h7$�_��ʈ�C�܍��/��v�X�w�=�ͬ)�j��Z�"�J������⋲~��,��u�!f���p+�����Ep��@�a"L�{o���\F�%BB7Ӯ	�!�L��s�%�*���0���K�Q	J A���hʋ�����>j7[�B���޻C,%��^&�v&
`n3;^@ڧ���5�������PT�{SD�(l������$�R�3D�"��|ה�$:yF�~+�8>&�X ���f\@PJ��>�"X-��}��^T�S^�[���	(���AXwS��y�N�7�#XĖ�ֶ7�#&:��X��slrP�����ϥo�F�����䑏����5�'7��Pi���)B�85���Q�2��ʶ�\�����7j$�v(wi����Ә��ѥAW���E�s|�Q1��ݼ��QDE<�������s�nqx���M�w�}���K�SL���4�nm��Zѝ�"4@D�����U�Y´�0�0mR�vx_�������YD��?��G��}�(ĝ>􆓭m���E4"�'z��$B�E\o�l߆ED�}��U3T��F&�8wU��ܛ��mk���0�-���^��--P1��y��E�3*�
B"�,�+F�=����؄p�h�K�BQ����& �p����$�%�K4��/������Ўo'?�5����K�*I*���� ��."���l�C��Z�Ԛ��;�J�!�̰I u���B�s�j�6�6c����@����~X���4� �|'��P�(,>zQ�����h[	����f�54Z��D��*���x(.C�Bɉ2�H��RB���dhƨ'��bt�Dh�r�]ws�����]/�fM����a%�fIdP�l�"��� 7��2t.dc�EGE��}��,�����%Ǣ��~(.�:��Fv_k7e41 4��KA��`tZ.���&�B�go�8��l����I!�����BCFzTM�c�h�<��$l�sgs�4 %\'a��tx�o�&�ڑ��24x�CZ�2���KƁx���6	� ���o���v�1�LC.��:���A1/��= ��T��3����rb���4W
��J��p��U�JÚ��$9u�69AS���)¥��`Gc�C�@n�Q��bS:�	ĒⰭ��Ɋ*D�ko!�pS���
$c�V�AH(����ߙ�#��>�R��J���i~uco�5�im}���Ԧ`s�)�J�m�/7��f'�j�Q(����$$�ʙAB��nx%�@�XYc׈"�4d�o0�!����	��J�_��&�RQ[І����h��b_C�����F|)e��E��mZ�՚R�CQ�p"J�O;۞#��\�!�(c8��k!�K(��i�L�\�������(�Krg|��C�t���.�<��6w�$������Գ�@m���������uM���)%����3�Jx�I�~6s[�ol�7���7    ���4�Y&���F�&�Dj����M�j������b+dwCgLpp�G�N�]�=T��|8�$�M��33�i����qQ;�g̥�\��_27`�!p�2�z̅K� ��&�	���?��&%ҋ~+�l�/��q����p�{VV��ƽ��^�PPmN4�����_�x���θ�����ఐ�B���n:�n�����{��q!�vT�]�B2��/n!}���6�J�RB��@� �v�Aa���g<���"�`�]���2{�	��pY�ޏ���-�K2�:O�K2���U��Bx��
���\�l^�f� v-)�߆`�7Sq�v���羋�b�S���U�6~Bq�"�>�'�&��J����ìN�ζ����1:2��C�eD7rZl7U'r�*E���n�������o%�@ec�Bס:1�0��qJ�b�El}�ۘ,�w]����"�B�2��T��ՙ{��5H E]��Ǳa	<���P�`����7��v���5��k��-X���9�ӫm�V�՛�Eս�l��ݯB�T�J��uYg�BB�̠Q�&ȹ��&BgtnN��P����a�n�I��}/R�!�7��95>ф��$H9���x�UZ� _��O6!���	���5���|�D�0��!�"���3�&	�9�w(�ۏo}7��M֖*:�IY��s���%�uXJ�f�uu�6������M���'��!�wh�1H�~��}}�O7�Dj�7!��ET��l( `�=�4s�1��"thv��2H�)Y]3T����`�Z�57��q��9) ,���¸�zWA:ѻ�q,����
�R��u$�ϥ�k!P�^��`yt���8~ڄ�[��R0��פ[��I0j�M��ABx/��9��r���oM���	#�c���{� 'C�vY�ވ����$������d$bDf)�h#M�t�A���Q_� ��)��S|�q:9o�o�=��Jc\��)��T���qs�W�ED ���jFu��G��` ��2.���~)�K7�ꇣ)@9�t�@Eq!lަ���E�[��ݝ����Ǥ�<��m�K�u�n~'����d�1��M���=����1a��ކ�_����3�����|g��mgo����,#�D$l2ba��z���N��I�j�/�˘���$����L��7ǎ��%[����Mv�3�%��c���*�����"�<tZV�+��V�
0p.w���}��I?�o�����{�!V�#m�R��j�������L�t<1A�Wg,$�RiVX�p�A�Ό��̤�K*����A���R���Y�
l��I�� ��x���I�n:���d��`�bS�<��� E���+��{M���q���r?�z5�hy�0g�MLuS�&�B���1�$����b�5Lb m!�ۿ[��g�@JR3w�tt�b��hz�v���f�:bQľ�]�� ����V���t�<{7��l��ΨjB�B�c2�`�O�R()c����˪�ʊ ?ĭ}����y��䳢��6ǰ ��Kg�����$�����;���i�|���YͬJ0�Lr��?kl��ǃW��;=��Czt�n�	�wu�!�}Q)�f��^�Tk�@}D�MH�����M�Ѩ�ѮF��B+��=u���>��km�N׎�� D+}���b\Vm��w��F�*���_@�ů�or�MN�MN�����y_�o�\�}�����P�c�2�뵱�⻩SmyP�U���KP�KF��V�_:X8?T��B��n�GB�zcxQ=��+-�L�&㦤	��d��p�$�|(��9� ���S���豟3��W����1!]�.\x�g�u�Ƣ[�ׯI��Br­F!����s�}���P3Ai�iW<���"�������аv��I�s��j���Ն����YrI���}����A�ۄ�AJ|qE��3�Y"O4Iٍs)y��)O�����o%�f����3`�c�I���Hvh�Q΄r�@��㺑��;�����<���u��z���xL��~�{�7�uk����H@����L� ��n�a��9O��Bև`�l��)��}^�b@������ӣ^�m%�v,�O�p.�5�� �h�$��PǶo��jC2��Q7��s��خ=9�*�c�/�ƥ�un��~q�n�-��
gfF��ʹÁm�q/��:�S�6�/��ԏ����V������^�ѵ��������O�)uf�S�2��8v�h�,s��[�L��5��z���\g\���i��/������N���Ie�z{>�F��kj�(�������y�6�I�G7��\|FpIE�L$t���M��K���<�z�NIb�M�;Y��&�����&Kx��o�MvBH?�-'7n����f�����J
�B�QTm��=E,|gJ�E�[.?\ܻ��{��c���/� 9T��O>�U�og���6�;�R��)�w7��hۗ�>�e�1v ,Yi:-\��|��C��݅6e�p9�O�K�����/!�+0'��ζ�\��q��c�Ќ��yٜs���P�=��Z�}kC����z�}�M�*��ԙ�/k���YK5�ݧSz6��qߪ��4n^W�~����2d�XJ�y��K�)�9G������A%x�;��̐7��lp48s�t�5MH�Q f�Ic=2����m�㫛G����%�E#a?�X��Z�����	&�r��v�E��8��w��ʄ�Vp��������a��ځ�#��oQtC?����Y1��������rw[��R�|�L	V�B��Y��*�dV��N1�"�9�Dr�-恶�H�G���
&�2�If�5%ꎄ㰀ЀC,[��a��&�'�^­�m�)�����)=G=������}�>$�c�'����St�n�Ͷ1�z�4�݃�pۡ�v/�(�Ƣ�������}8ӽ�����f9����zS�������?zY�e���������&>����;S�Zda��T-�}�,2�r��g�T�5�5����Es��o���l�~�f���zG�St9��w�O} O�B%�y�+��w�>1	��������^���o^�&g���|���<��ȋ-���_��[kaZ���J+���>��`�	��DѬf~`ɹ�}�c�[�����b:^�߻�7m)5\�
�Zol�����>�l��q�ն�ɏ��uz_C�ai�X���4���]�n�I�^�%�:JFbj)+"�C�(���Ab�'y����H�̝_ʇ�,�W�RÌ?�c������xe��܀��'�voa:
��Ү�T�w/ά4�ㅨh�L4����4����֛ʻE���aL�vҒ��S�����(?�ń�0�xz�`tCů=Ug�������+��P��ǁ�Aھ�Mn����Q&��lM,�u���i�~~2�J�Ji�V��c�V(a�%4�޵�ד��z��{.���
E5�^���M�꠱��G%AE�{%��"J�]4Ev)@�ln��ek+/���T��� j�~�2�����Z�:��i����0��?^Mq<�U�E��JK��{A�Op�63��A]�)�_����F gԚ��by `;]��ʺ�MY�X)�my���ј��6�\!�{���Mb�/Jk�ԥ<3����z�X��K����3��=N������"��l�bu����kvu�dԏ����X'z�LF�L��N,�@
��� �����/w岠a?�L��%�[�Ա.1?C0��(e�"�Q��X�P��<�.N�|����I%'�L�%����{k���?�c}���UX�Ln�����p��G��X��%1����
r[7v��}������O��G�E?���Ƕŕ���?K�Nڹ��b��	9�;������z���bK"�\b�O㽏yTw���z]��*�{�B�`Yc����ңS0O���7�x[�[�v��C���;"Q��\���`�a����<������<�*�	S��*    ׳Y��>.�������.·'�
��f{�����^��tO���_��]�� \�qM2�kXL�Z�WcTI.�Ȕ?]C#6�S�!�Òeqԟ�z�?�R��@��NyT*}u�l+{�e�]��@E��*/���L���J`�����ӥ{�E���Ey��纼����I�e�n���<ݰ�S����2�N�Vr�d[�q�����Ҩ��`w|��w:�Q������G�h�u'脈Y�*]�������GSz������FF�W>�?!G+#v��ݍO^}T��i��J-<���M�me}�z> �+H�ň���cu��w�����#@�ҕ\� �{S������[^�4��ofy��<�t�s@��݁c�ѵ7��{�Q��d�T�0vL(a;!&Z��N�Z
���\�m=���]������V����HY�Rl�L���FHz�G�:]�%D���l�t�A��h�yu,p�a�'T�zW��$^q�CD���n���:(��i�Y�yc�|N��a����丞Ř���u�y��<�S�4��jb�Ym�Ɋ3���Z1j`�S%ʥ����>_��y��:ߝ�Cq��<�U���gj�Viʻ�Cۙ.u�Z�d��޶qQ0{V��;J\�"]� E��^��X�:����|0jx>�:�a�X�2�k�����UY��X��˪�"G�A��176W�	&\���w�F��1%��Y���{'�H�6�*ώk���c6��=z�����uOxp�~�'{���1Z`H�?�����+�8�L�b�Aq���RWA����y�7rI���o���AX_pUx������۾��o���/��ƙh>�K MѺYU�1�)�fX�W���i34�Y	�p7����=
ᮕ�o�J��~:�i�I�/�c�1SP��@��)�L�����h&p���㏩��X��B�(|����M	�8Ze���{���������Ŋ
|�J!����	�(�u
C��������(�gS�0uD�����;� 5Y�[2����n�m�'��oRb�vz�S�
��T6���;�E�����V�X����9lɚ���ݦ-�2�4_<&Sq�������5�:v;=L���VvS���)�@bxn����4h�Yfjv�ߵQ|Z*����qs�6\⟥:�yں�F��
�>}�^<N&_	k�$���<i����B�}xgEQR��ř䕐 W�~6�XT��fۍm����=��~�:�|	�s/����������Ԝ�%���'�-*R+H��&����T/��*}�L���N4���/.�$�9M����ԑ��?�o���^sBuY����:<)�:gޝ���FG�`�Ps���*_������4o�(&�S���6�-�R�"������:��J�q�-�l֜�ݸp��v�g��Y���o�}��p���=�y���(D����iU\
+>
5�s�Lg�B�#��L�&`q���O��l�_u�#�;��P�v�z�`�h�6��t!��ӻ��)N��&���*�(��\*D>��Ȯ��ɣ�p}���T�k�@�(�:,c��&���o���t��
�֚����]H�p�˃�3[����3�mor�k�=SR�@s���y@Y�(�HKP�9߼\��m?�<&lԊ���-�4^{[β��L`���@��,�B�A㎐̰�BW�?'S[Q-�3���a�\�P;8��M��ŏ������KEW�%|���.]���9R���+,�����?z�q�v�0W��1�D��^x0"�
*%��QvAÙ�Y���{�琉e�89(_���YB��������]�k�|X*��]����t/�b1z�nd�0:6�g��M)P��8�*(����-�);&����zW��Q2�k�Iy�����3��WE���汻)*O��2��I�z���$�O͸5�s�n�}�z��WoK��u�gb<�d_�c�~Nev�c�Z�#��;Sl�QA���ж�T- /�W&��Z��a+��&�n8�;�_l�#7�N]Z.r�b߷9�[il�̑�;�F)[��K��Q	2m@^�տj�)���g����.�O�${%�}B��H���-�M��48�I�ut�K`��j�M��-�G�u��	����xB^P�p6�1&��p�eM�ż�Ċ�����Q��=Ѩ�m-��5d@L������j�����}��Ŏ�"�Ԉ@�d���Fh5B#g�z�ᔜ��m%���F��<����.�а����n/�m'�oSd�ea��T��&��FO�9t�/�)�7wW"�
�CKst6EH�w��"��#Q4n��`>MG(�*���0���@�Q	�hG�>v��2tE����>m6��Uv|"a��ѣ�2�1Iۭ��M��Q�^�YX�w�,��X��{�V47Jtxl�6��'�.���N��(���;��zs�L�)��J�N��s�I�\*
R_�MN�_��=d���tS�i�斺���5�4�4�X��qΉ7Ĵܶ�H�Y'��e�C[�l�zkg��U�P{�?�uh]J�6y+��pm�a��ͧ��� N���'�=f�5�%��p#�"�&�q��m(����iu�/���^�g��|��-�/PD0�S�㗭}����Y�Z�မJ��i�|?:��C
G��W��^�{�������(��ܵsgʢ5�YJ�gߚZ��#h3'J��/n�8���� (x�?X��rZ�2%{����iB��8&���������e��ܚv�[��eH@epf�q�5���Kyq��^
3���\I7����n����d���ǋ�v�_�\{|���k�VIQ;�e�!S��([;!k����پJ��Z�r��-��,9pʩB�R/`�9���ps��u�7���ڻ���n�1��}s�dq���I;މ�b���G�!z����s")��4ۢ7/���.�Y���+ǚ�ő~��	�
��Ȩ-�ތx�w�������6H���	.���x��_�=V�</.ve��ɸ	����7���B쿦�ō�Tv}�9�.P���<Y6����dL2�f�*%n�8��F<�tqN�twGo{.Mf +T1�ư�T��n8Q��sTPu�QQ|/����[Ҿ���~e�h���gӻÕ�݇nrCQ�xo�:ʸ}2-��*�]<��2(����-�K�9���d�s�2&ۼ��pU	����M��`���\��E����^D��Ի�!KI3�8���Fc���,T 4=l8�|���w��#�W�N%\[�"�~\�w?�SBP�ǋ��rǫ�䈽���u�+���v�\ ��srwJoq���� B,�"�Gʍ����u0d˽M�m4O��
����Ť�BkIP��33I�1G���ֽ��vw)G��GՕlۇQ_Kef�#y����vy�5 Ug����:�����R�eh���1��n4��aI���#.�h�����!��V��}�b�e��N��/�%� �8�q��Ib������s-��R��"ƅ~>��N�OS+n݃xi�ĵ>�bd.e��%W�~��?��/v�]�I0� W,b�����Y���G���-��vuC7�r�\����?���9�Hkg)��h��]&"'Y[��U�QX��ۧL4�@�)����G�Ѵ�w_�l������+`�������:�0ʆ�wi�O~p%�a���q)�����Q���(_�U�{�<�a�SA���x���1Q�mX,ḯ�"=1n}ٶD�+��a� ּ伇
�Y�P�� ��N�ēD
o���� �_�G��x��)�L�yzn�[�a4b�
��ۄ�(G�=p����&��Zpx�p1����$*"���@���$Tc����?��au{/H���Sh+��fs
���.\�����l�̻�kT�}��(AqS�w`7��:���<U.4p�.0�$�>����:jq���e^�	��};��X��'y�xs�i��K�����4�.��_����%�9K��M2��}u��m7�ct�lL� �FO�
�y�D T���kk\��Y>�}���0y&mL�~�Ҟ����&vC @�    W@�q��dxf��#�{���'5������	-�H&��GW�<����6<���j���BO^���?j!����Ժ�ke�۲1	W5j��o��;b_��@^�p�l�{报��,�c��^B�k�-��^�n������r�}d6;�Y*ʓ�g	e�f����?ELdi ��i�9����x�]8T��,6�Qn�@�^i���C���]k����W	��B��~��\,.D�˒�B�bqߥNq�Wz�u�Az�������6�P_;T�+Q"�H͊[�*�@p��s�U��4�)/#�{�t�9���ٖ��=��aA��$ �:���:N���w���<s+�%�d��H�A��ɶ��Gu _W9��?��q3�|#Ֆ�,@��������A�@����27Y�&�=���7�G���Q����O_�&�ۡ����P�{���ѵ������N7�������Vum�'�B��;�01�� �ץ{^����c�b���ݻ?:�C��Cb��ws3nG �(V�ry ����ǉ�@�oI���?d�Qy\���/��ާ\��(n7n��Gk���A�FF���\���vz��d�����&g���Ӈ3]�$��>���݄�W�$���r�V��k�}݀��DL�ڀ~�e���CX�+Jh�ݑ�(�ဃ�ӵ(F�����6�> p���5���GD*��'J��nq;ܿ���=}ΛiCE���ڐ~��5U�����BV�
���C�F�" ѕM/�鱁�j������gq��LiVڙ�.��"U\'��wD#h{%��i�E��6����t�<���V�Ғ�O�!qM�����<h1̺�f�s�6j<�-�d-�����R80��\��.'�̌_6h���b�4��A%.�۔(��8g�Stp;a,c9�4S�rX;�˻X}�i'�_-F)�>�0��C�&h���,��Y` ��|���'������(���+����3ޝB��H��^���c�.�H�/x��:�
&:� ��Q?�����2�1mv��h���?L��u7����5*6I���9�ҬČ�A?��rл���+i~xh�Vj],�5�cHqG�J�C�f��*�t��O$��p��Q瘻;�<�t$���4�������!��!����6�n��d�����ժ�@�L��H����e��
XI��N��R�	�#	�֓��F�칅;̬���c�V�Z��#�6	2��E:1���r���/��s��g1��0��yV����$�ԶlSS�����by)WK:�Êd��d���5���i����?M��^B�gz$�������Ag���z#Mضc�o�"0Co��u�������b�s��`����-��[�Q]�K���,u����n�i��a.ÿ����Fd���kd_E�=�j���˺��V�iGx6��;}�v��C�*;[r�qQ��"�Л�-���9�k��ڸOO�r$!":vk�R
MkV-M��l��Q�ڵ���Y(jА�mV�
$�R6]�?��h�"����������M������3��+�p<���;qn��t5yp�ǫ��9��l�Mʷ�V�q�K7��!�g��Ҍ�5nn�5�2�Ы��Ed��0t;<p�C �Q���֥7�f���|L�Q��YS&<�����}�޾���jm:��F�O
�Y&$���]L��Y|8U�q1J�g��~�V]%�6섧�đ�f�Э�vچ�*.���3v��-��Έ�j8'gS0��0^�n�)
��"����ۼ�ܷƃ<��e��v"���7��x�ex�q\w�<h�g"�z��>t\����C�����1��)���$�H��(��h��'B�n�ʍL�:�2�Y��Ù�����U����w�>m����k&�9�1���p��2@ͳ��\C�����a�돁[T]�f�.j��4�J�_W�fi6)ڦ�6�;��6C�cV�ì
��m�J��9}L����W2d��qY�LB��O�>۪�_�[BH��Y{�8=����>��N�/����Gm�P��!y~�*m��Z�Ae䚘�]��>L4��Kz� Az[..��Q���e�_��ױ>��|�F�9"��`ܖ�ܨi���B�/�h�u�.����^ο���=L���T-�,�ӄ����~ԥQi��U�|#TL0m;~v�@X�K켼��]#?Ժ5��L�@�w,?��,��n�u�=��iYw���:q*�0�E~��ug�����GHN��z�e���֧u�{k}��R�Nc?O%4\����y��\L�8�J,�]ɦ�]  �ou���y�>�g E���$��چ�*Ee�����?FD,#����������dj��}�_}ۉsg����F%��o톶�l���������9}��G�$�lbd,s�f4�sy���Goˢ�\��^�G7۪�9W'S�$2�ʶ�܆�P\J��n�����7��q=������T������u�d���T�ʥ@�r^��b�S�V�8&��v�Yr�����jd�P��dCC�e����~Y�uw��o��AF����FJgvf۰	��/��O�I���?�Ұ��)�{.O|kK��!#2���b��Q�Q 7�����m3�>G ��9��Sې$�����j�;��W���Ő�~��XG��C~Ù\c�\���8oRdO���A^��P�܀|�		��t���Θ��q���|z��䮶@��Ɵ�4��"DV���A�ܵ���j�9a��۩I���q�h���2V����Ia��z!��=�r�
��x��E�{�I6[a᳈~�{7�b/R�^�41�2�3��{N;�xP9�fA&�&����DU�"��t��E��#'lT*!��e�����>˦����/uN$Ի��UYt0���y�pF�ny�!��{�`�sZǛ�
h�!�aLj�k�b��f���_��L���ڳ�7�
�$�i+\c��]��?�����[w[M
ڄ�lk3?����=��,��2M��ɫ���T�+q�f��6�&b	��DOxeu����q8w_p1 8v'"to{q��\�&�7lq�!-E�O��J 4�_��G_>�׽mߧ8o�Ӎ2Ri �p�V��*X��B������À�!I��ȏ��1���a~���".|������Ȇ�g8nF
�p���%�[1w�.�W�2��&
!��w���-R�M��E*��c�=�6�S��þ�=���]�L���Ew�����
Nλ{�p�������D��,F�c.4*�b��p:^�|�2�T��@�RSfxkB��2�IȊl%���T�]M��]D�Ð�p2YI&=�������"ʒ�8N�S�o�B�
�ҳ���S��CCg�!9<����������*P.���ݷՉ��5��;RA8��+�nII���}�W,�L�ԋ�"�X���4��(�t�֍�,v�'vE҆�%d�[)�	f���%�ƫ��S��n�_5b.]K�E�|����{��6,��O0����[��p:�[��m:Q�I�y3^��$r�n����!.���J	/)�$(f:5:�������$�4-ݣ�d�W���vA�a9V���ĥi!����/˽)�S88�����v�R�z�ɀ_l��8��SR�~���}_���>�k"8I�iyϣ�{�>�׃��s�%������D�|5^�R�ئ���G⟻G������\�B {��/�x�Rd*"�(�(z���1�������(@;_) ����c��6��f �.�^�F��g\	W(S��ZBA�ՍF��j}6�&����5D�!����ӽoaIYeV������)<iI�#��9�r`9_>J*�����ҮW�/!��A( �:h����im[@^)���	`E��$
�l���2,�X`���=)��$�ޚ3tZ�D�HS���^����."��G��g��L"\�)YY��]��4�;�+�)߈������f�;Kk0����N�'�:�rD�{Q�+�� .  ���;L,��5 ��>�=(����L������8ͼ*V�
:�Rq��J|��ю$y �L�XŰz�4��5a�U���`�W�iN3��b8��,���wP2���ox�lX��*Y�����\E�yd����婐?%Ŷ@ʎk�n6�$��ā-��>��4S/�@�}|Fu�)n��,n����OW'��5.SR�Gu)k��Bd������rVR'+�4�t�,݉�����t�瓐s��KΆ?R��k�9Q�;{�)�Jј���q��;��v��O̼
|x��2,7���߾}X�mU�晽;��a5#�$ ���>ݫ�� Y�<�I	�p�1�Q��C���F����rJNb������#��Rrzڿ}��r��	+�o^���,�R����Ȓ�C��Ud�o�~��w�A%t�W�>'�N�0�Gd�ۺH�~��\��/{�iϡ�c&�F�)����se�ϐo\rf[DM���ȯ�C���R&e��Ey8K�L"/_�gw<�)Ww�Ӊ�*�S+>.D�b��s��Nf�e$�`Lě(�����N�
[B�M �n"���q�y2�z ���O��>���[nm *sYl�N�p�Q3A1`������$!���DhKE�����h�&^PdQ'X�$�m���fF2���b�ݲRhDe�4�L�B�H`��''M� �-W���K�y~0j���]R��K����1Ӏ�b���Qij̪��Ņ�F�l0���O�HITFr���w)��B�ܻ�{[PSE��g�,'f�}t��]�s��5�IGS7N�"I1�+�SO�Bh5����'����e)�Səe����N���J�G^��%����0�kב�bb>��J��]L�`_2��"NF�	оOE�ϱk����~��Q�`~KDDm��Sb�R��#r";ᮓ�`@J�Y��_��zz�G�$n~�M`h]D�����ر9��P̝'Mml(�{���G��RjPD.}(4w��Te���kIv��9��`� �Ć�ӄ?o�y��?Ȩ�J ��©E/:��6 ����ړ�J���+�|��6�@��u�Vv�q̖ ��f��v�������}�A�;���9H�+\Orx�VN��6��=�l�mqm�. ��4�i�x/�s��#����̽c{=���%N�f''if����ayL���y?���X�<���)�Z��*�z�~��41���졨��.D�~~B�h��GЏ��S�A|	�V�*��i4��fT5O�� z����a~q����\����G���"bmV���r���/8˚^���yMMD���J1Ծu��ۖ�q,X�fl]jB,�)��x���J#!g���$J�P�.�u�ǁ��wǂ�8�j�󜧥+�\n�X��@>��_w�Z�t����A��n����c%f�<�1'�����b�l���as8�Rnb�� b�A؎p��q[y)�Hg׵!o{p��R��� �-cֲ{�:��k)5֭��!]AjT�	2���#��|��T9�
��E
 u��ˤZN�I��N��J�(V�
8��C�O���u�l]�b䜞E�:x�]QXxA���ע�����9��ԚW�2/b���Xd� ��C^P���
��P�.[�8�J�	H�(���������ͷx8���A�V���j�<R�˓Y����<׶k�v��T$�����zf�o��'L�hk}ў�4�ï�x�|ܾ�jǡK>S+~;O���l9SD�� ������Rg��t�f@j]E=�6Q�(����(�3�0ɸ7#o&'.�1�m��Tnf��ܐX���NՕA4�z��f�Ap�3d"K�l��L0���2�\ǋg�y:3w�+ݽ��S��6��|��L�O��tU8ʸ� �O^�t,!HaY�����Yn1��W �N#�d׭쟘<ab`����y$}8Ƈ=Y9iNs.�y��FT)���麦��	_�@���r������%H^�u�vG?��
�鲅am���7��ZJ�v~m���M��BK�*��{��
R_I�U;�2���k9z�v5&0�
��[�'��*$�Q>c����S��JRz?xݞ|}�҈�!|/���� �g}?��C?����/��,@���,׷飝���Z&h����{}�FZ��d�A�Q��3�A	�x8>Z�+��U�٬юL6p}Ji���T �2	mK����I2�~�Bg)���N�A�}oJD�$�)ԓ$ř@'�#��SK���� �����CP�u�|�D�����=�8�xO�	/�髬��22<2�D��.f�_���Tt�� $�ј�y��GM:�|����M{��%�<��T8��=�F��9�Q�q.��� �11ӂlB�c��qUq�/��N��<Oً��Z�|�C��b.+(�E�!H��r[,|S��������m:M�غ�N�
������;�I������j��=쓐���7�g��
�E59#�n�d�_%�Y������0��,�Ʒ�c$o㵜B\�p�F{���K+�T��-�>�
���3%b��gz$$Z�,�4��g���x�$H�o<�_J81�ss)��(*��poJ��)2��P����[D�ƭϤfoH-���8����'��,H:;�V5E�yh$�Ԓ�@7` D�u�[�8j�eHJ ��_�%��p�4�Df-s|�Y����u�aCq�u!I�T��9�گ�z�Z_O��ʸ�W�mj;�����3��*��Ъ~{<ډ����z��F�YH��c�C�ڪϏu�"�eG}V�	U�@���?��eO      �   �   x���=�0�w~Ż�	����a !hDܱt )���m�(qq!����]���Yt�!Nogt�CTl�D!�����Q��k�<�'�]�%o���ƴ@�o�n����I`�@LJ�Dǘ;�<͓d}0�T_��|�D�gFr�%H�&���9tqN��.}U�lZ�@ݖ�hA��l�2�"�ZF����7�	��7
�3�W�0^
�v%      �   
   x���          �   
   x���          �   T   x���v
Q���W((M��L�K��K�L���K-�O�)���Ws�	uV�0�QP��t
rU״��$I�Pk��{��cH3 n\%b      �   �   x���v
Q���W((M��L�K.-*NLI,Vs�	uV�0�QPw�*Z(�*���*8��%��Aºf�F&P�%�g
��(����@HMk.O"l4�a�OiVba�,H���e.� H�m D�fh�f�C B��t �f���G#�`��K�\\ ���=      �   `   x���v
Q���W((M��L�K.-*NLI,�O�)���/Vs�	uV�04�Q04�Q025:
f:
i�9ũ:
�F��溆��@9Mk... ��      �   
   x���          �   �  x���Mk1�ỿ"7[X�N����<�B�^��K�b���o\ь�	L��x�0/��0��j�����M���߻��������q:[����V�AUb�ڽ	�V*��,����w�����<��8\��_�������$��[N�s:N*�V���=���k����^o���h����5jvС���o�vУ�6�����A�߈��a�=.z~-�������ٽ�M��U���n�t8��t�)����p���F�{X�ڸ񴑈��6��H�$6���H�M��{|j$�&I��=�4
I�\@�{��Sș$l���)$L���ٍ���s�/��
21�W�P����
31�w�P��A>4�M�1ib�O��P�|k,Ś�cc�ؠ��k�I�@椁���4��Fr2�*�����1Ӕ�H�@�ѥ5/�9dLi�dd�[*	�1��FR2'�/�QI��uHN&�D��      �   �   x��ҽ
�0��=W�Q�H����! lu-�]�Ԋ!������g�b?tב�~��w}��|�매%�iݖ��2�\��V��t�u��p�6\X���"Ő`4$�P`H4��`(44�0`h4Հ�4,�p�Z4��`84<�`x4���ˆ��Z@�'�Һ      �   
   x���          �   b   x���v
Q���W((M��L�K.-*�/Vs�	uV�0�QP�wS��wwTG��������%E��:
~�>>02-1�8��YDjZsqq ��#�      �   B   x���v
Q���W((M��L�K.-*�/�O�/*J�I,�,�LILQs�	uV�0�Q !Mk... �(�      �   �   x���?�@���Wq�w��3Hm�%0���ߣ'<y-�3�w�l����sM�>��x����C?\��}���\E�Ud��FX���MQ�c:w��G��n�Dꈵ����	�]�\�<�H ��
�BA�DB!}W:�r
�ʹ�U����@h��΅��\�����q.t�Z$,�w�s�� �ѯ�i�gt���(� .��I      �   �   x��ұ
�0�=O�Q�H�6i��C��T��U�.BjŒ�7���^��>���Mun������{u���a���ӻ0����a����R5|�%<��=K�N���3�7���AeT� %֯%g+Rf�Zj�,O�Q��Y�*��U��Tʀ���),�$[V	K��9��![s����	c�+�      �   <   x���v
Q���W((M��L�K.-*�/�/�,)��/Vs�	uV�0�Q "#Mk... �R�      �   M   x���v
Q���W((M��L�KI,ILJ,NM�H�KO��O��O�Vs�	uV�0�QHK�)N�Q��񁐚�\\\ ���      �      x����r�F������;B%y��
"Q;(R�b<�	��˘�5/�y����K/ю�Ͳ�b���$]�G&*7咫
��?O�󝓣�<�-�h����㏛lu�N��ߒU�N�U�'���2��o�9���d�O��d9?��;'g�t�ʒ]���Lon��bz&�`����?�ZX�u�4(o�����������������	;'��Q^�l4���	�Ϟ_�=����x>�E�)��r4O�FQ�Y棶�%,/�棅���lr5��f����o24�L����x�ƀN�dZ���&���kL?���k����y�]N��ad&��Y^��`��N�$&ף�i4X�G���p�߿��	M�:�X�:����wjM#"^���%��ly#��԰YD�_�f�3���i�����A)�C��X��X��R���r2�f���5��G{a�� �ឱ�P\�==�r2��棅�����/�T�����n��}�k���.��j��7��h@���h2��!g�tB��hlf��=O��n��ݚԂw�NQ���GD����W65���w��gr1�2�����}�>`�vk2Lv��p@s|��w���aw� �	Xw�뵆r�@t%ݎ�	���O�����ZOH<\W�x~�2&��<�1[s�f�SjX}[>�����/�>i#��wft���o8Tp���S���5���|��`1�<FC�i$w��A�ŭك͖�o|��q�'r,n��& 㳗<���kCsz��ͣI��?+���-4��؛�n��n�`�
��^�Y��G6��R������S<��Hݼ�ގ&���� ei��ͧfA��5��ͼ������}�8iȋu]�*]~C_�TN���5z4��i����X��j"�A��1a���NC�O�hcM	B�";|���L���o����#�o,-�H>�`Z�o��c�Т����]4_�
����۝�|��k�k��X��wޜP&�4*�y��g��,���=�&��B^��h���sh�FU<�t��ނ.1��Z<� fq�X����&��&h]�����=�Fc<���*�u�\H?F��q��r �Xh���@<��'&���4���Lة1 nҳ�
��,3_W�@���/�} �ʪ��<]��⛐U~w�I�?jeF����g���D�>�
^w�!V�m"�y#�JSH�m�'�E���;��b9���r&g"�G�]4�pU�,P���A.~�Dn�
�dO�����#,��	{'�`p/H�<�j������������H���p[�5(0߰���k�_>T�7�ȭa�3���择��i�m�ԕT�{��1���ĈN3�^p:��n��z�T���*��]������i�P+7�:{�*`y���o�9-���I�#�m��t���ɺ��u�_.&M�`���E��<�U]�z�(�t��M\�������[p��>�K-8-�v)��v1�ε�]�}���pr'�����n�L{"@ʛG�Ѣ�`dł;���#� �-��;��<l�! kZ\_/�g� @��lޏ~�S��Q�g!��ꙻ�@�R�����/�,�/��_�gF< 4�����RJ-�'��Rj1>d�R��	�Z�/ J-�� Rj�� �'�����"/�'e��6)�? �I���A�̰��KG���C5w!*�b9 �LjQ�QV~h�o!����b�q�F�B�90���t�������$�'��,,��:R���`���W ���,�����|_`�6�������oPJk1��� �	T%H_5|0�4�;�J�&QbP��ÔgY�5�$T��QQf_�N ���&g�|{H����>�_q]�O�W��S(sZ�N�� �zAmV�_�b����"CF�/�t�ު^�X�+����E�QV�X>`���wK>=���V�$���NfS��4�����赎	'�>�k�,��S>�K���ک�ty1� ��͝�4 ��d@8�{���m�7�&�].) �ɩ�w��mj��^߸P��q�O���JU�7�����k; }r�d2|(�_qW�_�^Ǹ�������1��z��*�;�V$ݒh}G�)���w�>i�� z��zR�[�˘�]� �T<s��]^�{j u*(�p�z��5���t��%?<�^�DU4pv�|����x�a���}&�Ʀ�M�"	Z��hd�P�Cj������M6������G�qeC����>��`On����9_�k��
q���:+�\i�l����B�I*���9��DK]r>��C�� TNx��LE�� O����(�9�n˫��Ԭ��F��aw���:Ye���7펻/k�X�$GlV�X\mu���鬽5�Y���YH�"��U�b��TRM�>�u�( ��̉`��j����U��*����\��)���̅�B.�g���h���z��Q��}`�������S4%����S�%��n]�E�MOS�cAޖ�ܻ��,���{���<I]�r�_ܜ0�T�ɳ�IK�ݪ�F�`���"���Ȱh���Tja1���� �ִT�e���Q4�D���x��hbj^W�C�6?�&��ܘ7�����^���bKB���6���z��������iQ��T�پ�2�֯�,*����?�ƣhR<U���L�4U��E��x2�gSb\|J���	{�ἍE�ưF-��-����}�L�A#7�B�Fn,�bR����� �i<պ�������j;'5l�4|{\�Q����l��u}L�nM`�x��U��7�ɩ;�z��\��F-�=�l_�F*D�/P�
}�F���i�{���h22o�Gu`������x1����k�(]��0|����u��ޟ���fϢ��l�W-^��t*P���y  �U��
�) D{*���K%�h�Ѽ�i ��.]}O�y}���)�T{A��(;�8�.� O{����5A݋��&��t�HAߵ�IR �.ɤ�P�����!Ĵ2Zw?���?��E{� ]k*�W��|�������Wr?�d�hꄒ� M�.� MU��8��4t�  �h�O�m$d�TJ1qWr����UC��O��$o
Vd�K�C�������.�U�YK�ʶ����{jQ����ضF�� ���P�j��2�/��ܽT�⵷7��U]u�,vɏɿ�dn���YQO�t�}��m�/�n�K����6�<3'y{ yfU)�Y��Og<~������Y��C�Aţ>V,��p��ï���k;��}j�Q�qfA�)Ͳ� ��^Vg[�E ���� ��o,�0�S���"8�*B��w���W���I�fV�pV+�Ԍq��n��k���VMH���M���������Q�˃|w/��9�r�J(�phʙ���o�8�}{"��3?��m��9�~�d<�g�
��1�l�>��;��v�H'�� <�j�3{��QgV�j�,�3���wR�Jt�����oݧ�䋁��6��60}��U=�lv{{.u4߭���K:��B�.������}ȋ��y!���{a�2^\����jU۲G=���:?���@<�3W�o4��- �rX�S��CE	��~�ز߫���k�+��{�T��
@�Oq���
���=�e�����E�d�u!���NI�v;f�tuH��G�c4p{+[���V ]��>�Gr���U�5|}��{D������t4Б Q���э����Ӱ�+GJ}�N��r8z:��x31N���٧H��t�<!D4�gg��guة�pEM���hrU&<���h,;X�����MD~��M\�S�t�{@�V{�h}wA�����h�(��.-7>���d.�@�bO�Ƥ�Y��{�MJ���Ġs���R�l��@
PE:;1��h{%,cn���]&1�Yru�f��$��H��K{k@*�I�~�4YV=��ݱ=z���Q��r_�<�	���TLu9�[�:��̪���J�(k�Mr0#�9s��w6U�nͬ��~�9-�lM�]h��<U�4�&tpf��$mɭ��m�60�缺o��J��5� �  ��{�z�-�:�En�M���(���Yվ���2��������<��~$ ��Y��^ł���5����E���)���h6�<��R3'U�h`͘���1��N �tR>� �9)�f@�mƜHВ��ԭ�ڛ�RՋG?Jk#�$r': ����� �S���e��&���]X����l�r����l���b^�m.��e����*_g?U���wH�r3��;� zg���Xf ޝq�Hx�&�
0�L��t1� D�9i�� n��.7� 6�|'1�׸�i�-�!���W��&C���]�(�?�w��Hkq߉�����R��w�3h�;�a"(��kvj�o�A�{��l���&�)3���,�q��J�8�WM�Ζd�lI�]��=�@�U���zN3�W'�6|dM8�0a�on��W���7���� z���3��cE��reFx��qˏVJ�ΊS�B� 7��N�=��gNzv2 �g
�[�g�����
��!%�]r���A^휔�kI)�<��>�������k��AXz���j��߷& )��;9/�!�}�C8�!��D�{]R�q�s�H>���EV�{��]X�g ��U����*u�l�dk`2�Y���
 }�e� }�r�rH��	$�ڞ{}���u��� [�i���Ԟ;���잫li5�FR�ء��;��q������t�������q\f��9q ��*�p��Yq��K8 �s���XT�0�gt�IʉT>��5�`�h�*�� �#�h @�s�j��+W��6�g�yY�p0������t���9��X>�A]��eͻ�qU4�Q��?.�H��|��y�d�=\PF �
��x@�T6尔�S̎@=lk�8@��K/��y��~��y�Eʃ�<�;�4 H���V���������G�Cu� 69�r���"�zv9� ��[7�� Nϝ=�ޞ��pSO ���ϗ����n�k`�<�B H=]D9�ԋ��@������<��.�U�?�/�zе7tz豦P�������(�� !/�d 8@���8�^���.���Hx�$�^���L��Pi��}�؅��
��B[]f�j�!]� X^��~��B�>��<9�7� �.��rq�b���	��B���9��hoP$V�f�] ��`ϝ�,�ȴq J�	����=��<�%?���W�M�?��?��@�T������luQtYK�S�KqmU^�#�ckC�j������p�\��PE?����x��@���� �.T�OT�	~�#)Ҽ�fr����`P�(]�s�ܗy���x��@��I@����@�^�2�!��wب�p�8�I҅A�Pr[v�|��y������8n��NH�z���H�ϛZ𑌮F��M�eӵ�k-���E���k��p��s�$N8~��"p�hs�[��i�|[��ooP������"p�' ���� XAs����`�ęo�� Tn2 �.^���]��*��-&��2�p �.���Yr����O�&i�釄�n~5�?��x��% �E��v�s�V�{�7Rْf���:'�1ͼ��@��^�Ï� Fz�:IԺ�s2���wB6s�g���� �}�4N�506m
�����d ��W!�h_�a{�M��� ��;i�����x� ��z�}�z:H�},��}�(�J�Zt�3��`�}Z)�a�D ���{�v�qP��d��$k�J_��>w�~	 t��+S�D ���]��@��;�x҂��e��b��L2��E�:�<�E����J�I��o���듿&�u�5�7	���W�=��{���;�ꩋ}��Y�t�.|�2�^�m���eJ�]s�抿������1�>о��ht}�[3���9s5���\�v��M���C&��t�[|_ Gg=�#0�,�`�.$�Is!� �}[p�B5Hf���N����3�?��k~�.�|�Ʀ�&����ɮ��cѡ�l]�g%}��Pq�xL��y���ܢ �v6���h��KN��r�˧�fq\�~ݶލ
�c�ݱb����^}�;ؗ�Zl�����U������Poo
�/���!�Ut��	� �����A��S��ܙ�݂9��>/K��P�ߖ���@��g�_�ӟ�K�j�      �      x��}�r�Z�澟;]O\�q����!���K�*J�Q@$D�&	H�Jz�y���,*�v��:fe��d&@� �(��LE��!�R� O�_�.���k�wq=�Ww�t���lq���x�,�/Q��{��&�Կ{G��4����e����8�ߘ���$��,��߽��~���G>cLi�����ţ�8���Z��>Nfq:m���1g��;��?�����HF��!!�@y�����N<{���N��R�ElE\d�4����q�Xd�eE��M� ~�q�uVϙ7���ē�<�<��T��i�����T��hn�O'�$���(�/Ӹ.�p<X��G����p���pJ^':��Q)��[G:��g���S]<%��S>��N��_������ϖ��x��} ����E�]��8G�� �+�X��<�6TI7�j@2���<�B�{����(/�����p��+���I�H^�S3799���ԻL�t����2P�G:�1(�U'��i�b:�R��
~Q�?%y\����J���eJ�I:04�.����:�G+��;d��=��\�y,Ԩq�@���u9����+|���Z{�O|�\��!�����4˓9�y߃̕��Wt���x,�h�Kz��)�^�x���aBp_m��(γi���z��?*�J��$��M�ƃC��������?$8��K�A�&��~�3Nr0��.����Z�\MV�2^��(�	�:?|V��ђ��T=����r��Ӛ�J8j(��OQ�:�>�:g�|�T�o�Z�<ͼ�lz�u��;��b/�q�sᷴ2J��Ii08����h�୧w�{-��9| �(���?�u�C�d���r	�@r��mwy$�["P�[n)���
���x>Γ��j��>Nӧn������K8����`��_k6���8�߃r�_����:`��Z
���J;K��K6g��4%�e�Y�&0:��xO��A���{�B1��
����޲��o��1���j9Ͳ��h85��.|����G�����q��뵽�x1z�[�|yCb��-	�1fs���#�k��4�K��I��9~ȬcV�h
���"%����LbO�y��j2�;4ym�XKs����]�?�<����&%��(� 0y���^p��`�%�	Z��`w����$��%K^�ܫ^���k�NWiO��"4h��_o�z����c&5g�^{z8J��3���2�ϓt��s�[�:s2�Sp*�D�	��)|�2'9z����7p�лn 
� ����":����	n��9����[-=o��r��ӗ��,�_����W�5��PJa+M���c>Z5�B8~ ����<���cL p��|��������\��hȑ�B�Di�����{� �1��n�)�A�w�x�X�����c���m�%0Lm!�F�ڲ͋t�Z�R��s����	i�G�t�A���xحIȴ���/E(�.� �4�����`8l�<\�G�~�38�?D�2yt�\���WP�n!�/%ŋ;�	�BI)�����.WWݏ_��� %jGC����8� �T��rp=�������>S��Hܺ(����w;�~����,~��޹w}��Ù�"�0*�`�Hj�ſ$B
��yt��^|45�o4�P���o�v�N�w��\]G_z�����/P���6v����.�Dx���4��z4��@J�>��N/ޜ����A���̀�KG���w޻����;�o�ՠz��{��~4������,.�Ɠ��Wy�c�^�i<��% J0�
�H��������e�1�� ߦy��u�.�No0\EW'��x��W�/��'�_HC/�����Fu��!
��eQ�|l��̷�� �E�	���8�$����:D����߫�V}�L�*�m�o�W7��v�9Dus��>�P�D�ux޽�mo�-�e��5�ͪd!g����1��~z �E�*R�����{1����ٸ�U`Ѐ��R!�*���)�U�]D`A�zQSq�/���(��u��?u���I�nmEl�-���	�9��&���W��i4Fߢ��( ��`3B��s�_F���F4�ު�g��A ����t����������<\(ԇ3p������w:�ڽ��ڭ� o.Y�Q;-4������CQ�{ڋ.�ߪn�n�>غ�M�<�v����8��n%�ko�n�2,�щ���t���Uմai��<�7����a�fXI��>�
��	G��~�~��>\��'�w�����j�P�׿������X�?p��u`�<%#��}Yٙp�8��f?)�WJWs+�u�Lt�� �7�H=�7��d��?�����>H9^f&ȸ2���C�s7O�#�~���@N�M`rO^?^xgI_�0�q��~2L4@�n��{��Vx�et�a&%��mo�x_�1�d�����Dw����G�oj3�Rl%}�gi;�g�r�V�D&][�]gp���l�i��ahU� ��?�����U�D�[
�C����S#p������|l,��������=�t\�5����P��|Q
v}�x �8+
�|-˴�b����:�OxTLԯ���h١>Ma���H�&��4 �d�  \�~����Nz��J�O��0~(NQ>���4O�y�[�4&*���B��f����S�g�jZM�]j� !��0[$� �xIw\Ob��0Ӎ�A�����v6����;�K��C�q�ī�Cr���+J|���/�����T��k;�DI����)���S>z�h�<%��s�=�r�(L�X2��Xi�dO���߲��S>����?��*i�V� h(��K��5�gy�t���Eɧ�/��bE�.�{�Vs�׉�����$�@oU�F��%��x�#Mn�|�jx_�RH�f�;���|� ��H�l���<ĳ7޶�l����}���D`.���,ɘ_T�$�APt$�聯����F�9T8w��r�~Zp����b���l���i=�̜Z9@\t/��]:Z���������a����	H؂��;�e��\�r�Q!ea,��y��P�Y��Γ���zȪ��˭E*��[z� _P$���"I�gۤ��,���X������p�����C$#}��RT��&����@7=ǣ�*x�
�A4C�f�ė�x��A� h�m�]���K �mT�<�CF�~�血k��iP�=�U��rIg*����x�"��8��R�h�/�ڷw��4�Mj� ;��  x��H�\[�G�BH!,��iO�q�,X�M7�ϩ9��u��ū��c�U	�V@$�P,��4'�YM��]:7R��?��. ��]�Q @���F(m61�4�g+I#n�r�8��g-��O���^�)���{~�o�\�� ���r�*����}�0�"�=���{T%����'tE_�'�-c5����,�՞�׃��w����Q�7�G,���0�{�7���s�Ei�����7��p�-��x���3%�ʀ>�{��EEec�x���JŹ��&��+V�I-�x�]�)�n��*�R��8^�}<�U���:@�Zsf)=V�Z���\u�B��w��$���w��L���W��-�F'�^=��E�M�*�F��V�~�7Fs��^y�������'݋�p���w��>8Q@��3o�^nZ.�Vo����a�~�kϠ�ߨ�G�_��Lx@V�6���,l��;ݦ���e��o��4N���4}�Q�T��8�nR��*��>�D��+��"y��		? ����c�K�߻8=����[�lE��Vq�*-{�Ѐ�9��4g�`�(��B�ڬp�	M<��1b��.|��e��G��{�uw�O)_�z�����E��ss���7��!���(*����։���!�D�9*�IC5kw[J��[Cs]��_�Z�^��8TB��_�VW��K�d�'���E�po�o�tl����`��z��R�`���t��.Y��q����m��qA�����(#     �UN��D.~�/��|p�J2U��4f'T�{��r8�^�^2�a��� �[@�^���{��g���<m�^�%��&�)+����֢���{�QG�
zX��p�R�����OE����#�N�{%T>�g=��~[����Zj�:��J��70lA68�(�2sp6[;f!��=V������`����! z��J5�!����M�0�����[y�E�H�$�Ljb����F�0�؂��,�˰;H��\cAnv��7Eu�H=H��\$Uϻ�S�B5�\S�_����:�~��a��O�*�Pu���v�9�9���	�"C|�k;;� k�i�Y(��D���%v�y�g��F����F'PM�M���8]�㧼�]c((<�|(�胆]u$��0�0߷��E7|�䷨��J�E�j,8n�/Z�R��18�^���L���ΐɺ���ūw���ݎ}ֻ��];�|���%�y�!���CҚ��(Pk�f�>��������Հ�F5�~�p[��w}�.�i]��6j�G�Ii!��z������������R���Ms~�u��v=,f��v$������]��<�4�!UѶxp�Q1�y���z��E�+��>l�%NkYf=]G� �nO��ap.��ց�5O1��]x����=�����l[�T �{������ͷo��K:������Z��F�ђ�e��a�sV6�T�(�������S^^��߆� mCc�zl�n��~LcJ�`��DT����3��^��w,��p��IJR������HeR�}ܽ�U}��ػ~�������7�HwYh��)�5�1�<��ņ���+/�����mGǃ�W����pN �Y� :ӧ��ɷZ�nѱ 7$og�8 o����`F�1�Փy��u���m�l�(M��2�����P����k6��: �i�CB_pr�}���/ݍ�R��'�(#�E���)�獡#�݅
Q�"pQ^[���b�J�b�ү'Lx�*iv�1���w�+��d؍گ��t<)��9�N��_*�l���)B��Q*Ꚅ�����3� �|o��iw�0a�A�'T��H����)�/V�P��pk2��0W� ϣ�M�@��H�Z�������L9�V<�"��>@d��a��F��_,!��c�Ǟ�د�!�նcCK����d�b�/��qvt*�]��ki��8�>jd(��Ύ�$f�=�<KAg�H1�uX�A�3�V����u���+�~�q�"��Za?����v(��6�>�1�ߩ:upb������t�+����2�c��i�N���"�U{Bg��<8�cIQ�6�4�x������cG���x~�/�~� �к�HW�-�q�h��E�nM4�/�;x5$���Y���*�7����mU�Q�"���>CM�/@l�����|c���04V1�D����E����l�7�����K���`��Z�;�Ц~�+ ��A��=�3:g����l[���_txFА�^���.����C6�^��:���ӛ�7L��E��&S���`�J�����Is�GTE��
���`ۺ��=�G|ؒqԇ7y����o�����b�\L�|�L��A=M�]�fMy���@(��5��(m��+P/$(���E�`ϕ(J�_A�1��,-�������E��Q���ë�TYwr 
�7�!��̌�=�7�W9Na�y�j։�Sc��O����T�{����׿M��x����?��U�K�
Y5��X�"9���{��ѭ՚��itu��_6�28�K�_k�:�� ��zN�!l����v_�U�?S ~�<����{O��y��|�]����;^s�u��n��<�[24/��_=������eI�5�Q���X{,��R��� b!;��W/:�bn��xu��L�y(ǰO�|EV-�S�A�ɑ�F�#E����3�+�ɪ�=�����w����6�~Q�!��\�����2��h��+�i���E<�G�M���ǋD�_q���ȽY�J��"ϭ����o'SU�7��{M ���.�\e�c}E��+���#MK�����!�F�hwV���|�@�P��_�����1[+��f)�����2�!|�l�0�n��ƶ�S$- ��I3$�謒�2���C���<%�@a���(9���8�Иmܢ� �Ⱦ���Z��x�Z�'�i�˧U��*�Py�J�#y�d�Z�2}_~�����8�AD:ZƉ[i�!H���E����x��(��1��k�D),p˒��0��"���`��i0�7����޹iɀ����D���=��=�A��"]�-�["�o��+f�2����%�1R?��M��|��Fq>ơc�,w�R�vP(@r{���s�e6��faW�*t�B�l#�ev��f����HhИV��S��10ʷ��Q:ߞ&�PlMT7?D��Wq������W�iH�aܾ�p�}a7�ޥ�d9z�/��_��pM��f`3q+qxI̮KRAǡ�!�����%�x��4�,t����}�n��% μ'Z�+���#�_���/P�Y|���E����j�>�p5=.���!�_bl^��d��y�����f`�l4v_&)sP^7`S���Q�2݌d���~�k�}א�k"8ͶhBݗh�����/ ����7��Iq5Md��?�e��Kbi�>����8�mM��h� U�f�u0�8�`y�y<=�2%�i���	+h*�^f�h C��q�ܚ��N����YI����p>���w�H������]Ʒ�X&��w��T�X��d~����m�;�젌IKb����H=�r���z�E~���h��S3�d�d�ԝ����Q��I�y�����^�hZ@Q�f8	�
q�K�~q��Oc�h�<��c�����'��4�=�����]$���~���E'HC܏GWI^�IÈ��CJ|���b_���;y
������\{L��ո�;qj��h����xU�Z���NL�]9�R��!@$�O���1��]��C��,�׎�L
c���9�����xM�KE5�x����j����J�{�y^�=��a}�+�V\R�l xǗl��P���K,��e�����9&��}��'񰁃</=�8��g�f$���߿����g{_Lȭ�q�?<l��)#����Qv�|�1�!�b�x�l���o��f'��a�}^MS���{�X��n�^���bb���0�/�i\�����E����
~��'��L
�s5>n�5M��ѓw	��2��J��0��I��u���&�r�9ԫ�+	�$��[��|��NJ���JI"�������,������S����\�cR"W�����G����Q ܗ!��%/��<�\^jkq�5�
o6#g�%r �*�z�x�dM��7����<��e��+;���J�(v:-�ъ��=U��9�q�|e�HZ��'�F-��;���v�F����g!�en�ⶽp��ş��vc'�����-�WF�,���^��=Ry�]����S�	�O���*��[p���_�:wK�RV;|!
Z�����n�B!9����������
����/�%����$בϱ6�|S�_�G��0+���?i�Ӥ>��C�P�
� �!��e���H�|�Q����C:��m sZ�����V�ѢX5�`a2��H!V��cb����ؚ���B;�*/��*�WA�CG��O�q_���O��x��}��L��G0-e|#�,k-�D*�
�=.4��g�zyI?.��l�b��Y �'��)@$Y%Z�e@�M�b�l�PWhF�� ��r���XI�n��:���lOA5�b�^;���Xo�x`�*f�}?'������B:7Js��q+��i^�!P��NP��.���GM+���JR{�mz���}/ɲV���VK{� ��+o�[b �� c���M��|i�ł������T;����n����pL�Ҥ�����    |���b��{<]�TӖ�N�zkk�xJY�qmh�}��䮮2�\�2�� ͈ҿ+�����,��:�p[����!x�$Is�OQ;mGuyY`����ZY|��JY���`�\��ܮ���g�3�1f�r�����֯��ǸTD�a��k�L��1�0��Wf?����٨�I�r�m4�\.~�lS���>�_����+.�=���6L����֪��m�[� .���;�!!Xg?�%�y��P3�=)|3���}<J�]b��3Ѐ�H�(���K�v�񊀷���s �C�+s��>~J�D�.K�￑�n����L�rH[75���c^���9��3��W�G	�R�'�UZN+�AT�b�����T�������e�e� �B�__��3��	F�Uy�w��~����(�f��g���x��2#H��f�����S�P�O�Y2O^8|5��A����AX�Ƿ�)S� ������$ o[q�>�X(�fӨ:Z���b� �};��(%r�+�Ni��6�/�UNi
S��1EG3�'�S|�x<�߿gsaD��Meg6����'�6չ�'�b�m:��U"���yg�N����
�݁�[`k�:^�/9�T{�����>
tX�k�i(��^��U	��H�ݲW�Q?,6���*�V��Տ�����P]��~�q�a41��'�^՗#���ܷ��qe����v�nv@�m�Aw�W��M�����~c!�FN���?^�Yޞ��y�!o�#��-Տ��ҭWӜ��ҷ���d�J�)�M�f��ޥ��+�����F���)�fϳ�X��\��IKG�C���c�<Y����\b�3�]�$o1��9��\Cx��ȴ�,�۳y5c��1�?�K�-�>����Y�cZ�+�2����t�C��3Xy�.1xK����ѝ���67Q+��x�.�kM1hz�T�e�a�q���b�l*J��6���U��S^�V��64N�yH���\`�/ �Rj�_�{,�]�E���!\\���ȹ_�n5���z�;f!z��Gv �M�E���
�[��k��q��Th,j�/���}|2�ԣl�-kݹ���1���m�$(_�����)&����r��W�6Ρ�e]Ԭ�!�2�\'>K����v�	tKui��w6�R�������~L�Z�M�-��4�^�d� I���p��+�B�2I�͜!4�G�S�����5U���� h�P
H��Á��G�w5�A��ZB��Ǩ�*�!����O!����(i�(w��4[~���4�P�,�<`��/��u:&��l8��Q6��"����+��ʱ�N��׫�
@���F�h��	�yK+���4[d�����_\Sd7�AC諾۔7pPi/Q1���i9@�����&�qz���nX4M�_����x�I�1x��׳j;o��_�/�����{x��|T�ۀ��y�/)�a���Z?w0�A�d-[j)�9���{������1oB���1N ��S�1F�-X��P���T��=:a�G��-yUE�p��	5��޾�W�*V�e�LI�~���|b~ #�m�â�b��k�Ֆ2�d5���q�Z@0Y�SncN���0��|��J�Hn0�[���3.F���*^��ʱ�Hc����&!��M����
���T>�t�Xg=k�f�h�~�S�������0�;� 1���l6�{�K@����q3\4O	��{���1`�Cc�d7	�-��C��|�7�]$z����ym��[TDC�7��޸0���Ox�Dl3��3�k�z98F�f����U��L�t��{2���v��4}O�q �B����P6��]g!W�Η��KMDǾ�-���_�p|����U<�r\���Ei��ʦ�?�g�v��0X�"��RU�1��8o͞g���[���آN��<&�>ǋ"p�lB��u�N��h��C��� 92�>a�:M��\;���ϟ�o�c�A ����P� ��;Mw��{W��$T���7�.8̋��S����F�m֡����Vu��ry�^YU[%	���bw�v��y�\�C?��r�b����8��"W�[���JA��r[4 ��em��9�wO�ó:q���e�����BU��Y������CQ��*��z�k9X����e/³�o�����p���v�m�;V�-���0:�}�5�yѨ�`���he�g������&4��Os�B-�̐�0�|"�{uݽ<�ݖi%[��0��{�p�pYU�j��z�p��_����a���7\Up<8����`������E��~�θ]��ͽp`kaC	�b�f�O��㛫�5�������)�����k1Oh�f񒒡�c%ޯ�h�O��R]B�����H���O�Ծ�G�j�u[W�_��k���=��I7�Pi�����g�՛i�
/T���~>�uq���t��7]��C/������š+p憊E�I�:��r�5�e{�*­���b�[�"�ӏ���`�WSL��J6�\�&p��Y!3�ïW�菆:�6��23������L)UO�O�Io�_uG�0dmE�+F��"�1����MŪ'}�+���8{ε���{9���o���%:!���Nzc1��̡�ZYq
��b�*�pҺr��栱�έ�@���m�KA&�<b�=�u/�v�d�\��`����t��gw����ۥ���L��dR>�#��Gy��sV�+@��R�\}��߮��¯e�6% ����0E�c�E��i�WSDQ8q( 2䅑�wQ9��G8�
���mP�lSJ�!ӥ�����6:���hV+"����O�Z�{Ъk*/{��=�/x?�].h?/�y:+��� �x�^�hX��^e�^ `Y��E���ӟ��n;j���z}�)a����7	~�/���v�n��	|]�����iٕ�������Ų*u(��!;��,z^�Z,�%�ao���4�e�J���a �3��X���Y����L�K�y�����b�6��^��7�?5�F��,�,~�w�m�[�����P@��Lɍo|�.��~G�Q?���o�Hq�η:R�?����~�1}a�����n�s`��1T?�߉��`�FAL�b��l�p�}���L�0;�K.tbpj�����3��-�1�%݌��h����`xa��D}�X&�'����R�d���]X�L�ju���34܏�^-v�.c���G	J�֧yw���L�Tq��G���>�׀���<���ݫa�KtV�6�[�.�XQ��/`l�C�S����{�\/�l��ֽ��H��7���u�&��gN ^� �_�ꮠܩ:f��6��w2��j��	���}���M����H��y�Q�E�f`�;xC��� j��`{^#�@���� ������uj��^��� ����o�n��&b�d�i0�G�����*/�Y���5.�(,(=9�<�l�.��d��~LG�l5^/�#8�;(u0G�˛���x ٔ��/"��z�[�C���`����.�=�ˍ}�e�ȶ]���Z��"����5jK����p�A��N���rf�2~F�߈cG.��V�z���������T�0������� �t�Ήv�b �=����Y2����_�[�qg�nH��G�K��{�����ہFfB�d��e���̔S��kR��w�I���V�7�����^����je���4l�:fnL���q����w�C8'�9N�D� ��FT�ï�C/VXL]�� NuCQ�e򰊿g��y߶J��U`�~>ƫi�L����$?[g�F�`(�=K�y�i�SI�K�{(e��5^Gsx���Fu�&�KC!� O��!�^�`%�#�j�PX����1�]��LS\�
:G��k�Eа�[�kio:��x�J���$ΗDB�<St��+�D�����;��_��hq�#�iP�dƩih	�0�aWI����%r���o����s��AkN��w��p���}Q�&���Z���d;��-觋�,�    Q��������U�k��PJ����2c�q�ł�$%�+��d���8\��Tq������>阜R`�-�]2�NW#l��f�vbB(ۙ^)�!�o�{�tOpz�]�t��'D�rO�p�N��q"$���6uSӐ�4
[]�-�h�����Y6NV�e�����|m���9���~]rL��$��>|�8%��i������r��B�)�a��:Y�܋����Ky�Y������#N�N�Z���i�� �B �,<�hP]���>�
B�Zؼ�s�/����$܍���@�Z��]��C��/_�qˈ���I�z��V\*}/ԛq��3a�6��&y�����ӆ�Ѝ�����OB<xѲw[&�~�Z��֖�h-+[�Ȧ���% [<���Z@ۍ|tfW��2Mfw9�u*��ܝD��jQt޾.:��nI�޺�c�D�V�� 	�X��Q*�� e���8�íFf���I�*��g��x��<�qK�'�O�)2����8%܆��9�5�:�b��;C)6��20Hk�U?�u�aؾ[�$�:U���F�c��� �e������k���`M���Ӿ�_&u�@�6�d���S��g�|�$(�Q�CT�YA���9mf���iF��Z"��]��O�m�5�K��wh���!6e��͙4d��2FZ�~��R�$y�q7fO�JfO���!���,���1�@J���:;��#�"���v�n8��.�Q6zHbL�KRӒ�ઋ����S)���c���ڢ+�6�b�JT  �|�{W�`�&���	 �����²�y�x~JG~�q
_��ʷ ��A�2�D��9�|S���F����+��}�ҋb��;ekR���X��}��[N���y|� �6��}2~^�<�k�:���}�_�nd��!Ď�	@�0���
�0G1-��;b����/ ĳ����r�)�^s@k�F���f�M�y��foKr�(�eNS>�+��͓�%�@�y��2��+l�Yub����^���^�u��wc�3Ԯ���c����e�ֺ���^�T��,�')5��I^��JC�%w[��a*��M�>��E��V+���3^xU��`IE=.��z�����������q*�D�נ#���7�1>���\Hs��Uh-�,I��^�����n���8��T*AQ��� ��pd�4��Z�(�xQ�k�<�o��A/���Mg��*�aP0$��,�V�T��T�����L���]���8*5-˓	:S��p"҇��}`o'-��ں�]�x�=q�x�7�c.�h���YaT�@!������zǫ�%~�&Ip�-Ã5�P�y�o��?!���C��2;沉Ԡ7�x�H�����r��2��'�9fT�2����Xy.n!��4�7��7��÷ڈ��t�P����@����ˆ��qc�5D[��Kga�)p^n�a&�D�R�.�#�[f�t(��sDi�$�L]A,�CJYi�=����	��l��xv=�J�.��{[OM�q�CF{�d`�����<��q<�9%�#{jM�д���H珞Z�([�g6s��E�
}���(���,�$��-��f�g��CB��P��E�H��l��D�1a7n@\��3q�<b
��U�W�qr^Zn����R�qQ ��B�t�Մ��ڏ ̒	f����SDpH��I�<���?3�C�Z�.]x�i탙��`,�w��sn�ث�ǡG�cA%qF�1y����1���I�q����H�:=	�}��Y�������o�P����6x�z�2�Bc�k���s���T&�˖,z�
�f}V�C�$��{��:Q�ѽ�rA�_�GI�<��X��^I5O�Bf��W�K�vf4H�n)�����p�s��T�5D���Zq��:k�����"���"�f�1npt�i5�*~���#�@x��.�z�W��z�UU�F�]b?���"�`<�����*Ӥ�B������IЕ!e���	y��R1�Pj���7²ϫٜ�y|�Z�v#E7A���c�<��_�b���Y��P�ݥ�"��
������a�� b]P�<�\7��Y����K��Ғ1��i�|\��-�@����<#��u2ַ��Tp_�)�D��������M�-�üv�3Ԃ���ڑ�Cb��?������	�ha	��D�f��@Ɠy<J�2:�,:��<^�H�-@�`���g�3�7l��o���ӵ�B1�w�Dċ���:kQ+t�����t?N��f�����j��8ޭ`Y�Q9Ɂ��A��E�C�����)��)l�I}Il���x����������[�qfDA{��/}7 b����^�(΋1�:��ۻ�Tb=#����THh
p����ހ#�lI᳢��x�z����r�%%/��Nt�3QaQ��'��C۴�Q#\wv�N��Bw�����B�\�PZ!�\lZ�t�bqn�
����PŮ'|�'�k"�޿�GO���s��ՈP�_"����i�=x��n}�Bfj���ס�-�מ���߻�DÓ�ՠ��N��Fov����b3�t[� �eTg���|
�s
c7t���I/jw�=�����l�<x��:���p��h]�� �	{�"	�k�.�����~/��[u~�/&��	���O�w���N�(�m8�M"d�Zv `(�;ۣ�3x5�nw/��nG�B0��ػ�̥i�Om�nǦ�p�r��ة�ކ� Nq�\r�yv�,�f6���F�)x����*i�������1�o�8�s愞�\w��T	�E�]2��&?t�`��p���"��U�1���I�1[���[	; V��t�y_\�Q �����?Fϊ��2�'�����^l��Q2J�w����u)D=����� i?��t�{J�<"Ѹ���ʝYva{������I뤴Y���9򚃊�Av��>LCƣ����G������o��$���i=_���C�ץw��Nt�o#�m���WP��@�k4�#��bc�8~^���u����N�g��,F`,�"�A1V��n��h3�G��b���dp�v�N�M@]j��-��Tf@�YY�N����l�6��B���bѣq�N�6��UO�SZ�lo��'�,` $�q�p+��H=�#��?p�Ѹ�Ｄ���B8�SQ9����׬\;Y��<��֧�;%�����w�w���$S ���h���}�#�h�E���L��ݬ-+�P�sc	���}�\�4��TB.�.?���^>�vvW`]���
W@,�:d��e��}�����ɂ�YV�+�=��70�ڬg �f����)����n��>C��l�7���{"��wg�b�嚆�4��$�5���%ĵ���]�K]�fh��>��w)6��kς9�	V�����#�s�������l᫒�����k+���.[�Ȟ��C���� M�w�=>�������'!�V�{��e//q^�7cOd�	���/b,�����_���s#�0��!T�A�n�һY����AZv���]��F��Z�0s��X���? ��t�<�D������UW!���`�Vw��pyF�8Zwja�N���w&Vb�~��Sb=�I�4�B���׀�p#
���Y(����9����9[��(x���ZK �/��Ӡ�nU��!�.H�E�=�X��{�W$���0�#�c��
�M�ѸN�.ܒ�1jD3��@��x���;a���B	�:�M��(~\�y��/�h���m�� �6g�j>Ne�CQ��ĽA5��������S���g�e"������Tpz�QsT�%�b�8��':�VH�)O�|�
��ߩ�?�9�]��m�������=�	�Zû[�j��5L�r��-r1Cv���5�lB���.�R\��>�۳<�!t�8��t��[��w����$�a�O*��eF�Y��ư��MA)�>�F�a��&��r+w��_
ƥ>��R& U��Ҥ�ܞJ@�k���ƳR�0�~�%�2    Ƨ��ι-0}��)�� 6��o���ƹ� "�C���*�6U�Y~�ˤ�%�'��
 �X/���x���|���¼��]��MX♖����1�]�=�����+���b�8.@�Ӝ:ؕ�=N������g�x�9`j�!2�
�}�=í��H��Y> ����޳�S�f� �˱Q�n�Ì���*m���`��2�n�Ԁ�?�u%��@�c»�à(�{���1l��'U���o���P vx�D`٧Wg=i �p��1�B�UC,�����l?	�^܇�A�ȃ`��B����j�|E67�M<'X����g�pBr���ytD����v�Yl �|��4�Am���o����q\�p�غ/z��&B\�c���˓9�r�U����}�Q{t�fw���G�����H�[B�i��Ǉ�nq��D�4�I2:�������y<_P��)�����QZ
C��V�1Cr��1һ4�P��+e9�Pi��
����?�3:ԯ�=
[��ߏq2��ˤv�nΐ;>���c�Փkʭ����/��Jo�y`x% 	E�2�N�E��e�ރ�m$%���$^�27�kj������8i�<���6DN��G�o�dJ��6(�Gu�j#��b�����
����k7� ]B%�f�v�<~��h�u���b�(ν����:+ڒ,Z��;g�qjY?�lqnt�8{Q�f �P�~i!j��^L�B�Z��9ܘ���}3-�-P�nAږg�����[Q�%��q:��u��������s�AД��zp��/v^�������˧�i��B#jdnn��4��W�����'�E����+l m�f�U1oU��½�K�7h��;]%96����p�[G�q����(Pq����[n»�����%�S��d1�������03O���v��sJG<�W�4�c/L����3c�N/�9�����o��/8Q�¨�Ը֝vC�q=5��Ԑ��]@���1�-3N� �#�:��Xj��fN�g4w�������[a�E�0�KL���%��!��P��z[��t48�������.k�$n�}�h�Yp��^��u���ĺݨ���eo1˜�Wy9v�PS�Y���?��2�N(� ��V��a����x~�b���A�_�GOH���Ѕ��p��!��5"�(+^���^p��`����4N��x��P7�F�v(�т4X'.����"8�.F�y�4WB�J'TY��8�Y��dp�fs����CPo#�[�C
>DpU��~�q鷴Y�B~Yҟ��-xᱽ�e�r׸c�˸Z�ȑ���x�	y ��.��N���/8����znG�n �h1ك��(��L����ې��p��BT8�m��Up��NTl>h�\�F��u'_�ԥr:'��!��2E���Ccg�)��	�p�5�oao��(cZ4��d����y��$:��6�o�f�Z�5�h�&�b���4��~���9�b���� �
��j���9����9��.�6��&�U<#�9�;�5*ţ��/�#c޺�� �XY�͗֖��e@n����~�}��/���}�`��E�>[��2%�UM1��Y� /SL�qF��(F�$
x�k�r��1%�ej�PJ���}�����(^���t��cK��բ�ȱ�]I�r�*U�F�zW+�=�}��Վ]�D��9[$^~�<Mr8y�	�N���FE�쨾��L9s �֫���A�d-����ӸycEw!sc��Y�^q�Y@;G+BߴG��Y�N�&Ւcs �jl�1Yxh�XC��*t `E��ڥc�fS{�K
���qʄH6Nr��@��C����d߇��s��v�Ea������ʤc� 1k|Ji�����o��R�^P�l�K��}������Kd,��8�B���`#l�)y��ұ����V'�
�5O�>���@���4ͳI��ʱ�p���!
�O	!U=B�n3�1`lЮ2��ɱM6�Ŗ���+�O ���#��Y�&�q#��<b:��Tm������.'��=�Bi[�'��~� %Q��-�A����������_*�S��#�o�㵬g	@ѩ.Jǆ?"�8_-��8E�h��Y$�{>7�� ����y6���lP*�ݚ��>pi����}Rr&"��1B���Y��Q�+������C|��|��Dtcg���<^���%Cf(*cJI��d��#X�5q7��"l�����
=��X�O��Tر�O�D�y��S���Og ����i����������>e����5��vNa�
��䭲��+�i��j ��/�X�����'�99 p����g��	~�d�XdMh��=�[��c\��L�pу���E��N6�V�Y�93xb���q��4�����C
~o�m>�����+E���?�ng)��
׬u�(�)�W�ӌ�<Q���-�!�b�B4�J7R���*��{� L	o�i�^�������0�EI�y���?�\��녲-�8����
̱M���q�����X�� dq� �p6��k?μ%���v^�����+�,րW��۳x��b�L�YeVP*7O���t���	�+=��{]�5"C�g_��x(�\��ܨ=j{}8[Qta�M؍��tWo�S�gI�I
�0o���-�Q�]~�Fs�Ǚ��}s�R������
Y�$�G�Ё\�4i48Kǎ����A����\�����A��Z��b����O1۷M��&��v9�D��4{L^�٭G��,�$�E�7��X��~�wQG�=~'a��f��Ux�]abi��d#O��//􋦋�n��f�1{���uKb�J�&+̸ŨS�v�!��������;�!�2p��$0�johy��� �].�z�q�v�h�Z<�k��bA(�����~���Gs�U5���?�W|͟A90�-�PhO���N�%$�/�Ҝ��࿤#ܓ n��;ʬ�.�v��<������� �ӽҭu �U5�7E�w�}�r���su��ۀ;���g+��3V�&��I��У�z��>��a����|Y9wV��G�cm���������.����H*>Wd%9͡�B +o�R�L�ˇ��|R^�H5B⯠�
�]�� nZ���ͅ�ǰj����;�RS�ݍ@*$���C<�{W�<�`�f8��A.�y'~�9�=h��F]	hR�Z�{@e*�I�d�g��n���Dwщ1^6�%/ c%���2ђ��MF�M�+4����y4F�ep�i:+��s�����/�7u���jK҂�ۯ}���Is��qH�ׄ�qq��_�q�n�U��[Fټ���$�2�4�θu��ĉA=�7���(k!��~THe�T v�u�9����E�l��m��̉�rQ��n���0ΐ�`�I��������@��A�ު��;P��42k�s\�h!����d~P����D��!�J��U|�]^��nZ�B�ln���t��������(�>��h3�m.��T0�70+K��LEr�9����֍�Y�0��V(�mJ!+���K�6l}�L����蹍�fxMG�K}TS$��Z�ÍI���7%l_�TH݄kЭ�<�W ��!m��[�O�J�-Ŕw�M����?._����:����*��"��~�@�솛G�|_�iݭ7($"kc`�oC���|����˂�}��S_���z�B���N��r��	��b s0������e�2BH!��,,������E�RYQ���Uv[Ц7_���'����2��椬��`��&����\Xcx
�����dޞ���±E�4�� b�X�y@9|/�D���ƴ���V�lp\n�IqYj�ê�n?!qg\���/����퐸��$��z�����e zi���n��D� ��v^��_�125���&�,I�H޹{[�0��`��M�����%gQH�U]b7w���6�������S�@o(WA\��G65A�O��B޼�,�:xBTndb!�c�d�+�5��>�N��^S�ˀ� �  o�7�5�œI�m{��o�����Pw��B&�X���� ��O`��kw!(� �����fu�������T��x�#pU�J����zn-'a���Kp�X ��X'�C5-����y2Jn(�����Kfq�X4^�[_GH4���^�4����+[���.cj�@��7��wѡ�u�~���m��q���/�]\'�Rn�'!~�#�02�ͰZa��B��A�O@�vH�h�C}����B�-���cZc��Zonpx�^��|�$+ȵ��(7�P�7s]`F,��Ѧm�L��ƔA�%�$;�����H̍y*y�#܄>oߥu*z�FF��y�wd�����?����!�ka�=�re��c<�aE�!�J*�3V��;/�����s��7H���x�൅���W�X���D��I��! �ƌ�	�2ʃ�X��\�Q�T�p:0��m�1A2qt���Kh�7$��N��NS�]���� ׳�ot��1�!��<�58��d6�2��v�le諲�by������Y\���:4v#
eч��g��~�'w���.�1��D�q��-�0����^|ZC�!��[�Q-�VVfy�2G��٫s>ʍ�%,�2�� =L�P��Ne�����1���)7���}��bdDid	[p�gLO���6ԍ%�.a��IHD���2����`O6�-ݪ�픇�Ҵ���M�,�\��[{on�a:l��q=��;�b�<{zl�[COH}P�q�˫�8Sڵ҂*��+�w�e���n6cmR"��U��M�� ����]�8��v��F�]��8Uy��'��y$n�jݳwؑ��+��8O���%��F�~ζ-UZ�9��[$k��c�}My�l5_���GN�d�y�/1ӔT�ö�g�xp<\�*/���n���yvG�k�ӱ�E�c�|0E�����A���.��$�*���ޅ��=��{|�ˀq�ݽ[1���D��)h�V>-u���=v���#� 'g��#��u��EH�g�&��%!zj���]%�կ�FZu0S�0j}a<DK8�a	���~Ên7�$6� ZX������G����O;9G}!��7&
��p�0�f��!܂
]�.�{�E���O�Q�x�k��pq	����8��L�؞�E<}�Ɩ��վ۵'����%��8��iUdp���2�"8|'BB����8���܎�J�wE:ֹ�A.��1^р�+�i�е�:��+�L��,�,Q���pM�����j���i��s3���C4�j�
�~ߝ�m�|��~��s���8?�f֎�1�7���0/��?5"�P{" W6aR��V���\��غ���w�X(2E�#M!<�S搳������W���΍�v,4Cw���:�1�`���H�,�rQ]�A}w��@��ֹ!sP�p4�6I_�{� ���h�B'B� P��v*c�D�@�,\��"���4(G}8���8���м�L�LYqK}ٵ�e&B�+�k8V��c�E�7�d���J���UH�t��jz4wsYD��9O��������>@�5��$ُ�q�o�Z�.� ����C�~L�����"V��3!�|?sZ4oh�)2d�M.�֌�2�g�mc�C;��8��!lFve@�!1h2�m'Z���R	�+�XX"1\����e򔎖�S*tU)�f�C�6��D�R�)`�π�;֛Xo_3����k֕G@�S?R7D�۩|����FwB�f��������>�^�(pX;Q75h�uM��@�C q��n3\�x>�0a�Ӕ�F.j�����9⡢=�?gO���}��!Y��뵝-�q^3�n��!�3��	f5�/g}����>;pÐm/(C ���[p�)�Q��P_�p�h��[Ϲ���?es�Ϧ8���/�v[EÚ�+dވV�ϓ�c��W�*�����)�N�<��Z�k)�f�à2�Z�'���T^�{_̅�� ���ʊ`��cc��v,�Ev�.�{'8"N�0p^�L`h�����,�@[Di�m�jd�`z_���u�k���`i�����w�������Eo�+b����L��8�[r�G�^��D����lpmm���2 ��χD�p�r��Σ˛�Y�vv�\���6#(A7ĭ���W�ww�W݋�U/�]|<�D��5��O���>      �      x��]�r�ʑ��+j;�����!DB�|�|h�ލ$�jt� ��U��?�K/1���яMf�$@��$�q�%U@��}�To8	�S�NGb��'�7Y��$�gy�D�x���`"~�k��Ag�����5�����w�FC��sh���޵Em̡mzh�9�Cmk̡]zh�k���Ue�����,�ҍ���_�XF��n�<��PϦQ��6�+���|��� 8�/�c�|.RbM�e.�Ab��/&Q�/�_9|�jڕ�h�a��GÀ�e��l�4n��bM�٪��ˀ��_��v?�'�l�t2�|Ӳ�O
�i��)�J>�",�����l�q&&��E��?��r<��m}iGE���ZOӆUP&�"�6a��4��u���;�di��ĳ�dI�7�GR��lA�_����8��D��D���ϖa�|>R�XRR���sT\$9���P�+���_���x��e���ϥ�����O�~ �V;�����`C��|����uP;� d�شD7����=��֍�h����v�Y���F���<����n�˛��RU�m�%�d;�i)�t�L[�,OU��Qw@���Ji����h�.w;�`U��G+����x�J�V/�R����p�˓����V�/�X��"�TW�|�j�Nʅ�r�4�"����i�90��4�;��6��:�T�|7|�)�G�4\�Nn�4��tGc������02�`������x4z��'���Jt�	�Ӡ���v�2�M������'�Mc��04-�+ʂ�Iq�4�9�A`�����~�;�������}�r?����?�?�n��^�.��ތ��Ip;�&��h�������=�w������9ɯ	�I���߃����]_C��&�1c�;�'b�h{G��)c/:��q7����~U�~�O�dVP
3��A�m|Qף[X��OB+���ФN��к���l��uf�Lk��{�`��a��A���$范��Ҧ��7�V��M{�\�H�������m:����Y����ƥ���+��������|[&��1��荄�Z��ތԬ�f��f{*�������������6�%�B�a�Uj<Tu��E�����n��g$z��`rZ���oqyPm���xZZu�hC��l���1Q���~�V�Bk垡U<i7����ͨ��^����{$Z�XL�å�t��i0���������X�̫T��̆��N�N��֟��ƽɠ�+�Hu��Lǿ*w(V����1�����r
t����2�����`���j���+<�{�lRu�᯸C���{PÀ13�/�F���nZ%�'������������@u��:ᘇ9h�����L�2yAW�� ���8kSUS��s����H�͂��*UE����DFB�e���� ��A��V���k�Z[��'Rm�к�B^�����\�{�?��迃��:�f�������mp:Յ����&��kCI-�o��H׈O�w"���������W���ZE��0��G�:�>�|ѡn�#Ƕ���j�J]��p<��k�������Gc�����7��Nc��ԋ4� 6��Ν��g����@�0.c{�4���};���^���w�[�Dʝ�����`\�f����������k�����
&�ѵ�ڼ���O`a0��>HZs��TU�*���y��#���,Þ��0��t�j��Y�;Ce;���c�<I��#^�ʡk9�Q}�iU�*�(�ޯ`9p������b�~����,W-���:��{�����/�(9�����>���t����l+�TgL�١�7/��TuDn�a	f�}|���\�;�9�X��k�f��(4��;����Ӭ7�v�c?��%��6�&�MK�@l+�AB�q�v���P�U�TI=?]����8z�<���H݂�)+���d����hG��(�ܹ�^�����F�d��gR�:A����t:��3͑^	)�5����fS���	(�?ˠ�}�J%��^�XޙN�;t���U��f�!Z��q�cfv8��c*ݨi8��G�H�9i�5��4�������v)���v)��Y��ѝu8�GǨ��w/�{�!pĢT~�?�e�,���uJõ�Ps2�hm����8���C�ٽW�_n��1h��r��7�%0�4C�J�`*�v�J�1i�7���f�����<	`V��h�=�q���2ϐv���j�D�2��<�@�~�)���E��������.��&m�Q�@$L@E4�r�w�0:��O`S�c1�������m���Z���2����a{7^W�YY�W�JIto;���Fr��W����Q�0�;T��Cj
�o���2>�e窋Ɉ��H��05�U����u����7��;Q�y����u��kq���q�u��.�7�=p8�љL�\�`ڛ�B��0�����J���!�E��=��~�7�(Z��ٻ2�z<�c0�U�_�8�޲^��3�
��Z��@�D��c�|��p���c*pwi���M$�b�%w��`��/��:|�����/��n�E�p��l���T'-��MG!*S���M���uh�n2����Z
���K��HMĎ(�C�ȗ,���弄�g��y��O�+�p��,�VY�	*1��0N����Bv`l��=��9U7�o�p=�sPY?�i�啭���#��`s�S��ȑ+}�^7:����Q�!�ft��1��<�C6��S�������3�������C�]�i���]���[V�ј���C�(L�i�\��D�;4����x�3ڼ�^�{F�7s��xG��D������|4�Q�f�i0��3M�[Թ�n���LS�����[;4
Q��� ]�K� ]�K�!]`�
G�|
�e�
Ou�s���9��/\H��Q�R�,�E������:s���g4��ţ%�d*`a��<�ri���)`�fc�-�x�4������i�eb_\�5A�x;ĥ�y:����4�<iti���iI��3�m�k�����vπ�9��I����0Ɋ�:J�q�Q���م.�R���8��\�b�����mВ���4hMG?�b�h~� K�����(�|aʘ�jf���l���xm�=g��5���r��{����k��s�̴�R�����"�6�p���}�^��@Kr(�6���$��T�H�ܲ�,�4�I;�+�ЮTͬ:����95���p��i?��9�K���e��^�4�Й����Xǥ�p׭��pJ�3���N���hI���Nt��M%׃�K�#��߆y��ᵆś�Q�>���h�yk���Æ��x�Zf��3�V�4fZ0A�n~S�_�|)��*MTFJ�.�z#�d����D��Lf�ĥqq��]��x���a!���WZ_1MӸ�L[W�	۹���V��˺�8���0��>�y3%��/��:���`�90��L.~3�q
~3eT|�a�pp�q�הe��z9�95%��\g�Z����pq]��"q����_��&8�i^��-I��6;������t.�FgIπ��tS3k���s�^!C`�U*���p�_�e�y���j�B��(f�w�fk㵕�����Y�^-���,��(���=EgIʀ��P�K��,��U!�NN��I���uo��G�$-;$�q7e����5k4�ͲyY~��Y�Qy� ��5_z��[\OТ�\R�Ifۖx7�	ta��[�}�wA�,n��)�/�S�%��4pk�h��Us�to��ܳ5 ����t�E�"
3�[#��$z��8K�i˗��&J!hJE��E��ht��,�4:�6�l�NSn�<ϊM-��h�a�:�J�Rͤg�/�xϬ%�4`�f��
��X��wH�K�W�f����k���vVv9�A�.�(�Q��Ȥ���*lNP���1Qe��2&��=U�M
�A��M
�A��Q�N����ɸ��OE��g�>j��^�h     )�eˆ����K��d����qi0�#���D5j��ۃ��f]�&�����N	�Ʃie��dL%�DsB֘ԡ�x5�T���U�4gpC�
����w�)�Y����G-�M�u=ӓ��~�f�n����HZ��w���@���1��4�����`:��V���Ҁ:S�h�in���;�̮�N��{׳�L@���Z:�W��Y�%o���1QLn���d��	���#d��!��y�֧�xL�K��YoH��a��'�r:��
~w<�4���zX�f�
���V�x���]I+��h� ��\3FZ��tQr�M��-�4]�˫��0�ߑL����i��0ui\�ˌ%iX�!ͣQ}��Ѩ>��{4�����ј>��̣�}�Σ�}�ӣ�}����>M���=�Ɍ:�F�;��Nj��r���$A��h8�g]�G�T�9oLJНu�nzFzѣ1�sq�G�4�^�����gly�O�FI����xO�Lj��Zf	/X�Q���UV�7����oO��k�,-�ɦ9�ģ�C�Xk��jyg��D��W�
�d���,dk�}�-�����g�*�ap���T�0y
��{;N�y�Je�@G�<��&�W�
Ve���!z�S�cn�^_W�B�PUM��Ii�
����٨#e����޸��U�B�.+��&L����㻹JW�ʝ�=���ͧ��噆��'rN���
���<f�F��=�^.T��)�|��V�gq�-��up���Zp�L�A�l[^��$l��|Gy���O8�N3���(�h���k�x�JOa50�l�5�"[��}�����_�>��������O��蕸�6<��Wa�n�ՁU�a���$�d	-�+�P�B-9���f4��6��8	��������捗X*�z+	Űdw�C�l�ꕦ������%�f����.�%�0o=fO�*0��ޏK�&[	��٥8;����������*7�A��pI&�Gs�^&��D"}���:`�*f`B6a�}��Jwp���FL�a���i>Q��:Y=♨!<����?_��wSK��A��`�U��jq��6]���E���Ɣ�i�e'Iy�c	?�Y:��54���j�u� Z2��4�I)��%��ƣ9M�h��5�;R)I�F�!�Q*�r��Ow����дL�|�A���d�ڦ6ͷ_�i�57§��&��U`J%XFŶ��6��pm���
�0���a;�_������ū����7]L�(��0�#W���dD��.<���G�,"�M�ϤQٮ<���*Wf ݽΗ�t��)��޶��.�+<]����LS*�>�"��38%k�3�n�y�Pk^��v��k�E�y��o�.G�]٠�J�u����z�U{پ>�)�`��
Ή��m�o/��D����\ε�ij?�_�����8���e��@�zg�?�IjxʯnAl�;w��\4��b&�k̅�-X�x�2\�ނb��� ���m�PAF���A1�^��~;��M�I��y^��(�D�U`Q�:~��kTb���Ǐs�B�$Y��{�â��j��*��f��1Dg���#�P�:�%n�9�bp��۹�Q��b�A_����o���h�U,O(0[�?!_Z���Y��[���٧[��Ԏ�<"�S��2�R���w�7���2W�4�{��9Q�0U��0UfC�G�(��<�pTy��Q�/�]�S �'u�ap�ɜ&����B�M���VS)�++�q�+�� u[�W9a��[�;�f�F������:�'��^��:~�Gc��g{LL��+LB�V�6{�Z�~IE�	\�����e048A���h���=1�|�3|����
-{pw:B�A� F�w��l޾p�W�Ze ���o��O[܄1RXu�wwu`�e�*���4�c�e�v%�E���-�P�N�!l~�gP?J���;�R���R,G��.V�q��HF\�I�\Ӄ�m_�״��������\W���*A�!2(�S��/�y��Yoi��<�KR���g�C�,��ۂ�k�m__��>�ruU־�F8x+L���|�w�u�G<�o8o���[d��e�`_�m~W4ڗ�r������sk ��YO��y������A�K��'��\0^��w�V����\���F��zQ"Կ)+QDCp���2Ĝ����}z��W��ᇫ0�u�˜˘�������2T��H����i4��1e���*�Rb�B��9ϣe��QQ]U��V,�VW�~BƸF���A����������N��lWZ�k�����,@�X�˛�]sb�Yx5���7Y�J$v�ׂ5G��Wk�-yZ��*�g`W�l��p�y4\�`��z^����Y$WE\D/��0�c��U�k�%�(LA�y���if�u
��3��J�!�;��������h�/����3Y���0a`x`&����ahZ�c�>m� ��	(`�ZSa�G�3t��q6��MW�L�t��X����k��s����M���yZ���h��м�V<�b��bV,�����"��+x	,�z���B�0J��F8�x�Zd�aj�����a��xD_04-u<�/��:I�u$u���%x!�m^�N�#��)�gPo�L#|�&�n���f��3�6m�oCWR����]��'�l�����|Ѣ�HS6���s��0t;� �X~�y�����"��#0����'z�������;'B&�_=�ǲOb���g`N������Iב�O�<�#�pj8}�q��h���S�S��I�7��A�	�p�!D@�p�����`�*�Fq�g���h�Ȓ�r;���o.�S�eeSK�5Zle�a6[�Ꮷ��I�ԐI����A�\f�FsΚ�A��?�Ƨ��˴*4��౐�*05$6�v[v3m�h|~LC7�R�/6y�����xU���TO�B��ྚ
Z�L�x�E��d�>*��j�@�k�Uv;->G���)�����*0��;�E���F�J`��gl<8���#~��i��ز@R�4� �4��i��i~_Y�؁���0�t����&�=]�A�|n���
��^!�x�j'W�t���S�35|�<��,q��%�wW�/�=j���?��6eٚ��*d��K�=��3ǁϾyy	&��\.z[��k�xu4:���CW��~(&��6]����+�����3�_�l�Ǐ[p�a{�_����7���7F+�#]�#�8������+ٖ�G]�q��p�ծ�%'N�*h��#H��h����q�&����D��v5��8ڄo��Id2��߇����8\Ừ��zڧ�����_\�������F�f�i�O��E�����/%��e�<�NqV���sOu�J[�	�'(5���/嵇����ڲ�ni=!>�]�@O���E4u�i]z��B����u�i������Е��Q Y8�PB+؃��X�0_�NM|��u���P�� �cK���a�#�]8G�I�j�]�4O��p�$�Zx��������v �b�=g��^��S���������I�x ����l���o�a�l�<��ᛞ�U�]fO`���y\�f���5���Y��/��
%9�G��\7�IZ#I�'�פᕦ�P�Z�`�Ʋ�l�1�����T��L��pKS��KW)�^"ncy�n&�16�o�� �[;Nw_[�����)YsT_��5�Z7�D�]0���7�$��*FDW�]޽ˁ��7�-�S���-�EX���h�ݭ�w�����<�j��-������.���O(h��h*��c�"��*�|���c�5���/�,����������D|�+7�9��h��;`y[��k{�(J��ީ��k��
�		l|#����)��t��t"h2UK}KE%*�����3XVպ�U0�����<7�eZ27͇F��9+�5���d�����3x��T�Q1�ʌ5O)i4�Ғp�=Rt�]ml�����$����ȴ��"��i��.g�
Uy~ג��,�B�39�Q��ZZ<$=MK����2�a�5Ci �  �s ���Z��v�<��)����������+U�͏�ezej�1����ᢕ��FQ!�ם0_G���U�K�:���4�k��$I��Β��5�i1S��´�)_�F�*�]Z$��M|4�!�=I7�vK"�we�l��m�vG}�-1�X���P���Yo�͎�:�⩈�,����:��~�A����,�� Q�	��h���Lrk4@�2�Lz�Gu�埳lY���˷1�R+�K��>���%>~�w%Y-N�u�b�V����R+Kp#F-����
S�q>#��W�<���T2�H��054�Բ��0>-�L��F#F-&�V�A��kA�h:Q˹��J�h����xj�Y�ô�4��r�[��:��8}<N�_��m�Fub�%���<�2[E��Y��SY���|�W��Q�*�!7%��Ġ�˴X41�%s�%����Ӣ�^3��;���%��%��
�)��sP�Q�z`��aپZ M<��ik|u�zLM��k�٣�QZd�K/{	�}��r�	ңL�bںwb���ʒ��u��K���Z�9*��t~hNQ���
C�|X<����bb5�i31�Դ��ik<P�V�3�n��sH$���6zS	MB̸G������,W��K(��h~+퀮�ǭ�S��D�6���ueY��%�YXSo�VG8Md��x|w��uФ��Δs�i��.g9�O�Yr��jN�=~�y�'�۩���d���I�s�x<����S�H��M5���]�y#���0>�HU��v���L�t_&����)!l��Byv�`�4f�4��f�Tkg_J�ܞ( ��.�� Ô)�:�3X1y'n#Z������`N���?�u|����ߩd�"����a��^�7��[2���A�3����w��ȴ�      �      x��]�n�Ƶ}�W��60�u#��D�93���fk�%hK2"@#-��_��c�c~�6�VK���E �qf�X��{ժjݔ�]P�wu��˯�w�o�ϏO�z�߿�_��U�?�A�E�]2�������C��Z.���������<����*է�)M����%���)��p�M����K�8�ڦ���{�[b����/�u�'��y��8z=�*3�K�N.ܧ�)������?��	�Y��}<�<q�[aU�r�*����q���,�n3x0��pSyt�.>� y���8nuPm�g/���ʦ^���oW�W�3�~��G��t?e�J�����'9�	������3>V�3�H���fUn.=����4,ʕ�PT�) ΰ��WP����k�^�v������E�4�ފ��ƹ<�0]��{󺟴w��.��ʢ^{N�`ٙǦ\��Ӗ�(���(0,�e���m�vն�����*wA�
	��ߋ˦]pU7��*5�%^4d�~����Q*�j�oy1�#���ɘb�Ljd:�Z�3_U���˫�e�}=#A�lF�Е���r�nu��\�'�͠Vr���E��]�ؿ]n�~�&ĉĔB����M�a?s�jdXov8Ѱ�.��Ǩxf#�
�T���PU����u��u�jcO���O�v�/�����IT�mj���1���O�����z�.:0����+=J����YsX�����R��]}<%r@F����m��Xu��*�n��(���d��]u��E�*��׆���T�r�Ty�>-��5k�6uJ a�L��@�h��z�z���`�:@��w��tlxd�g�muJѩ�m�%2�TA2�K�Rn�UN*غ����!Z7pF�oP'jN�p������+��~&)TC�������##Lk�ǐ��>�I���UH���T�pW�)�������N����l��2�I�D�L%K�h������#)s�7"P�Oۡ_�mA�<�ы`��4�]vF�dd&aQ.���?o3�����U~Y~!�ﶖ��.?��,2�<E��$ؖŮ���ZQ��(�_{�~��tm���@��>}�V[�U���>��%�!)[n�ڛ���zSn�En��n�Mu�ahw�ty��l�xʔT�m� ���2�(ƚe�ބ6�`Ş&��f[�)o5s�����K�Jx�5
u����7���ʔ��b	V:��ܮ�ֲ[�l�/�H�ɒ�#o�5�Vũ��`"��Q
��e� �V���w�:�V����'v����Q�r��p�(��l�Mx���q�2���"��d���K����˰`�.��5?w�	.f�=�l��&`�ΆN�'W������F�o���X��T�:q���%1�%��74����Ĳ�MÛ�O�Kw��l������ȁ�8�k���@1L�p���(c+�D0%\��m�8���������S�Sl�����-m�	�!^�������(���ſ_/�{�H�&H���3��I�WX�;�8���+8��p��}�����/��Si���w��fE3�����4�0�<ܿ�8D�b�؇�g�c"��C2�!b��MŘ_�/���������C��"9��?��}���ه�����G1p�+O���8����*�>�N�8��+xB����7O����ẽ!p��8�P3�����+�ه��Yq��q�8�и>k�>4~��|�k�>4~���f��q�ap�М}ܿh�>̌���#��}$3��b�7w�/ON(��7��$�
�Ѓ|�^��C-C������M��呋;�ˌ␰��ͭ-<�D[H����QG��[�D�N�C&����S�J�y�x���G�z�m�u0�vS=��e"���a[�Bx�^:H�	�@$=$�	te�	1rF
�0V#g�T)|���><��X�CO�mF��@#N� #3<i'���������u�w�{�J3X��4���Y2�R��d�*��ѩǸ��l� �)�}C�!Q����Ha���MS�<q�� ��N-�6����a�)�;���5#��-���/��{4�3����T
�>��u�������vG����~��z�@uY���w4c�=��C �i{��ˇ�@�3��G��Lh蒱�HkRNc�s��4'�J�!~h�?��MP���ಌ�N�������o�u��9v�Ɔ�x������:ț#��4y��wM7�d��9�dͦ30�n��UX:�]����8rɜqY:9�O���"* ЕN���.�	n�o$X�n�o$������ئ9�<�2x�\�y�����s����#��L]d<l�y�.s�I�:e�h���MH�I��S.��Q@�/"��<����S.�b7�"��'�R|p.|�D4�>�AJ�@G8�X_		�{U(�\B0�3	B�i������SI�{�:3�G����R�H|7x �a��]���Q�)Y� �U�	���7�e`�h�)5�;$�r|M�=Uy��S�[j�gQ7W#z/�:rt��u�%5Z(���^��7�GYA$>���6��ܷS�h���ٖd���'%�n�0x��,���ڠ��庱������)Y\+gX�sṷ]�~��p�s�~C±�0�%<W��6oxI�`����E�Y4>�e����K�\r�x3S��	�u�_�ݺùG���˳�G"���G�84�І����Ė0��t��}�E���6G����*:�|��	-�Epr{vX8BnLC/�\���Ɓ0'A�ߤ1U�Ɨ1�BX����{���W7���(a���_u���Ee�ź�+u���jU�'K0 ?�T}��S�#C�����rpM��0�)R�q�`�D4%��n����p�+�3·������Y/8�ݧ9*%�Y� `�s�2Hģ�+>b����e��W%��B��ݾ��!$�:�7"�#{�D]������[������O���0h����}�R�^���Y@�9�~�{��,��01Mj�� ���ƽ8$J���(�������YEt	�zZ��G� g8!�;V"e�D��!�0���ц�`�r��������)^E`VK����f��H`��Ny��f�����n/��������!ش���'«U<Q4�M��n�:��Yq�E�)9�k��*{|D�:�h�7s"�{i8�Wd'Ȣ�cf���F�%��x��	K�p�%h'Qb�C6�LܒW+	 �� �𘨆��#&��(y
�dI��A�4�g�*�#�#Z|���u1V��:��+'��acH٣#6u���:�74yE���x����~|.	Q�>����1:{�x�FJ��LQvP<�^��+论	i0��<u'�����;�1�]M�fJ���L}V��H�i_���*��{�����HX��w�zix�#	$�?�yb�-:�$G���!)���!<���	��e~UX�oy��f�E���J����'��NQ��@�����m`�+���Ch[.K��z*�j!��_$�d���{8 a=7��.Ǿ���Au9$O��2Q�	cѯTDc��o�@<`H�-�<t���'H�-	/���A4��u�	�����
���u"9��K��#��������@@�'R�w���	�kA/8%�$�;M�/��ƒ�徢t7���obH�Y��	8$G� q����C�K9CGm��z�Ժ�b y0$g��$�P�ݻ�V� ͉��QJ���._�`�~���T�-�F�u�T�};�18H�A�{ÿ���[���WhLH	�J����R��j��.�|���}}x+��K�ܽ�3JJ1x.ˣ���7H�;E}��=0:5l����F��1����$�����)�쟞oG �A.w���=�D�
���ה��٨<p�����A�>0ᒇ/����M�d:KK�r��	��sr���Y.��h������%��$���[��I���	8��I��D������C�axD��2�b
D�)o?)~�D�pF���9����摉�->�� w�����}�2e�m2C�'M'�5x O  f��(�8��6�-W��m��^#3��g��+�6�(~����ۣ+'35U�)�&�pF�0�D z�8rKC�2c�F��2c�njF�gkP1�ziĒ�(tl@�;`�?=$
~t�A���LEl�Z�/��;����e8Q �SE���W�U4ٟVt;�cqv���'���Ï�#aP8B�L���{���74Aq�0(�>(M�M��<�c+�F��ΏC��˯�&�B/���
��羧��)��a@{�(���hP8�/9�p�7W�r�Y"��wv�98n�G�|�5�f�j��ۜJ/7��ț��	%�
H%�C��
�Q�
��U1÷��g����l	��>Y�(�zW���(�z�
��U�s
�ƥ���W�L�CT(�W�0>﷕8�.��*�ޟ�L����d%�΁BI�(���oQ��r�Lv��-�2Dz��
3e0Hg�I7����31
m{P6ǒ!F���ބ���P<�@G��*6���&�OC~�]K�㉤:F%/!^�F%������@�������{��,��SJeS坎�.���,U�)�cf䡱�@�a�H&ʱ��n�p�Hh��CQ{�k���M�sJ���^ߌV�~�(���D����UmN �IxL����S1����9a^�x��=��^��#
Rnj�^R���(�Yь�����i���~�3�f��u�D���5ʿN�96��B�4����(q��p&�3֨�~�A��&h�~5�s���͑0���x�/�%��L{A��S�jk/�<��8�m��L:������	�4�󦓓UmP�N��k�Q��J9�A|�oE���)��26_�f�l:�l�xL�{L0��P*c({�ho�'�?�����g���:�@1����͛0�ãm�_�.��DʳL��%���_o�<��9\��Q��#�����B�o�+�kni�;����
�f�%���]@�5�V���ݱ"�>��Z�`�Ps�c;��!���AY5��ư�+0���c���_�������zi�v��G4�:x�>�h�('ޏ@�Ԩ�f�͗A�{��.$���/���v�/kS�U�v��	�h8��|���Ȩ��'D<c}ܳ�x���*t�ß��w�'�$O������	o���!��8�PyoxG<4F�x�{�^Dc&�u�1�J�\Gva���h�N�h��~ ��Ɛ�i���;z//!5R���v�>5�w��;�����i0����:6��H�2�� �,0����n����1.K�Gp�X<Y�ߕX�E큢��D��#���S(�!��`u�ˡ#L���ȉ�      �   N   x���v
Q���W((M��L�K-.IL�/�/HL�Ws�	uV�0�QPp�s�t�qU״��$R�H���?H �� �      �   �   x���v
Q���W((M��L�K/*-�/�/N�K/��K�/Vs�	uV�0�QP��U״��$E�1P�6ɺL���H�g
�G��@~� �6s�>'ҭ� i#�6Kp��n��H#���Hw�!(����R�p&(����LPZq$](�8���� 8@      �   �   x���1�0E��"#,�Nl7C�H�H�p `��	q���O���q��<�6Χ�|���[�x=/�7���>��P�J �i��ɔ@�YLک�*h��r`�`��⌌@ �v����/p!�:pZ
�1����>"�l      �   
   x���          �   
   x���          �   m   x���v
Q���W((M��L���,K�I-�O-.)M��/Vs�	uV�0�QP��u��W״��$A�Po��s��9����C\��=��l�����3�� �#L�      �   A   x���v
Q���W((M��L�+H�,N-Vs�	uV�0�QPw,JO�+��KTG��kZsqq ���      �   9   x���v
Q���W((M��L�+H-J��I-Vs�	uV�PO�)���W״��� ��      e      x��}Ks�Ȗ�w����@"	 fEI�L%�R���;�Bɨ�_��m�?̢�A�������U���y��h8*�}L���w�7w���d~s��|9<n����Rw�v[�&�������B�49;��Ǫ�&�U��7�����PW�(�$�9��N�R��T?M~�6������b�?�����(�%��w���&��M�5L�������TiV��*q��vl�;�u����:y��׵��2�Y*��>���^U�]�������o��&��EV�䫐�z����v��u�L���fS�=�4ID�d2��ȴ��R�m�㕮����oy�B��P��
.1o����'�yWw�����iV�y��b*�/U���Vm'��N׼�n���%��,�m�,q{�mڮ���mu0��]�|�럅�9Mp�Y�b�Z��p�U�nHX4���rx}i�0<ӟ���o��i�s�g��X��2/
�|4����s>�_�����T��Q���)���V�xs��m��4.�g����K��ԳbK�+�p�ա;zB�j�u���U�	-�q��o��Ss��"�#ʁ��9�CN
��=[L��D�d��jѾ ��f2�>uu5�׵������g�5��8->)�=j	��!�ߵ<�{��?��|���w����>��q��k<�"�({v����g��Y��Z+7�M��ם��JZ�HT���~CL�Y���m����On�}�1���,�o�+�(d*�~��}��+�n��+8~�~���m;��
�"Fd���jXe/K���N����כz����M��8�����BH������h�/��sf��ͦv�.{��0�	���ui��oNd�,���~U5{+Tz�9�2xI����W] ���W���L߮��3��ҥR��N1�x�%n����e�٬Ji�U?'�g��<�y�eE�m����Z�c�k6_q��uc�z�[�_Ș�v��+�����h�/W��bJ˜�����%s+S+�R`�J�6�CMḽ6�<v������bNo�ww3����S�8)I��٥�D!zSQ��N�W��t뻘�R�MW��e����8��E�i�R5ܾ�g�\]O'��f��b��\~2��QG�(���[~�ئ7����������aU$�L��.L"��)��C9��X<�>No�f��q\=\]�g+�0��I.�e�,�2�Q��M����n�S��mKX]��{^�-�)os0EF_�?x3����,�uܘ��i����g��$zE*Q��뒸�aI�w��������NW7��eh�X�_�<�n�Y��(e�Qa�=���ӫ)�������Yr�h��X0,KϘ>m5,��mA2~7[�<�e����/S'p�Y"�\�2�L��	L�6+��t��jz����O���˄��
p�U�e^��?`�R��B���n��H��r5�g;]���*2�0t�$��Px�F>8Ɩ}ȩp���.���Z���<UR�/�8��l�<��$����ȥ�H��'#$4�P\��*R�~��Ɇ�QP	$-\���4�W+�f#�KA�"^(��\�LG�R���2���{3��Nf��͗�-.���S�D�ӧ�u2�,�3��UW��7��Z�� �������F��b.�p�����[�w�Ƒ��R��%1�V��3,3T"�x7u��E����� ��ۣ)��2�YZ��w"ْ�E���0v��G����^:f����-�\ܥ��L`��F��zi6G��z�����9{_`�=K���K��}R<jV~�w��<"�Ӌ����HJ'�-���-�������	�w�sg�,���(��e�$���f+��,%�.Et��|aL�����D���I�B$�S�j�}�B5;]{���-VX���O��T�sl#
�S��.FH�[~-J��F;��z�쬡E�P�n��ځ[Coټ�ϕ��&f&�W�Ҁ��y�F�E2�ǁ��^��2Y�:�ב���Y���[���,����j3����ݳ�G��J)�rA@�>j���śqط1�z��X��f�o��@�|�`?EV�@f����[r(�P��z@繞ب�g~����(͖�NY�۞y�
�X��o�NXYE�j_j2��ĮB)@�x}n���t�u���ֽ<;[n�ߺ�/�����~��;І6`��ݵ�at�m:��hUB�I\�Vp�"�@�Ǉ.Vҫ9l�6y���֋+ɲ#� �f ;�7�-: )(��4/�m�m��As�XO�b�>��h�'(s4}>P���Nw{X�ӺhU9aY$�
�8OaI��7�S�������\ho��'�� �+rD�W�(w�Ln!� �ú7M�����byFb�A^�}j��s�6N�s�]�`��z6�o	�;��V��r����|aM͊�r9��p3ƕ�8�,Ƴ���}c����at�Ջ"-e�T~&��"Qą.���qm˄t i�����.����Do&�%[L���rE�uiÉ�d���),H�c�i�b��x4�wӋ�����jy�i�X�7�a)�^Rv8e"W�
:���Y�L��v~3�7;�)��g�Te �\dJ?K�L1�gnX�+6��[Bg��,3�q4���y�����(��]�3v�>Ы9 @&II)e�vx��#��S���H�����|v��#p7�c/��p�ϔ7Å���P���9�+�����>�d�e�O��B�#�R�"c��p4�hw3s}9[�3缘�ڀX�92X�XA�����!��EQ1�;}�q�X|���R���U��q/-%~���e5����d��}�{v�7�j>�X�蔦� Em�z)�R�x��(v��=��Jb���|�Xذ� )ņb�v�g6�r��l�t���NmhC3�-R��5(/"k�fV����=X�E���E �r�{�P��3t[�.Vs�Hӛ���zJ��n~� ���Ҝ^)��I��]�|p 
U���rf�.�"9c	F&���gㅁ�D_�<g�~=�YpΏv�~�r	��4���J=���%G�3I�� va;�*uI�Hq���T��9�;��R����?	x�|�n�a��_ػJR����VqX���ܖ�V���m	����=��
�
��&~f�ҩ,�`
�WJt�������gޭ�׆%Y���(!K]�].�]2�����i�����jnMIݔ
GT��\����$�X�s������qo�(�нv�)��x_)��J8R�`���-�3�jIE�E���O$m �kvo�F�g��ht$W��R
/
�c9a(�f�&p]��?�@fN�c���@R��Ty�
oZ�w�qg�|�#�}�d���̅���I�"����&ɘ�XH��{�^��\B�u��]*���Qni�6	��;g��\ڨ� ϛ��)��}���X�5�����.f��M��\f�&K����>�O�TĿ���^��l8�O��ț��� �0O�E�̯�`Ni:N\Wx`���~J��:Ƀ��s-m@�*!���p�(�/WK먢��9X�hx>��ep�����h����C
M���H�n�(v��n��q���^�'�rK#�@䂨ry��a�4�����Y��JSYX(Q`B̋�,PmD�ϼb����!�ٶk�z��$�E�%��@	���NP��Ohp���{�`�0au�L�,�+I0��u�ܭ+���Xm����gᲐi�`�/�GJ+���ŋCD���-�%�,�N����Ѕ�D�E�>*hh�AXI~)eQ�6����nmc�����K4x2A- }��->q��	���Kp� �q,xN|؃>n����k�%~� ��£��ڷ�@,	(]��N�����@����2���!����:��)*ذ��>o�#ӢY�p���=��n���bYw2Q�5����)K�/���|d�RQk��>2�G��2X�G�Â��cK����n2��F����z��>�R�R̶o�XN޶���y[�4.�~x7>���}�u�s�����3Ҷ��� Ģ��J|��4��yW�t�����/(7wI	�2>~h��(����OT�9���q���&VA��&���eF�M[�ܵ���)�}���    l1A#g5��.fW��3�[V���N�l+�3
r8��_���?���`q��w:�=y3�P�������������g�'.m&��R����sa�H�����/�45���D	:��^.�L�o�P�v�
�g�#	5�DN��P&5�l`�o68 .��g��5�T;A;o��S;9ow��%#[��#S���4PE�;UK���.I�t��/g���o&��s����E��
�s�iaK����/�|}8��6Z�9{=E�� 1�%��ŧaS��~+�o��uc;��"�섥Ș��{Ŗ�22mӏ$Fn�w&�yn_R�Sܑ�=`JKQ� UTA1%~�X����M�lB7�����/.3�qF����4'�x	jH��.E�l	�r/���%�5k�-�,;*8(��gh�i	����羨��Nd�,T_�Ӑ��>jtZۢ�E��ڹG�N�׹)HK �6��T�}l�%")�ý.2-���Mah��3n{ѷ������������<�h��aeڀ����-�U�|:rp�k��@坶�3���A�}2/�{m�/Z�E8����i������+.UR$鑄q"���]��}���
˵�����j�����}���4�&![)�o!2��A�Ii#1���G���c�}m'��vJ/�}���)]�ോqOM�ޙ}~�K_jZ�=���Ը�)e�˕u�u�bͺ��,d%V@�dG��o��gX��rX@�fW����K1΀����^���>�T���˗�z�y�XJ�(�3Fx&\���i������zc��1WlJ��H��)뙛�%2O����I��"�T�՛z��C�u���%�N5��:o?�����G�0���7��K�ps��	�!ң��j�\Q9}�r�A��k, 	%#��#奂��#�t�B�dh����v[0�{�K��utb���]��fU�Ϭ)0�<Ҭ�X�-��c��[˶�F�GZJU�����m����R�X߮,}����'~���r�Y�?7=�@�o�j9�L)Gv^S,���_��G�`�OR�hK���hX.���~�����K�#)�R6�^�-U"#��z����+_����E�#/0�u�]�c��ެ�C�t��o��=��r�q�_��v
��"	��= ��'�f2v���y�5��1OF>Rʦ��U|P�ݦk��,�a\�qj�(����D�C���SS�=�=v>z3���=X�rU�2U��#���i�+{���Ё��ga�6�D$Y�V����Т��
���V����P��G,�"�i)V��7_x�š���d	3R�R_��G�4]�*Q%"ΌdYrP��^�px��}ݣ�u�(j3�FY��n_}m'��x]owo�"���XK%���4K��n6�z[ґ0�ᐣ���?������#5�l2�Gؙ�۷oؤ-	[Ehyg���M�m'(|�m����O��b�⦮ �(e�3�BW-��|�	r)|��h�$��U�z����E�E�����f��ղ�2LA}�<�R�C�q�����ѼU5)�.�H�@�J��z���~q��>�p᫴�XP��}�y�&�ͳ�r���{��W��\��\|\�bU��jcåuq;Z�é����m�с�47Xw�ah�b�]��f�L�H8�?o�M�l����{�Y��4��
�0Na�11:>����z��/��. �e
�u䫥($M���1Ng�+u����:v�#�-U�κ-^�	��7-y��^�T���H;�<��pf�y:���ҡ�}:�X�H�>`B�q�B�K<p!'�3��#Q9I��;4�;40�u�er�������X������ض#S�Gj �J:�H��"I���G���9���E =�|IR92�F9������ĵ����`�����\b�?D�%FךH�����D�+��(5ܝ�>&Zq�b�b�B���V���W �;O!�XdY2Rm"�87�#JηM����Rw�	E�OT x]m��0ރ/�j��6�_��I+;��qb�ѹY����+{��R9�����g:�U�_I��L�32�p��oa���6(S����
�#�u�\�f7�=�3G�ߑ3Ɯ��w�% ǩ%%�����@�r��k���odv������a��iߒ��������sJ��o ���U�"�3������"a���oa����j^��L��:v�g�����x$��*n:���E��1D�M2Qh��kC���$Ѱ*n��\�l>ʅ䤟f�FF�U�e������AkZ���x��]���	[��Q^���އ��_����O��:_j�*��R��׉%��4�[��³�64�D�K� N�O����%�����u�i����K�Z`�b����ځeg���:���l�Te�f��3t�����o�T��7����.c�;0-S�E�:W�>�el�� ��NE�`��1�֢z$d���P�b��-q sI�+�]�]�{��`Oph OuG��6������C,l����mj!��Dn��|��Y,���c)zSov��h�O:-�b/��t�-���%-�rf��j�u�iw|��S��8���Ng��cQl������Ig�jŁ�"+F�F2*�u�=��h���^��aC���Y��M� ��=�L�K�_�验+27�U�+u[�ցR��S�yz��b�o�Q�d�]�kljÀ����1��>�l0&�~/ȓ��v�|��AIԛM��${�R'#�y2�Y{�M�}jk����"w�'�/92����m��ʧ�vk�UkW�.�"^�,��Ȳ_�/�v�o4��u��8.A�q���[���Er����[�荂 *�S�C����K�o��v�8��{l�MF��	��_H]r;&,��u�� ��q�T��~�g��ϖ�l��ن��w��}�l$��v�>,��8a�b|�+␡P���#2l*v.d�7��6u�2-�"[�|���ŗwR���o�洫��*�إD��2Ѓ·�XZ�էI�m]���ӽ5[�.�L�D�_<K��
k���A߀	9
���F���_����m_u �(c.d$3S�G�66��n�#�Z����׉%�Y��+�M�����(��O5vk>]�ŦT�3�#��<V��`�Q˟|�I�~�Xw�h/�xHb�4���D ��A�,b,�}�������'��r2y��E8Trq��~�tg����d�����N���4��b�"�:�]�V�]��9$�92�? �e2�R��/�!^-/<\B�qCS�M�8�qK��F\�����*��&^)��µ╾��P�[�,��~v�~z3�M��"9|��K��Tj���p�H��L1��!�3ö�ń1����ʡb7�iWO�TU�oi���p��w�3�\\T���bC���p`t���uzÐT���_�QQ�'�);�f*ęá_i�����ypԜ/:I
Qm�A�?S��8��KD���偐W�?�z5���63=�)���g׵�KK��(�p��P����̯����;�� AOig�8��>���$�կw��/�NHx����N�`
��Ӥ�R����{s�7����bA�7�!�38��}�f0+�Y��OBԫ��q���*3C�/�'h]����)�,?��bG���Y�Py�[:�n(
 ���j4æ/��p��L��N`�܃S��ۃ%����_�3�8�Z�F�N�U���E��Ib)�!Bz1�&���������c�f�����
v�/T���`�\j��G1��Ȍ�镗��5���s��Q�}+2��#��<�W�O���;��b/b&�n���c��l�g���Y.�L0�K�C
vQ�ł�V���d];�br�V�Ȋ<�~u�\�P�zC)�N��nnG�	��A^Hg	��XL($u91Mաp��_[)F�M�t�Q��U����*! ���#Oϲ������̃�����Kxx����,
�������M�N�Ҧf������EҎ�Z��oB�)mpzT��ď��_Xj�������� ��d�����b�    ��3%>���;����&Ђ�5�iY�8�,����,pĔx�J����9�̽^�]���&nf��(��~zH�9�}�i���Z�*��駿8�R�j�f���g��^eK���!�L=B`|����H��0F��k��E-)z�T�q3���u"�]���$���k.�7FKNg(�6��:ql$ܲ8NX�1R(�h��Ó?�A?n�s<�7N�y��!¥Z|x���@���;�Lλ�+Ŧ��'�zR��Cr�lI���NSWjBvu��c�=V��'F,t��>	���
��o��Ԝ��~���t�L�>��"���"����ΎZ�q���uT	��"� .�[Z�w�����}�4~$�)�cP�R�E�9����#j(6�%>��a���(fi�zw*p��mh�]��t0���n����ں��	X�R��bBX5� �!���+�Z7�N����R&(��(�ptF��w��?6_]�������n�O�u���t� ܔi�T�?�}i�XW��FO�i��ߵL�BG@���MY���}�����5��"��+u�Z8(K��c��z�3��=���ǜ�DSz"�FS8��:0����̾���,ޜ��+g{��W���`�x�`
%N��-1~�%�6ل[X4x����MqLjv�������f/X�8���gs�S�']��Qu�|d��6ٚ���j�R}�Y.��<�2AX�>�$ҙ8`L u�r.��ٮ���;і�P`�Ȋ$�m�"���^2�Ǿ���;J��/�o���K��"�9���W�hUD��*)ʜW`-�xY���|���'8خ�
�Ϗ��L��\8y8��_����cr�����8���=8�ı��s�d��R+��i-xn��yI��&�y]��S��,*7��*7X��%��'R�8������AV{,|v��|3@k��H���%��y�~�ex~xu�Y%�V���4˔<��q@���xY�J�Qզ��̂%x8U&io;'�f11��K��N"��U�o�u�M�c㔭�Gش��9�@>���3���|����s��p�*K�q���w})a�bfb��s�p��=TNX�L�nЉQ���$���fޙ�l��r��w� ߵ��k[�
��@O��	=k�і�̽5����eӺ��7'r�-2�<��1>N*�*\���ɜ<��-���)Qo��f^��Ҿ����^��	���u��D�!Ƌ�2@C	�%������j*�D���5�8dZ=5����(;���[/-1�/���Qж��*���7(�y8kH�}(c��G�� rjj�j�Thk��HQ=�otC�l���S<��Kb|�^z�OU�Ļޝ�����H�=��~K��Ra)WX�ux}�}�y��h|�#��,�D��{T?��DR���9��ě3�Ӱ��8�����v�E�7K�x�'�;C�%ҿ�C�*k]�����xݾnR�*���؆�A2*�~���]'l<K��o��e�3���s���s$6���7�KK��p5��KGf�A�v̑*�$U'��!Ʒ$������X�ɽ�.\�O����k�ʄ1�_4�հc~-�bX��6Y�eGއ�B'���l����t��������g�꿴�֏�8������t,A1��ۖq2ߌ�`%�,92��e�hؗ��zb���m�c([���Aę�8"�	o��E\�`J`���2�l���a��5[b�L��6�7�Q(4S���u�*YK7.M�B*uJ�b|I<ɴ���U��׃�I�LU�i�3�N�oK���"���.���
�h�B��E)D�j�C��m�dd�r��c�M YPb7�π��`���G�揄�b@μ�8��Dx�㋕��gۊRD橞����
L�Fi%�{Ѥ%��y�=�2Pe�̏3!�T�f
�\cq�q�Pa�=x�o��-��G݋k�@�8`�h�����3���]{g#Ѫp��2��b$<����2w{h��QrB���~��
�0q�nj�{�R��z4����. 3˶`ы�ǅ�D�֢:�=6k2���(��u"�HDMվ�2l�t��fT�g����dM�p6�«�1���7�hR���4��&97�)p�i�K�ք���i�J����~����5�چ�E&�&�P����'�G��G]�a739�l�R�i_sg��}ũ���-�p�s[�����F,��"
<�Q�P�L���D��9��6k���h�ܗ�J�mF^7����y�wӛ{���qL��1B��~����)���T`�B<V���������Wo�ZP�"�܅��I|��!��+=vt�A���l*�=?~Z���[�J�E5��jpr�>�m���8Ǉ�nr�]�+K�5����'/�����q?֢kjU�}YL���B!]NUOL��x?V��-�ź�Y&Fb�!����t��FO�n!�B��%+�ivA��q�yhi6�{8P������������"Ms}�\1>;J�^$A�Z'���)���84-�7;q��n�	s+KS�$�L�>LJ�21>)K�x"E ���[/���(pd{_��cb|��"�?`����!h@j�t�(a�j$u}ݴ#�3K� �Id���B���×��
V��k��v�iײ��EJ&�ПJ,1>�Dc8��g��-|8���B8��VpZ .S��8a�b|&��7/�-ȏ��=l8��ٞ�y[&8,��U��a"��[��K�ӀŬx��Ъ,���cI�E�j���+�q�<�ۧ �1g�)KlY?��m��;p���uS4����N\���p����G�Q�@v���-�P�Ý�]ر�K�3���E{��!�8l����#[�F�n3'�,3��rp��p��SR|���ȡ��t��.��D�����9uN��?�vX�E^�0c�3�d4n�	0�ڜ��f`%_��]�X[�V
�s�b�8�����;<KxQn����4^&2?�SIK��;�����Up��֖vo��F������I�&"Ƨ��)T}�㺨�:���>�"�$+����|��p�]z)�@(g�Q5$#�rRZdA�k�s��ªL�����s�Z���{�5��uY?�nw��b���m�"��Dj��a)��0��ϋ
����߽9f4� �L�04y�i6h�3���@�8�,�$�!�/_�<��`�k�Q�U�0��T�l$��TA;�Q��V.��f�{�)}"6d��/u2R��,�ޡ���A\,�G�Y�W9h�(8n�q3�:ԇ��/��Ņ0�jK�*�+DKp�d�ԏp����fk�>7��`�cJ�␙�o�Æ8��"�`7X�[����k�Ps�q��)p4"x`�O~���ū��B�k�b�9ܒr��A�ϻ�7DG1E�ķ���h��H��H]A};.Fa���g�)-|��4���$d�21�q1\Ъ�����+2�y#�3?N���=���1��ĕ���HF�3a����+xL���G{�_�w�Ҭ�rnc
���gy_�n[����������	�)9K��(̖L,b:3��<9I��y�8[��Nx��_��7 ��{����)��L�!�{��(�18�����kw��+nI��9�M�u���aݻ� ^���z���#+��4J���mWk�>�z���;�D�M��qr���	�&zD\Q�������@0YgƩWYZ���bK���7�(0��<W}#}J.�JJ������6\b����4�J��\ڠ;{V2�c��fr���v"�)&�(0�82���i��qFl��L�18�B�#��K�|93�ptu��N���dFq31�]P�`x��4o��n����wr�[¹<Qaz�>�(�P��H0�;3�x�-g={�L���J��C�se�B�j�$�6A��%dJ��,]�V.o��|�۸2�gP�탥��z%�p�4�T��*E1�x�S}k��&:��8P(���Sj��la�nh�۳-K�<�&HNp��:��L,1>�D��+�+��|h�g.���?׏ut�g �  0�	V���[ �~��x�n�.T��N�/��#�/���g�C[�qwB��ǌ�K�f���SEvOO�a�c��M	�M��#T&Fo�J|�2��3
Yr�_eR����8�=�b_��ac���4�Āe�NO����m[�Ga��͋﮷_���m��s+a��G`��IE~F%ō�0���i�,Qc�"���F��9�{1F�;4��Wf~�V�i�%��8`������v"�z�\��e�y^�#�Z����zύW�UZ���� !����Tpqb�%��$�|4���֟}���\=�@��D��%�7Q�3(�{U�2�u�f�K8�*$v�������n�F��3O4��׉T��"���)�x�v?�ļ��K������U�諞�n�T_J	_���	�YA,�S�f�U��]�U�B��M��Ql�{J�%f�$�e���N�#��\f*�B,��-1�ㅲ�8��#T���Ԃ��'2E��q��J�~��e�L���=S���E�7�eW�j�I������6l��o��/��uЋ�	`iK���c�3�� ���R�l-R���Po��&=�x����UHzG�S�&�K�;��;���*�c�%�ߘO
=�S�6&�7�Q��;,�T��B�x��D-9rڲ�~�S031p< �Xl�W#�RSL��W.�U������ s�J����x��ɗ*���`ӗ��#��[B��2�C'@P,1����u��؆s�����$~��-'�4�`�#�e�z��W��.\,f�)AcaԸ�R�׈�ݾAۆr�"
�saN�o���	���@<f����g�4"������%,���4F��/��a5}9�A��Nͺ��������b]W��R�,�R4,��Po�<K[����l���=-Z�=I�Z�R��� �{���5��̥(D�w����|*�6U4��oQ��TuO=�B0��S��%�5�vC��N��&�s��uje:r"����6���E����Z�B�.�\˱υ�#Z�5��=��P���#Akt؏�����O=��@��50�c���eqxã�$�PF2���
 Vf��z�X�.v�x �\c���e�Z�=�Ĕ�ε�?ǫ�M�����q����&Eҳ�TO�v?L�l�|�A�
�� ɉBK��7)T}Ee�GE����M�h[I�����O1^j�`���&����?�p>>��1�=���O�/l<)�46�l��5x�/���xP+4�Ɍʤ����%�y�k���.̃;�7���nY�NP��Č���p" }�J
_�SJQM�Z�#���Ub�!�<)t���~�;'l4��2�=�7՛;"lJ.�ڠ[���k+x�Ug�~@�`�a�8�#��z�gʚ>�&i:)3}�p+���Xf��,�Vw�����Z��G���Dj��[7�n㖽�-wP��]�T���}������)�.���a���f����|	�`�˂L���m�K���\��'�Kթ2rC��{ �Khb��?����0}`��D�%�ÚP~�]�j��f8��q�����E�G:h�}iO ZSo�?�f��ܿ��hF��Hg���o�����$��oK�oF�<�3���>�fh��@���A�F�����7<��nBm���)�1h�f㼶k�Gg7�_4xm}�������	֔�������z!| c��.�N{9Y/�=��OYl�+���OAi��w��F$�v(㇇�tz��r����z�E��D�bb<�=n,g�EAS�)�v�%ƃ�[��`��k�>�1�S�9e�01����g�0����*Z�b�c������	Ľj�����{e�?<eLS��31�����G�+d��G D��$Sjd��o�f.�A���z�����.�#�����詞�YI���\n���Ѻ(z�ӇD�W���Kc��$��o���z�1/���V	�O�ة���ƍߞ�\��v
��hmF� THϝ-�9�&	��'ee���A<i���5�$�32��Aﵧ���� K5�K����=,��Eї��R�p4���r��p����T_�Ov��#
(�8�G@N,1�����X�x��4.*��qҜ&b�f
��Xu�׷1�L��{H�:1�x�D �lP��[�m�&k%I���Ȇw�R�����:,.Rn����	���=��G�t/G���*xp�TB
�0��Ϝz"��rh���sW?V��@��Z�$�Q�W�1��i;'ǚ׷���Pn�b�#�͞�:6���E�@�/�~�>���٨�jK�7�A�������m�o�pFEܤ	֕�'�vX� �4����<�B �]�m*}]�l��>�)\`�u�bʟo���
(�_a$��塶?t���83����&��F�>��A�m�5��r a��Ӿ����H��%��1����%���\���m��t$zAFɒ0����Y��y�M�ScH1%+7�	3��75ȋ�,��"����΂�$���<�� Z���I�)�[� QF�F��}�����}D�A#�k�D��L�l�
��:��T��$��~Ld�G6�d���z�k�tϏ�����}yII��QY&ƋC�a��6���@��Z�=�fY6��Q�wzZ�ᖅռ����g�W���zQ|�vSe��\yV��Bf/u`�`���I�� ��Y������	��!��$s��m������+foן��Ҿ�5�>aVYb�����A!������
5R�i�D:l�����o�f�10�ꓑ%��b����F���ߝ��[W�z7�&��m�EPk����`<Б�+���S��D��Jk
λz[OV�������KeҸA�r� �;�(b�����K��F��>�����/UJ��4h˳��x�'�1�����$�:��<�Kj�6]�:�k����7p������U���������;`�N.IXS�ؙU"o��T��'@h-1�k���O�ĸ���z�lF��:9�3b{cL��8������vw���6�<)�PǙ��G�Rޔ�3�}��c6UۙwZ듈6�m�P�(n��F�9��)c����M�Y�/�=����<o�} �[�Ng�a����-&Fץh�79��߶�q�}��d��8��D
��4��Z	���>��A$m9��N�Sbt��Eʋ�l�L��w*S���ȴ�6U���г������G��qMV�
|oi�����6�1��� ����eT���3{q��f����V�c��uO��k7H���Л㓖�M�ūvfQ�Լ����֟���33W��b[a��BXME�7�.r�������N�g�#K�5����O5p�طSx�(��b��`K0��v���x����z>���ٜ�N�b(�*���`�n�3"��nz>[�F��,������b���>!�e�cx����� �0��      �   
   x���          �   >  x����N�@��;O174!��/�'$mRՔ�}h7uI�[�;&r�I<r�%��-��y���t��F�:HR���	jڔ2�����*����l�������̤�p��� ��;<�ZZ,!�0X��u�-Vh2d�'�0�,u�+ڐe�;Ǵ���7���)�env��@Y# i�~������t��wpA[��1����y����[�t������	]:+�H��o�|bA���O�����!��5빊�XZ�gNz�`A�vz�K�����$-��Ўg�?�{��Tb�!%��5���T
c�?"$Q0Opa��Q�~�n|08��v      �   '  x����J1��}����R�o�-�jY��Vp������4+I���Y|1'[{(�^f&|��|�ES=.a�X>�[��f;�� �i�������E�mF㝶荆�D�'t���Cj��n�E�T��A��)����}�_u������'D��V"Z��U��δP���mR��2:M,Υ���E��m��1��yAg/�����{�x?�r��-n��^'&wFU29�L�W��kMrb�QV����ߑD:�u�tk�=�iD�=�}�����I��䔗�:Y���Dӄ���"�`�	��~      �   
   x���          �     x���Kn�0��>wi���I\t5��
z��E6�cka A�9HΔ�u�A��;A�7�8�����!Kɛ��ǧ��������pz=�����2F�4]4/.e��X�ϲ�=t�@[FO&��gH^Q�JJ�3�����{�P�0|���4�N�o�!XR�ߙ�AH��^�Wk���O���<�O��^S��Z�u4���ր��<m��?/
�|@��S�};=��J�����>j&�#��Ќ���)�L�:kp1��i�
�^��%�����;�=����D]vb*��p����5z�"���2H�;]cjq�W�@�x}U,��L���Eխ�hz3����G��G����& U_Kh��7�Y#���M\7U9�뭡E�1���o���]���6�-CE<��J�F���^u��؛��l��"���^�N�)�e��E<��h�Ib��w��o����P��?�����Њ��˜A�!��	�fK�w�0r��#W�����R����8%      �      x��Ks�H�.��_;v�SR"���M�$D!�$T|�O�&"�JT���������E�ݍ����,ڬ�ά�����="@H��K��[�U,��G0<���w���	۽�<,�F��r���=$�Y6�g��o��.����?��tO+�C��=���Wa�	�M��g^��q�wA���0��.g�l:��/rI= Q�ׯv��G9���o6�cmۂ_������->���Q��a'�j��d2Ӏ�����G��-s����f��\�^^G��6/kQK�˿��Z-��	�����e�f ���s��W�l��ݏ�nZY=��?S�0.
��~g�Y��4{�̲i<��0!o����ÿ��D5$�Nԛ���_ja3Tu؅4��9���!i���f�N��z�"���iz�!a�����758ڙ��RJ-۳,ʹ�Q 6&v��EH�K�n��]+��W��Ny<�Fօ<�SiD9�שt�w��-���넵�'��� �@���gT?[j;԰��I�D�H�Y�F#Fw�H�i��1������u�2.�8��׾�8�w'3H&�wE��ߩGo��:-����VԳ�J��;�F�#(����T��H+�t�3l�<6d3������˳l���[�1�v]�B��(S��ˁԮ�]�K�&�{a�s���H~��4���5�ݞ��\��m�6.�D����k0����[~/ڒ��V�G.m�*��)�@+�8cJ�Y6��;����`��lh,��������K7��*�F�!��aԌR�ˣ�W�:i3q%o�v=�óq�ߪF�t���ߠ��{�(j�H�g���E�&ə��H�����U�i��z.�j\I���Ӗ�1�|e��k��_]O��˃n-�>%-�;�'���-����R첌�>����w ��F��y���!���(ԈZ��%Ǒ+��񝽁/�U�UF VT+��>�|˿����|����tj����s�c��U6Vb�W��o���M�J=�0
����px��n�N�xBT�����r����L
e/������pW��jR����.��s�i���4܍Ļ��%b�&]�<�x�ܴ,��Rn�������
9�M�&�������`����Q�ܼ�<Ґ�`����䷶78�Ərx蚂���=�1�4J��+�����ԭ�� ^��6(T�s)c�s����S=�o��,�¢n}��4��뭰v{�Fm��NA|Z�^{&>�އ[؉�(N:"@L�����m۵�E5�����5V_�r���[�_Ag����lv�^ڥ���R"0* �\�:�J��ծ� ġθ`l�ڇ]�;-V��WB~[���"���լ�%�]�ˍ+q�q%*�`��N��n+"jG� R`�NԂ��� x=��Rry�V�~M^��{�%�����-�(�/���D8��?�m����u��6\*�����V:?׼�P�VJ������~��7�$���(��n��Kfq�Z�p-�V�z�R�{�6"�L	?)�F��B,���,蠏��~�.���腷�x:Q�:X����D�� �� >�/p���e�N_�7*�e��+�� H�&\��ӧI��,عD`�*M���0tGh	fZ��'_	����۠.�ӑ�_���n�0U���5�T����
@z�{����h4�ՠ����T;a�5�E:]0�f�����(����U�72�6�CjH���ۍ0���k�6X�����oF��?\��@R�i�T��F?��Q�=������K"P����آ�+K�D/��~�6��u��ݰ�7@���gjh��ɫ��.��n�>e���Iڱs�)(o���ACބ���������e��Q ��4�E��
ګ+HD�%��e_���U�e���r�d��	w}�
s�J�6~���	�R���!NݳЉ�؏E��	��Pd�%�B�
;*�\nZ�'���g魸%U�Ӌ�`=�Vؓ��=�3öm�j��u�ow��VgB�^m�B�@`�u�ÖT������?��Wz�%�Jc���y-�&�+���v�@�5u�By���e�)�DJ��L�a-�D�M^(f�Qaj�l��D,Ӳ� 4@6���gRl��aWs�z��#9"7���z]�H8�t���K/�7A�o����I��g�]]+���k3�)<O|hOg�O�x�r�b��k;T쳚�b{��		��x�^<Mfɵ��X	����:c
3e�8����AG���㿚�}�i�v��� �j��M��x�Sp+ن�DS;�lz��cRM���l.^�0�`�a����ۥW��00��p�iW`�P�t��n�ɸs��w������+���7:ot@�4��L2O��Cz�86���E���0EAC����tbyܰ$F@^Q+A���oE
�q��H�O�����nYg2���i+}���6�r�R�kQ��܇tk��郜�"����6���O�8/��[�j ~� ��.���m��im �ՠ)���U�������|�N�xQ�$3���mZ�4���G�$薛�OQJ�ˁN�C)�^���"���D��A
vj�`S�P�#��.d^�n�+~R+�����}����:�\�E���q���q��6��%d����vTt�@�mi]�GAHZ���f��|�]S��-�)k�H��O�]�k�pk���ū�G�"�U�n�P�-|�|���o���Vf���-�}"sg6��-�>��.P�-x��«Pص�������
�:n��������Z�f/3-�sO��ˍ\���� �uԽ!�Vl��Е�RD;]}�AC� GZ�BChX���k@��*I�:��@d�X��,��e��7mU��k ���ۀ���ʯO��������[�^�@c��� }��1�d�L�� �G��+!���C�m���`�Emb��i!97���BN�,8jQ�(�,�*fK�&����+�SH=��<i���!W����j�IO��l�OJ���	B���D2	iF`���c �6�Ns&�ti�_ɽ�S�q>��/vjaڊ��A���_rKj^7l�]�]���O�P���*����U�Or���p���$�� -(�Z_�Qx�4w_�%� ��`�\����_jq��~��D�60ej���J�p&�1�+L��y�KV�N���Hm��y:��KR�+��� r�r���#c���%), �@S^�)e���	�^�@RߢE�G0Ss 9g!����ou�Y�G%VT�U�[m�c�s�h�l��p`��u�m+|-�_D���Ór�`К�a��ӻ*����Kz���-#�2Lr�x\l�RL�V�G��g%��`#��L���"�Hbi�X�9�e�ZJ��EX�D���l�@h�U��d���a9��AHS�j���v���{~��@�x��U�4/γb�S�=E�u�1�TC����-썺2�MW��2�OHD���
]l f:�rl�{R�4#����{'7�-҂�/w���c%�����2,��w�CRk����=��3��ǊD������W�~[�hm���;���8B���"��5kq�(�g�9,�K��QfN��77_B����2I�g1�m�����y"1����	)Z��0��'�?��
��os3M�Z���t��b2�?��� �?�'�G���0��Ε+�)q����̟���A�9�?�%X4�vW�:x�QO�<���Eg�e����`T�+E�J}��PQo����ܒ]�]���h+�����Me�]��Aǧ}�{��x�"��m6�|�`j8H�"��	.��0��n�e���Ĩ[0��֍�h�=�D
v��.�igY�f�u<s��.�#6�α�L�{�@O�!��d�`�ПKQ�C��`���2�QZ�~;��S�!��: ��}��[�۹�����Cw[�M��N���(x���v �8�pH�:6V��WKnw���C���i���Q��I-d�u�r�@+z3��V�EY�R |�/'�4"n������`�M�    ���@�ʹ����K�Q=���a������W�w��H��eA<��E�����,�H(�wjp���M+�b���^���<�-��#��ir<�2	{9M8X�S�A*��߁0]�JEh�ƦÓ�w�<R�V��P��u���C1��m Ғa������I����5�g�ש�� =3����M-ݰP��@�+$[ eY����r%�a����"۫b;feO��pӤ�LG��2[��{�T��Y��T�k���	�����F�x�4�ˆy����N���͗,7�r�����w X��g�&��p:~K�%�T�^.�n�v�*<�漫V�woC�d�/��4GHe�A&h�vvEڙC���J�Tj���X7�#�b@���7�N OGВ���i��{-�͓�:�	jAOU5 O/�����zc�a�8�Y�L0󻽠/n���GMM!9��ۢ��\& ̢�2Mn�$���¸C�W�m�	����Ny���"vI��s���^�����>�N����Vѭg0.r	�s���T���#���.Ė@��߾%�Z���e��ڐ�.��<��Y��J�Zz|$��~�w���%]�P��_һԉ������������wj륶*p�����a�\qa�Dٱ���^yYsf���DV��f!U�
��Z~r�6�vc��X��
-0@��֤#NЏ��/�������n�_�}_�+TҴ��S��FC�ˌ5[�x�I���b"�%m�bR3l0_��װ���
ȟ`=s��K�Қ�&���C�;�T c�s��[�{{GA�?Y�^i�vw�s��8�L���Ҿ��<�����o,�I�=��QG�r�A
��Nr�=����-�����MB|���}�>;��Y$��M�!⏒���pˈ�S����� ��ٺ��&j��TGs������K�f.1�p= t�[I��\��B�ҿ}1R.�b�a��0TN ��Y�l*��N^`�Q6M&pE� #:z�=�X�a؛�AjY�
���_��bF[e�l� �w��Ky�l�e�iRXJ�>Ⱥ��fx�p�;������(}�����E��D�A<�t�JW�:7�Ṫ ��+�:�8��+��@�[��vM�''�4�����F�0t��}7=$�L �lϴ=C���E:�p��(r��梎h�2��*�C�-F�|�>7_�~؋���9��Ŀ�f�I�DF2�W�|��|��4��J,��T��A��f��M�*�B���-j���@w�i�[U���R�Y�XM�c"��X��@B4�D͂F��b:���l�H�1I<�Xm���r'�Z9�	�U��d%u�.�h���D4�؝H�����5�z����;uK��<�Ӊ��s���
u�T���x�� ���)$�\KҲ���E����#�>�3��Hsd�	�gY�)V@;�\��l3��l�) �Jڃ��7*{��t����{ ��B'��5-D-U们�(�g�HdH�'ӆ�4��~j%奅^���F���uA���0��e��ۄ+ᨤ �R�T;�ݾY7�d�l��ކ��Ӎ�;����_�� %L��̏�|�ӏ1if��QKד;���w^ѣ,+j+�Y���CG���p��UFF�b�%�4׎���w���[}j%H��M<�Έe[&id�Ϗ�%�I-�?�c��$�*��C���բ
��ww��m�{<�^Ti$�9���T���� �r]��zź�V|�P�?/&'p5�b�n�oޮ��PI�Y��=�3#�n��'%B����g Q���}Bi��?�=|[��ܶnѼ2��P����3�ߠ�/����{��t��prf��r�^=F"�:����4=��ki����t�`�j���7��]���r�6��V@�)b�vH�yT�>�������e��5���A�g�F�R$����? �tb��I*� �h�5���(�������I�˒.��*���?�Jڿ�j����k%0�~@�.���U1�/�l�g°7皱?ƍ_�|M.AH�j�r����m�o���W�Q�Ə��'�l���Z�Ӂ8^���C6�?%p��p��֭�8�fX������zWM �x\Ҕ�犆pf�M��y�zʧ��<�N]���vDEl��Խ����]�%y�|�'�'6}T��2�:�����l�0�܊~U[����C��b���1
U�p�?�U���5���ͦTU7:�,=  2��<ﺗ�TK��2�-�Z(gR TD��'t���(��3�+�p�X��	��c{�5�oi��T�K���Z��B��TjU�,�P�+P��o4�f�&��A^�H�(��j5A�yZ�T�C@~�7�%�-��Je�F�;(�6��+���i����_�,��i�/i��� 2nK�R
-Yf�j�|�"P�^�[q���H>I�y%����i`9�m)�N��q��[���M���t�f ��	%/�l�y�k�l�u��5��x(���}��S�!�.E�ck�h�:Q;j�l����;ӴUw�gJ��(�Q�o�n���K�&�}�T|��z���A�::k��CJQA,b�\�Q��j����'s��ѭa�n7�ۊ���-���^[ؽ�����Y��]ݨ��� ���� g���Q��l]�3�k|M���'|���D�)�51-ƈI���]8SzԾ�.�`K�����zFiM�$�z���f�H��!�5��.k7���i_����^hZf޼��8.bi���&LoK_y����e����엂#a���ǝn���� Vo�-l:q����X%�ϼ��� �� o���C�P�|���nr�s�*�2����pȶ52/y�kD��������(�9B�
	�\Ee��WH&�;�H�zͩ)[�Jb�[���lIL���n?���7%��¦kp!z[7
%����6����bZF-�56gN����ص�skOY��<r����ծe�=�R;>&Ɗ#R���`w����Jz�{��Ijz�'~�~{�G�X���;��#�e����0{x�MK%ߟ�kNQ�QQf:l:.������kA*U#OY��bQ��-��ɕJ�l*Q�� :�?t�6�r?�eC��M��5�	wz �4��zk��i�Uj��NE�CO�n�������q˓����qòr��Z	����q���%Yc������-�2�����6]�m����+�P
���!��~���/O.L�3|圍M �Y�m����2"�֗uF���.���>v��,J�+���aT)Lg��Q�����T�v �+��T�.�4�����6g�Wu�ߪ<l�y+='��Mesw�`J�α���"a�*z)^��N�*���qtýpԅ Pk�m�ov�V��r#�����8à���łaG�3]9'a?�ic�[&�i+�^+���ٜc�z�Ux��Iw��u=�FuQ���^�r5�O�+�����8����u�}�Y!�4B�-Y���.{v[6rx��XĊy�X�V��(��a/z�	�8!�O�i��c_�U��oา���Zn�Rm��q��H¼����O��%c���:�(N�V7}]��Dl��M1+�A�fZ��S[��W��WҌI-?��&���b�ǻ���s�y���j��e:U��G.23����J�2�TªQJf��a�� A<ٕ.�=�H`<-c>�A+��������`��ޕBL�Z�tmñ]�� �ZI��
4y@����A�t����(���(�b�����*�&wjZe��)ĉ�;�ݯ����v�o���&����,v�ekj�[Ց>�e�l�ؘ9e��U��h���VM|W�<���`9�p����_�Vi�I؀�+��q��O���]�pEUz��Z��'���0�j��,<��`�s�	��xX1�M�T���"���6{c����q��)i-��~&�m�%_�%gD}�X@T��4���%�T_&¼2�4�Ɨ��:[:���~�dT���iT��?uཉL�ɤ��0r���5��$y:��KpI2����Q��і��;*q*��    :��eՌ��gR˦��/�%n��
cdsq��m�.S���4�Hhd2����	`;� *1\�Q;�3�,Կ&�AII"	��(/�Hm���ף>��v��cʳ��VpS=��g�F�}�o�b�ܖQѾ�%�P���؊�4��C�䮒�$�UXN��Y�6{���|�Z�g|(>#���,�E�I��`O�!�aa��=�>,F` ��Ԑ���ӥ�ަ�o�N7앳_�u��b�Q�*�'w�P�b���x���BӾ��i��䐲�`�<m?_�ep���6��o���*�;����ҸT�2w��oS�w�`����z�2-:2w�i'�=1��d��v��|$�+���+bu0U2ӘmY�)�a�B�u�@�<��V�(h������.#�o��G3c�aSM�N�F���[�H����A��7D������JfL4D7*б�ߕQ��|؋�~^�Na?�)pgC�~ �*~LF�,&R
hb�<���K�Ȯs&cs��d�d�b�C�;��,g,�+�3,�8z���hl�ud�$&��7g������"��d�5�l�}<�ph	����nb-EV���`�cV!��	i�|��Z� P/���;6yHg1��g0`=wI9�c�c�-Ǣ��!��A;=yP�����:Q��J[�g���o�N�ke���	�f���&��t������(���%	�9%�����a���a�ZI�;H>&`y��K�~�c���4�b��΋3�*HԸ�({?��)>�+D��p�Uq0'�'r����Q$�B�z�	�]��`��p	^�JFl��`z>`]q��2��qS�
�{����Vݻ>i'���^'�9�p�9V	�G�?KԊ�q�d��d�I:��M<�c�1��lt���b_w��\��ˣmϘg�<N�wq |A����`&�L�/�N�+��d��ʳ��l{���i����i���@���n��\�LU&B-�#E8jHn+��@���@%�M�$?~^�P�2�ʦ�ގ0LP�l>)�f{�k��!?�m�b��4+<�H]3��[x�y�\{R�w'� �Nk�Z7�e��U<�pQ
f@0J?�w���$���<�I��gyf�~�jX	$Sǡ�W�I2#��yDK�ً��ګj~e�y�k[e���ɻ;���ݽF�<�������xL�Q����:�8�B-��h�v��J��u����N<| ����z1����m�_��oK�<,���%�pSS�"5�`����*{^�M����D]�l�f���M�;���JZ�P�^�R�&��i*M>��0�锚�i�|�T��B_K7h-܃Y�R�W]n&�˛�r��u��쩂�=Ag1ۤ��`�Vq���$G�H�x�#[���i躖��n��b+KsK>�
uY�A�B��^r��'��SS���X�i9�t��r�:��`?|�����s�@��yk��&�ςo�Ũ�1"<i�d�5s�缫�)e�L�8u	����&]3�J~~���@?�u_����m�� .��̍z�����b�!�M�~�� �Jty�Rn����F�A���� �Ȱ���h׷��H���Sѫ��^�ٽ����P,[w��c4�`19�S�l���yJ ��\�=�i9+7<n�����,��ʢ��ϧ�y���I��5Q���+�'թ3��P��T�u�?m�X���S�;)�:�
�⡒U}SJ�����#�\*7[�K�s+��Q]�O8���	�I���]���aSurn˄�9$>���-	G�N�I�s�A���R����io)�ݒ �k�<��V+��O�`��(hiB|��'�H
��������%p0�hj�7V{����K<<[��UX�Z���v1��z�	d ��a�p]�K�J�����ii �2�(]O�#=O�\kk�Ԛ� ��,s@+[J
0@���Q 
ă�KwMtXh���x��m5l��QjX��-��g��} ��I�$�A�-�MK����К[�����u��~i2X�=���nSn��:�w�5�id�L�#�1kz1�ׯ��sLY�6{r%g(	o��P�S�.��@ˮ�G�0gz*U,vx�f���噂x7{���N�T�����Iw�a�Me鴈��:K���Ĳ=3v�#�j%H�N�<#��}L,0��>f[���'�I�m�ŋm*fr��v%�����"0�ń����&�h���F�mBO=_+b��a���zǘ��z2��?9��������B�&�]��K��M��@����	R�\���t n9\�m��	���!+������VRr���[(�����n���W���g��hg�����T�/��`g$Y��ąa[q��gZՋE�&�tA<�p�%xns*��PM~�_��N ���~m��nPw{<��?��������ݰ)C�����'�1E�0o#X`D�q
���e���Vc@j��t��Z���͗�B�P�f����� nL��>u#hףV��`�  ��.b�T?��)\`Q���5�>��~-"�2�R��dR�<�v�m���L�<s<\l�_����\򉃲{��z��+��p�:��zT��3�I^�'e���d��v�pW��$gyL�VXk}��{)�@�4��
�7���ʽ>X����a7#i<nC�0�a�T͝������8���e�_v���.�Y������Kq�*@�Ņ�%��F6Q�WX�*o�6���0�����x���X�̒�jħ�@:����X��*<��0=�y���Fp��s[��\ ]��]v��7K?���������L�4[VQ]�w��+���3�Ą������@��Y}G�
,�?ǭ�P
}PnU���4F[̩z9��0�V.���=c�:��bgGy'ܕ�V�C���Sv�
�m�Q�:n`�;3d��Z�K��F��|�1��-ؽ� ��q����~��� ɣΊ����&l?=W�h�S�����	�Z��6�B��}P����^-�[Vg`��BwN(���~#d�)�J�h2�����;��-f���t
+�œ�4a�ecq*~�����(Af^\B����Wx�O���4�)� � ��
ɤ�1E[e���@(6�1-�1�Wb�S�v��}�~�fU���Cq�����Ը^��>ߩ�����Ոl+[7�V�G��NF���ua/�~��>�O����&�{��z�;�x<�T�d&k�������0]:��e58xg��A����
[w�nX*x�2�x ���
���������vWo����a{�v-=��dS�&˘hp{�i)�,א���|��Ug��ga~��Fa�F��y�e��T4�(0=�lf�Z|տ%��,H�>)��-D|2 W)\c�p_^0�lG�����ޥ�iY���}{ێv��Ē��)P�)Ϗ��υ�0�*����j5�<h��!>���.6����+�還�ߏ�DT���������r7��F=٧GJ��a���Yl,(����?�]vϩ��]W.�a�-�<ŉ��9}�Jzg��~'xKz׀\,�w�s��즌y1�s��Q.�x�q�aT3Q��M5�b/F��/{lv�T=t����#)N�+�G6�=Fq���ijnH1	�v Z�Ir�����*O5�7�=A�\ט��J�p/��j�������;G��JЍ�~����m��p0�N�nyfIIі���$�f���Y*���Kr%��6�~�c'mI�ώ�[LZ{�]n������
�~����M���{�	�
>�K�B �Oy��B�/����J���e5ڼn�_ZF���M&�/��K|��Ft{b�:�L�(���h>�f��o��{9"~�?%��e7Q[��Sפ��4��:_�Ǯl�/�����Z��W`G�Ky�p�v�4 �3�Hۭf(���4�\A�s����OI۫�(F�������QpT�B�i��RO�e ��;^�-[���:�"QU�"L��U?����l�����a���	�����oK�ItDe�F<Oe�Ь�$DU�g�,[���j    �V�M����O�*��E1�b��q¶�M��d�7�e���F��>�跤���7� $kے���T����=C��g�²P�Ï��L�I^jQ�4�AXnkA^�����b��?���QBL�v.��+z;����Xr�lN)��ˑ�����~|��?��[��7�
'��Z��ڞЙ;���D)O�V+�߬�Y'�Ŷ�;d)�vة��ޮ8��ǡ�Z"�8����4�ض��T�Û�vz�jAzv �	�b�&^茻2�p�k���(�J`�� ��!.iI:I���`����E< X�z���(�ka��AM��r�aW���g�ߊ��6��N���������<�h�'��o��蚯v@R�C��+���� ,b�T4�wH[���胺���A?H�q�:\����R��n��;��n��8�A��p@�~�&>�Ut��[-uuc\�/�d���2�+X�/߉~���3��z�JX�yd���<��3L���m^�K��)�B��^@�./s�+C t5���j�����t�k�ި��6��8҃�x�S�+
�Q�Y<��]R�'��(Ll�/��[��FRX�/Wby���=��fX�.�CV��ɡ�����a�rח�Q�>W��ŭ%Z�/�Uw���R��M;ۧ�cō]��W���(L4ȳ��TӤ�dX��S+Y�����R�QCS�GDʩk���8��rum��|�.���Fp|��ÛU�z�za��Ŋ�nD��NK�H
|�I?Oym�}*���L*3T���
J��K�ѵ0��׋�P�g�	�<�!�e$��6+Ha�4��8 Ҍn����CMSL�r���+�d��K��2?`�E�r-��TJi�%Ʃ�z��*�yA�.�[�˒+�/&�q3~X�Ŕ�~u#�
@βw�y�Gߗ��I�Z�s�|�;��b�i��]�����B����dN��j�8�Ua �_��3'����&qr=�'��گ.�x�.b�`02�@'�yq�.�XA��_6�F���2��8���:rp��\�Zm8��.ےɕtbR����w��f�Z�_A�k��]�v�.����%��l��t��E.[qQk��W�F�����ylaD��|�R�)%z���k�6K>�Z�n+`mG��BY��m�T�����[�hD�(�0nJ|�C�-�S(U���)t[�ؖ��ٴ�K���G@�J�ۅQ牊��U�Y���ԆBn���J��S?�mؔ�i�p7gK��fz�M���'hy{'�娒a���d޴*0Y��~n�-����]��G\�rb��v����[����E8M^�.2ߊ�b
ݹ�eӑ+�#5o�W�cH6�Q.��<�j/jw墶<	e/��-�h#��uӯ6�<���� ��ly�	x�,�C���*(W����mE�v/���:*(U�A�z5@	��r��f�W��_�d�J�,�%>��B��r�œ��y(sb��)�v��A����z0�����+�O`9S:���7K�z^EtjX.Z&U����8�!voW�w���V!?��K��!��7a2)�ǔѲ<I��Q�vu��h1��Ei;-uN(������Ī��U3��[}�TDGUA��>;�E0W<h��������n��7]�Ba"rhC	v�^��J\=��"z��*RBUJ˭pW�D-�M�ׂ�뗎
0��2�So%>�e6Q��7�YQ�u�Y�c!	t�8�k�e��/Q�9G~�z�b�����Maؼ��� 6m�,t�M����b>Sտ�7]jB�5=�V��=�v��;�Fp���xg�O����.ݭJ������|�3�H5�-�[V��Jȭ)�;���\�*bymiQΘ��]A]����8��P�#{��0%���N��=]�mn��3|eo�&b��l]*2y~���r�Q����q�v�l$AW�W��E]f�<'E��3��|����?���c�V�^���k:����`�;`�q��~�Q
[�/Zޏ~V:���(�B�i-���t���!ZT0e���d�Po���S�V��UZ��c�J�t�~ �l���Yp0����x9�F{x���q�3�߁��V��I�2��|�U3�x*���R!�U�P�8�ə#o��� �ˏ�<��&V%F�;j}[D8È�6H�=H	�j1�Vi	l̐ճj��c<�'3叒/�3�![�J[<|!"<k�[4���+��i�H�d�Z�i[M:,f�1�]��Wrx(��N����P8�K���s�N��􆽎�}y�#��w�m��.�~��5�~����^gk����uR�)��k�̄C���8^I4�b�'C"	�U��D�Y�j҈�D��R�!`p�A�`զ���-��J���A��Z੡3_!ηt���t_=�w�M��P��K��T�؟���Y:����Q��/�!��y:ؕ�Y����:u,����/y����#:r�k0b�Lb������v��np`�gA~q# )��c�1�3��P�>_�+��^Lr2���gx�i2;��XN!�M�^�:[�>�Ә�X��:��HR׳Ad/�.x>�rLB/~zz?J�� *o���w�+<�.XRZ�����h�i��I|�{���u�q�y�=��L��c�T�n��$T� ���G�8�^�|��&3�g�({�q�5LWq[��^��I3����6c:�%St�+��$A/,��R�ܶM��V
���
�S�"��a��|�ʊ���a�̵�x1�&�xWvQj~1*��A��ľF:KF�n�8����WJgz�:��F�X��ӣ�i<�HZb����ۯ'(J����<�-�l�=��5�5![z,�Et��q:�8���Gq���p1#]���ӿ,N�k_�b�̸���YI'sb��!܋#���_���4O�׹"Xf��Ԅ�8�V6L���@��N~����?�
�;�J��P��=����-U�g�+�:�_��:R8-1V�O���A�i9ܥ���]���;��,�:K�k]�{�~����-��c��.�	^��DK��o��Lz�?��?��a�	

�f��V�A�>���Ɵ�%��~1����U�w�F?��z�܋oL>g�G\���=�2����L�������sM��G?�^6J��MхK|j�t��w򯘠��(�<4�l1�O�`Y����֘�+'��
}8J��r.�w��L�-7M.֏���|�eqVk1�-	�1��Ay��"'(:B������]?�i3<wE�Ub~�\ �O����
�o�0�F�$�8����o{\�)e2��5��qr�������~Ww�+�N0�KF��$j�5�31�m� �Q��Q�F6��8��Y����a�]'��g������� �� �`�l0?�=L�('	 ��4���,��)����+�L�~�f�����ڎKث�9?w͝�f��f;_�5vSd�<�B̓���҇g�Me�p�a��kS�K],�š)|�~��1������2Lj:�<඄C߳��d�]ZN$�YN��4I�e+��JBm'�i�`H8r����G��%��x�� C9��@��<�6��IqДeThZ�Ρ��n�-���
�x�����`D�`�M���'��}|^������^�O��t�� nӏi\���q--����/��Ꝺ�:ZY��)����}|�i,��m^���Q��{]�1�	�3����lFd�.E�86\�6x��@�'�1�O�t4>8� �:.�2���Ń�ܷ�N$�]N�� ,��mW��q�5���43�=f�w%�Nl�a+�Y;�n<��@3�-����~���<50�Z��6�<-����=\�Ծ�o,�$?�#iPjGw�ɤ��,��[�<]K��nR4�1Kε�u|�����p̚���N�����b'5��QF�J�Kт���$����Ct[0��0bb{?�:���tvX/�oT؜v��$�Ϳ_�ө^%���l��A�E�>��d�L�0~88� f���BD?�;��E�
�M�s��ڤ%9l�h�%�#�*�O&k�SE��@����C̥s�}���ls�LZ2��?,��e����ua!�*��4    m�l�/��	ҌI3��|ؘѯ|ܻ���)����Þ�������iI�n�K���_�������g�����A��-��ɴ:�	(�孞��£��tLM~T�o��4&S��`1y"����pPg��O�ȳ��e	'h�D����;	D�oƶ*�!����L��e5�wf�}ʦ˨�p�Nn���o��ÁC�2�L��o���ik�3b�d-��f�;q,�)T�<��́	��N���5'B��4B��8^!��ki�gwx�`Z���l�a/���?��K��j6�*���&�vO�6G������$Cap��Q�x� }͇\z�|9G�v��yw�v�{��f�IUd����8/�u�m�
�x4�&��� �bk2$�l!r�A4����(c�ʻw���MZ��������I��+�iRx7mϴ�Y�E���`�Es���(��]bNղA&{0W�y��Yؔ��k
V+^'�,c�pސlp���s�N�Ę�e�Ye�l���'�4�2�����,����ˮ���8�����]<q-*�:�O�\�z`
�w��f&*�7U��±ꎳ�x��@�4�N]4�������]b���D���*R�;���&^���,�0��(U� t�s� U���ar��R�=a�0X��7s9LFr�ߦJǟM.���&��Kx(iJ,_0��B�t���84��4�9�q��4��E`����� ?�(~Jl�z*����d�Iz;�Z�v��
����L�|
(���HsO�>%�k=�%S�x�%�x�5k�O��YU�S��p��
H���sD�C����x�K��:����g3�!7�	7<�5�z_̴�O��,��x����J��!G�d%V�U|Һ�c��w�L�Zlގ�ّ�d*cM��c�%�G���"���q\zs����^l{���[�\�f���j����<�,�H;K�iY�87=��u:.Hm��#�˅2�������Jl��i��]�������Ǜ,������}E���4�Iq�� �� �\�����I<Oߋ�}MLY�vVǙ�[&�U�K�҉��H��u���bw�'�	 ���ϣ6�������LDn�m'�����m��̏�YVbW5���e.e�9�ˢ4�-�)�LK4[���?�i���Y�m��>�K >r���f2"�N���x��L�5�T.��bL'�iF���N�e�Q�����l��j����oӮ=��(@�M�^|��,�;��MY·�`.�Es"l^�0�AN�#U0r�6�@��P�
MmbS���]~=4���H�y��![���L��g��b������Ĩ�dS���x8�8oD�Vr�Xc1	#��A,.]-U��L*�H���1�]<�'���a6ޣ+F/����	%=1��4�����t��5��+���	��_����>�Kv�1y�j.dIK+�~m�rv9��4ǛL��@���	�4D�5 �0��H;Ƌ�#���8�է�qs#��t��ê	�#	O�W��Z�0Qm(E�`{D��,���0�,6����V���c�9�x��{�!�I`�Ͱ�k�����-�=�@s�eSǱe����,��{�F��I� /����O������GPfr]|z��m:���~w;?�#�ģ׊�0������l0$@��NV�
K�����v�V�7Ny�>9��M2C��O0�|[��iy���]Gd���ߥ�>��K�KZ�d&�ic1��3�\y���vM�z���F4�H��䁑��r���K<�-���2���~D_�.�N
�� ��0��|��V���B蝻�!�[~7:*�n��E[��k�"��Q<�4�����Jh��o1��:#8�D��yZ�
�ـ��l�ݧ��7�5:�L�*�a[���Z���78nϱ�1��x��/cN&��
$��Oj~NG�t�U
'���)A;��r���C�f\�n>�a�u���m}Z%�Ub���3�>��͡j2J6/Tg��h�h��Hn@��`H�e��	��'ӿ,�}��}Z��*1Ao��'���JS��0���n!�0G6��E>����Q�C���Ll�w�-J�ScV����"�f�Og=�Cg���+a����v��E�v�{M�:��;�����P�T�0&��eۉSl]�r�-0#F�A�������qp�c/1dw4�.~��g���7Ъ�+�C��ȱBv�}���5�E�%|��#�#��P�D��c��3c�9;�>� ~�˥_�����.1��f�S�?��	�\˦��%J ����)�u��H��?�!�<�7����Q`�X�`�δ>+����\�1�p���fD��B�lD���/���mq��ɑ �绛f�l��iQC���ƣ��0Ss-^Ń�,�ⶖҭ��g��?/?�r��÷���hv�UX�A
��a�|�a�p����16��$둾�F���KLbt"��Li�̖mu��<G�h��Y<X`�IL,	MOO�69P�K3���,���R���A�>+�eQ�"\�N�k�"�3���>�����	��h2�`�b�@��l�^���9߀��O3�#�����Zt aJ��n2�"^��.�>��%�u�������� ��4���g-4xZ��mqj�&/�<$3��o�����Sbgw��>�1������R�
�џ.��'�r�7�~w޽��Sbb�b�� o:ߊ��Q�#�
�a����f��=�����P�P~�?n�,��������/1�o��������dL�*��p�ے��D�Ʋ��?�6v$������k��y����,��{&�6��0��l����6 ']�&���I���μ�F��ٝ,.�NGØD���@�ky�2#�q��(r\'�2��{M�y.��Sb�]LTs�Hk�TV�n+�`�*��[���.��ψ	��m����^{�.����c���iC͔��$�pǴ������P�KilMf�r�\3<y��wH�F���_p�q��np��Զ�$��.����b>ʲ_�� �d�O�>"��Q�/���8�K��^9&�8����@C<�O&xQO��xڄ<�q7���?gy��0JҺ��a�����Z���ޯ㾅+HȭxB���¹�کc�t2�'�1F��eP
�^6,���Z�2P���[�F���Ŝ�I�u���d�'����4��U|�g�UL����NaԬ�97�|ԬZ�6���jY �� ���{ǩ+���xG����qUq�C��bǱ��م`��~�i�x3�`��i����sV>yt����4[s��������[�+�Ԣ2�Ď��^d�x��]���O6\-�f��S�k8�[������Lv��k�5W\�# �'�����y6)K��0 r���G��[-�}CK���F�B�쬽_5N3�)S���	�l�r��a�-�d��x���]��	���xN���Sv�+]���ܶ�G%Ķ,@�ٴ��7x{�5�³J��@�=��o���X����ϟeuJ������i*�*�n)�C�U@A��>>0�k�6�_&�h,��!#�GV�]��rG���-Pg���$�;�^γO�\�U�	���t�e T�`2�<�x���4��*�=����;�����L�XG��|.��mg��?�!)��Xl5suְ����T���O6��w4��m�.SJ8]KM<�����3ע��	�����w��8pz'��rG�����x�4��s�"�J��b��;$�$�:���3�N��a�,r�s��ޯce~�+Y�*Ė
���1[L	\]�n|���#���H74r�i��)���Sd]ץL�~�ͽ�3i���k:��>��l0��������		g�\�4��������(�
�*�ӶtP+A�F6z�G5bz���n�-�Z�y��% C��C��q�A�'}�ꉣ���;�]
�����m��|"=0���J8���+�?�2e�d�F7$�(V�[�t����1��� ��c��"�ۦA��:��1~.��h�}s�����~$�����84"�H��yA�Mf� ��qd��    u�UH?�P}6��$�`h����=�؊�,�����/(���Fӱ���"ǒuL���-[-�/�o�N�+��K�X�v�`���e�ik�@[Ow�2�qۑG�-v�J(��h��PÐ�������Q��6yl��b_?�4�-ײ����� w�n�ܕ�ǋ=ef BQm���V
'��!��d�Ӏ<���������X�qkkʯ����uw_#�� �q1J���ٲ�n��:J������9��_���@��Q�a�:&�����0r�a$2��0o"f1�!�`J��yr�k�P�ŋR+��Xn�����}����d���K��Gm�zg%��i h3��{}?YBlx�w�{|����1v�TUL^�lm >���[G߇�7�؇l(籽ʦ��w���?ڵ�qR��D�b�ݎi�WL��]L<nZE���i�6�օ�����I�b;�ޝyAeԃ��A/L��@�݌�) vfԣ	�x$���	0Y��H���$�T��>�$�tF������g�k�q��*&���=.��ǲ���+�x:FH�U���t�,�<��[��J������C:{gX߫�;����o�����<wr(\Iu�Mm��[e�x���oEcm.bP9 ۇl4��"H����6̟��>��*_�Ӎ~�@�Fզ��DF�M�!��XBM���4d#�8����Xn���`#7KB�����Wdw�(��D�4�>��7�:�Uw6����_�C�{o��)���.��p�Q����ڇ��bN8�J�3���a����b���d����ې�:��t#s�*��R2oK�ۭPWFoׂS��\�թ�8� �4���4p���S�X2rN]�	��Jm�2���^��������K��"���E3`�J��H�y��J����m�ɟ�p��U������_�ߴ/G�ux�O%]�ċ���m忰ucY�K��ӷ��t��m�q�,1-�p.|��e���b�e�����!���E��>·�++�t����HÉ$����/kKx��+�I?���� 0�EƂCf9�b�ҝ��`+c����@�2`Pl�aP��CZ�V8s�C&�	^��-�|�'$��b�C�՗����;!to�a2%� Xş������u�����!~�c�t�4��G���/��)0��	�I�Ӡ���l��c)ԢVB�������Ï�㒛��R3���ɉCE�ic=Hp×�kN[������	�5S�d��g(,�f6�X�}H�C�K�	�������pqCx-G���C��!s=ǯ��E���/�iʰ�g;�drR+q��:t,CD;,���m�|>fB��p\�x���p�5b��{�el�_��.�m_�}1Y�`ቬh��� vHe����p����2$W�Q�J��b�ý8�G���C{�&��9��v��fY��N���A8��20�IK�w��7���T�X�~�g�	�������}���H�u�p#E���y����'��F���I酰M�:��E�^����fRv�+a\j���뭏��}(���6��Ʉ�	���&�5#X��=Z��*:��_;��ñ�v3���G!:�d�3�������9gT5}G�T<�>K��|Y�zyN8�ŋ�hq"���h��� �	��BG�`�ڶK�7� x�M��5��M�DF���e�a�� �ߥ��:뱖�Kq?"��F'��,d��������*an��X��o�l�eQ��2��Q^�Q��5�<*W��T�?�w	1]8��\Ly޳����I��{K�^KKzo�Q�PD��
;���/'g�uK�u<N���*��Dͷ�(ђՎ��$�w&��;Жi�F��0?�d�)��r;o�x��$`��������Xn(�B����-�<pm�ش�]"�[dF{�V{�&�I�K�к�i@�$6�򦹍�VTJ���ރY�8}�;	(��r�of�9`�I�__?ċ_��&R���t�}�ρ��}׭�׸� ����B:�]� �Դ�[�#��?Ǡ�,��'��~59rp#�����>��Q��~,���[=TI�M��r�v�v�1X�� l7ڕ,'l�R"�<�Gm�C������#	
�p>U%F�@��1$���-M5����&�?��g�u�����b~x%�[�G2�y��]�m�9m@&h݊�@����cf�`6�F�w�\���b�$fx����u��UH�E��c'�F<}�gy��j�p��ͼB-����]���=|�*5 {$�
��do�l�����7}Y�3��k��w�y릵$�\�[���h�k	���o��5 �s9�t����\]���/R�<sYw�˦��r�t�2۴+�+g��&�%3�4N���(����a@�H����}����F?�� l��8�G��g�Q9�l��2t�|��g�h���p�g}��3��Jn�VZ~3lG��ס��m�}r��:a-��izp���Ik����8厬;���V��&i�����|���g���NTm]|R�K�n���*mqџ���aek�r+l6����6/kQk�L���n���zX���k^��N�
�fC~Ex�M3�E�?�Y��4�j��/���E[A�J7���,����V&o�ݲk�0[��z?�	���w5��i.��1&�����IƜ�ʮ>���tԂ�φԃ�Uؖ��� f"��5D^#�J�A%�!3a9wC�n,��Sy�Z&����FJ�Wy�~7���3���|�y��߅��-9O5ou\JW�d��<t��P~����\4���	�ӵQ��gX��FE]�v,�fB���h�j،��H�d����	JIU�s�\H��f�1|�6�(<��և��%�~- ���ǿG����mxID~��o���#�J6/@��_E@�f���$�������3���e�йEz�¶���Nm���I�gĶ�
�F����ҿ�q:�����ò�F��qMرn^��������w�+C�Ò���.���u#ۙ-Fjq/%��{R�!�hWL��eg�bs/�����K���GA����D�.�)�JtԘ�{�hpItر6�~P�dRE�[L���H������.�1?�5�H'_
�l�@- e�_��3�"���?�_��ev�1���i��*2fe�ol�dQ�d+��J�3C/�]�^�`aL���Ƣ��I�7w��dWvIa,�e�P��5��ӹ� ��d�p��oj3���Y8��ɍ���O"�l��`�n+��R����4=����M47\��#f��K,Fdt��}.��R�E�c;�d�e1$�K�*���q|�e]Gf�"���H����r������T�{ �l��%V�v��5*I��t��ŗ�d��>+Q�] �e(7����Һ��_`��LU�e:�J`,�_h]��L�e��q%kA���E�����0�8-o��wK�#���]Z�	'��D/-M:��������'�W���Ҷ���b�,��Sа�$�A��z�葂\S

J	&�kj���Lq�;��^}��蹾��'):f�q�S(W�l�Z��b��)1��T+K�!u7���(s6k0<2�oS �\UO���b۱�e�n�q�w�xg]�f�ܲxL����pӰ5�������/�ϼ�ğ?�����U2�qcT������x�P 9_Ih�Q�j�b�*BHj������a=� �[ʦ�R�(�Cݲ�C,�N4>��o�/�B/r����	*~
�T�y.`u*�����R�xz�.�Nr��r]e��B�:�]7/�V+qp�nu�Ǩ�8�q6�QV�m�1�ޒ�N�/.c�}��l��ssT!	�d�ea��4�ʑ֬^t����Ū���RX˛���d!�	F�#�� ��~�o��eA�ĳ�U3��n���qi����>fki���P��1�eX�� �[MXw�A򀩻����$��b�ˌ|"��,�Z#��Gt��e�|��{��0E��<�'2�UؒË�dl����V+UD�L6~�­e(�]ú���d���6瞖&&��    ��v�]e �����b'�D�b��\��4��p6O�U�5�4����$�L����|1W�ҳl���yI���W��A|�>���*�ڨ\l-����.��� ֊I�)�����`,�r�k�Z60�L[��"��K�U�7/��Ժ��Td�3�������s�K�~ ��c�=h�^�na���w�L��x1�>��O��N�
o���ND�_8MgK���z���.�\�ɍ��'�CG�&�?���ͪо +��ʴ�\�&hΔ�7;-�n���b?���f��=B�_#Y��(�k-����N+f�(�-Ƅ,}�K7[L�1�:�?{��8����J��e����*)��XE�lR���6i	I�	H�Z���̬���ͺm�Uۿ�<v��.�HJ)ev�ؔ:��� ���?�~���|&�l{�O��~?P)4�����s�E�@p�Ɂ�p&6���O@ƿ~�W�s��Ε�V7��z���)I.؏��[*��ص����6jy�h�g�\��}'����]�Mc�x3'�+b��=��u����Jk��g�_�����a6��l�;f���Ӭ=�^,�U<�J����V�޾��%�S�}��/����E�D�v��>F�K�R�̦�bk��k������g�I�y]CF��J�t�6__(�z.�Yx��Z4�p���|;Z�W=��qk?�>�w����=�T��`�do,��um��7�����t�U1���x�ln3߷m���K��*���0�D�I��ǂ�9D\���yz[��^�k�xMۆ_Q���A� v���e����qw�:ڞ��%L�˕��Pp�D�%�Mʠѽ�;!K犹*�2Ɲ���5lP�0��`���C�qߢ�5�ۂ��f��F��G��P�W��*괈�#�8��@C`����kYodl6�۝��7�ן�W#
���.�O>�#+qo}I����^�m9�X<r�f��Jt����e&:x9
���=�p�Ƕѱ������E��P��R^�x�v�	�����Ѯc�����A|����і���s��tۀ�W]���f�0���cR"����g���h4�Z	�v@j��PN�)ā)�(�2k��2&T��u
�$ͫz˵�mr)����"��i�3�#�u�����@�IZf�yȧ��_S��r�ϑL����I�5�PV[�}�KM��!D�Ez��;Df^x$���C�b���.Fs�%�{��k)��_s�уK��z�̠�o�?A,I���ԋ���t��yj�1%��d��q�h4�F�O�,� J�29�/���XV�v,��s�@mi���H;<���������z��0��g!�$�7A����%-d�)�������+a1b&�:��/�Y��-��u��.	l��a6�[.�#+�62ȶp�F�]�����v�W���Q���e:I�\�q��K��j����Y�Y�^:HiuM����Q�����&ʹ7]��fS;�����x&������N�sB�	�i1���dj��1��}[�s�ݱ�V���r�&xU�@<
@@�g�����ͩ���+�mZJ(�a�|��hԝȂ@�w�>s��Vb��aI�P�
��Z�b�8d�#Hܸ�5=��}i\F���n���U�\�[=���htz�M༢��*j�X:%"_.4�Nr�'%�ڲ��Xz�("�CHlL+#GO@��}v���1��1����=�^%/��x`�D`3j,�����������rܧo�<_��uˑu;K��L&*��a9�$�^F7K)\�X���y��2땐u?�����˂���5��˪�Xۼ�8w-3B�'7�-n��5��Ci�j�Y�F��>�m����m}0#�:����z�I6ʣ2ۡ�J'���(�6�{�J�a�p��C2�� �z
O�̊1�.�I�`�.S݇�����T\�_��l�3߶��0E�[��&��eO�6�o�^E���1�2㡋�ZEe8\�M�́[�W����=����<�8]V4�m���u���
�6�ey�&VX��Jl���R���� QM��~������N��wZ@?4����Y�)Zݾ>ʂV@u���~��^DB*�U(��
�U�M:6t��Z�R���3΁��ckq�x�\n�6�*Y�+��o�k�uDZN\묜h�#z�t��dC05�&�[��Z��}1��)��<�q�bq���G�u�_W`a��e�'��֘b�����T�Μ����86����R�"�8"AN���T����q-�r��Ow9LD�˜"�,�ܙ�S�_�}1n�$Qv+��u���%nvCE�+ra}��ɬ�![��dd�Y,�Gy/'�#ֳ���8��
�WB���h��!�a�b-`_��<
����s0����h�W�b99%��^�0�hJ���>Cj��Y��ed�+.���r�伶ȪPV߶���N��C��?l0C�NO�M|K)�p�@�H�#�n�"��w�r]L\�l��,��xu!�v����L_��Cln�6;GB?��~"^�2��U7���P���My׳m	�O�A�aT48;��U�
��h�<�� �5UOk��p����w�*�Ze �x�Q�Ъx���3%9jf[C�d����_��w}�y��~-&�+=NB�JM�[�03E�w��hn�*�hat.��g�Sџ%�}XQ߭`��M�Z���I8�����Jl����بp�m�=���ɗ���db,d�/�`_�N�V�E�����Jw-3�F0N��(�� ��wl@�X�y6��;%Mr_��D8$�O��&�e� d�zM|�ME��~�H��b���$�m+��� kN�q����U5�{!8Ȑ�G\or�f*U��Ϯ�.��ܲ�d��j�X!��	0��a�R�tB$J�G�~�yi�.�B7��J�}c
�2�+ҐX9%�R�����1#vSxRT-�p��}%�kڞeT/����|�Ux�2�����Wj�|9�U\�t.OD��P෯�N	^/��l=�s�J ����3����)%vt,�j�-�2['�G��[�p=&a;�+w���l�ᆳ���^lPXY�N0F����C;"��e^<�L%k2GA��W�|F}�h�+�I�2��?-uj�:u��K|b�w\���uԃ�[�X�3W�7hɷ���-��݈2��%�;q��Da!���d��)�=t<��w�g�Oq@r���+�N��.�psؐ�ƈ/^���"h=#�ho	�^�Y�Li�G~���_ ��Xe����L28��]�K0Ս��ƴ�G�3�ܠ���"��� ?��t�Y��*ܾ���障�u|���n�D��õػ�A�ۙ�rs�86e��'V:J�F&��E�H�S�L'e+�8 K�w��/U~U�.��X2YS��PXW��J�@
Ʃ��3��m��b�Iv߶�*K�b����mXt�d�����6l�D��N��G�[�_Qc+��n8�+�d��,�5I�y-��~�"����nh�����Ib�JT߽D衩Pr���A��v�O����J<���F+t�&W���.	XB�g]Q��.� ,�v���ξW�F�B)]V��]����C9�l���Wm%v���3���WGKQ]�I���p<��X��+)�d^�"d����b��ث҈iFmbQ��Z\G�����,@k�=��(2>���)�rm���D�!����ŚBG8ĝ�e7q	�ca���&V+�������$+ �XQ�����#Pq�&�9����ӡ���O�J�&`ͤ�n�,B�]V�iC$���$E��X�&&�:���<�2�ü^Jƿ�l������I����~}e�B断x��$H�M�%�(�)�t`S�'E�ēr�E����!�2��:<ܧ_&Wz�Ӝ�L�`��z�����M�5���Y~���t��IF܀��ౖ6o��(o{m�{ew�ƴ�;&u��/��-Zw��d�{���+!�wQv��k��m�+z��a8���dk�Ʊ<��}��2�,	��"��kAɍ)��#�ꋪ�wB�oF�U�E�m�    鷇�e^����ۜ����Y�2��pۢ��D�+�Ew��H叡��e8����99\e�í��A�����}�����]2P�U}H�hs���ed��xKC�&��.�ˡ����΢��[��{e�<�+X!6n�����
��ڜ����;T�Ĳ;�&���XX��l'Ω�c���BX�E;Y�\3�{��<�QX���x���V_�]#�oK���PeJ~��6^��[�br�2�\9;�*����]���!z���s���@����x}���vv���y2�@�<��Pv�M@���j
���}%���8�>a���x�i݀."�2u�bg�=E�����D��s�p���7>\e���"�ك}�͜��q�\�����#����({w��|svE~�|�#�㤔\N9ɫG+�����fv|�
�`̺A�����w؋�ٮ�{�YUM�x��.S���o�?h[�Epnc��C�۞���e��`?�M%d�������L�$�J�g�ͳ}�E��z%���l�c�� J��}�x���fD[��z����7 �w!��طR�c���1��R��f�A�׀m��<S;�^�u袗��r83��I���l��Z�O�^�'(����t�^���,�|:��B�;�mW-�,h�jF�ƯX4h�٬�j�o�Yxͣ�q_w{����ْ��#�fP�>�~j}�G�8�NT}�O5K��>3�N"�0�_��.�}'(���*R��A�+��\*��h��7A��z���Z�rs�	���E+�Pkk�^Po����m�Z&i�i���Z��Fp�_`,����O��M�����Z�)Y���id�J�����Kɞ���5��2��(]5F�g�8�YU��	�"(+c�6gjġp��{y��NEf5w����l�ir��Bk�n�C��i�`�)��jJ�V,�ߵ4�)�Q�ԩ���P�Kc�� �P��-�%T+�i
V%��������	���
�W������K��c�~v����\��+#���<�|� ��#�x%6�1��pmԼDS�TV�JpU�Q����������v��/�{����G�yql�(`��? %P2J�Y|��Q�v��ԅ8ޤU3��y��WAL�}\�B�2邳%ȟWq�ʮ�q(�A^_S����=:B�M���u� c>ӵl�R-&�2$��<-t��30����Nn�`�w�!��~�ȋBP��`��0����z.f?�f�����A�� Q]�+9i\ �sDK����ޣ�]s��j�7Z7�g0>k=8`X_�:-�9�F�&�Q�8��7�]�H>_Lt��r�CB��Z�"���j�x6�Ͳ�W�qfy�"��L��#3#<�Q���/bS����[��z���;DG�m4��p��2Ҝ�U՝_a2�\�ĝ����W�h�����&�YU��������:��ꕷ�eQ�Y[�̙���Bo�	��}�Ϫ�^I]#O��B�b�qN":0[��,���$���#�{�Փ��0��[��@'՘-�q��PŤ��=����w|ƿź�hǁ�u�?��2�$}� �����6P?s�Ű�,�L�$ƽH:@�	"P1�Z�wt�HO?���p.<!���;������R��RƼ<%�:D1^N�[XGIۇK�M����zJ��٪��:�-w/A�R�Ԝ�ؠI�l�>�;9�]��A&a�6���w�qF:ol�����x�ݵ�B��,��n9��1ǲ���%� �@�6����r�A���p�#�_� �#UD���l�T@����8�&�y�^�	p�Y١xl��$l���z�.H�q[ �b�=`W9^����5�!�m�Ѩv�嫝��#��ʮ4�'"\y��F��&�[nŷ��V=��K���(���J���6S}_E̫�j1�r%<Ud���� ��~��Da����ֽ�I�����[��Q6�;'[D"{�pG��)��;U�8^Σ��>��q ��4���P�F�۫(ln��tʃ���[����^�@�
�S�n
l�rr�&��a�ѝ��\�9�?�)��u>|o�)�Mq�z6����Q������)�3�n���C$XN����#{^���J�!�38����������h�o�u��3�ϡv��PA.��
T�ǯ&�~�m�y���K�v��a����)*�2��Rp���
0���m����jb��'��>6s���f`��g��!�����ݺ2�!sF�U�l�'��.3��თ��%���LI�.*��/���Y�t�/�Q�I:�F����u�����E�&z��ϲQCw��)Ӱ�`�Y�CmK��P�9�0�3t�1�.=KD �g3��&�'��R�8缺ڢd�}˯�&��G!@dH\�=�S��*Di)^p��ޟZ��a(HY����rd?��p)V.���f{.��-�l�w6�8�b2-�?�͇p�e�������O�2�_��v:Nq'!G`[p�v8���χE�R�(�/����V#�k��N�帊��4���|��]���9��5�~|�x�(��r}���p�ʐ[�����/�rX�D��Z�_+�xa{t�4ګ�é�W);��� i�(D�����\�b�ra&��p�ڪ�W��ZSf��`H�������0���\y�{�(�[��[��fb���Mra�a�5~�Z�p8ق�&��8l�����65}��J��@�����?�k����Hq����G�c�K^Ҫ)3;V�
�+!�΁hEZd!��Nc)m�߹��Mn1��'�f��#���C?D��o��DԪ�u�IͶ'�~u�=�G� >���y��B�C�����/��ĽK�p�a�ɹ[��!���jt"��Zq�JzZwd���u�a�!��o��0��n�qb��S�1��W��[�f} 2���xL�:Gݶ��������w�����Qw ��=8�:������q#��]�l_���{�9�U��hpL�NZ���h���[��UT��v8K�(��!l&�tjz�I}^�#p,�Ņ�9�ͣ�I���8wdK�����;��Cx�	�I�6���N����&Fg�sx:�c�O��+݋�խ��</S�bϗ�m�!�g~��F&���ۭ�~ɚ�g9��<���c4-�3�8O�`~�6��#W��7�{���w�������i��t�P���� �x��t�]���- I��8�jh��lO�$L�$�ו��$��q��#!�צ����?�>Krn�}b}���s,�#�?�BQ[C�D��Q����wL�OÎ���38��%n��/}5|9i��<�i��'J5V�m8^P����_�f�S2�f��������@���n�)�R;P�_K��u&+��6/G�8"i���D����9��� �t�^S�&`��9(z&���~V�G7�EB��3���o]�ö)���k�A/ù����¼��g��h��Y����z��@8*�|����n��:R���.a� t�G���&rJ�BN�K�Df�ٓ"<������f���"��x��FNe�*��6�冘w�{��U������,w�!��)Dh��]�����
����R�-�?��κ�@�b͚�c�*�G�v=�V����C8��b[����Iܧ�5 'q�`�c�գ���|Oͺ�_�.��~ؽ �U��v��y��'��z��u"�J��ɚ[�s������<?xhd���M_��Y>' ����]�zP�Q/�*7�.�|�����uDA+3FW��H滏EBr��U՝S���@��.O �x3'�(�'�_6�}�1�����'�=n�.ڝ�
�*��#��O�H~�ʿk�>1���I]ں'��MJ�^��O�k��q���a.�EL懆C�@�X��LV^��6������w��T{Q	,��o�uC��\d��� _�H�����Q�Ń����;�Pj%�b�#���QM�V�B�>�+N�C�'!��,_�c�;��H�M�./��fx�m��$�sM���i4�    
���J+���X�ɦ�N�?�&j���pSЎP:t��T*�[���(��b%$>A��ط0l}'�踣�"��Xӧ�a������7�Vo��y-#DjX4�^|U���89�ZJ���!	�uj۩E�0j�u;�\	�� ~�o�+�F�]�S�/H� a��&�m�ڶ%Q�W�,u�S�޴=P^{ˢ�ݝ_G�&��H��`E)����! ���p�t�^�e�,L��h�,�q%j�	� ��|��i�D��R�T�8܁y�ŤN�����6����,��v$ۖs *-.�/�Eө�'e��8ON��J��i�5\(�&tYP��y��q*fӭg���<�L���p�1��\��2��)�������k��H��Ε��� 
�Xy�Gy�0��zp��:v9�{�.>�wj0�`<
E�U#�TÛk:�)���d�ĉ�1��KB�������1��uߏ����y ���8<v�m��(��;���o�������V��`���Q�����G�N�%]W�oZ�)�L�n.w�	��8K@W@�k�m�68ˍ�֨��_�Ik��(���6gp��$��{{{:8?ku{�����hb�V��y���@�hp��qwt�:ȫ|��8k��Qkعx�H��F��?X�[�Ć��i�MI9!_�x<�K�i�iN���b��Z�������4�2�Pt̌<�msϜ����*"N�g���1>�F��^�=�r�V2j�S`�N�F��僂$�2���N�q(���������஧s�j%�,��(#���ؕ��b̧>S#�	v^8���5���]|9��g�l/ѿ��DӸl��v �h��w�&D�)���$�F������b�˦/lXuA@97Z�_��@�J(�?��L_�m�\ɁU��%��`=M��-%��_f�p�v	y�C=@w�#o0�����$Fx�I�N�qa�'$�_�*%��KҚ]"�J6|�8�v�忓|��o7TE^��M�Jh5����_3�O��� ��\Nmft�85m"����BG��IUmAB63j��ݬ.�f�3�m��gc��Dd���'�p@��}��NU!m�s<��V�|~��x���es��l���u�����'�w���]�L���[������.��u�7n���\y�P��N�;��[|��B�գC���� ��8a*�ÉF9��n%o�X�s=�A��9�� R�s��	܇'�����H��c#uJ��'�Dn��*������m�A��QDz����\�y�@aR78F�1#��\�i좟v��q+��]L)�P�~B+�4K���.(+�L�ܼ�~E.׆��ԝO��$��X�h���
\�����U&ɭ:I�h�|2V�A=��qN�f8�:�Oɑ���L�����H������M׷��wax[�}�3]�Kp־��r^��K5�n-O�}\�Г�Ҳ|��+d�p�;f����j�	�߆���
� �&���2�*�C�8T��^�w���:� �@�AW�K����1��R3U9Q�Y���}������;t��c)CE`U��GX�4�+9�"�^��v+U��8&%M�c���[L~�����>[��f3�����cS'4a|�sY��*�z	����d����*Y�
�Qv;&_��x����H]�*�y�3�G�)#��x`qM��VBI�7q.�k[��$�r%v[�¯�'q���	��#a/#8=�����!�\��e��$��0R���cb�A���.�&���1TЎ�;��n�S���x=�]�s2ꌿ�?�gG��w'Vi�$��O|̌$	w\�L�J��rz�Jt��d8�`�@�1ψ!E[��z��.��=NԮ7����(#�f��Z��b+�O��81��5O:V	���Z�Ok&:�M�ylcg/P#[H��* �^	˨xl5v������ru����f�ǖ�z&���LOK8�&b�O`�(�$��@��.�8�!��m�Z��>�W�8Jr��Mݮ߿w��Ү$�_M�T P\P"O���[9=<�����З���H4!R���,������Y�b8�j�nP�Oy���m0�������o�1˧H!���1��b�N�+� ��y����D�_WѭLVH1-�<O�����?(�vV�1Z����ʟ�D	<��R�)Z��A}���H���&��D��߂-�\A�w���-EW4VK�V�Z&E}�O��U4'�zJe�K���h�%?.���j"� 1�7"d��ֆ?���pG&)�����y:^�T�_�m��.i��+YQ�á��,������� M*���&ul�V����K/P%�&�<��ڦ�-�&�6�V�"�J��x7%Ica(�x��L�����;�}�U�=�R#�D��Y�	p<���"C�a3<�NLD9���m���F��.������>����풏��b��|��2����U���[WHѯJ�)02��"A�=�����Y��\�"O�P;p�y��lM@U�4y�_9�*�P?វ�������!�7]÷���q[}�w}�y%��/�G׫X@"��D����pK!�A{�=iHk������y���m�s�v�p�7S_h�d�p��>�9���*5��?%��h� $ʦ1&E�V_|�'�x?��qz�8��(���y5Y��ǧb�����[�*1w���rXܻ��	���"M����~��<;�'�+9���h�+�6U��>N��]1w
�%�>Eӭ��E
�5~����2nYF��:���0u ,ܛ@��-����(��ן7:xu�8)�%�r:�̟U�������'�,Zx����w=��hR+���m��&����Vq*�U��5땀 ��||�R��"�[�4���P;�,�SL�e�	e�3��W�s"��a�2ԓ���������F�R��2�����ݚ�K��ˮ�´k(L�B�����k��?g�tr��
��p�iF�'��/ca|�t'b��_���[v2�pD����kcK��Fn�)L�
�R�S"21Bpޞ�-ۦ�r�F�w	�;��fߦ�e������[���9�7%�D�uT��z:�Im�Xj��`��N(�cO�#SZ���i)@�W"�����;�C��������tV��(��8��Ȼ���R�~��,�ONe���"���ɝ꽿=1��;��5��_	{�5�r7��:�j�A)��ڠ��S۠<�#���2$�1ܐ�Z�����״ܦm�z;�w9��:���}nBBz�ƻn��"�� D~��B2�S��Q8���hT��~���ʌ����Q�h0ںM�1��S%���<�	�	�gȧ5�*��x��6C���}�!8����U��^��yk�m�f�G���RC^>�q{p(	��:��`׷-Ɋ��9���s��_�ZG�w�Y��C���p{�=�Q�f��u2��o�(�[����UY`�K��Nv��w���5��Z�g��~r�w���~�CZ�;�$�:�S8(���y�z%���<m�O�8��p<S�\��Op�I�[�l2�p��  T��=&�J�mv?���}�:*dA�v�F�N��j�a�*�.U�a��k�	<��KȗGS���<Umǃ;�?�}�pp�����u�g�����Ph����8�p[:�s��q�5��s��
�f|pFۏE2�����c;��͠v'��I)7��?Ix���^��/'� E�jxx1n�z�q{غ���1b�e
(�1�� r����x9��}ῴF�l0�8�ϕ��u�lo)��5���e��]M({Y�3.~�e�s��{��x��wz��hA���3u��I�;�J��w��`��q��+RC4�:പCNN�����=�}�m�����w�%�x�;G�����u��`�g�u�	�#�[�/Mu+�V'Q�Oq��m�*�W"(�@�;���ڦ��#r��0rk���H�1�I)����צ�m��Bnw&��u��eL�h�W��#�����*3�[������-�#/[p�x�B�f�rĆz�jȈ@{����J6��� ��%��    ����\}���Վ�+U]|s��nv��0��Y�{зMD��'G���e+�i�D����UM�0GOB�p�ʬ$�/q�K����z:��[V 񦉤�4�f��oi���e�ʰ�8�"���$�f����8T���JX�U�\�b������z0�Bz�b��1�f��$�Aӣ&�V��B>\����2R�(�|�2m`S�u@��n�����Q�7Vq"X�����@�M�

���iq�����n��l\��<nV�oٕKv��z���r�!ސ(/H쥞Tꏆ`���VY�h)Z��К�m/�
1>mK�S8/�f7p_��Å�rex
��F/����5sN�cy�������v{e���$��Cه<
�?(��CP.��-�I40���'����`����'����tNMf�~Ӣ�qx����Yq�+���'؛C�߲��%����C�Xخ �}XP__���jL��H��CL�r��Znm��&��A��`�"6s��"s��Tyjt@��t���-��W��R��]Y�z�d�L"��&�W�X��#�ښ�a�j��5��e&�v�>����]�jR�<���wLն�-���#p��b��̠��NJ���e�i��dvY��X@0y0�8N����'�D��F����%ZH�Z.3|�	�n
;��q�
b�/�B���T��_�i��%XT��C)��H����G=�I�eao��|��ߤH������� "�W�QB�X�P�=�����w�]U���(�����m�U��z%������ J��ؐ%�OTW��mNAÅT{� w��i���63��uǝ/�w+���λ"��7��� ���tF��L��[#lY�8���~U,�I>jy�T�E�4Z`��~�������jX;�/����J�l�oJ��2�.sfvP�Fb���{qQbwj����u!L�\O������<ҭ�v��%Yk�<0P{���;�~�= �>9�u�g��Џ��.z'�X�Q�=�λ�ԟ�~��=�WԾb�}:�,��6E}z����K]<�����(Ev�o:f�bm��s24�n0�ig$�)�Gj���m�)�����8<�X�[;};�8�?���gZ��!�ǥ�~kJ���n���M�C��k����x� �u�ݓ�����6Y�%�n���+��~�X��J>���n�S+�~���	df������u�smʸ�<�6gc�>O�ժ�5>o�6����.�@�wG��\�9+����o;#���(o%� O��L�g`���y�~�m�,>�u>Z��.k�g*����[�k�,�C,�_���(�򢡇���v�#�.�����Uv+��ރOB��6Bz?�Ǵ`em}����o(Z�/B�r<������Q�̉<5Z�����Ƕ���:��/�^KB37�J�����]zǠ)�b��-@j���()X�m���v���W��U-�T�ǋ��E����csxq�����"X���� )oE���/�4&���9.wT��/W+���.�9�K�zg��I�L�Q��%@��;�����nu�r��cxq��B���9V8����g�����lXƯ����҂־�����§�Nxд �11S6RD�� ��+�Нhle�7�M&�M�&�-��)L�&�)��v��jԴw�Ql�>�|]p���aEA�_�w��	�m_�� �tl��~����6_�[B�XZP�V�dԅgT���N%r2j���2�0״p�;�I7��WBr�ʂ���	(��=h2(�/EkQ������]�B��ϻF2�-��ȹ��an! 6]�$�_}%~6�2+3�:�8�u�3�4�`]�uz*�x6��S���-�5�����_�&sLPf�e!���r!�	|�CZp���"�ǳp�㡫�\�����5�&�A��\�.��qw�m���H�k_Q��@��5�ǰB����~Y�Y�����9\yN�F����{�+n7�y��Ꜩ6�e�JS���@Wdy��e���s�:u n��U��<���ƭ���w���?�⺠��N���Ǌou�~��z����M��S�J��@C;#<��/��K�Ρp�Q�1�7���Xڮ�0�n�౲wG�T�
�Zv��B�H��6�G���;T�Ɔ~x��]�!pk���g�p���0��c�!�s\��!q+8g�A��z���v�[�b�z+��P�3�a-0|�Q�՗�d�!춭[�o�ĵmS��qƎ���j�O��j$�:�2��W�ce=�+��c7�l�S����H��ܿ�,1����6�m���j%ن:�ulٲ{_�찐<��N^�2;`�D%�<x�̛B�<1V��U�p5_^�Ũ{x1� ����8�����`�_X�लB��9�em��;��vJ�n3e�����S8n�(��~_2�~i���7(8��� �Fjb���[vG�?[t*�]��'��;8P�͘��O�%��*x-���D}��zo1�(� �X E�y��ZyR���A�e������ N䣋�M�#e�'�Ħ�5<����Cd;�_�{%�6:�>��ZGg����8PG��;#��*�'s�ړ��הx��m��e��Ob<d睈�r=���k����g�Dl����+̶|5Y����MЖ�'<���.3/�O��z���0W{	�4à7ֳt�`���nI7�]�W��N[�C���*Dx($p�����GXO��v4�Hћ�[��Az�g�cdHO�
<˳����M,��ݬ'�ߟ��X�wwoG�J+}cϭWx����=�HJŋ�����CW���U�LNI���7��Q_e�l��	���bV[MT�^?����S-n�,^�&Y� ����h8�@fK�3��F�<�w��[�N�N^������}��b*�^�)�_K�|qx������]cty���x�7q*���ᴆ�j��PJ��q�_�Ϳ����y:̱~$N)'�L���p����vЍ��A�"8(8�b8�+ZY�
�g�պ�f������q�>�v�
EV�gs����{��F��6��b�?a���o����\<W�Y�x���Ox��蜵ȸ�{�P�W0A�r�-蕈�E������0�:k�Z?#�No �MיX�Wd[$�r�r�;N`ND���϶�v�p:�1&��@R�MH��mpبu��	�
� �#ͬ�c�签��8�{>���؁�`���t1�N:�n����¶���>X]� L9�ۧY/��� ~(2�Xox�_����۩�J�|z���q�s��+LK��p��q+��ؔ�Te��N�]�.#[��������Iu�:<$��A_v�W�O��v>}pS�B��䋬��Z^Rr�-�{�bY��)�Ԝz%|T��`"�O1�!?G##�^���K	Q�,]�7{0`��)>�}����=�j
� 80�(�*�AkP�=�X�^������s�.v�ED�U�b��UYDX��^�4�np4a)a�Q�'K扔�ɨ�#���a��|�����%K-���D����`�.*�����z$4P�s�~V}ٳ�ﶫF~O�~ �0 �Z������0}�f8�U�[Ϲ�
�n{�Ku�]�<)���@��}�u-�t�<y�
�QWlϱ,^�~��� ����y��'�5���(7I������DR�	��o��u�@�pvX�ds�,�š<M�]�ؖ�p�
��i*;�� �w�9� ��xhxU�n��A�<���v�>���W4��נ����s'�0�tI-t�L�yfO��8&��z��	��$�Z �\Ap~��6H�y8XN'u�#F��9e:]Ƌh~���x���iq�p��ޚ>���4{k�'D��U���*�#y��h�@��ҐLI|W�2�`MMz�=GEc��[��j|�MDS��r��c����:A����I:Og���Wxj;a�M$�d����ў�FW�!Rxք��N�fъ��8�ү��X�� H��R;L����I?���u~ '�(s � �0�8*�AJ�F�
�J��h9    ��E���^m��u�N
�+/v�$����3	���C�B�&I�=g�*KIN Ϫl�H#h�'�BE �-F��o#���@��l�ـ�����-J��x����wW7���� ��X�x}�J�dX~��"��=R��yޢ,Y��
��변Q#��D=8-A��@�qv��J�@��8���n`�x�F���MLa��Z��l����=�ً�B9��~������D���{��W�"R9��I�R�N�1��(�R��M��X�Y����j%�q�p��f�>��Ń�ZM1!�0�#Aa`�d:[~{_F�2J*�����@��ߵp��2$��8N�=�?�� ��L%��8M��I���"ɇ�Xk�F��8	c�:�8�ܘ� ��f+�18���}m�@n��3�3���i2���h7�-^,�,�m�g�튱�|��"ώ�Z�/7�5:҉�8��Se�	n�@�p-/�{�F2��a�T�Wb$��Y��}"�t!2W%C�,�Y��o �!�-���x�]Ll?�Iyz8�y�1�Mid��HNf��u�Oa��roM&i���|���,�K����{�.�I��Χ�m�< U�U�Rw&7X3Ḝ��7'?��u����!�u�Gv]Y��J��i|���x���Y|��Gs�M��rj�@�#�;PСqp`�v�ww�b�F�
�ż]$�S(�S0�if��o@��@�3��_��o�DK�����2��zƏ��y�VC��x�kG�f��L��11�[]5�֖���o����� ��
�OB}�B*�K@H�i$G�#+�3���q$ S�gx�]���0M�]�G4(��q��C8���sW9�<_��N1��F���f�����*��L�(���j{�ag�sO:�b�����P���lR]A�N�tn�}�2��K�ْ��=��X#��/2l$j�v��,/��C�˳Vw��Fav� ����|��w��f�z�}��M� \�3�O�����#�q"6���貍j��\�a����]�b�`�d�B'ߑ�Y��6�Kx'��^��<Z%`��~�H2༮���Y
!�W�w<�{]���Q�d��<���d��?�֛�������"��O.-{O;��EV�����E���H��bI����v��#�劒��?��2���Y3F����ނ�1ײ�.�p���
'M��@ ~��b��A�IYB�l�E���e�v�����}OG��;��a`%����-Il(?
ӗ���,��+IL�b��倞I��]�$�<��$�}���w̤�M�h+1��K#�\~�e��bkWQo�K6[��ǝ�E�h?q5�[�k����y��lʍ*�t�X���:V�g��@�F��&W���ҝO�k.��$�s�wT}Mhe6��q���+��z~���s�qU+�"p��?�=�b�����)btQ�nI�5 �4��$�x���b�-�B��#��J���x
�� Cp5�f)2�R��(E�s��Ak�@S�&��W�Ev�a��$G�t6f�!��|��٪C1�go1�Dx7ň��Ī�S�O�Y,��/���S���0��ep���ax��o!9K:		�tgmDEǧ���*E��d���=���eo�܈�[����hp�!g���� y�>k�o�A�@7=XuܽAr���?2�,��jw�_ݡ���q�����4��Fx�T�ձ��ݵ�EW�f�J����U�1%���6�K�C����[��2J�.n�hz_.=��8��G�g�a��2��ރ�&�(�8�0���c�����B���rO�x������=q��>�&x��N1���$?,]���,2{�����W��xI�?�������#.:I�9����]|���ߖC��n�˶<E&�Wb9��ˈP��۾����
�|�ke59�k&��$����C�6!�N�r�v::,Jk�Er��Y�MpB����%����=Ƿ��mf���V��ŋ�4$���Ȼ�[}^����:�Ƙϛ��&Fn�[����n?�r�%0�v3ϝ��!������zD�&���Ӥ<(���a�.���(�w�-�2�<X�Ax�2/z%3/�b����H�~<�/�/���FH�c��촳8[ȝo�U�!����j���|Dg������)�v]�G�< '�%N��pO��hz�����-�A��Y8!X �U��2^��)9J�>"K�;i����Z�"�8�/AӦzf�2$r^������#���1�Q�i��J,��l����*�p��"ͳC�X�1K����r������л���;<�[T�NS8�BIdew�2N�U�_I~�";�/Vf^���L!{�H78�L*�UކI|���D�s!�ONE���M���.U�ׄP��Lާ��'������K������v���љ�ӀgO�ps��@?���Z�"�8�u-�*FIJ�ҹщ 4Rş�	��p��ۣAlj%ށ�r�;���b��y�V�c�a3��gb���l�N'��\�Y�z�C�����5$����vț����˃�o,����7��y��v�ܧ
�\�c�Q����{~�2��O��c&R�pp�l�L�Q�A� �<�b��=!`o���
��9�XyRM<5f9F^X�kx�R��Ņj������<��٨�
��N*����*��W"����h�]t�Qf��3����Q�U�	�ӄ��t�Å�u�ҮY��l���^�Q�O;��^*�j��*t��Z�v�:�܃d%��Ja��G�f��qk�k����y�����w���N��%	�q ����䋘],��k庈@:����j�T<��
\H�_|����o�q88�Jv_Zz%|��D<���#xK�e4�l1�q�� Ƞ8�#�~�;�����=.�EF�G���Sq�V
é���T���\�=ע�I\v���8��$�ZB4��?�-x;��t/��Y��t��B췎�4]�����A0����~�;��Pp}
A�i8+�*IDQ�]�I/�sί�<7kS�Ph�ʝ@���#�V´�>ʝ��b���K��{-FצN�����N�q��f�z5��slM�V�mq�/�ri���<]LBͥ&&��z��<���>Jc<!과\hb%��EC.=�-z��d]4���v�����3s�᥼]�.���ؑQw�J��T_E!i٬��HPXռBRh!T4M����c`H��d�V�(�s��c{%-��쪊 B<^#���MN�_}�s���C
/�`U;�ۃ�!�ݥ9#�yoz�lj��W��X��������V�_Q�����K8���%f�˛(Ӹ᤺��½�b�I�+I�"z��{
�v����=��u]�����ʋ�%k2jٲ8#�8��cЮ�x^��H���e��WL�;e����#50Bc&Z'��m.�7�GW^�JwKa�$%�0������a����������Ͷ7ɱGG�o���e�gq�3���TV�L�
�Ŗ�,��ռ�R�$"���`�~������Dd�n��`�]� �'	�����K/��#�
,Ak&�6���C;�����xy�|�r�R�����yO$�����sg���2憑˅�T�i�vۧ�9�6�l^���5��ӌ9;��.�-Y�"#}�Vp�����vkt4�'�©�\�rK���/�;.�<��ʕ|G�x�9�� č/�ffn۱%V��9�XƩ�֭q˽�ue��t���Ń�.��4%�V�֊�-�d)?�3���lOb��Y�ץ��}=_�u���K���U3R�{��-tؒ��FĹ���|�&��1��c|���A{�;D['�~�%����h�iÍ�GG\����p�m�c�h��xi.���c��e.��pǭ�F_�@N���i�\vD�2�R�Λ`ݤ��rF��O�JzZ8si@��S���sicf��b���OZg5�͹O�����-|4n��/��=�x�G��к�O�vG��ܾ�3��5�����8�FJ�Z.0���
ʶ,�g    �PD>;����n�����a�ji�qXR�E��VL��p®��J�B�;lo�<mc�QOw�K7k�.v�$CJ	n�ip/�P��g"���?L��T�>����'!�0YmQ���I$�!zB�������΢%�0��R{܏�g�MZLVQ�g��)�%��@��\��v(�;pL������VW�xl-Y�)�i�;����V>q@��)mN��'Ѝ�	����n"�n�݄��q}�� [�G 5�R��� �{�O��eQh��x�eW��e��
�pP�{rttzj�8d��Q1o��Z�`%p��~\-��;$x�6E��G����ȸ��b"��۰Zip�'si�]>���2�$��ݠ �}���+����vl'���d��T�t&��9Hj��5:���ww�7z�u�2�n�
��fL���;���rn�߷o�e�ĖC���b�[�%�ɶw�1M�6��6��A��4�!n�Fl�~l�����/�@�cǓ�2p;��=�D�
�1�hG��y9B�GU�/£l�g��T�Ҿ�1U$��+�b��4˽�~k��o�n��Pn���c���Z9�ϣ�,��Ir�~<�n3(�ǿd�?c�
��*����J����x��'��33��$w)���M*��.��q�8�^�]��m9l��'�
=���p���0�,�'2aT ť���i(��0M֤��`z��	�-�tG�ZI���%�$��p>��M<�|�!��|�uҙ9�j���q��`P-�(7��vn����5\����_y���{����*����KS2���iG;ͥ��������՝z��*8w�B�C���j���0����]�r�1�+
N槰OZ�]����Z~Ԙ��/$���<�N2��D�$?'_ѕ�M�����x��P��*��ű,�	����h�dQ�M�r�R�ahvy�傏���>t��'  ���GY8�����H4ج;�N��uQik� V�B���D?�]:9���eV� �f�lR�N�����VM���ʦ{�#V�w�$y�$����Oրl7����7}�U�y���#��a�$��{�Hs��7��ݲP�=�}�Y|��cNcu[*�`Գ�>W�M�q4ћ\.>^�1 O
,��>�Q��D���������x��/��W͏��(p�:���+��a(ݎ�ڱ@�{)��-�b����Ю$�p{�7-j�_�k9��������I0o�N��mn�>�	/��v��Z�Zpyn��h��x�T�8=(+o?nå�.��W�,�0���X����<y�	�R�sc@R���}��>�+MY
����϶A�\U�!�
.N�&\'Q,��G�\�� O|��ѵ˼|��H|s&��DqoU�@m\�*5nM��=�;��)~#��Wbk���Z~U���W
�DY63쒌4m�Z�w�)�o�4�_��3B����@8�rۓ�۠��##�����Z����4�|�1��V�evOڤ'�(�T ;���0j�?9T4���[y6mu��h��é�A��H�xu�	^�B^am����p1n�ȟ&�l�nݡ����J�1f��T8� N}.f�<g��+bE�sΛ�W\Y�k��O�!_�m!½b�M��A�F�~�~p����tм����-0��fO��:L�l�������r�~F_Z�1�fXS[�<�P�mߠ�]�C�[0�9lc�����	D�q5KS/�G��3��Wr�ľ7�~��U��l{�U�@����<�z�
:�|^�bN,�,�gy�O�D�q������=Ÿt�zp�I�Ha�;� ۮe���dUs�?����0yO�~^�|��*��'�G&�S�X�Q��#���(j���'�0��O��\<%�n���T1�R�դ*i.xi�n �TU��ٕ���p�B	�0X����|�ZiW2�Y�\���	�%"{d��C�Zb��H�i��l��(p����e�2��)��|���� ��p���?A_���3'��sm�5�V��� [���E��3�j%L�O�B�#��3P^�Y82�/a���c��V��w������q���9�]�v�W����0LsZ�X�@��e��W������k����(���;�r���:m)�&ׂ��P+����U�Qp&�{�^l�w]bt홸^p��+�����y^�e}#��W�+�3�VQMn��?]�B8���i}��E8���ⵙ�*�O�Ti�f��� b@��D�9Na��D���p�7�Di�8lp��/��9l��uh��S]T�J���.�ˏ,x0�U�MD�/�o��"M��*¢u�7�m։�I�m�|5Y;����2�y퉋HLn��5,��T�b��b���-i�+���c�(E�0���"O��Ƃ?��z���X�h~��eb����\�-1�RI �|�t(���8�4��Z��g��X���1�gp�[2'7у೒nR�k2���|��zv�z"�J��S���:�A���Q;���ǫ�ML���al���p`���:6���ZK[�/Jl7�r���q��?s�8��1��mm��3�� ����C�3w�y�d�b�D�� (%�ϫ�F��{�>�~��i|\�A�5+��hƂ��rjc��;����*<❖C���V��:����s��-^~��?_U��q:����,�K������f�q�C�\�+;�uʚD�V_�� pK��G�T�I�)���@��>���� �Z5\��Q�- &���R{��������mt}��e���O;R7��kXR^����=�X�B�S`� �=_VN��q	��7����&�z�������g���$�������$��o���*X��2�%NI���oHO<�*\B'�4��):�����y�����&�,^0�{Ձ�
�r�h���ϑ�U8�խ��3��D��G��ʕ���r�G�qL����7��:���z��7߫Y������!s��!�cGE/�_�_4�{�����d)<���B�'�n�����;�#�\9�7����Ƴ(-�)�����%adv�F]��WG)rR.лjc��T���Fz�^}��˘RK+S�������ף��}��~F�`,0�ߞ\�e���٢"c������oS���1A�I�RL�O%���-����(�e S?E��=)��E.�]1_�� Y۷8Ucz�JU��8
גэ�_t�]�-�5C�k�W�[�ۼ5ӹ�C���|�1���mT����ª4����r��s��/�=Y�@�?N�'��Jvݸ�HC9'y,?����nʙ�s�0�Z3�����<͞�0)=�3۶u/LC�0og�u�L���;|��Է�3���,���|��VR�)"�R���5ϡ5�@?K'�����y�ḱ���'ų��Mz�Z$�4�d��ѧ�w���������7�/����o��J� �Ed�!؝i,�3Bx^�������+��� 8%-�;+b�=���B����I�epP[��2=Lj����Mxy�7_��u�+�~
��K��Tf�B���*�S;X%��Ru��¿�H�	����~��]	W�b����xhhqU/ҎX�
����8�N	g���2U��'� c�E]�_Ӡi1�!6y�o���^�G� �ǿ��X(��/3�Ц�T����]�d-�[�`^�X�Jع
?����t�*�C��"�Y�F�'�1*�Z�$���Ӻ��P�}
1:���myjb�k�]��H���2�V�՚��`���
��$%Ŋۦ_7F��"�EzY>�J��Z,�T{�	k��0>�a��2����1R3���5
D�T��#& _����p��z��{�"�,���ڮ垿Y��Wb%@Z�����U�@��������@�*�
|�,S�5h@���kZ�����~	Z��d�� g!��E��!Wc)[ع�|��]�I9��r�R�P��:#��Wj�o��� �����:-�aU�_]��r��#��� ��{� _�S����Y����G���n����R    �5��]^H��eB�K�ic�q��>���4�����H5�轳X��ɯ~����b��P�J�r�����4��ǥ���~
nZ�K���>m۲���
Ēa���9���d^a��V0hG�9����2N�9��&����I�9�2&�m~��wRv����A^�r���{u���	�)~�Zߜ*�/���q�a��waF�$�&�d
N�G�]2YE�m*ض 4!F,�G3�z��GM��fb� �di���M�߈+؀i?j�/�;[`�5��I<C
��Ga����w���#�^\)�A�i�-e��x%Ӵ e���ţ�jAh�ͨk���y�I���wGb_��Jz���h�M	���,5�v�\�/����Z]U�ܵxoĥ,�e�H�{�N�����G�C��n�d[^xH�/���q����1W����zD�P���]
1�qL��m���h�n;�{���4��a���)j�V������Dt���^_�&NG�l�����D+�sz;��}�_39��(u}���)"���ب�4j��J'z��ٺ܏,[�"��1��h"n@w~��s-��0�jc�h$�����4^,|�$����nr�)����H�墨�k�W�ˈ�ΔWTo��eU��	\�����pY$ԗ(��-�~�69�w4���{���?��F�LW||��&^��������S��xAN#L�TQR����%-&�@���
�	.��!O��8oBP����oZ%��~j/��1���W��g;��?��)?��]Nw�7;�%Pw]�1� ynN��qt���s�5jG� ������x	�
���n���!*Sd��b�D��R1��p=Q�M�S��g���
���qP|��r��)a{�tho5M�����O+�p��D���=�[�q)?��uD��o�QvO�o�?�i��Z}܂�hY9x8�'�;�����C�����|G(�`\N� M6��5�ܓ�ٳp�9����Cq'�����S�C�|���el�s2�E��r��u<�Y�}�9jKx��P�o��8�»~1x�q����J�&D��L���q�X����V;�3�g�Y[ˬ%(v&�An%�g~`��u��-Vrx[������`T�{�^���i�ךd�ͧ�!�F���֌����#�iQ.f8�tVa^S�o>.�Y�(G���|έ2��,����*���~h��I�ӆ����D3�<���N�N��z\^9��7����<K�_fAO�pz� �"�?K��#�3�������g镚R<_����q��3ۢ+S��T���T%g-.����g�\��V_��n �r5�?b>�aY}}�V&O�8�yy#Ċ�2'�,q��Fe���U8�$=��WB���T$.DMJ����w-�m�z?���nW�2��� feJ�mz�J�����0$�TF�7��"UY�խ����=�`�$>d�Τ*q�i>88�����ʤy����+�y�k��D�g�d+�����\L5�|�zu�UH%�u@���(��I	H�Ρi��%��p��G�4Nv���`M��2�c^����7��D �=���n���mw�u�u�a=�t�'��)�����cF����q��f��.��*͆�m�Tm��n�5*�WA����?�?ih�4m�_���r�H+��/�my3+C5B�����ƂA
6�C�M���le������W��3����Y#�Yg\Q�7���Jr������zB�(�g����K
u�����&m����h]_�2cs��ٔ08R��\�ל׉^,�0�|�rV�I.���A�-)�H_�=�!�f�˄�"������PU���ϸ��ފ��3 Uծ�0��J�a��:С�N5�J�#a������{�T�l���%�`����=�����:*Z��j��sL�&�SEwm����ߨ�X�t�_�Pb��:��d%Ƭ����R�c�wz��#���maA˧�u���d�z`ӻ��R�E��S�O�w�p��.��Cbjf�qp�����ރ��U叚^�&aR��
�X@�AjԀz�a\r߮�;2p�����1�aF�� w4έꖿ�9 �BCZeJ�͞��p�A��3��F߫l$�%�y��W�㗪%味yC=
�6��bb���	�S+z�Sc��h�2 t|1����Gv��Bư��4.~�%���wx��pO�V{<FF\PG�Bl�k�1o'��H_�=��Q3	:�it�}5�m:��N�bq��֫M��(��X*Rb���#ȡ�ɻ�)�ƏR�(�%���_�>H~Հ���z������/�l\N��X���W&��=�t����Z��y��ImV������ª�A�d�n��yP.}�!��|I�'&���W
̭��1MfK�y.�9�a���Nc��Ϧ.X�ࣤ9M�3g�E�O��ZU�8"�=?��XXf�N�s�7D�n21�e�`ɷ��yv��������=u_��^�7�S�{敺F	������f�j��!ڱ��K�k�����	X�������hL&���fF�t	�ꚕZ"���eO�@|뭝����Z\gZu��p���NݺC��<2���^���<x��u�� �t�`E�DT���t����D�g2��z�yTv�
�w`"�f����6.�mf�I-E���MEl�~�=U��j��ZÅ�D�<kqI�Ǝ����W���|������V�B4������56,��a p��`�ydf��J��n����dF�9W�+xW�X67�h�#xg�]�����Ç��C=��Gg#�M������8.1(������L����F��P&|�>B5���F,B����v�������\�5�-]l��%G�(:���4��{r>'��~T�5&��u�LTW��f}E����D;��8�omCO�U3Zt��||�iN �4.�J�pe#c��]T��-JL,�j�Z���1k�$�?�>�{��ޭɨ�&��U�p�	;0�(��`�B��\a!����{�#�ܚrn�K�ˠ�ų���&\+	�q~ы_�v5�Ф�T.���3�Jt8Q��,za��<�*0��nN��o��"�@����ZQ���u�ͣoG�<`�e�����q����d&�^�n���lԄ��UVgZ�E����a�� �p���~_���9�@�<�J3���[�E��n5�I]�B��G��y��ת5�heɁ�m���+��d�#*7j���N���u������J#�OǠ'���t�+x,S�z*P��ԗ\���N�J��b/;*���F�g��	,,o�
7c{*#��� 
(�XN#���#��{laY��+�����e��H�-�K�t�5�����L�4R;-�q�#���U|�G��}Ҳ������c��h6W�_�N��tg�ѫ�7�r���À�t�j#���<�q�q����t�� &��Qp;����LUG�d���N�����)n��ū���4���JzaʟՎ.}����z���@Sm�ݗi�@z�����+N��P���Lmy���EŹ9#�C����}������辕?���D[Y��6����z �{�3ըJ��!c�̓��JW������.�@�.!{�;H0.�%�+8����_��������n�PG����R�W`���X��@=y�Rn�t9�'Fcޔ|N�bf����y¶�ڕz�\�~=����/�^���q0p��ɚ{A~����cܩ�����+Y����P"[��t�Z��]~n���Q��p�<����ҫ�o�S\ ��^Q����N���$��5��}�������N��*���q�C֠��B}&�l�U���@�K&��_y�����ާ?��ow#6�7��=��q�b�b�C���x�s̮��̃mF��t���łK�(*�{^2�`����,3�%���d�t���<*ֈ�-��鍲��K�h��Pu��t�K��ͧk˙��6�W�v�ъ�T��H�x]���ڤ�0P�L��}m�55mp%���W���NӳǊ��T�)��	�CZ����>�n	�"    X��|�*���p�p���yL��W�f?�9��3�z��=���ȓ�_K�AV����/��_��D^6���$u¯AB��SM���S��������a��t�J����g'�9��'Q�}����6Ym^# U	��p��"Y���b�h�͡���)���rQz�
�I:^ď^\'S;Oי��2V��������~�<��]2������C#��g�V���۫���/5� 'V�3%z$D�y�{�s�v�e��E2 �0�6b���~Z2�<�?�c�$�����lvM�Q/��u�������3���+��'r��w��,K��~��kn��O?;.�n���P�4�����BA���"�s���Ǽ��&� z��\���d�w���|S	��nڟ��}ٮ�-
��T����!Z��@�d��Hs0��6::���.)l��u�Jz}��
�z�-�+��:!��3�Z�Ɔj5��2��-���0�&� �n��"ή����܏6�����r�=d�މ����u�`g7���u�����b݋�a��O�*l���Eއ����5���v?p��t��k��qz�k�G)�hs�m���9m�X�;FЈ	A�H� �vX�
�T$g�6}*=YgZ)ٽ ��9I��ڝ+o�M;�\��f��Q0�喝F�w7���ㆺ�`�:���&���~�򇆯 '{��jhQA�ͮP."�s6�sVˈ���a��e:]?�i���D��t�ן�M�)�oۘ6X�N������*�&���K����3p�7_W��,��V�!�8���}-GG邖w�)��������!������V	(�V�%Dg��5�4����f����׊wꤏ܍� ���6
C���95��x6M+�������Ixf�d��0Gڙ�s���<���@T�,/8�"�ޓǣ�gЫmڋI8;�@w���,�4֓9��j]�_��o�M���ʔ�f\H*��=҉�i� r}����NX�B�l� =iT��qEL�@��h��U��`��|W#��k<����y��R�����W [��kڔ3�����Ins����V�g���ϳqw�j����>�C���U�R�}<s��P����y�I���H��X_�=OƸ�3�K��R�/���Ň<L\�I�H�.�V��p�y�Ũ2��p8^#\���\x��}�z��g��ڃS&k�����Q�bD�礙vƸU#V���d\���/X��H�����5S6$���2�h|:�7t��)h�0�|���|_Z2r��Z�:�JҠC�'�W'C<h���^��).�����坥��fq�Vφ׆ѭ�P���ȳQ��Wλفp�
R�O��)��Ev`ʬ4�72<!]����M�_J�Q�m�p�,�`C1fz[�I�B#$�̸#�����҂��*�,?Al'po��D0c�f�:����TC�|>��AO0V�,�c	s��Y��~Ǹ��qrx#DS$����ךųk��}�K�E��骄-Ă����e&;6�\��v�S�RJ�v:�dN�6�uX��ͷ�լ�J"�{7�	I�Q��q08'3�lt�볞�:z�`�Lkd�n�m�mb���?��ֹ퍊V��v���L�tF9���[�����	��Tgq/A�Ur藐�G�єl����h�<h	Ɯ����lww�����,���l<L�}���*�y�+����Ai�/&\��� if�s������z���ڶ,]P���>KӶ~�f7zB�1�{LD�7�+ud�?��d���s/00�浉��OzW��&i�ô�`V]��iXJwI����Qݗ��]Y�����F�[�z��b㥾i��>��Qʂz�ʟw{��]w�{ɭeZ���1�$�j���O=�NgV����,�$��/��Y���a�b9�-��N��V�Vú52����a�{�ť�M8I���	�VM*�����a��4B�,AJ���ҟ}��9*�mm��2�GCD�F��J��G5�w1�!0 �3b���>�gt,�zv�*�i #�Q��(�h)𝷨�;�}I�홼z-���ݩ��B��-��{���O��:2��iӠ�����Ov2�z��oIR�.`�E����'��)�x�O#������VeA�d�����J5����E���ze(&���]i�7_�i�ª���/I5�};4@>r��=��������g�,P�|P`bZ�̧�e��9R-�
�H�����!s.�����4�}��VOPW ��fNB4ݥ�+���"����?�-[4�u*2�'����:�g�e�v/R���E�+e�G�E���#�￵�褳~(|�ѷ�[�9�͆kI�rDg�$�<����:/�:n���>��"��u���t��y��h�X�@�L]�ޏP����*��6X���J�M�!E+uUE(}_�v����4�0����y�/J�.�]��!<k���`���"^ 7:���H�	�����c���P�%Lb��fS�/�m�B���`���Ͽ?�mu9ϋ�l8K�K7��V���u��+��q�#��"��{���[�����G>�,aV�����"<�QՃ�^�lP��)V6(�j�H)w������}�l����8����0�Y��'�s��`�c�vD�,�mj����Yvs��Q�8K
;ƏC�%��g�'�,a6�ʐ��I}8E(�I.o�$�Sʌ�Q�_���7���xb���ќ[^?ﯖ�"'�i�@�ht��;bG=�
�0�����9ڹ)w�fn���E�6[Rf� �Q��im�YG�ԡj��4� �j�Yi��|<Hȏ��5�)4K�G,3�+h�̱�����}_mtS��G�pw��x�+���ۋO�AR(�����%�Zj�,O�I��c��W���xw��<��l��;�>�g nkj[ ���xOSƇ ~�F���/_i���������Y��T�x��3���6�����qf�rf
�_����kM���Tl��޵yם�jKDP���K����xֿ�]Ǌq�[$�N���_s������`�Sp8=j���ʳǬn'�QU�ᨪ��&҆,ش!\w:-�����&��!�B�9���'>��*-j�L,Ǖ����Ɗ �:P͔ #�?��@d�>R��tp��#s!�&i6���} y������_�*uߋп���	�W�9����Yb��r��̓kT����.��A������k�߶��w�%c�I�yV3w�ޤ���<@����2��nl��+e@���~�*Plf/��5VxB��� ���a��3�v�!m�=��Ӟ@T��c�J�zo������k�ұpIi2��.�A���@��*+���I�5"��f�L�2������~~7�`E0 "�0�����L��pr��b�8��ۼ�TT��Vɘ��z,	�� Uc�gE�+�4J�n>e�e:~��~Nn8�4'B�Q�,���������I�I��t���κ]ĠA��mT7�8�L���jN���
���{��z�%�R�"�'&t��Xa{\�e%[�h�=���cQP��ƣ㲕�o��*�&��x�Fc�����2Ê&�fn�iJ��9S�K��T�槀Ў��	�&y�#����
������b�
�dsf̴�<�ѭ#7���E�!�#��1@�޿.�W����"�]���#ؓ4����be���`d_��,����I��!e��|"7�ћԗ�ЇO�;���ǥ�p�ο�3V/������bܖG� L�0a֜-K��ez�5�[�IjyB�J-1I����M>J�H �<H�\�0B��sڎQ�1D?�`vxu��?�}�N��j�[b�95�&�}�P�g�9�_
��(��,_|گ�������Jux��PS=��f�i-�s��i��6Ӛ�:6O~�^�yA(]S�.#�p��pT��ݛ�~qg������5{p��(��0�]%E<���m>������+if�����3���c�H��i\��Y|�i3��pM��,���W`����^ L  �#��.��z�(��ģ�I���2�&E>�*L�˾Է�;�ף}%H�b�WYV�#��\�{[b����g��doW����7���r�~�0�kA�=Y� �3�SjYL��xpM��8y:�*-K
P��
�`/�L�)���A��BIy丗���y#E�U��<�:%dK�eH�5���Y2�	�~|�	����S�;���x���Shg���p\&@�	x��"�2��Q�]B	���oW��JB�<!�����ܑ�(�-��*��#��ᦖ���6K>�����x�c����|ҿ�C%�^>I�%%ن�;A8>u�`�Wi� P	%X�&t-aZ�R*O����Xb�>	J��0.�W�Il��;��!������A:� "��]��^�Y���e�G�s6�`�)�V���"�Vr<""*Dw�Ŗ�t� ���Rlo��5��N�#r�^8�Z�bP ���7)?.��`��C�%�%yY*$��4�F��G��<�Y�N~L@ƙM���$t�.|N}i��jY�����.�N(g�/F|�B�c��8�k���L�8t�_·�"t��j�w�����#QP~L>�>V��O9���=o������5&�an8B��;����k���N���ڃ��:����|�:��Q/�τ��=;l�����I��?��<FD+	�t�=����H�l���k��,����5ۑ�h�՛�v�pw��H)�:��?���ڇ�.�@=1]}��y�s�!�������6ȼw�>P{�W;���xi���O�N��z7���hKÚ�טG���u���~���'��W�(&����D�Gݶ��Q����a��c�D�0z.@�~�wxrFN;���7�
�íq��i�`t�s��g��{��=$Ee��3��;�z{r��U[=+�"݆<�����H��I�	*�+z�9>9붻�V�m�=k�u��B�����#5b���E�Wq������o;j��#QP�Ó�wmr�=\(X�gr�;u����R78�[+�\�\�'g��sq��s�>~bݭ�?�������1����������1|��ə�Ň��������t����<��'�/�,E:      �      x��KsI�.��_�;t�MB�xMo �dH ����,�(d�  T-mg16�Y����,�Wcwqͪ�gu��R��/�9��; �������������$�^�퓤�O����x4�>�����|:���D�A�#�D&��h��*�K+�&�����Iڍ���a�.��z���Wq��ȿpW�@�g~���҈IZ�j���ڃf�gB=υ�^����I'z�O��v�#Qҍ{���'1�xk����CJC��[V.�i�[m��N��(iV�iK���?���� �:��%����:�X}i���m����+v���F��:Jǹp(��z�9�_og6��ϧ��vJns�fz�U~���)ٛ��$i'������z�L49}~� EC}��|�Å�(J+�X�;�G$��^��Kv2�?$iF]IA�^�zSG��ߖR�z��R!��acr�/�D�i�d��ws$�Zq#��רv�ϣ)�^��8�B�$}�M��nW�^?�I�i��Q[S)�} �\�@�;aHW�׊�I�~+_�
w���6V�I�( ��q=:�����-7����+������~��t�˸�v�F�¡����J]���������W�x��~���䆛�݈�
\��ji���=l�T��6�zHSz�
��qR�n�]��Fҿ&�MԾ��IA\?�����I�G��:�&�mJ�i'�"�:��^����8���1���pO���>��%g9u+ƿJR�II�kܭ�m��;��"�"�7fF�"\�y-�h�rI� �Kx��q�!�E���J��	'�tet��@�!����M�+cN}8(1]?�'�I��m>~�G�^~�>�g�qu8�_Q.�5Vr�RO.�^�#�L��I����6�#M`+u��)[FW������N�"n�:�u�rh�˸w�zJ.�f=m+�L�p�oHԍ�+]θ�4��ʞyZ�H��Nԇ/T(N� .h`�*@p:����_G�NtՎ���� G=�$�Ҁ���6^^!��A�z�VU;-ͽ?&=�L$W�).��vo���%�eu=ڗ��}���@���:���g�f&M��ښ��!�Txj?�)V������P����>\����` �G�p��q�Q0��(b�Z��)�AՒ:\y��f��WG�O�)�^��E	J.���@O?v2��x5 �R"��.(l�78p|�n|�^<AB�Z���w��$�u��R�r����,PT�;<b(R��*����%�&�^,؇=�}e����M��QWY+J���f�(�u(w���	�\�th��
ڌ�» [H��Ԣuwܫ��]��x���h�ֺ�{�n��M
f��{�$J��C�fR'q�D�+���(�]&�]`�\��O����%����DO
�)����_��T���;%��|򕠎y'nbe��7h���7c���#O3�Jp?��z�J+����M^��f�J���J�i5��Fz�׿��,c.B�ڪ�.xUwԅ��b��|�N�}��5��Iڊ��o�~}�U������ ��7�˕�ݕU�N;pX;8�t��Cl+������D��;���NP�����b5�~<�d��/�c̜s�qj���EU�l����4���`�F�Fu)��u4����۸qUS�wOaR�<t�bE��ݏ�e�S�XM7�SL(Nn�oӦVɡ�y�5ذr#�OI���y	�̠��g'���@X�K��W��&��f�*Rǻ'!A������X�� ��t5�������y��Լ����J�p�673�����]��ή��1�I��G�f~.-�N7��xP�.�?Iˤ5Í=��)�d���7H�V_�&s�����=���T����2��=�]E���%��i;6�*�Z8�������Q�+�3�a�O�f�D�i��1t]fInFmdC�j#��`�c�|���F���*w��W�.�fpѨ��W�6z%٬�b�OE��w��X��H	�pJ}��q��wjw�ѽ}X���%�b0"��O�d��z)�ū�[(�z�%�ns�ؕ�}������l~��~kzZ�nZk*J�$7�ؑ"��Ǩ��歌�0��`�J0^��T?0_�c��2Ԃ�"�$w�U�������(���/�ʂ~-e�A���1J)ш�2F���<:���d��Բ�<����+�%��"R�Q(��r��$c!sCfE�Ā&��w3�������T�KGFmW跟Lg���q-T[|6J��^T; y<���>�NVH���p+�F-��ۨ��5_�r3�M�.+r�z%�Q��5pT��z��ɤ7� �-��:����T��i���l��?���	P~���ᜨۏ{�t��U��iE`ӥ7�׉)m��������d}��ߋ�� ���XH������
?;�A��.u�}��$��#X9ꢬ�q�-pJ�2�<F^�Ljݴ�DM���Ј���;��B�I5;�y0w����N/�B4�)�|���Q3Ƕ�]��A���V���*1	6�^Ɉ9�j�������+U�Y�ap*:�.cf�����t�o���|��J���/3����� �H<h����Ê��\�g�>�y��P��fj��c����*u%U�PO���7��5	����\��Zi�V����X��p_�JY����� >�6�ww1�*O�,%8!$$?;Z����7���������ݒ���0_����F�M�V�q��9�0��E�ĳ�­��m)�Y�Y]��v~0x�����e2`�`ļ��H:��lh�wP�	��!��ё+��qT)SR�S����8D���y�m�j�& M{���
��ԯD�ڔ'�����D���̣GX�w��x����D�´�����)g���s<_�Hk�l�ϳ��(�h�n*)�? 횤_��K_�V�����b 2ޠz�{�|ĵ�6��F���b8ˇ��D��mF4/;2�+��^@E`įu��w�:�f�н����I�c����B ���>�M>���w�ws���HF0߅g5�t���&�1�=I�3�f+�S������l���mm͂C���tW��
���J�Y������W:�AC���Fo�2��4�|7[7��hA5Y�ZƁO������w�v/ѥ�2�]���r���GY5x.(������+i7�B&���"�<e�z��1G՝�����_�x����F왴�e�E\10}�遡p�j_���3�>M>�:�G�A=%µ�Ϡx�Ck���6O��y�ߣ���0��	*Ը�b�Nl�h�@�*��+�s�`]��Qنw���[158��S-S�嬋�+��<(��p�u}�:���]沖�C�}�0���|��J8í�����Y6c�`�ݔ>7s\evb ��|A/��4,��o��J�uz�)�� Z�+r��hP�U�ܐ� s��T�>~��ϸq�\�ob�u��y�v�����V�xk�I�Z�*��}j��)��@� ,��ғe�F���֝��Pn�wS�J�Z2聁݉�}0���bF0��g�_y�RgR�V$��{���Q�ƅ�,u�U��\��-*�J9�i;�g��]��o�U����p�ֻzY��,s�#T�O��o��V�)�������-�/�G�G0�{�/��v�-ǘFv�0�o��p3-��W�װ�>�T�W����L��RE�z�~�ZR����T���z�}�6��I���oTi$7�X�Ѝ렼@|���ٯ� z�*;$2u>�Z�������-O��4h�9�}v�� �E��Jr"�$�<V��`�����Y!t��rk�˸�Zl���b����}'��7��%��G�x�?������
H�$WMݥ5k�*����R����T���WR�]����a����
I�m5���bڵ�b�����y�������MJ&#&m��	0w�7	���|�f��r?�������:!� �*jݱ��Ob+�����\~��$E8J��[�<r3!|?�]0�J�{2�FDz/ڲ���I��hGoS ��n���煞�[���7\�~t|vT+6[B~��}����S+    ��1v]5�0]�,ь`2e���1ס��֪h�a�F�{2��4u]3��g��r\��5l����>����������QU��Tdq�zM+�7u��\&=m�>_o��N��]ru����W�5�dU�_C�TU�g5�� ��eU5��?�n

��H�|�S����-��.sm�'
W~]��n��[.��,�J��L0�Q)�n��*�X��.�5����v`�v/��Ź���Ko+��*���z��ꃹ��d7"�����ȸ��\y�FӰ��%�Ғ���+[s��;�����
��ڪVB*��	�fڽ��а�D z�x˓v3	�ů[DT]��W� �},-�or}�ˣ�Vp��֔=�c��3�f<w�ȗ��qu�o���v\O��:0f�?���V�:��ׯ�:�wh�^�U�,���J����FI���yOWI��dz�_u7k}Q����\��u�覯�X|k����]N��g�-�V@+FM{�ޒ�h�	;����B�[�u����eIk�{���Q��|��M4���l��Z՛?J�L��s��߿In�w��s꜍w�hT-i�V�4�
�e%yAY3��X�ÜF����Q3u@{�糀Sa{�O�jk��.6�"XYM�4��)���I����{P��v�K�Hx��SaE�Q�(:E��*��Im���N8f�|=��B��An%�墮��Y9$�!0ƌ"F���-��!Kh�\<R����j��M	R#0��V<��<p�|����iE��]E�[G��5o���`F�r����z�yO��Ī�f�W�=�?@����	n���Te˗��۽>� �����s����bT`}ֻq��҉��nitI[3B}D0���#�)�	�4���)��K����sG;��y�naa��f�E��0�\dt���S���f7#���D����Y��di�J�jO
,!̺r���Ͻ[��p�����|�L���W�� ב̼�%��������J^�Z��H�{�a	YhЈ��Hv��'���!0���l�����x4��#E�?���O���$����}ݤ6�H�}��kv�[�zF"ZQ�e�R&�t�p�߮կ:u�3�Y��n�%��4���6�r]���K�wnD?p'��M�F��*_�ֈ���(5>w~+Z�ie���l���p'J���\+iȹ����%H����eګ!C�}�HE�5�������n֡c�|U'!��e�&�Cb�94p��iCi|�"�R��M�/p��2�H�s�z��������oub����c@X!���e�|\F5��� �Ns\���C��+�sA�K�-)N�>�FJ�=q=��9�t@�\�-^�J;�7ud7��	�ݤ���ub���
d��0Z ��'���V	tY75��M��JO�D��vp	�Ռ�uB�5
O���/�R���j��P,Q�a����X�R���Q����.�q֬�ü����y��Mr�d ��B�VH,󨗨�gc�)�l��x��t1��x�~������	��{W�����9Z`�N��?��[H�o0a�����z��Uac&a�h)���=zQM��4�Fr,)6:;*:�btP����6�y͈4�����fH�q�&�K+4�jk�=�󖈀Q3n�
��D������@	c^!��#W�#��XW�ӽ�y��U-���Q%u���U`�ǮU�1�X�^E5#��ҏ���G��AᙨQ8VLb��'�
ǣ7Y���m�����ʟ�mU��<�J����VH	�)�Ҩ0I�M�_�tL0�PLnq�%{��܂�p�T�>�@Y*����[���,O�ز3
rk��?� �O�l���U�=�ub��[%cK�긱|�.��y)�Ʒ6zVȶ�xIxW��Y:X [:F������FT�$��^�F�<᳐l>�F��ٓ=�>ٍ=����ғ]Vy�`�eܰ�1�'5�Unс#�_MB�����g��V4�� l׊	�����M�Z���.lIu��bU@t����C_�-��+ժ�[��{��*w}p�f�׸�b�ez�s��o������gE�"�o������]�7��bCN����Q�w6�[���M�Rz�h�{J��K`J�OE���[�Ij��u���u`I����+�R��|�L@�V�	{P��������&Y�P���(pE|*�_�je�]�Ş0��%���Qmu
C�������M��p��S F��l��U�n�Te��e0g��p� R3�)2k7�vR����D*�<!��(ȫV�z��w�~A%i-z�����|�F�F�OmOn�<�ҙj[m7��}�-U�~`�Kk���&��|zZ�$E��%v�1� ��t6nA���(r+E�^"e��������UH��W���[4��WOӼy�2<+��HdE���M$;`�3'���!r7:1(�]�u�<-V2�� >	��>��5�9�܇�ed���.��u�Ba��=���������������t'JC�	��E�R"�כ����XI-��Q[5�^�Yw�Ә���R�S-�]�֢��I��	>�v�	�j֋�>�hа G<�jj_N=]&̚��mp��+�U�05跗3���E ~�H��jY_VPj�
���� ��n7���=�P57W�]r%�/�JWNڲqr��8U��+P암,)�l������4-O�&hM�W��5_�z�*>醇�4�8��	\����J���0�{��K�߄�D�ݗۛPQQT.&uȦ���:�j|o�_�gb~ML��Y���/Pm5�K�F�6ʇ�o�y��g��u�=��H���d�ڎp�-�l��`.�>¾"@��%��r�w}ي����H���_:���A�3��c�J�`�#q�!�[[�sX�,X7Z�t+V���M���@����ʡ6��8��U��X�N�.�A�gC�-��PҪbm����)5p�^�~�GPֈ�ڌ�b��7��4{��
�)�ٙ�ъ>]Ơ��f떜¶��V�%��;��܌�w���D�v݊I+�a�����Ź�y�f�%����6�g�F1�c(��H0��w��ԭްº]r}]��x��b�	�����ZnM>W>uK��ީ�`�js:٭�U�X������Gf�ϊ9r�{ӈ�^�eY�|;�-�&lft7�{٨�R�/�+��)��7p�t���K�~�iE�3Ig��|Ey�Ւ�o2-��Q��^)��"PLx�Pu0-]�mR�8�N7��������fn�]�Fﴵ�&����V4J߼��cU�{�4UG"s_/���$ �uqkdc|�������	�~��k�\G�)�k���b����Dƌ�.b�83:׻�X��tc�餲M��&l^F�FԮRpƛz/X2�������L�U�]t��F5�^�5�p���k~;+�l�nA�鷨���3�Fe�j#PaT�S���ئqS6u���d�X�˸��	�K4H�݈��f�(��+� [Q?N�D������h�-���P��[�޼Kq������t:%.�}�B�=>��<U�~��Ǿ�Zɐ����K�\;�+���O�\I*�q� {�jEwP\�$�tVcq7�����fgl��	S�!���z�e�I=n% �
�VL%Mq�t������D�8�e9ȕ�S+'VA�D�XG�&�V1�g�,g�d�0�
����ˁQ���aդg���o�:�2��%1��G�Uk �y�Ϝ�Z>9�֐j7��~�T\q�ϊ/8�ux��r���ʊ�F�	��+�Fȇr���8�8����J�w^�B����ߩ��wW�t���Ǿ0���P��)��.�r��6<O�o��]�d�" �S|��Vv��lt9ͺS�'%�(�Az%�ׯ1MY�$�=�Oڽ�FK�iqWʹ���j�&�w�s���h^dg2y}+,$��UTNc����F{����f��W�R�h^��Nک.4�vH _$�"Qu�p��UH�\㖛�;�%��h�����5    �e�N1	���l��e>�l	�g1�|+Ԍ�y���qS�eSx�jO���y�� ����8�o5L�Q=W�O}�K�[]��\��y���:��Ά׳�DƧ�p�$�BI�޶J��I���o��z��x��W?��G����M������C��H΢�gW܏:.7�tV�����X\������=��DM>�7	s��^�DI��4.���}��5&UB�W��+I��DN+�ܠ�[�rޣ�Xvap/�&([+I"�8����/-AH��9Y��fLG|�e���=��,����m�ƧT�!ƃ�<��xP��������N�Vl�y!6Cw"��M �q�"C�=p�(By���vѽ�I����)2D9���P�����S�n�nz��^��q~+?���F��Գ�}>Y �����+��b�1���<�4��z�A'G_� c�f��S}�۫"&bI�����k�Ž$oО9�M��0�l��i҇�.}��:�)���{��)���}���Z>����+}~��n0�}�sL^���So-g��mo��<��5[�G	Ϙ����[ F�Y�6��,{*ܬ�Z7mt�po��]�M}��<�Ϛ9!�o��b%����f4�vZ"��\Y��� $���`����JhX�Y �#�;�y��r��
�.7^l��c�6�x���JFv?�����~׽����RY�Ont� ~K�p��)�_]~���[��]��7I/.�J��h��=�]
���er����%��D���-7�:V��m\�Է�@6���`�
Z��z#��m[C)I���]�[/O�R��p#LsZ!�Vګ_�*h� �sJ�S��y	�+%��0��%�͸���a�w>�0ʹ�?�-���j{Du�ь7
C���ga�԰���?yX��NTǌ�;#9�����e(�M�QO��	�X"sU��Y.S�\���A����������a <j��!�>��$Bc)�lmB�x=���X�)RR����#6�CK;*�v�J�Fm4��?L��i�
Y�7��Lx���2��V�`���ASM�S�x
l��]�Ց؏	��?a���z�Uhͥ�CH�m�dW��CMt����ML��_r˼�^�H��4� BH��HY���5$O��]�y��V*��c�����K�VV!��Dư �2 +�T��+��'�ˤy)c]�=ľX�׊��0�FI�"d�GM�+�*ʡ�f�n�lSN�lz� 9�x|�z��M�b�g���z�>Чo�H��J�D��)]j�>\�
����1�Q��z�"���W�d���8�ܝ��q XGqmۊN�ZPϪ}������.�B$�ݨ���A�K+L�c����&֊/�y�F��Z����B�x��$7���>���l���Q�
��m%���K�jY�J�Z�.����V1�E��Kb��F������-s�+����Y��m����BVl�&z�}�o��KזȺ�^�1�0�{�U����B��^/эt~�i۰l�./�w���(�b�U�D����Na���+�-�G������w0f�^��G+:�* �pFv��rc����I�n` j�![���?��#5U�������t�	N'�W������7�� j���E��^�Q�
g[�z���}�u�V�	�vݠ��C1�=�Mf=`H��q�U�^�g�i�c�;I��u���dʳEv�{N�4�AWBtKi)���ӗ�F`y��\	^��Ҷ���X�qt)e;Q�Z�xn$g�p}O{.�kB]��^����6�V\��5�;��I$�|��w���y4�xN�1��B���Ua�4u9��*n.��_`d�5�3�x44���(�IG�q�s�����v�/՗*$���m�����N#ȝ[�2\�����ʨh�;Sޢ��0�V��
��[WƏ��j�57O�I2�Dy��������}x� ��tZsU�F�,��V���Į,W��<��ІO"���ɂ�uZ�*,c+>�<���ҫ��R6Rʱ���Y�y���G4ly�2�@[m�9x����F:>��`�TV@�G�evP/:}FiicDu�i�j�S-Ǌdʛ�림������"w:H��P�����ϕ�XPᅬ}�FWJe�=f�������7߫���Hu����'�'|ڃ��.��W
(���C*�L�N� t5/V�g�QGͷ�wo�sWbu?t//�N1��s��<�#	s�"��9]os�����{FijdV�st�[}�������}z�(�D؜��]T��ܔ�{%�%!�������1��4[g7�qz0%�^?i����1OZљH5A��1�pJO]O��u�Q�&(�]fvM���J'Eݢ��Y)⽱#��f3�/�]��Q<��Q�Y!�v޴��G�,;�&�+���硚[���.���(Bm-Ẍ��5��W�G�$SEzv��;�*T�����.��:eYX&���<��?�^�����`��`Yɹ/d���mFu]��pu���kp��2������^9-�J^݌� x�2T� '�nOLIǡ�@"e��I6�qCs��ڏ���fro�7�z����[uզ����Ȧ�n�q4��t�e%G�ݚ�����D�?(3�)�5a.���D�4�T�V�;{��&�����X��]�����D]�#�bK����2^��+59��u��E��}C�*��X�I,FI1	��ܚv�4��LWrE��Ѽ/g�-�g�����@�u5��¡Յ�l�ת�®5���e)
(�b�qή�f3*��熄��/mV����郛�;�G�4s�ez�S2�Ž�sU���ˑV|f���I-���o���d���Bڳ�l��ӳ�[��3�ҙ��}�9��s@枯��i��riǂ���V�qJ1N1x[ƖK��)��U�����ܾB�����Q���k�S o�����a4^%"˰@�Db+����5����
N�M�lk�rk�պ�88�O��+��ۊ�zT�b)����C��V��㸦!U{sU�,�4x�d�	D �{�(�o�b%8I�i������Ƭ�e����œL�j�$���z���"pZ�w�3n5��aΐ� �m��>CS���T/���ۭ39�����u��(ex�f�fV�2WUTvU���Y����
���X -�@Do�
��,r��c�G�`#��L���t��
�=���Km�k�Á��q��K�7�UrX�n&�cW~�*m� |LU)sNːY�����;�;�I��b;�!W�W����1:����\G�$&ћ%�
Cv�ahS�0��rN�^ɣ��Del_�U6��LE=-U�)��
臾P�"�6�wz��8�D�UG	�dۺ"�*Y=�Ĩ��|��ȩ���͚�`����H�Xq�����S�U�%Q���G�k����Z�Q��u|N8�U$���O���� ��A.����d�\������j��g��+�����C���$V��׃V�ƣ�߇��
��k�`	x �!(�z���r�y��K+)�CLj��Sy�Њ���d�Ԝ@���Nn�
�n���v1��S��:�DVT&m��_9lLe9���ԒHP%t���z� 6���Z*�@'&�dw��U(' ��<����:R{[nwg��V�&�Ș�{�D�S�I7+��a��;[��d����#ͤh��� T�\|�%��+@�s3}���O�z��&�j6$�~$:@����K 2���.u��$#,�8���M�N_�o_Kn�A��S��x� �8"9,|o�҅2`!$��a��TP���	��4d���)��6���1	�:tp���z��oDU�ѥ���\���i�a�!&����<L�(Y��~`s���.l��Q$
����}	�B����a�*P��	\�wcV킛�{{�CeU׈_����g2�̚�
t�3��. �?u�!�~�-S�J�)�n#U�u݄��+;J��p�Cb끛���A����<�8�;��P��ZS%�B桊�h���    	Lap������Z��f�}ks�+/0�[8+m��Ez笻�e�Woú8"�n�(��ic��DB?����%�t�YϨ	�P�]�ckM+�q��I��F�p&6�����8�װĘoؒr�P*G ��s�f	B�7]��7펎EeB�Ĳj>�zzp�s���?��D]�\����&�c]ǧM���_�y�\Q4�f�S,���,V�
�t�'M�U䉞�B-p���o��p#��ީ((W��RA�[�F�C�0����T���'��;�%�I�)�@J=�+-+�*��	K�Кy�9�(TN�JU��J�8&�c-�!��4G�ޏ�j6zHY`�ɭ��2�,K�O����
�F\�����{��!�_�h(�"��-?AQŜ{P����n����i-���;���J�*��	�#�a!p�J>{cu�}`��y��P�ŗE/r��UҌw��]]�������ښ�3��T���Gzf~�#���=��\B�T���tԠ��Y��Қ���� ��?�U�l����3̛垪z����p���ƫ�zr�Z��!i��~��}&����F_.���#u ��}T��\�g�����[b�S����-xV�$�n������KyC�
���aGIO���\Z��lT�~^k�*z!�����8!{t�8;�J8���S�ד����z]4�e�db:�C�t�\1m��A;P��]�g��P�w酬�q5�<`����]��eG#�]���?�Y����̲�W.q�-؏1r��{�	ﲄ��	��,Qx$��2��j�B���7�Z8�.֠�<+��M�B�qSRo��٭���උB?4<Ş�j�G�,&˛Ъ�L�QSY"�%b��5Z޾U��Q���o��O���!G 7-c�J�jAT"V+F 6�stcTΒf������<^/�L��z�;
vM�V��$S����IVp-e��~�MҾ�Up�L�6p�饥�[Y0[��Z�j��6x������=2�%^�z,���b ��`i܌ ������7����y#�U:gĀ��p�*��*��$�^kk����n���q�XI�)1�^3JWF�*cQ��'�r(Y�͈���v��:��~���j^j�!]�h��KR���'���'�!z�Z�QS��Z�E�wJpI��`��r[���`���[q��;;u�i`,OMt�|!�BU��M=�5�)�M-O��M���O��	�����cB�N��:�hrΜ��ΚЫ#�c���^N��Ks謎���p�A(���+�|+`��8�\+W��H�>t����>}��S��f�KIf��J+�����sv�oG��"s�h���I� �zI4�df�#�#stJ�Rb+z#��7+�v���CO��wщ[%��I�RQ�b�8G��0b�FK�w{8W�I�X�����6���d8��Fm�d��n�G���q�=�>e�9fc$B#A�����>w�t�+��|v
GK��p��G_�!w�\���t>�f*�-4�*���䃎㄁/��t"���tB.g�d�Pnc�P�n~�ߎ�s�|�4�c�T��hn|� �G��z!�D�Zq�ͧ�S�ؘ��Ǔ3�����Gry����{;��7w�rn�.��FY�_�	"�2���/��v�)I���)���Ⱥw�f�.Z��'
�f}`�wE\gN}������� _-
��a�B��2��Z������IF�P�t%g��&�9h?!]�P	��	�M��ٛg}��r���¾�H�[y��� ���G<v��=�Y�V:6��.c�zŔ�?C��Q�H�n�t�F��pb�`\ �&�ꌮ6��[�F���^$����J�G�B̓m^m���e�͈�{��7�Y�M��b6���W�y�W��ku�w�"ӣW�IR�o�BC�|Wj)�Ddf�DF��8�:��C�ju��v`Q�"�X���`���t�O�@"e _a_UhZrD��&~�Y���ιY��i�M^R8�q]B�o���"�)�~�M�yV���\dE��:�&�젰��J.[H�)���ۇ�)�Is���\��j�W�:`̙� ���|�qw琀��2�x��	��6�`��D��$Z'�4[*~E�@�Mk}ص&XpcFZ��� �;�\�̌�u+e�Z�Ŋ"j�5��l(�U2�M�
��S�J�>ؓ)���ߜ>�I��< �k�}	h�a>�*�����@	aL;هF{�
/�e�N�i�D�M�����QH�'�yZ
�t��!�Y�IM?��i,�C�)�5�d%p=�m�:(VR]'�f�x�M��7�ޕ�ʇ�sO�6p���]�[Z�	)�ih0�|�������3��R�=�o��*t�*�p��B��X�����e��E�@%�9o�Q�<�\�7+�4�I:�Gx�9���w�E�-�(���*�ň�Ye��"ن!�2z�5�j�RE��y{^GK��Zq�v�~�#gK?�zp ��y�p�M��h�)#�g��Gyj��^�wR��@A`����w��g���5Z�f��]�ɾp���g��t�e`�dc��p���ai�(�Z���H�À�M��%�߈t�6[�p8������g0Օ�[T9�9Oa��t�^�V��H3���|?�p)��4��`ٍ��gÏ�18��&�
�����~���Vy����Dv�bd����'�O���L��m&��l"-D;RfbP��
����^����6ߡi�CB��A�� "��̲�琸�0a�oa�j�U�4Ě�z��˖lX"�#6�Q�;��M�$��e��Mv?B��h���SZ��~X$D��\�U�7�-�-�K:5��!�@(�2�j��v���[����m��G;�Iٍ�Y�۟5ڟ\��<�P�M���S>[_��(�ꨒ��8C8�B����*]�f�� gIp�����h�ȹ�x�p!fr�K]�6�P�g�Ă�ct%b1�I�W�H�J�ƃ��z�����r���$��7���L��ǣyF��)m:b�8�
�+�x��W���t�?�0����b4��i?M�� x�Y���~|��uzIG0ߜA��W8�?�]F�U��&�&�O'�,X�mٗ��,�<	�+�Mǚ{ 5�p�^�N�<[?���=�0�8��"B��J-��L<�{��zȾl��,�7�=����J�DUsoe�~w%���A�$nC��O'i� �9���M�^~��I/{���M�{��w��%�{~��F��R#�'O������)�Ҁ<��|����D�K��U�Y�q�W��)������O8���S��]�hG��+������P`����V��݁O>"�ILS�	�3{L%�}(vɀ�6�jf��Γ��fQ���6�'(OL\���Ƭ��g3�O��d4D����T�D��K�#�k K=� *-0��y蒢���ݗ��IAW�$�������W����t^>_�(;�u� ?q�O)��A�9�9�p��h-���&)b��Ro�f�@���W�����l�����eM��a|kU�u(�y���d>�[&Ê�uz�[qqR��0:�g�O��E'e�����$oy�Yぷ��R+�lN�$��9a�J)Մ�A�q�o�����R"�g͞@`ڃ��6�䩱X�Rp:|<��b��7��ǩ�Ԏv=��Z8RG�2kP���U3�.S+���,�A{Hk:��MCH����RE8/�����f&�X.�������L����<�c{o"'�%��F�z6Ä#}��|�Q����ڑS�k���*�[	h�V���ec���rz8+"p���+*5��)Jc���1��ii�k?N�I�Ք�d�ٚd�`{/�MO"��F�t�q
I�U(Ee�$q\]ro��8��\�+��U����T�t� �qV��@�Qלj���x�[\���W�	`k�[#�$�76{x������N����y����U6���IN���K�>T) ZPцzr�)YAE����Qi�ل\.&9hD'<\#�XA��Tt��a]���d�?��w���w����扉�}���c�"Z�.9A�Uu1Gyٞ������nN��>N�    _���P�>~�����	N��`rQ�&ן�LN���3�狡��Z S���/ũ&�ҊI+�G5P�u5WN+n��R������[~?WZQo�,�a&ϩ�2\�������Q5���j�l����ql�Y����t������,ş�V�\�}�fڝQwֲ2T����@ZI������~,r�P�'��Ѯ;�ϧ��)�h�q+����rn`=U�1�g2�8%��z1}�1�7�6�iOQu��q�S�J�!nj�[��ক���vy+�F�Mb=�&�	�Տ}��	o=ӨT����l���a�,�CӒ�u��Κc�Z�$ϵ0�WX�8��`9��Y��o0��S����Nծ���1['�Fī��1	��t���J�l�m�nb<T���]�֣4WX�����RmMGE֨HC��x��������p�}��u�q�9��U��P��\}��ڢI>;�0HT���9�����4�|�v��xYG�L��͞x��O����sY=&h�%�)=�A��*k��?=O�۱)��

=�����l�YY��1GG�s���>ɕI�*n' m��/�n+��2z9��݈��﷍�y����n� Q�B�e����ㅎ�D>�+5:4�-G���b9�;2�_y��	��������ӻ�|y��|z���:�'Y���a&��̧�BZ�ʅ'0Ͼ�R�l4��_��u�l<�	c�AT���T�o'�� �]ǬAʝU�j[�^l�uw�V��m�Ϧ�����x�?f�^�c����(h��&EK'j�3Ï�L�H�����)�{+���W���y.�\�_�vY8�/P^`{z<����y��F�e6��5�Ӣ-'�S���U��(�`Y��x&a<&���)�7#W�ɗ��6ο�y����&{���7ִ�����R���w�q��x:qG.w��U"a�Ҽ�[~�KA�5���Pk-
<-�č���a��D���L?��NgFǢ�\��i�ڃ��~�v���h'���~��=O���j]k��4M����C��~^���뭟2C.�v�3ٟ���W���M��pJ�M&#es]
�"X$l���K�`�
ե?0���Ө%p��kԴc�!�͖�s8��;`6d2�j�.*P`y%5B�'7IS�����ȓ��J���ë*N����HL������-T+�ңJ�?GOϔşr���9.0.4�~B���t2�H��v��Wa����xf�f2��j�7^RS~.�Z<����'n��tcU*S�B���eh��4QO4����Msq�ȿ�##�٧�#Q��n��QJ�u���"f@]�?�W���D:�@�|���'������Y~{���G��M�h����f9�oN��E[>�y��Z�q�i䯇h�Yv���K����*�l���F�b�H�R���y�KNj��lv;�*Fh㤒��YhD�aUfA�]�7(qC���v��W7H���Β0t1�Q�0�űV�������u��I�9�!�����1/ֿ�vS.+m<Z��?�ud��č��"�Lz���c˓�4�z��1R9��t&�]IȖaI[��]�j+�+O�]XE�ʸwTl-��;`X�cTMͳ�/|kBC�-WYG$`DU�j~�o�M��Nc��x����/�`}�E�\:V@nF�dō� �E�Vc8 �)��b%��l�>'��#������S��_�Vd��\v��߲��;� �_/��R�m4�PJ~I�I�VN�F[�G�����sB����b���U��s8�&�A&wx��e����u���<cU��ˑP^�C�#�#���׊����w]Y�g�MH'�g�uT����8�y��X+�zԮ�rS��w0�c�<�}���[+nj�KR��J�E�NƓ�r|\�e�JI�<�c��1~��nd"pw
(R��˫�׉����$�c�J7QO��[��KJGX��F��2D�b}9�L�|t��%���z�;h��MӸ���6J�~H��N��E�(��
U�bX��� ���Z頭�6�"jq����T� 6-<*\ZЂql/Z}Ԡ�ƬF�^��~3M_o�!�t���8'�$�L�*�t;���Z��*|��L�)!ɪ�˫��v�\�i �V6Y�c2��f�2)D�_�����%gA]"� ܻ 42���,���������`������<ғ����1�U�K~/��:���ǩ*�|�����ĳz(R�5"Vm�*7���-;~
�u{��\�lѽ�G����^띀#@АS�}��x�7���ʹ�0�]�j#�c*
	� ,~&�~"���jB���Z=�F�['�1��s�����ס^Y5w|�x�f����gJ�	L�(z>n]���v:#yڻ�FQ|��&73ɽ+[:��1+:-��;�炄��5~f��ψ'���t��W4J
�?��JZ�|���/��=.p�~*�LpR�}n$��18(U+������sW:C�n䴟��M"��'�٬0D7sW�H~�Or�3�[6W�48ڣa�8%7�]F�@P"0ԉpO�(�L/<���Fg�=�w�;s��G�(Oú4�à-g�|��m�K�:�[��ݺ�x�	�~��S>�͞mn�� U�X	aHU�DeU'�))��V�z)�@`��H�׿3Y�[�E��O(R����``�B����Q�}����a�^�DyF-�r� �2���
�_��F�4�g�J�gl��ԯ��6B(���?�	X��,{��_�J�VA�`�3�)�3���d>��u͛��g�r��,^~c��1�R�[Q�S�VZ°�����`�:���x}�E��xR ��(<��O�R8p9��1+�L�Ȋ/�Q6�/.��A^�|_��m6�+c�b(�7��g)�Q>[H/�����	�e`�I�æ�r-;��@|T9+�X�Ku��?1)���xo0?$6!�P��܄Λ��b5�,����?jʋ�@��t���Eߍ_����I��tv[@����:x����y}��뮊Z�J&��]n)������w��.�`gz"��+\�C�r�7<�����c�ٝ���	WT���?u������Ng��r�U(@';UV��P���A��/�9�������<g�2i]��X>e]�.�DqC�籀�N/��~	�/O��?.@�<]���<[<N'��#���=+��B����[�vcȚ潰J��Rx�ʙ�~�P��w`ML	`�Cz����	��;�TnĖ��w�׀m����bF���t�*���.��N6��"'��v�뢵�Ƣ�>M	c*�s'����^����ݑP���p2ϲ!iMos���G^�38�IN��}ipuZ8���R�S�W]��dN�]�.S�f�&4�p\��(���<���_���G�x@B'4����G�ӵR��ͬA��ѐ�s�VF�6�a����0����g.�!}��y�����R���o�d�ܫ��gx��ك���� �z(.@�#��>�=jwld7� R��1%ǭz�U��'̅%�$��OM-�XV%������U]��=(���j��#Rv��n&��'��w���l(�|-���k��}r(���$��P	U�,3���So��y)�R�36�
X,��zL��W�����[���O\X�18��ҡ�W��VֹS	epY� yg���(��*����",t�cT������D� ��cC�a�=ȹ`�??n�����!�w��X�@6�6�(8�N�6[��[�=#����XE<�_򙪜|��"�4r��Rv`�pG��sT��6����t����)��d1b���`[���Y�б�P�xɫ��׬��U�:Uw�;�t5>e/�`��b,C���l���h�^�3`nh�!��&�Z6~�7e�j����6�4&J��������7�a~[�%�`u�ԙ:�X�����f^\hE�T;���(�����y�����e�ٝ�劔�]��p=�-'�!���^N�����%�k;S����Y�_�Ue��4�v�J��Qi��4�R"�/Satl�+-)�������T~d'cq�s��3O�3�#k`�K���y����l��~�Q    ���95dJ/�>���B��Z9�ڱ��	n�f��y������Q���1����J�\�5��N%r�1@0������f#l��=�?�	1����Z�w͇ٽW�~#"�ƈ8���`���2����Z#O�:�fP���SC�kӻ���#���_�>��9� l����ߏ%vS��%�Ԑ���;fS2��8$��~��x=,3��f�<���B� Z��D��0fI���&C�O&��tu~�,f�HE�T�ݫ�}��:�da,U��+o�FHC<^_px�&�-���1u�imo�h���"ם��x�L/o�(l����Is�F�B�'������Akq7��H�%D�Qc��0a�������3P�< �XŌM�V8�.{��^��Ǽ��o����s��g��(l�]J���^��9��|F����N���'�Y+:drrs?��??)&éd��xl�B��,׆n6��%��{�t�X��y�#d�	�y�[����a���Ρa��h�z���z�{u��广o���O&���<�G̨�5|���c��\r��������w�E�-����u���L1J�K�	�7s�~R"���N�b(�s�!}���D�woF�ú�Ps�s_�f3)�J���=sBqo1z��L��@U�8?\�k���⛙��ş��j�����s�ߖ4?f�sex5��M&kxO6Q<ƌ0N����)a�
W%�#�|ƞ���XX����;�����B�h'�,�1��i"~��� A��Q�rNOM�8����V�%�{��5J�;����6"$8���[+����|���G��0&z��ٞz/��J�hL��	�h�
�����i�,���e�JU�폴��2��E��Q�DA��xb�ڶ�k�'��L�	9K	4/�Z�D����Giәa!J�`�$��S��������5�&rU7P�f��06�[,,��d.�;���q���'ٓE,��
�cޫ�y�����D�3��"�,�	�v6~&WX7RN����g�eEc�x"���)pCW8�0\�	���ُip����)Iy[S0J�Z�X�E`i���S��oO�|��6�ݎ��rVzR�n�S�q�LL�v>�?� o� d;̤g�*��eG��.�0�sp?����q��Z����y�4��c�=ld���D͚��:�@TMnIm��E]���<P����{�ʻwh���t8��U�G��+N�b-)l`^�<��j�a>�	��P��!~�z�͏���s9:�&��SMKd5���2�F\����A۲>-����d4�z�29_���]�}�eO�z��Ƹ�ǥ~�?��٫,�c���j5��f��!�͆C���Z��F�d�5Le����
_�Kwz�G.1�7>����ْ$�e/�����5�4R�"|Ye���[�����m>V;�1�g�XTŞ%r ��0[����>��	Wf� `,-�Ͳ��.-;�@����Hu|�b�&�Y�S��*���*�[d_Dpi�#���-��[�Lߏ����y6ۚ�f`S{88K�$�}�h �j0%�i Mv���ΰ��0�����7�����ҭON�����Kc���__���w%>�8Ugyʗ���3sA>[6ٟ���w����T^ϧ��.MD��D�W�d� C��,�� �(��1y^7�F��n� �i��=Ee��� ��Q�➊��h8��g�"aC���>�1��󉪪�.?�F�X�́,41��G�����	�4d<�w%��S��<�Y>�-S�!j^F�BoA�r�zj����^=q ~�;�8� 7�=�{#�Ť�8]e�$��JZQ������8���hr����Ҿ6�}FTN�V������˟]�����*���Ĺʊ3V����/������c.�,���SW��@�x��a�$_�!�lr��̦*�4�<�L$��]�2j"���_���AA&�)�xеW���o�[uB�{���{��L={��:}^/�܏����)4����;�V����V�ю
��`z\��)�#�妪���~V���q���;/�	⧟F�f_r�F���l6Wц]�S��8:�b� а��4C�;K�]�
��8)9n��01&�ŋ�|�����8GJ!z�L�ߞ��-"�l�$��Ω��ԇ3�\�V6zX���U`����zo�j7����O�9�e�,ΎE*G%$�p=s��*�Ə,��86��dg��;~ޢ��b�+�5]=�JF�L�#�'���<���L՘�A�|+���(�^��5�F�LH5]S�v��
ʢJ��͞�7��_�We4C���v�����,�b��O�o�a��yK蛋�G)^/����
7��T����G�Ђ�R�R��n��S�C��l�/�hX��7{v�qsc��l��c���N��j�Vv�k�_Y���~�C�"!ZVH9�ޓ���;Ԟ��>=���)"�J�7��	�믏�:�#������������b/?h���~6����,��E����X�L�`����7*fj�v%@���o�I�@=��^��Q���b�I+��#�p�L���o�9&\�	vYn�r�;��!�wDEt�$p�"�]��3�x>�����b��}��WKHe�N���xl_���GS"(y���-"��q�[��kE���rK���8���V8��N=�\�� ��jy�����kw;d���%[_��X��]����s���C^r��F�f�3%�UϤS�L�l�#Í��@�5Q����)�s�Ҭ8��?FF���πb��ǌ`o���� �_��**$'q���w��/*�+��bC���:��[ b��X��i�圑�N6��=e3����p����Y�>�����C9����|���a�?�I��b��O>������یۆ f�~�	}!�!���vvTC��C��͒y����R�܅X�fS����#�����J� 1p�l]fc� CYN��������t|+���6#�Kx�iS���`	�X�c4�$�'��.|8l���ȷN��?Z�Z	�`�w���ӑ��6�`4c�s4�̉�e�������([�����`�2
v2�a�$V@�+������Y�e��	\���Q	V�]v?��Ap&��9~�C�eVl�G�{�.K�=��*¾)���þĳ�M�ĕ���阰�����*�+x`v��9���l��bG�7���Ɵp��j�z�����,�-�g���,?�:_���d��_`�?*��=�T|<�^[Tڡ��NE �H5x�&Q��eR�SIU5uX���73Q�l�XR��wzo@<�,��]���V���:�ч�E�E�J8��ɉN��3V��<��,�r��q�F`�e1�.����@*�y�aT+��3����E��f�%�n����]�i4D<!M��AƝ���A���]A��	�4!��M��E��M����k���lv��w�Ⱥ��(���w��3	���O��H�y��l���Z�]6��z�����-�|'JC�+��-�Ce�6�w�O���v-�(���>�㻏�=y
��¥v<WM�����%�pH��K�����Fϟh�8뢌���j}hȸ���O�ꕥ!fZ|�{�J"�o�f*��#��rި��U���h|��t|W�T��7����#�i�g9�B��V�s�U���b����Ҭ�F
�c�(��Q͢Ơ[���9�-�7�V�\�Z�G�>Oe���cq5���x/�s���A��Y�z�<`	+�;[U�JM����\�N��q��!��q!�@J/�#D�S+�|>�x�>�ϕU��[��h�x��L����`�ſ`�����o��
�L�ˇ|r&B6��'xMqK�q�:�]1����e8#ؚ��Uϭ�f�<F+��IN<��eG;��y@�0��1�@����+Yf��rӫ2��n�Nd�ʾ�{�pP|��/G;u�j��7��F�|�˴(.�n]I!]U����ӃӟEruf�{<�&���g`%���    ��`n��#���W�Q�g��0�) �"�j"#��}�(,[XR'�
��e4W�)U㇩J�!+�d���2��U���4$�7{�}���[~vŹ��i�$)KX��^�F��q�IZGJ`��a�W���.B?4�r�zv�Q�O��j �2GSXWJ���������dՀ�*�
I���V����H|) }\��*i.�,����7�W"p/�PiY깎0�)8M"��/���2Kn�_Hr� �_�n����0b`E�$,'�3�q
,��Z��-�ZB;*X�5�?�O�e�%�`^���|��%\q[E R��F��c|^6��aQ;FK��î#�]JW9MMR���v����}Q�\a\�V���d� �����0���S�&8?y6"<kE�Y��2���[�����mEP��c�k�ģ�CB}��׿����Y)y����m��$���gD�^��/���V<&��,+��ݿ���v��+��m޴��\AkY��~Vd�:<��n����V���:=���1��D��39��;.𽑔���j�k*�?��2;���;�0�K�7�]�\N�[[w8OH��2�}o��7�El-�g�/�AA�
4~,�<p�A`� ����������'�� �
��2�җ9�\y��xz�y���;�[��hv�x&A����P ���͵���]��(?���:��3R�F�P\w�IR�Hja���*si�+��s
KX��ş��5��V��%��=�Տ`Y��1F(7{2��_�K�^<�u�6�JF^�����R����+�`g�y.Z��+����w�n���F�J�o���
�;�n��-[-99�߉DBl�P@Bi��|=�A��^���uF�;{�,��DR��8��QRE�QU����Տ���3s�L����n�O�����Fh��H>1[slR@�O�8�6e#
�m0����A�w���JaUˈE�Ts�8\��=p�U�^a�Yp�����4���5��ɯ�t���ň�}����%6����i0�V��+k�5x�>]}HÍ���>}���L+������F� �GXۋ�*�[�j��T)d��������r�S����ߑ��}Ḧ́�F����Ct.5�;�w{.u�NgU9)�&��{��`�2z��N>�N�`��nuy���3N��G�ʙ�B'	�ҙH�H� �w�D��l��f� ����3G!ma^6��Ac�LϬ�1�ì.fUw���F��!]m8���D��a���ZP�tpo��>�+�ӿt�a��\���Z\yG�*�h��0��4M��r|*x$������>+�K�˸i�F1� J��珧zΩ��n�����J�̯���m�K�,ҧ;='Y^�
��I�AH�3qk����凋����� �Ŧ
�yR������������Ǖ�i�3���S&9:;��V�Ƕ�hC�v�j�aS�� M�Cĉj߷�dLD��?l�:��bDr/[䍍.Pj����'�/���`v^�W�\%G���^�p���_��z�K	~�򺊶g��h4I��S�̪�/�jl�=�L�7T~��%��6Le�02y�K��{�k��P��3;�,�q�f�"8�T0j�[|H�� [_�悺���H���1�;K�9�gx�-w0��P�&7��Y�;8Z�����{ZS;�p-��p�&]�8=��� �j__��W����S���Pg#��xlW�V��Al�"��!��D��n��D,
u�Gm��Qa�*�e=�TO�k}��*��Ƥ_x%��&0��M*�V�}�q^j�X�T�TYw����<��ͩ��+I�?O~�|p$�S���M:#lIR)�0�I���k�}���0{?��ּnE8�J�Y���׆'�)���aՂOр20i��V���`Lc��B�����¼��]��j{ۮB�Q?�(�����J!�!�XI�x��^��YyU�|d�:��rb�����7��\b���x���Z�p�D�"���.�LL��C=�`,S�*t�[:
�7�(a�M�Y�����rI]|��#�{�M�>y���U�=?a=S��wy������	��˲�,�k�+��)��(G)���<�+�V�;��� /uo�6~!y_ՃOSrEv�i��^��-�#H��n�������$2�4&����0)�!��DǓL��CQ�~�����n�FC��.����{����f���<���o�ϣ�j�s+V3����|q�"�6=T���%��n����6��`y6��f���ǋ���ᷦ\��t�Z�a�£x�������0wS�7ͻ�x�FzIPp/�]��$��?G�ݫ(��E_��;��NEJI�F5,紙������U���acI��bH+����,��t�y�]hh�JtJ��?֖}�J>�ѴxZN���t��{���U�4�/�[u���͍�,�6��YtH��_ha6�F�8�S�?���8IO�/+Rno��2x)I#�cAKi �8f_��>�r�]j���V�Smf�Z��B�a��a�[?��Cx��CGA��T�0�F��JQ��Y��O+p�c�#D�����I=%���"���K��yHd�0��z��R�mz��޽���t���75�������D����3r0l�=�e��Lt�i���8�:7�M}m�k�j��q��~���	1���6/-g�m���IH1����!�>���#�܋��ۅ�S��Ĵ�5��upj�fst�4^A��:�����M������$�7��g�۲� 8��0�W�E��(?d��F�\�]��38��<F��H��w��\ ��S�l�~�	N&���buK\�J�E����V���=������
Ԗ$p�*�K��!��h��j�p���DX8#�0���-���%I�L���ǛV/���o��y������,k^�-�qz����1�e����[���Lņ�j����Ƅ�^�ye����.42U�dy�`#S�Oaep���6}1��R�cp��7��O��o�Ҭ�����2l�I:_�2�Ͱb�_�ε�@W{�K	���H/��z �������BŇ����j֨��^^��
{hw��$G�*�Q�bT�083X�x�=�� �3�7�Z�o��Ɏڮ�I�(/�ع$��A���*"ʠ���܅��Bx����㩛��۲��z�����1����C�B<�#�}�an	�� ��Gaa�L|��̓�{p9���^d���l�������[s\}J�H��pn��O+IH\�\�y=��!M��WH�I�T#��3�����ې�+zXz����ts��G�gy��Ŀ-��nޤ���)҉T��kx�����i�������fs��X�]�|:��EŁM9ܾ�l@9�T^�T0yp�*�X�%�P>K ��� d��1rm #=��XL����n�E���#�`Iz�m:����w�<�����:5U�wpU����c	��)�D�[�u��fRp4������S3�.�Ӫͩ_��*��w@��J8�Ʈ���k�f�c�U���c'b*��5.`#Ck���IV����/�]��2�yXp+�$I���[c����t����镸7C�-��:���lX�"@����;���d����[@	���x��(�QI��0���=ٹX��uf�����4�N�y��P]�HB�(q9;X�4J<��f?{��uP�ڛ���jU뼠��P,Xa ��N���O�K��ü�LR���4?͛���O�����H�7���"�g��ZLַ�.�zpkBw��F5;�0�i��T(&=���y^d��I�z�2w�"L��KCi	N�U'�p�O�t;�tz{^-��������@�(]�ϡ!E
DH6�;#�˜L�M�^���&�L���-���n_[������ U:*~�ɗ�"�h8j��@$�Cs��C�}��{�WN�I�&H�s��_+���2�K���i��y����#/����K�4��x�n�j��4     �'�a۠����m��t1Rqs��#�H�0f9E�~9)+-�b�T%]�ߓJh8�k��ʸw�Fz�ũ��f״N�ɛ���{!�OJ�] ��EmN8��3�7Z�iqu52��=������o�^ukF���sJ��a��ȟ�h��\�Z�V��Ʊ�0��9�I�s� O�=�W�3��j�����Z*�דav�M��]$ek�·�x���� �3����y�{}���2+��tq����~a��00"��dB�H/�#� �E���lb=���L�ۤpa��qD��8���=�SN�ܻ�����!��H�~�^����Uz�~,�� n���wow��wG�U�Cs�̎��,��wb{#�3u>��L�vb/a��k1I�`T^n[�>2P��;s`�u_|��~k�U��"T_�Bm��4p\�1�J/���=_P����G�P_�Y#*�E���e�i���M-�7�t'���%į̦E�fW΢��#6*'VJ��
�A�K�%
�H;��x��\��aXO���y�d�$�A̤�]V����]u7��w���0�jB�*³��/��U�tV��8Og7T�-1GQk�ɴ.� �| ��C=CR��i��[�Œ�{Ck�F��&t��׶��_�sd���\59Nޑ�d�.,�T���������?��oB��DEC�
8%�T1�Y��c�g�Z:�+"7�%:�/�
�R��N�3�@���Ya�␚M�����L�_yi�'O�g�*@:�G�q��~�.���%D���]À{�J���5<��sn@Pp����Κy��/e5��������]`v((D�	��k�l`��͘Θ�52D_E�Y'��Ĩ�.����*n��`#����goMO�k=�U�fV�PV5��(��$�M��:�`�G�����S�$�'ù�J/�3o�h�����LhrP�ڱ[�M:Ո�M\�c��3N/�B+�B�|�K���H���T	�m��60��ve��f�*aئ�ǿ��,܊�z��\����ﭮY��ϭ�fr�5�W�����sI���;���]��'5^Q�±㚋Qu%Z�S� v� IS�0�I?�ڛt�-�S2��7eEX�S���,�G�o�T����*f|eiU�N�YUA`��CGS�����5���r�S�s2��������`hS�W��%���=��`��Ak��`+U�>��<���#�M��x]7��چHrTe㼾{9�/�!��4�v����Ҟ�����Ҵ�B(��\�+�v�1�{鴶��^.H=5܆�J�ݮ7 �ؕF>q��L;jcw��!�C����:_�a�{P߈2�
�1���ş���{��e[�V&�xDLQc�t�=�u�P9�Fz��;�O�Q���St�w-m�i�e����@�ݾz��󤯩|?1%�L��6^�U����ga�9�,�����a�yN>m�[oĢ��Fc�͘�*^,?��'�_�s{\���)�9K �=�O&��A�&�C�����q"Jܝ$�(� e�X(Q";�< �X�r`罄`5ͣr�U�����_�f3��>���w=�i�Uٵ^A;c]��Uk5 �wa�ˡA�X`�X�)a�7ǣ�B�x#�I�}Y��Q�->kv��M8�|��SqC8�󁏳���{�mjH�.v��27	uS.rd�^��s��A+哳������ɶ>���V��=4n:#�hl�
�$8����i�qh����&-�{��O<;�QDuW���i�di�����]��i���ZS0�򌸔�+f)��V�tP�3'�����yV�Rg&_e���[��շ�3퀔$R�e��!�!���
V/�����0�Ӹ�B�o[3�Iw��*��l�h��8�۹���S��圂s�c�j�3@�E�V���dؔlR���`#SF��%��l*�b������ɬ���n�kSxȾI��*Y_҈��m;ŋ�k�!��g�-���'Ea�#1a{���l���s���J�H���RcH�JC�CAIH�!a��-+��,ݘ�SA�K0�07�G�r0�S���H�Wa��ۄOY��1a8��j�xE�u>��y�;�>k�^X�`�	�ī<����~Wp"�6�[��Nt�q��'Z�$1Նw�������[��=^������P�����c,�����A9�Fu��b���E�Z�S����<X�v�C �"�QQ��5yR-����Ƕv��$I�g��h1E�A3���ѻ��ZH=�w�az�#"�� Q�������O�T�����Y�͊����#��I�v(x;dh�U"FJ�P�oZ ��r���$lY\h� O"{_��w*��~I�x���ۦ^�+���O';o}���W�~���K�8)5ի���Q�(dt�~�7گk�,��fd81FI-l�ڃ���}��F;Hib�Ic)a��`�yg�_��+"y��o$��N�=�Q�py<�e_�ǛO�)�Ҙ�����CԾq���tC9��BY�!{O���ᓹ�!��S�@��΀���_T��4%�	�E��`C�<��1���8�Rk���P�ݔ���M׎%
��)�)5�ڳ���(��h�@z�y9�&���#]$ۮ�YU�av(�[v��&WZX���BHՆ�X�ZF����0mL7��)�Ƥ��yB|?�@�Lo�i8�L�����,t�R+��^nFf�R��YqZ��"9�Y
w*��#��a��h��K��+�#!8�������Ʃ����`I}���<H���KL��~�'��o�k�T=�[�����r
	�^l1�\�Fܺ�x���)��$���{�>ƹ5�
)��^Fob�7�iGqw����*[o509��+��]
��K����-U�sZ���C�did�mqp�e"�1�H7)�kE���+#(�Yd0U3�o��)�H����wԇ=k8��2�F>��#����g⢚l�T����E���pSoIQ֏�.�������$����̰�ݻ��� uTb0��fU�fp
�:l#{P���iv>k���0���q-��C�0�0���H�f�rp��^S�y#)dEh�Pz���0T�縿H�ù����#h_�*j�1�`z���Ǧv�bg��؋��7��?;c�d�x��[���Ό��/R�FQ^�G4��B B���)���<����^�m�K����Lt�t�'��eޯ?��n�^��U�b�h�1]H�I�~��ڋ0��^]�ՖW� ��������H�|�0�`��}^ֳ�,?uH��}��-��]���u�z�d�׊��Fji��4��@��[�0���c��9p���:C�����I���i��D�y�|�R3�N+w5�"�9BTg}�s��VS��ygп���,���U>#��_7�w�@0�!Đ����t25�!��0BI�׳�:�'�f�;�݅ȥ�_�g0��A����� X�XD���4g�,�̦Z��/��J�o�:��X���{*��:��r�~����g�� ��ҤO���4��8�o���z'%,,�vC�}h� ���3��3�f�.��o+�^�dۀ6�W���L�|�tQ�}G�����	�*��x)��R�E�־�OY������@�IشbG���z��e)�*���M����
K2�gŹi0Գ]н��W��lp
��ݭj��E�K�����(�G���-C���}/b��=�\7a���[�oW��p4���� 1��ĀG67�&������&

=y�K����w�]�i�>N�7/T�hb4!��ʞ"���U�#�+j�Im��{�Z���e�/Y����F�a��y�X%l��|����"�:M?��_k�����m���<��z/��ҥ>�A�.uh�?����^�1�&���k
|IiK������y��˫�l��Ěq/X��M9�[b����b��d�y0�A���҉�vѣ3p�I}�}6��Ѿ��x��=ډm�w���x�]���u�3I�w�؇@iS�
p�����[D���`�JL5������R�5������s�#�
L���²��h.��    �0o�����U��������nPVUZ��Hݔ�oJ���~~z: ��2�}8�Lp�&y(��>?�2����?fS-��Е�Z��� ^�_nې�'�PLx-н�8��C���aM�㧀��s?��I9�2�mv9�`����8��bպj؜uSB
L�
���F���8b)��\T`E<fl�[Lv���U����-/�/턇�Bb��To�uWpН�H#��UD�fXE��4�Y��V��@K�E�mo���D��b��g��I
�V�X�Ѵ"�
w����e�U����"y!�s,���W���<U�l���>��C���Z�{.*��! #���_�ߓ������0r�úr��e
������oR[��$��ߐ#9Bm�òZ��ڭMFTL�<zIɡ�����9��m/���۪Ҷo��4���ƹ]a�1��y�,�� *�eb�]�t����)�H.B�ٜ�!J�c�"*T	�?ϰ9���a�8�΂�Z�h�ܸE��^a{N�����Ց)sQg�3�(VCj.�ׅtS-l+BI��2#�!��{vKκ#���iE"t�I�"���C��XO��j�ϲb�e�Ի���Ba��#rT C��P��OKS�>)�l����B�����H�Dz̨�Ls4<��G�������D�����X��Ӳ��v#����@{K���G�-�|u&�FEEp������6�a���%$%N0�3�d�S��.~�'�kMq���(\�J�F"�(�Rd5��u��ԍf9q
´���ePeq�䇝��z˖S0�КZ%�&ٻ�s�t~g��ukY|�|3A��]�Z�ݩ	1�֦ڎ�|08�`;Ӿ�Kt�O���bSȭ>WؐCp3RAC�	�W������$��Qy�M�Ճ|�BA�'���t��(��	�� 
lq�\b�Af���ΫCg����+؍���eo�-�К�*��z�;�K5>�3����	ݺp<<�żCɕ=�_�e$�5R%��e�����<͂lX/�W����J�03D]'Z��A�Dw�&X3��\���~yZX܃�O��t@9j�&}�qr�E�0
db]�F>M�4�	m:�7#��!��O��v�A3�,��r�"X}Vl��r�i�H�c�i^�_�8	⨅xK��h��H$���K�i��c{���X&�5TL%�6��N78�ؼ@�S�6 ��b�sWZ��=�D��x�w,b�6�w^d�yJ�{��ݥ����*㟸G�	M}�������QZ�w��--�0��c��W￳Ӫ�(L�ɺ7��������Z�37�3=箶�W��"���Eᬂ#�U��<c�[=ڧ�w_���R{oS}ݍ|�1�6L�.��F�8;�`��y�5��5y�4��9�F�F�ψ71�<��^�3U�U�-+�-�n��xd�M6����+|k�n�~��R�{�禾`R6�����6��.�-UF�B���a��5�R�֌	��56"�}j�.�K'B�gϾ!��	�l�? ��ܛ]�>�+;y�IOʳoy�Ǻ���jz}����Bw���-�.l�"y@9����ao�z�^:̯	Ot�k�]S�i���B3��R=�3;�m
:�gC���9���[}X�����ђ���0j��~L��9��
�6�̴s��""I,<��/5v�RN��+{ �&�Ѕ�����R�@*;8�MZ��=�$6��9��4���Q��O�	�������V
��J�\��ƲF_��Șb,N�C!E�/N;�������)�;����L{r�l���|��f���~2��ȗb�U�a$��t��WXkU�e��rDb�ܬq�5�(2��Yu�=���\�8�8�V�Kջ�g��T��&]��|Uk� O<Hl%��P�F���y	���c���qM���&�ԫ��sI�*�m���ARҸE�c'\g�J� ӫ+ƨu����)��a��v�<=�b�����Ͱ)K[+�*��̏L*�rPB�Fn+��zpN��$�݈��/Y�)^<s�sj�&���v�d��L��n�Bπnοig��\Z(}�Bң�y�h��	�"�
��`�ƻwR�Ho�N��m_�����U����X�X��1>=K�e��5�6q�S�;�_�����ͻ�AgL�gT|��t٦;؞u�����?�ʅO���50��1R�N�F�M6�Ƈ���_�D���'v�&���ʻ�� L��F��ka�b#k��D";���ec��_�|���KW�������
�B���k��%��N_���c06�A�0��!κ�Z'GE:Ks�H��o�!�b�.~��~̕MӓPA�1�B0����o]��M�|�v 4�뽯��z�䤾��#�}t��_P<zڇ ��?�¸ 7����i�d7+�~�3����R�����T��9���p��Y���%�Jݳ��֦Xۀ]>UXa��}L�_�AT��k�a$�>>V��^M �v���A9�M�W|�������	O�T���J#a{>�|ڡ��x`yiF�g*EK���z��ylW�������J���K,�-��-ָuZ�s���� ��G�0��~1#�f_�ݨ��I��2��##�I�(���W��?\�7@$�D��p��+��#���ŭŲ��4�#�l��i�4�h��X�����l�����=#��n�/H"�WQȨ�TF����������?�ߠ򷺦�׵J��A/���)�6Q7�rL#lڰ���!�,E����T��ֆ�.�B`��!`D��O
�_V�]�����6��U�2jBӲ�?3ެmrt��Xa�o�,
"�S8}U�|��^��93���8�]�J�����\O�O*E�}i��U"C�|�񙹐�pǃ�ƾ����?'M(w3س���%�;�k���~�fEm>a��<�`I*o��d67"x�Z;B���;�Q(��D�5�D���8ϭU*{���3l�^m""m��c�UT2rq(,-!ƿ�e^ý��~ �WI��=-f������"Q��ƈ�?�1Jm�Ĥ�����s|i/����m�{�sT��:��!s����O[����,����81*Z�IQPj����0���?��Q,m�V�q6%��9C�k�/)r�g-jE���3=�/�~�OJ�Ca"񤴨�ޡ&H	Ⱦ����Q���7
��Ӗx�U�j��a�K{iT�RW
О��Y-�y�iT��L~������Æ�y}��>"�9�E��E_�{S�0J����+�߀8DJݺ��Iw���.�Z=�F���s�/�?;m��@R���c�^f�����<=ہφ�H_�^�t�g~C�Z�u�[s�������K�#c�A�b-���F���ex�"۴��6l�h=h����}Z$�($�!�L4A6NԴ����CH��'G��<[A��Y��G}FJ�f\��#��<\��2�+�zwrx����=C���u���;��繦,�y�m��0�R�[���m�m�ƭ��c a&Cb$oCܯT�1gn޵O�0
�c�R����-3��L�S�����������,�K��O����ݧ���]ۍX'~��ۏ�d�����;5NVr��������\/��-KǻV�O3ג�&������4�60�����8l�w{�;�OY02׆�|}a ���Ѕ~��U�'��^��5��d3�d;��R�$��'-N�^�a[\�v"��Y�X��CbՖ�/�����)	����ez������Sw�L�' У����K� �RZ�0K
�����	���!$PQL�v���i4ĐrI"Xk��� �)�.��	V�+r��zm�D��T#�w��4	�������8���}�e�8��~�ֵ��E�.�ua����,�ADE;�0ؘ���waX����`��98<.L����h:�Wҍ��Aۭ�NM���3n����Υ���/������FD�H�
�z�;��^?�p�-J�p�vH	CEw�F!աn�oNjD�m���P=:����ca0�k�Ds��(���\�lO������    ��0�X�sc;���V�(%��>�Z��m��$�Jp#�(�&o� 6��~Z:������
=ב�<����[�j��-K#	c���u������ݣe�+�����N�O����y�]������-:MO3�}��	��
Y��EV�5nV�H(�ףp������қ�8��1�R䏶�L�	��Aӟ���K������B��&x1�]0����+��zAX�I6��+&R(W~#�|B�Z/�pf�:��﮹�s{�&l&ʧ�������*n�z;n!����^�P����Sf���N!(w�9�0�鷦#��{�G4B;�Q�������Q��f?�?-�sw�dњz�oRX�#����C��Eu^��?i��"���{%�-y��YN��o�꣝X�6����Gyj^g����c�)�H�������H�D�=���NP���!�~l��[���$�������0>�����㖾��A�))d�<��+����e��t�h��?f��i�e���3��(�l2�2`1Ba�	���:��hEM��nV��e�T�5���-颀Q���+(y'��R�$����v<��\{��c�U��1��c��I�7.��}ph�����E=u�u=u�d�~P�?{�dRV��h6���%c:����0u��8���'�X��Ny��n>�1kf��	��Z4�����7;����Y5U9ȍ��a
hjވ��B%�7�O�pXO�t�#,%�� ��R�xL��w�$O����-�`��}�W�@Q�u�^ԁ��+0i��0�����S���&�j��X(Q�Q��ѻ��D���y&�֟���s��՛:v������*aC��Ȧ��髴yDwg�
�8� �F:�`�b.�]�QکV��9Å�9��5a�c�C�Y:2�!h7Z� �����gݍ �Λ����Y�����w����e�<59�o����K{�ӿ�F�۽~�{]��Yzie�d��FC�]nu��40�&���Y�M�K�D#�5�R˦��g؏�:[!�F	CSӈ�Oe�Ţ�35S��$�hVC�r���*�^�������������X�OKr��Ҽ� ��A�^_��J5?�#��$�Ŵ.�Eb�GR�,$a#�R��9����b�����jc)c�g4��~$�pҁ�ق�?dz��Dt�"W�.]�G��ְ�J� uï{���4�P�$�T��wz]k�����C�P�hV"0U�b�o�Y)�O̘BE��o��j`~� �����뻗���,3I�?�:��u�������z���!��K�����������:V���?+����?�s��ȸ���%\���zkۗ����F��x�e`�����q1��VU�dZ2I����THi��XC�f��G������t�a;�N�c��?]'�q������S�5c�a]�x^�C�s��Ũ��H�֧+��wp;����!ye�0�38&e�ġ0��5�O��˦���C� L�^#9z�ꆆs����V�1���Sl�8~0���-l��d���yE�(I����������Z���S׆��Ej�$fA�їi�B��+��	X���[�u�zB�G]��]���1%a�=�\?���NkCYt�P[�%Q�y��Ȗ�'��P{�O��,F�q�y�����t<���X�m	1R�?C�R���fe(U��x�%b���M�QC�2�Zc���0a�o����0��oE}���y:��n;*���,i2\��Y۞m��޶.�2$-������°�j~�h������ry�E�B�N����苮���@����F����H1B��9��$)�=�t:���\A,ͨ��N�d"��<�3��3���[�������D-��Y]��2�s�M�� ��Ayv���>ԝ�8�������:�R^�r�,�����OB �ׯɠ��~h>m�=9NǨќ}�ӁwR����aY_��Î��ಚ��k��Jc���+0,8>��nW���}]$l�����V�t����;	Oꬰ�Z�\�İ�,��K*����"ُ�$��}��o�4��F{M)Xj}�w�/u>��bL����s�$�w�\���\_�T_����d�̐p�i��n[�ٕoxa����l�:�Lr��+,3�rH�f����<����^�'N�uG��4�>M?����(_5��8*j�T��J��S-��^�Ȑ�.�'q�ܣ���C����dI¥O�{@�� obG8���[?N��~\gC�^�g����R�>�I��ĞW�m��.o���j;:���D�Ueᄤ���4���0��6��;�˲8�="<��0��T��R1���iuh����yz/��[���2�~�e<��^�)���j��s��kZBυn$�T3�ٙ�M��8���5A�"j_¡�"�1T�������%Q��*ޫ�)FO�qͯ�mV���贈2�Ls��>�{�G4	,�	��0��������)�61����,�[Ƭϩo��]nf�Ub�9:y���fI���'sV1/�_�Zau�)�[��E�T�G��1�!��6\�ӳ�8HL��3���P��=Ί�O��sW/�������H����o�I�YeD_L�<�&�L���J/���A83V���!��W��3�%e,MDhj���4�k��X
�L1GJR�	���<2��8�U�g�^�%ϪI�9�zFC��@7'��I��s�(!a��9:���Hk�A?$�1�IFv��5I��l�/��L��D�Ŏ?��a����m#���-�m0�'E�eޤ�8/?�ऄ�'�����Y�Ʈ�%�>M�ūO�e�Ii���:+�?��z���"É6̉-:;�m8f��[Xi�	��4�`�%U�����ypXBr������J<?�RΊ��8ݙ	.q?L��)�~��� Cx���EVϴ�sRNrpgQL�e�'�p
����@��t���V����S2�A�Wbj)��~��]��0����b�_V����t}=�?�kA-C�k�ب.�+�'�<v�"�02���<'*i#S7�J�v��	��-`�'|�3��Q���YU#$J?��y;��7�FJ��{�4~ߐs�����tе���b/IL�xq9%�V�����Fz9�������p��P1%G������DP�(J"d��5r�Q�.�u�/�x�;���lZ��?+�	��͌2��m�E��Ԯ���]�m�=��r+#|i�Ȫ:8���$��
	C�g���)����e��,�n������P8�� ��n�KD2�~T�[I�lw����l+�e.��(q �s^�����[;h��|����ɵ��d��ӁL`�E���ҢrZ�D"	x�L1�.�gHV��ĺTD���b�M��4�斖K���8��j�9�|~�wp#<����uu>%�2t���PXGPnBj��"A��a7	��E(0���<�E0�o���<ץ�I�E�	�M�,@�K6V�1E�b��]��3dO	�C�K�B��{��N�`E�|;8��BŖ�VI��Y�E煙��YVd�@�����-�k���qvVd72�G��V��9"入�5�.�[���䛳>���W�t�ݶA�Wc�h�_8<R�3�
�F���]��Oձsr���o�[��N�n]]��k�H�$����F�X��R�|���
9��n�-c�0ɍ�bG��ohJ�5�9c�'�,�S�.!��Y�w�y
�[I���VY#	�<�a^E�j5����kuHE)i$#_e��Y���
��ܸc�G���!��zh�(����nOﺺc���*u!�$�{7�
����b�����Hގ�I=,/�9���v�6����x��`A��)7ڏ���Fy��z�UWD@�R���Y\A��5%�l(�0�~#/*9v�7�7�$C[��I>��i�{3�";H>Y�cL����/v��x�.��׳�%�7sM�Ns��7��Oq����v��k�-�K�E۽�����p�{Ci��\�K��U,�������}	��y    0����ZNo/�
7�:�mG�l�QXna[%��4��q`5	C�ћX�]����c� � R|Yc%^�#T}B���p��H�Uwr�WT��q�ᅲ��28vww���H����g��|?}��a:��ܔ����b�$�_�V�����H��z��ng0(�U��e��}��)������H�W�V#O̡��J����8�a��쌓����a��vDu��jG�}ۭ��e�?:}���ո�Yn[/<BL��z
���s4`֒�Ê��"����N<#����J�蕁.<���c	%��n��e�5Dw՚ :L��0"�l[c��X��ut�@��mG�����c�,8X3x�����c�Ol�ft�U���@�k>A�]�ɨ��eMi\�Pi$��!�7�`�g_�d4���#3�`l/���^��f���
Г���t�
��?�e|ih���Q��*`71ad�9�qd����eu�~�w�����B�ʝ|Uk�و >��]�l��A8�L|T"��cӑ^��9Bh&%���v�Ka�N�bd�6�����;�´q�����M�X�?��.z�u���OD���(�1S�0���z�$?ְw�چ�a6%��Db��X��K8��#.�����y���	{�n����ZE�G�q<��<����b3�viKYv��>��@*Ӂ�IKb��Q88L��3�KC	�|ӻ�Z��Ϣ���J������Vޱ�� X���*:��mW5I�hZi�~�U:1�T3?G��,�2��U-�A+bl-���$��6�����gt�����y?����2��U��Mi�C��^��D��Т�� ��0"�]����n�
6��th��E�i4��|҂�Ta�9��9LԤ����x^��ƞOr��-;ap@��j��	F8��D�Re��(p�7�$������n#��:U8����v�'�������k�	��jp3��$Z�i�7�AKao�{(��" Q,��iv����Ň��ͷ�g��Q1<����i����w�(��-F�o�Hn�zh����dN�e�E5�a�qrr�WC�z��m��t�Ofp5���B6'��(�����M94�����wS��EXi���+��4����r=J�L$����Q_�K<IX�Q�@E����D]1ΚG�j��t)���^�Z�����1g��|l��|�N�Լ1Ȇ�v�785��Ҝ��������pLi��<�O)����^8$i@����m�Sl����i_Xo����|�}�wi��a��8�\��Kz���h�����6e��\���6�T��ʕ�T,&��0m�
��F�=s l��&�W���Ć�Y��x��-(�O>�Yw�o�T|��9����t	�\��!y��_S��i*�;"���eW����fXB^d�3qNh��	��KR��،j�)y�92���/u�y���ZSEm��ۣBư&�4+6mۈ�g�d�$+���n w��Y:�	�WY"`�b��r����H>�D�ZL�a
�Tf;�h7�0�)N<`�^��Ԅ�φU,O�}�v_�}3����=�Oyɷ�n���o�K�nSTX
wt�F Ey��?����yC��� /v�XC����t�IW>._͐�|���:^���%�[og��4����,��Ū�Q0��H�O�6����Ɯ��u�Ƴ��f���	p�εWZu��G�b�a� �i����pCq2�SeauW�mp�q��6]�|7Nᳬgզ��/HY��8�ht����Ƭ�g�����c��DұO	
Ci1��u�
a4��:��+K<�ǎ�>xh>��q3�`�H�j��F��rX�09��r�w�<#?�{<5�c�;��Ҽ�v�=�<�&X�R�������ȗ� �'KW�}��H5ϔ�]�C��e6a��ԗaԗ&�isT�P��Xk5�I��et«�=(�C��DQM]�}�1j�dR�!�-�}T.Si[�z��'ET 7���6�J�t���Շ�YQ�i��/��S�k<��tk\q��Ry�u�,�234�C�.��Gr���̧�L�v�t鞜�ť��_�ļ�0�!!�R�AfB�_�c�c�\qXц_p�0N��ɏ���C���_r<
��d�X�"J'!y���yID��B�l�VJK@��i��z��G=�gg��|r�>�2�΍��>f~��u ��H4q�\�s�1��{�b�\��}��&=�^��8��Pr��=�'~��q�8�ݕ��?���?aO- /�Y9��3�4!'e˳Y>]ɭ�]�cK�E�P0}Wo����e
;xV��-
Lj�~ ����$̹�﻽	~y�/�s�4˫#���B}⸨����X���	�4:ϻs��bK�)�8�-.��zjE���4M���wp���aj??�ڌb�"Y�⦛վ�d�v���C�9C�ɤ���zq{�WU��Qjd��I=m�"��B?�`4����]o0�!"����Z�V���N~�MM��+�n�B��h��z�a,#�|��tV~�d�0�=x�F���:'��yV�Jy��8��3�	-G ��O��%|HJ����dd�4��!��>2�h9��F�y ��m%J�����*���jo�K������j�p����;�����-h�QbLD+�a~m�e��zg�]�ZE9umS��fLJ��;䞀�{�;������2&�C�0AU������D2�8�#AzĘ�����߰60��*�}��$_E���L�
�iK��J���k�N!i��%�S�$�VuZQVX�D<�nI��To��������P�����9�d_�8�.ߦ��lʑ�=�x������	�])�ӅpCu5���9T!�*l�ҭ�́�h+�K�ṗ<�P��T"����F����[ƹ�bc���~�:i���(�C���4�ǡ�&��s<����o�3ݒuZ6Oc���h�e�4w��o/��7�ۂ^�4�"��Ӱ�F:ouO����5�!�<��{����8�Z�Q�`	*��?靹)��܃�s�����p�`�ܱ�m��Ч��y�$��i����=��N�е�%�0��ۅP�s�w:R��{���jv8�#��'i���.�|�s5��a��ʉ�[iV&u~z�^ߋ*oov��E*�ĺ��
C�֊x/���/�`�G%�܄������p��v���>�,^��R���9_^��۲>'C+��c6u@��["l����{���E��G����R]/�u�0"n�5�~�v4Gnt�Kr�|$!^�����,Jl�y_��鲶.ײ��@��ֿ$�nA>r�.ȸ���L-��"L�"�;�n��\ƖXأ�<M�G�;@H)�
y�K�.�a[���1��jR�x�x"���L�΂!@�9�l��b��܂mlh�A���9)��cW��~������vwPE���ݜ�9��Uη'�c���V��ΐ���ya��+�;���̠�rl'1�<訾a��c������K��l����j�2zqI?mIB]7w����^e�t�I^䆰1��,�>�/�Q�}+�vW -|T�=I\���m:���1C��梋��m��bR�E�s��ɇ�Y	Q��v�%ؚ��}�Mˆ�S�Ȋ݂�O�T����k̯������eҥ}TC$��ӏ���^�e�u�z�q=)�����/���;ǅ��E-N;$H}��^a�ߖF�b�L1�Џ��\�q���-�ZHh�}�%`��i�
x��JZ����L�}|!
,�w��m�E�ٖ�g�Tf�������X���c�9�����eY\"�^�Mu������j� y]��f�B�ETL4�4�H?X*�S�~��{�*Ea��\[�9i"�ҋ\r��Dϵ%�m�j?��y�<��n�)fʺ�U�	r5�y���)TI��)'e]���EB׏b�6
\�(�ꂅ��������ݓ*�Bj����Nq��Γ!�[W����ط����0'9���9���m�p�X��'�� 6�8.��!�t>���F�K�    �ʌ0I\}jq<N�&z�7t&��9�u�]>j_V��cJ�cL�SU�OlA�N0�3��.ʬ��A~��{1��F�S�[��}�@��?����mV����q��@k�b|\A���j�0�+`�</2re:�~օ��	��`�`��M	O�7�r*�2t��|-��56�	ض��2۬��`
g����n}��W��|n&����~I���G��Ԕf[%o�yF�!m9�Q@�0����ع�a>�2md����Q����,d2F���w\��fz���l��ݱԢ�2�W���ˋ���^��kZ�G���g3��݇��Ȃ{����`�(�(��B����K30�4���:��׉���'���P��DJ�3ih�<1Wэ+<�μU��������K��W��]|��[��Q��n:w`_�.�䙒�����$1\��g&���ө��i�mk��`p������p��Nn�g1T��+/��c���"\p�N���p?L�D�Y��7�x#6juwi�w�t��s�>������pK�T�N�;\��(}�FE��S7ҭ~X���r!cæ����p'}f���
I?i	�����sp�F�D������)0�L���L�C̝�Y����v���<��$H�e�~NZ�o���tAM�>�<5Ȁ�U( &jZ������c[��;��$t��6��@����ʇD���T����m#���SV�Q�Z]��+��}�{��J�QC�w�+����"�9�e�m��4�4��y��=)�G�g,4�Ʃ��ϳ���o���:O�kpk
�UN����05���$~eS� �,�ǻ`�h�]U(�>o�ܣ�����<$�i���5j�+�JwvX�����/Կ9�n׃� �5+'�k~1�^o��O���
��֋l�m����W�!���Xɂ��@���{��ے�-)hB��^� fY6ӿ�D�����W�>eAʅ�8x��6�+�*�i����g�-V�|���&]>������K�[���V�@�/J�ԛc������^�w�:��R�n���y:*�+���%k9S�����9-.`˧�H������F� ��~k��N�\��"]/X褕�;̆��n������u���@m��$���{�UU9(�
�O#t��z��o���8g����4����m�����E>���t�+��y�2#SA�C�(�b�XY��{$�jQ�m-hz�;OS���M���g�t�L��ą��un�?�M�^v��e6�@Y�O�n�ޅ%ih��4� s�!�c�`		C~o���)F?�i>�<��A?uʰ��=�?�����c���)� ��VG��]��J�Q��Ox�]���x�KV����+(YU��cs�)a��������?���v�	+�d0��!F�~��Vc3�.�T�)O�^`�H��)W�v�)
]G6u��ӬŁ�z	�?�fhCi�馉C�P�I�X�rk(L�b��3��;�4J�Y����	V֓V#��Ɇ���0"��4�����?H�^���~>��ؓe�`�����h�� ,H\K.Rr���>�v�j��f�XE��Jl�]'W&�(�q
�GHS��3ѓ�BO�;�� �	).�!� ~�������Z�zr�!Ò�2�,�S[L�m�;�����/��+�M��m�=��48�7�L�z^#�̹�X�Q^ �����&$�l3ru�1��YJ�|�J���5b�99/1�ƶ#�[�&��e���pU6�y�je���PJ'�Ԅ�.���A.�� ���P����-��;��J�-�g\43�`O~���H��0�Ҍ�O�^���7���{�f��E9�]m�}�ӌS(?I���l����-��ވ��&��(�}ƨ2�8����[���Y^`@�tp�ιBV"Wꦻ�Fߒ��Y����)�8w��K���p��ӱ����y,1�cNB�x#�C7��CC9�X��A1���S.?�_�YO'8�N����J�M����YY`@�K+N��K^>m����}�@ԅ@_�!�dH�&,�H�՚�*'�g݋{>��3u6�	�^�7��Z���I�C��0������$k�H{�5�O�v���sA��"����'0�(�`�������\Ek���� �����lu�� ����{���D�`]�������+}�tW�1Jw7�o�Kb���S6M���
�l�ND8�!���t1-�)���o+� 5qG�?˩��2���ښ�Ja�3�ท:�+i/��5�w^��=�X�N-<c7�[�T�����\��(�JT1(��ʟ3<���V	N�s)�6�$�>d�D�͒���~>���)�[�`6QrT���X��7�fh:�%�Ez����nu�6����r	C�rם�&�Ө�b��5�E����JA��P�	<8I9��ͭ{�'~�ױ44С�t���ޔ!#k;���:V��I`�RN[�O�#�*�:�.iZ[�_*H$Ă��B%��i�yak�LD¯��9�5ay���#�6�-�=4bw��Ga�����g���(�^����t����6a�
��S\��Ӵs�Ҳ��4q�X	��hMq���u��E:̊rZ~���4���tsʯlo��L��@C�P���zb!�ȐX���5�ù���)HJr��QrE��i>E^z~.�eZU���Y�y$�4`=�Jڛ��z�h�+!��#�;���GG?�ǆ@�� Gp?�"0�4�0�:+�����_�W���u^���vɁ7ѧ�{s$�9�&���%ԆB�xÖ�7ž�@���c��M<�MW0xG��"zT���_4s\���.��J	�Z�:���&'F��k	���P�L7�@��6��V�dgק�;t�>!ԁym�h����rTe��Gm4�Û��������%��J.a$�G[�OGD���tM��%�8��	��
��c5_؉���p�����5t<k�K:�e��v��hmn׵�ŃS�2���P0��>�N���TQ�} �mO{��{� ��|Tg+�xt�RQ��D�$	Cϖ��kq�~���vٝ)ܿ+O��'%Y�<6����%y�}�r���cQ�v]䷗�RH��F�=����VQ	�^������"�"�/p�7ID��͆
^����<�e�_A��/=�F�Únb��	i�|���CJ=Q<>?�/,�Z2�!�پ��jx=hD�����vn8�E�u�|��{���� a	����	�~3�f���ȅ�̘1Y[+I�!�tY �a��.��E8Qv�^�V��nd惩�m��^j`k;�X�������0PR�71���e��t^ֺCe\�:C�=V��~�eW��Þ0�P��0:D��$]����jIbv5�v��S?��k�]؉��n��(D�Uٳv]({(��bN�"z��0��r��U�Q�� }�Q=�3pԚ0v�F�������yp��"Ģ��uţGE���yn]>_�//�e��~�{���uZ�sK>f�1E�,���(dˍ��_��ݦ\Ɠ�j0�ia�Z�۷�O9.i`� 0܅!��C���lF��B)i&~3�TO�3��>4X_�#R��#Y+��U��e>��g�1*`5����Z���5<w���3"#̈�nZԞQ���$�0���\*��M^!����ȱ:��^�/]?��COl�3������#yh�`���g����l�MM�Q�q~�bRpI.���(�wl~O��=F^�+X���Φ�H�G��зu����2Mjo�A�����D�:���0�}R<����b$���"���5p�����?���]����-$��ys���=���n	}P�NP߉�MA���a_��Vd{����� ��� �jh�T���Ś�I9�Y���e�:�&��:%,档(������Ar.�oP�Z����}0!���q�t��3�p���$�[��n�˯�u������t��=؃?8/��tQb�O{ހ320t�V|^�W�,kx�t��?v�g(w���Q�Vȧ1�B�W֓Yu����y6*��uʔFXPA��H@m���    U�V�ƍ�'��W�r�@4�(�&Gs�o�ۦ�n�\��#�l���/��x��q9��,kz.5��|�ēJo���Sq�	cpf5�q�ȴn_.��I��V�9W�BSc֗q��%�Ib�P)k���r��m��5�-D�}]��qI�ȫRWB �f[6>�G�qNW�ec�w}��,f���o��K��9JO���Л���W�*h����Z��`1�Í��w� �"?�U�J��.N�r�V��v-��0�Iy����[΃��)~�Ez=?&�(��;��Lu��!�Z.5�� �Q ��	
��ӣ���X�IS"P�l}�)׺ �P?5v���w��6�^����࿬PyF�1�������rE���4���XĦ��y�D�d�L� �j�9C��`�� 
����AYۆJ��p����V��F~N��*���~�E���۩f���c^����R|����������񣕍@���Mu��,�������>�^�v5�?���Dw.�n��UY�DD��d�GʐE>�>=���]J	���p[��ƻ���؂�<l-������B��� 	�m��m6(�YJ �%�qA���8=�޼i�}�*+����Z�:d��ش�,��	f]�k��_iD�ֵ����G������5��Pqxb��R�������(E�I��ts��c�'��
"���cM��է�Mg�m�C~yx��=;&0&����t8N����(�O�Cm-��͞��ݪ�
��7������V��zf,0��y���{p�-%��}����7[�T ���d��2�v�HX\z�KD2T-�܈���~�G�"��M��;�0fv�`��\?������b��F�J��̜3$��w&L���6(�|�T	r�;�0
�^�y�/Q�]�c���ҴvZ�='$j���X"ί2�^p�u��� כ|�3�3lg�&��5��u�[��V<�ӣ����{�b͢��u˹Wc<��h�y
����7{�@٠X!�&b\+Ͳ�9�T��%�*�m�(�H��v^��x�_���?�G����n>���H#c$/O��)���]��Mcy1~�	���yj�"�o�^�¸�Km�	�na�����&g��{'�?��io�)�a!���q�F2������fo�\���B��H.B'i�5)��Fv�6�,o��QQ�;��WE%>9��	�����i��� �����I-/�0���t) ���~��J��4t����L1��y߬��t�[��5t}L{A��Jt�Ȍ �'������{��̥@a�S�G��ja��������h�}[Ջz���@y��~��./�r����q�ތ�x){��%���v'�)m縲�
{ R�2���Q���&1wm)�9�!�tr�U@��iy�!�����פђI����-�P2�}�8��f�7���N����#Φ�s�K���V[�V����2=E2F�����3r�M/H���e�M�ِ���j�6�a�	���m�_�d���;�vj��VM�3�fP*v;5��2Z��|�5li�{ײܶ�E����Ѯ
Q�YY�e[+����M
�`
60�##}��2/R3�YF?6��lP�LR�({\q��M4p��}ϩ���Ό�G��������袵��`��\{K֌�PI� �� �6(���v��I^��iڷ^R��n3���kʥδ٩�J�Ӌ����)��\g��[2(r�4p�iL����rKX�E\Č�ˆClB��MUn=Oh��f�1F�l���n�sp73�m���<{���C0+s�!��}�JW�i�� �9M�v����ׯ�����a2)�4hU0g��]���v�x5�~��H'�:����ݤ��Ϻ��#�P�m`a�]�w�/{��`��������00�X{r�Iq�uF�|�Rm�+��Q�v��mJs�Xr� �n$UOҔ��K�"+�V��1�R�U=@��"��$0 O�;]HgQ-���I�[	�'��� w9��^T{6&u)i^��#��S���t�#r�4?��v�l��Š&�i냲�ԣ�9!�I���[��ň�B�+v�b{)~Q�5��+|���b���xq��~�s����?ts�r���x7*��&�Ş�v��M~�X������'1�K�lFf��-I3�,$^�����j ��~�YB�0��$�4[�����)��6Gz�����9cI��,/��8��7E?�,O̬��ԃ�S����Q�������x6+��Tj��pL�8�3�ʽnn�H/������a2�f�g�S�᝛F��MM~��p�|��={�#�u �mV��T� c?� +�tl�o�b����D,4�@��( ��O��0��!��o�	3ɤH��a�����0�K���=3��ވ�V����F�<v0���0!�L����+�0�ׁ]2X��n�.��� ���n�K��6@�˪�gR�C(�iL� �Y��VQ���%���~�S�x�d����K���� � ,��.D.�7��o~:�������FxF�&٫�\���Rh�A�~��CG��d�|�+��Y���*��T�X���Jϧƫ���KX�ګ�X�H�.�H��\�)���������H����	���P=��(+Z�w����h(�-*��}�a�Kռ,;�n���	�	��w����ͫ��.�N8>`��T[�AN|0ʋ�(ͻt~~����;�W�ʺ%g�e�������ʽ��H��938fV!���M�Hvs_n�.o�n��e���Xw�:}�O�Ȭ�n]��G�e�5Ě!i�&z��i��6� �n*3�\���E��T������_�kIO[��#;��y���\4D�CEyt����GY��7�Vw��@�E�S �-�E�������5���]B��&�e��ό�T�� 2��bT��Ծ
��B_x���<xH�Fi�	���$�d�8\0r���(X٘Ix��}�.��	�kuF�w�N��w�\���&���E���#����^N�&�z5�
ir��2������1f��e�ZX���Hl�`S\�^m�Es�X��V�����wmf��)��]ee�N���/I�h�v��e�l�o!4R��x+�%��{��Z�8Mki� �H�,)�3A$��q�LE�Xh-�iT1U2�#�J.}?��E�of��q}v+d#O��yȖ�n7?2�7C_��f����/��z�N��q8X�1����5�]^�3����r��i7�a������0`���@ԭH����~���A�v��F�u� 7{N5ҹ'�P���7�xO{����Mڪ��Q|���sÁA�=a�mY KX-�H��R�ã����S��M��ђ������]��|L��6���__�ur-��� �b��<!/
�s�P��KOr�,�ưA�����c�2A�5�k<���_Z
����פ8 /���-��{od��P��4I[������I��~�ĉ�O����X��<��Q��"X�J��	��<�� }M�GO7�ZV�v���1s:T��Fj����).u�M,;��Q!M�뮏�f�R/���\��^�s�2���ư�P�IQ��T��%C�B}d[g����a�D�67R;^��U���8)��4H>�~�M�6�A߂�o��lh����1��P�맄g���VF��t�pMsX�J��ݤVc!y�`'W�b��L����	�f�#ܶX��c����ZZ���qrZ!V�a^�+7��wb�Z�㩫�1�2�n04;�>d�����,o�����G���;03���Vʑ����I0�j�S�����b�>�J��"����$Q��#������-��ۮC����-8e;ctЪ���M�|F��4G4�Ϝ�����K�BLT��4 t�"x~�m�� }�Q�%��h=�Ո��L��1��a_c��n�W�W�f3��!��y��1��5���m������&؅i3�Ch�c�f��g��+u���	�~�kmd�B�gt�Tj�Ǫ��9��Q[����O �  ��:x�')��j4N���b0_�<:_!�x�g�1Ss�Q}/�Ug���K�;��j�����Ҽ�G�a]��7-�9�2/��pC+%���1R�-i0o_�{ic�\~n�!AC��i�*����&�`[mE`�œpMT���h" i3o�Q5��s����q ؒ�����6�W�k4@V;m�	�O�<�+��I�M3Q&_'�V�!���ط�Ҕ{r'
f�e7\�%�	�=O�},n[]�\}U��$���h��[�7ZO)H,�QOFV]ư��}���U.�!';Vw�����/��mD	ڑ�����6S���:���.Qȭ��-s��V�do0�'��7�o�0��-V�E�'���tK'�6�<���͠�����F��)�int���<�ǽ�D�IV�i�K����`ظzD��>`�`����3	K�@�����s�$��Tu멡Qt���|�x��� 
��w�h��r�"��`�Ȩ�9�gJkFe�y��w�8Hx�����r�:�/��
��ú�|�(���h �����[֑�H<f���2�8`���i$���yV�Ǯ�G�-�t�Xa'X_r��N�t\�NySQ~�Q��� &��2�P�pr��)�I�{M�?�!il�.Q��S��V�9v���z;�ϋ�y>ʮ�Č�����׾��v��=+����F��k4YX2<�q��PGlyI^V�쒀�d�+*L�`���������5�bķ�������ޓOo0��uO��0fa�픺?zX�c�+&��n��q����V"=��8Kʾ)�䈔`�ȑaW�k�iC(`i9�?�b����W�eUJ���[�Q�B��N��lǸ�EG���G���]O�$3*����⁪ԜY��z��)N5�_5�ӷ7�#0
GW6�o��������'�v�����T����!_�܎�DD|���Epwn�2���iͥ�}��ĽH�3��%��Z��Cn�Z�������OE"�Œ�]�\���Y�=y��7U�a���nW��� �k5�S��C���e�Y�:J��MJ�sLx��(�k/�ze����9�0�A�=�N�D��)�t:�2@���� ^Ďg�&�W �4��?E*�K-1
\Q�1��]�E���^���U������v����/��Cٷ|�6�n˼������3�`�T�m*�w��lE�g�? ����0^�4$�8���=�<�,�e���K�b����ftz9���,O��g�@�g��M��O"/�H:���s���������霚+��������5}�s�hI_�d/�[�H�ٯ`�\:q"<!�G���y���`�b[��a�G�� �e$Md�ȅ����I�O���d��S4��]
��$V��>��̍�_ONs�+@�/	׾5��KNm�LAԂ(���v_���0��t<o�wq�˪xO@�X�� �5o�/�]t�95�vxv�����$`��yy}r�5w��7CԄ8���V#��e<ۀl�
��4㻤,mvA'Gc�A���
 �skT`	܌���Ɏ�'�P�K��r�a�B3��j=W�Kg���EWp��4��Zc-6��>��#c^V0�����z4��28̅ξ��\���j��む0/�|#e�,a���	�8�\�3��!���	�(G��iU��i�j�4Z�ƌ��"�2�}P�4�p����Y��.��K�V-o�dvz�C^��^݁e�q>���ik�8      �   X   x���v
Q���W((M��L�+�,ȏO�I,NUs�	uV�0�QPq��tvT״��$J�PS@��sP�ڌv�ô�tsq n1�      �   m   x���v
Q���W((M��L�+�,ȏ/HL�Ws�	uV�0�QPq�rqTpqu��W״��$F��V� WR��������da��_��k�����#H' AoC      �   P   x���v
Q���W((M��L�+�,ȏ/HLϏ/NMIUs�	uV�0�QP�u�u�Q״��$Z�Pc����D# RI"�      �   ]   x���v
Q���W((M��L�+�,ȏ/H-*��KTs�	uV�0�QP2}���5��<��e�����D�>c�>G�OgG�W�V.. �(3      �   H   x���v
Q���W((M��L�+�,ȏ/H-*��K�i�9��
a�>���
�:
@���S�����i��� ;W      �   [   x���v
Q���W((M��L�+�,ȏ/(�OK-�/Rs�	uV�0�QPw��ut�R״��$V��F#�������"[�� ��6�      �   R   x���v
Q���W((M��L�+�,ȏ/�,)��Ws�	uV�0�QPw����uT״��$N�P�3P�������?H' �!�      �   u   x���v
Q���W((M��L�+�,)��/Vs�	uV�0�QPw����u�s�st���s�QpqU�qT�t�T'�D#2?=Q�1'''31/9U�3�$�(/�$3?/1Gh���5 ��)7      �   
   x���         