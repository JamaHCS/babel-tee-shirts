@extends('layouts.app')

@section('title', 'Venta')

@section('content')
<!-- Page info -->
<div class="page-top-info">
  <div class="container">
    <h4>Detalles del la compra:</h4>
    <div class="site-pagination">
      <a href="{{ route('orders.index') }}">Mis compras</a>
      <div class="back-link">
        <a href="{{ route('orders.index') }}" class="btn btn-danger my-3 float-left"><i class="fas fa-backward"></i> Regrezar</a>
        @if ($sell->status_id == 2)
        @php
        $ticket = DB::select('select * from tickets where sell_id = ?', [$sell->id]);
        @endphp
        <a href="{{ route('factures.download', $sell) }}" target=”_blank” class="btn btn-secondary  float-right">Factura</a>
        <a href="{{ $ticket[0]->url }}" target=”_blank” class="btn btn-secondary float-right mx-2">Ticket</a>
        @endif
      </div>
    </div>
  </div>
</div>
<!-- Page info end -->

<!-- section -->
<section class="product-section">
  <div class="container">
    <div class="card">
      <div class="card-body">
        <div class="row">
          <div class="col-3">
            <label for="nameAdmin">Cliente:</label>
            <input type="text" value="{{ $user->name }} {{ $user->ap }} {{ $user->am }}" id="userName" class="form-control" disabled>
          </div>
          <div class="col-3">
            <label for="cost">Monto total de la compra:</label>
            <input type="text" id="cost" class="form-control" value="${{ $sell->monto_pago }}" disabled>
          </div>
          <div class="col-3">
            <label for="provider">Fecha de creación:</label>
            <input type="text" id="created_at" class="form-control" value="{{ $sell->created_at }}" disabled>
          </div>
          <div class="col-3">
            <label for="provider">Último cambio:</label>
            <input type="text" id="updated_at" class="form-control" value="{{ $sell->updated_at }}" disabled>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col">
            <h4>Datos de envío: </h4>
            <form>
              <div class="form-group">
                <div class="form-row">
                  <div class="col">
                    <label for="cp">Codigo postal</label>
                    <input type="number" name="cp" id="cp" class="form-control" value="{{ $address->cp }}" disabled />
                  </div>
                  <div class="col">
                    <label for="phone">Número de teléfono</label>
                    <input type="number" id="phone" class="form-control" name='phone' value="{{ $sell->phone }}" disabled>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <div class="form-row">
                  <label for="completeName">Nombre completo:</label>
                  <input type="text" id="completeName" name="completeName" class="form-control" value="{{ $sell->name }}" disabled>
                  <small id="helper2" class="form-text text-muted">
                    Nombre de quien recibirá el pedido.
                  </small>
                </div>
              </div>
              <div class="form-group">
                <div class="form-row">
                  <div class="col-4">
                    <label for="estate">Estado</label>
                    <input type="text" id="estate" name="estate" class="form-control" value="{{ $address->estate }}" disabled>
                  </div>
                  <div class="col-4">
                    <label for="city">Ciudad o municipio</label>
                    <input type="text" id="city" name="city" class="form-control" value="{{ $address->city }}" disabled>
                  </div>
                  <div class="col-4">
                    <label for="suburb">Colonia</label>
                    <input type="text" id="suburb" name="suburb" class="form-control" value="{{ $address->suburb }}" disabled>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <div class="form-row">
                  <label for="street">Calle</label>
                  <input type="text" name="street" id="street" class="form-control" value="{{ $address->street }}" disabled />
                </div>
              </div>
              <div class="form-group">
                <div class="form-row">
                  <div class="col-6">
                    <label for="exteriorNumberAddress">Número exterior</label>
                    <div id="exteriorNumberAddressId">
                      <input type="number" name="exteriorNumberAddress" id="exteriorNumberAddress" class="form-control" value="{{  $address->exteriorNumberAddress }}" disabled />
                    </div>
                  </div>
                  <div class="col-6">
                    <label for="interiorNumberAddress">Número interior</label>
                    <div id="interiorNumberAddressId">
                      <input type="number" name="interiorNumberAddress" id="interiorNumberAddress" class="form-control" value="{{  $address->interiorNumberAddress }}" aria-describedby="helper" disabled />
                      <small id="helper" class="form-text text-muted">
                        En caso de no poseer, el campo tendrá el valor 0.
                      </small>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
        @if ($shipment->paqueteria == '' || $shipment->paqueteria == null || $shipment->paqueteria != '')
        <div class="row my-2">
          <div class="col">
            <form>
              <div class="form-group">
                <div class="form-row">
                  <div class="col-6">
                    <label for="paqueteria">Paquetería:</label>
                    <input type="text" class="form-control" id="paqueteria" name="paqueteria" value="{{ $shipment->paqueteria }}" disabled>
                  </div>
                  <div class="col-6">
                    <label for="guia">No. Guía:</label>
                    <input type="text" class="form-control" id="guia" name="guia" value="{{ $shipment->guia }}" disabled>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <div class="form-row">
                  <div class="col-6">
                    <label for="fec_env">Fecha de envío:</label>
                    <input type="date" id="fec_env" name="fec_env" class="form-control" value="{{ $shipment->fec_env }}" disabled>
                  </div>
                  <div class="col-6">
                    <label for="fec_ent">Fecha de entrega:</label>
                    <input type="date" id="fec_ent" name="fec_ent" class="form-control" value="{{ $shipment->fec_ent }}" disabled>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
        @endif
        <div class="row">
          <div class="col-7">
            <div class="cart-table">
              <div class="cart-table-warp">
                <table>
                  <thead>
                    <tr>
                      <th class="product-th">Producto</th>
                      <th class="quy-th">Cantidad</th>
                      <th class="size-th pr-1">Talla</th>
                      <th class="total-th">Subtotal</th>
                      <th class="total-th">Descuento</th>
                    </tr>
                  </thead>
                  <tbody>
                    @php
                    $count = 1;
                    $i = 0;
                    @endphp
                    @foreach($details as $detail)
                    @php
                    // dd($cart);
                    // dd($element);
                    $image = DB::select('select url from imagesproducts where product_id = ? limit 1', [$detail->product_id]);
                    $product = DB::select('select * from products where id = ?', [$detail->product_id]);
                    @endphp
                    <tr>
                      <td class="product-col">
                        <img src="{{ url("storage/".$image[0]->url) }}" alt="{{ $product[0]->nameProduct }}" />
                        <div class="pc-title">
                          <h4>{{ $product[0]->nameProduct }} | Tee-shirt</h4>
                          <p id="prec-{{ $count }}">$<span class="price">{{ $detail->costProduct }}</span></p>
                        </div>
                      </td>
                      <td class="quy-col">
                        <div class="quantity">
                          <div class="quantsContainer size-col">
                            <h4 class="p-0 quants">{{ $detail->cantidad }}</h4>
                          </div>
                        </div>
                      </td>
                      <td class="size-col text-center">
                        @php
                        $size = '';
                        if($detail->size == 1){
                        $size = 'Chica';
                        }elseif($detail->size == 2){
                        $size = 'Mediana';
                        }elseif($detail->size == 3){
                        $size = 'Grande';
                        }
                        @endphp
                        <h4 class="text-center pr-0 mr-2">{{ $size }}</h4>
                      </td>
                      <td class="total-col">
                        <h4>$<span class="subtotal"></span></h4>
                      </td>
                      <td class="total-col">
                        <h4 class="text-center">%{{ $detail->descuento * 100 }}</h4>
                      </td>
                    </tr>
                    @php
                    $count++;
                    $i++;
                    @endphp
                    @endforeach
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="col-5">
            <div class="row ml-4">
              <div class="row mt-2">
                <label for="estado">Estado de la venta: </label>
                <input type="text" id="estado" class="form-control" value="{{ $status->nameStatus }}" disabled>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

</section>
<!-- section end -->

<script src="{{ asset('js/cart.js') }}"></script>
@endsection
