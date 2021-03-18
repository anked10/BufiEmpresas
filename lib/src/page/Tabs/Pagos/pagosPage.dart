import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

var fechaI;
var fechaF;

class PagosPage extends StatelessWidget {
  const PagosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final prefs = Preferences();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Sucursales',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: responsive.ip(2.5),
                  fontWeight: FontWeight.bold),
            ),
            Container(height: responsive.hp(10), child: ListarSucursales()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: responsive.hp(7.5),
                  width: responsive.wp(30),
                  child: ObtenerFecha1(),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                Container(
                  height: responsive.hp(7.5),
                  width: responsive.wp(30),
                  child: ObtenerFecha2(),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                Container(
                  height: responsive.hp(7.5),
                  width: responsive.wp(20),
                  child: _botonBuscar(context, responsive),
                ),
              ],
            ),
            Expanded(
              child: ListarPagosPorIdSubsidiaryAndFecha(
                idSucursal: prefs.idSeleccionSubsidiaryPedidos,
                fechaI: fechaI,
                fechaF: fechaF,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _botonBuscar(BuildContext context, Responsive responsive) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        //padding: EdgeInsets.all(0.0),
        child: Text('Buscar'),
        color: Colors.red,
        textColor: Colors.white,
        onPressed: () {
          final pagosBloc = ProviderBloc.pagos(context);
          final prefs = Preferences();
          if (fechaI != null && fechaF != null) {
            if (DateTime.parse(fechaI).isBefore(DateTime.parse(fechaF)) ||
                DateTime.parse(fechaI) == DateTime.parse(fechaF)) {
              pagosBloc.obtenerPagosXFecha(
                  prefs.idSeleccionSubsidiaryPedidos, fechaI, fechaF);
            } else {
              showToast1('Fecha Fin debe ser mayor que fecha Inicio', 3,
                  ToastGravity.CENTER);
            }
          } else {
            showToast1(
                'Seleccione un rango de fechas valido', 3, ToastGravity.CENTER);
          }
        }
        //(snapshot.hasData) ? () => _submit(context, bloc) : null,
        );
  }
}

class ObtenerFecha1 extends StatefulWidget {
  ObtenerFecha1({Key key}) : super(key: key);

  @override
  _ObtenerFechaState1 createState() => _ObtenerFechaState1();
}

class _ObtenerFechaState1 extends State<ObtenerFecha1> {
  TextEditingController inputfieldDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _fecha = '';
    return TextField(
      decoration: InputDecoration(
        labelText: 'Fecha Inicio',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      enableInteractiveSelection: true,
      controller: inputfieldDateController,
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
        _selectdate(context, inputfieldDateController, _fecha);
      },
    );
  }

  _selectdate(BuildContext context,
      TextEditingController inputfieldDateController, String _fecha) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        _fecha =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        inputfieldDateController.text = _fecha;

        fechaI = _fecha;
      });
    }
  }
}

class ObtenerFecha2 extends StatefulWidget {
  ObtenerFecha2({Key key}) : super(key: key);

  @override
  _ObtenerFechaState2 createState() => _ObtenerFechaState2();
}

class _ObtenerFechaState2 extends State<ObtenerFecha2> {
  TextEditingController inputfieldDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _fecha = '';
    return TextField(
      decoration: InputDecoration(
        labelText: 'Fecha Fin',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      enableInteractiveSelection: false,
      controller: inputfieldDateController,
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
        _selectdate(context, inputfieldDateController, _fecha);
      },
    );
  }

  _selectdate(BuildContext context,
      TextEditingController inputfieldDateController, String _fecha) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        _fecha =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        inputfieldDateController.text = _fecha;
        fechaF = _fecha;
      });
    }
  }
}

class ListarSucursales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sucursalesBloc = ProviderBloc.negocios(context);
    final preferences = Preferences();
    sucursalesBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
    final responsive = Responsive.of(context);

    return Column(
      children: [
        Container(
          height: responsive.hp(8),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: sucursalesBloc.suscursaStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: Text("No tiene Sucursales"));
                }
              } else {
                return Center(child: Text("Lista Nula"));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, SubsidiaryModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        actualizarEstadoSucursal(context, servicioData.idSubsidiary);
        final preferences = new Preferences();
        preferences.idSeleccionSubsidiaryPedidos = servicioData.idSubsidiary;
      },
      child: Container(
        width: responsive.wp(22.5),
        child: Card(
          elevation: 2,
          color: (servicioData.subsidiaryStatusPedidos == '1')
              ? Colors.red
              : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Text(
              '${servicioData.subsidiaryName}',
              style: TextStyle(
                fontSize: responsive.ip(2),
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListarPagosPorIdSubsidiaryAndFecha extends StatefulWidget {
  final String idSucursal;
  final String fechaI;
  final String fechaF;
  const ListarPagosPorIdSubsidiaryAndFecha(
      {Key key,
      @required this.idSucursal,
      @required this.fechaI,
      @required this.fechaF})
      : super(key: key);
  @override
  _ListarPagosPorIdSubsidiaryAndFecha createState() =>
      _ListarPagosPorIdSubsidiaryAndFecha();
}

class _ListarPagosPorIdSubsidiaryAndFecha
    extends State<ListarPagosPorIdSubsidiaryAndFecha> {
  @override
  Widget build(BuildContext context) {
    final pagosBloc = ProviderBloc.pagos(context);
    pagosBloc.obtenerPagosXFecha(
        widget.idSucursal, widget.fechaI, widget.fechaF);
    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: pagosBloc.pagosStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text('Pagos');
                  }

                  int i = index - 1;
                  return _crearItem(context, snapshot.data[i], responsive);
                });
          } else {
            return Center(child: Text('No tiene Pagos'));
          }
        } else {
          return Center(child: Text('No tiene pagos'));
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, PagosModel pagosData, Responsive responsive) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(15),
        child: Row(
          children: [
            Container(
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${pagosData.transferecniaUEConcepto}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text('S/. ${pagosData.transferenciaUEMonto}'),
                  Text('${pagosData.transferenciaUENroOperacion}'),
                  Text('${pagosData.transferenciaUEDate}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
