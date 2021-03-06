<?php
class comunes
{
	function get_generico($tabla,$where=null,$order=null, $usar_perfil_datos=true){
		$where = ($where) ? ' WHERE '.$where : '';
		$order = ($order) ? ' ORDER BY '.$order : '';
		$sql = "SELECT * FROM $tabla $where $order";
		$sql = ($usar_perfil_datos) ? toba::perfil_de_datos()->filtrar($sql) : $sql;		
		return toba::db()->consultar($sql);
	}

	function get_generico_sql($sql,$where=null,$order=null,$usar_perfil_datos=false){
		$where = ($where) ? ' WHERE '.$where : '';
		$order = ($order) ? ' ORDER BY '.$order : '';
		$sql = "$sql $where $order";
		$sql = ($usar_perfil_datos) ? toba::perfil_de_datos()->filtrar($sql) : $sql;
		return toba::db()->consultar($sql);
	}

	function get_mensaje_error($e){
		$mensaje  = ' <br><br>Información Adicional: ';
		$mensaje .= '<br><strong>Error_db </strong>'.$e->get_sqlstate();
		$mensaje .= '<br><br><strong> Mensaje: </strong>'.$e->get_mensaje_motor();
		$mensaje .= '<br><br><strong> SQL Ejecutado: </strong>'.$e->get_sql_ejecutado();
		$mensaje .= '<br><br><strong> Codigo Error: </strong>'.$e->get_codigo_motor();
		return $mensaje;
	}

	function chequeo_zona_alumno(){
		if(toba::memoria()->existe_dato('id_alumno')){
			toba::zona()->cargar(toba::memoria()->get_dato('id_alumno'));
		}else{
			toba::vinculador()->navegar_a('escuela','3524');
		}
	}
	function chequeo_zona_cursos(){
		if(toba::memoria()->existe_dato('id_curso')){
			toba::zona()->cargar(toba::memoria()->get_dato('id_curso'));
		}else{
			toba::vinculador()->navegar_a('escuela','18000081');
		}
	}
	function tiene_perfil($perfil){
		return in_array($perfil, toba::usuario()->get_perfiles_funcionales());
	}

}
?>