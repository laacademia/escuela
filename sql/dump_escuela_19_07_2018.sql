PGDMP                         v            escuela    9.4.9    10.1 �   F           0    0    ENCODING    ENCODING     #   SET client_encoding = 'SQL_ASCII';
                       false            G           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            H           1262    976414    escuela    DATABASE     w   CREATE DATABASE escuela WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF8' LC_CTYPE = 'en_US.UTF8';
    DROP DATABASE escuela;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            I           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6                        3079    11905    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            J           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            A           1255    976415    sp_trg_ai_cursadas()    FUNCTION     �  CREATE FUNCTION sp_trg_ai_cursadas() RETURNS trigger
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
       public       postgres    false    6    1            B           1255    976416    sp_trg_ai_cursadas_alumnos()    FUNCTION     �  CREATE FUNCTION sp_trg_ai_cursadas_alumnos() RETURNS trigger
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
       public       postgres    false    1    6            �            1259    976417    alquiler_sede    TABLE     9  CREATE TABLE alquiler_sede (
    id integer NOT NULL,
    id_sede integer NOT NULL,
    fecha date NOT NULL,
    valor_hora numeric(10,2) NOT NULL,
    fecha_alta timestamp without time zone DEFAULT now() NOT NULL,
    hora_desde time without time zone NOT NULL,
    hora_hasta time without time zone NOT NULL
);
 !   DROP TABLE public.alquiler_sede;
       public         postgres    false    6            �            1259    976421    alquiler_sede_cabecera    TABLE     G  CREATE TABLE alquiler_sede_cabecera (
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
       public         postgres    false    6            �            1259    976426    alquiler_sede_cabecera_id_seq    SEQUENCE        CREATE SEQUENCE alquiler_sede_cabecera_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.alquiler_sede_cabecera_id_seq;
       public       postgres    false    6    174            K           0    0    alquiler_sede_cabecera_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE alquiler_sede_cabecera_id_seq OWNED BY alquiler_sede_cabecera.id;
            public       postgres    false    175            �            1259    976428    alquiler_sede_detalle    TABLE     v  CREATE TABLE alquiler_sede_detalle (
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
       public         postgres    false    6            �            1259    976432    alquiler_sede_detalle_id_seq    SEQUENCE     ~   CREATE SEQUENCE alquiler_sede_detalle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.alquiler_sede_detalle_id_seq;
       public       postgres    false    6    176            L           0    0    alquiler_sede_detalle_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE alquiler_sede_detalle_id_seq OWNED BY alquiler_sede_detalle.id;
            public       postgres    false    177            �            1259    976434    alquiler_sede_id_seq    SEQUENCE     v   CREATE SEQUENCE alquiler_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.alquiler_sede_id_seq;
       public       postgres    false    6    173            M           0    0    alquiler_sede_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE alquiler_sede_id_seq OWNED BY alquiler_sede.id;
            public       postgres    false    178            �            1259    976436    personas    TABLE     N  CREATE TABLE personas (
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
       public         postgres    false    6            �            1259    976440    alumnos_id_seq    SEQUENCE     p   CREATE SEQUENCE alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.alumnos_id_seq;
       public       postgres    false    6    179            N           0    0    alumnos_id_seq    SEQUENCE OWNED BY     4   ALTER SEQUENCE alumnos_id_seq OWNED BY personas.id;
            public       postgres    false    180            �            1259    976442    alumnos_legajo_seq    SEQUENCE     t   CREATE SEQUENCE alumnos_legajo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.alumnos_legajo_seq;
       public       postgres    false    6    179            O           0    0    alumnos_legajo_seq    SEQUENCE OWNED BY     <   ALTER SEQUENCE alumnos_legajo_seq OWNED BY personas.legajo;
            public       postgres    false    181            �            1259    976444    aulas    TABLE     �   CREATE TABLE aulas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    piso integer,
    nombre character varying(60) NOT NULL,
    id_sede integer NOT NULL
);
    DROP TABLE public.aulas;
       public         postgres    false    6            �            1259    976447    aulas_id_seq    SEQUENCE     n   CREATE SEQUENCE aulas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.aulas_id_seq;
       public       postgres    false    6    182            P           0    0    aulas_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE aulas_id_seq OWNED BY aulas.id;
            public       postgres    false    183                       1259    977207    caja_comprobantes    TABLE       CREATE TABLE caja_comprobantes (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL,
    id_tipo_comprobante integer,
    activo boolean DEFAULT true,
    dias_vencimiento integer DEFAULT 0,
    es_cancelatorio boolean DEFAULT false NOT NULL,
    orden integer
);
 %   DROP TABLE public.caja_comprobantes;
       public         postgres    false    6                       1259    977205    caja_comprobantes_id_seq    SEQUENCE     z   CREATE SEQUENCE caja_comprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.caja_comprobantes_id_seq;
       public       postgres    false    6    286            Q           0    0    caja_comprobantes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE caja_comprobantes_id_seq OWNED BY caja_comprobantes.id;
            public       postgres    false    285            *           1259    977274    caja_cuentas    TABLE     �   CREATE TABLE caja_cuentas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    activo boolean NOT NULL
);
     DROP TABLE public.caja_cuentas;
       public         postgres    false    6            )           1259    977272    caja_cuentas_id_seq    SEQUENCE     u   CREATE SEQUENCE caja_cuentas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.caja_cuentas_id_seq;
       public       postgres    false    298    6            R           0    0    caja_cuentas_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE caja_cuentas_id_seq OWNED BY caja_cuentas.id;
            public       postgres    false    297            "           1259    977230    caja_medios_pagos    TABLE     l   CREATE TABLE caja_medios_pagos (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL
);
 %   DROP TABLE public.caja_medios_pagos;
       public         postgres    false    6            !           1259    977228    caja_mediospagos_id_seq    SEQUENCE     y   CREATE SEQUENCE caja_mediospagos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_mediospagos_id_seq;
       public       postgres    false    290    6            S           0    0    caja_mediospagos_id_seq    SEQUENCE OWNED BY     F   ALTER SEQUENCE caja_mediospagos_id_seq OWNED BY caja_medios_pagos.id;
            public       postgres    false    289            (           1259    977261    caja_movimientos    TABLE     �   CREATE TABLE caja_movimientos (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_operacion integer NOT NULL,
    activo boolean NOT NULL
);
 $   DROP TABLE public.caja_movimientos;
       public         postgres    false    6            '           1259    977259    caja_movimientos_id_seq    SEQUENCE     y   CREATE SEQUENCE caja_movimientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_movimientos_id_seq;
       public       postgres    false    296    6            T           0    0    caja_movimientos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE caja_movimientos_id_seq OWNED BY caja_movimientos.id;
            public       postgres    false    295            &           1259    977248    caja_operaciones    TABLE     �   CREATE TABLE caja_operaciones (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_tipo_operacion integer NOT NULL,
    activo boolean NOT NULL
);
 $   DROP TABLE public.caja_operaciones;
       public         postgres    false    6            .           1259    977297    caja_operaciones_diarias    TABLE     �  CREATE TABLE caja_operaciones_diarias (
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
    fecha_operacion timestamp with time zone DEFAULT now()
);
 ,   DROP TABLE public.caja_operaciones_diarias;
       public         postgres    false    6            -           1259    977295    caja_operaciones_diarias_id_seq    SEQUENCE     �   CREATE SEQUENCE caja_operaciones_diarias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.caja_operaciones_diarias_id_seq;
       public       postgres    false    302    6            U           0    0    caja_operaciones_diarias_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE caja_operaciones_diarias_id_seq OWNED BY caja_operaciones_diarias.id;
            public       postgres    false    301            %           1259    977246    caja_operaciones_id_seq    SEQUENCE     y   CREATE SEQUENCE caja_operaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.caja_operaciones_id_seq;
       public       postgres    false    6    294            V           0    0    caja_operaciones_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE caja_operaciones_id_seq OWNED BY caja_operaciones.id;
            public       postgres    false    293            4           1259    977363    caja_parametrizacion    TABLE     v  CREATE TABLE caja_parametrizacion (
    id integer NOT NULL,
    id_comprobante integer NOT NULL,
    id_mediopago integer NOT NULL,
    id_movimiento integer NOT NULL,
    id_cuenta integer NOT NULL,
    id_subcuenta integer NOT NULL,
    id_tipotitular integer NOT NULL,
    signo integer NOT NULL,
    impacta_original boolean,
    envia_sub_cta boolean DEFAULT false
);
 (   DROP TABLE public.caja_parametrizacion;
       public         postgres    false    6            3           1259    977361    caja_parametrizacion_id_seq    SEQUENCE     }   CREATE SEQUENCE caja_parametrizacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.caja_parametrizacion_id_seq;
       public       postgres    false    6    308            W           0    0    caja_parametrizacion_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE caja_parametrizacion_id_seq OWNED BY caja_parametrizacion.id;
            public       postgres    false    307            ,           1259    977284    caja_subcuentas    TABLE     �   CREATE TABLE caja_subcuentas (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    id_cuenta integer NOT NULL,
    activo boolean NOT NULL
);
 #   DROP TABLE public.caja_subcuentas;
       public         postgres    false    6            +           1259    977282    caja_subcuentas_id_seq    SEQUENCE     x   CREATE SEQUENCE caja_subcuentas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.caja_subcuentas_id_seq;
       public       postgres    false    6    300            X           0    0    caja_subcuentas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE caja_subcuentas_id_seq OWNED BY caja_subcuentas.id;
            public       postgres    false    299                       1259    977199    caja_tipo_comprobantes    TABLE     q   CREATE TABLE caja_tipo_comprobantes (
    id integer NOT NULL,
    descripcion character varying(30) NOT NULL
);
 *   DROP TABLE public.caja_tipo_comprobantes;
       public         postgres    false    6                       1259    977197    caja_tipo_comprobantes_id_seq    SEQUENCE        CREATE SEQUENCE caja_tipo_comprobantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.caja_tipo_comprobantes_id_seq;
       public       postgres    false    6    284            Y           0    0    caja_tipo_comprobantes_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE caja_tipo_comprobantes_id_seq OWNED BY caja_tipo_comprobantes.id;
            public       postgres    false    283            $           1259    977238    caja_tipo_operaciones    TABLE     �   CREATE TABLE caja_tipo_operaciones (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    activo boolean NOT NULL
);
 )   DROP TABLE public.caja_tipo_operaciones;
       public         postgres    false    6            #           1259    977236    caja_tipo_operaciones_id_seq    SEQUENCE     ~   CREATE SEQUENCE caja_tipo_operaciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.caja_tipo_operaciones_id_seq;
       public       postgres    false    6    292            Z           0    0    caja_tipo_operaciones_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE caja_tipo_operaciones_id_seq OWNED BY caja_tipo_operaciones.id;
            public       postgres    false    291                        1259    977222    caja_tipo_titulares    TABLE     �   CREATE TABLE caja_tipo_titulares (
    id integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    campo character varying(20),
    activo boolean NOT NULL
);
 '   DROP TABLE public.caja_tipo_titulares;
       public         postgres    false    6                       1259    977220    caja_tipo_titulares_id_seq    SEQUENCE     |   CREATE SEQUENCE caja_tipo_titulares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.caja_tipo_titulares_id_seq;
       public       postgres    false    6    288            [           0    0    caja_tipo_titulares_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE caja_tipo_titulares_id_seq OWNED BY caja_tipo_titulares.id;
            public       postgres    false    287            �            1259    976449    ciudades    TABLE     �   CREATE TABLE ciudades (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    cp integer NOT NULL,
    id_provincia integer NOT NULL
);
    DROP TABLE public.ciudades;
       public         postgres    false    6            �            1259    976452    ciudades_id_seq    SEQUENCE     q   CREATE SEQUENCE ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.ciudades_id_seq;
       public       postgres    false    6    184            \           0    0    ciudades_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE ciudades_id_seq OWNED BY ciudades.id;
            public       postgres    false    185            �            1259    976454    clases    TABLE     O  CREATE TABLE clases (
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
       public         postgres    false    6            �            1259    976460    clases_asistencia    TABLE     |   CREATE TABLE clases_asistencia (
    id integer NOT NULL,
    id_persona integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_asistencia;
       public         postgres    false    6            �            1259    976463    clases_id_seq    SEQUENCE     o   CREATE SEQUENCE clases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.clases_id_seq;
       public       postgres    false    6    186            ]           0    0    clases_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE clases_id_seq OWNED BY clases.id;
            public       postgres    false    188            �            1259    976465    clases_profesores    TABLE     }   CREATE TABLE clases_profesores (
    id integer NOT NULL,
    id_profesor integer NOT NULL,
    id_clase integer NOT NULL
);
 %   DROP TABLE public.clases_profesores;
       public         postgres    false    6            �            1259    976468    clases_profesores_id_seq    SEQUENCE     z   CREATE SEQUENCE clases_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.clases_profesores_id_seq;
       public       postgres    false    6    189            ^           0    0    clases_profesores_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE clases_profesores_id_seq OWNED BY clases_profesores.id;
            public       postgres    false    190            �            1259    976470    condiciones_alumno    TABLE     m   CREATE TABLE condiciones_alumno (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 &   DROP TABLE public.condiciones_alumno;
       public         postgres    false    6            �            1259    976473    condiciones_alumno_id_seq    SEQUENCE     {   CREATE SEQUENCE condiciones_alumno_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.condiciones_alumno_id_seq;
       public       postgres    false    6    191            _           0    0    condiciones_alumno_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE condiciones_alumno_id_seq OWNED BY condiciones_alumno.id;
            public       postgres    false    192            �            1259    976475    cursadas    TABLE     �   CREATE TABLE cursadas (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    id_curso integer NOT NULL,
    id_sede integer,
    anio integer
);
    DROP TABLE public.cursadas;
       public         postgres    false    6            �            1259    976478    cursadas_alumnos    TABLE     Z  CREATE TABLE cursadas_alumnos (
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
       public         postgres    false    6            �            1259    976484    cursadas_alumnos_id_seq    SEQUENCE     y   CREATE SEQUENCE cursadas_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_alumnos_id_seq;
       public       postgres    false    6    194            `           0    0    cursadas_alumnos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE cursadas_alumnos_id_seq OWNED BY cursadas_alumnos.id;
            public       postgres    false    195            �            1259    976486    cursadas_cuotas    TABLE     �   CREATE TABLE cursadas_cuotas (
    id integer NOT NULL,
    importe numeric(10,2) NOT NULL,
    fecha_operacion timestamp without time zone DEFAULT now() NOT NULL,
    id_cursadas_modulos integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL
);
 #   DROP TABLE public.cursadas_cuotas;
       public         postgres    false    6            �            1259    976490    cursadas_cuotas_id_seq    SEQUENCE     x   CREATE SEQUENCE cursadas_cuotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cursadas_cuotas_id_seq;
       public       postgres    false    6    196            a           0    0    cursadas_cuotas_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE cursadas_cuotas_id_seq OWNED BY cursadas_cuotas.id;
            public       postgres    false    197            �            1259    976492    cursadas_id_seq    SEQUENCE     q   CREATE SEQUENCE cursadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.cursadas_id_seq;
       public       postgres    false    6    193            b           0    0    cursadas_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE cursadas_id_seq OWNED BY cursadas.id;
            public       postgres    false    198            �            1259    976494    cursadas_modulos    TABLE     [  CREATE TABLE cursadas_modulos (
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
       public         postgres    false    6            �            1259    976500    cursadas_modulos_alumnos    TABLE     �   CREATE TABLE cursadas_modulos_alumnos (
    id integer NOT NULL,
    id_modulo integer NOT NULL,
    id_cursadas_alumnos integer NOT NULL,
    orden integer
);
 ,   DROP TABLE public.cursadas_modulos_alumnos;
       public         postgres    false    6            �            1259    976503    cursadas_modulos_alumnos_id_seq    SEQUENCE     �   CREATE SEQUENCE cursadas_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.cursadas_modulos_alumnos_id_seq;
       public       postgres    false    6    200            c           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE cursadas_modulos_alumnos_id_seq OWNED BY cursadas_modulos_alumnos.id;
            public       postgres    false    201            �            1259    976505    cursadas_modulos_id_seq    SEQUENCE     y   CREATE SEQUENCE cursadas_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.cursadas_modulos_id_seq;
       public       postgres    false    6    199            d           0    0    cursadas_modulos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE cursadas_modulos_id_seq OWNED BY cursadas_modulos.id;
            public       postgres    false    202            �            1259    976507    cursadas_profesores    TABLE     �   CREATE TABLE cursadas_profesores (
    id integer NOT NULL,
    id_cursada integer NOT NULL,
    id_profesor integer NOT NULL,
    id_tipo_profesor integer NOT NULL
);
 '   DROP TABLE public.cursadas_profesores;
       public         postgres    false    6            �            1259    976510    cursadas_profesores_id_seq    SEQUENCE     |   CREATE SEQUENCE cursadas_profesores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.cursadas_profesores_id_seq;
       public       postgres    false    6    203            e           0    0    cursadas_profesores_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE cursadas_profesores_id_seq OWNED BY cursadas_profesores.id;
            public       postgres    false    204            �            1259    976512    cursos    TABLE     h  CREATE TABLE cursos (
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
       public         postgres    false    6            f           0    0 $   COLUMN cursos.porcentaje_correlativa    COMMENT     �   COMMENT ON COLUMN cursos.porcentaje_correlativa IS 'porcentaje necesario para poder cursar los siguientes cursos que son correlativos';
            public       postgres    false    205            g           0    0 "   COLUMN cursos.certificado_incluido    COMMENT     e   COMMENT ON COLUMN cursos.certificado_incluido IS 'Si el certificado esta incluido o se paga aparte';
            public       postgres    false    205            �            1259    976517    cursos_correlatividad    TABLE     �   CREATE TABLE cursos_correlatividad (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_curso_previo integer NOT NULL
);
 )   DROP TABLE public.cursos_correlatividad;
       public         postgres    false    6            �            1259    976520    cursos_correlatividad_id_seq    SEQUENCE     ~   CREATE SEQUENCE cursos_correlatividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.cursos_correlatividad_id_seq;
       public       postgres    false    6    206            h           0    0    cursos_correlatividad_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE cursos_correlatividad_id_seq OWNED BY cursos_correlatividad.id;
            public       postgres    false    207            �            1259    976522    cursos_id_seq    SEQUENCE     o   CREATE SEQUENCE cursos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.cursos_id_seq;
       public       postgres    false    205    6            i           0    0    cursos_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE cursos_id_seq OWNED BY cursos.id;
            public       postgres    false    208            �            1259    976524    cursos_modulos    TABLE       CREATE TABLE cursos_modulos (
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
       public         postgres    false    6            �            1259    976530    cursos_modulos_alumnos    TABLE     �   CREATE TABLE cursos_modulos_alumnos (
    id integer NOT NULL,
    id_curso integer NOT NULL,
    id_alumno integer NOT NULL,
    mes integer NOT NULL,
    anio integer NOT NULL,
    orden integer NOT NULL,
    id_estado_pago integer
);
 *   DROP TABLE public.cursos_modulos_alumnos;
       public         postgres    false    6            �            1259    976533    cursos_modulos_alumnos_id_seq    SEQUENCE        CREATE SEQUENCE cursos_modulos_alumnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.cursos_modulos_alumnos_id_seq;
       public       postgres    false    6    210            j           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE cursos_modulos_alumnos_id_seq OWNED BY cursos_modulos_alumnos.id;
            public       postgres    false    211            �            1259    976535    cursos_modulos_id_seq    SEQUENCE     w   CREATE SEQUENCE cursos_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cursos_modulos_id_seq;
       public       postgres    false    6    209            k           0    0    cursos_modulos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE cursos_modulos_id_seq OWNED BY cursos_modulos.id;
            public       postgres    false    212            �            1259    976537    cursos_titulos    TABLE     x   CREATE TABLE cursos_titulos (
    id integer NOT NULL,
    id_titulo integer NOT NULL,
    id_curso integer NOT NULL
);
 "   DROP TABLE public.cursos_titulos;
       public         postgres    false    6            �            1259    976540    cursos_titulos_id_seq    SEQUENCE     w   CREATE SEQUENCE cursos_titulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cursos_titulos_id_seq;
       public       postgres    false    213    6            l           0    0    cursos_titulos_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE cursos_titulos_id_seq OWNED BY cursos_titulos.id;
            public       postgres    false    214            �            1259    976542    databasechangeloglock    TABLE     �   CREATE TABLE databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);
 )   DROP TABLE public.databasechangeloglock;
       public         postgres    false    6            �            1259    976545    datos_academicos    TABLE     C  CREATE TABLE datos_academicos (
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
       public         postgres    false    6            �            1259    976548    datos_academicos_id_seq    SEQUENCE     y   CREATE SEQUENCE datos_academicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.datos_academicos_id_seq;
       public       postgres    false    216    6            m           0    0    datos_academicos_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE datos_academicos_id_seq OWNED BY datos_academicos.id;
            public       postgres    false    217            �            1259    976550    datos_actuales    TABLE     �  CREATE TABLE datos_actuales (
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
       public         postgres    false    6            �            1259    976556    datos_actuales_id_seq    SEQUENCE     w   CREATE SEQUENCE datos_actuales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.datos_actuales_id_seq;
       public       postgres    false    6    218            n           0    0    datos_actuales_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE datos_actuales_id_seq OWNED BY datos_actuales.id;
            public       postgres    false    219            �            1259    976558    datos_laborales    TABLE     K  CREATE TABLE datos_laborales (
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
       public         postgres    false    6            �            1259    976564    datos_laborales_id_seq    SEQUENCE     x   CREATE SEQUENCE datos_laborales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.datos_laborales_id_seq;
       public       postgres    false    220    6            o           0    0    datos_laborales_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE datos_laborales_id_seq OWNED BY datos_laborales.id;
            public       postgres    false    221            �            1259    976566    datos_salud    TABLE       CREATE TABLE datos_salud (
    id integer NOT NULL,
    cobertura_medica character varying(100),
    apto_curso boolean,
    observaciones_medicas character varying(255),
    certificado_medico boolean,
    id_persona integer NOT NULL,
    id_grupo_sanguineo integer
);
    DROP TABLE public.datos_salud;
       public         postgres    false    6            �            1259    976569    datos_salud_id_seq    SEQUENCE     t   CREATE SEQUENCE datos_salud_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.datos_salud_id_seq;
       public       postgres    false    6    222            p           0    0    datos_salud_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE datos_salud_id_seq OWNED BY datos_salud.id;
            public       postgres    false    223            �            1259    976571    estados_pago    TABLE     h   CREATE TABLE estados_pago (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
     DROP TABLE public.estados_pago;
       public         postgres    false    6            �            1259    976574    estados_pago_id_seq    SEQUENCE     u   CREATE SEQUENCE estados_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.estados_pago_id_seq;
       public       postgres    false    6    224            q           0    0    estados_pago_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE estados_pago_id_seq OWNED BY estados_pago.id;
            public       postgres    false    225            �            1259    976576    grupos_sanguineos    TABLE     m   CREATE TABLE grupos_sanguineos (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 %   DROP TABLE public.grupos_sanguineos;
       public         postgres    false    6            �            1259    976579    grupos_sanguineos_id_seq    SEQUENCE     z   CREATE SEQUENCE grupos_sanguineos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.grupos_sanguineos_id_seq;
       public       postgres    false    6    226            r           0    0    grupos_sanguineos_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE grupos_sanguineos_id_seq OWNED BY grupos_sanguineos.id;
            public       postgres    false    227            �            1259    976581    ids    TABLE     %   CREATE TABLE ids (
    id integer
);
    DROP TABLE public.ids;
       public         postgres    false    6            �            1259    976584    inscripciones_modulos    TABLE     �   CREATE TABLE inscripciones_modulos (
    id integer NOT NULL,
    id_inscripcion integer NOT NULL,
    mes_modulo integer NOT NULL,
    anio_modulo integer NOT NULL,
    id_estado_pago integer
);
 )   DROP TABLE public.inscripciones_modulos;
       public         postgres    false    6            �            1259    976587    inscripciones_modulos_id_seq    SEQUENCE     ~   CREATE SEQUENCE inscripciones_modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.inscripciones_modulos_id_seq;
       public       postgres    false    6    229            s           0    0    inscripciones_modulos_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE inscripciones_modulos_id_seq OWNED BY inscripciones_modulos.id;
            public       postgres    false    230            �            1259    976589    modulos    TABLE     �   CREATE TABLE modulos (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    numero integer NOT NULL,
    id_curso integer NOT NULL,
    porcentaje_presencia numeric(10,2) DEFAULT 100 NOT NULL
);
    DROP TABLE public.modulos;
       public         postgres    false    6            �            1259    976593    modulos_id_seq    SEQUENCE     p   CREATE SEQUENCE modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.modulos_id_seq;
       public       postgres    false    231    6            t           0    0    modulos_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE modulos_id_seq OWNED BY modulos.id;
            public       postgres    false    232            �            1259    976595    niveles_estudios    TABLE     l   CREATE TABLE niveles_estudios (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 $   DROP TABLE public.niveles_estudios;
       public         postgres    false    6            �            1259    976598    niveles_estudios_id_seq    SEQUENCE     y   CREATE SEQUENCE niveles_estudios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.niveles_estudios_id_seq;
       public       postgres    false    6    233            u           0    0    niveles_estudios_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE niveles_estudios_id_seq OWNED BY niveles_estudios.id;
            public       postgres    false    234            �            1259    976600    paises    TABLE     �   CREATE TABLE paises (
    id integer NOT NULL,
    nombre character varying(60) NOT NULL,
    nacionalidad character varying(60) NOT NULL
);
    DROP TABLE public.paises;
       public         postgres    false    6            �            1259    976603    paises_id_seq    SEQUENCE     o   CREATE SEQUENCE paises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.paises_id_seq;
       public       postgres    false    235    6            v           0    0    paises_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE paises_id_seq OWNED BY paises.id;
            public       postgres    false    236            �            1259    976605    perfiles    TABLE     E   CREATE TABLE perfiles (
    perfil character varying(60) NOT NULL
);
    DROP TABLE public.perfiles;
       public         postgres    false    6            �            1259    976608    profesiones    TABLE     ^   CREATE TABLE profesiones (
    id integer NOT NULL,
    descripcion character varying(255)
);
    DROP TABLE public.profesiones;
       public         postgres    false    6            �            1259    976611    profesiones_id_seq    SEQUENCE     t   CREATE SEQUENCE profesiones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.profesiones_id_seq;
       public       postgres    false    6    238            w           0    0    profesiones_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE profesiones_id_seq OWNED BY profesiones.id;
            public       postgres    false    239            �            1259    976613 
   provincias    TABLE     z   CREATE TABLE provincias (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    id_pais integer NOT NULL
);
    DROP TABLE public.provincias;
       public         postgres    false    6            �            1259    976619    provincias_id_seq    SEQUENCE     s   CREATE SEQUENCE provincias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.provincias_id_seq;
       public       postgres    false    6    240            x           0    0    provincias_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE provincias_id_seq OWNED BY provincias.id;
            public       postgres    false    241            �            1259    976621    sedes    TABLE       CREATE TABLE sedes (
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
       public         postgres    false    6            �            1259    976628    sedes_formadores    TABLE     {   CREATE TABLE sedes_formadores (
    id integer NOT NULL,
    id_formador integer NOT NULL,
    id_sede integer NOT NULL
);
 $   DROP TABLE public.sedes_formadores;
       public         postgres    false    6            �            1259    976631    sedes_formadores_id_seq    SEQUENCE     y   CREATE SEQUENCE sedes_formadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sedes_formadores_id_seq;
       public       postgres    false    243    6            y           0    0    sedes_formadores_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE sedes_formadores_id_seq OWNED BY sedes_formadores.id;
            public       postgres    false    244            �            1259    976633    sedes_id_seq    SEQUENCE     n   CREATE SEQUENCE sedes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sedes_id_seq;
       public       postgres    false    6    242            z           0    0    sedes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE sedes_id_seq OWNED BY sedes.id;
            public       postgres    false    245            �            1259    976635    temp_ciudades    TABLE     u   CREATE TABLE temp_ciudades (
    id integer NOT NULL,
    ciudad character varying(200),
    id_localidad integer
);
 !   DROP TABLE public.temp_ciudades;
       public         postgres    false    6            �            1259    976638    temp_ciudades_id_seq    SEQUENCE     v   CREATE SEQUENCE temp_ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_ciudades_id_seq;
       public       postgres    false    6    246            {           0    0    temp_ciudades_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE temp_ciudades_id_seq OWNED BY temp_ciudades.id;
            public       postgres    false    247            �            1259    976640    temp_personas    TABLE     I  CREATE TABLE temp_personas (
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
       public         postgres    false    6            �            1259    976646    temp_personas2    TABLE     1  CREATE TABLE temp_personas2 (
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
       public         postgres    false    6            �            1259    976652    temp_personas_id_seq    SEQUENCE     v   CREATE SEQUENCE temp_personas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.temp_personas_id_seq;
       public       postgres    false    6    248            |           0    0    temp_personas_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE temp_personas_id_seq OWNED BY temp_personas.id;
            public       postgres    false    250            �            1259    976654 
   tipo_clase    TABLE     e   CREATE TABLE tipo_clase (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_clase;
       public         postgres    false    6            �            1259    976657    tipo_clase_id_seq    SEQUENCE     s   CREATE SEQUENCE tipo_clase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.tipo_clase_id_seq;
       public       postgres    false    6    251            }           0    0    tipo_clase_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE tipo_clase_id_seq OWNED BY tipo_clase.id;
            public       postgres    false    252            �            1259    976659 	   tipo_pago    TABLE     d   CREATE TABLE tipo_pago (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_pago;
       public         postgres    false    6            �            1259    976662    tipo_pago_id_seq    SEQUENCE     r   CREATE SEQUENCE tipo_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tipo_pago_id_seq;
       public       postgres    false    6    253            ~           0    0    tipo_pago_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE tipo_pago_id_seq OWNED BY tipo_pago.id;
            public       postgres    false    254            �            1259    976664    tipo_pago_sede    TABLE     j   CREATE TABLE tipo_pago_sede (
    id integer NOT NULL,
    descripcion character varying(255) NOT NULL
);
 "   DROP TABLE public.tipo_pago_sede;
       public         postgres    false    6                        1259    976667    tipo_pago_sede_id_seq    SEQUENCE     w   CREATE SEQUENCE tipo_pago_sede_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tipo_pago_sede_id_seq;
       public       postgres    false    6    255                       0    0    tipo_pago_sede_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE tipo_pago_sede_id_seq OWNED BY tipo_pago_sede.id;
            public       postgres    false    256                       1259    976669    tipo_persona    TABLE     g   CREATE TABLE tipo_persona (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
     DROP TABLE public.tipo_persona;
       public         postgres    false    6                       1259    976672    tipo_persona_id_seq    SEQUENCE     u   CREATE SEQUENCE tipo_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.tipo_persona_id_seq;
       public       postgres    false    6    257            �           0    0    tipo_persona_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE tipo_persona_id_seq OWNED BY tipo_persona.id;
            public       postgres    false    258                       1259    976674    tipo_persona_perfiles    TABLE     �   CREATE TABLE tipo_persona_perfiles (
    id integer NOT NULL,
    id_tipo_persona integer NOT NULL,
    perfil character varying(60)
);
 )   DROP TABLE public.tipo_persona_perfiles;
       public         postgres    false    6            �           0    0    TABLE tipo_persona_perfiles    COMMENT     Z   COMMENT ON TABLE tipo_persona_perfiles IS 'Perfiles a asignar cuando se crea un usuario';
            public       postgres    false    259                       1259    976677    tipo_persona_perfiles_id_seq    SEQUENCE     ~   CREATE SEQUENCE tipo_persona_perfiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tipo_persona_perfiles_id_seq;
       public       postgres    false    6    259            �           0    0    tipo_persona_perfiles_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE tipo_persona_perfiles_id_seq OWNED BY tipo_persona_perfiles.id;
            public       postgres    false    260                       1259    976679    tipo_profesor    TABLE     h   CREATE TABLE tipo_profesor (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
 !   DROP TABLE public.tipo_profesor;
       public         postgres    false    6                       1259    976682    tipo_profesor_id_seq    SEQUENCE     v   CREATE SEQUENCE tipo_profesor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tipo_profesor_id_seq;
       public       postgres    false    261    6            �           0    0    tipo_profesor_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE tipo_profesor_id_seq OWNED BY tipo_profesor.id;
            public       postgres    false    262                       1259    976684    tipo_titulo    TABLE     f   CREATE TABLE tipo_titulo (
    id integer NOT NULL,
    descripcion character varying(60) NOT NULL
);
    DROP TABLE public.tipo_titulo;
       public         postgres    false    6                       1259    976687    tipo_titulo_id_seq    SEQUENCE     t   CREATE SEQUENCE tipo_titulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.tipo_titulo_id_seq;
       public       postgres    false    6    263            �           0    0    tipo_titulo_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE tipo_titulo_id_seq OWNED BY tipo_titulo.id;
            public       postgres    false    264            	           1259    976689    titulos    TABLE     �   CREATE TABLE titulos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(500) NOT NULL,
    id_tipo_titulo integer NOT NULL
);
    DROP TABLE public.titulos;
       public         postgres    false    6            
           1259    976695    titulos_id_seq    SEQUENCE     p   CREATE SEQUENCE titulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.titulos_id_seq;
       public       postgres    false    265    6            �           0    0    titulos_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE titulos_id_seq OWNED BY titulos.id;
            public       postgres    false    266                       1259    976697    usuario_persona    TABLE     �   CREATE TABLE usuario_persona (
    id integer NOT NULL,
    usuario character varying(60) NOT NULL,
    id_persona integer NOT NULL
);
 #   DROP TABLE public.usuario_persona;
       public         postgres    false    6                       1259    976700    usuario_persona_id_seq    SEQUENCE     x   CREATE SEQUENCE usuario_persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_persona_id_seq;
       public       postgres    false    267    6            �           0    0    usuario_persona_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE usuario_persona_id_seq OWNED BY usuario_persona.id;
            public       postgres    false    268                       1259    976702    v_sedes    VIEW     �  CREATE VIEW v_sedes AS
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
       public       postgres    false    242    242    242    242    242    242    242    240    242    242    242    242    235    235    184    242    242    240    240    184    184    6                       1259    976707    v_alquiler_cabecera    VIEW     �  CREATE VIEW v_alquiler_cabecera AS
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
       public       postgres    false    174    174    174    174    174    174    269    269    269    269    269    269    224    224    174    174    6                       1259    976712    v_aulas    VIEW     �  CREATE VIEW v_aulas AS
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
       public       postgres    false    269    269    269    269    269    269    269    269    269    269    269    269    269    269    182    182    269    182    182    182    6            /           1259    977334    v_caja_comprobantes    VIEW     @  CREATE VIEW v_caja_comprobantes AS
 SELECT c.id,
    c.descripcion,
    c.id_tipo_comprobante,
    c.activo,
    c.dias_vencimiento,
    c.es_cancelatorio,
    c.orden,
    ctc.descripcion AS tipo_comprobante
   FROM (caja_comprobantes c
     LEFT JOIN caja_tipo_comprobantes ctc ON ((ctc.id = c.id_tipo_comprobante)));
 &   DROP VIEW public.v_caja_comprobantes;
       public       postgres    false    286    286    286    286    286    284    284    286    286    6            0           1259    977339    v_caja_operaciones    VIEW     $  CREATE VIEW v_caja_operaciones AS
 SELECT o.id,
    o.descripcion,
    o.id_tipo_operacion,
    o.activo,
    cto.descripcion AS tipo_operacion,
    cto.activo AS tipo_operacion_activo
   FROM (caja_operaciones o
     LEFT JOIN caja_tipo_operaciones cto ON ((cto.id = o.id_tipo_operacion)));
 %   DROP VIEW public.v_caja_operaciones;
       public       postgres    false    294    294    292    292    292    294    294    6            1           1259    977343    v_caja_movimientos    VIEW     Q  CREATE VIEW v_caja_movimientos AS
 SELECT m.id,
    m.descripcion,
    m.id_operacion,
    m.activo,
    o.descripcion AS operacion,
    o.id_tipo_operacion,
    o.tipo_operacion,
    o.activo AS operacion_activo,
    o.tipo_operacion_activo
   FROM (caja_movimientos m
     LEFT JOIN v_caja_operaciones o ON ((o.id = m.id_operacion)));
 %   DROP VIEW public.v_caja_movimientos;
       public       postgres    false    304    296    296    296    296    304    304    304    304    304    6            2           1259    977347    v_caja_operaciones_diarias    VIEW     i  CREATE VIEW v_caja_operaciones_diarias AS
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
   FROM ((((((caja_operaciones_diarias cod
     LEFT JOIN v_caja_movimientos m ON ((m.id = cod.id_movimiento)))
     LEFT JOIN sedes s ON ((s.id = cod.id_sede)))
     LEFT JOIN caja_medios_pagos mp ON ((mp.id = cod.id_medio_pago)))
     LEFT JOIN caja_cuentas c ON ((c.id = cod.id_cuenta)))
     LEFT JOIN caja_subcuentas sc ON ((sc.id = cod.id_subcuenta)))
     LEFT JOIN caja_tipo_titulares tt ON ((tt.id = cod.id_tipo_titular)));
 -   DROP VIEW public.v_caja_operaciones_diarias;
       public       postgres    false    288    305    305    305    290    290    302    302    242    242    242    288    302    302    302    305    305    302    302    305    298    300    300    302    302    302    305    305    298    302    302    302    302    6                       1259    976717 
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
       public       postgres    false    184    184    235    184    235    240    240    184    240    6                       1259    977164    v_clases    VIEW     F  CREATE VIEW v_clases AS
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
   FROM (((((clases c
     LEFT JOIN cursadas cu ON ((cu.id = c.id_cursada)))
     LEFT JOIN cursadas_modulos cm ON ((cm.id = c.id_modulo)))
     LEFT JOIN cursos ON ((cursos.id = cu.id_curso)))
     LEFT JOIN aulas au ON ((au.id = c.id_aula)))
     LEFT JOIN tipo_clase tc ON ((tc.id = c.id_tipo_clase)));
    DROP VIEW public.v_clases;
       public       postgres    false    186    182    186    186    186    186    186    186    186    186    193    193    193    193    193    199    199    199    199    199    205    205    205    205    205    205    205    205    205    205    251    251    6                       1259    976726 
   v_cursadas    VIEW     	  CREATE VIEW v_cursadas AS
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
   FROM ((cursadas cu
     JOIN cursos c ON ((c.id = cu.id_curso)))
     JOIN v_sedes s ON ((s.id = cu.id_sede)));
    DROP VIEW public.v_cursadas;
       public       postgres    false    205    193    193    193    193    193    193    193    205    205    205    205    205    205    205    205    269    269    269    6                       1259    976731 
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
       public       postgres    false    184    240    257    257    218    218    218    218    218    220    220    220    220    220    220    222    222    222    216    216    216    218    218    218    218    222    222    222    226    226    233    179    179    179    179    179    179    179    179    240    184    184    233    184    216    216    235    235    216    238    238    240    6                       1259    976736    v_cursadas_alumnos    VIEW       CREATE VIEW v_cursadas_alumnos AS
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
       public       postgres    false    273    273    273    273    194    273    191    194    274    274    274    274    194    274    194    194    274    274    274    194    194    274    273    273    273    273    274    6                       1259    976741    v_cursadas_modulos    VIEW     �  CREATE VIEW v_cursadas_modulos AS
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
       public       postgres    false    199    199    199    199    273    273    273    273    199    199    273    273    273    199    199    199    273    6                       1259    977169    v_clases_alumnos    VIEW     %  CREATE VIEW v_clases_alumnos AS
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
   FROM (((v_clases c
     JOIN cursadas_modulos_alumnos cma ON ((cma.id_modulo = c.id_modulo)))
     LEFT JOIN v_cursadas_alumnos ca ON ((ca.id = cma.id_cursadas_alumnos)))
     LEFT JOIN v_cursadas_modulos cm ON ((cm.id = cma.id_modulo)));
 #   DROP VIEW public.v_clases_alumnos;
       public       postgres    false    281    276    276    276    276    276    276    276    281    281    281    281    281    281    281    281    281    281    281    281    200    200    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    276    276    6                       1259    977159    v_cursadas_modulos_alumnos    VIEW     �  CREATE VIEW v_cursadas_modulos_alumnos AS
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
   FROM ((cursadas_modulos_alumnos cma
     LEFT JOIN v_cursadas_modulos cm ON ((cm.id = cma.id_modulo)))
     LEFT JOIN v_cursadas_alumnos ca ON ((ca.id = cma.id_cursadas_alumnos)));
 -   DROP VIEW public.v_cursadas_modulos_alumnos;
       public       postgres    false    276    276    276    276    276    276    276    276    276    276    276    200    200    200    200    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    275    276    276    6                       1259    976751    v_provincias    VIEW     �   CREATE VIEW v_provincias AS
 SELECT pr.id,
    pr.nombre,
    pr.id_pais,
    p.nombre AS pais,
    p.nacionalidad
   FROM (provincias pr
     LEFT JOIN paises p ON ((p.id = pr.id_pais)));
    DROP VIEW public.v_provincias;
       public       postgres    false    235    235    235    240    240    240    6                       1259    976755    v_tipo_persona_perfiles    VIEW     �   CREATE VIEW v_tipo_persona_perfiles AS
 SELECT tpp.id,
    tpp.id_tipo_persona,
    tp.descripcion AS tipo_persona,
    tpp.perfil
   FROM (tipo_persona_perfiles tpp
     JOIN tipo_persona tp ON ((tp.id = tpp.id_tipo_persona)));
 *   DROP VIEW public.v_tipo_persona_perfiles;
       public       postgres    false    259    259    259    257    257    6                       1259    976759 	   v_titulos    VIEW     �   CREATE VIEW v_titulos AS
 SELECT t.id,
    t.nombre,
    t.descripcion,
    t.id_tipo_titulo,
    tt.descripcion AS tipo_titulo
   FROM (titulos t
     LEFT JOIN tipo_titulo tt ON ((tt.id = t.id_tipo_titulo)));
    DROP VIEW public.v_titulos;
       public       postgres    false    263    263    265    265    265    265    6            >	           2604    976763    alquiler_sede id    DEFAULT     f   ALTER TABLE ONLY alquiler_sede ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_id_seq'::regclass);
 ?   ALTER TABLE public.alquiler_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    178    173            A	           2604    976764    alquiler_sede_cabecera id    DEFAULT     x   ALTER TABLE ONLY alquiler_sede_cabecera ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_cabecera_id_seq'::regclass);
 H   ALTER TABLE public.alquiler_sede_cabecera ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    175    174            C	           2604    976765    alquiler_sede_detalle id    DEFAULT     v   ALTER TABLE ONLY alquiler_sede_detalle ALTER COLUMN id SET DEFAULT nextval('alquiler_sede_detalle_id_seq'::regclass);
 G   ALTER TABLE public.alquiler_sede_detalle ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    177    176            G	           2604    976766    aulas id    DEFAULT     V   ALTER TABLE ONLY aulas ALTER COLUMN id SET DEFAULT nextval('aulas_id_seq'::regclass);
 7   ALTER TABLE public.aulas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    183    182            y	           2604    977210    caja_comprobantes id    DEFAULT     n   ALTER TABLE ONLY caja_comprobantes ALTER COLUMN id SET DEFAULT nextval('caja_comprobantes_id_seq'::regclass);
 C   ALTER TABLE public.caja_comprobantes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    285    286    286            �	           2604    977277    caja_cuentas id    DEFAULT     d   ALTER TABLE ONLY caja_cuentas ALTER COLUMN id SET DEFAULT nextval('caja_cuentas_id_seq'::regclass);
 >   ALTER TABLE public.caja_cuentas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    297    298    298            ~	           2604    977233    caja_medios_pagos id    DEFAULT     m   ALTER TABLE ONLY caja_medios_pagos ALTER COLUMN id SET DEFAULT nextval('caja_mediospagos_id_seq'::regclass);
 C   ALTER TABLE public.caja_medios_pagos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    289    290    290            �	           2604    977264    caja_movimientos id    DEFAULT     l   ALTER TABLE ONLY caja_movimientos ALTER COLUMN id SET DEFAULT nextval('caja_movimientos_id_seq'::regclass);
 B   ALTER TABLE public.caja_movimientos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    296    295    296            �	           2604    977251    caja_operaciones id    DEFAULT     l   ALTER TABLE ONLY caja_operaciones ALTER COLUMN id SET DEFAULT nextval('caja_operaciones_id_seq'::regclass);
 B   ALTER TABLE public.caja_operaciones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    294    293    294            �	           2604    977300    caja_operaciones_diarias id    DEFAULT     |   ALTER TABLE ONLY caja_operaciones_diarias ALTER COLUMN id SET DEFAULT nextval('caja_operaciones_diarias_id_seq'::regclass);
 J   ALTER TABLE public.caja_operaciones_diarias ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    302    301    302            �	           2604    977366    caja_parametrizacion id    DEFAULT     t   ALTER TABLE ONLY caja_parametrizacion ALTER COLUMN id SET DEFAULT nextval('caja_parametrizacion_id_seq'::regclass);
 F   ALTER TABLE public.caja_parametrizacion ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    307    308    308            �	           2604    977287    caja_subcuentas id    DEFAULT     j   ALTER TABLE ONLY caja_subcuentas ALTER COLUMN id SET DEFAULT nextval('caja_subcuentas_id_seq'::regclass);
 A   ALTER TABLE public.caja_subcuentas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    300    299    300            x	           2604    977202    caja_tipo_comprobantes id    DEFAULT     x   ALTER TABLE ONLY caja_tipo_comprobantes ALTER COLUMN id SET DEFAULT nextval('caja_tipo_comprobantes_id_seq'::regclass);
 H   ALTER TABLE public.caja_tipo_comprobantes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    284    283    284            	           2604    977241    caja_tipo_operaciones id    DEFAULT     v   ALTER TABLE ONLY caja_tipo_operaciones ALTER COLUMN id SET DEFAULT nextval('caja_tipo_operaciones_id_seq'::regclass);
 G   ALTER TABLE public.caja_tipo_operaciones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    291    292    292            }	           2604    977225    caja_tipo_titulares id    DEFAULT     r   ALTER TABLE ONLY caja_tipo_titulares ALTER COLUMN id SET DEFAULT nextval('caja_tipo_titulares_id_seq'::regclass);
 E   ALTER TABLE public.caja_tipo_titulares ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    287    288    288            H	           2604    976767    ciudades id    DEFAULT     \   ALTER TABLE ONLY ciudades ALTER COLUMN id SET DEFAULT nextval('ciudades_id_seq'::regclass);
 :   ALTER TABLE public.ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    185    184            I	           2604    976768 	   clases id    DEFAULT     X   ALTER TABLE ONLY clases ALTER COLUMN id SET DEFAULT nextval('clases_id_seq'::regclass);
 8   ALTER TABLE public.clases ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    188    186            J	           2604    976769    clases_profesores id    DEFAULT     n   ALTER TABLE ONLY clases_profesores ALTER COLUMN id SET DEFAULT nextval('clases_profesores_id_seq'::regclass);
 C   ALTER TABLE public.clases_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    190    189            K	           2604    976770    condiciones_alumno id    DEFAULT     p   ALTER TABLE ONLY condiciones_alumno ALTER COLUMN id SET DEFAULT nextval('condiciones_alumno_id_seq'::regclass);
 D   ALTER TABLE public.condiciones_alumno ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    192    191            L	           2604    976771    cursadas id    DEFAULT     \   ALTER TABLE ONLY cursadas ALTER COLUMN id SET DEFAULT nextval('cursadas_id_seq'::regclass);
 :   ALTER TABLE public.cursadas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    193            P	           2604    976772    cursadas_alumnos id    DEFAULT     l   ALTER TABLE ONLY cursadas_alumnos ALTER COLUMN id SET DEFAULT nextval('cursadas_alumnos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    195    194            R	           2604    976773    cursadas_cuotas id    DEFAULT     j   ALTER TABLE ONLY cursadas_cuotas ALTER COLUMN id SET DEFAULT nextval('cursadas_cuotas_id_seq'::regclass);
 A   ALTER TABLE public.cursadas_cuotas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    196            S	           2604    976774    cursadas_modulos id    DEFAULT     l   ALTER TABLE ONLY cursadas_modulos ALTER COLUMN id SET DEFAULT nextval('cursadas_modulos_id_seq'::regclass);
 B   ALTER TABLE public.cursadas_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    199            T	           2604    976775    cursadas_modulos_alumnos id    DEFAULT     |   ALTER TABLE ONLY cursadas_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('cursadas_modulos_alumnos_id_seq'::regclass);
 J   ALTER TABLE public.cursadas_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    200            U	           2604    976776    cursadas_profesores id    DEFAULT     r   ALTER TABLE ONLY cursadas_profesores ALTER COLUMN id SET DEFAULT nextval('cursadas_profesores_id_seq'::regclass);
 E   ALTER TABLE public.cursadas_profesores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203            X	           2604    976777 	   cursos id    DEFAULT     X   ALTER TABLE ONLY cursos ALTER COLUMN id SET DEFAULT nextval('cursos_id_seq'::regclass);
 8   ALTER TABLE public.cursos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    208    205            Y	           2604    976778    cursos_correlatividad id    DEFAULT     v   ALTER TABLE ONLY cursos_correlatividad ALTER COLUMN id SET DEFAULT nextval('cursos_correlatividad_id_seq'::regclass);
 G   ALTER TABLE public.cursos_correlatividad ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    206            Z	           2604    976779    cursos_modulos id    DEFAULT     h   ALTER TABLE ONLY cursos_modulos ALTER COLUMN id SET DEFAULT nextval('cursos_modulos_id_seq'::regclass);
 @   ALTER TABLE public.cursos_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    209            [	           2604    976780    cursos_modulos_alumnos id    DEFAULT     x   ALTER TABLE ONLY cursos_modulos_alumnos ALTER COLUMN id SET DEFAULT nextval('cursos_modulos_alumnos_id_seq'::regclass);
 H   ALTER TABLE public.cursos_modulos_alumnos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    210            \	           2604    976781    cursos_titulos id    DEFAULT     h   ALTER TABLE ONLY cursos_titulos ALTER COLUMN id SET DEFAULT nextval('cursos_titulos_id_seq'::regclass);
 @   ALTER TABLE public.cursos_titulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    214    213            ]	           2604    976782    datos_academicos id    DEFAULT     l   ALTER TABLE ONLY datos_academicos ALTER COLUMN id SET DEFAULT nextval('datos_academicos_id_seq'::regclass);
 B   ALTER TABLE public.datos_academicos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    217    216            ^	           2604    976783    datos_actuales id    DEFAULT     h   ALTER TABLE ONLY datos_actuales ALTER COLUMN id SET DEFAULT nextval('datos_actuales_id_seq'::regclass);
 @   ALTER TABLE public.datos_actuales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    219    218            _	           2604    976784    datos_laborales id    DEFAULT     j   ALTER TABLE ONLY datos_laborales ALTER COLUMN id SET DEFAULT nextval('datos_laborales_id_seq'::regclass);
 A   ALTER TABLE public.datos_laborales ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    220            `	           2604    976785    datos_salud id    DEFAULT     b   ALTER TABLE ONLY datos_salud ALTER COLUMN id SET DEFAULT nextval('datos_salud_id_seq'::regclass);
 =   ALTER TABLE public.datos_salud ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    223    222            a	           2604    976786    estados_pago id    DEFAULT     d   ALTER TABLE ONLY estados_pago ALTER COLUMN id SET DEFAULT nextval('estados_pago_id_seq'::regclass);
 >   ALTER TABLE public.estados_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    225    224            b	           2604    976787    grupos_sanguineos id    DEFAULT     n   ALTER TABLE ONLY grupos_sanguineos ALTER COLUMN id SET DEFAULT nextval('grupos_sanguineos_id_seq'::regclass);
 C   ALTER TABLE public.grupos_sanguineos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    227    226            c	           2604    976788    inscripciones_modulos id    DEFAULT     v   ALTER TABLE ONLY inscripciones_modulos ALTER COLUMN id SET DEFAULT nextval('inscripciones_modulos_id_seq'::regclass);
 G   ALTER TABLE public.inscripciones_modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    230    229            e	           2604    976789 
   modulos id    DEFAULT     Z   ALTER TABLE ONLY modulos ALTER COLUMN id SET DEFAULT nextval('modulos_id_seq'::regclass);
 9   ALTER TABLE public.modulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    232    231            f	           2604    976790    niveles_estudios id    DEFAULT     l   ALTER TABLE ONLY niveles_estudios ALTER COLUMN id SET DEFAULT nextval('niveles_estudios_id_seq'::regclass);
 B   ALTER TABLE public.niveles_estudios ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    234    233            g	           2604    976791 	   paises id    DEFAULT     X   ALTER TABLE ONLY paises ALTER COLUMN id SET DEFAULT nextval('paises_id_seq'::regclass);
 8   ALTER TABLE public.paises ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    236    235            E	           2604    976792    personas id    DEFAULT     [   ALTER TABLE ONLY personas ALTER COLUMN id SET DEFAULT nextval('alumnos_id_seq'::regclass);
 :   ALTER TABLE public.personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    180    179            F	           2604    976793    personas legajo    DEFAULT     c   ALTER TABLE ONLY personas ALTER COLUMN legajo SET DEFAULT nextval('alumnos_legajo_seq'::regclass);
 >   ALTER TABLE public.personas ALTER COLUMN legajo DROP DEFAULT;
       public       postgres    false    181    179            h	           2604    976794    profesiones id    DEFAULT     b   ALTER TABLE ONLY profesiones ALTER COLUMN id SET DEFAULT nextval('profesiones_id_seq'::regclass);
 =   ALTER TABLE public.profesiones ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    239    238            i	           2604    976795    provincias id    DEFAULT     `   ALTER TABLE ONLY provincias ALTER COLUMN id SET DEFAULT nextval('provincias_id_seq'::regclass);
 <   ALTER TABLE public.provincias ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    240            k	           2604    976796    sedes id    DEFAULT     V   ALTER TABLE ONLY sedes ALTER COLUMN id SET DEFAULT nextval('sedes_id_seq'::regclass);
 7   ALTER TABLE public.sedes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    245    242            l	           2604    976797    sedes_formadores id    DEFAULT     l   ALTER TABLE ONLY sedes_formadores ALTER COLUMN id SET DEFAULT nextval('sedes_formadores_id_seq'::regclass);
 B   ALTER TABLE public.sedes_formadores ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    244    243            m	           2604    976798    temp_ciudades id    DEFAULT     f   ALTER TABLE ONLY temp_ciudades ALTER COLUMN id SET DEFAULT nextval('temp_ciudades_id_seq'::regclass);
 ?   ALTER TABLE public.temp_ciudades ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    247    246            n	           2604    976799    temp_personas id    DEFAULT     f   ALTER TABLE ONLY temp_personas ALTER COLUMN id SET DEFAULT nextval('temp_personas_id_seq'::regclass);
 ?   ALTER TABLE public.temp_personas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    250    248            o	           2604    976800    tipo_clase id    DEFAULT     `   ALTER TABLE ONLY tipo_clase ALTER COLUMN id SET DEFAULT nextval('tipo_clase_id_seq'::regclass);
 <   ALTER TABLE public.tipo_clase ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    252    251            p	           2604    976801    tipo_pago id    DEFAULT     ^   ALTER TABLE ONLY tipo_pago ALTER COLUMN id SET DEFAULT nextval('tipo_pago_id_seq'::regclass);
 ;   ALTER TABLE public.tipo_pago ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    254    253            q	           2604    976802    tipo_pago_sede id    DEFAULT     h   ALTER TABLE ONLY tipo_pago_sede ALTER COLUMN id SET DEFAULT nextval('tipo_pago_sede_id_seq'::regclass);
 @   ALTER TABLE public.tipo_pago_sede ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    256    255            r	           2604    976803    tipo_persona id    DEFAULT     d   ALTER TABLE ONLY tipo_persona ALTER COLUMN id SET DEFAULT nextval('tipo_persona_id_seq'::regclass);
 >   ALTER TABLE public.tipo_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    258    257            s	           2604    976804    tipo_persona_perfiles id    DEFAULT     v   ALTER TABLE ONLY tipo_persona_perfiles ALTER COLUMN id SET DEFAULT nextval('tipo_persona_perfiles_id_seq'::regclass);
 G   ALTER TABLE public.tipo_persona_perfiles ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    260    259            t	           2604    976805    tipo_profesor id    DEFAULT     f   ALTER TABLE ONLY tipo_profesor ALTER COLUMN id SET DEFAULT nextval('tipo_profesor_id_seq'::regclass);
 ?   ALTER TABLE public.tipo_profesor ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    262    261            u	           2604    976806    tipo_titulo id    DEFAULT     b   ALTER TABLE ONLY tipo_titulo ALTER COLUMN id SET DEFAULT nextval('tipo_titulo_id_seq'::regclass);
 =   ALTER TABLE public.tipo_titulo ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    264    263            v	           2604    976807 
   titulos id    DEFAULT     Z   ALTER TABLE ONLY titulos ALTER COLUMN id SET DEFAULT nextval('titulos_id_seq'::regclass);
 9   ALTER TABLE public.titulos ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    266    265            w	           2604    976808    usuario_persona id    DEFAULT     j   ALTER TABLE ONLY usuario_persona ALTER COLUMN id SET DEFAULT nextval('usuario_persona_id_seq'::regclass);
 A   ALTER TABLE public.usuario_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    268    267            �
          0    976417    alquiler_sede 
   TABLE DATA                     public       postgres    false    173   �      �
          0    976421    alquiler_sede_cabecera 
   TABLE DATA                     public       postgres    false    174   a�      �
          0    976428    alquiler_sede_detalle 
   TABLE DATA                     public       postgres    false    176   {�      �
          0    976444    aulas 
   TABLE DATA                     public       postgres    false    182   ��      1          0    977207    caja_comprobantes 
   TABLE DATA                     public       postgres    false    286   ��      =          0    977274    caja_cuentas 
   TABLE DATA                     public       postgres    false    298   ]�      5          0    977230    caja_medios_pagos 
   TABLE DATA                     public       postgres    false    290   w�      ;          0    977261    caja_movimientos 
   TABLE DATA                     public       postgres    false    296   �      9          0    977248    caja_operaciones 
   TABLE DATA                     public       postgres    false    294   5�      A          0    977297    caja_operaciones_diarias 
   TABLE DATA                     public       postgres    false    302   �      C          0    977363    caja_parametrizacion 
   TABLE DATA                     public       postgres    false    308   �      ?          0    977284    caja_subcuentas 
   TABLE DATA                     public       postgres    false    300   (�      /          0    977199    caja_tipo_comprobantes 
   TABLE DATA                     public       postgres    false    284   B�      7          0    977238    caja_tipo_operaciones 
   TABLE DATA                     public       postgres    false    292   ��      3          0    977222    caja_tipo_titulares 
   TABLE DATA                     public       postgres    false    288   ��      �
          0    976449    ciudades 
   TABLE DATA                     public       postgres    false    184   I�      �
          0    976454    clases 
   TABLE DATA                     public       postgres    false    186   ��      �
          0    976460    clases_asistencia 
   TABLE DATA                     public       postgres    false    187   �       �
          0    976465    clases_profesores 
   TABLE DATA                     public       postgres    false    189   �       �
          0    976470    condiciones_alumno 
   TABLE DATA                     public       postgres    false    191   �       �
          0    976475    cursadas 
   TABLE DATA                     public       postgres    false    193   &      �
          0    976478    cursadas_alumnos 
   TABLE DATA                     public       postgres    false    194   �      �
          0    976486    cursadas_cuotas 
   TABLE DATA                     public       postgres    false    196   B      �
          0    976494    cursadas_modulos 
   TABLE DATA                     public       postgres    false    199   \      �
          0    976500    cursadas_modulos_alumnos 
   TABLE DATA                     public       postgres    false    200   H      �
          0    976507    cursadas_profesores 
   TABLE DATA                     public       postgres    false    203   �      �
          0    976512    cursos 
   TABLE DATA                     public       postgres    false    205         �
          0    976517    cursos_correlatividad 
   TABLE DATA                     public       postgres    false    206   o      �
          0    976524    cursos_modulos 
   TABLE DATA                     public       postgres    false    209   �      �
          0    976530    cursos_modulos_alumnos 
   TABLE DATA                     public       postgres    false    210   �      �
          0    976537    cursos_titulos 
   TABLE DATA                     public       postgres    false    213   U      �
          0    976542    databasechangeloglock 
   TABLE DATA                     public       postgres    false    215   �      �
          0    976545    datos_academicos 
   TABLE DATA                     public       postgres    false    216   �      �
          0    976550    datos_actuales 
   TABLE DATA                     public       postgres    false    218   �       �
          0    976558    datos_laborales 
   TABLE DATA                     public       postgres    false    220   �x      �
          0    976566    datos_salud 
   TABLE DATA                     public       postgres    false    222   �                0    976571    estados_pago 
   TABLE DATA                     public       postgres    false    224   N�                0    976576    grupos_sanguineos 
   TABLE DATA                     public       postgres    false    226   ��                0    976581    ids 
   TABLE DATA                     public       postgres    false    228   J�                0    976584    inscripciones_modulos 
   TABLE DATA                     public       postgres    false    229   ޲                0    976589    modulos 
   TABLE DATA                     public       postgres    false    231   ��      
          0    976595    niveles_estudios 
   TABLE DATA                     public       postgres    false    233   �                0    976600    paises 
   TABLE DATA                     public       postgres    false    235   ��                0    976605    perfiles 
   TABLE DATA                     public       postgres    false    237   ҳ      �
          0    976436    personas 
   TABLE DATA                     public       postgres    false    179   �                0    976608    profesiones 
   TABLE DATA                     public       postgres    false    238   ��                0    976613 
   provincias 
   TABLE DATA                     public       postgres    false    240   ��                0    976621    sedes 
   TABLE DATA                     public       postgres    false    242   ��                0    976628    sedes_formadores 
   TABLE DATA                     public       postgres    false    243   )�                0    976635    temp_ciudades 
   TABLE DATA                     public       postgres    false    246   C�                0    976640    temp_personas 
   TABLE DATA                     public       postgres    false    248   L�                0    976646    temp_personas2 
   TABLE DATA                     public       postgres    false    249   ��                0    976654 
   tipo_clase 
   TABLE DATA                     public       postgres    false    251   L�                0    976659 	   tipo_pago 
   TABLE DATA                     public       postgres    false    253   ��                 0    976664    tipo_pago_sede 
   TABLE DATA                     public       postgres    false    255   "�      "          0    976669    tipo_persona 
   TABLE DATA                     public       postgres    false    257   {�      $          0    976674    tipo_persona_perfiles 
   TABLE DATA                     public       postgres    false    259   �      &          0    976679    tipo_profesor 
   TABLE DATA                     public       postgres    false    261   2�      (          0    976684    tipo_titulo 
   TABLE DATA                     public       postgres    false    263   ��      *          0    976689    titulos 
   TABLE DATA                     public       postgres    false    265   �      ,          0    976697    usuario_persona 
   TABLE DATA                     public       postgres    false    267   o�      �           0    0    alquiler_sede_cabecera_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('alquiler_sede_cabecera_id_seq', 2, true);
            public       postgres    false    175            �           0    0    alquiler_sede_detalle_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('alquiler_sede_detalle_id_seq', 3, true);
            public       postgres    false    177            �           0    0    alquiler_sede_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('alquiler_sede_id_seq', 8, true);
            public       postgres    false    178            �           0    0    alumnos_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('alumnos_id_seq', 9, true);
            public       postgres    false    180            �           0    0    alumnos_legajo_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('alumnos_legajo_seq', 6, true);
            public       postgres    false    181            �           0    0    aulas_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('aulas_id_seq', 4, true);
            public       postgres    false    183            �           0    0    caja_comprobantes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('caja_comprobantes_id_seq', 6, true);
            public       postgres    false    285            �           0    0    caja_cuentas_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('caja_cuentas_id_seq', 1, false);
            public       postgres    false    297            �           0    0    caja_mediospagos_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('caja_mediospagos_id_seq', 7, true);
            public       postgres    false    289            �           0    0    caja_movimientos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('caja_movimientos_id_seq', 1, false);
            public       postgres    false    295            �           0    0    caja_operaciones_diarias_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('caja_operaciones_diarias_id_seq', 1, false);
            public       postgres    false    301            �           0    0    caja_operaciones_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('caja_operaciones_id_seq', 8, true);
            public       postgres    false    293            �           0    0    caja_parametrizacion_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('caja_parametrizacion_id_seq', 1, false);
            public       postgres    false    307            �           0    0    caja_subcuentas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('caja_subcuentas_id_seq', 1, false);
            public       postgres    false    299            �           0    0    caja_tipo_comprobantes_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('caja_tipo_comprobantes_id_seq', 8, true);
            public       postgres    false    283            �           0    0    caja_tipo_operaciones_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('caja_tipo_operaciones_id_seq', 9, true);
            public       postgres    false    291            �           0    0    caja_tipo_titulares_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('caja_tipo_titulares_id_seq', 6, true);
            public       postgres    false    287            �           0    0    ciudades_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('ciudades_id_seq', 1, false);
            public       postgres    false    185            �           0    0    clases_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('clases_id_seq', 7, true);
            public       postgres    false    188            �           0    0    clases_profesores_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('clases_profesores_id_seq', 1, false);
            public       postgres    false    190            �           0    0    condiciones_alumno_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('condiciones_alumno_id_seq', 3, true);
            public       postgres    false    192            �           0    0    cursadas_alumnos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('cursadas_alumnos_id_seq', 16, true);
            public       postgres    false    195            �           0    0    cursadas_cuotas_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('cursadas_cuotas_id_seq', 1, false);
            public       postgres    false    197            �           0    0    cursadas_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('cursadas_id_seq', 12, true);
            public       postgres    false    198            �           0    0    cursadas_modulos_alumnos_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('cursadas_modulos_alumnos_id_seq', 60, true);
            public       postgres    false    201            �           0    0    cursadas_modulos_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('cursadas_modulos_id_seq', 72, true);
            public       postgres    false    202            �           0    0    cursadas_profesores_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('cursadas_profesores_id_seq', 3, true);
            public       postgres    false    204            �           0    0    cursos_correlatividad_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('cursos_correlatividad_id_seq', 3, true);
            public       postgres    false    207            �           0    0    cursos_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('cursos_id_seq', 2, true);
            public       postgres    false    208            �           0    0    cursos_modulos_alumnos_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('cursos_modulos_alumnos_id_seq', 13, true);
            public       postgres    false    211            �           0    0    cursos_modulos_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('cursos_modulos_id_seq', 10, true);
            public       postgres    false    212            �           0    0    cursos_titulos_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('cursos_titulos_id_seq', 1, true);
            public       postgres    false    214            �           0    0    datos_academicos_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('datos_academicos_id_seq', 538, true);
            public       postgres    false    217            �           0    0    datos_actuales_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('datos_actuales_id_seq', 4570, true);
            public       postgres    false    219            �           0    0    datos_laborales_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('datos_laborales_id_seq', 2216, true);
            public       postgres    false    221            �           0    0    datos_salud_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('datos_salud_id_seq', 539, true);
            public       postgres    false    223            �           0    0    estados_pago_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('estados_pago_id_seq', 1, false);
            public       postgres    false    225            �           0    0    grupos_sanguineos_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('grupos_sanguineos_id_seq', 16, true);
            public       postgres    false    227            �           0    0    inscripciones_modulos_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('inscripciones_modulos_id_seq', 1, false);
            public       postgres    false    230            �           0    0    modulos_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('modulos_id_seq', 1, false);
            public       postgres    false    232            �           0    0    niveles_estudios_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('niveles_estudios_id_seq', 1, false);
            public       postgres    false    234            �           0    0    paises_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('paises_id_seq', 1, false);
            public       postgres    false    236            �           0    0    profesiones_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('profesiones_id_seq', 1, false);
            public       postgres    false    239            �           0    0    provincias_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('provincias_id_seq', 1, false);
            public       postgres    false    241            �           0    0    sedes_formadores_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('sedes_formadores_id_seq', 5, true);
            public       postgres    false    244            �           0    0    sedes_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('sedes_id_seq', 8, true);
            public       postgres    false    245            �           0    0    temp_ciudades_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('temp_ciudades_id_seq', 43, true);
            public       postgres    false    247            �           0    0    temp_personas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('temp_personas_id_seq', 654, true);
            public       postgres    false    250            �           0    0    tipo_clase_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('tipo_clase_id_seq', 3, true);
            public       postgres    false    252            �           0    0    tipo_pago_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('tipo_pago_id_seq', 5, true);
            public       postgres    false    254            �           0    0    tipo_pago_sede_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('tipo_pago_sede_id_seq', 2, true);
            public       postgres    false    256            �           0    0    tipo_persona_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_persona_id_seq', 1, false);
            public       postgres    false    258            �           0    0    tipo_persona_perfiles_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('tipo_persona_perfiles_id_seq', 1, true);
            public       postgres    false    260            �           0    0    tipo_profesor_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_profesor_id_seq', 3, true);
            public       postgres    false    262            �           0    0    tipo_titulo_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('tipo_titulo_id_seq', 2, true);
            public       postgres    false    264            �           0    0    titulos_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('titulos_id_seq', 1, true);
            public       postgres    false    266            �           0    0    usuario_persona_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('usuario_persona_id_seq', 1, false);
            public       postgres    false    268            �	           2606    976810 &   niveles_estudios niveles_estudios_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY niveles_estudios
    ADD CONSTRAINT niveles_estudios_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.niveles_estudios DROP CONSTRAINT niveles_estudios_pkey;
       public         postgres    false    233            �	           2606    976812    alquiler_sede pk_alquiler_sede 
   CONSTRAINT     U   ALTER TABLE ONLY alquiler_sede
    ADD CONSTRAINT pk_alquiler_sede PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.alquiler_sede DROP CONSTRAINT pk_alquiler_sede;
       public         postgres    false    173            �	           2606    976814 0   alquiler_sede_cabecera pk_alquiler_sede_cabecera 
   CONSTRAINT     g   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT pk_alquiler_sede_cabecera PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT pk_alquiler_sede_cabecera;
       public         postgres    false    174            �	           2606    976816 .   alquiler_sede_detalle pk_alquiler_sede_detalle 
   CONSTRAINT     e   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT pk_alquiler_sede_detalle PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT pk_alquiler_sede_detalle;
       public         postgres    false    176            �	           2606    976818    personas pk_alumnos 
   CONSTRAINT     J   ALTER TABLE ONLY personas
    ADD CONSTRAINT pk_alumnos PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.personas DROP CONSTRAINT pk_alumnos;
       public         postgres    false    179            �	           2606    976820    aulas pk_aulas 
   CONSTRAINT     E   ALTER TABLE ONLY aulas
    ADD CONSTRAINT pk_aulas PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.aulas DROP CONSTRAINT pk_aulas;
       public         postgres    false    182            �	           2606    977214 &   caja_comprobantes pk_caja_comprobantes 
   CONSTRAINT     ]   ALTER TABLE ONLY caja_comprobantes
    ADD CONSTRAINT pk_caja_comprobantes PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.caja_comprobantes DROP CONSTRAINT pk_caja_comprobantes;
       public         postgres    false    286            	
           2606    977279    caja_cuentas pk_caja_cuentas 
   CONSTRAINT     S   ALTER TABLE ONLY caja_cuentas
    ADD CONSTRAINT pk_caja_cuentas PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.caja_cuentas DROP CONSTRAINT pk_caja_cuentas;
       public         postgres    false    298            
           2606    977235 %   caja_medios_pagos pk_caja_mediospagos 
   CONSTRAINT     \   ALTER TABLE ONLY caja_medios_pagos
    ADD CONSTRAINT pk_caja_mediospagos PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.caja_medios_pagos DROP CONSTRAINT pk_caja_mediospagos;
       public         postgres    false    290            
           2606    977266 $   caja_movimientos pk_caja_movimientos 
   CONSTRAINT     [   ALTER TABLE ONLY caja_movimientos
    ADD CONSTRAINT pk_caja_movimientos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.caja_movimientos DROP CONSTRAINT pk_caja_movimientos;
       public         postgres    false    296            
           2606    977253 $   caja_operaciones pk_caja_operaciones 
   CONSTRAINT     [   ALTER TABLE ONLY caja_operaciones
    ADD CONSTRAINT pk_caja_operaciones PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.caja_operaciones DROP CONSTRAINT pk_caja_operaciones;
       public         postgres    false    294            
           2606    977303 4   caja_operaciones_diarias pk_caja_operaciones_diarias 
   CONSTRAINT     k   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT pk_caja_operaciones_diarias PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT pk_caja_operaciones_diarias;
       public         postgres    false    302            
           2606    977369 ,   caja_parametrizacion pk_caja_parametrizacion 
   CONSTRAINT     c   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT pk_caja_parametrizacion PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT pk_caja_parametrizacion;
       public         postgres    false    308            
           2606    977289 "   caja_subcuentas pk_caja_subcuentas 
   CONSTRAINT     Y   ALTER TABLE ONLY caja_subcuentas
    ADD CONSTRAINT pk_caja_subcuentas PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.caja_subcuentas DROP CONSTRAINT pk_caja_subcuentas;
       public         postgres    false    300            �	           2606    977204 0   caja_tipo_comprobantes pk_caja_tipo_comprobantes 
   CONSTRAINT     g   ALTER TABLE ONLY caja_tipo_comprobantes
    ADD CONSTRAINT pk_caja_tipo_comprobantes PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.caja_tipo_comprobantes DROP CONSTRAINT pk_caja_tipo_comprobantes;
       public         postgres    false    284            
           2606    977243 .   caja_tipo_operaciones pk_caja_tipo_operaciones 
   CONSTRAINT     e   ALTER TABLE ONLY caja_tipo_operaciones
    ADD CONSTRAINT pk_caja_tipo_operaciones PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.caja_tipo_operaciones DROP CONSTRAINT pk_caja_tipo_operaciones;
       public         postgres    false    292            �	           2606    977227 *   caja_tipo_titulares pk_caja_tipo_titulares 
   CONSTRAINT     a   ALTER TABLE ONLY caja_tipo_titulares
    ADD CONSTRAINT pk_caja_tipo_titulares PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.caja_tipo_titulares DROP CONSTRAINT pk_caja_tipo_titulares;
       public         postgres    false    288            �	           2606    976822    ciudades pk_ciudad 
   CONSTRAINT     I   ALTER TABLE ONLY ciudades
    ADD CONSTRAINT pk_ciudad PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT pk_ciudad;
       public         postgres    false    184            �	           2606    976824    clases pk_clases 
   CONSTRAINT     G   ALTER TABLE ONLY clases
    ADD CONSTRAINT pk_clases PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.clases DROP CONSTRAINT pk_clases;
       public         postgres    false    186            �	           2606    976826 &   clases_asistencia pk_clases_asistencia 
   CONSTRAINT     ]   ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT pk_clases_asistencia PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT pk_clases_asistencia;
       public         postgres    false    187            �	           2606    976828 &   clases_profesores pk_clases_profesores 
   CONSTRAINT     ]   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT pk_clases_profesores PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT pk_clases_profesores;
       public         postgres    false    189            �	           2606    976830 (   condiciones_alumno pk_condiciones_alumno 
   CONSTRAINT     _   ALTER TABLE ONLY condiciones_alumno
    ADD CONSTRAINT pk_condiciones_alumno PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.condiciones_alumno DROP CONSTRAINT pk_condiciones_alumno;
       public         postgres    false    191            �	           2606    976832    cursadas pk_cursadas 
   CONSTRAINT     K   ALTER TABLE ONLY cursadas
    ADD CONSTRAINT pk_cursadas PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT pk_cursadas;
       public         postgres    false    193            �	           2606    976834 $   cursadas_alumnos pk_cursadas_alumnos 
   CONSTRAINT     [   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT pk_cursadas_alumnos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT pk_cursadas_alumnos;
       public         postgres    false    194            �	           2606    976836 "   cursadas_cuotas pk_cursadas_cuotas 
   CONSTRAINT     Y   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT pk_cursadas_cuotas PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT pk_cursadas_cuotas;
       public         postgres    false    196            �	           2606    976838 $   cursadas_modulos pk_cursadas_modulos 
   CONSTRAINT     [   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT pk_cursadas_modulos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT pk_cursadas_modulos;
       public         postgres    false    199            �	           2606    976840 4   cursadas_modulos_alumnos pk_cursadas_modulos_alumnos 
   CONSTRAINT     k   ALTER TABLE ONLY cursadas_modulos_alumnos
    ADD CONSTRAINT pk_cursadas_modulos_alumnos PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.cursadas_modulos_alumnos DROP CONSTRAINT pk_cursadas_modulos_alumnos;
       public         postgres    false    200            �	           2606    976842 *   cursadas_profesores pk_cursadas_profesores 
   CONSTRAINT     a   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT pk_cursadas_profesores PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT pk_cursadas_profesores;
       public         postgres    false    203            �	           2606    976844    cursos pk_cursos 
   CONSTRAINT     G   ALTER TABLE ONLY cursos
    ADD CONSTRAINT pk_cursos PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.cursos DROP CONSTRAINT pk_cursos;
       public         postgres    false    205            �	           2606    976846 .   cursos_correlatividad pk_cursos_correlatividad 
   CONSTRAINT     e   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT pk_cursos_correlatividad PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT pk_cursos_correlatividad;
       public         postgres    false    206            �	           2606    976848     cursos_modulos pk_cursos_modulos 
   CONSTRAINT     W   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT pk_cursos_modulos PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT pk_cursos_modulos;
       public         postgres    false    209            �	           2606    976850 0   cursos_modulos_alumnos pk_cursos_modulos_alumnos 
   CONSTRAINT     g   ALTER TABLE ONLY cursos_modulos_alumnos
    ADD CONSTRAINT pk_cursos_modulos_alumnos PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.cursos_modulos_alumnos DROP CONSTRAINT pk_cursos_modulos_alumnos;
       public         postgres    false    210            �	           2606    976852     cursos_titulos pk_cursos_titulos 
   CONSTRAINT     W   ALTER TABLE ONLY cursos_titulos
    ADD CONSTRAINT pk_cursos_titulos PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT pk_cursos_titulos;
       public         postgres    false    213            �	           2606    976854 .   databasechangeloglock pk_databasechangeloglock 
   CONSTRAINT     e   ALTER TABLE ONLY databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.databasechangeloglock DROP CONSTRAINT pk_databasechangeloglock;
       public         postgres    false    215            �	           2606    976856 $   datos_academicos pk_datos_academicos 
   CONSTRAINT     [   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT pk_datos_academicos PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT pk_datos_academicos;
       public         postgres    false    216            �	           2606    976858     datos_actuales pk_datos_actuales 
   CONSTRAINT     W   ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT pk_datos_actuales PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT pk_datos_actuales;
       public         postgres    false    218            �	           2606    976860 "   datos_laborales pk_datos_laborales 
   CONSTRAINT     Y   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT pk_datos_laborales PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT pk_datos_laborales;
       public         postgres    false    220            �	           2606    976862    datos_salud pk_datos_salud 
   CONSTRAINT     Q   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT pk_datos_salud PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT pk_datos_salud;
       public         postgres    false    222            �	           2606    976864    estados_pago pk_estados_pago 
   CONSTRAINT     S   ALTER TABLE ONLY estados_pago
    ADD CONSTRAINT pk_estados_pago PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.estados_pago DROP CONSTRAINT pk_estados_pago;
       public         postgres    false    224            �	           2606    976866 &   grupos_sanguineos pk_grupos_sanguineos 
   CONSTRAINT     ]   ALTER TABLE ONLY grupos_sanguineos
    ADD CONSTRAINT pk_grupos_sanguineos PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.grupos_sanguineos DROP CONSTRAINT pk_grupos_sanguineos;
       public         postgres    false    226            �	           2606    976868 .   inscripciones_modulos pk_inscripciones_modulos 
   CONSTRAINT     e   ALTER TABLE ONLY inscripciones_modulos
    ADD CONSTRAINT pk_inscripciones_modulos PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.inscripciones_modulos DROP CONSTRAINT pk_inscripciones_modulos;
       public         postgres    false    229            �	           2606    976870    modulos pk_modulos 
   CONSTRAINT     I   ALTER TABLE ONLY modulos
    ADD CONSTRAINT pk_modulos PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.modulos DROP CONSTRAINT pk_modulos;
       public         postgres    false    231            �	           2606    976872    paises pk_paises 
   CONSTRAINT     G   ALTER TABLE ONLY paises
    ADD CONSTRAINT pk_paises PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.paises DROP CONSTRAINT pk_paises;
       public         postgres    false    235            �	           2606    976874    perfiles pk_perfil 
   CONSTRAINT     M   ALTER TABLE ONLY perfiles
    ADD CONSTRAINT pk_perfil PRIMARY KEY (perfil);
 <   ALTER TABLE ONLY public.perfiles DROP CONSTRAINT pk_perfil;
       public         postgres    false    237            �	           2606    976876    profesiones pk_profesiones 
   CONSTRAINT     Q   ALTER TABLE ONLY profesiones
    ADD CONSTRAINT pk_profesiones PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.profesiones DROP CONSTRAINT pk_profesiones;
       public         postgres    false    238            �	           2606    976878    provincias pk_provincias 
   CONSTRAINT     O   ALTER TABLE ONLY provincias
    ADD CONSTRAINT pk_provincias PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.provincias DROP CONSTRAINT pk_provincias;
       public         postgres    false    240            �	           2606    976880    sedes pk_sedes 
   CONSTRAINT     E   ALTER TABLE ONLY sedes
    ADD CONSTRAINT pk_sedes PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sedes DROP CONSTRAINT pk_sedes;
       public         postgres    false    242            �	           2606    976882 $   sedes_formadores pk_sedes_formadores 
   CONSTRAINT     [   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT pk_sedes_formadores PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT pk_sedes_formadores;
       public         postgres    false    243            �	           2606    976884    temp_ciudades pk_temp_ciudades 
   CONSTRAINT     U   ALTER TABLE ONLY temp_ciudades
    ADD CONSTRAINT pk_temp_ciudades PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_ciudades DROP CONSTRAINT pk_temp_ciudades;
       public         postgres    false    246            �	           2606    976886    temp_personas pk_temp_personas 
   CONSTRAINT     U   ALTER TABLE ONLY temp_personas
    ADD CONSTRAINT pk_temp_personas PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.temp_personas DROP CONSTRAINT pk_temp_personas;
       public         postgres    false    248            �	           2606    976888    tipo_clase pk_tipo_clase 
   CONSTRAINT     O   ALTER TABLE ONLY tipo_clase
    ADD CONSTRAINT pk_tipo_clase PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.tipo_clase DROP CONSTRAINT pk_tipo_clase;
       public         postgres    false    251            �	           2606    976890    tipo_pago pk_tipo_pago 
   CONSTRAINT     M   ALTER TABLE ONLY tipo_pago
    ADD CONSTRAINT pk_tipo_pago PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT pk_tipo_pago;
       public         postgres    false    253            �	           2606    976892     tipo_pago_sede pk_tipo_pago_sede 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_pago_sede
    ADD CONSTRAINT pk_tipo_pago_sede PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_pago_sede DROP CONSTRAINT pk_tipo_pago_sede;
       public         postgres    false    255            �	           2606    976894    tipo_persona pk_tipo_persona 
   CONSTRAINT     S   ALTER TABLE ONLY tipo_persona
    ADD CONSTRAINT pk_tipo_persona PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.tipo_persona DROP CONSTRAINT pk_tipo_persona;
       public         postgres    false    257            �	           2606    976896 .   tipo_persona_perfiles pk_tipo_persona_perfiles 
   CONSTRAINT     e   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT pk_tipo_persona_perfiles PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT pk_tipo_persona_perfiles;
       public         postgres    false    259            �	           2606    976898     tipo_profesor pk_tipo_profesores 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_profesor
    ADD CONSTRAINT pk_tipo_profesores PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_profesor DROP CONSTRAINT pk_tipo_profesores;
       public         postgres    false    261            �	           2606    976900    tipo_titulo pk_tipo_titulo 
   CONSTRAINT     Q   ALTER TABLE ONLY tipo_titulo
    ADD CONSTRAINT pk_tipo_titulo PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.tipo_titulo DROP CONSTRAINT pk_tipo_titulo;
       public         postgres    false    263            �	           2606    976902    titulos pk_titulos 
   CONSTRAINT     I   ALTER TABLE ONLY titulos
    ADD CONSTRAINT pk_titulos PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.titulos DROP CONSTRAINT pk_titulos;
       public         postgres    false    265            �	           2606    976904 "   usuario_persona pk_usuario_persona 
   CONSTRAINT     Y   ALTER TABLE ONLY usuario_persona
    ADD CONSTRAINT pk_usuario_persona PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT pk_usuario_persona;
       public         postgres    false    267            �	           2606    976906    personas uk_alumnos_dni 
   CONSTRAINT     J   ALTER TABLE ONLY personas
    ADD CONSTRAINT uk_alumnos_dni UNIQUE (dni);
 A   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_dni;
       public         postgres    false    179            �	           2606    976908    personas uk_alumnos_legajo 
   CONSTRAINT     P   ALTER TABLE ONLY personas
    ADD CONSTRAINT uk_alumnos_legajo UNIQUE (legajo);
 D   ALTER TABLE ONLY public.personas DROP CONSTRAINT uk_alumnos_legajo;
       public         postgres    false    179            
           2606    977281 )   caja_cuentas uk_caja_cuentas__descripcion 
   CONSTRAINT     d   ALTER TABLE ONLY caja_cuentas
    ADD CONSTRAINT uk_caja_cuentas__descripcion UNIQUE (descripcion);
 S   ALTER TABLE ONLY public.caja_cuentas DROP CONSTRAINT uk_caja_cuentas__descripcion;
       public         postgres    false    298            �	           2606    976910 $   cursadas_alumnos uk_cursadas_alumnos 
   CONSTRAINT     i   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT uk_cursadas_alumnos UNIQUE (id_cursada, id_alumno);
 N   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT uk_cursadas_alumnos;
       public         postgres    false    194    194            �	           2606    976912 $   cursadas_modulos uk_cursadas_modulos 
   CONSTRAINT     c   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT uk_cursadas_modulos UNIQUE (mes, id_cursada);
 N   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT uk_cursadas_modulos;
       public         postgres    false    199    199            �	           2606    976914 .   cursos_correlatividad uk_cursos_correlatividad 
   CONSTRAINT     w   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT uk_cursos_correlatividad UNIQUE (id_curso, id_curso_previo);
 X   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT uk_cursos_correlatividad;
       public         postgres    false    206    206            �	           2606    976916     cursos_modulos uk_cursos_modulos 
   CONSTRAINT     ]   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT uk_cursos_modulos UNIQUE (mes, id_curso);
 J   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT uk_cursos_modulos;
       public         postgres    false    209    209            �	           2606    976918     cursos_titulos uk_cursos_titulos 
   CONSTRAINT     c   ALTER TABLE ONLY cursos_titulos
    ADD CONSTRAINT uk_cursos_titulos UNIQUE (id_curso, id_titulo);
 J   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT uk_cursos_titulos;
       public         postgres    false    213    213            �	           2606    976920 $   sedes_formadores uk_sedes_formadores 
   CONSTRAINT     h   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT uk_sedes_formadores UNIQUE (id_formador, id_sede);
 N   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT uk_sedes_formadores;
       public         postgres    false    243    243            �	           2606    976922    tipo_pago uk_tipo_pago 
   CONSTRAINT     Q   ALTER TABLE ONLY tipo_pago
    ADD CONSTRAINT uk_tipo_pago UNIQUE (descripcion);
 @   ALTER TABLE ONLY public.tipo_pago DROP CONSTRAINT uk_tipo_pago;
       public         postgres    false    253            M
           2620    976923    cursadas trg_ai_cursadas    TRIGGER     m   CREATE TRIGGER trg_ai_cursadas AFTER INSERT ON cursadas FOR EACH ROW EXECUTE PROCEDURE sp_trg_ai_cursadas();
 1   DROP TRIGGER trg_ai_cursadas ON public.cursadas;
       public       postgres    false    193    321            N
           2620    976924 (   cursadas_alumnos trg_ai_cursadas_alumnos    TRIGGER     �   CREATE TRIGGER trg_ai_cursadas_alumnos AFTER INSERT ON cursadas_alumnos FOR EACH ROW EXECUTE PROCEDURE sp_trg_ai_cursadas_alumnos();

ALTER TABLE cursadas_alumnos DISABLE TRIGGER trg_ai_cursadas_alumnos;
 A   DROP TRIGGER trg_ai_cursadas_alumnos ON public.cursadas_alumnos;
       public       postgres    false    194    322            
           2606    976925 0   alquiler_sede_cabecera fk_alquiler_sede_cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera FOREIGN KEY (id_estado_pago) REFERENCES estados_pago(id);
 Z   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera;
       public       postgres    false    2507    174    224            
           2606    976930 6   alquiler_sede_cabecera fk_alquiler_sede_cabecera__sede    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_cabecera
    ADD CONSTRAINT fk_alquiler_sede_cabecera__sede FOREIGN KEY (id_sede) REFERENCES alquiler_sede(id);
 `   ALTER TABLE ONLY public.alquiler_sede_cabecera DROP CONSTRAINT fk_alquiler_sede_cabecera__sede;
       public       postgres    false    174    173    2441            
           2606    976935 4   alquiler_sede_detalle fk_alquiler_sede_detalle__aula    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__aula FOREIGN KEY (id_aula) REFERENCES aulas(id);
 ^   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__aula;
       public       postgres    false    2453    182    176            
           2606    976940 8   alquiler_sede_detalle fk_alquiler_sede_detalle__cabecera    FK CONSTRAINT     �   ALTER TABLE ONLY alquiler_sede_detalle
    ADD CONSTRAINT fk_alquiler_sede_detalle__cabecera FOREIGN KEY (id_cabecera) REFERENCES alquiler_sede_cabecera(id);
 b   ALTER TABLE ONLY public.alquiler_sede_detalle DROP CONSTRAINT fk_alquiler_sede_detalle__cabecera;
       public       postgres    false    174    2443    176            
           2606    976945    aulas fk_aulas_sede    FK CONSTRAINT     d   ALTER TABLE ONLY aulas
    ADD CONSTRAINT fk_aulas_sede FOREIGN KEY (id_sede) REFERENCES sedes(id);
 =   ALTER TABLE ONLY public.aulas DROP CONSTRAINT fk_aulas_sede;
       public       postgres    false    242    182    2525            >
           2606    977215 ,   caja_comprobantes fk_caja_comprobantes__tipo    FK CONSTRAINT     �   ALTER TABLE ONLY caja_comprobantes
    ADD CONSTRAINT fk_caja_comprobantes__tipo FOREIGN KEY (id_tipo_comprobante) REFERENCES caja_tipo_comprobantes(id);
 V   ALTER TABLE ONLY public.caja_comprobantes DROP CONSTRAINT fk_caja_comprobantes__tipo;
       public       postgres    false    286    284    2555            @
           2606    977267 /   caja_movimientos fk_caja_movimientos__operacion    FK CONSTRAINT     �   ALTER TABLE ONLY caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos__operacion FOREIGN KEY (id_operacion) REFERENCES caja_operaciones(id);
 Y   ALTER TABLE ONLY public.caja_movimientos DROP CONSTRAINT fk_caja_movimientos__operacion;
       public       postgres    false    296    294    2565            ?
           2606    977254 *   caja_operaciones fk_caja_operaciones__tipo    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones
    ADD CONSTRAINT fk_caja_operaciones__tipo FOREIGN KEY (id_tipo_operacion) REFERENCES caja_tipo_operaciones(id);
 T   ALTER TABLE ONLY public.caja_operaciones DROP CONSTRAINT fk_caja_operaciones__tipo;
       public       postgres    false    294    2563    292            C
           2606    977309 <   caja_operaciones_diarias fk_caja_operaciones_diarias__cuenta    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__cuenta FOREIGN KEY (id_cuenta) REFERENCES caja_cuentas(id);
 f   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__cuenta;
       public       postgres    false    2569    298    302            D
           2606    977314 @   caja_operaciones_diarias fk_caja_operaciones_diarias__medio_pago    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__medio_pago FOREIGN KEY (id_medio_pago) REFERENCES caja_medios_pagos(id);
 j   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__medio_pago;
       public       postgres    false    302    290    2561            B
           2606    977304 A   caja_operaciones_diarias fk_caja_operaciones_diarias__movimientos    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__movimientos FOREIGN KEY (id_movimiento) REFERENCES caja_movimientos(id);
 k   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__movimientos;
       public       postgres    false    302    2567    296            E
           2606    977319 ?   caja_operaciones_diarias fk_caja_operaciones_diarias__subcuenta    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__subcuenta FOREIGN KEY (id_subcuenta) REFERENCES caja_subcuentas(id);
 i   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__subcuenta;
       public       postgres    false    2573    302    300            F
           2606    977324 B   caja_operaciones_diarias fk_caja_operaciones_diarias__tipo_titular    FK CONSTRAINT     �   ALTER TABLE ONLY caja_operaciones_diarias
    ADD CONSTRAINT fk_caja_operaciones_diarias__tipo_titular FOREIGN KEY (id_tipo_titular) REFERENCES caja_tipo_titulares(id);
 l   ALTER TABLE ONLY public.caja_operaciones_diarias DROP CONSTRAINT fk_caja_operaciones_diarias__tipo_titular;
       public       postgres    false    288    302    2559            G
           2606    977370 9   caja_parametrizacion fk_caja_parametrizacion__comprobante    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__comprobante FOREIGN KEY (id_comprobante) REFERENCES caja_comprobantes(id);
 c   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__comprobante;
       public       postgres    false    308    286    2557            J
           2606    977385 5   caja_parametrizacion fk_caja_parametrizacion__cuentas    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__cuentas FOREIGN KEY (id_cuenta) REFERENCES caja_cuentas(id);
 _   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__cuentas;
       public       postgres    false    298    308    2569            H
           2606    977375 8   caja_parametrizacion fk_caja_parametrizacion__medio_pago    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__medio_pago FOREIGN KEY (id_mediopago) REFERENCES caja_medios_pagos(id);
 b   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__medio_pago;
       public       postgres    false    308    2561    290            I
           2606    977380 9   caja_parametrizacion fk_caja_parametrizacion__movimientos    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__movimientos FOREIGN KEY (id_movimiento) REFERENCES caja_movimientos(id);
 c   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__movimientos;
       public       postgres    false    296    2567    308            K
           2606    977390 7   caja_parametrizacion fk_caja_parametrizacion__subcuenta    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__subcuenta FOREIGN KEY (id_subcuenta) REFERENCES caja_subcuentas(id);
 a   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__subcuenta;
       public       postgres    false    308    300    2573            L
           2606    977395 :   caja_parametrizacion fk_caja_parametrizacion__tipo_titular    FK CONSTRAINT     �   ALTER TABLE ONLY caja_parametrizacion
    ADD CONSTRAINT fk_caja_parametrizacion__tipo_titular FOREIGN KEY (id_tipotitular) REFERENCES caja_tipo_titulares(id);
 d   ALTER TABLE ONLY public.caja_parametrizacion DROP CONSTRAINT fk_caja_parametrizacion__tipo_titular;
       public       postgres    false    2559    288    308            A
           2606    977290 *   caja_subcuentas fk_caja_subcuentas__cuenta    FK CONSTRAINT     �   ALTER TABLE ONLY caja_subcuentas
    ADD CONSTRAINT fk_caja_subcuentas__cuenta FOREIGN KEY (id_cuenta) REFERENCES caja_cuentas(id);
 T   ALTER TABLE ONLY public.caja_subcuentas DROP CONSTRAINT fk_caja_subcuentas__cuenta;
       public       postgres    false    2569    298    300            
           2606    976950    ciudades fk_ciudad_provincia    FK CONSTRAINT     w   ALTER TABLE ONLY ciudades
    ADD CONSTRAINT fk_ciudad_provincia FOREIGN KEY (id_provincia) REFERENCES provincias(id);
 F   ALTER TABLE ONLY public.ciudades DROP CONSTRAINT fk_ciudad_provincia;
       public       postgres    false    240    184    2523            
           2606    976955 /   clases_asistencia fk_clases_asistencia__persona    FK CONSTRAINT     �   ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia__persona FOREIGN KEY (id_persona) REFERENCES personas(id);
 Y   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia__persona;
       public       postgres    false    187    179    2447            
           2606    976960 ,   clases_asistencia fk_clases_asistencia_clase    FK CONSTRAINT        ALTER TABLE ONLY clases_asistencia
    ADD CONSTRAINT fk_clases_asistencia_clase FOREIGN KEY (id_clase) REFERENCES clases(id);
 V   ALTER TABLE ONLY public.clases_asistencia DROP CONSTRAINT fk_clases_asistencia_clase;
       public       postgres    false    187    186    2457            
           2606    976965    clases fk_clases_aula    FK CONSTRAINT     f   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_aula FOREIGN KEY (id_aula) REFERENCES aulas(id);
 ?   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_aula;
       public       postgres    false    2453    186    182            
           2606    976970    clases fk_clases_cursadas    FK CONSTRAINT     p   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 C   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_cursadas;
       public       postgres    false    2465    193    186            
           2606    976975    clases fk_clases_modulo    FK CONSTRAINT     u   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_modulo FOREIGN KEY (id_modulo) REFERENCES cursadas_modulos(id);
 A   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_modulo;
       public       postgres    false    2473    186    199            
           2606    976980 &   clases_profesores fk_clases_profesores    FK CONSTRAINT     ~   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT fk_clases_profesores FOREIGN KEY (id_profesor) REFERENCES personas(id);
 P   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores;
       public       postgres    false    189    2447    179             
           2606    976985 .   clases_profesores fk_clases_profesores__clases    FK CONSTRAINT     �   ALTER TABLE ONLY clases_profesores
    ADD CONSTRAINT fk_clases_profesores__clases FOREIGN KEY (id_clase) REFERENCES clases(id);
 X   ALTER TABLE ONLY public.clases_profesores DROP CONSTRAINT fk_clases_profesores__clases;
       public       postgres    false    186    189    2457            
           2606    976990    clases fk_clases_tipo_clase    FK CONSTRAINT     w   ALTER TABLE ONLY clases
    ADD CONSTRAINT fk_clases_tipo_clase FOREIGN KEY (id_tipo_clase) REFERENCES tipo_clase(id);
 E   ALTER TABLE ONLY public.clases DROP CONSTRAINT fk_clases_tipo_clase;
       public       postgres    false    2535    251    186            !
           2606    976995    cursadas fk_cursadas__cursos    FK CONSTRAINT     o   ALTER TABLE ONLY cursadas
    ADD CONSTRAINT fk_cursadas__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 F   ALTER TABLE ONLY public.cursadas DROP CONSTRAINT fk_cursadas__cursos;
       public       postgres    false    2481    205    193            "
           2606    977000 6   cursadas_alumnos fk_cursadas_alumnos__condicion_alumno    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__condicion_alumno FOREIGN KEY (id_condicion_alumno) REFERENCES condiciones_alumno(id);
 `   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__condicion_alumno;
       public       postgres    false    194    2463    191            #
           2606    977005 .   cursadas_alumnos fk_cursadas_alumnos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__cursadas;
       public       postgres    false    193    2465    194            $
           2606    977010 .   cursadas_alumnos fk_cursadas_alumnos__personas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_alumnos
    ADD CONSTRAINT fk_cursadas_alumnos__personas FOREIGN KEY (id_alumno) REFERENCES personas(id);
 X   ALTER TABLE ONLY public.cursadas_alumnos DROP CONSTRAINT fk_cursadas_alumnos__personas;
       public       postgres    false    2447    194    179            %
           2606    977015 +   cursadas_cuotas fk_cursadas_cuotas__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__alumnos FOREIGN KEY (id_cursadas_alumnos) REFERENCES cursadas_alumnos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__alumnos;
       public       postgres    false    196    2467    194            &
           2606    977020 +   cursadas_cuotas fk_cursadas_cuotas__modulos    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_cuotas
    ADD CONSTRAINT fk_cursadas_cuotas__modulos FOREIGN KEY (id_cursadas_modulos) REFERENCES cursadas_modulos(id);
 U   ALTER TABLE ONLY public.cursadas_cuotas DROP CONSTRAINT fk_cursadas_cuotas__modulos;
       public       postgres    false    196    2473    199            (
           2606    977025 4   cursadas_profesores fk_cursadas_profesores__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 ^   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__cursadas;
       public       postgres    false    2465    203    193            )
           2606    977030 6   cursadas_profesores fk_cursadas_profesores__profesores    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__profesores FOREIGN KEY (id_profesor) REFERENCES personas(id);
 `   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__profesores;
       public       postgres    false    203    2447    179            *
           2606    977035 9   cursadas_profesores fk_cursadas_profesores__tipo_profesor    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_profesores
    ADD CONSTRAINT fk_cursadas_profesores__tipo_profesor FOREIGN KEY (id_tipo_profesor) REFERENCES tipo_profesor(id);
 c   ALTER TABLE ONLY public.cursadas_profesores DROP CONSTRAINT fk_cursadas_profesores__tipo_profesor;
       public       postgres    false    2547    203    261            +
           2606    977040 6   cursos_correlatividad fk_cursos_correlatividad__cursos    FK CONSTRAINT     �   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 `   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos;
       public       postgres    false    205    206    2481            ,
           2606    977045 >   cursos_correlatividad fk_cursos_correlatividad__cursos_previos    FK CONSTRAINT     �   ALTER TABLE ONLY cursos_correlatividad
    ADD CONSTRAINT fk_cursos_correlatividad__cursos_previos FOREIGN KEY (id_curso_previo) REFERENCES cursos(id);
 h   ALTER TABLE ONLY public.cursos_correlatividad DROP CONSTRAINT fk_cursos_correlatividad__cursos_previos;
       public       postgres    false    2481    206    205            '
           2606    977050 ,   cursadas_modulos fk_cursos_modulos__cursadas    FK CONSTRAINT     �   ALTER TABLE ONLY cursadas_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursadas FOREIGN KEY (id_cursada) REFERENCES cursadas(id);
 V   ALTER TABLE ONLY public.cursadas_modulos DROP CONSTRAINT fk_cursos_modulos__cursadas;
       public       postgres    false    2465    193    199            -
           2606    977055 (   cursos_modulos fk_cursos_modulos__cursos    FK CONSTRAINT     {   ALTER TABLE ONLY cursos_modulos
    ADD CONSTRAINT fk_cursos_modulos__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 R   ALTER TABLE ONLY public.cursos_modulos DROP CONSTRAINT fk_cursos_modulos__cursos;
       public       postgres    false    205    209    2481            .
           2606    977060 (   cursos_titulos fk_cursos_titulos__cursos    FK CONSTRAINT     {   ALTER TABLE ONLY cursos_titulos
    ADD CONSTRAINT fk_cursos_titulos__cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 R   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT fk_cursos_titulos__cursos;
       public       postgres    false    205    2481    213            /
           2606    977065 )   cursos_titulos fk_cursos_titulos__titulos    FK CONSTRAINT     ~   ALTER TABLE ONLY cursos_titulos
    ADD CONSTRAINT fk_cursos_titulos__titulos FOREIGN KEY (id_titulo) REFERENCES titulos(id);
 S   ALTER TABLE ONLY public.cursos_titulos DROP CONSTRAINT fk_cursos_titulos__titulos;
       public       postgres    false    213    2551    265            0
           2606    977070 -   datos_academicos fk_datos_academicos__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT fk_datos_academicos__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 W   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__alumnos;
       public       postgres    false    2447    179    216            1
           2606    977075 6   datos_academicos fk_datos_academicos__niveles_estudios    FK CONSTRAINT     �   ALTER TABLE ONLY datos_academicos
    ADD CONSTRAINT fk_datos_academicos__niveles_estudios FOREIGN KEY (id_nivel_estudio) REFERENCES niveles_estudios(id);
 `   ALTER TABLE ONLY public.datos_academicos DROP CONSTRAINT fk_datos_academicos__niveles_estudios;
       public       postgres    false    2515    216    233            2
           2606    977080 )   datos_actuales fk_datos_actuales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT fk_datos_actuales__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales__alumnos;
       public       postgres    false    2447    218    179            3
           2606    977085 )   datos_actuales fk_datos_actuales_ciudades    FK CONSTRAINT        ALTER TABLE ONLY datos_actuales
    ADD CONSTRAINT fk_datos_actuales_ciudades FOREIGN KEY (id_ciudad) REFERENCES ciudades(id);
 S   ALTER TABLE ONLY public.datos_actuales DROP CONSTRAINT fk_datos_actuales_ciudades;
       public       postgres    false    184    218    2455            4
           2606    977090 +   datos_laborales fk_datos_laborales__alumnos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT fk_datos_laborales__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 U   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__alumnos;
       public       postgres    false    220    179    2447            5
           2606    977095 /   datos_laborales fk_datos_laborales__profesiones    FK CONSTRAINT     �   ALTER TABLE ONLY datos_laborales
    ADD CONSTRAINT fk_datos_laborales__profesiones FOREIGN KEY (id_profesion) REFERENCES profesiones(id);
 Y   ALTER TABLE ONLY public.datos_laborales DROP CONSTRAINT fk_datos_laborales__profesiones;
       public       postgres    false    238    2521    220            6
           2606    977100 #   datos_salud fk_datos_salud__alumnos    FK CONSTRAINT     z   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT fk_datos_salud__alumnos FOREIGN KEY (id_persona) REFERENCES personas(id);
 M   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__alumnos;
       public       postgres    false    222    179    2447            7
           2606    977105 -   datos_salud fk_datos_salud__grupos_sanguineos    FK CONSTRAINT     �   ALTER TABLE ONLY datos_salud
    ADD CONSTRAINT fk_datos_salud__grupos_sanguineos FOREIGN KEY (id_grupo_sanguineo) REFERENCES grupos_sanguineos(id);
 W   ALTER TABLE ONLY public.datos_salud DROP CONSTRAINT fk_datos_salud__grupos_sanguineos;
       public       postgres    false    2509    226    222            8
           2606    977110    modulos fk_modulos_cursos    FK CONSTRAINT     l   ALTER TABLE ONLY modulos
    ADD CONSTRAINT fk_modulos_cursos FOREIGN KEY (id_curso) REFERENCES cursos(id);
 C   ALTER TABLE ONLY public.modulos DROP CONSTRAINT fk_modulos_cursos;
       public       postgres    false    231    205    2481            
           2606    977115    personas fk_personas_tipo    FK CONSTRAINT     y   ALTER TABLE ONLY personas
    ADD CONSTRAINT fk_personas_tipo FOREIGN KEY (id_tipo_persona) REFERENCES tipo_persona(id);
 C   ALTER TABLE ONLY public.personas DROP CONSTRAINT fk_personas_tipo;
       public       postgres    false    257    2543    179            9
           2606    977120    provincias fk_provincias_pais    FK CONSTRAINT     o   ALTER TABLE ONLY provincias
    ADD CONSTRAINT fk_provincias_pais FOREIGN KEY (id_pais) REFERENCES paises(id);
 G   ALTER TABLE ONLY public.provincias DROP CONSTRAINT fk_provincias_pais;
       public       postgres    false    240    2517    235            :
           2606    977125 +   sedes_formadores fk_sedes_formadores__sedes    FK CONSTRAINT     |   ALTER TABLE ONLY sedes_formadores
    ADD CONSTRAINT fk_sedes_formadores__sedes FOREIGN KEY (id_sede) REFERENCES sedes(id);
 U   ALTER TABLE ONLY public.sedes_formadores DROP CONSTRAINT fk_sedes_formadores__sedes;
       public       postgres    false    2525    242    243            ;
           2606    977130 6   tipo_persona_perfiles fk_tipo_persona_perfiles__perfil    FK CONSTRAINT     �   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__perfil FOREIGN KEY (perfil) REFERENCES perfiles(perfil);
 `   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__perfil;
       public       postgres    false    237    2519    259            <
           2606    977135 <   tipo_persona_perfiles fk_tipo_persona_perfiles__tipo_persona    FK CONSTRAINT     �   ALTER TABLE ONLY tipo_persona_perfiles
    ADD CONSTRAINT fk_tipo_persona_perfiles__tipo_persona FOREIGN KEY (id_tipo_persona) REFERENCES tipo_persona(id);
 f   ALTER TABLE ONLY public.tipo_persona_perfiles DROP CONSTRAINT fk_tipo_persona_perfiles__tipo_persona;
       public       postgres    false    257    259    2543            =
           2606    977140 +   usuario_persona fk_usuario_persona__persona    FK CONSTRAINT     �   ALTER TABLE ONLY usuario_persona
    ADD CONSTRAINT fk_usuario_persona__persona FOREIGN KEY (id_persona) REFERENCES personas(id);
 U   ALTER TABLE ONLY public.usuario_persona DROP CONSTRAINT fk_usuario_persona__persona;
       public       postgres    false    267    2447    179            �
   h   x���v
Q���WH�),��I-�/NMIUs�	uVа�Q0�QP720��50�54U�Q020�30@U00�25�25�3�44�� �R74�2 !0��ִ��� ��:      �
   
   x���          �
   
   x���          �
   
   x���          1   �   x���v
Q���WHN�J�O��-(�OJ�+I-Vs�	uV�0�QPw�qTp
�W�Q0�Q()*M�Q0�QHK�)��B}|4��<�2�d��S��_�������FH�C$n�f��cH��s��#�F��v��Spq�sq�S �����l�3D�� 3Ef      =   
   x���          5   �   x��ͻ
1��>O1�*Ȃ��*�Y�D'�m��"
�¾?��Aҝ��8d=� Yqp��8|���8��'��%���r�'F��5�"�J;4B}�Z'��#^�'���D�o��6��V4�LiU�]�����!]N��Xtk۬��"�t�      ;   
   x���          9   �   x���=�@��_�MX�#N�4�F��� n�Ġ��	�{�'mJ��: ��խ������k{o�P�c��Y!��"<;��MI+K�����w3��6�8+To��)����_�V�aO"¢̈0���Ó�Ƥ+Iա`��8��禤�P�vJ��Gn*>�9�       A   
   x���          C   
   x���          ?   
   x���          /   �   x���=�@ཿ�*��-8��XN�K��\K-
ڢ��x���!��b�Ce����[یסo��><�s�//u�ңS��L�ړ�K����HU͔��0�Q�PPd�2�0�M,�b;�α&g$ڮ�הq���G�#�6@a�V����+6ڗ��%�B?�:      7   �   x���?�@�Ὗ"�
]��8�׳F��ܵ���u����oG�=������@6g��[U�mߕ]�U�v��W4��0��0�hR�cR�f�8<��!����9�#�B��i�>$_I��0���"�o�\�<,�HN6|�V�T;�N�Aq�Ѕ@;�81�}~!��0k/V�V�#�YE/���      3   �   x���v
Q���WHN�J�/�,�%�9�E��
a�>���
�:
�@�������_����BIQi��5�'�&Mvuq%W�1P�k�s���#�F� ��suu�"�S�!Ύ^d;��7�`L7pq ͤx�      �
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
qy�\��tc��*j�Rݗ,��)\��n�_�������,��S��%n���,`���Isw����;7�^:�t�U���c� ����N�s��=���X�b�x�^�V�1�������ĻH�2B�����Fx��(��5~�C/E��6��;�jU7�C3������䞶���f�� [�tMR�\D�S�c몒S�\�{�ݗ*I�Fp!���E}K�t�5���S�2�op]����x�J�J&�]"@L������?��hSH      �
   �   x���M�@�����Y����u�� �Ej�E� �n��f5J�N��0<�L�f�%�8�OP6R+�CRD�<�)A��6(���,뾳@t��P��p��ŀ6�3>����E���V�'hA�j�'B0�����ATƖ � ���P�j�;��ھ�T��r4I B�F�'ޟ]�.�'��P!>UX�vkq      �
   
   x���          �
   
   x���          �
   M   x���v
Q���WH��K�L���K-�O�)���Ws�	uV�0�QP��t
rU״��$N�PO��{��cH 1�       �
   �   x���v
Q���WH.-*NLI,Vs�	uV�0�QPw�*Z(�*���*8��%��Aºf�F&P�%�g
��(����@HMk.O|V��ʧ4+1��E��b��G$��B��ك0��<#]C�ɆDm�j�%HF[b1�h4 ¸w�      �
   Y   x���v
Q���WH.-*NLI,�O�)���/Vs�	uV�04�Q04�Q025:
f:
i�9ũ:
�F��溆��@9Mk... "M      �
   
   x���          �
   �  x���?kA���O��	\q�{��T),c j� �L"~��'���.����b�y��Y�7���Z������w��������s<����n�QO�R��MѼRT��n�z|t��5��W����I5i�n��~JO�"�W�[��w4��=�c�Heڙ�2<dƇ5�̦�^�f|ɳ��:�W��dǗ����^��_�l�og�A����k64�C� y*
Rl�՗u���=mT-ȱ�R����[+��E�S0��&pB�G�N�	����	��̉,��Jh�DV	�C$4S"���!���]��C�=2L��E��fCA��9L�Ct�hզ����J�C*I	�T�!RI@�C�H%�1"�Hx�T(�%RI���`�+p�BNP� 8!A�#B�H*��@<P�h�d�g �p<88�@�����@$P�pp�
gC�3(T:�n[��?�n�O      �
   �   x��ҽ
�0@�=OqG��B'��`�k	vl��^�����m'M�x_ M�^�S��z�����yoǻTx^��q������� +Ē�bc�X�llk�-bCز1"g	;6��a���'�8"�#�q�?I�Z�/�2��      �
   
   x���          �
   [   x���v
Q���WH.-*�/Vs�	uV�0�QP�wS��wwTG��������%E��:
~�>>02-1�8��YDjZsqq  � �      �
   ;   x���v
Q���WH.-*�/�O�/*J�I,�,�LILQs�	uV�0�Q !Mk... ��      �
   �   x���?�P���Oq7���458f���Pc!$~����m�w��3��i�K'��;�������s��X�e+vy&�Ӳ�<��6}]o�b���!�����[p�*j�*��+������®y���@kb� �ၖZ��A� �:j�.��;�������y`�6@b0 {����:b9����m����I�ʘ�      �
   �   x��ұ
�0�Oq�B�&M҄N
R�VW[���i�t�������ۮo���p���>�&���8��<�|���xiz�ɜb���B؜D�}���%��d
��c���p�,b�q�UL��>$�mX
�f��a؆(� @* ����Z ����: ˅��eY��      �
   5   x���v
Q���WH.-*�/�/�,)��/Vs�	uV�0�Q "#Mk... i�H      �
   F   x���v
Q���WHI,ILJ,NM�H�KO��O��O�Vs�	uV�0�QHK�)N�Q��񁐚�\\\ ��&      �
      x���Ks�F����)*�"OD�L� �'�dK��H����^6`nc�"4|L��[�uo>���q�m��/�H(BУ�YD]�-[�
�Y�Y���g�霍��	[%�|�o�2Y�w�2߱/��b8c���`?%�]�������>��y�]f�6�?�������|r���8?��w!bT5����S��=��Z$}�����>j��~{�#��f��6�����پ�N>g�i<����]�&ד�Q\L�lO}��͗���B����pF|��c���ç���=�4��`���C�n�"�\JMHb�}�I�%i�������e<��*(�����[�]���dƆ�jt;���٨?!/����ћ�����ELЎ���bD�1��_xn�g���F��6;Ә}�M�gz9�S�XD��u�/e]ĦW�l��s�_��t49�(,��zm,�薂K`\������p:������a#��]�W߀�X�۾��h���h9�h�l�`ף>�7��H+�V�ɘ-f�5Q��������� �\F-��\�aP�罖^
�}%�x)@�U[_
�'��l>����M��:a��;uY�%Y=@VK��E(O�V�a�9���D
%�V�K��Y!R-}|e�3��o�T�r���p��?ny���P�k�����'-aBiv��h6|��G�ZDz��)9Ԗ�"l��&��(�)�'��Ź�����/�A<`�G:֋�Z�-�U�%��˰�ӱ^��BY�x���)���ʱی�!O�����<We�*�F|Z������ITQ$ZogaHR�癸�h�п?[ܖ��>�/}m�&��1k�肆Zk��_LgbR�p�x��L��7Cv-��a�s�6{��w
��B�ERT%�hz�X����f�b��ʳ���l�N�'aа��)I��D=�n7xL)M�V!��]�����mX�E�_�?��b���kzF,��]G(�G=�0�=8�9h`dKv·V,I����M� ���wt�֌�i���9z��ӹ��h���G1���阺���С�&��r�����M<&�D�C��.��v��WB�v��\�:����.���K�]�q���p8��ZlC;g"]�i�#�t\N����p0�]  v�.�U>k�.�U1�l��ݯ�=ad�h#���U�6�P_��F�>-�QH��2�=�Ў5��g�x6/�I^�S_L��uш$�����P�Q�w��X)�`v=_.�ac��?�x'��<r����Y6���Z9��=�^6���9��5�٭G���,y�H�|����[j^��{?�:�jA�c�a�)����у���W��`�W��t ����2���mBp �j;�@�m��Uf�v����;v�Ͼc�}�����v������=^������1����=�*���Ɨ�.�&����8.i� ��t�� w�g� ��+�w�RFX������(t��G ,G���'��A���^��ќ08/��@|�sٌ@�{.*���琐��sخ��n ��;NSaW\��H\�*��>q P}<p�xv�か�q����!� �\�@�q�� �s��`w��,7������Lw� @ǹ���9�]�1��q��s �p\��
 |��eU �.�A�zU�V;y�ޝ���m.�@۸|^�ց]��Q��D��\��Q9������)@]��@��\V����e��y���)@�\�2�e����9M�y��T �U�ZX�'h�bTUB�� �u�#�?�;Rv2t����W	�[%��鄀�WL��G D�8��}�ʷ����~\�r��Bt�8v.3�VI~e X&:QMI�/l�MV�e��g���u�#�� QEf'}C��\�_k�_)Yf��a�~�eK�%��Fp��ٍ�0Ս��n���#������������������s��![�Q�5T�� �ɠ���] y���@p���֮�d��4�>�]�e��lۇ�.٬rv�-p�ο>�N�� 8'�_�;��:̫�IS���e�H��ױ�BIs�w�-Y�a�ꎭR6��ߦ��`|O�_e����� ����GehT�Ht� ��m�D�nj��Æ�e�ɿn��(�b�0�¢�n���n��2ȗ�W��R_��m�����h���)�ig�8�t�����;����)��vC����n�w�6_?���˟`5 lO���VY�j�ek\`?�ߜK0,a��#�`ni��2��S�耉���`�L6H/�t����~�u{("i�@�UL��h��owzVu4�o��c{�~���
��d�Ce�M�Mkx9�L	b z(21�3��V���x���n$%�brgo�pa(�� CM�G�ۣ������ �
�~��P���0��v���X�^1,���m���<zwP�s��:z�w�Xj\��cz����W2L���5K���Qh�-�FL�d��%�uJ����_�#j��z�=��'Z�˘�6CA������;�_��_/���rm��m��x<�ٍC�nkd�le�е����۽W�Q��5a��Ť��{��"TjpԺ���e#�������Q<�j2�?���K]�x� �r8�F/b���f@��s�I��:�F�ճ^
�n_�����-�B�(��
�nn\X,�l�4���4�$jQ{�� ��K��\/�%-��l��kSVi�3�v2�xݼ����������$r�"-z��&�<W%Wm͕E��Nm�m̈́�M�^�P��ȡ��u"�s�n����p�"h;�d���zo�&U���`�t�\��.���C�j39��7R�ll�)���4�B�S�,9 ������c�x��� H�����i\�R3fp�A��jJ+���5 ���mOX��JJśd�����ݬ8��#fq E-ْ�4Gq�咊B�S#��y}�1�?�!A@��Z ��gq�� �ѻ��+��9 �r���R�k%9p����� ����&�Ɣ���|:�O�./��B�Z)�Z @iU�|�9ߗ$E��i������ny��sv��W��d�p %��UO�y�� (jX�y��d˄M���`�V�b�	2d�*Ŭ���6�1���͜?# �`e����Y�Iw�
&�d��\�ب�{~`��*^;������O�WWy �n ���+� ��zUK�l��S��NTD��"�wt�xY0�m�[ �
�6�C�)\&�0=� G�PS<�� $��p�u����j�J����G�@�>/ �˷P�r^�iA0����}���r����{��9 )*�m;�_HQF/�����vԑ��<��_@Ee�t�Ш4U���a�K�ȋxi�Y=bی�>Ш��}B�2#Lh�F�G�P�
���!L�8���
�8�J��A�}�J�R�h����<wa=M9�tz{�Aۼ|�bڏ.AK��������v�1ه�bO��) 4�Jb		5���em����|��S��	�V�h6��FP�^ME�!�
�<k��a���.3f�1a煍q� �<��x�.³�5�����Bx���${���B�x��C�O����>*�p�,	�#|�����{ ����!��M�ʖن:S��P^C)��T���\�.����� �8�?�nno�K��Wn��<O��`�t��#�D������X��ɴ��]5��ݎF 1ı�ezL���h|Y�c8����Z���^�lpOob��dؤ@��%	G:�U1]��;g�cifm)�{��A�*g�jb�rI�	a�/W��;��i�����B@}5_��tx5�xɤ�N��4?z%� 	8E�z��H���.��ݽI�����W����o�f�4�4����ݡȌ<��i����k��S��T���?ęt��TW��e��:�S��$���OW9�k���}I��)�#���"0�hO+yOJ�������,�d+���'����رA���y��B��)P��0C �IE�RI mLE�� |  ��������D��,y�����j�lRzq�
��z�x�9М��@�Sx%:�U�-�@#U!��E@�U!��G l��jLP��o5� �
���a�94\a|�ƙ���G=��2:`̤_}�`!� ah�Z�Y���l�N�9�ߠ p`Q��.7��a���	ߚ����]�������U�[��ʻ&<
`�d+�&���  ఐ5��5�0�Bz%+@��@�3��?ii�����F �P�D[ z,B�	��i&G�J$�&��+y:'�f�a+��c�5}H��Я�����!�r��P �r�7,Cpf�F�ؾ���@�e�:�:_HW=
�S���n��}8��'W�K��l�lX�Ym��Ȇ�|��Q��
N6���-�B$G~�?B)w�a���Gh�n�<�0<`I���W�� ����VvJ�I�]�H�I����-��S�c�����۹N H�08���cTG�4�x�O�`��=��ף}`%rX2�_������i����G6�ֱ檿~�}C"���E�;m��a�=c]��i�!E������e�7���2xOw!� �Y�Ӹ'g��@�d�%�$�M�^��lG� �,�9����&#�� �e�u�)��p����d�۰(���ߦ�@��9���e� UUmx�����$	P�R��l��~	��RWNt�ȨwqH [�����=��bZ#{	��Ҝ�L~,
Ԋ��� ��Q��f)�+q%�5K�t�6C�5[ �,����b�_fw�d�%J�{OL����UfeʨǷ��G����ڕ���4��G;BxAX�ؤf�$�&���XdyEI$@'K����1`VL$�+��2!%(YF��% �eԊ� ǲ�F%��c���x� s,�~u ��e���^��!�@���>��|�G�z�~��P�d��e�����ҽ��d��\	0��Ԡ��r�V�&u\b,�;�ɷ$w@�e�=�d��� ��:~�t KV�ʗsv��۪L�Wm���9j�D�
T�wD��8(:�!+�w)� e����%@+�?������v{J�_4��� M�L>�l� PX��[[,	��*he��_e�J.��Y�O�4 �_�q, X���|�'�5�_�XE$�
���+�_\��XaO�Q��C���W��nr����H �U������=��,�&?��9.��t��7&�L��	?��1]��]΋G�}��(�ޫ����b���,������oSE	���:\$˟K��0>`�N�\KH�2�q��Ꮴ8����{JU��^%k�Pr_&�'���S�9A`^��  }����t	�U�m�9� ૎-�O��\��̔I��Ua3�]8���Պ	KM�#�`�X���̟��r�>��dWv<"�} ���9�/ж�/�,W�Ş%@����@쪨ޖ�N���K�% �ȯ7�*�{j@�*� ������W������}��7@��Y��T���e�d�_��`խ��$��A;E�v��Y�2�~H����Wb����k70��	 Vݚ;�X�(�7��&e��~~W|Μ�����'�~�N�smY"}��I�o�� �%G%��~�Q	��ap\Ϛs���J���L 0�dY�+z!=��$@�~۷H�
�N, ���P���,�.5"�n P8�J��T�kE[-�U 7��vQ��
`�C����*����8!YQ* ���� X8����ɮ�`�Pz5h
�s��TH+d�6�Fs��&#��*�'�i���!�[�\!͒�y��E���lWن�eQHGd��+�y���i߽zϢ��O!ݐ�WǬ<�{���v.�-�ޕ�{SN���;�'@hFZ�+��NO��Vm`��h��Z�V�CH\/]>��נBܯ��*���D!Xo׫w� �W�n���~��i_�����nX�ĒB�_�yΑ
�6�/+���<eъ��ew��j�o������(M�G��V
��U�����_s�8g�\��7���p������+�b��J
��à�wec�uq�V��2�Tܩ�oǔ/A`y�B�,�I��@����� T��R{�����"YV�
���Tطet��R 3�.��������      �
      x����r�V�.:��L�&��;��-ѦD��O{O	Q�&	H�Zz����3�w�u���b73H. �����!��'�˿/�W7�ɗ`x�e̒M��K��m�H�����vp�E*�N��E|ͦ��Ȓ�qaZ�?g�~��O~�nG������1���r��'�I�&Z.�?͗I��N�%��3m��矆�D4�jW�4�>� ]��/<
�A?Y>%��pBFL)�"���U�����,[��O���"`�)`/y���KL��"d�*�@0\G�x����ET�0��A��6-�;�V�,�K*|�>��%��o��%��N{ʦS�	�E�'�/��|;S�K	?�T��O�e�����a��M�!.�`?�!\����$��I��n�6T�qN��|�XB%=Ee���b^$�<�u��ӿ���r�����4�E�ٞa7��:�x]@�<��r�Ep��4_�'d��O�~3��������+�tĥv/�QZ<�ER������8��Nt�"�@o(�)��g 򗼘nᯏYxZdk��.(�i��q���ɷ�����0�҃��\E��1�����"/����<���5��.+�ɠk��F�F�ķȃ�u�[|E:�0!x��<M�|�tݾ.�_+"J�<E�n��2if��a���-a3�5�Tu?ey
�d��ᘥ��P[�f~����η�&Y�h(����Z1|V�E�ђ���s�HV��&[e5���=�hU>�F_z��a�☆n~��w��2�z-�<8�A��G[(Za�������Q:,�F������[��E�����U�n�H��v���_{�8x!���߸�%W?�o�Nd�uGD��Ўb<�8⇳��fE����f��O��9EI�������O����Q�"P�ק��x�Cp��� �ޖ��&�:bVP-��b.�E���f��M�H��jS䎤�{J�f�4�$�`B���Ξ�S!XtR>Æ��F�kO�l�|ʷ�E�����
P���L�����p+.~���2YO��m^�paG�?���2�Qc{�9]d���)->�$��������9�ʦ�&���$P�d�����V&��֝b�C�Q�5�K����(*Zl��xhXz���c $�ӏ%R�Lԁw$��s�zH�ܠ�V�jO|ͲFW�|��b?�A�dpņ��k�����&�9���*���i�0#oe�l��"�i]1ߋ�֦�"e� spP1�n������uvm���l��Aܣx���g����aK�<��F����o7�
�>d`�%  ����CE �/è\t���R
�|�������Wr�_���E��U�� #���!m�'o;_'\p�FpNX��3r/�o��5��U����|�Wgi@.�vm���+@�����;0}r P�#jGǮ��v=����VV3/}%����s6��/���AM4���������n9`ZK�X�ϣ�dҽ�t1�r�����%�Mb��I[�"\��-ࢨ&	l�$���� c��&��o������f����x��t{�f��?_����G����P:z�)�P�܂�ޗ��7�F��AK!T�^���2��}�	�"�0*��j���?1����6���e8��6n��?%��������n��bx�;�����:�:w��@���	װ7�^�m�$p���4G_��`�@<�����7�=?&��F�
�?���b���\��l7�|����f<���F��pԛ���]�'|ouR�ꪢ�"K����O��+):61���n�v������j�م�H��]<�\����d|ӻ9�N'�Qe+YH�y\3C{y~;�������,�"��1�T���A X�10��"�u��p�Z˄��r��v4��T�.&B��Uӷ���Q�nܿ�귟��㱌�CFpr9���+ �P�a�vzQ����@�b?��p�F�[�[��������M�N����.�g4��FCŜ��E��xt��U�Ͱ!�H�7�h����������wu6��KEm� ���/"Z���DaD�f8:�M&�o���(㺽V =���u����e/GS;K��Q$J���t��\��7����s�!��X��������|��ા�E &W�h��аB�G7�onA�����a�j�����Z���O��� �����䗃�am#�ȇ1D��~o2�O�pUUQ�	@ǻ�> r}��x�&k���0�:<�����e4��8N0�b�_�������^�X+D���;0T8h��V�ufp�%��4�"�yʺ̄WD�3�ĳ�G� ��j6����u$��Tt�D0.�t���~�-�!�7o�I\��t��axܸ�3���Y�O������s0J��EZ�W�^'8k' d0��A��~��qK�M]8?�A�_2��4���0�q\��kx$P��g;�q��@c�ėd�u�d�n6Y�c��a)Qm��W������4:��D�1����h|=���Xܗ(n��������D^�@��n�@�ƑƄQ,��OO��{�Ok�CZ��Zc�R���/��ц�e%�W*ԲI(�_D�}�Źb�~)�$��Z�!���� �p��$���7P�e@��w6�]��}}����Q�
�γ"��Wi �7��kw��C͜�*����	����J�h��|�n2 �F��;r�ȣK�J�=�#g�s�w��2�/�"� j��4�NӇ .����c�š�������nh�O�kS>?��B���i���r��(x:���Q�pDc q�0�<Y�V�7��.�����v�I`�//�H0�V�L�tR9F(�l��i�5�_.\(fCY�*��]�Ox�A?Yo�wX
P�#}8n��#�	�'�_���>-fۆ��������`����`~�.����c�|gc%�@��e�w�� 
�'̗i�º��+��	�Dky�,�x��v�e����&��?�܋l�����U�Pd�+�+ 9�0|I��6y��V�2�Z��"L$QRW�{�J�����+�
�I�������������|\������UB ��-
t��Lei�"�U��U=%[X�u�}��F{b$̃*,0U�}8v�a%�΃��A�a��$K���o���F�{I�[�2�\��
�F��A�Nf��UW7!��n&u�]o av��Y��Ց��6����p�ZH!bǘD��ȍ���٫h\i㻻Q�t���Xhն<��6���)�O�n�;�H�H�\;�D�BH!|���E���Y�"Xuӌ'��T�������M8@��c��qp���Ʊ���!Kf�S^;B��fZ�8����7���Ûq��=;,i��f�$KaV�G ��[xGp�k��Ɣh�p�����������V�����jJ�)�����W����%�w��*UP0�������:8���IE Ą�`eJ��|3�2��/�W�nW�(*>���K���'�Qp~;<{;ksR�B��չ�h�)��0����Q�n`��Þ��O����˺�T�W877�7	�ad8I�.��������?6�����&_��]l��#�	��֜9'�0p�&8@�C�G@��4\�s��l�GA��P96Nʠw6�=Jm=J�:d�8��k�?��,�D��0>y�N���p4�48\�'� ��2���MQ��`bmj �;�&��2{�0�o��3l=����<��A-��T�7�HE�F�I�Ԑ�+�L����s�f��)[dO��=e��o�ozW�O�����b
�<:d;DG��#�y�8�:���{���[#C��G���6����!�o���w��eV�P��<��$�y���5���B�'n/$��σ���/�C`J�2ֻ��>�7����hԸ�d����*��uȀ�
CM��K<|g��W��R
m ���u�K�r�K��I֤�[�F�ڛ����;��Ja�4w��%�������Z����x����Q��,(z?/��M�������T���+����F ��&���    !
�uػ_���E`�������w=CUOz���G%��|:��q���9F��*~���Q��E�퓟
3'�م�?����vpPъ�8���V�Z靆��IMM'�[�-$@<�<�|�eF���"��CI�|r���E�|�1u�qP�p�#��?O�4{�@1a9��!0*T��!$em' Ƨ�#�S᧣A�r�m�Bo�7*���~h*7�)��C3YV+a��c�[�t��^<�w�]�U�����,H�����4b����
J��uG���>�U�ݺN���A��9�_ܞ�~9
T��3j�ٹ쁟Ӆ�+B��$}��t��ko2�|�_6R �*����s<��ϲM2{.���|.�! ?�St�o��8⮪7��fa蜘�A�w{�@~��R6o4��tپ�M�"2�S�C�����՝��H���C,C���_�ש^)�(������zP����$h.ۋ@��ˢ5s�Ppf�aw9Ά_.@ɟ�o�,6��eG=���v�������q)Sה��'��h!�v��X9�����eB��M{�C�t_�}0�� spV�Hi�p"+�G�7��.�k�c�ڗ��v�����IM� (�A��P(���\b��e0��K����ٗF'�˥i٩Q��>=�RX�5�_����&4�*�\)j��{t��[s+�8h����~>��A
-��� 9��eYI��(Y��5ĝ���&8�(��.�pWIc�U�K��C�%��ˣ��Q����  ��z�;Af������EE�<P���Q(]�RF˺���a����u�R��o��ri�����JK�y
K٢�3XF����[{��d,�흎Oߨ�e���� @�}�ư0�'Wg�j��6}.<���1�ש�t)���KE�tUdۦ���JX���C��ֻ~�E9�P�f_j�#0q�Y��g�X@�i4�:؟k���#DqXLY���E�jt���Z��D�KPv(ݻ��f�|=M
��8�8.�y,�y�&^1�g�A����Hߵ!��#��o�qK�0� w��!�m1�D�����a�kM�ϲ�pT̞�����6L|�R[?����9���j�M��'��gƛ�\�1���Ҽ䤩OD�e�x�jjn�ȔG�������\�_z��z�!���S^$��h����6��P0�e�uSn�r:�0=����� �-V�yEj4;�N�4bvX���#���]fp֖O�|�u\�����(����dp>�[�e<��Q'�o�^��
ke��ƠO�c$~�	���H����`����z;n����덮
�H�]�Z�������O�:��%jɩ�"�%�9�Nc����t��2\��"��s1���)_'�d�55�*=S���{8��cVB�,�j�3c�&��y7�3j$f脅'�P)$bt�@�Q`�n{*Ʊq�%�잎�_��"��'Zx�!
����� P]��s\`X�}�<T��\����/{a��](¡7�������񷷥r�7���й��qw48�~�pi=�h�X��{���>*h_���N&[l���j�����A��'�;TX
p2�M�:�kč�3[US���϶7�+��~�C����G�-���A�����ƪ���! ���FШ}g��(�@﯍&�f�̳ЕX�_�]�w�|3z$b)ʿ�5�`�?�B2�B�i��j�l�dM���4���~��5`B���-������H_A�����������
	�6�'�b���=67��<�lIO��n�{��׍��;��ڀg��23�����k�}��_ jU}+c�6(�ֲ�ѼL��*Y�b\��'�u�#������.cvdl"^j|$ ��-�Ӵ�e�xKQ. ��>�i�_����W���k�<�{�?ƮF��V���g��y/[Y�A����#'�][�\r��P;G�m�˶�w|C-3����gRxl+�t���o-�d!����lp�xf�gT�Bĕ6���$��:Y%��rj�U��-!��${ڂ"�dk������ ���v�3U堒�U�!�i^��$�-��~߂��i)������l�Q���߂�tZ��#���9.���wԴ� f�9�i*H�ۋ������	�uCzjjj}�̐�0tp
�?ˑ֠�MכX}6�x"%0�Ȝ(2��w�Yo��G� <��B��y���2Y���*��YXOұr�
�M���Ă�"a�vg<��g���|	W|���E�� '�CL�4"2»C��h�x�9��l��5uby��v��}����l25s�����\��5�2� ���8t���H�Zg���t�c��*�!Z^l�y��^�C	��=eCO���1)f�Ʃ���цW�*P��S����ܺ<���ľ'�r�ȝ��o9�~%�J��S��=gT��4����.�|��&���ڷ�$yN��+)m�2���Զ�m(�:��l�n�/��c�9'�l�N��t��cV	o�9v*05�T�m��t�,u��žG�X =�K��C��G25����Q�u�ۅ�\�
.�����}�u��6{J��\D���?|@���\^���|�E��۟���whj��N3b�p2��(Wȏ��ݪ�2䊼n�
�Q�f��XG�[��ז�	�^��]oS�62�w]�CW��7=���Tj�j=��7���E�6)f��tV�K�p5e {�5���a��+�Ĳu�D����L�X4	��,����u?E���𻫚�bΒ�jYI��� m5�f�E��D�����$ww���	���v�&�t	�,���0���pߋ��^�ݏ�N�RJw�� ���t�S2K��l�!�`�-U������k\��4�fhK�'#]%��,=��m���E�/��P��ƭិ�ZKQ���"yI�0I�����ijE�E�\�ۿm��߫����A��;�Ik�#�>]�5Z���X����=�b�+&U���肐�t/��l[R�F�����	ϋD����_�;�.)~T툥���2Q�D�7y�������o���U��w��$�`�H�QV(e/��� �!0�aȕK3
V$�4��>E��k���%D���Ӽ�	T�y�C� �>�O�X8@�|��,_<�����~|�Xa�5��ڮ��x|<�1S��sW�`���0���6j,�hA����{*:���>?m`W<�`�v��?w��'(�]�t�&|L#7��2���zP�d�*A{I$F�"D%�����i*��=�p'����dL �o���߶���[x�d��٭~l$���:�-�(�?�`{������Kc(���0%/��oG�����F���G�9����P, ��y�؋�g���~J^�|V �x����T��n�6r��H�b��M��i[��c� ��n�H��|���	3��Z��(�d�%��@ف�0�K*w��:[<cJeZy=/ʵ����I7��xr�C���P������߽����
H��6�Ϥ��-g�%��Q�k�f�Td���,G)0>�����R���2�ڑ���O�5֝���F�ύ�!���V�S9�
K�x*�F �)�f�DNB�iK;� MTb@�g��!+�b�֛�x��0Pv�3`$d?A~��T�6QĊ�ӤHf��ly_���7� D2b�<�ZX�w4��U�A&�r-��%5%���1�ŮW�	H�*U2"�R�c_M�I��T���ρ������k�I�O���2��;�����D��昃s1۾�f�6�K�I\y=���h�^0�"��0��Aɦ)��Zq�Z��ȳ{J��kCJD�i��&�&����N���� �C��zϥ���(��K������{�C�<� �R⠚�X�}�P+p��ι�[��G�J#���9��,�X��2.����d�N7���=O�t+�#td`�0a�����c ���&�ʭp�B'�S��7�O����l�����I.U�}Òԭy��i��0�I|����r���f�    �{�W� 0Rʱh;�����m�������9I9D���Q���IVJD�7�ZPn�UV-���	h�4+��į�����xd��$��)��_�o�NڠL�D�[�eP����9m��)Pcnvk�����z?��u��u"��7�3�H��3nO1c�Ba?��}N,������DS�ZNO�l�Xr&�|���������kt��rzEh;m�`��
�p?Y ��`;�V"�w��_�!���R���(��4�	_Pf�H�����M
�ݴ�����qY���BW����C�!��}��?��� 9=5��"=�E��4���S^Zяk�e`�'o<OSlu�Ϋh�敂�h>�>�T����6)�ז�� p�a��S�gt~�st����&����:ٮ�Nb��E��i�ǽ��h�qP'6.m�[�V�l���W�UMT�}W�����(��é���`���/�Y․]'�<d���<U���[��X�x�m��sC�a�8e�t$w�j�l��M]�K߀���%��}�޸e�����X���2q._$��_�զ7y��i;�1[�`�	H#�������sy"w@gꝏ�Pr��n�H���}�6���Qc+UY�xR���`�eq�j��kc�[�Ӽ��O��׬�wK�h��_Df�l`��W���E�*�pBLU��n�(N)�5{�������yG;>X�<�GJ����������?�Nz����qQ�j��Q��N.+=35����EZ�np�η�1�������N��ʨ�''�&]*���2�#Z7���S�I�����.мH�x�b�%�X�������u�b�"�;{��J�~���\U�������K�1X��M7��!�H���t.أ�Bb����w"��P�sXb�&唯!�������#h�#�Cl�Y����:b����ac gv��(J&g;ky�,����x��U��yPGW�1[�����_�eT��}X|<��5�"�l7fV"{v��x�
��JW�>���[��-�gX���F[�G�1vǖ�#�dp��܃� �4_���@a�iS�1���������L1�d��s�^@���[����'�67�5Ȏ���X�e���Vy%k^���ԥ��>P�����ܦ{Xۧ�����'���^;�|Ec��c:�<Z�!�C�	��Ě�5�w�U��mJV��YJ���� �O�>VT}��]��U��;��aNT򔮧isV�'\���/[,rpH/��#���Ȋ_�~?��G���C�;F�df�|�}J7o��*�1u�N�`Ѓ�y�<ى�b�=��旯��p�f�������Rm�C��\�JF�v��9�	G>=e�j�݃7���,M�נ�8~}��� ~Tᮕ��u2�	�]�vV�n}��}�WӺ�<�4�͐��#`�wg�xA�&�4��BFz�����i�@��^�8��"y�ƈ��E�M�P 4x��Q�nb���74h�r}�M�N[��t������jS�P@j�|����Y��YP��:�ㆪ�S;ʸ-��$Y%�v\��Gy��h�T���w�֕,�ܠ��(�g��m>k�׿���o��Z�1t6��
�������Շg�"�b���k�暑�E�P˃i0�<�8D���z *�`��V�8�8�}��4�z�z���8~O���%A@ʱ���o�w�Q$x�V ��ttmȤ�{��j�<jT�-���"������F�"yy�L�6��ߚ����BhW��o��鬺���Q3Q[P��1ꇲv�e���\�:Jޤ��5�|˄����j�Yh9�m2��E��U,G��ɮ\�
�e��8ڑ�"ZNUO\��7I�w�>	ܷ�9�UڷT����^b�\������)Y�`�;'�>4�5/`�:���m�W��>�"�^�[�l��>��%�'�c���3���g���h����ϲ��Җ��`��bY7�s����?�����t\���3S�J�"C
�-���9��RZ,
[��h;kw|y��2@���x\-��%��XC9 ��F�p#B����:�1�ȋ@���4�y�H(���Bn��*�k$�h/��/��aW�?�m�&��}
Km ��T�@_n'����ac(5�
֚CS;�����\�V}ir��4'�A�9�b���7_�û�˩d� ��1��c�H�����ͨ7����=��^�#ˁ�H?�!�����FT�Qy/r;��R��ѠιkI���Z��NmߑY�r~\�����ۛ>!5�"�y�`�墶6�D����È��O6Q2Ca���������+5��㧌xk�M��gc�c>��=!5-�SW+=������O�ͭ�{�ZC���Cb�}�W_��9��mv��p��𯷃w܄垡{��tj��}sh7�PPR�1���U����s��|�;����Ǡ���G��t���G�A�&�ts���)U̱�ƃT�?O~��~n<1ak.8C-�_���2"5��x�>������ԥ�C� X����c�VcI�CT��nQ��-,3�:�%��6]��=I��d��wFd�}N�Ό���B��r��-�:�*��;Y%�>�߸1>V�N^C�m��T� �A⣷������-�-"�)��f@i��0�v���ϰ\��޾�cQ(��Q�넼�i�>�����ȋ,�h/�&F�����'���)q��`k�;�7:�w�G��a�4��8Ő�D���Y�����h�_���:}��J�"h�yt��$�A.'~�wu>!�Ɗlt���9#Xp|Pu<��p��H��	Kn���l�-md��1�q�qd�Y�~�PM��ZD�de�'�q�r��4�����d��f��R����h7]��}�(�e��Y�d�������?��X����Q�)�)B��6؟k>��pՅ;�eATu�d�/*��2�N'�0����Cg�L���5E�ui��S��wi��t^'���Pr�]���L�X�n4)��.�����V�Xˣ���/������ YT���c� G^|��d��;�1��
�cdv�����Hv�G}�~$>��V�<�������d��5t��ǅ�hw`��Lz��?�>��NQ��e�� Q�4詋��ʝ�������=h������T��)+�Z�d�=���t�O�1� �<��5����q��a����̦b��{6��ExCc�"~�~�����`�;��<v�����k��ӆ��ֆ>8���r0	>� ��?r�q���2����
�T'OҎ<�uK����+	 3��J�7�� �e���c������������n�75�a�L�>s����&���q�Bf��@�ث��Q�D0��{���ܞ�M�[޶0��/�ɥt#�p��`.��>�(�X{�uC��t���r�=O �HSo/>�h�(A��&[����1��M�v��EH8�9HT��^���Ȝ�#��O&M��f������E�}�^���[�a�e���A���:>�:xY܇5�<����P@��mgɬlw�N^�QW~�ngF�p6�������5A���ۊ�}(:��@[`N4��SY����r[.��DM���y�����T��i��L[��(�(����D�
�Y��]�ok��2�L7bGFd�'�$�0��~W<��)���
��Vn�$�2�Q��(�,�1�N��?�������%��b܆G��2jP�a�/v����:�1z��z�����6���)�`k�c��0V�ۄ��l�&�?���t�⬚g��!��"�Vi�yHI�L?�8xq�G✬`/�����5c<o���"�O��Vܿ������X8i�e{v�27vE�2�sEjV�	��q޻��߉�{�Q�_&�m�n�I�!�R[�p�h�x�qd�u���F-�9�j�3~4C�p'��� � �-a2���I�좵���1%�H`�r B��u,���qc�F���6��=���y�6�f�����g�s�d�:!��J�[c?���)����s:��t�b�t�$�P    56.ɰ2�r�cG������Kl��8O{C���H)�4��� �X&s�\��x̤1͎�Fw���������nj
��RU-5��A?�G���:i��Uy^�t��4ꀹg?�� с�1a��?�+�b�($7e�|��rbEx^d5�O�-�,KeDӂU,���6+���0%XX
��
Ahɻ�O�^9��\�"AC��X� �aF�����*��jZ�>)�_dk�j��'9����v����dS��md��S �N�%�o����-b�oU�<���YZd]��9_<��<9�������1@��}Xd��zՁ7�iP�����""�7VV�|7����h�nҧM�.��S��)*��Q��ږe�-3��H��|�-�x�N����^��U������X�s�G5_�]E���dx�4D걻U����q����Y^$�Hp�-�6Gx��j'�c�R�D��cV��;��ط��� Ϥ����o������5��I<o�ʜ�?�%#Ŏ�+`�W����m�\N�.�S�	�.C��}K���UWs��[��>1��-��{D��.�j� 7Nw�.u�]�4��h(�z貈-Ma�n�#/���"�r>j[V��#�e�O�\�����'��Q%� ��&�=�~��5��# H>�;���������g'����t�O�]�L�E��:���uJ��wp)r�gOɦ�j�d�gς�4��)\�*8n�@?͑ռ쭈 Y}�Q�-���k<?gSD(�,��yTmV�wiu��!m�
y	�#�ˇޯ�p��C��ah@8G��Y>`5e�%�O�Q���_����N��e+�Xбa������eU��W�Fe����֨
�}h�,�@�8�������	͍��N�.�oX���ԗ���9�bc�R=8y�}��m#�K>�����S ��b�螦��)��J�Y �h�¬�6d�^����p��-�m�}ٓ1�P)��Ͱ/&�:�9����k �_�RU�&�3�N�IJOV{C��%�T��=7#�%N�F���Nj����}�� �3��Q��R���V[��
��_�)�kz��t�ZE:@�q�h>���������+�DӐؓ1�P���J%ȁ!��) �-V�i�0�-����֖��n(T�g���2yئX�,#L;��4�5���'o<���_���>��|.��)�9ڿ��رE-��c���Ĕ��ݯd7_l�0��ot�Z�'�3H�QS��H!�V�P���5y����cx�
�� �z�g��H�������j�"U/v�2��t^�-i�1D��	��_�ʳ�b�sY�j�D��U��K����"L��u�9Y���.��{�Dē��P�������cWS�v�D�Q�MQ��0Kڗ�"QD}�|�m�����p�xL���o��/�L�v�拌�`��I*��Ӯ����SJ������i�y��`�o��G�:�T.ѧ֤�X<=J���wX��F���.tNr<��ڟ�e2O��:�z�j��>͋h�ǔB<��pz NC��0��T znix��5�M���ƶzo�DM8����rO����G�cq:�ʸ��+UD��}ؔ�1`Ԑ���Q��Mp��pR��?�0@6��>[�:��PQ5�!�� Y�m��G��bQ%���)}�n�'u�1;��Q�,�8�c�e��%H�k����;�zu�x�k�l{�s0+���j���cv�����:��X[d:Z�ߒ���Xzw�����k�L9��o�Z6�U���4k�T}-p�t'f�l�b��v����y�1����<I�J�#'���*��qqUV��E�����ɥ���y�D2	�d蒭�=��p�O	�8
�|�:���iaH��̓zks�y\��
��>%�l���M�!���!j�@O1�gP\��7��/�_�����֠�ɜl"�+��2�S
>�6v2C��*h�w �����⠼���x �ԏk�G�y؄��c��ZZ���L�n��2��R��"{b~v����>�Q���=�� ���X�	�r�<t� c[#�֞\[�*��v�$F �	�p�k�6{M  (��A��� �:_%Ӭ.��D�tZ$�~l��.;���3_���'�f���(+$:p5�Ho��I�{.����"�)���h�]��L�N�]��8Ƌ�\!k��@2=�`\`0�~h�nOC���g���ڈ���O��>h��7�LERQ�pc�����q�V��a��vx��ɣ���1�c=�����# =�L�����`q�����ˎ!�����|8�R�|�\�:o����6�T̩�� A�+A��#6u
����Ab1(�x�H+�c.�b��0	�}���Wba�� a�K ���$E�>����׿�/j��x��w��1أϓ��8��ꝷ
�X�}	����L����ϣ�]�79ߌk���Ij�C��$B�}߃�]��׽z[�[�,?ԫG�����z�g�^�?%C��J�e��j���n�L�vE5ڻ�<��`��"aEݤ� �x0�`_o�U[8Cۥ%[��;��9	ζT08�˳�,�I�v ��R�
y*x��0n-t��t7}���,B�`'�}��qP1��ĭS�Zb��n��]�:�r`=�C�~L~mK1��WlK`��@��D�#��"�S�$��}q �S���M�����x��5�-gd��Mǻ �@�xo
���>٤����p�<lD�����ȹoq��o"�O�"�$mt�X;�rN�i�=m�[�Y�Q�=x��D��r�	�s�ɖǧ���dy8Y9����N�r�z� ��`Fv�wB)�ɏ�4����"2�%����\'������[���SB�<�β�c�����g
#j��c�� :���8� �d:�r��7�=���^�ɿޅ�Q��{��8�.��)� �%�4������D�KɁz��R�O׀�k+��SD��?����H`�aή�E��)��Ğ�=���%������QX�bI�������o��+X���ם4�$������Li�  ^�q��eI�u� O��a����Y�f���7VyqO|[�2��/*Q��/iq�,p����ֆ���F�n��-
�c���� zjMf��b��ɶl���e'��9��aVy�՗�y�35���%����������rrT��QO��U0O��JCCY�?�T�6����d����(wV�T�`�O�U�2O�MD 8H��>,�pQV��
�Ǌ�w�j8�sW�)q<���Ы>?���>�"�zU0?�;b��[G	b-���Cc�t�"T%9FG�F�f�}��5Φ����T���ۇ-{ܦ ��E[0�Iǣ<����פ�o���&˔���-:ǔ�3��#���472��}Yz����sv�l�P1O�ɼ8O��.�9תK��Rfv�$����b�vO���j�݅�b��@am��6!7~���g*���u���ݩD�"�=�RbW
xFG����gp�X�\��4�le�J��+l7���?;�7`Yt��<,1i��
�dtĭ��^rQM�0�Ұ �Ť���~c8r�UJx�30�����3(+Ao��x�ǹ>Θov$�������M��mQ�s�%5����ѥ�ٮf��W�	OԈ�(՜`�&�����ҽ5�̢V��Ns��6;��gx7"V�S����1/�Ȱ���3@H@@G���N$8keT��>p);a�8�d�Ψ��V�Yq;&Œ����I4��Z"S�S���1R�5e�)P�5���3�c{<e#�'����ՅS��������M�����W?�ư�Nfp����ߗ'�%���������3qGĜ��#�©�3Lq�I��ʓA""�sB]7I��M�aq@c;B+cB��n�j���L�M�=�81"8�d��{{h4���t���o��.n�F驺/�&��}2�J 8b7�#8��J_�ͶHv    g�Ʋ�El�ttdh&���=N/Ϧy�\TxVnEĜpj�	/��ʛ�v2�D�r��&iٟ�c�D�i�oA�w�8a���=	�#"R�L0���巨,<@(ǚ^�,C`�Cc=�ʢ�i�R��i���`g��� "�B\a�Zds�a�\&7���Ƥ��>��x?�)<�V�c��ɵ�,G�Ů�\���y������<�[�&�b/gZ��j�(/C�3w�����n`�yC(O�J\g�&9�BM��
�]{�����r���uZ̳�G��8OSG�.8D탽�}TF��6�L�8���z_������s�dD����{,G �!�>��w"��@�;���q�;\17��j�.g !f���Čp���Cd*d�
����=.����HFt7C6����=͛,KȬ�_���������^�N�]��,]&�MZ[AO�E����?L�㚢��$ �Ňqڽ�����;F��0Ԭ9l����F�N{5�F(�+��ҽX �# kk"�$1n�o%�������y��DD�P�5؈��8�D�jgfpL��f�𡵧Z��=ўj��.��G�A�����P���Z���aG�(��-�HfE�e}5<GEvx}��ˢ|�]���[�	�0(��V+�ᖟm�_��X�縣H}8�䐍`a�d��*��l����!���P����ԭ/ ��P��e0��G���?]��e��1��,}e��foO�A�횑� /\^���z���b`�P�x*^e�gl�! �SS��"�ηi���-&�sN�t�#$8�i�-<M7�,Yw���!��� KM(K�2���`W7n�q�h���	\Т.�m=6�[�a�=bF���5�-�iT �qG��m�1Nr9��Ӊi�Z�R�DpyryE�A ��2Z�=�P;����&��ے>�-������ǘ��e�9@�ׄ�A�)G��kb�ӱV�Y��mK3���Պ���>o��dq�aź��;����Įڥ����71�϶E��֌PQ�E���.�M~h<a�X�D��1eJr�.F�3c��v�7N���$�>����f�[?B;�=�R��NfXס��Y�|�Z��S���t�ݝBOHE����5�������-^w�F�(�4WB�JN�������m�#m��+���Wz�z�d���`W�&�w��aG�]/tG!薕^�eBt+`۟���*���R%ʁ�m�D1��1֧�U���X�
=���!���zB �@lw�
q�~/0�EpE'�zWڦ���0w^�4ũ��%o�N�I8�]�X��,0V�ÑBF'XWr�����i�+�`�N���bذ�rx�rE�͂�:�.��E��#țL�]Z1�E��_��t�?gR����	�ԤvJB_�;��^��ё�MZ����f�9\m�F��i�f
(u�3n��F��]Ab��2�5_m�y,kD�<<�";l޺�Q�<�`�����,5r�[��l�.����	7�.bv�a�3B��{h����"��:D��}�ѱ��:�ˇ��>f�i��&�h�`��o����\Z� ˢ��d�B�p �;9t��{F�~r}K߈n�|�Cx�U�����9�o���o���f�h�9|r�t�|�5{ah�qZ����ǣ�[�u����GX`o��0E���n��*/��y���-<#j�}i�}�|=U�R ���Ҕ�yr���u-��X@DgE�@`k��H�{Z�9���&��[`�.*�Uo,��.&v��蓊XO��m^)�D���_����G��]�֎�q�?�莮�a�ݹ%S���J��ϷR�X�7� Q��<���#4H��J\dE>o0������Gd@m(!���ҳ�4���w�S��u`i4m`��F��g�*�������D��N��"�XVky��L��\��Ɣ�ey!���y���wBQ�3p@� ���O?_��l� )K&"�v��o̒����) ą�I�b2"�ܮ�,CgL�@��)y��A�-���"�ރ��o68�<�Dd�܈���W`�(�	��F�qA�v�^G�J��p���1�D��M�yR�F���l�t��#!e椤 a�:^C�؎ GwBi\
 ��]�Zo�g䲩H�[�d;D5Q���3P�����uX�'	R����ꥒ;�O��5��|�Q�2
��d57�f���̒�m��������!������5(x#�	���s6�η�uބ��U;Ѯ��2�����C�w�gۮ��R�|y�;�Lu��p
�X�H�4"om���Ś�{�=�Vl',�L���Ĕ��㕱�w\�&�T��n��*�C������^} J���7�JO��O�:p>X}p`D0�h��0�nӂ2�&��=�!'�e����;�C�&v�;ZqK�r&��^a���C����Ļ�PD?�DJr�\�3����A�s�F0���Yz�MA��=�>�vg�.��H�m����.�<�g���O^R��D��E��Wn����W�۽GL֗���v��`�)l� ���xU`�n���}Ǝ�l�f`� �6X2=c�2�*v�Xk�O�F��.	RE>�yN<N}Ec�H���7C���)�F�*UI�Tx��G�~��S���m��`��I#�,2�n�E���6T�g9�>���b�W���d�`�1�,; ���{�A�K�� ��ζ`Pf��a�Z#r�9�*mY�M��g`�CkW��i�H��9��t�a���i��gPc���#Q0��;�"#�<|'�F��n9��D7M,�Zux�fb��\=t���Ɍò����p�>�0T|G>@�#x���
���J��~Z?eS/�t�£��9��M�0,\���2ݸ"_�S�r���T�o�>K��CUu���.�oy�f�}xY�x$Sߵ8V�ч��kleMd?���,��V�]�cgXwbNl��T�G�bTR"v��c�-�ʺͬ�g<�F��N+B���WDp��VRw�j��[�k.�'#AL ��%'&�Xz4|pӱ����Mjl��AIl���m2�f�*�'oNL\ ?��j�l�<'d���%E��x���+�,��>��@�r;n�x��Ȭ��|�5ڏ����e@?y°pY[�����̈́��J��w	r�����d⚺{�"��ϔ7H�y�YY4]�`�|}���w=��T����o}�B�i��ܓ�4&j�/bq2�G��|W���8w�r����H�M:o���,���W��EoWٳM�`�|;>��,Y* �Ѯ.��3�2T"�p1��D����>O�L���g9B2;��0�[�]cS��ܭ��ľ�U���1X>$c
�*�������k����L�
N�>%����e[~ϖ�*�{x���Y���3���^u��Ye�A��n������ٵ�x0M�,��E��^yNB��e�Yl�\���j9Y%��KW���*�*(1
�+M�4���N��}�D?�TH\�s�]$[�s��5"sʳ�$f%c�Y'8��Z|��oY�o?k���}|ylR׀�Y^IÙ[��܁�j�3{��DF����f���$����x><�l9�IM}��,T�9kwݯʳ�$&�1("�f�7��e �0�7ܪ��?���q��[$�62�XRCM~g����橮�B`�����''wì%��1�����:��3]u��^Oh]��:�v��o����И7�!BՉ�V˹NLx\�ֳ�$&���,�e8�5V4~'���׋`���{s #~R]�?��S��ā�-�Rz�r�8��w��$$����/9�wQ����W�P��VT��z�{n~t��w������GEz��rjd�q[��b��YA����,'�����)O����r<��J���GQr�ʈJA�w��\&�y�ꅫ��@����s\��4[u �8�ds�ƝO	 ��eg@UVO�)�8�����r��^�c���/Q�\LG�xyVCĖ] I�q�O$�d��e4 �  M��j�#��EJ���ܷ�I�^7�0�g�ALT���Q+֎]���imp��1�?P��51q�Ɂ}[��S2�!��]��I�ǤxM�ol�'��x@CƵCG��m|V�ʏ���1��#"��u�-_�����Ȋ�}hIk,�͈ٝ,bw�Qb?x2�-I�SҜ��I����+��F�#�>on"���	�E-y%z �*ԍ	?��;��-'8�wս��|�ʓ�'&.���_��_#����u�fN��������8滧d��!�u�<1�% �f����	�Yf1��[%�cC�a�b���?V��"1�����Gpt18}����h��(ށSR�K:2gfV.Eb�o��	SE��9�2&��>�m�D@u�҆�BGa�c�C��秔:5֫d��0�g�Cܠ@���A�8Te��Ƞ��5�ˤ��u��I�K[)��O���y��'���Ʉ���[`-������C�����D-YWF��ަ@���ʓ#����#�i��<RUX}�s��"�>��^"�I�L2`��F���TyFo~}��򤍈�q=<�b� �O�a7���Z�?�M�����`Q�3*��!~��E�ֽ� ��8�9�z��|~j\ϲ��XFp�fI˙�{db7�g�v���J�;֘��v����r(K#f+׸A ���\�-��6Y_͍D��\Y�f��N�Qs<oˮ�o<o��_��Y��`���J�P�(o}4����@��ըK%��~�]m�R�gY:σ�ׄir�C��,牷�\���w�x�t�ؽ[��4G��s�����,
A��;5�o�5�K�8�8�8�Z`#�G�w�IFV�V̿`J+��(+��7�O�_���*��Ti�b:�.o/$��<��-�-�!�5	=o ��S����&�o��kTޤ�¨�m�`�#1��߅�y^j��';h��kk�w��I��r�B�n%&�,CD�[�V��7F�F�@^ۡ`���5j��?@����A\�I
�=��<�0��d�,��ʢnu�y����������	�@�lL[ݯ����<$"T�(���ݔ�[}�o^V{���dK+86���P�F[�J���v��-s��J9i��1c���u�H�I\���y�͏{�_�oRHl��u���R8E�Tl�mt�j�l����g')��E#�
� ba���#C��q���Z!���Up{m�o
��86]�/���jh0��k�;"7~��wQ���P��}�#�c���-��֏ؐ��DUV}*���#ɚ'�Ӽ/�~2�2;��d`�v>h�5�T���'�+M�ԔN�\`{��K���P�~��Ml�z���<_�>���RS�� �BX�n�>����.Ѝ�c�fe׳$[���X�=����W<P?*Z�I~��7��#������������q� }���
~�����������=lRˏc���@c�$1,P0:e�"Y&w��}����s'u�(��^��ϯ�����X\$�`��[��M7�s&tu�=�6ct�0iB�9�9������G�8��`U�������/����C�3c�D���[H� ��<�>㉞aM�i\[CϣHC����`�	!6`�����pp��¡�-2�pa�縨	�i!#���ǊH�	���?��یgBr�Pד�,ZԢ�6=�Jcjp%s�a=�n9+��6s!��(�{$ø2�k���i��8���&��Ҏ���;j�L�������Ƌ�=��cjsߑ�,�Ҡ���O��lB)���Kd�§d1O���v�����l��Jw�-s낮�,E�&Fv���C�����1�G��"˺OW�v��=���	���U��]�L�i��H�(RA���XW_+�֞���t�MF��z0�'ë�����)�L�8��)ٛ��Y�rػ�&OS>w�1�15�_�&������Š�ZV ;qO�~6��0b�E��N�����f�^UF<S�k����xY      �
      x��]Ks�ʱ��W�I�E�I u7�HH�Çn�lRC�a� �ʑ�E~B�Y��rWYF�vH�(7��U��m	�������hNf�?���Jn��O�\d�L�B<�y8�5�� F������F������7�f2-Z�ϕi�2-�s:�L���l�2m�L���6�2=Z&���LK�y2��?��ûk���^���U$��6��,�
��05�݆բ��b��[�C�1{��AH]�=�;?G]ӆ��F�S���BL���0�l�0����,���Jw�m�Ɲ�,�����-����_��n?�w��t+9sJ���8��%U�v@[4�Vϼ���uW��ngb��8Z��o��?k�#i�v�/������������4Z��V�� fQ.7�n�i���*Ϣ�%Y�x8��.�/-X����$��D���R�g+�0"-��4�>�>G�e�@
�6�_�	s'>��(]E+�|��m���W0h���K��<����:ʗ����h0�!(k�m�^$>�-(��5ԋ�h���n��iVhg�h�\.�W�skng,	�22�]�%�d��������;��U����"���V�Cɽh	�����h�Ѧ�5�YY����o�Q
��f)<���i��j���/�x)�D��I�pMr�{���h;���E ��6�Ib��,��&g�ą��텢��m.�h.�O�����b����zao<��&�
�:�d��vLg��h<�s�TpCWݸ�f!C0�о2�i��׀9�dXo��d�jf���I*�a�\�GU�Ɠ�`��%���#Ѐ�.dm�ŃP�mO柂�дLˆxM��_��͸�n�����x�ꎇ�`�31^z����)����=�lMsΪ..�A�T���࿛p2'���n���퍧�3�
s+_7���g� ��a>�}H^~C�Zm�m���[�#Ƴ�*m��Ij�a�'��b[��a�ߝ����6����G�?�3��Jm�e���I8x���&w��J'�Y6��Á���w2����m�j�gWqc�����}��J+{�`*&��?�ܖ	�v;5���h{�����W��0ںo�}#bm��A��( #�Ke)Qh1gtJ�f�2�he�Z���� c��>����C�tp���fi��h��Ѵ�]X e�hշ�ʆ��A���R��5��2�p��f̐M[,�?�m������emN��p>�cx�!,&���+c��Qo�W�sC�����?2>�O
�͍���6`@�'！��"�\fN`T4���rf���5�)+�K����������(��F����A�G!gHZ�]nܠo��0���h��A0�Ѫ��B03��,��Ƃ1 ]j3*��D8�A��+U�^���wa�܎��<�`~P�{<��*a0�����e�ۇ�
c�z�̣~k�3:J��(KL�4*Wu��t��v=�w/f��'SX���܆b4���{���B���'�p
_>���]��J�O�w�zLف���V��E"��@��1�B��r�b�Q ��s���V]Z�x����L��/E�e�t>���<.��m��z��J�uٽ����;��L�ړ2��m��-_ů��`4�A��q�f͋�խ��~��X��u>��^j����w�S�9��;�^{���)L&�; �a���
�r�xOP�����<V��=��x� �2�g��mZ��	���@L �1�7�0�/.�A`Z�dP\R�s�}m���;��#&Ӂ	�З�������2c�!�����)�:,+��Z�k�u¶�uG�� vqX9�5c��������ˬ.�U�_ՙ�x��� ����K�R� #�"[oԬ�ݼ{7���4�0�ă�C`6�‡Rm�FK�(�����nA:���!'=U�n,�k�����١�k���ǌ�\��
�㚞�
��I�	>30uM�N��8�@�9K��E+�lP��j�I��W�M:�7�����>I Fo�����뚊v3OTb�9^R)�aւl^d���U������	�oA8	�k���`�|bZ�K��3�8*�"��a��  �N�M�b�H=5,�b�H�P\zo�e�\��҃���
/ ����
�6����P8v��O�XӴ!B�<����c�f��<�iݎʵ�*M�+��Ek�����[\m�Y>c2i����kѱ����vmZ9�3j��Dz�C�0R_�
�����۰���n��hv��&��J
���m.�m�-e���J��_��2މ����ϵi�����p
��\ż�Lc��'�j��#@^cf	�&�'mS/#GH��t�.�'������U�Nm�]���U޻����Q+�?���T�t��α����qܖ���I=W��1D���VLǼڝC��˵NN��7aH4UտI,��w,�dݠ�����(��Jt�뜔[ˌ�{"8�@tɭ]NB8�Oy�Syux�I8>�f�C�KЂ��Q0�'��
�S�C� �'�߇��N���6[ΫGa�aPډ�sն�0�f�oZ��G:u��{w�~���i�<i���m$�b�%
`|�!`d,��F��1�b��㗿���:N�����ᝍ,��u�6��\�Cc�.ҥAp���h�is��4��h_�8���m���/Y�%Gkh��͖<�i��T��n���:cH��S��e�F���Bȷ_p.���
!m��<_�]4��2�04��n�<����P�;t��+\1N�@6��74�塃z�k�iܱ���LZ{}��6 ����@���DK�4�����\&���ߝnBc�����c�Es�4���z��)�"u]�v�Ph.�A3'7�4sr�3��Z4f�ܵD��Lv�ƅ�&�&�0�]Y�!`�ɵ�>�G\��K�Lv��AS4�hנ)�]�k����$K�$�U�
_w!9��pϧ 8gZ/Σ�9�Y<��hu�w�	|�kk4P��y�u���E�e�L���j�a�E��6�~xts������q���l:����8'�J�tZ��L=��d�ʹa�nl��߈�#.��k�r����&b-��dEg���8��#��g�in*XJ��5Nb��@̢_�q�^��9.�ƣ�?&�U�8�qi�S��^k�Q���3��ܴ٣�@��]�5�,{ζ�5&�V�j��{�٪�ז��UO�bs�q+X�m.��f�>~�8i�e?n�1Fi�&�ut���6��W;^��Gas�se[ƕn�U��e�5�b����"���kP&�\���"� ��U<�hD�er�+&��ѿG��,v�P���nw����H���M�XSK:Q�cOC��C�%���ooe��{m�,fi���g�����[k�e_���q�K4{C���ג^���rt^ �f_�|%f�:��(�h?�0]�����UTn�7[ds����&{Z�ƿ�.Z�B܁k���f۶ue�mSS�_vru����[���F�g��m��b7d+�EP��td? �t�6�c£D6;��D�ꮈ/3��H�η��j�doNw"�A�/���w�ǫa�z�D�:���_��� �m_�n[Q_��]�}����rȗ�~��(o�;Mϭz?�2��u��[�J�E���H�x��1��9D����iz5��,�X���~����d��A�t�]5��6g�^4��Q���Dt,2�F9�p�B��i����&���Ɋ�P��Ӡ"�]vqHg���r��ұG���_�É0�n0��t�;�rh�T�?������ms~E�Oz[�o_��i���έ+`���=�Ym�Ca�t�8�����]�5����|�^��~�ݫqZu�"���"��w�gU���R�&R!�L��
��is�y<�Ӷ�1`���n�<ϊm�.����&D"�Va�֬sB��r��<����)y�����tX[�4̧m3�)�6����T�.�Ѩ&�0�$���'���y44���� s���2�]�j�@ŮW5`��S<��L�t2x�y��~չ����XQt*ȸ�',p�GcwT��O��{4��U(�a    8�a�C������2B���(V�Cg*���X�l}�Ù��fh=���y0?�ˁ�do���N*<���/3�����] ����^r}ٞ�������5��o���Dݔ�?]�OMKῙ�}EbG4Iq���d��y4�6/[=�W��ꍧ�k�����|2M�?܁�W�����J\̈W#�:۸q&�@�B;�x�0ؗc����z4�����d��_�?����UإS��0�M�7���$߻T�&��x'�~/�)��@@��\�lo��	�[�a��vh:S}~���0A~�ςy��w6	��Ocn;�G��<n>Ec��g&>�2��[��D���ԧQ\��O�����FE�^�FE\"7�FE\�O��u��ϰ��4L�P�Z.�߀XIY�˒]��M���f<��ק�a0�7&>�ͻ%��M�)y�4`�p/��iԔ��^��4<��BNi�(�>����m�Y�iy�]n��h�r��-^��Ň%����b�l� ���L�j���7�X��%&�����~=��U�}���Áf�!�rs^�ܴH&O2��w�4Z�V���&z>�Q�;�x�U�
�-�O��˷�mS)�,]7L��ʵ|����UÑ�M��m���~����boe"�
JN�
�SoWъ�of�[���#�`n�NCY�6ny�1g_���+d���%O����B<��]W��J�z�^��ڪ�p#w�l-d���<n��'�Wm�	m-�V�aZ9�ZY�#��;�h��_�����jMo����0ڊ7��VH���>ٕ�ɶ̍g��i��m���>�ԭW�(�T	��+�H�+i��������!�FG5{��(����Ò�W���,N"Ũ�1�]ݶ���a꺈�-�w%
b����)�����R�-n���#��ҝ�d���{�g�_Z�T���v���X�r�@^��f\r�&���m~(C�76~�{EI�������7Q���w�V���Y%�����&A!�*s�͒��L���b(��F$��T��C��l�ML��jS	���x���h�9]n�u�wq��'H�x0z�W���l�N��,�f�P�ъ�h��ŭ��0j\F�&��U��2��� ��Nr�E��\Q*J�2_�qΣ�m�l�VN�[V��%��֨m�����(Sv�K#�l.XƯ�hZ���]�j������Z&2��wى�e��ݟ���M�x�>���l17�K5[l��H*����!��B�	��9!ɑM�Q=u0��#T��PES�/��~[�мN���vk<�Ө6[�A�l�0��@���=�>E��+,���_%L�����9+�$)�az
f�N�&K��c���)��p�6����K0T~��C��.�P��~O'��BB(�Q�$�g�%�j�αQQ�&Z�G��o��S��὾br	���P� 4v��Uk�Y�8�x��J�P�Xf�: �<+�jX�U��hRZ�I
?�=��&�Br�ȭ@��x�B�i�񣸎^ýJ��"~\��A��gI����y��~�W嘽,�<�$�u �I���`�Z�V.�nB�tX���b̍"H-�G���OE��auk<iiR�W��l�o�
�F�PCk13NW2��S�JUU(�OX��(��.�/cD
�SV�� �ǥ��`��z�f�j���X>u����.���i�@Fs�!c�3J�\�!�FK�05c����]׹r}_�ae�⃱��6^�@����m���.�1h�g�ڵC-7y�������فlkx�ȧU%�U���X$����� `��id!/��A��u�x8
CrN|&~ӯ����k���bm1^�[�6T��˷�#�O�6O�~�x�`v,]G6`UOt�zYP\E�n);_wE�*����3&�S6�S��@�~2U�zK����=�
ɨ�L�Z&�s�t���+�̨�9ܟ�4�-c���Q�����c�x��;;cux;��ր�L�O� �AߨJb����jGg^_��4~w噺���ԖL���b}kMEP	i��B�G$l,2x�2y>l
2��Jr�L}���R��^�T6�y���띞�|�0�D����a�� �z��yfI4��BL����Ly��h)�M?�p;fe�5�,��%
Y�e�v�2�[Ŭ�}�h)(rP�A�y�=�y�,6p�F4ZW�*(��U��!���<Z�z�4��u��qj�����4k�m����/�H1�,n��P�xg5��˳#m���������팧��3�Hr�~�"��6K_��=r�s`z�r?-�zr:��U��
Wn�i��� ,R"��<Z\�@��<�j�?/^u��E���+�L(S��e_���l�8�S�eG�fiM[�q- �����;��}�����ipT'\��T��>Je�c���g�1A&�����O�(Y�vq�\�_���{�!�&��y�B#�����^yr�J��Mu}M���PxZ��ԓ �����`���`/K������o	2iŵ/'����2{!@&�˙��I��s�`���w�B@4�Ng���C;uyFc��3��d�j�d����(֛��0�J.Ҡ�p�Q��;}����jh
�6��5�}c�q�LZ��\Mo����ŕ �v�z!�����B�d�?�{�cq�J�)�1�5�y�Ȭ�q38V��>�b�R�v��p�	qu��C���b�`��V�Wo����x��|����y>8�KL٥t��?�n�l�?
#њ�rW7}�����řlZ�U0��m�}"Y���UR;���:Ͼ�q�Z�%��n��E��B]SB?�-wj�;�f!-�����D�T��D:fb(�ˊ�x��������i��q�=۳�\<�Nc�,���+�.vy\4?���]�����m� �4^���(�LzV|��Pz�,�;�uMw��ݗW u�y��m�/c�9��ǝm�u!clީ�j
D�O%�F���A�5�JsD2}A&�Yb���I�Z3��AyL4Ȥ"U�|��Z20\ ���6hh��<���k���(_@x������Wt���v
�P��$~�'���נr꼋rW�6/!����Bܣ�^��R��6,�6��i�����Gjb��H�Tզ/�"��EK4��f�T2���@�i��KW�|e�>��`&��<[���BZ����5����#��Uh�f����*z��i����RIY�ݍ2��0z���dӣ�=���궙d#0���`�f3{�@f���v�E&&�V���"*��T{N�)���$J9�M����qT����1���J)M<g������7�]���c�|F)||�-�h�z�LB+��Ǜ����4J���4��c���.@vc�,-�k>h
;۹���ӊ�v�q-�9s�(�Yi��uѷ�3��1T[�ʂ�@K�[�|u�ֳՁ���R�h`S6��e�7�68ڣ�'���f�[^���|y��^h�Q`��2��Mjw7�7�s����yP���(��<�"U��<��dLbkn�a	l�<U�q��c��V�X�����W�BE��cA�E��I.ר��bt��f<mKV���H5[�Ҙ �W+O��Y;����z.�\�U=�?K���'�6VG�e�c�����u��q�*��VFIY� ⲟ���UQ�����0mL�7p��x�ʂ��� lw�P ���V������yK����n?��������H��N��o���sd}��lz�G�i�ebC*d�l�:��-ȗY��;�
tz���l">����%08��G�cK����ܺ�E_�UV,T(lV�'�-�#d��y���in?G��"*����^מ
6|�������6GJ/@��p�מ]/��j���^�V�0g3�g���5�qq��)ӎ4L�Q���n�}4�^h��@���!�VX&�4Ȥָ<�3*�Z���J�7Y�I��Xh;���9L�0Ȥ��y̺iTسF3�]�4h8��h�� �F�B�&�<^���a�ewҞg�֕���Gñ������Nt�i����+�iW�hˊT�
 F  Ŧ]���e��B�$�ߙ]��T��9�j�A�n5Ҩq�*�	�M� ����H~�1�(��~o!;��t����h��r�w����y�t}��q���O�� ��ӥ���G������5h���Ŧ4���V\d���%޴F�7���Y�*����˶1�+���?l
ƪ%��B�V��痮s9g ��(�4�
<���4����N���9܌;�0�J�e��@����z ��R.,ѠQw�h�@;��'m4���^H�b4N������T��:B��P����$NO˽W�ݶu�:X�Q%�cyg��#^�h�)�m$V⢧(_E��_1�9%:O��u�S�x\�A��9�<WB��J+�w/��u��$2i�d��l�Mu�����^�{������@n`p7ew�v�(���)= 9l�OW�>Gi�!��I��*��'H�N�l��6�+P/������eJ�_����N��.�u����k3)A&M�dv �4U�eИ�6�e�`�6��@����aT7�#�ҍB������%k�Ѫ<��_u�E���(4��s�4�S��HѼqm�S�u\d��|K�l�f��#�ȓ��BO&wwͧ��k3�O�����6_-���.��n@�]� ߾��ST�7m����&��x��:��P�b��������LK�]�}����5?�0�z���m\ؑр�M��ؓ��Ә�2� �6���h�æ�H�^_d<�$�h�ͦ�����$m�s6q���.�H٦��A��+���;��8�@�&��폧�6��&��x���0����ξ      �
      x��]�n�V�}�W�M	���F牖��H�F�{��r��ƀ�|�`����8��?v���,[{W :/u_U��ն��f�k�������<��^������&?�ɬ����E��t�!y~|����.���Y����~h&H��Բ�h>�A2�#�d�L����<����:��C�v?��ɂ�*;b��E�j�tt�� �,}=���J�y��i]���4�����f�4�m�op^-�g����u'2k�e^z������b�Q��n��M���r�!�}eYǼo�����=g������$��.�9���Se�YEy���LJ��i��.���(ޝR��d�}i�R	��2^,��y�~m^����2��[s��q�ތ]���I�uz.��%��"~�ơG]7��dȌ:P�I���5������Q�{�=c��_b������<(�������M�Hvͦm.��#�L�n����*m�ә��n�M�m��eQۧy�nQU�sv.E�C�˲���d��f�eø�C�s���u���j���W���j�z�N�tY�%s�Ps�f���Mw���sS���N��Swt6o��f�l��՛��o�n�k�y�<�Xl�%PC��xs���)��Y�"���9��ٗf�����.���U۩�zU'�v��W�m�O�fY]�?�Ư�h�M��,}^1d� ƞ��a�˪ye�����ӡ��=q�f+�;��|Q'_��f�����0#^���2�m�>�h��e��fS_�X����dо�f��]��u?��͢^o�*��.
5����}����S�h����I�/ɢSO��w���-bLU
gA�a��t�bbc��ˀ��RoVMEՉ��5�P�y�bR�6w$A��֟-JH���3/�бr��Y/B��s���3.�J����y���l�mV�<��}uE,�4BU��B�^	�x(O�6��Ac�g��f�ø1�C��<���
�N��:
���Qz3��Fz���O��M5�>$oݛɺ3|Mu^�(Z�	΂z�h�?Ŏ ��s����[����S�:�]%�z�u`��,�:��P��kӷ\�E���L�@J��^�aʅũ�Ԯ�MuQy��h�ɺ9
���@�[�C�?J�-��!�Q<�"��&ڽP����2��E��6͊\ӎ�6�;M�z�i�F�V�E0�4��C���2�:���s.W^
;�ڶ��2�`�_f'J�k�i��zȢ&��-��)O�lw�l7��իd�|��]�� �Y���P:Hp�%�B��hN�I���i�1A�k��j~������da�����O��_���Y����嘿�
����a,Mc�̰a4L#������Y��g��5o�-�a��H&���9�vu�������p[@�"��t	.<�X4V�Ғu�S[fB����,�℔����	0�c|:�9���,�<1�a�2A���r^QC�Q�����r���B�9³�{+���}Q*�@�d%GHpg���R�ي���e
�p��è����8p"�l��2���C9��@���*�q�L1��2�a3��2gk��U��8)ڈ\��t�\��8[R�9�V���g+�b�g+��s���Ms�-(ޠb�(!-�~�q�ܚ�8[�H��ق��jsf�÷��.� )�e�>2g��8�65b8�6�4g[�1g[CZ����-���+�g[��YNg;�q���m9�v�g;�as��K��qv.�%[n�o�^��*I�p4�8���4���2�"�F��ZG�BWW�����U��@8��%�������#낓Ǩn�P&�)�B���M��N�ܣ���}zJ:�?_<\=��!�f:�3E=��\�~h�V�/�����r`�.#��BGBS�8VuΨu-q�r�ߵ�b��yws�ޜEQ(�r�s�.�tu�3�]���0�����c�N�����k+qv�l���wʋ�]&�7[rrc`�:+�c������(�x#@�!# e����2�PL�r��j�mwJ1�@\��������������~�һ3N7���3��|L�<�a�B�0��c
����/O��>w��t��54�)G)S.�l���JƝ�����Ӳi�&<����%����[&,�^�6�Z���R���N˗cAt��Æ�z}%Խ�6�~l]��S����ר>�>���g��e�*��5�w54�����+eK�8Q&=n7-u^"UO����hĖ��S=fʅ�ĕ�J�t��I�s���|g�n٪��M�N�=#�N�FU���N��)N��O�bb�~'Ȝ*���	�������x�)��;���	n9)@�6,�"��w_��e�w8T��w�'GU�Jc�C�$ܶ���w��VI5�6�QE� �T�N����X#�Hn�N�C��)�Q�v�l)�&T�b
f4�+���4ٙ��#/�|eeh4LR�f�=m/���8\$��4��
-�Sz�@L��vk�Ӗc�
Q��u���C�*̳:�˒���s�E��<�L(	4�>)^~�r��l���Ӟ᷑���#a:���ii1�_���2	G��75	jxox:\�B��ē���7�v�S���ڷ���9nS�#;4C/��5'��z�?��څ����ǡ�w����N֋j՞%�e
��ʲ�PJ4��G���-��L*�5q�,�&v�xB~��2��0`��d�xB�K]��@����n��l�Y�]u�.�y�e��z���8K�Z����
��R�lcm��X�#�0���\�V��}��y���_���֗v�|��u�\R}���~�~y���Xu��&�l�M{����3�X	
��Pgp������1L���Cǈ�*B��GR��FP���N�'�鑔��	_[~>C�R���2(T.s�#)��{ŘO3�#98�c̃K.�?�ʗ��թ C(�[����U� 2��U��8����t���S�0
PA�p�I��T�P����Y8Y?�|�}�&��?g숶`w�"��r^��H��� �!#����hS��Q�8�y���;�k��� f-�sP�U��ք+ϟ��O�/7�~|��~��5)���\�_��&��� �^�ɜ�"��e��o��}�O֝o�p��F|R�p�m��M�fו����I��s��2�
8[X�F2�JAU�U����>%Z����LBlB,n�^�HiP�5��`��Aק	d��aD�#Re�1�)� Y��\%�����n���u�`I�N�����������2g�UD�j%�a^�󰚴%~h�+��e]�O�,�����������`�>�_�0
��0�<��*��~���_�פ��7�d���X櫻�o�����M:ܱ;����Y��ٻ:�����~�xVoN��-�<M@s�t�>�B�k��7�Z���y�b虿o�}^T�s�x��z���y��3Z��~|��|J܅�j�
�f0`�J��t�'U#b*]�!�꣨"\ �����7���Þ�H���i����BP8	n����p#���T�z;
AB��h��@Wk�-�� vo\�/z(<Ԅ9�i�	{-=��]��t��GP��"�6y�� ���4�.������&W-���5 ��]�ay_�'MH�t�c���;���3Fg,�`x���Ʋ�+h��\���wks�X���^�����S'�\�����چ���Q�3��Ƒ�%fK'�Ǝ�����g�s�f�Z{p��2hNHs��Z |S����/����"���	m�:��=Ӷ�YL0	@��㑐@����oI��Y�
k-	��4{�%�k#ւ�{Mmē�t%��8^����&��E
M�����)YoN��@׻h�s$;�l�`����EӁ���Ү#b��.b}<,:D�l����O��N4A���á�S�M~�v���Ȣ�Z���{�y���9�j�u�}�s�~|���������*8=�����Bp��F�0���xM�D�	L�I	TX�&���_Y*�D�.ᗮ�	�G
��>E��9�pBɆ�& 5  EK�u��d<@����K���;��T#��ѥ�
5<���*�)Zwy(���٫d9�&(���Ij��6�Vʶ�8SLR6PUF���~U�ɠZƤl����If���_&e{�ZcfR��ݩ&��Z�-BdΤ�ZTI>���5A������w�A
�`��*�H8��Z6�ᦋ$�aOA���³����X����\�Ef�	�s?����~=)>������l�	I��.���^E�?�X����c�0�QHEyq����'�%�޳�zYm��~N��l�	7�����A����3�U�Y�a/oNz��hx��_2d����4�hf#�0�hf��dZ9 �BF�
��N��!�������dd���^<�����S`����!B����j�'�9M�C�"[| ��a`�WNʺ`�q\�������R����;�Ŀ��,���l
�]Bm��s�y�*���D'��%��=[AU�! �P�q�x�����cD�)���)JcYT��E &�!<���,	J6�ݜFk,�s�����P�0�X1��n4���`��W$���{S@�_�q5�M,?@��Z,t�q]+��'����M��Z���E���[�B[|2�
	�O��������d������`��$�����j�Zy���C[)�d56����A^+�ob��#)�\��&�ð�83�8���]+(j��{�\ ��^ݑ��<�}�7DN�L l%�=u�.�7�����0:l%1~�-�rcn��T`1�qYz�
3	�er�aM�1=<����/��`��&��8�9a�XN��K�rAÁ�N���)�q#98���.���`��4A�q'x�̈́�wGBc6<껮�ʥ&�0��tӿ������H��p���v�$��]��ܷMG�>.�
��:$n�dp�J�f{�A��h;��K�)w�v�9��m����瓞���r���|>
�:֭qp�6%g��5^�����,���W�N�9����4��gz���� ߾n��YX�&fAð ef��v���L4�ؠ�,�;t���u��y��j������;d�B�J�d�)�*���{L���3�J0&�r=�J�N���U��O,��T[�^�@zӹ�V1���g?�����k�5�.X���1[��ۼ�l<p�H��;�ھM7:։2pHʆ�q����˼�ж�wy�9%��ph����r�LRJ:��$���Ǜ?#��d/�=s�w�j����m��&C���M7�����)���~;�j��?�t����P���         G   x���v
Q���WH-.IL�/�/HL�Ws�	uV�0�QPp�s�t�qU״��$��������� ��K         �   x���v
Q���WH/*-�/�/N�K/��K�/Vs�	uV�0�QP��U״��$J�1P�6��M���H�`
�@�s�@�� �|s�',� �'�|K��I��� ���@$8��$�ű).Ų?).Ų#	�A����� h�         �   x�}�1�0E��"c���6�:1d���ThOЅ��K�����������žl������o[����|�~C�T�T�DZS���m$�Sfu#Z)���*�tvj���p#!�B='���7r��}��B=�6��'C8R��x         
   x���             
   x���          
   f   x���v
Q���W��,K�I-�O-.)M��/Vs�	uV�0�QP��u��W״��$F�PS��s��Iڌ��B\��=I�e�������� �LB         :   x���v
Q���W(H�,N-Vs�	uV�0�QPw,JO�+��KTG��kZsqq 4         2   x���v
Q���W(H-J��I-Vs�	uV�PO�)���W״��� �>      �
      x��}�r�H��}��7�U�!� `{�$��Y��&��ɼAJ�*����I���f�s�C[�qO�/����e$��f��S�@����ӛ�dq7����G_�n�n����xv?Y��G*�/���{��jt]u�z]����=��ÿe������ȥL3�~�^���/�����5����_�4���+�.�MS�>6ߚjc���c�ݶ=�R�Ҭ�N��.���-�[�n����e��_�Vo��Lf�Pz �L�/����3<���iS��4Md!���P!�u��};�lw_ꎹ����u��+�I"J%��ܴ@n͖Wm�-�m�|��|ˬ"�Уi|2�4�����z$f˺no�\�fe���0n2I��t���ftYm���VM�CJ�r�M�o�ݺ�����m�7������]���4��eY^���S:��U]�&iọ�m����i���&���<IӢ�Ý�bqv�kQ�ЯQ>6�]�������Mϵ&���;g�/��?^5"V7�ݮ�4�H�)+xax/=g�Dq�����w1�6�5|�Z��r�g�r���j��j�)�q+9𒿦�!�j�m҇d�:}H�Zf�>��f4�<vu5ba�T��V�������p�I!��1��#R����_�h���[:��yi7�F�h��g���H�,ʞK�Ok���f$����Uu�7��ş4�5�tR��2=rӆ���Id�n^��z7��v����m�Y��a�JQ�T��|��3�u�����3���˦�%)$����&2�p�^Ɩ�OZһ���^�V�u���w�>�i�le!��{�3�5��4[�/�^/���f];�O8�I����`i�"$2��q�
����ՃI� �E�����j��,��y��*+��7�������n�t��>��1�k����?-���k�ԯ��U���2ϳ��}J�O_�(;�f��v�_5�7��^p@I�t���l�?K�{:_Lf�1l��ލ��̦LQ/�ـCZ(	7���5�~�V!?y.�ˋ��t6%V���rb��15Ǒ"�$L�'u_�N������bz1��D>ܻ�b<��<T���йH2�Φ~�oE�/�ǣO�	����r��\�F�WX��-�w�̧��A��w��ãHPܒ�^C"�ōy�h��g�xe㛫�lzA��WW���p�r�P$�c�*˩L�Y){����|���y�S�3��8.�[}����!���ߍ��f��o�[�<��i�+h?R�"��&�[H�K���/��������7��y�\X�\�<��Y��(��3�;�_,�gp��1<y������9d��V�<p�Jϑ~�Z<&�v+�)��ɂ���o�Ͽ��H㕲H�\�2�ܤj&�6���Gs5>_Lͻ� YXN�P�l�!�UI�y����p5��O㔳�t����r1a�/���z;NV(�|F�GK9�!S�8R�6�-���͐��f5URC �X�Wj��I>�B����(�+�-��F�5�4<��(�H��r�1��iV�r&��i^M�`jHM^-�F�2.�c�Z�Nr]"�8���T�H��Ǜ��v|?3�yg��m�^��)8z�6��[1��4K�ҫ�Z��-�u�@�'v*��yC ̭Fl4�g�zS���%F��"�Y'���=�2��AD��;N̪U�]�/]W��KY�Tgi�籦ԩOK��u%�/m<h��VM���B�8>�W$��J�И�7���T=7�'sZ=�{{>��.xDI�68�mI��?'ۤѻ��d�^�l~;YX'��x�cjD#M,%©�N���;�b~mſ���i�d2w���\X�i����;:���&?���&MD�#�ER:˫�0����ܸ{|��Xp�n��M-���U�'&���m��yJA�(1S�R|	|0U��Yp��v��"�q��,�F �T6s � LRH�\�Ok�$��
L|�j�'���^|p �S�ΆǞ14��9��E�i���g��S�-�����P�P�(�'H�я5ch>�m�^56C���ڍ�x5��:�2�L��ϴ��r_��_�U�#�$��Yں{��Mٛw%+���3�΀�����	�
k��sm�gv�K����s�B���fU9+xyv6ߴ�wM��}%���s��G��s.^��h��f$�hY�]jR4�Z|)fL�ǣ�'I�kgM6�����F�� ��¯��kh��i�Җ�2��ɦe9�ACLm$a�~ԧ=�v�&	�X����e~���� z2N�I���̓@�-Bs�y`�i�:sw�X���4�ς<��U`�a}QG��|w�f�Uo%HI�80�-���$�U��~7�һ�αX��z���bD8��v~t9_pP??�Y�B��RB�-���C���]���ĺ��?h|�1�K�oQ��L���D4�^A�r|kB�2!EM�/{'}>G�i(��4
���d~3_���mj%@�R�r�N�� �Y�hލ/�o.磫����l��-�_��O9.�	�GT�u��9��M2>���frg.��ů�Me��\F���ri��SV�i�_��9�*%��T���~:VFW���PQ.1R�Ԓ{(�]
���M�$)�i��D�Ŋ��1��|%�����|r��sK7|��K�#ΔOݥ^�H�P"�����71�5�g��m�/����N�J���G���,s�r2{g��lzk3>����r�BD��>��z�I��?N�[)]I�.�eA�֋��D\)�;,��W�g����9]M�s��є��\8EVJ���O����N�;������f��v�R�ܞK�����f��Y�?�m��>�\5�~/��z����w�"���e��ȱT�I���iO]����t��ft7��ͽ�^݃�[i�Iڈ�N
Г�!��4�g7�Q���d�j|8�����4�駗��'7 ��,��%���O'��!� S:*���~�^]�;]�AE�͙s钾��I��D;O wᕥ���Az�}܂���^�H�������-�PK9�O����a���j��?���rf�ҩ,������3�E�?�n1�6��]�@@	Y��]h����.*�����/.�	�TL�e@�ȕ�%�D��!0���{s���ܓ?�0)8�@��`$����	^��r�_��C*��(� �N�u�H(�Wgrg
�'�9h��%w&�R
/��c�,0�hk!#x��oz��n�N`�)TQ�<���ǆ��c6����R���a�r��Y�Y����:�"�ܩ��z�֫�� �SͰAG�W��--� {�tFdlnӣ�bQ�4������ǆsD�Z�6��\L�.ޛ�瀹{�D�_.L}�H���"ߎ����n+|��ϟ�%Ȕ�䴀 *O�c�����p��H�<t�އ�9��PC���A�����SI��`�)<�*����rh�lO&�!8��,�0�wZGF��ǉ�kd�Dg����W�N��ل���{��^K�a@=��q�toT!Fs�Sq��U�;��@�v%
��xm��H�;�\�q��0'3�t�_�A�z\�9�shjo��;��:���u^?��PC
vo�$P��'L��n�}�2�oW���͏��"Z�jZi�`)H�I�U��Eh0d��O-����� ��d��� �/}���"r���6J�c#W���f�1$��h��V-�Y�@��J&�mJ-��^�+W5t��I����~�jl&EH�'�k{PG��p^YkXP��T�.�&AvM�FC��݌J�&q�����ۤ%vB/7E�6t��[}ƴ�<I�M��N��W�x*Lԕ(�R_kv��R"�VE�y��Tjf�Tb����T|�����{4�D/9������� G��)�U:h�
^)P��ب(i��U�m�����AK.�1��^�Z7��/U�b�w���K�����������D��Jc��޺������.��<%�=�\X`�������<�Q��dy����M�N_2MDA	���nQ�7�QS"��f���l���bJǛM��A>    ��T�*L�H'�#N*�ځ��f�âs�l��>��j�'�X�=6���P
��ig�q:��
����W��Sj)�'����0���~|��x�U�>[��⏹G�Cs�D��+���L��U�nc!ȵ+S�Q
�tB�ŧlM8��e�j��<q�`U?���vk[�3�Ay�+��LC��/gi1%<�27m��p��k�f��:'o��U������U��%���� �����&3� �����M^�ZD�0�;��z���V7v�C+�.��Ɓ<J�X΅�FK;�9#�q6�Hz�f�4Y�s+EN94�3��*E�1Y����b���26)��c2^��_�]�:�j��b�E���Jϐ"�I�;]7��^�ݣ+[j��){�YvP�.��eh9r��v��vVuO}��࣫����9��k�X٪���j�Ȁ��J�*�ʑS�y؏q�>������N�� �:7�i����$z��}�w�&q�����<
� �cZ�����[{�]��� 5u��F;;m�P��R
|,��/�	��EhC|~�~�h�adF�wW��֮?�TI��*�)'K��0�w���+����[cb�鶪V����ƨ�苄ܔ�؋Lfe�kP�4Dbi�j{�l^�Ѹ�C��nW?�e�%��b����|��L�sMǺ��Ӟ�� Y���$x�n\��E���=����iC�P���f��	�w;|�l��[f �'�i��������cK�Z�1<}�����

��]E��iWn�F<����,��x'�ؐ�t���Po6=oDj]���Q=״=훮�ߞ'��۩�3�4����Rm6���x��X�=���.���|��٢]q����뾯}��σ�������|6>8[=
D�Y!�PNV�lm�W�׵��K]��o\4�ON��f�}��I���ϣ(0M:ԣ��	;�-|���۵�_�Ӄa����z��
���3��O��d�:�o�8���ŏ�N�ڪ�f����H���3�r�w�j�yM)Lߍ|Ѯ����%Iْa��/f�a���H13�^�v=���؋;T���=#?��D��h�y�~1�'D/$)�>K�U'�u�^��}�x�0)��C)R��l���K�}�GA�W$A��'�K�_�	��x�N��<*l��_�A����ݺק�l���ə�d�S���f�z߭�p ���a/�O��9������j��������
n#h�<�k��.��F>��}.ID���H�;(�tN+Ua�o�R=�?���Q()]uE7(/<��l��be��o0TM� ūr؁�]��H���$��*9#�T���ծ�1��H��C�z�~�����>���7۷r�Py1�I��U:��;��u�����t���l.�`�f����۬H6���P�O�s<���lw�[�#� �ɇ�� �٢zn�#z#�*J�Wo��h�nA�{�΀�`�Jڢ����dq�Z1�+i���^N�E�E��J�Ӹw��K���<�Qw�C�p�rYmv(oA
'��9T�icQ�^�����N+�����(!��S�}�~�F���Ă�mz�� z��\rn�Q҂d���Z�d_Ac<TS�����D��4��I�47(R� f��P���T�ꡘ\)���4 W�A����GS�rcj�JS���p��x:�����	7V�;.��e
�n��Q*�LEov�z2�>g�֑�&`�C�z#'�_�����,�I������<Կ,f�m��y��//�t�xE��0�OD¾pw���e��1�K�����Hudi�-����x�V�`��#���`(��&�mm!p��������M���tÄ�p�'�0�oؼ���~Z[�CD�$�CsC��?��pdW�����d?��?�K��4���]� 2�j��4��
�(��{08�Ag�S̖�ڒ��۪uY�
�Y����Ħ��H>�-�V�^���F�dz�` ͪ���BmZ��f_�����kks�AWp�Rp�i�gL,�tm�f^�|N�_+~qG/�c��\��_����c�v\7�^ͻjeS)��i� 6��P�����m�����I,9_��"f��~,&�8�4�h(���7��o�����O����,-ӾCRk
#�(?���0����� ����w��>�fĘx��Q��fx�\sc��W�s��>�魠�i�L����0aħ��C������'$�eE&
}�~o�8xQ~A��t���܁��|ܓK�Raeh�We^��������5'��p��0O��o�#`iX��+�5�ߪ纳SPW%�����H����#�ŏ<d��@<7͟M���!�
��#��#�O�ޱ��������xZ�S�B̝��Y݅x���m����fjN�i��>?��U�!"�߯�Sz(t'���ۘ��\!�S?"�%F�����^!(�TZ;ן��@�� ����ZbWI%�]�}�ӌ�s��2����4ĈF���,��a��l�;�I*�V8-���s��C�wS���ob����	}8�<�I��]�pf��W^ͪ� :����>�I����T�83��Y�k�?�o���U�?���Ȩ%�=��֢��al!��ΆxZ�f�pN7�� �Z'��p/̰�C�#�ȭ+����ޮ[�'������� �'�9{�]��<��!/V#�\_��=L�A.(���v#���\A���u ^"_̪&C;62����ٚz��<��,#�2�oM�mh4���k���j��vc��֮�W`;��H���������]me-Hkҍ����-��:dFi�q�x ��hw;��5P!ez,�a�
�t���!�����:���L�<��#:TK�aW��o����[.1ю*T�o�,1B�(�D%�M�v����cg��3rX	�]�71��A�P��	s�ȼ�� �jw����Vӄ,�")�p�7�[ZD�u�;��@Ս��ə����Iġ+�$� ���v�4���-�w���9ѱ}�RȴLt���Ĉ� ��[{l��m�&�&�2Z�Ғ3Z��c޵}=\�����\LC�Z�0�q���'ʹ�7��ZK��D�����������$��45� T���I9g�2���26���a��_|#~X�XwpL�t">1 s��$46�(#���קu>6�U���թ\����Nξ�_���ȭ��$�r�a�,֎�\��� �g���⽛��P_r����p�ę판�r�U2Z����c� �On�Z�UfYz#����lzs��H�{����M�~`�P"z���ty7�}?��NF�O8�L�����A��ڃXb�TeAI�a-9��&8(91V�:�_9�0c4C�i�ʃ��(Ζ�ȩj;|����T���'&����O?�o2��l��8%Ŷ\�i�Bhc�X��fr�у��>Z2�p�$�(���`j�)e��K�[���`�����,�[���^�A��tc��R"$��vy��>��^�����v-Aژ�FȂ�/b �9c�m�i9��-u��f��LuR���_������������7��C`'�Ӝ�W�0�eq+�yxT7�x���<x��K�ݓx\f� �Jļ3��E0< ����\�f����;	�Py�W:�k(1�i�:w5�<��ʀP��?+$������1i�\���s���>N�fn�1c�rr���Hݬ�!H,�t�������;#���j1��h���� ���G��ZJDy)�����{���_y�(|f\���	Lh?�������r?]�?;Y y���T&�Ūx��5����@�g3g��$<_$�r��eN9�p�ɵC۴a����s���2%f�jD���n˩]^a��M��K�}�x�Jz�����P�������(S��y�� [�)�pt/i4���N�;7�x3�s�"5-@9�%�(u�3� ���<��?��x�bj���w1���Oܦ�[��MwӛF�U$*�+U��gH���p:��`j~�Nۗ>�V��z�Q�@0S"�'x��k�9�h@�z�(˜� �    )�2��%VV0%���k�A^ϗ�'��YTy��ܣ�.wa)��&m�8A?�"@��8����g� ͒p��> ?i)0���0"ಷp�9��PS��BxWϒN���7㛋O#�����-�"��]����Wz�'C9�>��S�F��
��E�Q�?RQY��3.~q��
p���5�o�rp��2)C8��2��T�dS���~͹`���w�7J�bג˰)캣b�Ԓb��7�d@���y����՗��J���h�B@�L�pIэ�k���p�^������M?��D淐�՝�~��O����c� 	���f�X�q�1��0�tU1�Q�ҢO �3-f/���]ﳗ�ϴ��o�s�pa��5P���|��a�c�����|��[���)u�+ 3"Z*�H-�7V��e�%e��4H��u6�U��.��ڇ�f���������E)��� �i���<�~m6�5������H����	tYA�TOَ޷غʩ[�:�]��BC�CL����[Z�*̀�Q�|�)sZ/e:<A����ʹ�E�c�u�������s�aUsS��x���P�H��#6�Ɗ�鄭]��y��W�e�z�1" &�d�d�e�=�<��W-l*M�·v�SǊ�	e �n�)�}yoX��-}�H�21fMr)�l'��f�RNk��I�;FBN#>j�����*,�(Io9�ڧM�j:h�l�%GA�50�O����"�+0۠��c�ͷ����t��*D�=,]11檹�m�n�;��]u J��N��̵Ęw'?��}�˗a�]b�Sh%�����O�%����u�k֏�kD���6��y�K�Ta-1��y�A��}�6�2>a��H�ߓ%ưͼ�=��:߿8X��`e̜e�eJ^C�iF��.��[ū�̹�y�Ƥ�$�8#@&�_I�� ��"0�hAf�u�- ㄈ�.F̢c��-1�m�,�y������z\��r(ڲ��C}%E�eb�-��bͳ��UmMs�v����{��$A�i�qP�q*�8T_ 6L����3��a@����g��}�{g���!�˦u��
��?p%2yD�1"e[���]}sJ#���0-tyL-[b��+��>�w�����w���rf0�YYy�U�#�F !���|)^sB�7
�jIyDGb�y5��.��%߼4~s���#��i��uc;"��2��X��)+\)��>���"bD�35�9������gd-�!�� �+���)B��n��e�u4u<��v�Ic��.��ۻ-1bB��9a������β扯�����������h#
"�ޢ�e!s8�2Ę��/��<B�ن��7{�"�Mu�B0�#>�!��χ��o���:�f� G��e�o��B1&F|��v]o¹� &0�^x!�����#����Hh�l į+����Y)��C�t����>���Z�p(�y�rm�Y�"IRu��b�$��O��u+�4�\	�,oD ����v�Wg�0������4���?�Cz���Ĉ�����%�������rgdz���?�Kۜ��]!E��+�"�駔q���³�E^��k�,���l��{?lb�1���-T��]�RNf;��Dy$.����)c<p�hZ��f����_^]J7�i�2�C��i\jBٽ����P-�Z���1�k��Ť��|��_�.�����ב���1;��*P�O�=,��R'�+ �Bx��"�Ð�5"D<�Md�.r�ڣ�,�M��X��M��77����j�g%x��K�)�z<��Ĉ��ĘB����7�'�1"�IR(�d�������w���!~Tk�pn*�ϲE��R���n��m�����c�*WHg/�.��1��;��\��ߝ=mg�p�2��b(���S����(�fF����ʎ%'��Q��|�6�_V&h^���k�[���3"�6n:����\�a��:s9T��D��c�:-�[���%(z�Q�FS)��G��!��?556� y�vm�Ʒ+��&nu�m}�?nG�via��"�����~Ez
>v�q���[��^�����&� 1���ҽ��dӘ��S_�=X�))Nd�S��L��I���H.p���.9=��a�a��m�x!�݈���xd��[U���>U�щ���r�de(�E��qod��.�7w���uv�".���B��x��'�(뽼������bq7=����}�^���)2L��n��w�R�:��C�����/ͺB �0\bI�4|�p��:C�趥h�þ��U��_y�׹At"��fZD}L(��x�ca���A�^Aab,?�%��92�Wb�P�k��u�Bg��#��������[k^��Y�B�
��ɻ���{�'H2�mY��&�C�Ҳ�{J@f=�����"u;��?O�\�v�Qy� f�9��7#�tDі�b�����~D��(��J�Ҵ��4�F�*}L���Ѻ
�6���k��un����AL�HdS������L� �e�R��3�\-i���T�y��.M�ƍ����%��8��o�c�n��G�f�g�U�e"�Ĉ�!�[�"��_��e�ph������h%�xІQe���v
`�b?(�w�d���ڔB�m��&c�M��H^��}���/(Z��8)i��]���]eF�ϛ�v�`�� e�c�G�H1�f�p�J���n�t�Z%�����[��ĩ���Rْ�*���H
,y��m�qĝ��� ���1�-JT.5K^�2�����uK�3؈��������:x�f.^f��G�<��EMɣs�o�.��
��Y���ފ��L��ֳì�w��������^�R���E{��Ę���vhp  �B����%2?�HK<��I���������#�ne������������+D�(�J�@���rQ}�w�n첖y����o�`�ɰ�\u#���~Q'CORZ�.�d������{���N⾪�i01��k���l.��]��Fl��vOdR)0Xb��a�E���wQ��]���w����2�I������\���@!�s߂�,�((�!FX�R�zo?���^��aie���P�T��^��V��n��e��!m�iu}$#b��%�cQ����b��/<O����׳w>�|�jv����z��}��Y�lb	2Lc�4{�^b�1ߒ\��^L��?l�їf���a<��2B��@_�cx� xn�n��t��Z���B��;C��1F^�_�^X�MUu������Lsx	�PO�Ry��w�I0�[İ���`��H��P�N�.\��;sC?�ɖ�
߶�2��L��L���d
�5�K�����B��=N8��ڳ.�=��;{ɽ�@Ջd�0�邾����|������*�56��<��*Cq�h����vc�����c�J6t��4�kLݏ,�/s��<:���x�p�Ȏ�X��Q؇�O\<��uBA�A w��#<+�Ep*�q��p��v��=�RDl(�.ޑ��ˈaRr��!�}�U���3M���F=3��m�i����^���s7
������G�v�=�	��c'�y�wxۦjɰ�*K�>��8~4�WǪ�9����[p�8N��sQ-bQ���+���b˜�p����������$�X1ZqjF�M�d�O1>Y��d�bCC��⽣��*^6���>L�'�B�C׺J*�8gͰr�Z���}���#��1��mP�6�@���_J�M.s�'9t ��i��l]{�q�y�s�9�#!�!F�J9۽}g�������*;Ɔ`3���<��-�1�g���K�rO�m�ޖ�8fA{���1K����%1�$SIr��#Ba쟹J���8�%�<�c��#�^a6ۭi+ϓ�Y_��g���V	���7%��7�
���݌>���OV_ꇺfZ;a�`Ñ�%�5�Ge��U�Pu��3���°�bH�^�^���t'�d-7b(�4 d  �b�+����Ñw��܊>�d��#�������R�U��7����U&E�bn�1|y���/
'`\7'\{3X_:=�bm�-����7��g?�k���ä�0�J%�hz�-�t)@QS�1�A�;Lm�}�e!�I��6rjʢ��`����u{����;����I)��x���cN�2�\ߵ��[@l���6ϋ|h�FQ�lV�xФ�&�]�����r�X�I,��
�Ĉ�$vR��ꋟ;ԙkH��N�Ĉ�*�]Q�2�ce��l���MIPH������A(jKF��։T�r�!�TȺi�W��z몄:s��*U)�j�q'U>��n���^	�Y/�}/�E��ٻ���()]� ])�5�����ޜ��i^U�8~^���LeY�~HK��
���w��F��@��5ns_�Lq�z`���`�N��="��C��X�����cG�;N �C�W`��_k������®�s��I�Ĉ�!�.�\;��u��B!�c����
f������oa*��I�Y�2cb̜��]݁����-	�¬�P��%11b6�*J܉nv`B]_/�z�3U���m�J�5��Ľ��\�`����sȈ01�Ѹ�J�ڂ���}�.�,�L��ˡ��T �Ó�ft1	а~4G�
�%��"Xb��Ie���]���߫SwP�n�`�4�2��қ9��o����I�q��&\�ʽ�2|v��6��҂(�8Vdb�,J27xh����3s̔['D���C�)�[l;��.G_NN�_}*��âY������~]��"i�f2Y��8���,!87�lk��ޥ�@~�4(E	�brI}��{�@���-��������q��)�j'��Ҭ���{�P�=��8K��'(��[�:fvUu�;�I�4*ӡKU�/�َ��(���I׳�^�"�r���.��/S�/�`�����t.}0�μ�n\&�0M-A+�����������1��E=T�J�nV��d�To�.x��K<�p�1�t$N1Ę	b?�>��leg\�:	GŎ֖�ԏ՚�����`]=~߾Z��<�p[�^�S�ɑ��%F�e�Z��nу�F�N��&��O,�I��l����!�&��1��������E���x��>�MؖL��c�0���C��-��x����O�D��/�.��RA��ĘK���f���xf~N��Ǝ�q�� �%o���1fNܚ�׫���r�UJB�=�?7Ĉ�.y��w��b�u�BB#c/�fR�i�(mQr���5��ٖ��V�i�~5��n��
��f}ͽN:�����eF�2}�'�Ĉ�\�U#��uLw���z�ҧz��HI�#|G�Bh����u�~�=`���TY)l��ӃD�ẳ34��}�Ґ��������h��ѻ�܋LA6��c���1!N�/���0�bY~�ÑE�Q���(��!K��7�d=Ǩ7�f�ݰtg����f��kٳķq��ɯH�t�9E�khԖQ2��A�Rfح}����J�Ȥ�%FCRR�y_�h6�H_� F.t�h�m_'y�IQ���D� ���{�#"��@y3 �K|��6~]:�(2C B��8��ebĲN�Ƀ��)��g��0��ms������:!����L�O7��<7�A���؆[�c�x���M�`&3cW���M\iz����"��G�P���2�`G�.K�@���� \�]x��S�8�u01���`��p�������p}��^[�'��;L�#JM�d�,�*c�A$��y$Y����4�iwj��a*B�V'�RC��Ww67ǉ�����}jtt^�Le���z��_v�|�u��wbC����\�"b�I��P��GA���Ru/Ճ���R%I ��ݒwb2�;�aY��C
����\cFIj4O���8d�&	�Č�{}H3B7%#3�|FV:����l�%���.��9�۪y豋BkY}��(^ʤO	��L�"�~Õ��j]}�W>�Ϋ/(tV���Xbp��}[:�|��9E5�����%F؍ �~��yy��T��>� ��!F��cG5H���P��X�2:A�(�7!�I3Vt��0-n밃D9m)d!�#��%F8���w��׌�ƼyV��3��WL��J��FV��m����>&78�ER�yc"#^�����z�@��`����*��14OC���$����|�]f��YR���8-1�*S?�q�'k�^[���fF�c'�F�# �Õ6�����j��5�ع�7֥��P[���TwϦ���k0t�0Й�{(���?6�tn��'�`����x��|p�H#��m��.�_��X�zTt����1�ĈP 7�ƕ5ɋ�����*M��?g��7�����
ޱf���8�`o�`6����o��� �=�$p|Eڇ�w��w�̾�Q��|6�Ȗ[b��b�����Xs�m�> ��Qg�!�R&��keo@��� �OS��4�%2�C�2JS���8��3��y�())wx$���F��v����0��񥲃F�,�V����F�Ę-b�������s���Pvю�d���jV���.�u�\���H�#cƖ����������a�$��XXj�pd�A���c8nV_���~.�>��X�i-�){�;#B8��	1�j�5Ҕ9��_���8���r����m��&C�
5���f��lߏ8�\U�e2L,&��:d�E�lv�/�W�!��$YJ���5*"�΢jʆM�zS��������ke��������4�a�G��&Q�!�e�-�o�*��W���,� z��MA�t�q�)����N�.�@�Yb��j�LA�?uͣ�hf��Cp�
��R�	����v��]�b�>�3���\o���Ώ`0Zb�#����BT����֛'���̵8IܭכR�;6��¿&g;�n�=��x�1O
�p9�E�ml�~�׮^���8�R"��Q�
K<���=� ���F�'ӁQ��� F�776�}l�6�. �,̈%.��}3{���x�1ASz�,�����(�2pr)s�?R	�Ę�F�[s��!@��S�"�6���Ύ����\ }�"2h�$���x�*�Y�Tge6�H�Mk���lL���J� �8M����Z\�Ej�m��d� )9%؄>�2������0O柫��I�` �ccxoIZb�,ur.�-x$]S��s�]}�TOO�U1�,�X�]C{5��L��:���3&��q ����Rm����q>��fmE���J*!1��KK�Y��oL6�/��ӱ]�ΐ���@{T96˟�ae)������|B�����r:��E��d�+�e�� ������r��         
   x���             8  x����N�@�;O174�@�?�'$m�jJ�>�\���v�D�>�G��}1�=���t:��,YEi�${��5�J�
kx�,��\�?0iS�DY��.�{��Uت)��b*�b)�WtX��QF�=y����7]���d�[�7�0k�<w'`i'�ר5�v� m>��F��-���L-�-�b�[��}��'�v�O�'�*�����ta�R�K_�Z-]q��O�߸9h!�ݧ��@B+�������Ie��5��s��d�J� �'����B���9Mx6
7
*!�I��K�Y����6R�O"㜫��w���)�n>            x����J�@��y��E!��K�⩖ �X��=x[�AW���@�8>�/�l�`=���7��Yv��
����0�fޮ�nf�t�k��|���Й����?��pHm�1���*��J2Eꎱ��.�m{{�5�8O�t�h�O�����vA��̭��K�s)&�dU9�ho� tA{�p^ҿ��+%�d���>��N9���[��|�	Ɲ�TLN8Si괃'��I����$���1v�HO����3��p�ؠ�ٞ!�)����V�U))13#01���e?����         
   x���             �  x����n�@�w?�mi���$.:Q��8��ѐ�0"����3��J^Ю�	>�D~�8a̎8�����������/n_0����꓃tu��x����	uЃ��	3v9ġ@�FY�n�d�n�{�-ԝP�%z�	�p/���}�1㣅k����y}�~q���������LA	2��h�T���Pc<8� ΞP�9��lj��18���F�Y�ˉcH&��';�1ʋ�Dޘ~_�Y4q�R��Џ��V	
1�.�B�J��Q�Z�E#�ض~�\˭S���5��hU�Y}Ԇ��r�j���`Բ����E��6��Jv	��f��w���vi�.�q���.���J��v��/0-Ů�?��&LU�"x)�p���0ݟ[͙�]5�ebF[�;�'xZ���Um��L����Vo���i05�����ŖN��1Ii�UPg0���㮩L�����Mc$9���;5g��"[�jzS7�_�A���$�D%D{�5���l~4*�            x��Ks�H�.��_;v�SR"���M�$D!�$T|�O�&"�JT���������E�ݍ����,ڬ�ά�����="@H�"AeVf��b	I���?��~���;��2�>�}H�l/ȭ�}�'�=�j7�$������� �¨��>�L=ϼ0�j��k�A(��,n��y����W���K���a��/<��?�a���m~�*��An�7���0�F}⇽��ݨ+�d2Ӏ��X��G��-s����v��]v^^G���/QG|˿��F#�5	�^�����m7�@>��s�կ����_k���y���a\����4���ޛy�.Yd�x��qB^g�q���?�'�i~OL��7Q�/6�4�v�(����[K�C1�Bb�zÁO\������FA�Û�m�'�������f���Z�gY�sC�zX�X����u!�.��h��^[;�2q����C9l��s����+�����F�`�F��c�}�7��5,{��7� �e�����Q�E��7YL�}#.F.d���|�m����*��]u�!��n���{��d������^ �D=ۻ�Tq�7l�ׂTsJ����tr��<���b���ۨ�0̱<�v���U<	�ևj�D�������L��`gц}O>�r�-��Z�����Q����b� R���5��yt�{]IY�[��P�#_v@���ޕd�y@r1%�,h�O��h��_�4�Qoi�m���螛^t���ߌ�F�0jG-)�����A�t�8��A�4��x�jةG�����R�}��Q��j
�-r6kG7RǷq�}r��~��K>��B(�� �ô�:L#�2��u}����K@��A�՟������E�Wuyu)VYFM��Iv;4�#��\FͳH�A�Ҵ�N�f�c�ʯk�f�`Ē�� Օ@�m����Dm��,\�@�E���BK9��1��j;Wb�W�=�o��M�Z3j �'	�m��k��n�ސx��k�a� .��+()=W����hq<�]P�J�WCJyb�ut�2����jנ��D�ۤ�f�����e�\�H�N���G]!/u)�Az��5��,Uۃ�5�=7w�:S�q�A��/������l���Q�\S0��o�g3ƙF���G���Uu�k"��is.�)"u�Ґkj���z���T�o��v� ~�v����7¨K� Q�I�o�[��75�p�zQH�EB��z~~�#b��h�֕2�6<����.7��%�*�QwO�gdT��І�NÏCx����<���i^��v@ܘ �tVk�H=�K4i��	`8��`���XG5�פ�f\�%�o�U���P��n����;�S7"�� g���,�\� ���w��S�!h�������n���9=As��ce�	T7��T�Aj��7���p��r�{�[)�\��D")����Ԯ��\�ΰ-��ghķQ4A{����6���Z���͕Z�[�`��e��Ii G"TD��WA�K����A
�0�D� ��Ӌ���s|���� ڸ� 0��Tp�iҗ��dA�f��N�+@Й�SQp��#�ېI ��P�<<��	 ��L+���WB\�}�6hJk�t�*��}(�_�1F��m�W*Wy�zx|�X�7�8���Й{�[꽰�Dz})�v�
����*� �ۥ�s��46Ϥ�4vt��V�^��a��V�}�#Eg�w��#��@�f�j�5��CT�nO����5��p�Q�Ԣ���1����Z�#���� N�~�{?l��5P�f�����]�j�wˉ�[�O٪�w�h�l�m�4h���6ֽ���3
4����|��?AC����G~�xmٗG�T�w��c��6����B_v�Ӑ�m�¸�Ou@{>�*ӧ$�{��}_�Խ@>����Ŭ��OXJA�r�r<�u�?Kw�-���A�+�t]�n��۶M�*\�E��}�U���
E(5��Yֿ;RO�0`�G���� ~_D`m8$������^�x�x�f����x�9��`���OЋ�]�AR�����G� ��,���DO�eW�0�18�3Q,ײc��;6��c7"7��5lwS�<'8nJ� �(��7�p _x���lI����F��ڎ�q
�wK���t�y�bR.�@�q�vm��֓xFl��?!����>�����$�۾ւ ����͊���Ů"����^;����&���Dڗ=8��#��:�8S�5^ �B����TK#��%˘ԓ�]�X�O:�9�]�a9�m���c9,�"�|�{W��!}�=a�����=�k�/��ʡ�xD�����!��9[,�y����+x_�M&}CQ�c��z��!�J7,	 �;ԕ��m�w"��8���p4���Ś� CC��0��4�j�]B!��C@C��rk�o��"��0f�7��j;���Rs^x/��Β_�w���>���M��]����-���Up߁����1<u/@(����d�7M��+	��v�S$�r���TҰ�3���S�*�"м ��|0
U0�d�@���+q	 !: ��?�qi���]��b��}���nl�z�m,ò� k�r[`�Q��Va����bW�8Z�C8��D=�����qǥ���_��|t�[e�o�Q���\?���Wi�h�!�6׉L[�=<�[��ܜ%�] �[p�]�W�0L7r��;�a�t��|�{C���V ��3-�sO��\������uԿ!��(�D��Ї�4D�s�T ��#��%�	�+�=� _c�& �Hˀ�1Q誔��2�Aw�v������\�������G:�A�K -�+�\ �F݇x��KG�ap2If��{�ȓK��`�#��� t�:�TQW@�r:ZHǝd����[��Q�(�,�:&#�6&�ɠ�+d�S����<il�� ��; �F�a;��b��ȟ���{��<Ҏ����F(j�mP��L�����k�&9�.��Q/Vjaƈ��A����ܓ ��A�/׆>�� ޓ�|�
�~��c���<-�8���Ҁ��B��Gc�$&|Xz��v	���
����>���'�ܷ!�^$��)3���P�\�3-�|`����i�S�:��j��&л�t��(֖4:V<����-�7𙫞��I^�4� �1y���y��&�ysB��*C������h �]@�u���r=*����Z�\j��=w
d��Y(��[�w~��?�}�`"���
�.��c�����S� ��P��tCǡ�K4���++��s��
���P��[0y:y��c� �#��4FL�ǲ\-U�o�����?K��i)�c `ݫ�Lf2�\��� ��K5R���k�`�|^R}FF�@�x�8R�p.6�b�у���>�B���X栫�^��CS���?�R'���kv�	3n9���hT���>b}o���):���k=U��BА�@Ƨ���uH�a����L���X��=�W���*�nK��S�r�v$(L"�Z��ǸQ-���:��i~	D4��B`����K�C�S&�򼖻ͽ����}�L��%���i:#�!�g؅;u���-]�`���57�����I?�fc�� ��R��p�~�O����o�]�m���?t��b���/��f1 ԉ-��u�zHD��r"��$Z/:F-�u�$� Ó})�6*�t�z��T��T&�:��O͟Z��?ܑaҸ�s���`�>�=���q�
�JFى���(�p�^E\]9�a0�$����:�Q�`T�����f짧�!6X�κ*�2��x�&1\�G,�cWL8{�2O��F� p`���]�P�CZP^w8�2cP��~7wmS�!��:̣�t��pX�㷩J���#q[�(��`����0�v �8��F\�sl.� ���\�񊻽ׅ}��>� �Fȼ��!����f�nXbt�1*���h�@��_���!/�����p�M�|��@��t���    �K�H�����`���^�ɯ��E���NK@x��'D����"&\H(�wn� �� +d�a찏���>ۡ���hr��2azM�Q��Q�	*��߃0)�Jeg�Ʈs��w�<d���;�͠���8-�M1Q5j r�Za�
���`D���5�4�f\׹��M:�\��w|)�.h��l�B��M1��mk�@5du�a�+q�o��+r�j�c֎��7M���n�F,�5�|��K�܃e�O��� �>R�4�I��ߦ2�0m4=ҋ������B_�߲�;���;�H|�@��ߑaw	R��{/��`|c��MsnUW�[oC�d����'0� 4+
�"�ˡG�g��	"�{R����.`ZD޻�g �
Dd�AD�DDӻ/�Inl��`�*��ו3p[���^9ØgX�,� �W�
`��A0g���H�����}� �t].�nf�j�&�T��B�¨@�����6���Aѫ8� v
������^��7�0�^����^)�'�qo	�s��B�)C�'��BB>�Q�oބ�D��2<A5H"�e�T(ű�JY�j$â�o�Z�$"��I�D_��������y���!���j�6'�떰��L`�Z�<alC٣�s�QZ�=s�e�gϥ'_���X�;�ɼ��l��]]�҈�e9�H#��J�I���詉�Z`�h9q�e��m��<;%��_�4�e�0Ĳ����A7{�4112�-�T[�4)fP1�kdh;�Y���	��&�:V(��kb�n:<hm�b��4�\�[
�ɪ�ZL��03���r3���YH��K��t&&��I��Of��jfz 1U1�G)܅��<z���2�{2��=:-g�2��R����2u6O��J>����8ğ$?ų�<�1g��9=�< Rȳu�M��RY��%sE˅�K�ӄu���å$jm.p@!I�߾���x�0s}��jU���dVܔZs5�-Hf�͓�X���@���dO��`xfz�XրI��5���Ui2;:P s�R.�vc2Osb�������7��h*ዾ���$}���z�U��D�Q<��J���7�sUI*ϯD���lF���#�3l-��5��d���l��1�;M�q,� �B�7=��̨�lϴ=CW�U��p��(�Dڢ�樢��& C�+&���~._�p�W_�����Ŀ��-���1Г��� d��6�ԕ�|6E��,��`�\�rR���]Q�>��/H{ة��֞��Z?��ZӽF�Sڡ�#��5�5V��_e�DR�I����`�f����ԕ#!��9%u<M,R�2r��{@=S��������{Ýg�(������4��UE/×�#�����Ƴd�k�|�Hyh(��V*�J�U��+q�Au�aD� �eF�i� `ں��K��d)�Çx�X��z�>[��£ro�`����>����}��^ ©�L��ɛEæ��]ץ	�^c`؈�C�]dڰ���N]I�h����_�p]&4ij̳�g���6�,8*G^):��j_o8��t�E?�M��G݃q�c8.�_��%�x
��b9��釘�3P�������Q����f%����{^�S�h�p��r�ͳ�J�$^�A�v�d����,���G �r��A]	�rO���l�$�l�����i����~�ϓ�U��#�z����$��W��co��syj�d���Ԕm���>z�n������m��)��O�Y>�b;Z�b���ۭ�*_��t'І�]f�~	u�Iп�{x�FF@*o|wp�P~t��ߔ�0�m�[4�� ��v��L�7hD��E��tc�A�.�
�%g?��	��둴A��Sp���{Ŝ�ȧ��w��wL��&�Չ�ygU��.� �=n��`/I�v^���0�Gu^����a3�^F�A;�~8)���Я)�T�2O:��$���q�o�aa:��*�"-)�`^���I]�Ɗ��C�w����&a��RGaK���>��v�l<s�A˚*U�0�͹f�Oq�6�|k�Qȸ�]��!�
�{=|�r�j>����_�l�����_�e:�t�x���6a���81��'	��UF^��x�	c���\���,�C1=�QOy��+O~S�`� ,�P�S�u��)]�llB^�k����EW*��|������a_S��� C��[щi/�9�Y����n�P�{��PeK����
�?I8�?���� ����q������A�ve"	�L���H!���TUe�m&u���2=]����a�=�>�J3��>X��_ޞ���*R�����y���V^�6D�W+�����%�U��&h7O��	ȏ��F~����K�0�h9��E$bM�-�;\U����K=/�$����@�}�Zƞ%O]����rT�W���-�sD�^^~�(��-ǵ-�ɯ��R������ ��Ȏ`B���S|�ɝ�,�v]�p���&�羿O_~��g٥h�S����u���fa{Iy�M[��?w.-�;�Bq�p�eZz �l���T"nw�fљQt�Q�@�\��"����K=�� (��<��YKvuɿV�G�o�-��¦��C�����ű�G�t���y��ؓ�_�z�n�Ŝ� 3�g���0�!�{?�;�m��Ĵ#&���wakL�Q����=MÎ�k�sf�<�+ �^��'ҫ'�������1�:
���d�z���'�A�2�~T�T!�3az���C<��/��r�e?<���t�^�/�a��w��<��:ck�4"��r*��q�"�Œ>C+�+.�)��ˡ1�-����:�bG����
�*a�Mt$�K�/QQRA�
���Wl�WH��{�H6%��(��J*��Ul?�lMEq�C�a��;I�L���kp!e;7
�����ֲ,���D��Z�i�;/v�l�eB�s�ki�ϭ!e]�3�D����cԸ��`-C̻���i*�F�9�cP��r2�WB�{h��SL������7��<��ղފeV�09Y����6-��~�k��ʢ����|*�?D?Do~4RU$r{��,���A�z���Ri��@%�`6��(��'Pc�3\^�`���`Q��}��o�<�����nar2��l�:���@�I�]��~_3��dyN�v�8nXV�VW���t<�P\�+�q�ʘ�'p�`��L��E���>%�z�{�"=�o�c���[GF���Y�j���ɖ��)�"2X}Y��{�,�U+HF�\�{��-y%\7l�� �q `�W�# �F]���kp��m��2�R:_o�P�}Xv�kQ��Fe4��[���e�%����I"��M���W�K�~��
�$�����i'��Y��u���;��$�8T�.������?Kh9��te���4��El���]��:�e��<5��(VS}S�"~�a����\3���I�KV�ݕ&r�8����fŖĬaZ�ߕL���}�-y�XY+��<�MWW�|(��� z�[�k�!�7�i�c;�M��_า����\�Z��S����v'�{d�p�KV,��t�G�6g{�\�W��DȦ��1���n��p�S[�V��ҎI#�>��%��-b�������Y�M�۴��2w��½�G�xX~K��@V9��┘i��Yp0�{�e*|m��+�B`(F�h��XN!ݶ��YNP�R^ɪ�b�m8�+Z�QWR|�5�n��z�{-}^�Y"�����0 �����v��ɕ�V�x
G����lH+*�����[�~n	'��}��OEu�Z�^��O9��{�ZdLS2aں?P�S5Q�6���R
%7�i�N8����_��_�IL�Dk��~�5�? ���֨��
��K-��˷Z�q��@�f�=/�7��~��@�l��M�?[�	�ҍ��v�=����Y��9���~"�m�5'%RD��Z�[@M��4F��%��[&�2�3ʦ���z�4���bI�(���!�������Iq�a~�vq!2p��1:�ޚV�������hO���y8?�~)i!���|��    4�9 ���|����jY�[��m[���p��JN�c$�1[��,��i �ƘL-J� R��χP�HJ����L�20��`�����pNIy���	n꧵��݈��O �=����2��������Y�|�x4J3yd��*����X��T��-����g�+�����:�c�!�(ܑ4�(���r���%r��|�~5����Wx��A����a7�z�pP�p��n�S�+�n?T|��U"���I�҅�4Y.�}O�*�Qe�, y�{~%.�KT��	fRS״�M]1�	��q��ť��Y����N�K�L�ҋ\QŴ��`�Ĉ����i�s�TB(�mo����Lc�u������~
3�9]�󐋺����;`W⺌ؿ��Wf-�æ������˗�ա^�fWГ��o�+��oC��LVh�>K�G7�+#cm�r����Tb8��sgGV��)~L&�"&R�	�a�T��������i&cS��B�e�d�b�CN;��,���Ñ��j�v:�l/��j��3HI >��S��Rz�5�>T�{�\��M��~�Jo�L5�*$�� �8t�:u%c3I��O����!]d�<�d�����5�l���7��������<��cr� �Em"{�e����/й���?����jN�$Z�+R����ҏ��[RTbK�q����$�q<�][��[����R]I9;J>$`:��KN�p�c�4�4Rb��}\*ϸ�>�8k�)΃�D؇p2��Uy��4�(RL�H�˂Ty����B&.�[#y%C��{�$Fﱦ��'�J]�q긆�GDǽ�Wie��]�s���Ơ��s������S��Q_�$'sU[���QLn�%�wPLed�%X����&���s�<������@Dr�� E�� %a����e�(O�9��ϡҟ��N�!k�-�����n��R��T����҉�5$2�}PK�5�%�$~ZMPs2����Ѿ+L
��(�e{�k�S?�e�b���*N���Y;��{�����4��qbIk�~5��e��U<��M
�>����d�^R�R���H˳<3�c�\	�����W�Y� ��yDKV9������ve�y�k[I�G?���;���֣�s<��X���W�ب�lc�f�l��߈繛����d�J��`^�#�'��F���v8�^́����c���8���*߈a�]���.j�K���VI2n��ߴ��{�O�$,����!�e��f֖��ٚ�Z4���Si���[;�M��pM�棉�+�b������#�=��p%�|���Kfr�h*W�v��U����*8J3<�6���Jr/+����/�E#^
4m�Y:���;P}�,�M�ܺ��&�G-��]:Z�	�'�LF>gscc�6�H����u�M�a�d����g�9��k[��'�O��n�դ��!�_�d�1s����+S�߅�p���/�}�������cS	�p��2�����V)8�`v���+~���c���M�}�w� �H�/�S��K��V�A�L��u �����~�6���H�jcȩ����Ƥ��^�+\��ݨJ�rL��(�l�V�eJ ���G�!�i9�7<n���Z�"��˔�ȧ�[+�C�KL�o�
��Lu��Cu�ߑ�8��\�H�;�s�TW�������T!�QAM�5��x���Ŗk��z�Zt�������}�f-��C�m�VM��2��ڈ�u�n�'����_���ن�>Pf�J��߯d���vKB���<�Y]�w|�G+�@r�B3�1>KE"�M<^��ԥ��`����l��x����f������I��b_1����D����`_�Y������H�L��;O���ij�t��H��,s�W��`O�g)��J����vM�8h��x����S��@X��q�g��|"S?3L�&�AK��FK�� �ƚC�xc��XК	�2�� ψm}�9�ώF�;����q&@�?�q5ݗG̷z�98�}�+N^��<_�Q����hҍh��L�[��
�q����c|�P���Ig���q��N��3����l.��EoK�Y*?E�$�������F�SW���t�,3r������p��cj/�'z���^ئa^X�؜a!W]���6�����.&<��.�G{��>:�o�����&�D7��;�DuՉ�`v���6�0�-���0��nl\�C�e��s�_�DG��OK����p� �k �����<Nf׶s_9E����h���C��߻[Oq\��s�$ьO�Xc���^Vp H=��?��,��.v�2Mϴ<�WXDm�݂j���LJX����E�����[#��Z�m7Q<L�*Q��J��u0�Y������{�װN��7w1˼0��X�C�Q�n�uq���-6]�A�i%�t�xZ����ײa���P]Q��-�������C�mF�`���	�僛>���T��I[`JyW�k$��nd-Rp�%g�
����[�l�8sp������C��ؐ|b�,J^wn��'�
$ܣ幮TW��$/u����ů��z`�i`�������
Hm_��^�(֓�UQ���[�6k�������v$���1���];�;�cķ�	��a��=04��F�}r����D�M�_Q�V?�U��-4�h�7���<��Wy$ϵ��]���
 �M'���_�%a�@L�h�nr�|���Z��u˪�Q�'��v~މ�yYᕐ�O�ԯ��LS�f�s=�R�t! �Po�6]뚣+���r�U����ps�Z쯏<�PO�V�8`��Y�A��(���U=�[P]YW���<�a����`0ò����P8�����nܫj��^��AU���h��`�ii�g�ș!���u~)��j���ov&���E��R�3�I�l��/��h�6Do\G7a��1㕉�x^�N�3��F ���eg��x1b��Z�E�.�t����6��ۚZ8�V$�)3��Ф��C�9v'T�N�6l'��0�����'�)���!:�ۥ��'���μ0���E��#��Y��!� �� �!�l+ETŇ��0(6�1-��˯�e,�Ƶ�q�#�#�0��*��+t�T/��͕X�[���1�zk�e�V�����/Ǽ�-ׅ�o�8�JZq��ً~��O�'�ы�t&�=�X�:[�45�F�zq�m��x��kA�тq5���A���
F�-X+q�2�:?���.E�oo\Y����y/�����I`��>e=�S1-��8uT�ZY�!�o���姞՟��`�m�赲�����ͩh]Q`sn��0�x�K6�H��Id;�d\�V8�9�>`َ 9���K�Ҳ.�X{��n�ƪ��o�U-��A��Y�= �Xn�S�(7��b�|*u~%=/}�������cw,#+aMQ)o~+W�-q��~��|�˿D��֍��g2y@�@�����KL����n��(G��?�WҽҾ�{�2�<*v�bz�1���~���\�q������;6R��t�6l��G���t{]����P5{}�>����8m6�n����h�ř/�ۨy���S��i-�M{����<������r}b�
Qf���{�U^�������'A�5��'����(g���N���dMB�*���ٲ<���Y*���B�J��#�y���&ϒ.\�=x�D�0@`����l�x뭆E���w�Sz�	��&�j�B�-�x��&��_�·�`3���ݸY��C,~i&N�3�l��~����=������k����(��/�h9���o���p9�}�?%X�eL[�eSפ��4.�z-_�����.z_��aZ��W`7K��p�v���3�F�Нv(��r��2� ��҉%2X�uT�K�f?G�R��F��Xhj۠Z K]���[�xy#gu��Έ�ҙ`2��x�W`.��k(jR�y�>�B����m�)���L�
}~�j��̍~-L���S�T�k�L���%b�9N�~��/iWNŉ	    ���e��7L�)�`�aj�5��W��jؒ*􂫯x+l�K�{*�~R��VU���&����7)��0�fy�B�6���ւ��<],���y|��֓����\9��$P�:ױ� ҜDbe����	������`�ldބ���	{~g;�j{B!�5�c��<�Y]�w��v]���yJ�8���^c�EQ,�8� ��$��<���̶��瀞��7T��g��ι�{�B׍)��?]�&F�� 3[��SP��AGh��I2���?E��/Z��z��<D:�W��51���)m�ZD��a'��� 	{��ߣ�aT�z��`H�m�ư=�������ۭ�A�����`#Pä�#]優��� d�U ���p�N������=~6ݙnp� +� ��FC��Ut� Z� MuT\�F/�Hc��:&Wp!���8l�o�܍\>���!�y g8M�|�
�y�K.m����G��\^�g� �j���ɰ����(�Z��x�oBp5��	x&�)v2/�� �"���hƳtw�"vl��ю��T�$,I�W��:Ǔ{��<�J:����*�)A�C-zWo�2�/�ҙ�Q�jc���׾��<(��Z��>lW�u�j����@���P諟���Y,�I���#��dŦ?"��IQGM�VYS�V-��ɾ�����m�z�(�Z�7��4t� h�E��\���`v�yf�<�a�v����s�2&���O� 4�i�ɾ#�A@�U��q������۬ p��܆bgH;�)���>5Mi�P��er�����^�E������SK1���QH�_�-1��1�D�.v�z�!�V\�)a�-�Ӂ#��6�iN��N� �u��#�+�3�@p�Su^��m����m13������،�Еd'�ݖ�_�w�k�� ���ӹ�E�lS%�dk۬Wg|=��K�g�N鮯�ʼ8��1�9����5ۨ���<��8���$���dd���[�J�*1�S�� =:�[�\-@� �5�݋.7+��F���Sĳ���zD��"_����o�x�}Xb���maD���U�Δ��.������<V��
ڑr��~k�y@S]�����3"LTR��O��e�y���%�DE��"W
�ٞ���sRv��rl2��Z�ia�{����:>�smL.(d��-���g9m�܆mi@��ww|��l�7��1�rʻ���cE��Sד�ȪFc}-�s�/�)��l��rt-���`�7�w(قC�/�\�8���6l��D�]��\� I&����Dz!Fr��^s����ՕK�������Dh�E88�fXo�yQ��?w����`缢��e���P.�&~n\Od�'� 9=��h�[�pc�J��7��|r�ޤ�&�RpM�\b���Ɏk���9U��{�A����vp�����'Ϙ�~f~��a1K���[X1-Zճ����1vW�bO�[��=ǒq,1�F^	�͛���*e�,���TԱ]��,�,�KQ�MK�ʣ�ĝ6S�t��jG�c�������{�]�Dw?����%������e�m����LD�좿����k���M��@�􍊌K�Mr+�(<K�Q��`G����[ð}���V��a��@T#��TTLh�j6�Xȱ<�u�'�Zkҽ9C��,�E=j� �oa}��S^�R9M֚�lu�Վ��A1�������.5
��z���a�Z�3�"8v��5�'G����_V�O�LO18b �s��4��#���Jtm(��p����**y�hQΘ��\C}5�s�8ױNp#GD�0Ǚ��G��jM�r�{}��8�_��C�� T����5�������$]����)��̏5/Q��,OQW��l9OH���P��d�	/I����.?�Wb��F͂�� ,�a��&���dx����3�9��Y{sE��l>�G��e�t�PDl�)�&(�&�&�
��M�5u%|�8ԣO>�xSj�� ��	���x@��/87m&g��k���{��������R�Q�������/�\BE�B8�p7�8�ə�����
��˫7~��N�gsK��r�'�:j}]�Π vh�=Ha�j5=FFi��ۘy�g�4���x�L�U划'�	��%Lp]�m����.�h<�;�Sv'�?�	���fȶ�W�Wc��nk�_ɩ��ڮ>�f�� =@�8.	��Oq:�3�z~ld�9��U�ٶeZ���I.��F� �=)�����%���S��J.6���'u-�u�^ح'�5D�Y��P�m8��iC{�Ju�h����Y�f���Jp((5�u�k1 ��F�L<B�/�r���t
���;�'��l,$�Q*�p��"����e����g�t�LG��*kW~[��A���њ�%��ߴ�Ñ�F^u��K��JLp���p�
��$�.��?�Ok=�ABq��I��W������x�	�y�,N$2V�_H:S��r��R�E�<��,������H�f6J@YE�����ӹ��M�'i6(�u<�Ӕ��h�w���HK@<Y����5��>�{�S�������<�$�Nf1���E����ԞN>�י� �ce�y�H'�0l��a����+�X����)�L�7������Y�0�')yaQČ�b�m�T��=�#8Ny�������3�k:���I�Բ��2�e�Cy�E�����".�R6��Z�"�Z�� ��8)��Q�P�[[��J5G����YF@���_�_9C��dw�EwB�)K�a������ڻ�Y��?��3Ѐ�x�~g���W���M<��*!�l���5�d�3�rH:[�t���^l��m�r�_���_�l`��Wh�.�xD:�8�^��&s��YB�#� j6��*})B���6��TI��_	|Ջ�
��sHa�Ĭ�?Q�'�8|��\p��N�v�K<Co���\�"]nuЫ��m����\;y� pP\�&��A����~�o��X�Ʃ&(���+�[��� �)�~������7��ًZ�@b�er/)�}ʈ�hyW�ze6��nߖ�[&p;��K���%ykL�o� �$j`�h�u1�x>M����LP�`�i��z����c�n���ġ�d��Lk�gC�`�/�by�ؾ��r���T"8돮K�:��bM ��!�����V	�K�y�&�q��^J�������&���n)�����=w��w�
X��z�@H�j�=.\2͘����>�J����pu#����i�ʈ�����d#tZMf�L��ڡc�{z\����)�`�%�s���i`L��o��k2��v9��*"-+0�i� \5�v���A��]2Y^~0=�=SM���}�|������2/ �管9" ����l�c�ä�6f>ZF����&Ίc����0�6�E�0{�Xr�3R�)��c됫R�2Lj:g<಄�ݳ�o��&�T��YN��<I�i*��J���i�`8rtқ��<%����`��MG�W��|�дZ��`��w I�M|7��a�ф>7�dz�_0!m�����`���o���T���ҷyu?KF����?�M?�q	.�ŵ��Nz�&�n�R��&��F��������T���<�բC�Ʒ\��>�ʢK���-�L�<���Π�/�}�h�8&�q�N�'�d3��I�"�bbq_�̯J���Q&�+O�ٯ���`GA�i�y&��z� ��J�T�akWTϖ8Kzv�)z,��s�r<O�}�jr�z��^K�.j]�W�ˑ�ਜ਼_j��٬(�՜����G����`�>s-r��Q���s�f������XFC�#�a��Z�`�9�Ⱦd� �q��ư^�#��i���M�u��J�J�M�%�a��*�υ�*id؎gs͎�҇x�>&&se�����)���Ln��\���¡�u��j^d�����e|�H'«�}<�m�&)bs�.\o�F��L�w�+G�78��?�ˤ%�����*OZ]��{�(ݖ�,�OSu�d�1�S 혴��O�M�������9���    ������HH�o��JW��଺T˚���,��p�v���1v����p%�j6�f�g�!��xQ������15QQ��<�7�x������\xF�����"#ߩS7Y3h�e���U3��$����]�Q0h��x�p!\�e�b���;��^�eT��{'f������r�P���D9ۻ`g~���Q~ؿW����H�5s��[���k�~�+��+�:�JU
h�Ft������,x�x���}�-0��}{�湁x��S���TŲ��,��G����t�Q6z��b��n30�O���c.ZS�G���.p=o��
W��,���W6^�%D�.�=�O��LR�����AB�Ƥ��DRթ҆��v�>qc�Ky����I��H�,���h�>�e�71�'eQn��L[g�Z�p�T�,����ݥ�Yb5�Q&;דe�7ؕ�kqV�]'��b�p�������g��f�5��@m�T��2y��i�Fe�=�n�Y�9���}Q���S�9��Ym���l��d)j 0�I1�Ļz�sa?u��C<�G#��Jp|���"�]rWID���l�9&|�D�^6����W�m�!���4
���1H��t���E��43V����\���\�ש/��GA���� ��dM����Q����=/��/.A��L- �>>�?b��Y� �+䀪���m�����d�47�����8\���~Z�Z���o�.���)1<���$��fg#Y��qO��mxr4˦��Rĩ�����9�`�&r���z�K��&�
�J��g	w�7<�5��V�`��������z����Jj��Jm���*��\�>O��M�``��h��,�~2���R�1E� ������DU܊��\�gʽK��]1���MVb]M�i2�9\���=�f�4-˥�Ǵ=�Ng�iLVw�t�Д��:���X�t5O�I�+�#�6����6�c8�(�QU�mN8c] �7�t͐�����X�o	�A=��8|ϰ�Zp�CCz�I�(1��V�I,b}��>�Q��<j3K�C�q�,D�T�o������y�[L�xF�J�V�o��C>%Y��@��:���iaEb'��8���r��->O��X;��~#W��y&C�l�����[n1ˤZ��Z��
�{$&Zq2�gD�p´0��N�<�؎f\�Sk��~�i�~�&+1�~X}��?�}1�gKY^�� �yѢ��UC� '��:�����^��w(c��,#��˟�*;�s��H� �y�űL�cK�L�g��j����W����5�d���nm8�6�� 0�b�&B��\{	:� *=�F�O��Kcͻx�L��M�lzD��A2�� J�;4�y�����t���k��W`��3����BkM^���b�M�^�"�N���"�*i�1�Ɛ��\.tC��1j~G�q6y��>vŋW�"����p��ݦ��	�t>�~���zU[��h�N<NTOD����w<�"�P�dM�J�p�������zV�/Q2x��'	��=m�nv��帕w2�T6u[֏�?,���i���T�W��x�Cv}����|%<�2���ӓ@n�	 ���{8������%n�N���N�ܟhf�A �z��Z$V��ߍ���Z%.7��:�������?ü�}�"����Q�w��w��x����K�\u�K�7:�l!�fk�X�2@Py���ivM�z����/����䁑��[b�i��/;(R�u�{�����>[�^
/�� �o0��*ڭ���Ww@~w�~tZ`�*�Zv��D[�x�qg�s�l�znF��8�ߌ���n�i�DR���E����������S��*�>;���Zc���1�gϱ�!�=l����SNf���ʣ�?g�O�nq�=	[��-�6j�r��;�f\����q���қ\���*�%o�؍ҭ��L=��g��ьȚ��܀L��0.��0~�L�Y��
�j�����*1o��G���
�R#���ΝDk!C/�+��E�;\��y�R�y�?�M%��%we߼Ubn��J���L���w.�F� %����X]�,�G�M�9L�O�]b���i6�(�D�x��j��<S�7Ų�`�pGt���"�w��]����w�	z�1r�~��7_A�ߐ�O����K,S=�,�Q,:f(9S���puy�"%��2�nk��ٕ� �G�[T.�M)�Z��%�k���]�iڟv��k��1�t�4��4f���<����?ğ�������Y��v��
��B�9���
#ϵS�+�m�zFd�+����&ĬW/Q��m�3W�/��._�<�j��*���O>��LDx���JD3�F2J�&u?�������b����*�Xv�=�}�^ʡ����ތa�`�����1�5 $Ks�ɦ�%0j����Eז������@�{�Sjċx��L��Xi��dlr���rU�E��ߗ�)1}���]V ȪT��g_/.N��7/p�r���3b;g�֓����p�MV�QzA�G�|�(�ͼZ�4î����GR���'s��r�c��x\��fyho�
l2�G���-�� \�B='���hd�S�5y1� Y�E~���#,N���ϖ��RX-jz�K�+��p��_��˥n���ݹ�*R��8��T�Q޻��Ǔ�@���l9FHN-P{��g����i��5�>9C�c�m/1�o�6������dJ�*�p�ے�D�Ĳ���?�.6˂�x��a�3FM�{wg�������=�q����6�'�ð�c�~.���	�\Ɓ�����]b݊��N&�_��qL��}YTܵ<G��^�)&z�ь��,�o5��ٽ�N���f5S=Q��l�SY��W�P�H�C*z��X� &��o���sh{���x"wnFg�5#X"�<O�u��jRZ~%G�^Jki� ��x�j��㬴S
j8p���6Δ^p�s���v�f�bq�=��V�I��\̔�$�t�z�v�8��N�����C`C� �l���b_>$�{@��>��	=k0^��h���P7I��da�K򤸇1�߄#��!�l3 G}Q=���Q�4�Yi��sz�����l	oFk�r�~��XZ�l>Z��ꚡ6R빼K�J����<[x����2Ϯ�g�y���.�m��셁#"�� Q�snX� Qu%Z.xZ�e� �ɟpJ��&w/��A�������Y+��3���20������<������:�l��ȣۤ�ᔝŶD[�ǖ{�VV�z�'��S�����ϻ�d�<�ާӻ2�E�l>,2Y=����6p�66�k���%`$���jn�s���M�K5��g�lV��^c �lǵ+��?M�{G���&�B��l}Q=N3ѨQd���f%�s1�am)���x����x�9���xI��'�RV��-�5sn�̣1[�r�^��~����um��R�a�o�oO�mh\�'�էO�l#o�\O��<�5F��	�A�*�����*;E�6^&P	�� ��GO�]��rGL��+�-PY���\�;�/���l��ƅD��i�62��c0�n���I�9{p|8I����7�*|Á�|Q�Ìm��]������ ����x+�� ��&�jJ^�hS������Ѭ�����p���w��@N�g�EE��Al[Co�!��N.���vsR�;�y��i^=��E<��lY�p�/A�mX4[f�C� �4�?������cu��,��,aK���,��-��mP?����	A�P�I��``;ʑ���P�u)��aqo�LZnF���.p��E3-�gG8վQ����"���'����08J����P��m�ԕ r+�����V���e 4h�y���e�B�Da��W���3u�`P�I��z�d���N=K�4�p�1D�ޑ�d V�J�	g�z�{m�C����莰�Ī�]'���K���ѹ�٨���6�����M�X_S5���+s�����D�J7Czq�@:��󂚻��A��өT�$�b t8�=�����3����y��ڰ���^��    �a�xЈ9��SR��P��?�Yj	�|^��}ߐ�^"���kֿ_�CuHT��z�G�9�ێ�kl#����n	5�2��-���`c�֘����I+�r-K�#�?�p�o��]��8R< �����*C�p6N��8Mf�IX�+w$�-��rq{�$�V�ߪ��v�50V��G�Q��|ƨ���ގ�d�UOn�V	��
@D�OrPG鎩��b�&����E�HL���h�/�*�-8ɖ�9n<C�.
�|�S��"�S��߱߭��mzw�i	�5��&�J��5� (f��m�z0Y8kx�W�;��g����3U5��|6�57��z��ot����z���x�W������7v����6�i�`�I�P�4;0ma���8����-B�h_�1�¦`�;�^�����d*��� ���U��'��hF��v����-Pw��Pw�d�7����g�#�VҮVO��d�,������}��>�l�YS��B]�p��d8��55��ԧͱ�ܱ־��k�Z�e��T��9�U�ާ�����J�38�[�:�:�πZ��&g���k�Զ,��N���_0��U&֎"&NP}�&i遀��*[`��,u�ë2?=�\��l�l����IЉ��%��S���C�P9+{�:�K�i:�I}�H�Xy���8��`7�#DKcH�=#-�p|��F���!~��������Cz��a9�s��E]�(s���n�$�Z%�ª�9D�lX&����X��2Y`K��N��E��M��IE��Gj��L�ҊVkԕ�ӭ`w=W�Gj�$7��l�Dư ԨJ?Ω�=a>!5��QC�Vc���w���lxٽ$?���T�%��f�T��[&@ҹ���O�&��I�*�n[[l--�_N�#��$�VrW�T��M	��(�P�[�(��T��|���Wؤ�U���؄i��s�I߹^�Bx'V\��x�-�%H�PTr#g����LX3�83�I�L��B����׾�\�v��]�7�b��"��L��@KwmS�9����&�#��ɀ%���A��N�Y��5/��%��c�lO�ސL߉��R_����	�z���9ypH�ti��*i���)eG�?,�s���m(҂��<�C������ߏ�%4&>/L�Z�:�-T�� ��
��=l�~����M�q:��LN*�?;ף|y��Y�9;�WH�ޭ)
f#|��0���Hp_m�>��� �&do{�/�p�w�-Q����ל�5�v�\KB�� /�GД��-K�v@��<���A��ϱ����ȫv4V��0!��6�#��
�.��	��ԒCfر���\��Z��3�h�FI7`��&�5C�vK�eH#�ʇ�+i=ǫ��8�R��ZVq����J�P����˥�6K�]��~�����[���!���1*����m;v��o�}�J�  C^���~9k�w\~�]��/)�����B
�Ƕ����K���JX�Z���z��I�J��&�0�p�F�����f,�\�C�p_qc��gb1<\��2� X��J�8\&{�h	�svAU{q�Y����㻴��r�oW���E����B����Q"_�t�F�m�TK�+��T�W�6'�D�*�[o.�M�6ݬ������Q���/0v@n�(�d���<�A���rk�T
��-sa�%W�W:`�[yՑ��f�!�K��¾W�
�ÖK/LC���-�k--k��G��j�TXIؚ��-��H��-��i2���W�<&j>��~����.[t�`�.Ai�	p�L7�+���Y6z�b�6�.�����K��cO�����83�單�M0	��\�O#���&���_���6�i2��?�
|��!��KB& i��Z�Ja�i0m;�s�"��[�&���ٞ�d���x�s�[�/��Bm69�S�9 �&�U�.xh�[T��nZ��6s��0��t�E�Tc��/&#��a���i�xq����2��y�lj�Y�_@�n��'����N?��eQq#������Q�i�~EJ�[�U%(��r����6H[M��'����⹼�m��q�IL���p��H<s���$�N<��el^�+@�&W�2��G4|�D�},fbVE���H'8���_tq�9vm����7�=�j7L���+�*���Np���ڟ/��}8�Q���� DN0}�'�x7j���+oE�Œ��6��Y��*�m�ƒ*K��|Ӂ���BﺭȠ�M��� �ɯx��g��6�~�����A6_������`]٦�XyQ5��iΔ��i:��ԅu�̀t/�f|x4t������w���i<��m �E!��ܳ���-s�EO�]��)���5|�5�g7�㿵��u�v؍n�?��0�����ɍ?腍�����5�&��^K0�;��κ���I��E�@~�oD�������OzQ���M�>���/�/t�4�E;.�(��%w�v;z���a��u��S��9��I'h��-~!�*���N�[��37�`m��4�#���Q�o��H_rQ	k�����\֎_X���w�.{�l�ߏ��=�7��G��"����ğb���0�Ӿ��ˉ@������^/�H#��pSH3h_�]yJ�M`N��Zw�-�n���~�2��s�0$��"��?�G�e�N�}4T����#8�8��N�/�w�YH�ߓW�5󾻥���}�$(Ŏ� 	�v~����+�n���nL⼨�*d*�Z�cY�0x�L&��P�f���@h%����<M&Jrz`_�6���wv�1�p�pߣ[V�\����������Gb����86�#AO���R���"�s;�RW����p����WSE�k��!~
a�N�,a�1�(��q˧a[L��L#�����|2���>������iY��I�Zp\V�[����-�x;Ǖ���d�8�� ���?$S�f��\���B;H&ɻ���*�9���0����R,��ߝ�s�ߜ(ȓ��R�Hm�R�䪠E� ��و��D�k���L&�0z��S'H��c�w6������%�Kag-�(��o���S@��a�[�R�����a�]�:&����po"u`���6/Ve�.����T~.\e��.f��<QW,���%yʾ�.Ik�i��+q���t)��a�7�JMmf�л��r����I\��7���m��_jW�ߞ&�q����q���'0	N[1�����sY̔B-r%@�ч1��9�X��ğL�{�~� ���4�Ž��r��<'J��Y� ��,�J����`�1jI��t��ŗ�dy��}jn� �ʘj>PF��Q�Y]�A������t�+����s���8�Q��F��@5�T+��f��޼���-+��y/�t>2��[��^�#zR0�e&0����ӏ���A��6c����T�����'Ql��/	�qM)(%x����U��3�o=�[uߝ��{;���Rt�
 �T��I����0U�rSN�Eݨ�Dlǚ�$sLM���-N��b�ݦ ���<ؾ��e��9�"��N���h��J��<�u��
����iӰ5���"��),\��ş>�|����U2��\T��$���x�P�7����h��N�HN��p	���zj��c����36��e��|�2�[��mׇ�#r.���j|�Q��\��,�n��yäz<�CD/�O79���i���ᮛW�+Az��Z���}8Ns�d�ږ���MS���b��2�=�2��f�|*n#&�]�̵�'5�D-�*��r`z;yGSu%��K��&7<1��G�	Ĉ�.� ����|CRn��u�I���3l�c\�/?d��V^��=�U�hLA�e:+U�˽d�<`J,z/���d0_�~^����Z$�B_ �#`�.8�l�@}x�_�D0c�c�h ���`޼ Y�t�g��b4W��J�%��{��˨pHY'�gװ.p�$���6瞖�%�׻�r�w�2�����?�sd"�-�O.�IZ�d�X&�&�Z{�,E��    �X&Y��t�Z���E6}�ǲ�M��+�j_�[�a��	�v*�:��e��
�R��Y3�4�]�p����@^���̀����QT�7xة����E�I�Z�� yl}Z�t&z9�}*�iTP�'"�&毃"K�3?���_pGN��MW����1��,��j�v�jmC�n"���y�X���U �e�p�䕜��{��ntH�!���1���b1=\�_� ��:ح_󆤰��Xi�'��;�Zw[�S��y*�NmZg�-����Y3�8B�Q1bc�B��j~�YF�a"�&�d��TZ�w=��y���ZV�e0.$�ȹY<7��F�9�=u�����E�9S�Z����J$���Iy�d���-[���uE�Ō���wYnI�F_%v�Sd��ˬ��(�U�&��?k����L�P�����8v^`fu�m�m���U�y��0p��KJ��]cS��"p��_>�ܕ�$<�Ċ?���(���}���t��ɮ��>~�����E�ųf�I=!��Ȳb{u�9�=X�0����c�����]y���_E����n����ìr�o���%W-5�����v�ύ�Ա\I��ʴ���~1p�^7����H"�&����hu�k�Ӆ�|}6�i����O�Ez���[��V�?I�1�������ᖠ��Q#}c8U�e�c�>A�}ߒ�Q;�Դ��͙̤�g��{��w��U�{;Q�a���?kw�e�k乕��B�����𚶍^B�v�7� ���p�p�qi���e9�%̥���n�(��5ʘ̽	+|�C�u�J�:"V��/�5lP� D_����oGw�?��W�$g�^���&�2�s��%�6��g�kx�7A����j��v��R���+�X�N���,d����C�����`0q
�_�g�j˟��C�9T$�[E��*孭���8���>HoI�8cb[�g́�Tc���"�h��}%.dP~�p��E.}M���q�:mu����l1I1:nP��M�75|xտz�Q��'���,�h���X�J��y����j�u���d�@<����B+5vK C�a�1�*�oC BAK*�r�w_���J.iE��n�6���2��iT��x����E�X�C�=�"�	g0�w�DC\=M��뎲�,�������R�³`���ٻ�Uԇ�vN'D=� .x-���k�7ں�;�G�;�6�Ąd��i�|�L5�\���2ِ���t���A{L�4JC���-�gb���;��d4M�0H� ���m!/a���� m�$�_�lnWj����är��� 5,v�R߰<O>j��F�Ķ-JL�J�.���~h��KM���NF0��-�mA�[xecx�n8ҁ'�pt7ܫj�8L��*�&�y~چ�ILc�����X��z���mWG����Dy�)�	�g"=7~�%eib�E�oI��Z���~s;p�� dx��"�i���m���y�@�J�e`�v-鿵�xU��3�.O@o�Q�|��e�"/*�
�z���pxƟ�� 
���+� ��,0�L�)�_b�V�O��Y]l-V>��-���d�s�����4�©�vQm��n�R�K.'�>��~<>;�6iV��DEL����
�&(a�ct}f���njeI�!�A@L�(%��J�;���6 �����]�^	/G۸W锣#j���+A����ғ�p�_�lu�r'MV�"�2J�1�8z��ە�*����@p�|Ka�ՊyN��mR�������6�i�6Y�2�z�qLo�;ܶ�j4r�>���+�p�H-�I��e��Lݲ�Grf�t��>a,�	��B/�o�&�Q�rŃ`g������A<t3�gY䳨G����=����^���^nw�/�+?��	b��lT��&�9H�Qբ����7�M�+�
D����PUo��"�-���>�3��#�!�O�ᰴ@S9'"�W�+&u,��e��d�5�_���=^�M�4R�n�xV�� H���σ_3<�g��iJp�E�S�+�������+��
��$�=,x`#T��)�Oet�e2_u�˕'�>�! ������d�r�陶[�G]ˍK�̯,�r��D%�xW���:�1����y��U�Q�x���O�#D3�ؖC���6�̷]�{�VL�5K;����ZcueR1,!}c��r��Do�C�C�0�Zg�1�E�C�/M��VT��$�/y�`���%ch�N̕\��X)	��(�҈�0����&��)
7��B��dOߒBR�r���
a��H���<�ް�O��}�,R+.v1�� U>�k�1a�/UCJ�>��1��T��p��_9�ĥ�Y�l�pFFY��"w��<߿�Ye@"8�B��ۛ��h)Ꙇ��ɕ��b�r5$��vZ��($,-�i ��8�̑dH��\H�����\����.�ٮR�N:�&x�=�s�<��/c���(U&&b�!�:����Ș.H⸦)����s�X���}k��?A�,���w��䳺R����b�����k���L1,�z-V��D�|��cy�y$�K��>o8�P������'q���/�%\��6b��Z
-W�t*�4��e�x$�͛�x~Kۻ��,�i;�dQo�<�k5��۾ë�x-2l��t��	5�mIFI��o��(��6�R����J�,��_=Xɸ��U*�'���A�*�z�v|�Y�Պ/�̚AĜ�&9�nnq��'���0T<�����v��d���Y&1�G��zr|�'�
%����aҮ�?�:�X%F���f�/4�KR�]�gV��@HmZ�"�">��&= 3�3��q��F��:�2��v����!�ߣ���Gf��d̈��a2�R`�3|�Q��`���$�������ϠM�5�jb�y{��
�]��v���_Ab1Y�Sb�8����ـ�c�����6F�)�ጀ��yN��#3��"��9��A��8�(wv��Gl�j����%Ls�����*+�)�p�4T�FDqB1��'��4��a��D�
9�lO���J�x�G��x��9MS�91�p�1��Vs�����z�mU�y)��fc���篛O���&�T�4�(��@Y�/'�&�j%X�E2�s@�,�1~�ț���3�na�
��׾?����1r�V�����c���߁{���4X%��3�N�/	���23{���N��U`��U�]�����|Ds�����s���?!%��8Y`�d�۷G��"?]q�:�g�S�ٜ��~��{w7�s;+[n��Gc����J�eѬ��O��<�)Z%Ӳ�x��w�:C|���J�zT�f)U(lTV��JT(4��l����m���r�y
&�4��;#���0(l�h�@��C��m�.�9j���w�T��8P_BG+ɱ^�XHԆ`z���5�����k76}�&'���n�C~~��fZ	�{W���UH�]-�*Q����T�zr�sL2��9M�k҉�+F�޳�'<R���(��xbϭ[�>�x�*��.q���遘�5}fF��ʴ��Ź׍#�����D��jJ����#�cg�J=��Y�$��r�|{U�0�Bm�6�-����S��.�oOz���E�/>��E�V.���Me�^?�c�V�cv��2S�ٖ�2vԩ6[��ś��G��1|r�����[t?��i�cJt�e4��{K���_��L�� ݭDհ5	�g��'�v3;"��X�XG�?�'>@�e��K��(��~�{��Z>t�u wԯ_��:e��G{-��Tv���EΠDt웶��GD��#r��7�Ɠ��tt�O�I��`�%6�9ny�����*7��#(�^�r�tg�N�ۀ�3�yVn��(�o�j�v�Nn?zļ��7&`{��*r���,s�eP+.�waz��b��L���[���Q����xk��2\�{=�S�P��d�bל4�=i���U�ܸ\ߌ��8�� �%�o�Jݲa�'w9;5���ѣ
����b�a{�SS��wރ�"�<F&�     2��\>J���(K���j�~9��+�<����=�LRPܬ>B���9�TU,2��O��ț<����h!�~�ӫJL:c��o���k!ѩWax
��i�M'd�6�˒�f�\�/��Z�eoqC�P_��e��M�3�Z"�ԃ(c�櫲e�&s	�y���8�*j�譾�I�F�߈��Uir����%"F�5�S�j=�3I9��h��v�Q.)�����0)�t[q���Y�=	y���8Z�������,�c�|�����p��)Ȯ�^E�t�A��-�2� G����{=6+��9�GE�v���l�Z#�*h�4,ޤ���:۴�Tn��k.&v��F����v�fNR������i�t�`���i<��Q���%��i���Bd9o"��6�8+�ϋ�������b�B"��T���^��t<���*gGs�u�N^�~[��I3�.��;���D{Sr�3z��.��d �I΃��������.�t��@�DV�V+�\����'����A�a�e���y���߀8ޅ�fc�G5,���� NCNn�&�u^�5e/�\��f�!z^�j���!?�QK�+d��q�Z<%�LN<3�J�:�)&�����q��lj�~Ӕ�tİ��o�>A"w�6�7�"\j7t'y���*��m�4�<�4|=)�儡�0Vgx8���D�C~�Y�:���1�Y����v�oH��*~'O׆Q,�n�(��R��As� ��
u���ͬZX���!��D� �v����$[�I�i���Jv茆pJ_�0����O�����:�G�������$�t<��~N&n�r_J�R��>U�� ��W���.r�w29��TJ��+��G:Dwو�y_�N�^9��y���i2��B[�5n�C���h�D��q6#�V��ߧ�Y�q�Ri�6lUg�W+W'L�l�3�ѓ+�lf$��ĉ��������|�H���:w��=�z���v���q��f�V�Q����F{�$�����X%�g���;,r��.@[�JijTS	P�|��o������N�-V��iK��#��<1=��K���&'�4��v��d��@ ��^�q|)\�"��k��>/i.E�.�	��Y�f��>nb=��E�\.=MЗP���s���Q�QUTV+ٞ�^�a�C-��&��b������h|����x�V�ya&Lf��x�A�#!VK%(N��A��@�Vb(/�7<Tg?�����G����l�6Z7ff89o?9�V]�:��=�ǚ��a9?�:��}��/�>�^^f����@ vڋ"��pk�n&3}��Voq�qBN��sT��#�����%�8j xVĴ�&x�����Q9{�୞w�,�ѽ������!������a�H�;kɭ�����g����6��@�C�v���X�̪��� e��%�����ӥ���
�o�N��Qq� �*��(�V)�,Dd����pG�oؚZ��>����d�b��q�ȃ��IN��O��N��{l�����j&�E�g�I�u�6��#�D�$pçsկ�q_#�{I�*N�1Z��x�C	�^� r���] e���� �ws�H�E�Lo�VۋW$5)u�5x���9�ka�l.�>���;7p�I1�7d���+��� 0KrQ�b�]%����ɑ�r%�Up&������Q�}c�_EK��nr��8qò,�Z�a�,	/�{�^0�w�m���;�u<�~�h
CD�aĉ�8x��$�B��8� �� 2liՄ+�|���)gPG�A՚z���{	�� f�L^h��ྀ	edtE�{t��|�r�Fb�2��Y�_�}eIU�4SS�s���
�7��rǿ�����Wd�`����'})��&�]RE,��(���b��O��G)�X �<-��7���j�^�(�n��!!jp\'�����^���"��.|��ܝD�E�3(2!s^����}Qg�mP_�
{]���dfM�G�2P��4�ʟS"h��D�iV�M$V"<�'�ET0�S��S1g`Y�N)��mRI��N�Df8��=�w�!UWT9Isb����^���$=K��4��+)�W-Pir=���#�%��4����w} ��̲�~w� E+gv
�$נ����w��Z�mݒ
��8�4)�N/
�����w��5TX�_�~
�d
Q11�ܳ�_��ƤN�7}��S�k����l���SL�k`����������pb��Uts��|�!P'�J{�K6�3Z������?xp�,n1�TxQp��Q�?�(�*.B{���M�=�+K	����1g��Ķ ' �9��v��P�����5x�bԠz��4��wY*��lN�[�n�S��} ��%��~�[��=rY��Yr�-�u�O'W<uqp�4"�oX��б8h�
�`z�=F��N?�{}M���o���8��Z�n]�Gw���p-�I�d�E�]�nL������`~���O���KD�W��7�
����G�Ld9�E�Ğ�����:b^��x�Zm?�f<����o8�`��Yk8:E�=��e�F9.�2l�T �N9[s"�s�|:����[��+�c������Bܫ1���O�-L�1-fڦ����d������.�LbB v��\)�;�IS�*WŞ?���j�V���HK�m�\���r݅_��8qL���`gٔ�'G����/ܦ�g�V����N�^͟pb^D�e'Fșo{\�8��C�JSM��2|�Kx�Zq)w[�qg�B���*\8q��Mo�fp�4�A���&Xd}�+���+S���+ϋ��b^B�.nY4ߞ��U�t�	���x�'�~��~6�����T�O��Q���N�����h|�U�c��JU�J�Q�d�
�O�~���~�{���lw��#R,��,�{�{��m�����M&�{��p
�M޼���An�w���p;��Q�{Q/����4������xR~Z�yw�sQ���'�����R�&
�*	��B��Rɻ^�3D����(��.|��V���e�1���;X���<�? ?�lKtw+��}�D;Y+�WP���v'�U���N��^w܆�{2��/����8}W�f�#P�2��"�Jx�q�X�&������%��#�����}�Y^�H:�)���pV`��g�L(p&<��C*F�
mb�纘G��>��K<�%q�#y�e;��6i�%ĕ%�.��_@���c�k8V�O$��4����8��pH�3ǋq�W��_����D��9���&/�ͺ�a3K�OҀg��\�K{��fюQ��4l��-�R��Z�k�ͯ�s� �r~�"IS���*��ԉ�0/a�5�r9��ﲨ�q�I�m�p�'jꕨ�{�l��%��P+�6�iƙ!Df����LP�p�[�8$z�;�:U|لi�> E7"Ŝ^ڜ?��~���K����4q'�[��0MBI��}�W����V�Ҹ���������h��=z��90��{�����Z3Z-�FLo50q<�Ŵ����1sl)f���h�L*�|�� �B@lk�f���8D8���4��	�C[~�V��E��&�ƩRV�c���H���c+��#�?/W���n��1v9�y�hbր}4�K)8��d%�ՠS����.�iP��g�(>�>9��'{k.���rr�s�H���9���2��������v�}�WI+Ucp��k:l��Y�
��/s=��Q߫��\��|@8rw'�	ՠ;���"w�>�~z���y�e`W�Ze��Pd�Ox�p��?}��R��$��-N�|� ����*�6=�R�.�����z�]v��o�᷍�)}�\��x���#,�;:��s����`�Mo7�!r��s�Ԏ�`�-1?,K���a�n�ٺ�![}��'@E�%�RO��_7�?�ez��A�u��2,�(L1���jru�x�HbV�>0�2p������އp�1�l�
v�Q�ۗ��e�/Вo3��+�����ycf;� �g��i�G�ڂ�}��S:�J��VM�(��c6�cU��S�M�%�Re�p�X?QY�+.�Q ��    ��q�;�N$��N2l:�M϶4��V8�w��Iy+�˻p"���X��בU9�y�3:n�8:	،`��V-��ڦ���+�f�"��n�a��退�Aj-�G5���l�^=eJ%T�A�Ke��|�� s�N���toqb7��O9��Ib5�#D0y�`I����C}Q/P��=Q�O�s\���C	��=��s�����u�Rp�W5���َ�p~��%7ip�=H -h�+!�/�Fʛ�أǒ��,V�6ø���G�������c8�����l:x.@w���qb2
f��.XJ]8�d2���ƶXq-�����s�:�D��8i�/���ROX��~�Yλ%�Oɽ�D��|�"U�2���c�L�<��+�(C :�!��������X|ܺ=F`چ�V a���8gt�m��'�R;���je����H��p��X��q�⌜��ƽn�-R�k�)�7%t�*s|�Ø�8f��D@�k��������7�_MH{��(嶘&�?8�Nt�w����lxq���[���(�\	�E�;�r��xxޛ�Io|�>��|P�8oO��q{Խ|�)�F�s0\�[�Ą�i�MA� ^�x.����	gI�O��*�3QG��#<m�� ��$$��	�B�����Yv�����,j88���1$WbCO`����6�Y���8��@��!4���ϓ�8F�̑�uz�`�>0�U�_��xF�E��b��E�JDhP�����	6(8�ͺ5���}t5��EpU��ygDѕl��v ��n����w�6@����I �q��+�!w���M_�0 ��}�fL�}���mV28i��ɹ�8jY�×J��o��z�_�[�v��J[8[�s�![�Y��ũ*������v!zMg��$�(1O���Cx��iϯ�$�$�z����q����j�Sj��J�&�ނ�Q���}ڒ�?3f�T;�:�Q̫��2����V"��Aue9&ժ��dWr���{��ӆ��DVw��&'.@4�C��VUMӵ\�^ W�xb��{^>��e2�����7�0�����Glϱ���A<WR{�n��ٯ�e��]����&NnC��(=��P�=&�5��n��m����g9�_�*W`X[�
�T����x�۵,5w@��Y-[��s�.܀(�������a�жJ����Tl�۪N��b����A��qH��T�s���z_��^�)��H7!Vb87�0��@�	�x�A(M��4}�ȇ��แ�����Nge�XM�_�t��f��3x�_�a#zv$�+e�*ȺNp�������4��-��k0������c���N��96k\4�#Zo�k�é�t}�|&l�m�߷q��,Z�'��s��^'H�� �� 
��;�B�C���{/WQ��ntD뇬���m�gː�.��B+�0i�M�9�2��V~���p�#ԑ*�	R��+��K?{{��&D���]�ʍ�-�[Θ�N�r�3s��9q2���d*��g�&d��!z?�~�L�$.O�e��l����*�Y�<p��¬���tk֚�ulj
&�msV"p\��/!=�*�fK,��z��E`�����O�}������b�Rkaz��SL�r�ղs��8��	����hU��yM�&<�����O\_�z�	ɯ����C�4�n���A�(�@F���2����jt�\�,�
HP��2�u[�\�v��C�5���������2r(#:�K�$%�8�����F���0˱��<�)�EΎQm�1��3���BJ]-�mk��Z�g��8���0*f�� k��%y�k�=�?eWQ�+�W9�h%vGf�1�9o��iϱ���g���k �#�7jō�l�7�H�r����&�*���r|�Ԇj���zh�I0�|�p�s�D��C����EHhq���:�N�z<,�\bSw���[̕�I�$D���qJN��2���������]��
<�w���3�k�e�kp���v�M;~E#�i�g���y�x�}�����|��3xϐ1#��"���4�E׊����Ai%|��_��N��|�ɝG�\���z_'l�S�b��X�6�����97��|�.S��~}���'��:��T8�_��2Z�h��{�r�W�A����J�(�(����m.3� �/�ݱݲ7�Q�>/��<c"J��$x�f�ڕ�.�kL�b�����ߔ��U�4���-�-C�D���H�$�U�0��$G-��8Y;[�Ѹ[��E�����,h4��M�Եk��0�W�!���WZ�@��q,����z!�v�U�D晎�ϔ+9��c�ϣ��̙mF�!�3)6����썋�&ݶ7\n�����.qí9��&�p�-F#?/���+�_:��]*���W�����\�~|-}��=���x�&�-xhqP�؂���gE ��c��]���U@��q
�Á�#��o��oI�Y϶����J���/,R�����/��-�#F�Cдa���Rt�Dp�/����-���#A��I�gz�
����M��g#G��K)O��B ����݂'�E��|�}���6��(�N�k���.��-8��
t�S/�S���	��o�̱w!#�´v�efT!���f�+1(��p�+�M8�l�p����aF�L7(�m�`Γ�I����2���Z7�U
�����OGZ9��)�c;������A
T�(8/�<G��3ٖ�|w�t0�{�_�q%`�i~��o��ȃ���ή�ǐd�*RDN�+���%C&��<N�e��'?S98��5�N��:#6���ZT�V���S��#�V��wpޢ����~ճ�ȯ���w{.��*��+R��AR�:��en���u���m@���b�Ӝ�!�/ޠ}�p�|��WE��k�S� �q&�g��U��J'XA�'tl��'��s(\b��(Ӵ}�t���
�ך�f�&�*N�O�^�-:'�7����ߺk���<�n����I8�dߐ˰�Y(�7D�14$���V<)���/��Kz���{�ӡ�D�^"�8��ɻ���R;~�A�OL0�� �G󈝪��=�ڊ�;.�5��_s���r7B�:+�5INۭ��,���MC.���k�M��}��O���X	�mN��9�-�9���6]���35� �d�]��o���>�����lG��P*���LdR�~'۬�,�O���q�x8޺��9�)�w�`|�G��i�i�����wڛ�6<�7s�&8�<��ds�Z�4�E{�k�.uƗ���ښ�,|����H�W�����g��	&�1[���euq9n�ށ.�����%��U�����D��A� ����co�7�HeIqL{$�&Pd8��.�Rr&��kٝó6��lr����.i��³�wf	�[� E�4χɪ���=9�g�b8RqumsP�?�m&2j�����VH`�4!�v��c���� 7��}�l8lU�p�}��s�:�&#.N�S��k�<����B]����~��­��\�q4<��~���>����`wC��b}��<ObԊ�$��������8�r9�b�/>8���"�����2-C����ݤ������{դ���+��G����]N:���a�/���"	+e�B��� l2�ǚ���!�,���_�c�J6�H��Q�
$�XT���~�B�^(�֒&$|�����~������ۃn��%!8���'��	���=�jz�ZLG<�z�i�W\Qy���B���@O�L_�ڝ8�eI���q�d�:�v�֗�픓�ǘU�ߖ�8�3�N�8�caUQDˊ6G���߅�u~��i3b��,����g�K��mS1Jb��mZ�Թ�v�<+^��}�d�F>{>�kh!q�|�P#�V�xK���!�2����I��ï!���۔}Rj%���ŒsT�����[e�A�x�Qs���͢��ͯa{f!��3X_s��8e��1��jF�D`��S�j2Y#+�    U���+v�$�`�%s���?ۇ㥘a�7���O�p�������BҪ� �MP
�f
v�n*�r."&Y���������D]�K��N��Xo#k��.�!���960|�o��Ν����x!�n���;���T��D!��:��������JB ��P}gбn@A]O�.��s+h��^��p_up8'8���y��
�\B��Σ4[�1y��:<�/0�jM�U�q�ӛGq"���8k~��(�v�X���w�7����_��+m ���3�5��ٮ��a[��)�k��N�[F��}�û(-���7��R�5D���*�l�c���<x�q�f'�8������w���������a[��R��fUٮ�r�'tZ�.:��%�:��|��C{��i	��,+�ΈG��a���h�h��G���|�NK#W"&u�u�7��d�.�ٴ,_ '���I!�NkWb�~2�V��xZ3��k�]��!MؚK�r ��.�re�!Ӵ�}�ų�9�Ѵ-��{��ݚ�m}[����n%9�y4y���y���0D
X��C9���2�r�!s��_���lWO�E4��1���S��v�;��������E�'8K��x�I+0�E�i��H��L�}�i��Ao��|x��$H9����jՂ��	����,�Hχ�(���NO�H=���\A֦�Ȏj�������a���mlH\��'������'��ʽ|��ČYI(�Y�¿�{������%Rr��_=��h��d�GN���@��;�1J�,E��~�*�p�$�4�C˫�f�N{������э,Չ+8'�u{�a/^S� �tvZS���=�Sn/��|�zmn;�S�l�q%a��:�^�C�nuz��.	Y�����}��z�!����79��}�{w�?�灌��q�}�{'���3/e�h޾2�$���� cS�������`"��7����+U�i�i�!����{�wn�O�cqku�>S=��k2f�)mS9�hk�|kgo�����goK|��ir~^�����6(6�,Q�� ��\��&C�G���{��NϺ�kD���{�^{ E	�$����x�e��M��;�_���k4ͦ'�x�AU@^�1m���ٖc2jQ�8��Z��P��6�9�O�2A�Eo<��_В �&��;#,��V��_d8��Y��`t����I��3����x}z:�	�����gX��3?��~�5�ӂ�g�}���6�l�,|��EK+�G�2�j�98d�� ܦ��x>u�Q��i���"���n��t,��X�{`9��оhwΔ�<��q|�t���3pw�>�R�����a�?ݸ<�ۦN���O~�$پ��U�ow0,�;Ђ0�9�zY��.<G�G���.E�&Q�[�T\��B �y8V�?�����c9̒���L��;;��[cYyO�,?��O�'��ƽwp{H��������iouz2���Zq��B������ڒd'������Š�_֗�z��w
��_Q�>[`~ӀE(�H��I2/C��cv�`6���x6R��l:�g`�J�l��V!�'�#�W���x΍�����CL.�**�����(��i��?]��bR��|�{������Y�������O�E;�zA�t�40n��©
��+g�X�Zq��@H
��Ӝ�'���������%�Cb�=m�q�WlRC�hو�>��j�]���07�t�# �j{�<)ȓ����>��}0�p��}�,�]�ߖ.S�b��h�5T$�oO�: �8!(��I�8����S|����)m���<����*��*��E���D^�{�=���|қ�:eA?���W�`.+���d�<)����\�_��Uxx�Ca�U��q����^����tYp���io:t[1Jԛ�z�e!W�nl�4�v[�ָ����j�0Z�H�=i���ͽ�$�5�0Uu@U�`����t�~vl��ԇ��vȕ ÁNv�x<�_j�7�#�0��b>nX+Y�`4ϢN�Z�NE�w������?�W16m\�ۃIo$���$�Ó7��rqX�O~>'��H����`O�|�#�?��B�9Z�:�~_6�L���	x�ʡ���7-��ҁXm�q��=dzs鶍N�g�$�iچ��4�.'��>
�jD�>�%�ɋ�H2���<r��C����o_�yp�ɝ'���
zl2�ևz,W�N��?�G�):إ���r����{�te5}j�H�X��Α0��㘧&����[*����ϻ��.Ǘ���6�i���k	\OZh�� {Q��\t�'=�n�Y�Y��}�[��sGj��ߏ�KF��/m�z�Ė���H�ki��b����g���`]?�l��;�mb�h��[�"IV(���W��[�I���b�P���b�T��Rr�
���38���C�kw�x�+b"M�dL��
T^���px��;�u"��/K�lt�}����E�9�pv��?w�d��O�����5Vu���D��O�|�`�sr�u}�᪟���g�b������4<9����G�m���g,|ߴ��Qj�b��b�%a������iqAa��:B|��~�ⶅs��*
v��\�#�WN��;��g�:���;c�b��+d�sUl��y�	^�&6�+��/�+��&v�w5z^�^ًݽ��*����ͨ\N�UZ��AͨH�Ċ9����7�CP�-ߑOIޖ�vh	�*g��@&�L�q��bOS�cK�~H�q�wQ��i"�.�k���<.�R�tg����=���#�����x���I�u_���n}ۭ��D�7/�I��Q}���'��U���	���6=f5K{�!˶m8И��8�W�_��>[e@\YƏ�*�s�X������S��.:����=���אB,f{��T�|�v�������)�p����ew�y؞�lU�̲<���o9Gplh��]��,h������A�zW���<�1xzg���y�Lz�w�!�X��c̐��Z� ��=�y��v��3������:kjy��~�|Z.W�<�����	���ѳ�nLw0��5��q��ڳɻh�{�����?�π@;~l��h�`��=�'p����7-�V��.'���a:�ϴDS��680����zL��p�9�2���] �@���xê�
�q]�`�V"[���/�[�N����@�I
ޥ��=q<˴m�}�����eO��}�#�>�������18DSxե�_�b.�>�W�z�6��~¤B�29A�[�V����Zq��!��)"C�O�ܬpz���E\� D���6�*��G�S/i��@u�jM���Y}�[�+����	��+��w�_ ,�G*��;m³��޲7�ʝA}�S��j��l�������i�-�g�N��>��o��X烙��J��a���v�ٖ� �ia���*��P �$��D՗!{�^�j��T�'�B�/.s�cڋ��<�2���Y֡�d���a��;�J�˕+$>>���go]��=)�CƪB�y��۳��b����:������ �`�*#���o&�������:.��/����ˉ`�䊕hL����<'��k5ِ�h^qt@!u��=�`{-ת��'#�e���u��I��b���缄������v]6�wyJ�EE���I,� ����#,{(�! ���;�3�A|��1e*~.�(���*Z���A�F�8�f��5X�z��el$�����w�U%L9HV�[a�ȓ-?��%rg��+
�B3�k['��s�0�8"��G�Dؚ�]�;$�\/[��8}RFt��"�?�|�gb`﮻
�F.�1yw�H}v�+�	<]����A���b�7�?��$%���9�P����	b��0]No3\ϱ~ �Y�r6�=��,"N\��t���B]��:\-�`��}~�W��fC'������!q�o���q�yt�31ϭ0%$q���y��	���i�(��t~�~ I��A	����    v2��y�n?[NY3�8�a�h�m�v8�����8��8��>��TߴB��U�9�ٞ�K��,L�u�]�^p<�S[��F8��B�1�*�@�f8%d����/�?�0�7u�p#�]��&[3�<�z'�Z�ԥ�4lO������-��g����� ���8��n^�(!C_ϑ�.!�d���}��E5Z7q���a8
�)W�G	'M��C�I\�����u\��Lgs����U��¸�ڎ�G�E[�]G<�2�q
�����*�	�U"��&I,�Ry,�-,�X���i������F��]*[ɋ�	���){�<�����L��m�`��o�r)�gl3RYc �T�Z�#��d8MN�������%\��O�Y�����"\]�����}YX�Sg|� 8�i���� V$"�$�)�4�y���� ȓ�	x�}DL���g�8�w�1�MM-�,�ȷe�6�mk
�;����ޞN��y��4��y�wr<�`ux�O�Fo1�Bd��z�_Gu�1qwz���^�)�n�S�ބ��W^����`H+
��Zq%>��>�O��>�n��p6ɟf?��t��tjh�}�-��Z���}��&���z�n�����n�j��(�kJ�Iwi���-��|��")�s�[\&�\��QF0�jh>-�sL��Q�i�)�<!Na�˅��p�Y �MC���Q��YVD�}��;�N9���f�1�D[_�E������4w�+�_$����ˊr�� �=a��tSN�%���FNL���ׇq�&38����t��Eċ0�`�mόka��1�
W���3��Z�<P�~;��83�܃i�,�~ȯ���jdi�� )�=��D���EF�� �r�ۆ���ϔ�/V|y���(������/{��L��zOB����z��Z��z��3�F��õ�O�AyWȳ�Lԍ�r�n\���%^q��.���܅�y�bS�5X��,�r�K��K���u&�wא <���Yo���ޏ{���]���7�g�88� Y�$>����Esܗ��C|e�{����DOU~.� � Q��GKd��𴽭H,�MV	�$��W���[�ӕ�]JEðU�^��'މ2�p OLU�h�����F�Ddp3]U�Ѱ�j���o���
w��C;��6�PU����&�ϼy>ŕ����eŦQ���2���0��E8��y�������QS>�h���\�&Ck��֮�t�(WR���N�����~rj�?���ۜ{I	�r�PÍRJ�p�\���u���-ςp�V�X�.Io1����<���Ա<ϒ�.�[65���㛯>\�-�3�n�^�ƤZq�Q��i����LW{��A�9%���^$Vr�H�&NI�Zd<�u�x�G��>o	6�gr��⣦!Q|ǿ1�̡�V1�#׫�i� �z�H�3��jC���>��!�U�|�����z3��k�KἜd���H�IO���ޫmڮES��;�G�-�6Fs۶w�?d�<[~���XC(u,�)�s�mW����X�u����]r޽h�C�����&H��q؇�qa�D��q�tCE��4PuG�Ul;Ji�NY�a2K�hmoGA&k��!��)h�A�:
�*W��f�Ǆx�ζV?�q����pK�0y����C�~�%����p0Dd5��}!ii�{9!3��>y2�V���	R�Z��1�e G�6*��γ0Z��7b��w�@,����~n��
vӚ��c� ����#.���6�.+�����1Z�>�G��U�"��(Pl�$��ߠO��J�k���a]�Ķh>����� DB:5ۍ��Է5I�ƚ�'9�j���7�ML����=O@���hO��PL:9�)�]R�����||1���'�Y�3�i*ܯ\�#�-��������~ �Z��=f`ho�·Q걦!�s���a�i/����~	 �����]�Az'ǈ^��A�E��w�	�z@J��e��$����Q��!� V[�Uy>�hA�L�J�LZ������O~>4/
�g��'��b��4��(]��o�@��(��>h��Bw�M�h ҅#��.��� 9��ip���B2ZF��.��ސq��#H�&����h�\E�l���dA�#�d�s���(��'�b�5S�Wc��=u��A����:�f�jZ���$I�	<E��J�'hvA|æԐ\p��������k�{\�]�a�D�-�Eg	��a�6
B��`%��J��-�r�IS.�Cr�"��a@�\:�P�wA�|�?!bK��3�iuvS]<hŇ���6!��\���!�����}Iy噹e�n���=;%C���(��[_��Yyp�r�{���+�|a���d�����8��6���(��\�1�A�3�cgq\���s��	�?FN1��|�7�[�ö봰.8�e>�y�^j�\C����n��I|5\<�xc�v����!`�{���]W��p�x8���-"�
6���U�c�0EGu  a�����7
��X�Ez�rp�l�s�d�}�1J�,c [�&5pèai9\�[m-�
��2��I�,#g'��E���4��&�e[�cʄ�Z�dM�x�w�M@�����wrKq���7W�&D�V�c���b�uj��z�q�Rg�3��N2GM�^�$)�L�]嵽o��*���q&Fl�*T��@�?�;�6��(SҔ+.�4�$���ie6-C���T�	�Β0�n-��k�A,�x�߳bZwh��c�}�m ��
����8xg$��DC��ǉ#��>�+�Z7�s��
����yY�wK��H�n�L�S��]���;_\0'��H�b� S�җ="zv �~�6u��4XF1G����
�0�I���� ӱ���8	��^�q5ƭ-�~똾Β���1��y��l�v�+�����_S>�1Yq_�8�e�wa*|��}��	�<�i��;��g���^npO�[ѣ Ň����:b�������i[Mϳ���{��%n���T.�K7�V�"�_-����ƅ�d9/��J����Dc2�(����psi�+�""���#��S>�vɟ:&�-��	r���Q�7b�+q	�>\h�ޱ�����rKq��
�e�":n@��E��N�7-.@��Z
S��q'���tm,c�������L�c�X�79�|b����v��!i�����Z5�{+}�.u]�t}��-�������9<���V��/!YV��%X,T)o��m���?w=]QᦃQ�z���8�m��k�a7�ˢ�~��:wcd�~[u� �6�m��t"�8�ե.�x\���-j��e��Kdح�lϳ��H4\�b��B����o����"r�z�0ϑ�Q�b��Iv����V�crv�vۻc�>D�%s���+�#��QF2]�KTV�H�r�Ög)��T�J�$$����g�~�&w�v�Ɣ�n��`��}#x&�%�ي>���"8��-��	;���ϖ;���r$$�neE
x���,��v�t�m��D0ʭ�-�4Gwǝ�(+n�[�@���Y�s��(n���Ud,!� 5�������(`Ƃ�ϖ����O�-Z���Ca�%�;g�{q9�|���r���ϕT��;�'���� g|�ѓi���0|��ً�Pf[N����}�Q�o�_>	�BZG��k�Z�ۢ=��D��.+��ш�9�"���*��
8V,AR�#L#�dN�!��-�]��q+^*�zl�K�_]K�"��Vg��;F?��~�%��D��x����g���u��h���c�LN�t a��<״�'�6�<N��FA�/� ��Q��{�"zD�[!e덿�eS3\:��j%�(��3$�)ZAL�Z���M�qv9�����Q�ۂ�Hv<(�>7&�����r�3&T�;�h�� �Qoܻ�l��'�K<n���cx2����m$����:���P��<���L�r�r}�B����*��h����*ŹStM(V����ck��!o�jj��Y[�P�d�C��)0ӧT�f�E�6\�    �:F�^l��T]M���/�31�q�E�����`�K��j���+�a ���-�򛴜fa����%�唬�������[������8�D��a�I��!�1%(�e1�P���J Z�$�Af��?�dá�L�>'�0tǵ�6����e	bت>qa3_��}���
S6ur%���^ł��q����B�)C�4���iFNq6����:�葟�1����e�&���W��̼��~"� �2�c='@��A�����ؾ���J�XL�d�����(�\�]�eZ9�L$ƿL���I�\ѿDc��Fkט�޶(B��`n_|��3��U|\u�d1L���N��-v�#JװȈc�
`O������b>�I}�GSnBH��)K}�o��뇠.�6�|�
��X9�>�;ۑ�퐁:7�X
��	��󚁸��6^�$��G��+-�)��k<���=�|%�XV{��a=�4}�hO�˦����|mW�V�OK�r�^�YE19
��a�>x���_h��wJ�e��,��1�&'�(�R=-Ip�TO\�(�}Bk뉧���nL�o2�����G���OᣇWp��hھ���/D�[���9
�xM<�� �l[>�<�jN�+!�E�B��I,�!1mO7Ϣ�W�ȶNS�M��R�Ql��i5���n뮵n���!�-4m�ʋ'��ӌ{�Y-�O��W�ݣF1_Ӯ	&-\��d3C���3mG53�����Mo�M-��W������i��(uݢ�Df	k��)���1�~�!��G�%�/���(þ6	���P�S<�`��٦�@�W�I�� b>V�9���B-�O���&s�g�:����:���5`n9{�.�O@�<�m���`�������(dWoq��*�6������=V-�?�]�!^ʶR�|ȁT�@��)�e�}G�s��w�sD���]�+���o!��(��y������Q�M�r$a���t��q^��o$i��TUmU(ɂK�����4������
�a��v���ddh��䙪M�������ăLq���R���#��%�T��+�'{-���8��٪VL=�@�p�e���P&���	��)ܚ]i��u)k�΢{-��5��=X��cƧ��B��|�^/�p�
�M3����܆�h��h�K���##����5ί�IW>uj�@�n�F,���i����Ӷ�{���_H0OE��-=jV:�$~>Şo���6Șju�p�7q���q��ٛ? 9 ��1ǉz�W�����w���jH� �@bjUn~��F���r.��[X+�n��E�&�e�̱�0T��9�Q<��b��M�pq#�Ӊ���^FԦ+�~��Gv71H�y��e�1"X(�4��d�U�@:����'���P� �l��������e�EW	z� 2\߭[O�R��
k������I�O�4��%|\�u�뤫*mt'��Mn����@�}��G��ɬ���9�Z1ioЉ?��:C�\v{�L� ��}�q�@�!�`Y��ݠk�)�1�[�͟�s�b'r����"B��l&��t�~F�X���WS�u]�Pd�ܢV�,�?09�`8�����􀂞�29Z�&�k7��q�6���?�}o��8�u������R��^�$�'q��C5��I�W���G�j�X�l"�'�,�z���,{r�F�,��Y>������8�����ϯ)�y�[g���-�J�9�ߡ�oT��(�E�e�u�k+X�\qm�Sp-�e��J�jw��w*�`��h�2��iX����PN�������p�[�@Uh����#^�/=4+i�4X�dS�ֽ��4��ǲ�!Y�/���Q�s�i��pV���9�Ԧ��f)���َ��0����{�e�)����_-�A+]Ⱥ@s��9� /�9U��6uU�R����dɓ�!�)��C��� ^q0��]��������-<&7'��,xj<f׮U�ևkyu��hV�w^�7 ��*���皹^ԥ5��'i	�T}\�`���[�b>�c��)\�\���i���ҝlz��J~��,�4]/�Wtͷ���ڸH��ࣨ>�-��ġr:�)L��-<�g�<��y����W
i����^�c�z�Hk��b�N���G����v��@����`0^�R���Bî �7�E�H���	{���Y7�'���
^�"�#��M���)�\b iIrPI̳n}F��:��Y���^d�l������Ad�&3�ŰN��)�}��}ob��筴Ю+���TO�O�\s
�"j��r���:)9j��N���DȺ$ ��u��0
Sϵ�\Stir%"��]` c$ʲ��(���(�ކOB�J�h[n�2�qk�m�G��k֭�|���x=�(����u:�o�l<ɖ����UC�8�a�Z���m9����?��],�S��l0�:��qJ� ZD�R6��=�O����/�w
��̡����M��z������C#�!�=��~<��[�^�ږ�Gp��Żi��&.�6\��i��ÿ��)�x��=�7��R'�D��*ǿE�G���x�����o?�(^.XB��L	05-0`��� �u#����5Iݭ�P��:�ݖЛW�u�I�� �b�	��p�=sE>�4j�,�X��Z�#��A���}����9���v�&7O��vln��W5��R�:O�jԭ�s�L��l|8�<Q�@/�!��MO�7��2�������V+�널��������GK�P���A�'*���
�}��$d�M������GQ�3�4�%��=C7�t!,��E�ƗI<M�%u�ק~�;_9,ԝ%1��Y0��NL��AT^��S�*�r��U5��!6&M���N^v,�Pn:�����,�a��S� 9�� ٱ���o�/�=��?�Jo�gn\!Ro�����ݭ�1t
����,�8�3q�j��"B~�夓�6�D&L���8AF�%�Lle����H�ݫ�N��ڶ�ԧ��knzL�Q��>�Q?#2/�X�oH �"�x��PJ���bg�p7m�d�6����	��
c���ha_A�$�.�������<S�.��-�sĩ�̖a�Jָ��Q��_�����ǒ7r�&3�Z�����*��N���$Z$wa=�kH��̦II��I12J?��t�c��8-���ܷvˑ=qA��?p���׋�6����Ԋ������I�$=��P�3�GM�lԽ0�����7�*�����M�s�6���Wܭ|7;��oʮ$�+�CF��COғj��&�HPP�V�<��U^_�+ó���_y�-�`a��u�C�*��Q�FM�CfG��a�Wa�_�w�0�Jl������,.5�ZՃ ���YS+^^d]�6ܖ��ps���v ČD�$��ȭamk:��2�t\���-VپΚf�:��N�xThW��4X��a��Z	�D����/�F�r�q��˕X/���>vGU� >��2t�^ð_�<����cBe&�G9�}XAV<ufX���
Joނl�M�����ɛ|�u��@�g�>��E��#����@�5g�A��l~��q��o}&yq�D+qc<>�w��I�\y�Ab�2�^iF�$�J�X����;ҾJ��؎sK7�̦i�r(a�c��Y쇐����z�V��^1�r�s�c��b�kӯ��nl��aJ%�ɖK)�~6�I����l`%&Y�a�L��.8Z��Q���]?TQ��8��'���c9��$�dquM[7b��,t��W	t��V8�^����&�| �+�O%p���OS�/^�9�H�Q�g:r��H+CD=Kr I[�ÿ!�q8��m۫�y�垤'�z�ѧm[6Ik-~�$���qpG<j~r�<�I���B����h��.O�V�S������Nq�%9{X��a���=�Jl��Wx**S������>:̼���(B&M�Ђ����#>G2�� ���*�>F~��Up}���U\�֊'� %V�΂9@:1w$�|:��>    �4��u�;N����[��S�R���D[J̘�Lچv�.p����5���@�̶��R֜D�R��fZ�X��p������u����k��Դ��G�׎�8�R֗4�Mf౸��#�,L����!P`�>��3w>�o����с̲@�z7���-��x�����\X1G�Fsd|~�&z%�h��=;���԰��%�J��L�0�%�m�,3J��hL��ƒd7X�X�����T���G	���ք�Y;�qE�p'�?|��5��qA5B\���_ʒ_F�sC���t��1oH~�>5>WicN�ᅧ���j�*�Hp�hs�:�oG���p�,�e�!�֎4���!\a��TM{�ڕ}�5��s)E=ڊ���7<�uN9����W���iT��!�3|/'gS+�xM3�5�ִE��n��I�uǈ�Z����V�f��Q��\�p�+�H��Q	��8
����!807����6P��2I�OM����N�;����:/�Lq������k-X3Ō
��T�<�h�v�e���>�˂�b��Os�|��ı˞��o�&��V&�sr�~���R��Y6��f�`��F�����\7I��EKrbr��E2=ױ�}�ƜI%���0Jp<M�8���yp�ҵb�ƿ[��-{���N�v^E~��i�����C~~�w�����rތ/o��XX�q$�H`�H���c�thG� E �p�K��4�hg���o�U�#_'Ed��b�x'�J��v�p6^��K��Ƹ��
���2����4j�W."���e?�%��w�q��I�Ję ��%�_�e��]�OIz�A��U�>�3ȟ��pe�`w*Q��cVa`�4�˽nn����Y��hΉ|��5F�$��P�4�G|@!���߉�#5�dŧ��-�<�kp}��܄*Y'��0�clt3�!y�}�$ױ~!��V<~�ip��(
�;�48�Ͳm�	Q%�G`�bwx�YF��^��_����,�9w���js�� ߩ���ٲ͉��J� K��8�?�,<����O|�IF؇	��Q���m-6�0kZb ���r��,��0����{��c o�$c�+��*�C΃��H+)N槶�ds��6v��Z0�;�����|�wZ�bbj��ʹ���ƫdH��"cy��%9
<�(l�/�=WO=[���X7C����
���֞yU02ԧ*&�Ȧ��*9���\}��6u�|�������SxO��Y�G�8��-�'v���D��i��@��M�Zq�Nn�r�-'	a�œ_ò� mQ^��4�q=�����N����\^L1c�=�d�r�.S^��ʡ�y����Z�Vt�c�j��\�ێD��8 �m(����/I�����`�!�:5,ENRX#����:�V6Pt}юp�t�1����>�H��73������(��o�E|�k��upH^�Fq����޵4�md������Q\��Fw��)����k(�s'D�l�`@R���2�TeqW��*�c��~�����h;�����h���>���?�?��4�~�_�h�b�P"��/�m,3+CjA�Q����� ��!������r�6����m��F�gn�)N��F ����>�+-��|�?>�w�����I<��չ�w���T6��MfaA�:�ze���W�apl���!�zQ��$���Xe�L-&� �N�v��#}-� c`.���.	L�����T�f
�J��i���B q��u]ᢑ�qu�HV*�2��3�J�5TR)c��:Җ����B6��<�k���(ei����e[`�c����Bm���Cc����j��~١���2ߓ�{��RKey0�y��F �g�-_3�[��KOA������,;�?'$r�F�7)��8������!����=P��Q���kkf���v��~
���N�����J�#W���#xc�I�pO#���n�+ 0&4�Uf�t���ys���O:c���J �[����~��7~��A9���$�t���I�&���h�O��v�'� ��q��7�9h�f���i���}��qV�\Y�}pyqA)����żq�d�#}A�T+�Dy$�bg�Ѯ����t�5��r��a2,���I܏�����-�0Gl>���0F�5&%�\Q�K�(؃O��C���1�%��G[�^����7��y��E�MWz!�N�)\;c��3����ج�I��K������@�:�o숩K.}�!q�|I��%j�|PJ,�*���0K�+�Q�ئ�a���N�a�����U���8K�sgD9G��N��@��=?���Nf�N�KիC�n3<�e� ����yo����ݨ��=uX�7^���Q�Q��C	昑��-��p�.�1��q%��������)�ܴ��i�8C&<��<F�t怲��Z"ج2[ܚ@��m�s���Z\'Guŝp��N��@��<2��w^��<\�[u� �t�`��H�ɇt�ή��t�]��f��<�EP���,�p�}דz
�53՞��^ET�"6��H���q=|s���4zj�{����Nk��X�?z����O���}�;��� �x�c����[L��0 �U�d0�<2Fv�3Z�q޿�	�h�<��5\�rP��	����SѮ}V[}���Ғ��Q��ʱ�&�z��S���ЉA���Pڤ�]�wd�����	>ֆ�z/	���n�)���g���=,�!�n<�-�*A+���O����|���}�=�\0HX'����hR$S����ZѠ�>1��)9���[����]�\T��v0�d������[��z-`�2+G��H��J��g�$)?�>�{�^٧N#�L����i^0D`�P6Y�������B$!��;)��tn#~����|�~B��)��#��mX=�&���$�e/~y}j�I��,P�#g�0���p�T8��nhy�U`d�}��*��+�$j�}A�/����ĕ�T-���qeD�F]�I<�ߍ�잞#3���i���`�b���00�*�֢gO�P!�3p��s���PnN���aTBs	�s�Z)�f�p�A�@��j��%���<��k�pB��\��:6E�@��.�
��4$�!!�I��:P�n��V����c�ݭg���Os=<'܆K�K.hdk�f��q1����o#�3p������c����9���A�7��j���������=f�,=��ӿ��*�Dd�VО]l��<-b�'3=��NK(B�1G�?r_�Q��i��,/�,r��k��S��`%ݱs���M�h�%�0`6��4!4�s��b������%mbk�ݪ<�$�v�M�}QS�x����1���U����rո�vHM"d%��0��j3	�����h��^��:���.N��ɚ�U 6�AB�����V(܊t��<�����r�����]ӫ4�*yf�*�e�OT������(﯎�^�G�oQ�<S$��ɑ2��ԕY��9<_��킵L��g�y��^r�����I���콷���K�b�p� ��R���GחT�FF��:AN)��X2%��[�u?b����v��u ������*���3r����[le��Z�^���;��w���Dt?�ZƬ�Ǻ:����3���f_�55�6�R!��î��*4��{��������1�/�k�E'	"Q-�i��ndv���q���|��8%P�����4w����H>X�7�Ԗ�+o�UW��h��A��}n��ɦC;�#H5zJ����]d�CsVٕr���XX�n VEQ����w�Kfz*�;_�
y�c���.ݑ�w�T� ���F$[�Q��t�#��T�AM�����|������c�8�`
V�w��O�s�v�)��m�F�#�Efn����1|z�l��������N�tW��M"�ֵ p�ɑכ���-a>���k㲙/R�M��.�NU��3��A��
�lE���v�&��0v ��wxV Eh��/� ~�s�t���ÀFD���l:M�0j�l�T��pƔM<jd    �2�-ej� �;��%�����Bp�|l�C�;eʂ�"���Mכu@9B�]�>�HV�!���iAs0�]Z
4c����B�{����d�df��:�~�^�j~/���K܏���I�3%���ER~h�>�8�D�E���:.��+���1�K�����{��^����ܧ}l��'�E��;8����N0�����"�A�:�ҡ��lU9��O�!��5��t�}�,���bs�{E��H.��nB0�e��˝l��=��ΎF��'r�B8(�T�+=ҹT�����ȃ����>�1/7����GVA�$�&�}b��:ST�|��ާ�!_�abҭU�b�l����ϙ�#��38��V�mDx�k6
�u4�]o�uZ�V\��{%�V�7z��#��ذr��Ü�F�q���5��-ݼ��	��t���6#fR�aXNv�, �&;5[�V;���n�I1hQ'�`�0=.σ�p��N�l�p(	%��(�>D�䢭�\p����+��9Z�͝�镮j��j-���aCA�����b� ��u��F�ԎQn������'��Cke����;�%�G�u��Q�_�ی<=@	v���;wSkn�����8�o��ɗf*�gP�sr J���Ԑ`���"b:��<g����W��_���C�6�����wH8���|�J�|gv���t��s�M�T�����^c<�0|����+�ֶ5��@#D�����L%]�5�9���q�R~�I�/$	� ������:��ي�>�([�Fe�7�nb6�%�Z<Q�Fg}��[�������^��Y�sӰ��Ϭ2�Zy<��X�3+%,U9�."�E�F�-�d���U`��{<vM�ɰ�h0O��tێnZ�Mn<]�����t~�^7oxd8w�<�W�-1]�q���h� �q=�ä��R�Bp�M�cT��UoM�@�x^�KT�fO�<�#��	�q�����#j�V���k`�?���)���������6�(x�o5��i<�~�<KV)C� ��u�S?����+�<�s%�	�e�7_@Ը������D�y:�/��\YV7Q7'/���`���E2/tY�ws���#�2/F�����a��b���c����+��@�O�h��N[WG�0�zj~!�<'3�7ƭy����Cp	��`1RC�k���l�0�U��xj�)���:`X�*%�������fŵ5fq��4�8Z;��'G�P�>+G��A\�Ή���U����f��V�Gצ�Ѧ��d��Αء ����C��F���*sE�܋�\�Yi�idBF�����m��3�����<Y9���\LǶ���DHN	XlG�����В
����>Lk&��i��NUA1&�`ޯ3F=	<��:����z��
�Xm��P���Ѭ�;��kݻ�C�[!p"�� Mw|�,�Op�����yҭ������e.�����ӌCl,�z��</f���P��t���?l̶����nͨYѵd�p]�H���5����.OC|�)گ�P��V�8��1-�9�(����{>��9���nT��<��^���2ʉ���TE�(xiN�{�zt����c�f?Y��䟄_t'�8�AK0����m��}^ኃ�ߤ�Z���0�i|Բ;�l5~�F�ql�"�����nE�&d$�Ι�NG������/�\OnԂ����yZ���4����9���c"��^�c��A�!� �{��5�M�&~һzG�Iz�}$s�
2M�g8`�+R��@s�y'��2���3����w���_��=}ӅR}HL����?o�C������[Kѷ�Vc�I�Հ#�z[ͬ�1o�Y��"�j$����"K��x͂&� S�S�xD�����u�c��W���=7��Ŷ�C�`��	�O*���a��4i��`��,ՃG]i̡�ǜ���6�VV�!��6v�\��w�;�C&�@�G,3g [�}v�hS�Ь����[������wޢ����%���w`��E�^zw������k�(�g{�����ګc���O�IT/�B���a��u|;H���s%�=X��� ٯ�ϐ�|�@��|>��*Uy�&Ü���T�I&�'-�G�6+1)DhH��JC�$��B_L��T�.ק9xN����ء�Y����>H���6v�kP��A�ic���WY^&2��+���{2ڄ��OCOl�����W=}\���i:Dx]9�����*�i\��ȓE���r���������jmۋƴ>��Jٿ�j��2���o�:�,��
�w4l�Vm�u��Z«�dY-�����_-?�sr���������a�Q���]���N�c��t�u��{��(4юYEڗ����<B��)��h������������%���43��e��U��Ta��i��7��Y�K 1�<b����w�!6}m��$�AQ��!-o���"����+��|	fh8��+�#_ؾ�˼�͇�t�rs��/��@X���%!�*���]��!ijEx䣻�����h�<��f���H��4K�D��a^x�H/~���5���U;F��|��唅���>u�}�am��DǤWw�/b0��\���YR��uA�.��>�<)d	'aV��zL�p��IAQ1(okw�Ƞ��e���\��n�6��+i�4gwW�}���J�I�_�^�9�����H��c����8���ٻ)w�FS���ec)O����2����;*3���ոai���_�҄��x����q�b$������5t
���Du�����6�-��#�{G��d<��y����� )�gQ�	�E-5l��gĤP������*��7�$(��wG����lU��۠����T�!ߺ�?eo�WZ|*�U6 �Y�8ϒ�J��[њ�����K1�%���C�K��kܗ�}�	\?��,�
�-��g6�S[m��Z�?nu]6p/���I���E2N����5�80�~��>7ң��Ȭ<{��6=��ے��&,���u��"���/�[��!�\P�}E�kh`?}�R�6^��X	p�Z�j0�a rq�#՝pB9D��.���Y�lH� �-5h�f�i?m����H��.?��W��^�`�uG��=L0?��=��Qd{CA3L����~�������nxT~�f�^ؿH��1���f0�mz�tNj�Z3,�e�����W��>�g���v�Q
_�J!5�'T1m� }6N8�^�Җ��	{�)	��b�����7zI?�`K�E :J�)���6j�e���O*txQY��=��Y#p�XeV��$)�K������O�'"�mA
X9��	g!�.g&�oS���M�+E��Ք��+,���o������(�X��Q�v�1����.�	$k81���bD�b�eGɪD�Z�����p̒�GU��7�({��L�>L�V�"y2	>9g�4�R>���r,�����W�vL=�̏��bk]1x�p�^�t�e�d��c\܎��_]���N�V޾�B�l�w�M���}���
����t��)�a(]sW�7}.�&s��	B4���G��p�p�+8���7��k��͙*�R��GwT �oS����M�r���ruu�J z���ؕ����7�@�r)���9,�8��n��
	���R&�KYq��I}��v��s�>|\\!��;c���έ
�,�'w�� oM�� ]��b��d���@z�Z.I�RK�k!0y���;����ַ�7⬲c�n���B���M�'����O�)RX�JlX���^�#����b��s�p�N�a<���'�����j�<T� 5��a�@a�;�2�V=H�mw�Y��������s�������2����Ce�߿Y�w����Uo�Q���O�E����uRĳ|L^�{z?v����Z�1�2d3з�Ȇ�{�!� 5��q��&h`RDµ��t����
=~�=#']��u~Q"�G��4Že�M��m~U���{�o�f�d$���J�&92D_�,�F:�.)�(��8Ya35�"A����|��o�������ׂp�{��A �  g6���.=3��(��כ^���p��*)@펒+< �J2ů�pi�; %��4#��q��'V�*�z��rq^��19ѐ{�of������6ȁvd�S����V�[�=[�[�c���p\&+�v��b{2�SQ��
B	����oW�8B�|F�O�{�/�#�Q�[��E>/#�XC�,�����Ekr-��r9��#ۣ߱�C�|ڿ�C%�^>M��$%��rq�;I@8>uSW��i�  %XN&t#)ZYR*O��x�X����0.��ilŧW�� ����A:�� ��_��;�!�Z�d��G6S�F����"�V�3""*�B��Ŗ�r� /�M��v4��N!2�NPd�z1�Aj�A�b{0��1͒��</U��MFD#��#ݱ*փ�n�#���D�]h�S_��7d��+eQ{�+�G�wC�߱����r~�4T!�]t��m��g���ͱ��M�G�����?Ԫ����m^�������:}��;� ����=X��������࿶
$o!����{�ԋ��3��~w/���m����՟ct�A�׎:��}9�}��J�5J%��ͥ��H~r���I�{�xv�TH�Y�..{�cr�v����a��9��Ux�y��~��;i�=�ǝ��~���V��t��w���hy�����ḳA���:\v�%���+�+�3���B�G�n[����v��(��EY�1G�X�=I��;>� ���Ϋ^�To_wCk��H ���\���ir�3�c��~��/^�]���
t�,w!H#�G�-$�N��$����ӳ�n�{jE�&݋�A�X�$�-�o��L#O�G�Y���(69i��p������*1��=>;}�&���U�#GoR��@O�!u�<��r�]5oy}vq޽ٶ�;'��Ϭ�U��}ܽ ��9%p��8u�~Նg������B���������7�m-~���G�=�H��/��q�            x��KsI�.��_�;T�MB�xMo �dH ����,�(d�  T%mg16�Y����,�Wcw�fUֳ�vW��?��w��xQR�uu6E�p���>�;I�w�$i�S��?�{�g��$�3r5q����L*��8�U��V�M�Q?��/��7��NÐ]8��pu��v?��`��!���b������Ժ1>R����τz��J{1��N��P���G����j�Ob�9�ւ�=P�����e˷�\6�n��zy��[QҬ�Ӗ|��"��i�A8up�KV/��u������I�\���W��Y�*�?u��s�P�o�s��:��l�!�Og�������.���O�S�4-�I�N���c�����h:���R��x��R��Q$,VH�JwЏH���n����c!~HҌ��t@�����@2&�&���BץB8�����._�����UU��H���Fr��딟G�ƽP�q<i8�:}�M��6W�^?�I�i�sQ[�'� �\�$�;aHW�֊�I�~+_�
w����U�I�!��Tq=:�����-7����$������~.�t�˸�v�F�⠖���J�����������d��e�A�\����݈�
\��ji)�+zĔ������HLa�Y3N�����v�H��$���Wq3)����3)���(�W�D��MI3��RR'Pd���4�e'����	a��ާ�c��,'k��W	�5����u���x�ZST�V��ZK:��%���l^.I�	/7��37d�(T�^�M6Q[5�+}E]�#�pH1xwr����Q�

G���	�fKcu��F��ß������h\N�W$K{����ԓ˴���O/j�7p���HI]�u��Eo="���F��Z�N{���2n�ݤ��˨YO�J�4�6��u��J_3�+���g^�V�&Rw����у�40�O�H��7�!��Չ��Q���v`ڨG��d$�WZ�����; �|7V��ުj�eR���I?��|�k�y��4� gI��D�\��e�oK=ߤ^�M;����}�! l�}I����b�i�>��s��|F;z+�x%����4�њ�G��L��<ʅ�ߏ3���3�z�NI����t4�����:�~�M��z�/JHW��p�{,�y����T�͖2����wA�}�d�<�����5�$�.�Ò�Hl���$)'�$�Lחʒ�<��S7`�"���	�CY�]Vq��-��X7L�b�>�yP�+��$Yh��7���Q���6�FaҸ�'�c�*�J���'��W��f��ARBx��d���^=����o�U�G.�֭w���^_l�I�����	(��	�I��m5Zp�@�z�T`t���v��;pwZ�#�_������C�#t�x����~��S�Jo�+t�]P���w�:�e���AߠaK��^܌�B�\�̻��@��멻P�$���6y5В�+�
�+��Ԕf��_�%�f�r���&u�I
��n�^K��+p\���h���I�N�V�G�냮��L祟�p��ܪ$����uځ����s|p"�� ���^��oi�F`9@f[R3<ӊa����@�+pV����as�]Ʃ��jU��u�9{o�N��=���%�^�{h�w#�o���\�����<��ݏ�I� �LSM0#JL(�m�oӦV���y�5�r#N	���y	�ʠ�D�gD�uh@.,��w��&��f�*�'A�����	X�� �t5��у�cuΉ�:�M2^E]�j%�6@��^	�\&�V��^I�U�����#i�?�fS���`$�]�����d��ƞ��ծ�A���M�/bӷ�Q�F��elr�Zq5zR�h4Q+t	�jڎM���������(e���v����S�K�uv��$�w]�ԑ�Q���B���n=I��O+����h���N8~<3��h1��+�����H1B��<��@�+�m��]8����@���;����>L�H�LB��~��~��B�/�U�-[=�^��F�JҾL����O6o�W�!��M7�5	n�t�H'��c�\�V
ww��^%�PƧ�����UJU��ߎ;�y�����|�a���ӗweq�����e	�J��.h�uH��=��u��2Y�� Lbt��Y�v[��(�j���fҊ���!�!mb���;��zz�vsA;	�T�##����O���b��V->�ag/r�<�@�^�@ +�Itܶ�t�K�mT��ך�B���p�9B��ϨE���*�E=��Vҹh�=�v��W�fO*���|��h6��F��H�G���@L���=e���ˊô"��қ��Ĕ|��y�`ͨ�p��O���J:�:`	�}���U��%�����Jޖ��>՚�JsLuC�׸��i�]XȮ\&�n�J��Nnh=�f�^�%[y�$���S<���k�c'���
83�ߨXvԌ�3mt��f"��h�S��J���W2��A�r,@íȬe�J�mV^����˘��x#��2��i��*_e3ρi��˔1��}<�=2��%�VZXQ�=pm��4o�<I1�K��6c�{�w�_e����	���FO<�w5C�+�^+����I�X�`V.�Q�$p��6�F܆�.�.?�)���sQ0@
�S�
�����\%(���G*.�lK*2/t\��{����7Zɿ�"�h�8"�,2��
�����Pf=�tw�	�!�>���2�'�eT;��v?���iА�".yC0#�cN:���اzU��p�"B��lEY@�6�Mɭ_a���U��d�5��(;ݐ���+�R��{�X�?\���>%R>�Lќ{��+hm���y6�e`�L�� �G$Z����7�`��+ت��A< ��ūS�z�b���V����H��\g�p���>�͈�^G�\�y���� ����nW�̚�w՛~;�oxL�ï��� �K�q��$���%�W\�^%��=���Тf�^ݓ��D0f:�')y���4���H�N�n��6*8%��
�Awp5�ިh6X���e��H�((����L ��&-�iMk�wC�`í��5�e<����㳘]0�{������誋5���d�ȪtsAAPUQ��^I�HW�.Ⱥ�覇������U򱾾��7�]�[�0V�V�&VL���q���e�]���2�p��4�������J��!�]Fk�<��'^+��D7z�CXh�T�qL�*�o*|�b�U��/VJ���f�S����bcpD�EZ��ʙ�P�5xPT����t�wSo���,-0�/|�a'��+�Ro���r#�m3��l���*�(}g�ʦĠ�K��^|5��g�wǓ���?��E��?Œ@S�E��
�)�;��`Q�jW�/V�� ٓ��M���� o��BW?TE�*�o��([��V���@m�,d�Hm���X��,��H9�"/�����nJZi\K=0�;Q���bX2�:�\��+�\�T�lŠ�*��~��[x�R�[U��1�Ѣ�N�����#y�AhY�{�JX-+|/׊���U��2'7BE��������H.�"G�������n��';�<��[����3�kZ9Fs�0���<x#�� ��9a���ր]���E�1��er5 )��t��r]�U?�����Xa�I�Mz��&�J#����B�n\=�:U/��~-E�&�!1�3֊)]�\�my�`��P��@[�a�˭P*�.>-V��� d�yZY����s���g�|5�˭]/C�k���Á%V����`m+�:�ă��ߘpV(�&�j�֞�Y�ת�>����OR,�Q	h،^I�u7�o��J��*$ٶ%���iТ�)�C���v��ʪZ�w������b&��E�ݤ���7�g"ʍ��
&���<�� �ft���#m� RԾ�l�����$Mgo�,�̄��@w�+I'�YL�h��n�&��MUó�h��J|z�z�S�S�kX�pop����QL�l	����e�o�2�xQ$�Ut�4�    t�l�2��]0+��\��&[s�1�E��ɘ�Ҁu�Ğ���X�V6����&���6O�/?g�S!U�wS��}�!�$K�ԕ�r����������?��v�O����^�ט#Uet�7U���Ń�s�eʰr�T�)(5�#,��O����{��S�(<�5t�#6W��*n��0��)�v3�E���ſ��`���ch��� �Wṕ�۽Hʀs�*�>��p<�(G7�%�O�vS	�M{�Wt.V�& ��bm�ݴ����K3IPL.�l�E��8��E���opjcW	�� l8i������.x`z�D�z'���o_�����-�ﭨ��>w�79�NO�L����g��aO� �	���(��>�_\]<[������i�5G,p����~��; 4�Z���x*d�z���|�7�Q�'E�A��U�jG=����W��Z�$��X���N�����oM�W����B��nkn��b4�T��7�-�V���<(4���Q߾2��Q(ijq��Ի$Y�.����Ń7������V�z�u՗���i����mr�V�M�ӹՊ#�"<�DUlN�=DV�2s�al%=L<$�?�k,5#H4\{>8�%���D��f�H�bs'�1�	�$H�Y{�t[:m�	�5m����v'�u
+�ԈZEM'��UA{ e���w��1���QWvځ_"*Qu}M��!A	���1f�
���n��.(XB��ܑ:�\'�`R{��_��4B�C�i$X�'0��_!��V\�U�`���#[YZQ��V�Xڳ+�
l����Dy��@��\V��7��8�a����U�.o�Tf�|٪[���c���h7I1��*��e����"͗8F`�F��5���;
�8"�"� kB�R�����;��S�hJ��)m6S��)��"��CVf6�2��5����SgT�+p��'k�UB'pT�8F`vaj����}��8f\���d�3��
;��KF��f;�X�2�n���N�+y-kqS�<�~���#dƿ�c��b\O�!�CCD���0g���h���$�h|�+*t�0�	Y�����Im��@9�.|��:=�:�Գ�M�¥̝�r��O]+uꘇ+����S�r�[���m�PJ�X����_�N:q��z�U^�>�Qk���Q�{�֔���d�����M�8n'J��n\���ǹ�m��%PF�ٜ��KdZ�!�=�],E��5�������a�ic�zU� �{e�&�AbB4p�iCiuǿRV�M�/p��2-H���z��������oub���^{/�`�U�2A..����m�� o9.�u��X�ͫ�Y���f�fŽl�E؏��`;��y:�k��/k�M�z����+��(R��:1��P����s��A?+�����E٢'�t�8�v˚A�:��u����}��oT5�^�����0���&�W)��ըڍ��m�0k��aNI	][`ռ�h�8GĞғ�&��C;�%��0lJ�Ze���&7=�k�ڲ�=z�Aaf~���ޥ�+��uC�eF�X��t�O9�����$�3y��X*ll ,�L"%�u�D/��*1������Z���FsDEG�Ab����F��f�~��,�;n`�y`F�F�Rmm�����.j�-U�wb���8�`b 
(Z�'�c{�J6N���$�7o�>����=:������d��Z�z��%��UT3�B^ �+� ���q��*���c�*9��p<�q�!���{�f5��2�	ܭ��ME�ʳx��dĵ�A�0�E8�n��Sj'K����(^�
{�ʺ�§p�T�>�HP*M���ĕ[���,O��b��
>��vP��u����*�:1v­��%�r�X>oɏmP�s�����m��]Rܕ�m������E��:��uQձ.����yD��1�=O�,d�'��F��#v�d��OvSL�'���H��T=(�l���BL�I�d<t���WDT�5��&�9�j"�صb��j&�wEL�V�+�{Q��X �5p^�4��j�Ju��V1�^�;Cx��]Z�Yn2��{����\��[��0:��{�Y�E�<;��.i��-��[��=0�oԮ�M̒'M$C[���7Zm��������S��e�U� �Z7}wuaQ����ʣ�e ;*�
a��b�7Q���$���"��^���8�X-���_��f�|��38)�	M!`���U�y��i���
�CP���:��~'=�l#��������i�5E_M�F�N� B U���&�4]�*T��#�n�6-�E��1�y��؈������M�����Rm��P�������l�6��g��[���HH+���ڠ�l�7����f��\ $��c�R�����Q���OkSgO�ZY�C��{��ڍ�E�\~�4͍�)��҆�J+�Ӎo"�!
�5���Uݎ���@�ﺮ�Eg���5�uF ��iF�шiX6ܬ��Ov�y�0
�����?�/N%n�Ћ@|��wP�>p\-z����Ԍ���
e���ڪ�κ���4��(Tݞj6�~� 4p��Kr�E81l��a#t�Ռ�a�Ѡa�mxl�潄�]&�:��5p��+��U	.5��o�A�EPx�H���j�^V�iQ�
����@��n7���:�57P��p%�/��V>ײ�p�p8K����Jʄ�6}�PA1X��$��6�+y��q=�[Rt�C�

a�
�wW�`�z�һ{�7L�!ޒs7�љj�%
�&$R���)��c���ߛ�����_��.F�����T[�R�Ѿ����+q��������q��ե a�4q8�5���ù%���
���SQ������,� /���#���V|X��&F��u�����ʰVt��*���2)ĩ�-P�i1U`�`Yf1.�XJ�G7���ͭz�*�Z���p�V�|c�;U���]L��5�@���Z钧���yM��?�BF�f|8'x�q��_��n�vO��Ne?+nt���Nr���>V���d/�����U`�g� s+&���F�y�C����y��-����b��`��J���a�~"Ѯ���u�R�y���v��u���~��W�/�k�5�\��-E}{'f�U��	��"N]�QրB�f̗IX:+L��H#.{����5�&6t�@���d��e��H�`�K����3���Y7�U*n/���Z��N�n9݊�$����dS���+�X�R�qEP���`"��m�*��q��n�Q;mG%�+O�n�Q���7�iHM�5�;�vVI⼼�Y\UI{�4U�s_/�RӤ�Qqk `|�Ѯ����tf��k�WG��k���b��$B߁����.*��&:���J��t7�	4�BD��5^F���R�zX�������L�S��]t�
�F��^3�p����kAR;+rl),A��鰨���^�Xh#�`�|cx�rզ�R6[s��N�\���e�L�����?�n�ƪ.^�<�Tr���X�]�	L����C4��n(����jo�%����Z}�H:�ʖVl���KH�JN��+'���I2
ha���Վ�
*�(w�#W���8lH{=n5g;(�oy,�y��t|�t0��,#ߐ�z�U��2w����U���n���h��1h��e���$�ũ���Q	*C
<���D���3ܒS��|+��¬�c��r4Q-nj�0��k�ڥ���ltIL��PA��r��3'v���M�:�_?
��{b�	��i38���<4�":�5q������⡜�k�0N�D!�}����-W�C���Fq�g�8��?��ݕ�� ��#�w����L�1w�"ÿ�'��9��Nl���f�k�Xo� qlXx��h����Y։���E�F��3��5��^ݽ�Ik�h��� j���Q{[�פ�n��S~�}��TCַ:(W�4�:����szX�jB+���%zڤ��^�a�D�uP���Tg._E��5n����_�|�i+1P�]��S4Jj`"�Y�3    Ζ>9���͓��-Nʓ�P�(�}��� �M���9>�".�Wj�(�ھ��G5*�>��� .%mu��rA��Qb��h�K:N̪E���
W�KR�ld
zۊP����Z�
��t���FZ�.x�7!۲��#Ԧ'ũɎEK̮Pu\n{�`�^o�㶶'�I�{D�*|*dnR��Y�,H{�4.���}��)&9B�V �+I��DN���_U�,)���G��ld�^HM��V�DhGbyA�Y��ep�<�͠ �@{[Y0{TnY�y�����O��/B�����HN��5���a>�V^�y!6�m"�� 8o��Ap�(
y���v���I��a�)��8���P����Rd�nz�J��q~+?���F�ߘԳ�}>Y������+��b�1���<�4��wy��&0� �f���S}�۫"�_I��������M$o�Xٓ1쀙Fڕ���c҇;��y��:��J�{�����}���Z>����+}~�@g��}�sL���So-y���n��<����Z#D	������[ F�Y�(��,{�-Ǭ�X7mt�bo�Z]�8}�k<��9!v;���b%��̝f4�>S"K�\Y#�����~
׮�N�W%ī 0��Dq��a�r$�i���ˍ���|�F�Lc�U�X�'�Z�ԯិ�|�U*��ɍ��o	.]�"����o��z+ãܰ�V$���w-��]����]&���X\"L�N4hn�k3 ce{�Ƶ�@}�pab��V��U��7r�޶5\�Dͫ��^��֤�'	���M �6,'RΊ���^�:Vᖥ�6��)�:=��+�WJ�7�?a��K.�qK�8�	D��i/`�s3�[��7�������o�d,����ܨa{�����;��e�����%�`t+�P|�D���1�z���wu�Ӗ�E��j����JW�q�TV�>�0 �4���GF`�%���I�6�
<a�L�m��)\|`��I�'���]���Q�v즒�]�^B��̀'㡳LI��~\im�Tc����@�:ױ	@5��c~�O�թ��cU.s)�;~� �
��L�[�z<tC;��Bŗ�2=��  �.-=�,+-2I+�p�R?a�$�f��Jb��-xAl�$�U�n`l1�E@��ȼ.�00�J(�H���h^��z�/R��f��р�4q�Q�	�����Y)�����6c9�L?_�6��jEL�����\�o��Xᕊ�����A:Z����6��%�� �q��ߩK+���sEB">��������tD��V	���y�<֊��.��_�䢘*DJ�=�������D;�j�4n"���Fj]��E[V� ��gYDrcj���Z�ΦP�=�������V�Z��p �>�Ԩe�2�a̬�ocC�߻�Jj��l?Q9��`�2ǀuR�����ܶ���HcE�n��ԗ��6�@l�U/Z0�^�)����o�W��{�)��B�q�:�k��,6[�_@[*��	vMͺ��2�QZO
+�:p+��<�
��J�8GT`�)�� w�)r�����GM0Ok���u�����dFU%��/	�!�Z`���{;"p�����23�B7�4U�+ k�y�d��^���hs����6�i��P�:G�
��@X�dh�c�W�Y9@D��I�N#[;� ;��l��������U���R0��v��y���X�C�3��F�,��-]�F�p]
�NT�־چ;ș/\�����~P��AW�{�6����׷t\���h	�-_;�]'��s-)��	��NwpuU� �A]����K���q��	��͎a8��A��P���+0�8��!�Ku���ь�-7�б~��b�[���{ͥ����3�������g�V(gU5��l<���al��p���������##��Ald�Z�y��9e��
�gtv%��b�3'&B�:������i�����\?�ܢ�I���C�h(����g�eY[�?���`���Ped��ᗾ�i8�|~�iRY�<P�AF���9���m��/M5�*Z)w�.R�B�;:�]��\� ��<�5��X>W�%������I���o瓗��Vp{���2�#�xn�).<s�;���E]���x7|�T<�H��A�:�]�$�����X�ު�$�~�U^@�b>��.����	���H9)n��i��}�=��B)�y-:�>X�r�l���z�R$m"<�[ҿ.�?\n
Ƚ���p�V����v���~��3���<�q��4�܇Nϑ>
��J��Ĺ�D8��ǧ�:����S�p��=Fq���<Q��bV�vo��i����bW�n�W�gDN�nVH��7�E��rI������䲢"�'��� =�C(j��\�1����p�*�����H�w�E�H_������bavLG�|r7�8z9���ۂ�J�[%��iF�#4�e�g�+�Xq�����e"L�U˦�jZbr ��@Ȇe<Y�%"������6�,��S��&��ڏ���fro�"�4��"�-Z����������D�q4��r�d%2�������D�?*Uߔߚ0�sL="e*̪��M��]Ө�q�\U s��`W�D�ȷ0<Wx�Ȳ��Ѵ`�֤��q�J�5��y`5�=m�P,��<l��@R�� �Z��Όv���܍������tKi��$��������~U����"�-�Z]b~ֵ@2�E�V�4t�U�lFl���ƻ��%ʰUBs8�[p3ަ��f�#�HzJ����{ 發x�L<hEV�����F~v_�ɠ�T�Ϥ<���X��em�+����ev]���,��I��rZZ%4\Z������+Ɉ�h�-cĥ�f�� �Sl�m_!�{�M���I�&��5���7i�t��0��e���
Ѵ��_ͦj＂c{�3�=�ܓg5�:��]fŊ*��"�ʔ\�� Jо}z��h ���U��8�i%��\��*,�X���m6��� ��ۨ���F�K�~��qƊ�����v���em"S�Y3ti��ek�^�1�Y�����[]��i��#�s�s¨����r?��n��v�L�s�<F5rW;;���L�L�=��j��d��˻N�E`8��@6YQ�Ҟ^�s�V��j���G�`#C��옃��t����]R��-�B�@�ȸ_���&(9��2i^�	+��Yd{t��je*��2����ͽ�#L���L�C�q��t�X5u������J�:j'1��,�Cr6C+���'�h�z%���%�`���Ң\�f��i�*9�oUW��9?�U �����&�&|�:C�
��aA��9'F@v3�>NeX$�xd֌ �/ǷRǊд������z:`�^8R$��+T�AxF\���@j��[d�~���I�jYN�w�������҅�WKm��.¤Z�%�&xr
��'��Y��"5;�^��D�V�&�_�DP�0�@	�c����b� k�E��XIib��J�Vlt�&�0�����wr�G��t�c%#�ӆ�/���С���)i��������!˹��n��q��[L<�K,%	R�f1��$����;9,v7�1�&����r�;�ݷ�|i2o�P�	��@89�V����'����^�岕JLv���y�=�L���������EX����87�=Ы�$��1�lҧf#��G��I��d�_8�R}�B����^~���u����T�:�����ct��y�+]��?)��J��OU9���j�⾠��!����M���͝��j�i�Od����Y�8�Ε�{��F�^�����St�� k�v=������,�E����Y�ڗ`4J9���z�'� /�,�w����)���k<]���cι���0PV��]��9>~܆cE��["|�
)��F�X$�{W��GxVFv������V�֓6��[�f?Aaxr}���$;\�Pе6J�Yv�C��ѩ����(�:ICyc����l��VTI^`�p�    R�xӋ���Y�����ކ�pD��TC��Ӗ�����L=�?�K����Qrg�溚��:=����^I�U��d%]�>e񖯁s1�%����Sv=B�2�F�zAo�4�o���J��e�yT��T��6�)�|�,��Is�����w�u���+P@^�?�qrE����M�>���X��旅?i2��O4r��3�s�q�x�p�l�TЏ�nt�ભ�ķ�DW(o��e�w��Z����He�qEC��W�Q���������h��0���x��
ˁS�R�߯�.����w�m^Hb#?�GL51;�,0�����N�[�5{��`�]�"�
�_���ٽ���/XN[o�:ܟ �b�=H��zRJ?vEJt�u�?�^�q%F1��
�����z%��ݢ�\=0
�<_~(���B9��*i�;bU��.EL@swEmM��u*�ss =�6�l˙�R%.�i*�S����_�,Vri�J�|fPnwW�`���3
T�s���rOU���;
��Xn�A�]�B�T�o8�ՉP�v�>�&�|�r�/�O�@H:���7*pr2�E�n�����`:��;�&���G.�+ɥ�`;���ПB �~�(��I5>݃/+>����k-u?��D���7�'$u� �9�uP	{bٳ���z2r�r���&���l�C�uh�ő+��24S��Aa���� 
���.��u'��f����m�k��h$�˝�Vsd{ ˤ�u�X���� ��0�:�i|o��]�mQ��"ה%���UzR[��@�*�"?S{��q�b��1��1�~�m)��q�F���� ��@�(�C34S쩪�y<G�T��� ͩ�s5���m]~�i�����ZX�d�}���np9��iq�W�U����z�-��).�CY��*�0�?0F�z���U:���K�J�kZ�R>�� �)�O*�k�z2�y6-�����&I�@	��f�o���*� 7������F* '��T�xіhu�l��"0p�Q+j���j3vSr�2L]�h�3���u�1�s����pp�*�*�R �kk����n�����XI�(�Г^3JW�*Q�'�ߒd(R��z���v���:���s��Yu&5x��nR��$I�J��\��s��O��#�|,E �;E���=O0]|�-�R�7���V��o)��G{�� �=]m^��P��E>C�q�86��ƊpC����Ut�;�;����P}�_�N���g�seK��&��D�@X�tS9)ќO���6�1�_�e ��
��
���:n&ךS6�����/�������ӱ��2UR�����s��o@��:m�Z�Ш`G�'��xI-ًeՈ#R!st�F�Rn��v_+z#��7�yvө�CO��[�C$�pD�R�b�8���&a�F��w{8��I1X�����6���d8��FQj�d��n�G���q�=�>e�9fc<�F>JG_�c��t�+�FG3�@��ƣ����h.F_H:f3q�;�gw�A�q�@O�J���~:!��l2T0.���$Gs���緣�w�'��<%��$�#��B��^��G��/F�)�T86�����@��	�$��|]��z^oGC��a�)�6���l��E�Eb��h���Mng��>�-�M:�3��F޻�6�v�k�Q`0�K�$Bs�%�����\�- Qj�����ߎ�-���b>���^L2r�|����;�pj�d�h�.Yk��6G�7a�9o򽆄9����7 Ln�����佛��b���Zy������S��=Sy(�����W��r���I��� w�4$U�p�1��ڲKx�\t�!i�������5:�y�-`@�"6�	���-�\�n��l8*�##���\Q��i�*�=�EF�t���*ʄ�'����RD�(��~��3��q�u$�)V�� �6������)���d����N���,��6J�'a�Qh0r�l�&��Y��ιY��i�M�Q(u�U}A�o���"�)m}�M�y����\�YE��:�#(�0��J.[H�)���ۇ�)�Is�ו-��t��+`0�L �O�d�ȸ��rH8�I�U�Qً����s���>��V`R��kb-��"T���5�� �TǶ1#����)z.Y�(���2q��b�� ����6���ʎuXt�J�k��ɤ���oG��$L]~s�H�	h�a>�*���@a��؇8{A�.�d�$�)��uM��_��F�> �dZ
Es��!�Y�I��L?�zi,�C��d.�d��<cZ�+�e��N3�O�M��7��������lO�(p���]
�YI�ih��|�������3ᶒ�=�o�L�F�l8[|!��g� �r��#�@�߫�ޠ; ��2��粀�.�b%��9Ig�|��3'�_�Npv�E=$��OeC��?�lQ��0��$?��P��X��q�����u�?���wj��W:r�����λ��Ǒ�٤�Ɵ2����}6�(�K��K�M�6��V�(tg9��X��C��mv�q�g���L~vXJ�]փI/F}�G����b���_��2����^���!���ʆ��T��&\>����֢zp�	
ǧ˾;�R��D�ٜ\�3�ɅK	�q��Lk\̠�>~\���^7�T��v��G��kӽ�'s��"��Ϳ���?�n¦[g:�n3�ldi��Q50����R@�0��J.�G���-u����Yq G�v=����	&~�|P����qд�;T4�d)���	��T��ޔpmR%�}��(Co��RJ�$��z17��"OQ��2��T��o�Si�\ҩi}v�"7�wT�
�@���g�ju��nS+=lx5}'�F�өP�Sȳ)�}�g�����\��g�0T(/������l�D*	N�_�-�8w��Lnt���f�i�lG�?HFW�´��$z�꼯dy9x���HX�<!Y���3C�}��|�|<�gDY�� ��������O�,|��N����� �r]��V�� ��Y��~|��u�xI@0�ޜA��w7�?�]F�UY�&�&�O�+X�_ٗ����<���MϘ{ �4��^�N�<[?���=�0�8��"B���+��L܎{�(zȾl��,}7.:���JJ�DDoe��s%��V �$ZAk�O�e�@f9���M�^~��I/{��?1����s�$"Q~��buD�Κ^)�:�?�S��y8P�����5����&��q� -�R�c�@�S�� N�ml��(�yGs����v���U�-P��5$��hKD��-9��|=.	��r�fv]J>�P�QmZ��ږ�G����z_�C�O&�AteQ�Y��f��Z��h���#�ta�0443���֌�zv� �Y`����%E�̯��/?1����C0e�%a������|��Qη�AT�ܘRb��r��q�Q��Z�݃�QD�=��\����2t������$GX�ĚlÐԪ��P����9F�y&�l��/�ڷ�� �a��>G ��@����3�gIn�J��o���V2�؜�I2fs�\7<�D�WGC]+��<d� ��㻥�+�b=*�?Y���SC�%�t�x���nF��S�*�=�z>�����Wּ+0ߩ���K}�VJ�}Y�	�ѐ�t6�;��`5!W���b^��1d�'��Ln�\.e�i���-��y�����+FL=w�z�l��?0�j����-�ĵC�NT���`�C�U`�V[��������p�C,"A��f���yư��c6������~����+t},"���c0]{/��M����F�t�I�UDe�$U\]�nWՆ8-����+��U,|���T�t���qVV�@pL�r����x�[|���Vn�c��[#�#{6�Y����ώ&����x��B�U6���IN���K�>T�Z��F/r�YA>ĝ�Qi�ل\.&9h='<\�X��Ct�L]���d�?��w���w���V���}��G�V�.$A��U�s1G�؞����t�nt�>N�^��+P�>~��������s~0�(E���OT�$�q�ɸ�    �P�y-����d��8l�hŤ��(���
��{X�~A�0���*�m+���g�0{�h��[�
+�
޸��E�f5����s�b 5���V��a:����׿�	���I+�n����2�(R����X����}b�$�l�e�hS?���yO(�c9�sֈ֝��Sm�UU4�0v�[H97��*�3~��r���,����R�D���:�8�)Fi�75�-��n����I�������&Qt���Ȅ���>
���=iT*�d�a6R)��0[V�!�fIX9`L�1��V��Z�d+lN�p�H}�X]/�םw�)�j��n�j����Ц��3Hp���t��z�u%j��bM��*3��o{��+��QYSe���"�S$	L3��Z�����h��>���:�x�$�*��@2�>�NmѤ��$F/�`���ּ�K/����l1^Vk-s�|�!\���V�+���\�h	`��q�Mxnp�J���HOϥǖd
��9��ws�[�:VN�b�hQM�8�O�aҾ��	V8�˴�'^U��!`�F��}�Q�[����w��QT-c���/t�e��^�)��l��8"��A����uN��U�w6��m�ēu��s�'�Q\X��e����f>�
��8.<���շ�f�����b��cd�qN���
��$�~;iD��:f��P�:V�z��խ�;���W�ί�Q�����:ּf�s,#��J�u�Z��?�3�?|? ���KV�̴��B�_�t���r�~Q�e��@y���A�sZ�'j����l�W��'�[^��b%k��"dUQ$F�^�KʼxL:����gF���/_�m�����M�ο鯪�FC0#q��g���޷��t�\�:����l�]+v������kD=��Z�P���֓��?9���!�~>��ΌV>e���Ĵ'�	�~m�+I�N�q��2%`Q������P,iw<�ӗ�<������[?ec\��gs?]������?�D끐$�LFʠ(*�'EF�H	ؾ�'|��b(rK�~�=科I�M�(�t@6R�-w�6 /%�u��k���	�?]��Sx��.j@ROn��F'k+0��&?����-pR�4���1�h2)/.�[�v襃�U��(�*�J=�s6\`D����D���d$%:��b_'������̈�dz��Lo������I������]*N5�v�������� nu���s��Z=�z����]�_��������(���2p��%O��t���2 ����+�I|"�G h>���CT	���,�=�(U �^ s&���n���7��:z[����Zq���W�Yv��K�����*�l`���b�E�R��y�KNj��lv;�	Fh�2��Yhb^^Uf%�A�7(�*�������W7�g ��20_1�P�0+��<�V���ŭ��u��B�9!��r�.ֿ�vS.�[<Z�a?��cշč��̼Lz�|�c���+�z|�1R���Z&�=<ȈaI���]�꾒+O�TX��ʸwT�)�:`XEc�(ͳ�/|k�AϯV'XG�ZD��~�o1�Mkˎd�u�����p�>�"-)�쓛�'Y�"IGuU���u
�X�e:��	g�HO��p�.�|*B�k=�
�f�NC�[gzG�B��e,W�	J�&
D��(��JX|�ZK���:T"oN(֥Qy�Ӳ�y��l����pü���<���ڕ�(L�ף0�J~��a���Ző]����k��*�e��D���
�x!��0�k%�S���X��I1��zL�G���3|k�?mxI��GZI�t��j��@N!띵��h�h΂'tc��0�P#�muG�{���z%�WQ�u���G~Ƽ�������_�%)�h,<�w��@����԰3�_p����1�r�9� �WLCҮ~��H���/U,d�&z����T��aN��g4W�j����d�$P�_����o�����Q�҂�c3���6&S0@�2��i�zv�s�gS�,�8�����A��|N�%ܦ��΄QҐ��깼�i4f��=����&�|Lw��Q�j(��!x���K����F>������w3�{`TUl�������y�C��?f��~��e�z!>���b�8�b���������ʒ�@�U���ͽ|�g�6����6�'[/y�!t�&ݯ���#FFᎩq��I/K�S�U9�AưC�Sm��c4Da�*��d�O���WMpR"�I�_��߄;f�z��|���:�+�����<OD�Ԛ��LI>!�	V�G������Ng��x?w�{"��Ngf�y	������cVt)0]�gO��k��b%�Og9�~�w45�	X�?��JZ�|���/�J8.p�6E*Lp
�}ndg�1�+�������sW�AF]�$�}��M��'�٬0/7<kW�H�r�3�[�땴&ڣa�8%7�]F�@P"0,�@F�(�K/<��F��=w��q��+�(��/�à-ǉ|��m�K�z�[l�����	�p��S>�]�2m�t @�aP��dU'Й"��V�z)�@6��H�׿3Y<[�5��O(=�����`Y�B���Q�����i�^�DyN}-Vr���2d�؊�^��FV4�'�B��'�h�ԯ�B5B����?�	X��,{����J�VA�`91�)�3�����=��u�+�^�rǫ��L]�Pc}�1�P�TQ�S�&ڷ������J[�:���}�E�v
8R���(�H�7p9��$+JL�Ȋ/����@�ȋ i�/�~��AfYeL\�x�6��,�:�g�J%�X8A�l��"	�0��eW�|�΃*g� �q�r��/&�����F�T�"d�Д��o3�Y�˞eT�U�G�Ay���ܘs`�����ى�D�Og���H�Ī�EY��ױ�]wU,�W2߄]eK�N��=\���t!�8�C�`M]�r�eR�����P}����h��l����P�����.U�9��=��/�Bzש�B���LԮt~!�)6覼�D7�Iө}�)�ɽp�'��!<�T�E���K�~y���q���J�ݘ���q:���<�Y�����h��� 8����4��U
6�U�	��
�Z>�SaJ@�b^����'�H����nr#*-���l���3B�g��o���v1'��t��_9I&�k_MA�����h�HS��;y�U���r�od8X��r�20U�k�y�Ikz�c�>�*���Or���H#}�u	X����,!sB�pu�@7�+|0��s�HL88����!���/�	�ЈL��v;=N��s���M�F�"ΤYYH84G�U�0�<�_����`���������vdJ=�z��;��p�����%�fRěڗ��z((_����g�ڻ�M��mbq�e�e�sa	+I���&ː$�aU��~!nFcU�w��b'DrZf̈�>0��i�Im�ݰ�>�^v�F�g�/n����*i,�>�.�e��w���):RJ����MAV�e��}D��$�'��wVdΠ��d�������/�5���9
I�J.30�����o�'�R,!����bir����Ϗ��k�����.�K��"��#F@q�Je��C�H��Ǹ��\ȿ�3U��
�
H�3i4�D���N�8�T�稈�m>�������S���Ê���p�A�`wc3���wB�IY�ޫu����v`�jt�^6���XFKw��!#���n�;��ЂB8��uMH�l��oJվf��7�h0�pzl�!V�]oF���XK��R�	h.�I�0�<K���NYh��Tם��(���*	�p�y���P�e�ٝ$⊆�DM�ŉp=�-g�!���^N�����%�b;3����Y
_�UeƜ4�v�J��a�[Ơ���R�/Sa\k��+)����T~d'�h�s6�s?3�k`�K���y��.�l��q��x�95�G/�>�m�B��E9b���b�k�UÖy����    ��a��	������x%g���On��f�
 ���	]Mg�v�rWJ��S���Z8|w͇ٽW�v~����p$�Z��e\@e�����O�]�pݹ�&�֦w�ǯ�F����:�|lisA��P����&Ñ36� g�ȷʦv�|	p�s�@E�z���Ra� �L�B�`������+f�����&C�O��բtFj,f�H�TOګ�}����`,U�+o�FH<<^'px$�
���1��a�G�/K��;���t���G�2�3�9����1xt�~��������$W���SF���'�ab̀h��謞���xX�j]쮴"8w����jo?�%?��|���+�;O�Daa�Ҹ\pO��D�گ��1��3���h|p�R�r8Bݯ��]<����2��4�������ږ�>x�\ۭ�L�X�s<~`!s4����b<{s�+jo=`��뇡��:��d£�j����չޗ��N�^>�ز]��l�a�ל�>B�k�\g�����3�m����A-�A�"�RɁ��k�K�%���=��*0D�?�(՛�����T������L
�#��CϜ[�[�p�a<P��O�ZR�3���c�vt�g�NZ������,1������
��~�&�5#�� EG����ɔ0�e����~>G���I�?,�Qc��՝G�@�<�o�RW��xo\�4�k��a����w��G� m��L����'��bI8�h@�z����rh�	N{ s������?��i_��H93.2�?�sB��E9�^)���x:�;�]��4�>�a�e�Q�L�J���vV|ձ�s8ʞ(��kS��u(-Q���5�e)l�%؀c�������(X:3�ڣ��SB�{��J�F�'u"7��F�Uv����+�O�,l46$X��\�b0c��<O2��:8�ǼW�����:K�kE�Y�3mp�?�+,�('D���3@��1����S��]����&���jg?��x�ӟM;�]��QS�Y�0�B.K�>N��{�噽��tv;���X�I��-xK}�31���p:���hq���L[g�*�~��Fz�.�0�`p?������7�8+�]��n��s�y�l�8���E�jNH��-�M�J�P	#@U�_T?|�[y�m�� gr�����h25C�	�%���g"�]-2�:U�C�:�?%��	O�P^�\�4.g'�Duq �i_�F<qWF�����;�g5�SP���1��MFs,�-���Q�ܥ�\!%�$�4�\���^�m��9�nZe	��,p���ԙ!	4Ê�m6by���7�:������"q�|Q�&��=���\��Xl	sf�h���;���H�f�-�e"8wnua�f���X���ԍ�`QJz����0[�ؗ.����INfd�1��f�g�g��P����3I��H�B��&�Y�S��*���(�[d_Dpi�#p��-��M�Lߏ��N��y6ۚTf`{8qI�$�}�X�c�%�f Mo���ΰ��01����.4�)�������N��d��@c���__���w%)�1�ey�����3�>�-�f�E��;�g����R���K���$��U]�1����5K?�-J�{�#���@�(�٭�1-S����̼�@->*p�S�#���@��>)��;#�8��'�"��x����b}$"����Mn�>^�',�<��ߕ�9��my³|4�M�ċ��(iIF�oAgrzP����yPa i�[�8� 7�=ox#�Ť�8�c˴��JZQ���D��l���w9ζ+m�����gD�Ě y�ɟ��\���	��o�d����8\UM���(��7�s�'��}������=���|��4��%�3����h�82�{��v�˨	jW�}g=�C��̦D�A�^i�����Z	�����A�:��1�� ��y��r?��2ȥ��*���0X�r��A�__�Sȡ�E�Ok�-7U�����3*w�scݾ�y�N��HJ43�vs5J��g��
�j���Qkمͥ�ٕ�Y���?rRF�9K\��1�-^��]�s,��C
���6rG��l�g�L4���JZ�[h��'Q��Z��aA��S��U�J"�����wG���zD�vP��?���Ǆ�3\WQ.~, ^ɷŉ�Y&� ;@ܮ�346C]��!���pT�B!8eF�-��|F��xg�d�����bN��1z�і�gl�`�3Ѿt="��#6'=�7{��+��(��h���;���]������T0��^�3��7�O���^n{�'2nd���)xS�p�w�Ҥ�'�N�������oǨO��7�W�qsc��l��c� ��N�3��Vv�kXYY���C"�EV�.A�ޓ���۳�z��%�ܝ)v�*�7�	�믏Q:�f#��v��������b/?���	'>�U��RV3������YT{0���󹫃Z8z[�
���ۋ�=�} �W�iT����o��xƀ,�����|�I�h�M���[�	�nH��Q�'��t�~���\G�O�2r��?f�����׾���5��Wh��єJ8�u�@����9��HGOn	z3G�2#�.�#���琋�b	�3�/-��?�iv�n��>�;����u���8��<�;���%��Ppk�f��4S��V�:E����82xA]�p\��绍��ߝg�QY�����@`y>�.Z�1�.B���{A&���TT�N\���p��/*�*[�����:�J  R��5��ip�,�N6��e{��������|�9�D�H�HK��:�[H��F>���0<���ϔ����2��!F���6é!�R�á�KB_�Z�d>���j���g���Fpw?��>[�����l� ��{ ߚ3[����ѧ�l��T(����l��;���o�Ó�fD��n;f�ΡE���x�f���G�%����}��ֹA�g��@+��f}G"�?:�k�����n��9��,� 0����H:}�b��Y��N�
�>�ށp
�w=�gċ,�Bo�A֊�4aף�cT��r�ݏ�	h�	�f����}�������T^�� �ZE�7Px`�����)Q�����7V;�]V�:�s������ͦ?, �l�l�	gs�f�W��/�\��o��8�7�e�Q��r?&���|�Qɞ�	��s9ǔ&��Ҭ��Gպ��l�&�L��b�J%2՘�m� �C��ճy6\`9bF4���YL �Lcg�v5�[�}�����"ƢT��w�Yɉ����Us�<���r���q�B`�c1�.��p�@ �y�P�5���v������춤��ѷ]�[`��|R��=�p�T�9��c��+�0a �s���2�Lّ��q)������~	Y:z�T���n�}&�P����wN;��y��)�b0N+��ƣeD����\�T��"i�xE2���@��������	�{�r��y�ه||�1�'O�)P�Ǝ窙�2��z?�$I�[�XH�ߠ����C.�n�q�֧��O�����Pb����r�$�*�h��?�!~��F7���G�ی�㻲v���9�4�a1Fk�8�	�"��Z����ɷ��ƀS�>)Њ�R�:A5M#c=Dș�z��$���/�~q�>O���1���DYq��Y��`�����	=����T����&s�~H.o�x�8��NÊ��zZ��"t�9��I>�_<L�焪!���v4\<�q& t}s���o�#!��o����$�G��!�܁��fw��穳ߏ�N^��VL��ƀ�"�P��}k��W<��5�`O'9�F:���V��]�P�h?�Br�d���?�M��ث��u;�#|(���"���N����-t�Q2�2-j��_VR�V!0g����gR���������	�G�M�'�3��k�`��ޙ��$��g��l� ԋ@�	�7U�C�	C.R'�    
��c4W��)Usd�J�!��d�����¦��4$�y�}���[rŹ��i�$�t�d#��?�y�<`u�"�C#����]�Q3��k8|��9Z�����U���kפ��TT�>�ܰ��2*Fh�_�B�'��J��/�O��ͶU��'T�Bz�#���ȁ���i��ʒ���\6H�׿��hc:̟qP.��)����'�V=WKㄖ�
VuM���Sahc�"�D��.���g��ʁ�B�r�[�(U�\�N��ˆS=;�b�hi�|�uֿ/A*�iIҽZ܎?¹�/�|�y�>3)Ȫ���#D,a%y��Mp�lDx����e�A������ӊ�?��ƇG]���>����ǹ�R����=��I>AG�ψ��_����xL�Y�s-������w�DVC�
,c�����Բ+�9��YuxXu�@Sׇ%�d+�u6z�c]�@��3�{;.p��+���j�kj��;�����0(K�7�]�\N�:w�O�3���g��7��i-�g�/�%A�
�l,��<p��9������r@�P=i��!�/��0�̹�����������o�o-���d*�c.�?@W̦$���v)̣�����.K�^����Zw�I�HcaИ�*si�+|�s
KX�q�����·`���������G0)&�#�������/rǥ2v/.I�@K]e/���]e)y��|
���,[0�T2���.�E�T���[U�����y���d�ʍ��VY�3*F%����������屍���d��x�|���`1):��=��0l�0f���޻,��dk����O�uN��Y7_�-[�r�9�'��(� �	uKO���Q��8�򋝵�&HH")YT��ѥ��(2�D�\�o}�=K�Kbp���k���'7��{��gkdo��)P0�S���H.�5�]o���B�Ц��ۣ��v�e>�|�1��c�t����2�����O�j�^{�::�`mߔK��֧�$�$R��`��W�V�Q����ߑ��}L̈́��?���Ct�3�;w{�s�Bx_NˉɅ�^�=Z��^榓O�AL������87��J�����t�/V�=D����x�Q����O5&8[�B��l��!��9�Y�c<)GY]̫�=.evtI��J��S�V�c-ޫ#aA)����i�w���J���~���$��fGˈ��� B���M 
CjO����ǁG���

�f���r��"M݀�(F�=��T�9�W����;�;^+v�����k�x�m��r��)L�����:Y�,s$�(?�s�6,d�-���n�k�Bd><�'�.��jDN���>��%ψ�C�p�1�ѓ����0��D�Ph�Z��1�A�kZ*"�R{�M[ c"Zm3�q��#�{yol$dRs%]�{z��X���f��u���E٫���1��m_J�֕�|�,8>�iz}��d^��|�U[�����iC��!<�Qj�M�a#�1�Ԡ�7��ڎ�
��t�9�"�sJ�v�����ά��Ej.�+�lV��-�w�90����ŒM.*�4�-^V�W^9}�����;�g-/�L�p��]/=��� �JR���[ɚ_�ɇ��ԅ�gc��xl�S�=��Al����!����*�~��:,
u�Fm��Qa�*�U��TO��^�L�l����c�����������>������.�Q5E���Ν���NM�ڜ<
\�����H� fN�r�&Ll�N`K�(z�l�+�"~��}ȶ[`��Go��E9�pv7��Y�bT__z+'��&��"T�D�`-#WMBƚ�U-���F���/�0����[���2��aD!�3����!���J��A{���U9��_��/ʩ�zN��Ϡ��H�2b����x���Z�p�Dv!�y�g&DВ�O-�M98�8
�7Ga�M_VϺ��prI]�?`��,�>����uzq������24��N;�	��˲�,W��k���oQ�S����Z�}6�.�y��
����U=�<#Wd��e(���)ޢ>�L���9?�S�~�����b����"�i9`�Lu\Ȥi�c$��S�a����?n\���޾�=�E����}��RW�ܔ��P�#9����<�=�ɶb.��s�CY�*�A�~�/��X�p����:�8�Y^�e�� �_5�	?/��.�t�NZߚ,9��Qj�Y
��-��nm^¤M�����U�6b[JX��p�2_�J�Hg�_`��9R��&>�7��Ұ�T	f�T���>SCa̈́���(��JϾ��22��B�ˀ��eY�f�̓y��{8����^��`I�y�k�'⬜|�{�wa_5L��b)�4�2���qΐ��m|�m����M��`Z��-#��
���|�i: o� H��%lɀ�$����l#���	�{��8଻jӔk���L�f�of���
�,>��\�ì�e��a^+YI�S�dqC�$��.�y6T�w�"$'�Z�9��zF�e��#>NC՗��3��$Va�C|���R��Sz���m�{�f����� d����8�G��`���h�>z�˨����5}<�7�9��M}퉦���
���\���w�u������< <	)F��ʩ��	c0X:4뮘�I�ݺ:��L&�˭9 �������/x�Z�С��c�篷��:���˰AE�co�J��HS��0]�K�$��q c��`�*����{��^��0:�E������r�0QN�e��8Q��ɽ�6-�!�^�
�r�/�M����$?W��
C�N�dUZ:E[;r'�јm�J� 8F��hANa#m����y�ߠ��mkQ�	|�geGz�3񖔍�<-�E6I���=�px\ګ��.�]���	Y�`]_ט��;�,�;u�6��RH�`N�02���LGgL��~K	#�,e?�hqWQ�y`�~~e-S�K6ϰ��g0�|�,��	�]�,�����H�k��Fz��CX�9�1��(�[Z8ڣ�&B:��� -�ѧvO��&�)�Id:��;oO�y��&~������4S8z�!̪��F`��(�*����K���NI�"�^��,T�r(��HZ�9ܼ�|���{��C6�B�yfd��p�����q�r��}�p���A�`�s�!�.w��uL����5�۸6��-Ņ	�����0��6���lx�V��6xυ>�f�#��A�7WM�2�Ӯ���g0������k�OzW��]g����C<C�<��V I7���:3E:5�������\��"9�T����h36��%������	~/R�oKD������sy����$�18oP�bB���L�[���}�S�	k[,�|Kc��"a�p̅�J�6��6��Nn�]-��鿕ռ�NMy�\��Ʀ� �Ѐ�����~n� ���:�x};d&��Iҏ[J���L�Z�n��7�28 ��'�ee�L��B:鵁���zFf[��é����,F�����d�l�U��0q������El���<�$��*zk��x�&˹���{stǲ9�����F��b#�9� �9O�1L��Az���%���}7a�BX�$�î$��}U~]gF��M��R���7
�\$�'.�;�F�$��goP]Πm?������	:����:�3p�������A9ʫ���>|��Pӱ�Ido2�,�;�/ O���ߋ��ooh��|)fC��s����@��1�����Y4P������y�!�$E�sTQܫR��{/���W-����v�ִ%^/N�F�q���L�ߦ��mf�����
"$N۝��eNfϦZ���iy��c����z�Fg�6���|pt���|��r
�Н9�J��<��㪡��®�S�9(�ؼ���GS��y��k���]2�K���i��y���#/z����l@܂��W7L��z�n��Nئ!+�f�m�]BF*bn[HxC�C����iYieӽ)�f���TB�<    ]���@�Pƽ�6��-�
i=4��<�q��3ə���@x<�z��+nOG߸$;�@��ؠ� B�a^����	궁�!�HJ��a�����\�8�Z7��r��]�0�(%�i�s���=xF�3p�j�A���?[|!���Qv�MG�]�[�����9OR[�ޛ��|Ǳ<�M����m�ˢ7�ʊ���O��0�aMV�$!a�7�	�a�6�	נ1�RO&�mR�pM�8"\p������=�n"�wo�ȟJ���D����À*��Jrzھ�������{�ɟN�e�G���l��wb��3nr>��L�uj/a���0M�`\^>��u�V*\���L�����(����EV��K}#[�u��Gq0㈴ �Q�Y����t�I��'����)5�TXb(�yv�#8�Ԋ�?t��Iw2��]��V�(���-e��~��FLR�3�d�@�`�t�0���>�`"��l��Փ!�r�~.�"	�5q'C3�eD��lG%yW�X�{=6���JG��6�f�$���r6����ZKGQԚ�z:�l�/��`���c�OĴ�h�DT�bI�=��������	�>����Ʌ���$:4WM>�w�#Æ�Ԣ�02ĺ�x�Df�/�Bq�Pl+��P��9I(ULDl���������ZÚ��mxwN���T,���"�r�t,Xʝ8��,]��^�ۂ��+/����~(�f���j���O��?�N���p�]1/�O�
��bn���3rێ�H�����؇���җ�֢+�r��3��v>l�����������jxv=���è��-qϋ�*n��`#�����goM_�kD�r��BR�dâ�Ɠ�_K=����|����a>C�9�z:Z�v��;3.;�.�ue"��Bq[���4��~CAD���C��Mҋ��*���Cv?Z^�,U¼����ʹ�T��X�ˁ�--�u>φ� v���۾u���!�YE�4���g�z�!X^�(����m︞ew��w�jE=��Þk�E��h�$0�A�$.6�ab�t�\o�1� ����ߔU��O���Ʋ�)5�S]�2ߨ���Ue��_dU�yJ���^�؆�K0\�����ga#�
%w8�p1]�d��vn�K�lD"��G13�+�����7]�u�Dj�I�M���]�x���WMfN;��٠��%c��m��đ�4hzԔİ��~����!�� �������o����Qi����c�Ai��UL̴��^���2�S�p��^�K��4��ڻ���]�������#�e�V#�����3T�*��`�4Tnia#m���A='�Q\���}�`z\��}p2LFB"��WxF�����c�Uj'\ܵ�=lUyKk_ '��=�C�A�t�8O[�������hm�ZST���د�s���+�������R��S��g,�A�&EC�:��q�#�|�$�* e��X(Q89�<��D�rh罂5Ɠr�Uń�X�_�f���䅿��o�D˪�Z�.����ϴ���� V,��)>
Ci;x�U; W��K(�y=��/f�ӧ	g���h*�b}��I6�p�F�����K�&�P�E�d�Kd�z�26�|zV>7��X��>��Zg$~�l�"w���ȵ�ڷBH�C`�~��a2���"���$t"z��㉷�aQ�|�v�*Yٓ�D�Ot��y�t��m�I��)yF\��*����~�{6,G���py���yV�Zg&�dI�sY�C��60�@s$R��P �!����
�+B����P�S��BH���f���@o]����=y��q����=KS��u�sɱ�����E���pD2l�5iV�A0���n]�`�S �)������k��鼆@��䍉+d_�$Jl�/i�����:Ë�k�!���J��S�Ea�1�z���9lښ�����J�H���R�7��JckCAIH!�`��-+��<ݚtRA�J0?�X�O8�`���-H�1���?��=~�xG�a{*���+"n�s�[��n1L����;�f��[$2�W �������_�����^}(N���bvo����x VM;/��B_����P��Vj���,tӧ�r���ܝ'��eɋʵ�7��^���!xx �
�@
����3$�i"4�X;�V	|��r�I��OF��a���f���Ɠw�_k�����F�#��� �w���y�;�D9@2�ʴv�gŗX��
��I�W'x�0�X&#uK��2-��S9�����_�I�&��.j�4�Q?���dC;���O�P���ӽ7�4���W����'��.^�Ԝ�v�����Fy ��v�niS�sX"���P9��:Mسt �aa{�S�v���غ���Hg����f��-WD�'Q�ȟ�ᎃ;��6QY\�%~���PɐR/�8N�;�}n��j���
��+x4�6}��q��IN�A�:iu�{Q��AJ�����:kƶ1n�8�aM?�&� �Y������wS�j��`~ʢD^��������8�f�Z���u���Ǫ��A�����F���2u�@�6��*�2���fø�e�L��0&}$���G��4iw�a׌��/�Bg����!2�j3fuL�nX��d�f�ĩ�z��z�]N�x*d>�1�W`FBp[	��kk�S3�O��^�i@y���;����я���d��~"��jv8���X�O�?����z0`]N��!��u(��J	SLIuG�f}~�eT*���z-�������q��'�X�jh�N��&��_�p#Wt���[�����z�`v���ź����ǈ�ܦ��) ������4�za���}�$=Oaq4�ʿ��|����s��k�A#����=���G��?�X������v��D��L���o����gg�i���n����'i�r>���D�У"�N����`"�/�;Ƶ�/���F�f�͆��<C-�d�K���� ��+.a��ϴ~���r�gaGԽ&	�2]���"k�М���b�����'`"�?{N9�4���4��T,�}�[5�B�E=^���
�3%�����P��,�>}�Nn��Dy�Je�2����͸_ep6���ͥ(>L� ���>V]������^2�S���l�^ODE��߄	#���e��C�m=��ӽn��'�"���:O�/��3��ѵ��ij	U@�V�RI����q@Z�r�:g�C�_g�Z{y�~VEFR��h�!�$Q}2�b�Lx�s�]��]GN-Y��@�����S��oa.�����]�O b���:e �#�aH��l�W:���b����y}���[s흮����Ry#�3���Q��nO�a@#�&ć���,�L�Z��ψ�J��:x�X���{n'u�:���p����g�����ҤO����<�&8�?6a1,�i	��v�2ܐG[��I�M,�҅�����
�j����JS1bk�[6�FL����ou$"�G�g1�\8^��3��?zx�?g�3��C�;�`�jiŀ*1��
˪IU�[0Q�@g}
�0�߈�܂4��.	&�٫w'$���W��"����Bi�Y�!�Y�v�!ҳ����1���dAۿ��U���=��L�@ X����ɮ��vP�D�@!o�=��o�F�E������_��K���C�'0�s'�H���qzU�?H�Z�$� �Y%����K�}*|r�tT��n�,kV��4_��i®�V���'�\�k��t��<�b��0�ƥ^�Ez�Ҕ��QWZ�N}��� �x�	�j{1���qp1B��<���Up�B�a�� ؔ��M9�[bw��DI��Z!��B��I�>�i����X��6����*F����ܕ��`d'��|���yv��H�8e�GZ��e?�AL�����i
i�YT�z$��F���M�N+j���/PL~s�9u�gju�/�Xc#��[�|ڿxfؠk�;�# U�����Kr���Ӱ���h1g�)�ߔH�r�|0���_��0��96�q���o    ��hn�O�L-/uf뭕�L_����_[rτ��	���	�����y�@6t(~nz���0�hXN�����'� �a5�4����l�`]Udκ��d��J`#ׅ���LN/*X><JlSXL�g[�U���I /�/�G�Bb��n�_������C63Ġ��̰�;h�g7훧P�,�`�E�wd�h���BZ	&&�c(F	c����ḵ�?��uVi����{�~˱��k^��e�q���<��q����z�慸�/�f�X��>�E~{�n��5Z`�|u�����,U(��ߤ��RI��!}o����e�~��ۍ���
T��#7�	ί��b{E���2�Ş�n]p3�c:�������_V��W�d0T��޻�a��a��3܃\��Y�=�A�pG�DT��qފ�0��f0����;K��]���~�둗n����S[R�����x`�fH@�0�B7Z���Z`Q��T9I?
C���|o������D���$$RE$iAu������3���g�2Ț�q׭�Ų��/�����S�׃�ԂOK' ���� �p�">E8f�n^�9�8:�'��n����Dd������X����vc|7?���+�����:�\��G��6�c����"N0�3�f�~O����Z7�;��c<
�j��Q�<I��;����@"��@��a�`(#&`�>Y�4I\'x��F�VYhJ{��Ja)���9���W|o��g-��fb�c�*+\�w1�-x���{4<��ri��%:oع����y�V�'��P��~T�QVF^�U~�忋|^��T���ʦ�A��BA ���l��$��Y?k��[.���k�^������,�+0�e�y�7�
Oi�U���/�����|h'e��tV�	��@3<�ż����CM�o�:��J2�N33��y�٨^%[�����ԣ̐NY5��� ���%����'�2��iY��b��i�R�(�80����a��(����EC�D�����I �ݎ]��\J?9��Y�|�R�8|ˋt�T���TK���#�m:x)�$�$���,�\��i:'��Z�� -0��j`�l�����2q�b*a�0�v��^��%⟃���:/&>ע�8@��!x�G�jbisr�E����O/�RL\�ZZ����b��r�_<Ik���Nw�%�!�j̓���W6�j�a4s�v5/"xC����~k|�&x����U�.�yZX��:P�[54<35�{���#�"�4��{��nh�ͪ-�=a�q�R%�c`��'�a:��'\c�QZ39o�pQ]�3a�4aDi��|nS3�3=��~1S�YW&�r�!��j�k����_���p��°��&�笾x e��\��d�M���t%��֪���%�GA�z88��Df\
�j�,�0�"bާ]�9�<t���LO��1���>ꦔ�������<��L~�ۛ��f�W�h�+tcm�U�b��ܐ�� Ll�� ���d�����Dg��5��O��n��	�K��ꉞ٩?��	�>k�]Xwl���k����r�J�������0�Q�S�Sz=�QTp��Ȣ��CIb�a���?s�rJ�=��;�6��	樟��$b���d��Akb#4�UQ��[�x%ލ����pX��Az�N�uh,:�e^�)�vT<RD�v��~>�N��qI����~i7��� ��>�sL�6�Uإ�3ƈ<E^�
.`#�v�k����߸�.3�';* �*'�v�Ӯ�E��I�d7˪��!�>������n���4��B��5�(�,�X7���W� I��	88#�J ��%Dʚ74#�<�"�tZ�ߊ�%��(��b?��AI�O��pp��+��{���(���u��CVnr��C��j"�a?��%�L�UJ]&,d"P���0rV���9��x+"��dQܧ\x�� �Ԭ���.z��^q�V��<{��Aظ���!�zt	��k�w��z+���藗H�9.0��N��i�#KJ8M���CS?�Wi6��b}pgc!���dp�ƫ���0m�m�_�J'_�v��Q��&93.��c���{S��: ~t�d~���]*�����9D�Y#&����o��D��W��)	Cn=��BC쎦�T�*#M����0T��JҲE"�F��β	����:_^i�#����I}�i��wŲĚ�{���vh/Q��1�2uJ��02\P�ZU�H��\2��2'�Xn����ses�$T�D�O��33�Nk}�[�y;�Y��>T����9�/p���E���?��!��`���@7c�&9�}�H�w�#��l��:�����*���_��(�.���w���zR����t�c�a�|
v�U�P{��+� ��E����0�a�
�zf�&�m��L�7��R#9(��s������^�@y����f�_�V�:$�x �h ��qiB�h�M�&�3;�����QhU�7��KrIgK|��fݧ�r�� �<��m[1a��1�-�+�5�2)�s��\_�$Jy�U���W�DX����G����!A�rqkk��{4�4B���Z֓�
dŰ~-�Ʀ���X�?0Bq�Y��}Ay ��BF-�/�E_Fv�wff�Y�����uO��}Y��~�Mf��iv���caÃ=�ad1 ��&�!�͉��6t-&�)�P�'=�G��ˊ��$�	���5�Jp��!�2�,+p�3��&@'l�o�� Q�5eQ)ؑ�Iq"S!��5dP���Lw�)�,7��^�W�fBpR)��B����r��L�̅<�[�5��4���h-�H��y2����J���r�����	sP.'�K�Py��f܊��ʹO�F�P>�F���>^�<����㟖ފ6;�f�&k�:,��"���'a3	i`�=Ͳ�n�, lX%�s�������K8���:��G%�h�-9��&E���^
����޷�qJ�����y2H���l��jhU���ق���&>(˄|�1R���|��!a�3G/k��a��m	2���P�:C����Y����LO��w,2%i�#����P�;�| 9�
W0���9<�F~��ڵ_\e�h�����F�'u�z�F���2A������m*����j�j�6�ě����ǘς+/���S���qJ�}д^��\r��ENN�S^;��`��^=K����"��s�XH�B>��z�¼,����✇��h��a��4�3��ˬW]�f\d�{�9l>C��eY`u���:�nq��bG��/QA�r���1Ճ�.q!0�"q�1ad�)�_`#Q1��A�f����l5�f?
�e)�T��dV2oy<� ��[�����������xR0ᦧ�wZ��sͻ��&��|�0񲋻���u���6a�ֱ���!�g�+��4�m˙3���9�� �
�0TҿW&�p�Z���dﺾo�e�,O�_���s������C_3�e����$�,u�w��z��|N�A%`{C��6�M��K�P� O���[����X%�ʹ���_�p}��)i�ӌ�) 3��e��\&���u���B�����k��w�L+��?�Q�ͱ�g��F�*,3�q���W{M�iqY0:��h�Į����Ī-[^�U9��4r["�'�{�2��pS��f�{�>���Dߣ����<��ū �
W�pB
�܂�[v�L6ͫ(&'��b57\-�hrI"�]���0�)�.h�)��+r��f�d `A��%f}S��b��y^�ȇ|�����p�!��m�@�tm�&���=�l�i�+��Q���KElq�{0*Q�~�j����H����H2�+醤�᢭�3M ��3��������Xx��ya��aV|g�{hG��3��:��w7�k�"���\:c(a#�}��(�:v�����i�ط-��J'�յ�c��x�`ɵ�[�������$�4���"n>7�f�^�blUG�Е���%���'i=ͪܻH�
���m�pZ"8�����
=ױ�<����     ۬���lD#>bD��^�U/՟?Ư�G�Ƿr�1ͪ]A������pw��~�ǋ������X��;��V!�L���=�B	���f�%���Wڞ ��L���ʬ,�6]�?:�KkG�&��"���Rn�fa�A�+�b�Ќ"�k~AX�M��&R(W#�/BzU/pf�:���.��Cy�����g�� ��]��5m�z�)�u~��S8/k���� �)�>�r����;fC�TY��F�=d-ΨK�KIY��cx	��柗r��Ά*�oRعc��������Au^�`�4Ak���۽�ͮ�~b����:�n>��d��i=K}��f��@=��:,18�a"� ٚL^JA�&
_����y��c�&�z��6aɟ�k;�������g#�f{�;��QR�$y��)���b���)q�v~ʦ�+�F��S���Q�פ+e�b�²�&��U��AƊ��ݮx�?B��k<c;[�eq��gn=.?W��N���i>-/���w~7��Y��a��������O�{�q�;D1���:X�m�˺�R�	4��0D��h���鴬�#�k�K�t
r�Q���I6N�OŰ�7ݝ�w�|�����f��{@ojy���޿>z��ݫz�}R���h��6��܌L_XRB��@�����HG9b@��>�
��p[�Tp�7Lr���?z��%��YV<��X��q٢�P�����0���/?�^�=�/5aT3?�BA�Y��H/׍���x	���[�Y��<�#�ܼ��]���|ǟ�8,�e�zMU�522�uݝ_�+��\/lC鄁m��8f<Rt� h�ZS�V,$�)�E	{c��ӱ�A���u���!j$?ؙ7頄��l�I����V�����Wwf�uߣ��d�J{��ӿ�5��M~�\��yzie���=EC�]�i�����~�q:ϳ�u�yb�FRj��ũ���2i�4��H�TF^0�/�q3�.�\�5t!w['��`ԧt���@z����q�z2(��l��݇�.K�uz}�b����1�+�M�͈�I�j��!��I��eP�J���/����J�>���#!���-���L��N��Zߥ��-��5��aI���n�u�}z1K��=n@T�_��^�zA�j��J��'}\(��Q�"o�B)�O˘BE���k�`~��������7��l����S�����Yo�!����W��:�,�2K�KD<hU%uW�Ǳ������yI�Es�xG�3o�.�a06�~�-���|K�D˕�*�A��7���XU�ʌi�k�Y�0Sa ��Yc1adX�5<����[P�ƅz{�du��t�Ʃ�b�6���LF,v��˃�d/�y�������y[֢W���1��yC���a�gp�8�Ca���Ǐ��˦��y>�$���9��JL��������3��vl�5}4����k��t���yK��Q"�.�G\��m��b��֋�-34��Î����bwp��*�;�	ر���j�u�~�G{>��]S��1%a�7�\?���rD�Ft�O/mK�s��a$�O�	�š�z��y9\$��;RG�̯���.2�oK�ux�D2(C�r�c�����sJ�����l�vY�l٦i���Ð¿��Mp��餻��H�S���h��f7{�j8��,��+�BR�  O;���/;��W��r{6�a~#�Raٲ�3�K�HKϽ�׈(D�1ad�M�	��>��O3Lg�z�)cÌJ��TL&B(ϭA��h��a� ���܄5�D� ` �cu����ȭ�݃%0^�������}������>�Z�<�e	��2��eV�"���>d]D^�&�:��ɝ��}:A��쓟��k�J�pFϔ�U�9?��7��\_���{�?8Z�P��;��'p���G��"ї�������v;ؒ%��[wZg��gJ���cI�\R�~��)Z��N��˷���M�9o�����Lx��{W�Z�l#J
�2����fH$�닙�Y,�"�8,�s��yF�p#�{���7����ڋ�:�Ns��Z����rH���7m0�{���W���?�cm�ͪ����«�9ے E-�dP	^�rrw�+����$��{$��}���L"I��Y^a���P>�&2��������;����l��Uy�	˃���`�=3��~�9�k���Uۋq,�&���K� ��خ1�!��[o��,�3M:C R[�<�0@�Q���(s�����]܃�{����#�ޗK��6�tfS3�ij��f�s��e�̓KM;B� f���7�����q*�A܁���w	��<jKݨ�~�3�V�+�F����fGu��׵[`����R˖c�~0*F}����F4	,q\�H����t �K7~;�5KV�1�s�/��.7��*r�[C�g��ٚ��㻠����q]�:���-�ղ� �7��g0�!���-&�Y��$��܁����i�PZ[�g���@Ϲ��}������kp�=8��c��?���2 ?��G�wj�P��x]߂�(��壉�!�qU�|�s�	e,M�Bh&�/�0T��X��L1G�R�	���;6��4�U��4�9Ϫi���zFK�A�w��'.�c�a#f�ʙVLDR.��!� G�龓0ڲ���$�N��=�H��0��S�1JO|ea����k#4���-�e0�E��oR���<��a��{�yj�YP�~�S��v������4����:�pR���0��m5�Sk�[�uzŘ%W^�N�1��/�`��M����^XBr��aA�?�xFn��s�q�s�~���+SC����y+�n���Y=���i9��IE�M��I���ǔv�&j4�U��M��Ў�lQ\�I�&��v��Ҵz�:2�~]�S����z��o��L�����K=\�7 �x�+8ad��y@T�F|nK��= ���~�'|�3�r����)y�F�~�r{k��T���=C������5�o0�s�X�X:S�]�@	2�&��r�Ho��U6���n*��d��+�ۈ��BI���
��I5�υ���%�<�̲,lG��h��j?c�*w"61ؤ�Q����������G��e�7�o�,�P�2�Vժ� 3C�'M�d��0���k�5>��a0���a+Y���{aQ��!_Z�!L1/ܤW�R��n��(���Co?ڎ������|@,���ds?d�{/�>v����l[���d�1~�P�`MN�o��H�VM_�H�������n/�-�-�3xn�����c;͉���J�I>,>��{r4������ ��>/���gu>#�2t�VI?XGnCɆ> ���þmrh!�P�΋&�y
�.(`"���7�uiAIviZj��+[�W�f�<�b�2i��?�K�������`�@���쁵��%���*	ƚ�>kq^�y?�gE�[�Z�Qk}�*��v>���Ί�oF����
�y
^Fya�YM�W1�$��,�����lw�m��~�����
��̩��0����f��Fu�����x�W�_�d�����uN$O�~�c�%#a�BB�O�p��y���p�͔kVA�G��F���/�3(еր�P�#����^5X��N����~��0���FK��W��!:µ0��jrK�ש;�6<ΐ:Q�HF�X2����RߴX��s�OLP �H�F݊_�U�t�"�m`u+�EyU���ɰ�n��U;o�9#/��G=*/�9�`uљ4-ƙ3��%���(
S���SY�3�6�� �����OHD�d�i��֔��dL�����W����ؐi�@f칗�FM44���!Yb�N0k]�w������>�	s4���io��5=��;o
�7� �ϙq��5ޏ3�s��~u��\L8;�F��9�츊%<񳒰{ 0��/a�0���������Mh�oV=�XGO������3jtw[�Q	�)��,��!6�h{Ub��{� �1ď#��^�X�����5��g1�_    >�v]��
�<=�N6���C���F��݋w+��m��_٭��;l}8N��\���`��D���3��׈�EC*�,��&���i���j��4=�^��,�)�,��լ�/�s����$��1Ns�(1Fp:7�F<��=�����S]I>�o��B��������g�#m�w'�.�}�u=˩��hI�a=�X�n��(�S��u�n��z/� ��E�K(�t�7�Q�!J�6��a��	e���V�r��������vD#[���
=`I�m����K4��|��*4��p
Є�x/\��cbh�OǥNk�ݒ�J�����ɺpg��u�8�)o<6S&�r�9��9Y�+�����m�8��+�0���-�Kó�ܯ��ŖQ�ka#��,�w#�N^��*�kxؓ���W�$g"P�ĐZcL'����`{�����'%B8?5��y�#zeZ��og��`�#/��m�\O� �c�&�_���O^���<wQ(��㜵"Bx%�s)�!���%��3�o�9F9ʔD��fP8����o.�$�hS�Y�osK�`U>ns��4l�g�J_A�@g�tXkg���]�E���/C�U"�4�;
-������_� �%l���>�Z�c�+�Z��{\'�jn(�c�R��k�83�]I�d�h-���rj�0�j}���ieO&e��Z]�
�OĮZ�*�I#��?����ގ��7$�2���F>���z�W�>t�ٖ�1���Q��C	��ba�L���kV}�{��X��xZf���u��%.P��s$�3�`� �9�f��4�D��goa���K,�m��7!J$-�N���'~CN��	�+���^�7�Pg�F]E�\@��5�����8�{�³���0ũq�P E�z3��p�C��d�b*��$�e�q�f�G�5�e����+X�I;�����A��JU����!������ ʉH4S�S�<��#�}�p��7,�������&��]���[ebw��m���aC���;�n����{�us�yX�����>OR8I�A/y���RFva-�0���Is1QWȲᱸ^)]I"�*g�h�°$e̙�Оع>�� 5o�Q��h��,��S��E~�ɍ)�\$�)�_s��B����_������n: 63���s�ϲ/�*��:��F����`y�{�=:8�!��$�LU��I܍�4���keQˉ�(B�dB6�(��y�� �3٦�?���p�5[�+�%���';�N1�jb����i��Q�D�9�_�9C�L3��y�����Gg���6�Z�2�	[Z�.�,ȀG^�A'!஀ݩ�(�s$V9I�_�3L��Bڪ�G����%���5�̈og���4+�&�n�Nn�]Y9r	:OY�{�;ϭ�>�0/�j�{�)����k�n�[���0�)�DS�>��L<E��`��fB1�?��:XLy�q꯿�[v��F��D�����^7D�-���)I�o��H�Gx���l[�m֛t?�!�6�a5=��Eڍ�xi���VPf���f���j0�~�{�"�tx�� �>��8���u����6x,�T~YN��3t��R���ưH'��-3��"��F��b���*㨻�m�c��{|��un�7�Oڳ��dնI��`�ԫ7Ǩr���p�<��(Ʃ�#χCĶ�
�(��W�Ң�?���h|�+�W�Y��=�}p�|�᧏�f�7��a�~u��q\��0��r��nA��_�静�1ԭ���i�w�����ΰ;�v%����amf7�����	Ĵ����q�&R��I�����0t��2���$mvI
.k�_=鉽���v}X�{d=�CSu�E6AQ����}�G����w�J��P���e��c�B��w��
�.�F���Wi��t��@���j�(� ���F4�vW���nW+Ny_*/HZׄ�~h�Eg����;>s��!�Nҡ���Ӽ����럊7^�)$DHJ9�J("��E��b�v��o+�p[�����	q�_GS����G��L�RC�$��a=</��Z
F�-XyBi����L�S��9��'����^*u;_̇�Xٹ��:Ĳ�O�#Ǣ�QF"��ac�<��yς���A��P�W����xvc�%�K�C�'��'��-�_;�K@����g�#yQ��q��!�9-[n�R�*a����>�lF�4+�M��+�����(0�<��%�K�0�nmb{S�� �Zķg�h6TG��et�ı%�_��~?�.Vg|�w'ԙ�n�c�8 k�m���@A�B&JF�Opr�`�i�=�ڎQ�"���Ӿ��v��a��%C�Ǵ�U�z�	���F����5]C��V�;0�X�i��!�vٍcY�U�xY���&���R5��/!� �2
Yd��0�g>�E:/?N�� ���m�#ga><�
W�n� �.w.4!"�%�ķٰ�I	�qt��_�I#tb�����V��l��������h�ȫ���϶턘pM"��uw����[�=ܕ�~hA��U"Zs��7�=�H����m��J���<�p��o�b"P2������{�Al���	�����?��� �TB ~�^D�cFvb&�q�g~��k
��U>���i���-��5�Ϯ��J��W�^�iD���N�$�������舨��� Y��w�̗i���C���69�d_�8�.E�{����w�R��`�\TG������#�>�!ú��^�,�w���f���_e��o�p�}<���%��T"��o�Fƹ�XVƹ��b蠠�]�� ׍�(�C��)h؏C�ck�*xҹ������s�;�,l�� ��3�=��hn���^�n��Ţ���E����!�t�������k0w!����vC_�}v�����S2K�;sS��U�X/���E�yx��z�B� o���gc9ɪ�6�&"H8B�D��H�o��@_��t�%�d?7�$3�#�'i���-�z�s5���.&𵓎�*��M;�Co]߄*o�5&��eb�v)�!�b�|x���w7��`)F%�b�A���M�,?N켻;d6�7�(���m�-���r�|GNGV���l��+��Dؿ�!��V���9��Ą����Բ0/1Q�0"n�.�~���vc0G�n�	q��!!����Z,Jlt�y_�Da���Ӫ�֠6s�Sמ��	�L,��RK"��	������1�����H2��,���O�qZ�DJ�M��%�h���2���S~{���ܺ���tE4�Ⲥ�@C�|����5A�`[��T��Mtg��E���_u��D�y�Z���{�e_��D�����:g�.����ڊ����"	�0R6y��hNEb�����_9��a�r\�`&�=���Fu��_���uPNQs�t9����b$��I8�;3�)9H��y:՜&rKp��V����(�'{�k0�}եz�>�V�z�Ro��BY�J�6�Z��hëÐZ^��K\�1�n(͔�1��o'�؞m�+J�gܴ;��R���-d��L5�L��N�&�Z�mðl�IYe:DQ=�!�(��+���e_FZC�7��������,�_e��&ja�uQ��M	�qs�ZW�s�$���fRL ��2�����7��r�%k�3�,�UO�������ŮX 9�;������eg��+�L��Z�y#
�)�F?��*/V2.=�i|�'�|xY�H�f3�﹅�}���V����*�5���Q0��`#�0`�nJXLuƌ�ȫ�H�k�K 
�7�PejGFE/�a�S=זn����M(��@���N�ŧ<}^ź�W�ĉ=5p���(TI�\!�e]���EB�ub��
ܽ�H������o����ܓ*�Bj=���Nq��Γ!�TB��ӷ���Mp`���FW����Ӷ8�%��B���$�M
�!`#�����Q"�0%�B%���LW6ZOҫ����{�f9o5�����*�~J���������m-�"b�$�'v��y�E���ܷ(m�Pa5��J�o�A���    ��b��Y�nLa[E��]�\���=W�H?��y��+�/􋮐ΞMI}���oJx6׽#�S)(���Ӗ��hI���a�~�U,�v�G38� �w닭�ʧg�sK_0�ww-w�Q��>!5�&V4���I��/��F�� ��a�2 �������$ͧ��4Δ�����q��W��u��nbAI���E�d���?�+��9�v�״���(KY��:{7��eV8]�HA���r�#$$���MQ�2���F�a�Cf�8QQ�kD��*�HI}�̜��*�a{���ù�V�w�_��52��3�
�F}��O`�5p���c�xLxu��̌�.�_���R�>3Q��Mw������'�����y}}�
��h�і{�Bv\y�ן�O��;���h�a"$
�zP[$¿��a�H��B���P��&�|���A<W��e�Q��U���A*���52�#�%���n���p�u����:�3�+��E�H�IK�+-�ܟ��3� ���\W݈�Ab:̿��t5Tܛ�������!}W�ټ�]��Q�Ĥ������l���g��	?��6M�rԑdSql��:�C�T��f��1�[ي(��C��l�kv�_��9%��a0IK���R�]k֬��4\�pW��B��ܱ��Z�T-��g({R$���T�Xh:pSsw�g�M��<�S��<���g)�U�!�'~iL��$~�Q� �,�{`Ke�]U(��l�ܣ������0��2ƾG���Zh��I�䴾 �Wα�h8�U�������Eڭ�Q�g���
�巋l�d�7, �+.�LL�l��N%"F�w!hB��%�ｄ�&��5�a�e3����%xj��PV��C��e���'C�4kl��}�;_^Lj�Ѣ6������'H(��!޾���ĴAh�`rQ�k�=�-o�е��qi7���6�ޓ��� �o��K�
u��m��e�d�!~I��X���}H.�qܐ��<�`�� ��I��9^�+��L��m��h�4ݽ��)�U`B�֘w(퐗�?�|b��^dUU���0�h)!U��[�x�g�I�L��q�iߖ�$_��c�P��,��֖�(o1#L��=to�(f�
����(�[�>�1����6y7;���')Xl�P}�E7̈́W0�Y��B�Im�O�@��H/���:%ݥ�>lB����q���*�IH�{����|�}$���-j`ag��$�G=_�m�������E��s;o��t\��q]>��q�ƭ�`%	���"ł!�d�2`lA�"%��/x���8a$����&ᡝ1�Zغ��*6���N�����|�ݰ���p-�i�J=j����w����Z[o#a #�Gڐ��0��^-�ppl�D8�KP�ծ�A�twV�~�8	vQ�}�`/��:NL62ݰ�� o�Hgٌ�T_�>����*_���o�����&/�ې�y,dA�T�&�%�젷_V�t��cq���)�Qu���H���6#�� +�OO�=��i ��a��F���=A�/��Vk���F +R�0��Nm9��{�qXh���W�,�c,E6���-��[��@�ds]�y��-�cFy�l�O��:����혾��h�`)��y���7�a����ۧ|o��J��2�l����
畡�N��I\"J�37.r�"�!��"��FMr����J|�v��.��w������H;�8��~�O�%m�h��Q�=�4k��#��˻�pbq*��pB��9RpĠZ�!�A���G!�3F-jH�Q�O���2��D�����aA��mP7�z'O��M�[*�H�O���'}�ߦ��� ̙j�l_QD�@�,�������?"}s���4�M�$jk|af=��;����	k���SVge9Z�ܠAV�Ʊ�h�Q��$���4w�G�0��O 0Ȑ�5�N0���c7�5�RN�<݋=��3u�4�	�^E�7����~%��m��`���7���F�%Q����mY�n�%U	� �C��<�!�@GSD<���O�2D�YF�ydS?�k>_��0p)�<&*!Q$X�8+r� ��n�Z�y���1����O�߰���6�G�A
�4�b'4�F��WLhxڕ�Tw��3o �8��*���<�|cK���{��K�����[�;��.�vk,�D
�*7ԆO�!�JK1���VN�$QA�X��w���R�ZI6��Q�UI�}D{��$���=��)�[mS6�qR����T����Igg6Ե�Ez���n���k�`���M��&e��1����"���-u�Y_(������z�'~�ױ48��Ԟ�N���� uh;3�r}:���I`�R�Z-��r����'�4� ��*$b:f�L��q4�`EG(z��||�R@X�L���L�-�fZ��Q�ug�F��w�:L��j �Q:?��yʻ,FV�f��⢬�4�[�.I4���'��0y�~�-���+��+�QV������kӳ���3zU���F��R0&�ݲ�����Y�{�
�b,��p��@l���=c�\�1�gȎN���L�j3jt8/9�$�'��Z�G�ȋE� ��J��������''?�;����YAN�A�y�Ip���y��̏�����sU=	��Ϋ���x��ܑ7�##� ��T�2� �k[���x�|�.�Z�pg�ݳ���>�|�Oz~��q��n����:��oc���Cx��؎�#�"C2�a!<�L�%��~M�w�}�A��zJ�<O`��*���j�ۢ�c�ŶlG�,-�Ta#i��
<5� �t�kk�,�é�L��֞&0m���N�־���\g�|��2[Ry�h�-D�;�F+6���ШM,�"�M�ڄ�!��u�U�&A����o��?`
���:[1������/t� �$Iz�x����l�h٨��Qv�h�����II��X-��k�p<�	�=#��8 ��.��K���.��!��{��su��ҽ���*���EZ_�4o�\k�9Q��/_kT�l�~E����(�hͦ&�7\����3���ډ��	h|A�8��!u���=QCcA#����P�~�s��)/����ؖ7�ūlnp�G�mmLF��v��c୍�ѧ8*lU�1�Vmq
���Ѕ��F�]�-ۉp*��q^���h�n��ia=�s|-TF��S���+N��*�@ID��Z�w���	���u?Ǥ$n?���%Ƨ����Ⱦ��~�>��݁s� �i�>A�3`Ib�K�`=�r�u�/��q~7U��T7�6�v=��b�JǶy�����B��w�?��I=�sp��8�X��M��e+8X����f]�xQe*a����&W�ˋn-��۹G?`��N��yn���x}�Q�l��r�k�O)��
f#-RYK4���_KX:z�Wa#�&�1�6����PJ���W;������#�O�	ֻ(l7�PԪ�z��M>�y�zJM����{�|O��l��h���؈��M�\.o�9ad|�y�WH��e� Pl,Z��C�w]�K�0�8����;==z���.]2Ȓ��3S�ȋ|>�f�3��7���q �	��	j�;��nR�ﱛ�����%�m�TI�h����7��W���M=����n�MD��#wL`#�NT�3Xa7?a*F��*��8�����г�p����d���{o��vߪ��n7I>���O߂�M��QJaߐ��n4��Q��(��ey'�g�F��Ś]H9VT�̴e�:Φ��:%,�c�������2A�)�oВڈ=ѭ^��A����� �g^�^�-�KI�5������:�����v�o=أ></g�tYj��w���14�GV`^�W�,kX�t1�?Z�(g�~�I��ޣ* ���䠬���JW��l\���)�j����ڮ��0��X�M�ӯ�� VtunC��.��4�M]�Kr���Q�V�.Ocw5����¨��_jz��9��H�;f����18��5adڗ/�Ȯ$W    Z�k���M��1��8r|�E�$���5s�X�k�^��%�-��C]�II�ȫR��BD�12x��=��qgN��V�����w}�+f�֎�����59IE�ǍMm����
�d�
��i,��}�~��#ͻ�3��jąh遯�U9K���im�����;�����3����zq<�l�3B1e�4��d���J��G��6'h�?L���MG&UL�@E����_ġ~�JO/�^I+�~�t*ȧ���� �9�H�Ok�������G�i>�[(/.��MI����IۘD��u�]��i��0���=V��SB���K���gg5�Xp�dW}�������^5��O���������]$��'���?Y���N����WM�o���D�����,Ӹ��O"�&�,ﰮU�l��B�����!�|0z:���#]I߭����xk��8K6�(���"������)�Ш��GR\[|���y��Rɟ����>=�ι�U}�.��[:!��q�$�i�X}�3̺�װ�3�hUm�t��e3�`� ��$ѻ����� �^������o��=�j�'��{��)e�.���+�S���.���V�l?��c\L���+T���1�1�/ط]��I����EY~n\-�؄��ٯʬ ҍx_�>]`bۚEO��	V̓�c�����L�xK�|�<�]ֈT'%��Y#��>�n���s�B��D!Ca�G��ϑ\��Q��a[ :*���)X��*����<�)~����-��V��[Y�9�N�[ 3%V+H�$�]�K�T	r�;��0
���lϗ�����c�f�T;-p����c�P^�W�Y/��:�ZK��M>�i�96dS�ߙ� �t@�=�Y�C���:�2�XJh\t�o핷")�xn��f��F���	�E+�D�k9�y�ug<����ěA�t�����k��^�קG���`������~,�u�A>`��=�EQ��4V�ߣe< E;�Qr��VƋ_iL�����b
K5���c�KH\��ޤ3��;����d�yY��ͻl�UY?��ꇑ\��M�
�kZ�Z���5��4Y�t���u4[������)z��e�i�Ҩ����t���I--�0���,) ��~"�J��4����L1��y߬���&���ݰ�^�]D8�'c�,���iS�s�@ � �s�JC�t�	x�Z :��4�����Wx�>�����v��}X���K��<z�����"^��yv	&6�����d���q^a�@�Kf�,+oԪ&�IL0[�k�a#�Vy����,�2d���#��P2	9����JF� �������G���ɻ�MĽ4ds��{�������y@^��4ݿH�<#������K�ٰ4&H[�|^�Gq���v�w�>��O�%���e$hVM0��5P*vF��P!SM$��W�&_
��~�ᢊm?x(�oc]cm����3ײ�xl�=�p&h�a��m�Ҝ����2�ai5�0]DF��Oﲙ�ֱ����0��<�m�j��ľN5KX����0���B����e����t<�? ?��@���XWа->���h��nV{*��av�M�j`Z�$C��������e�m#�����S��/<fe��my��KV��7)�)� � $S���,��"5��e�cso?�&EI$ES���+-�D��}�뜎 H�U�L`���M3ݧ��Y��郒�9+�&�x
�Ϳ�6���q�vz`;#���V��<�α�E"��x7)��QW��j�v��a���]���y2%�2�w��$��>�}<�0MW�"����O]��ve���yXh� �8N��8JPUGh�Gh�Q��C�MQ#���0R��U=�ÓES�$0�E�#*��,����$֕z��s��l켗%�ͱ��2^/�� J��)�⪼5����� QPF7�aj|��Nu���z�:{�7��B�c"0����r����X���UT��8�
��#<����#<W���_0��W;7�(��� ����wے.�1���|��6���YQC�a$}�n�L'��f�.�@�� M*a��O�#��~B�0�6�]4S��������i6z�C����8SҜ�� n��N�p"���ipQ�lp{*r�x p���k���d��˖��6���j��;��b��fGZ�U"�����_�&i���y?k0�޻^S��D���:�gn�����%�_mܖ�t�jiX,�f%jW���d01P��Fu�pp�2F�:g5����6 �$E^�"�Μ_(�	���,0��1���,����O};� �7���w/!���%}��V2/`&">�d0��[S�I]*2?r	��N�K�ն�%�˪�g�c;7fm�rI茳��%�*tC�u�1O1y�"# �KuQ3p�R�K�g]p$\%gT��y��e�旣��v��`���!"@]��l97����O�'��#^��ʌW�էJC$�<��OV� �%�|�-�%*t�{*t�!�^���E�*�V��u��X�݀mU����XI#a.<N�_}j��u~{��o�6LA�T��C�%9��$!7^���:���c�2!��ZV�[�1U�)B������4iޥ������sr�G�N�㤟[q�����_ ����F�ۇN:f����U5nˋG�d?����j������v6WV�Ć�6"ħ���F��"y,S����Shi��y��QCp��gɵ�'��җ�5�����'�5�������w3�t��_�C�6������5��4aY��1�<�1�u3�q�@VpsT������r�Ͽε���hrX�oBe�I�����j��;/��\����G�.J�BGȷ�:)'+;҂��K]�C�$��ty6��@qv�"A�����LĤ:C���$_a�F^���,���[E�v��u�6O���,�}�(���Yn�QF����}1��$Xz��W��S�z,+��j��H�am0��{��'\e��4�M���/I�`+���WJ�j�oB�+�Q�~SC)�HI�8m�f� ,_?) v��@kl�R�1f<˕]�ՔL��rcK_���p�8śi�=n����U�	*?����ٻ�l�ڲZ���,���K?B���Q�HÉ3&�ڸ���V6�+c���w�TW^6��u9�:\"/�m	�ko�f�
����˹o�j6,�TGnK;S�m�u�=I�	�f ����Y������u멪�lZf�e\h��	ہ��(���D� ��;����>%]]S7�Z����nH"�]3+�I}Qbσ����wK��h�v�YQL�M�'�y�WN�HU��;�ғ��ڴ9����BDu��`�/Ai�D���xr	j����$w��W`�P�������{���R��di�>6Og'����A����6	p�ϒ�z�*�`�<�%8��"�Hl�8N��CFD��(�}��gժ���ԉX܍�Sb~ר9�z~K�o�l�K�F�����"q�ٴ��z͍�p�Dz��=�\	��B'E�~L
����P#�	�QLj�f�.B���9�L�\�f�,���jF�8)0�3L�~1�~��`Z����al��xg9�IQ(ŁVi�a�S�f���Aƕ�p�Js�H����V�y�`�T�f��l�Y7���O�,��ش�b���C]��j�FeP[[���B6�7y9�\W��kwԪ_M]ݏ��Q��$�����~>�1.k��Gv��4;rx�c)��S=QS<
U��Y�����Z�<���FVO��0#�ݜ���-�`������[���ƈ����eM�|&5�w�#O��kg��$����D�I��O����&$�e�:�\��'Ħ�OИ�P8G�{��'�)��:�����9{��~=�ݡ���o��~�ۥXo{П`Y��.��96��&P�!����9H'�ED(��N��
%���ƏU}����Dm�0���?�q�k_���f�����p1mx|�F��6��1]e��r��Ug���K�;�{���Iդ�U3�Jy�X�\��0��\2d^d� �B#��Gэ�*��` n  �a����W��mcH���S뛰+:wj��2��S��+����e޿�jhy��>bB��`+�ȗd!wp¸��fڛ5`z�,j��t���0(�*i���O{�b�be���^����d7\!��9O�},�]w'}�iR��U��"o���j���� ����e�a(u�R�P[WFCN���M�a�_9�ڮ!B�s�c��L�o��ä�>��8�������ƛ��mG�J�]f��Ŋ�G���w�d��֊�ݙ���!���ϳ� 4jJ5첚��<~>����w�8�j<>f)��֛5�Nw���L�#+=�Y�%a�>���wN�!�WUp���:y�����.���t@�?��f���%
x)z�U[S�zf�fZ֝g/z�1���N�ϟ�N��|/��$ܾU@4� �9������@������D�c��������;��a�kz]�e��z��(.��O����=n/�i�����3*q	�{�l4��қ04�mpA���2�Y�7d��D���{�e���l��:�y����w���ݽ^��&��]z��?(��K�4|���.30z���Э�d�D�0�x��b�!-����򒼨��%db�k�Fl�����9�?��i���eG�{?��L�0��{��k`N�!�)�J�QU�I����$����n=6���'���Mr�0����k/�C�2��
�� {E���_��UeYՄ�W[���'xˊ47N��l�8�e������1�]�]%3E�����}Uj�GyB�S)�4I]5��v0�#��U��g�?�kڙ�ӗ�[;�GIzvW��=B�#�4�7G�D2�iv�]���ß�e�!ȕ������.���`�S��o�t���=ʹ��T�pʱ ,���kj��U5���넼��kU�v�"~�X]X�LOm��e��x[��M:_R�V~�}�	/���������iW�@�@��j0sϲ3<���}3�<�Uw�p� .b��N�U�ԭ���GE�Kpћۀ�O����ՅS+�{�"T��.���٦c���̗7&���t�G��ɠ̜~�ד{���u�|
wSx���eC	�=G`1��QMz�� �Qd��\
�ͦ�I��T��������<�Z�J�l��b�,�<�����j~>�u@a?�#g����Ι���x�(~L8�7�?WH~���@�������)ȕ�&��{�m9��X��A�&B7�>vQ������p9BU  )I]=�4��73�ԕ��LH��J�~^f���jr��� &|E���/׻�,�'��L��~�^�dt��@zQ{T:@Zs7����*��94���M)(�f��ȗ �K��o }�Ẃ�i^^�\rͽ��oe�F;�P�?S�ǳ	�Mס�߹|����!Ib3'�vL(<���Ц�0>��<)`OJ_$F�П"Z�+T���^9��Yt�L�7�1&EC;�:�*�eL>.����,x���-t��U�XU���|��_��x�Y^�a�����1�LE" Đ7��	�(G�iU��� 4b�#@���m�t�>�	_�[�����Ń{�}��mk��*�S<�#�{/����8�w���_��         P   x���v
Q���W(�,ȏO�I,NUs�	uV�0�QPq��tvT״��į��: ��9�������a�@ڸ� ��)�         f   x���v
Q���W(�,ȏ/HL�Ws�	uV�0�QPq�rqTpqu��W״��ī�I�s��Q����\\���Rm�"��/��5�������� �8f          I   x���v
Q���W(�,ȏ/HLϏ/NMIUs�	uV�0�QP�u�u�Q״��$���#������� 7�0      "   V   x���v
Q���W(�,ȏ/H-*��KTs�	uV�0�QP2}���5��<	)7*�ws�"J�1X��s����_�+H *�*�      $   A   x���v
Q���W(�,ȏ/H-*��K�i�9��
a�>���
�:
@���S�����i��� sH�      &   T   x���v
Q���W(�,ȏ/(�OK-�/Rs�	uV�0�QPw��ut�R״��$��I��qz��z���\��z���� ��.�      (   K   x���v
Q���W(�,ȏ/�,)��Ws�	uV�0�QPw����uT״��$��������������� �1      *   n   x���v
Q���W(�,)��/Vs�	uV�0�QPw����u)p�st���s�QpqU�qT�t�T'�D#2?=Q�1'''31/9U�3�$�(/�$3?/1Gh���5 `~&�      ,   
   x���         