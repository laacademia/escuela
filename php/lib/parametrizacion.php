<?php 
include_once 'comunes.php';

class parametrizacion extends comunes
{
	function get_estados_pago($where=null, $order_by=null){
		return $this->get_generico('estados_pago', $where, $order_by);
	}
	function get_anios(){
		for ($i=0; $i < 20; $i++) { 
			$datos[$i]['anio'] = $i+2018;
		}
		return $datos;
	}
	function get_meses(){		
		$datos[0]['id'] = 1; 	$datos[0]['descripcion'] = 'Enero';
		$datos[1]['id'] = 2; 	$datos[1]['descripcion'] = 'Febrero';
		$datos[2]['id'] = 3; 	$datos[2]['descripcion'] = 'Marzo';
		$datos[3]['id'] = 4; 	$datos[3]['descripcion'] = 'Abril';
		$datos[4]['id'] = 5; 	$datos[4]['descripcion'] = 'Mayo';
		$datos[5]['id'] = 6; 	$datos[5]['descripcion'] = 'Junio';
		$datos[6]['id'] = 7; 	$datos[6]['descripcion'] = 'Julio';
		$datos[7]['id'] = 8; 	$datos[7]['descripcion'] = 'Agosto';
		$datos[8]['id'] = 9; 	$datos[8]['descripcion'] = 'Septiembre';
		$datos[9]['id'] = 10; 	$datos[9]['descripcion'] = 'Octubre';
		$datos[10]['id'] = 11; 	$datos[10]['descripcion'] = 'Noviembre';
		$datos[11]['id'] = 12; 	$datos[11]['descripcion'] = 'Diciembre';
		return $datos;
	}
	function get_mes_actual(){

	}
	function get_anio_actual(){

	}	
}
