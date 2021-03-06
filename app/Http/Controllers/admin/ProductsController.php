<?php

namespace App\Http\Controllers\admin;

use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use App\Http\Requests\ProductRequest;
use App\Product;
use App\Http\Controllers\Controller;
use App\ImagesProduct;
use Illuminate\Database\Eloquent\Model;

// use db;

class ProductsController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
        $this->middleware('admin');
        $this->middleware('isntDeleted');
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('admin.product.index', [
          'products' =>Product::orderBy('id', 'asc')->paginate()
        ]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.product.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ProductRequest $request)
    {
        if ($request->costo_prod > $request->precio_prod) {
            return back()->with('status', 'No puedes vender a perdida.');
        } else {
            //salvar
            $product = Product::create($request->all());

            //retornar
            return back()->with('status', 'Creado con éxito');
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product)
    {
        // dd($product);
        $images = ImagesProduct::where('imagesproducts.product_id', '=', $product->id)->get();
        // dd($images);
        return view('admin.product.show', compact('product', 'images'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function edit(Product $product)
    {
        return view('admin.product.edit', compact('product'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function update(ProductRequest $request, Product $product)
    {
        if ($request->costo_prod > $request->precio_prod) {
            return back()->with('status', 'No puedes vender a perdida.');
        } else {
            $product->update($request->all());
            return back()->with('status', 'Actualizado con éxito');
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */

    public function delete(Request $request, Product $product)
    {
        // dd($product);
        if ($product->statusProduct_id != 5) {
            Product::where('id', $product->id)->update(['statusProduct_id'=>5]);
        // dd($request);
            // $product->statusProduct_id = 5;
            // $product->save();
        } else {
            Product::where('id', $product->id)->update(['statusProduct_id'=>2]);
        }
        return back()->with('status', 'Actualizado con éxito');
    }

    public function images(Product $product)
    {
        $images = ImagesProduct::where('imagesproducts.product_id', '=', $product->id)->get();
        // dd($images);
        return view('admin.product.images', compact('product', 'images'));
    }
}
