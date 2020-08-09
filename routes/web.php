<?php

// Autenticación
Auth::routes();

// Home
Route::get('/', 'IndexController@index')->name('index');
Route::get('/home', 'HomeController@index')->name('home');

// Product
Route::get('product', 'client\ProductController@index')->name('product.index');
Route::get('product/category/{id}', 'client\ProductController@category')->name('product.category');
Route::get('product/{product}', 'client\ProductController@show')->name('product.show');
Route::get('product/sex/boys', 'client\ProductController@boys')->name('product.boys');
Route::get('product/sex/girls', 'client\ProductController@girls')->name('product.girls');

// Cart
Route::get('cart', 'backend\CartController@index')->name('cart');
Route::post('cart/{id}', 'backend\CartController@store')->name('cart.store');
Route::get('delete/cart/{id}', 'backend\CartController@destroy')->name('cart.destroy');
Route::get('reset/cart', 'backend\CartController@reset')->name('cart.reset');

// pay
Route::get('pay/prebilling', 'backend\PayController@prebilling')->name('pay.prebilling');
Route::post('pay/confirm/{user}', 'backend\PayController@confirm')->name('pay.confirm');
Route::get('success', 'backend\PayController@success')->name('pay.success');
Route::get('canceled', 'backend\PayController@canceled')->name('pay.canceled');

// User settings
Route::get('profile', 'client\ProfileController@show')->name('profile.show');
Route::get('profile/edit', 'client\ProfileController@edit')->name('profile.edit');
Route::get('profile/update', 'client\ProfileController@edit')->name('profile.update');

// Addresses CRUD
Route::resource('addresses', 'client\AddressesController')->except('index', 'show');
