<?php

namespace App\Http\Resources;

use App\Http\Resources\ImageProduct;
use Illuminate\Http\Resources\Json\JsonResource;

class ListProduct extends JsonResource
{
    public function toArray($request)
    {
        $imagesProduct = $this->imagesProduct()->get();
        $images = [];

        foreach ($imagesProduct as $image) {
            array_push($images, new ImageProduct($image));
        }

        $image = $images[0]->url;

        return [
            'id' => $this->id,
            'nameProduct' => $this->nameProduct,
            'description_prod' => $this->description_prod,
            'costo_prod' => $this->costo_prod,
            'precio_prod' => $this->precio_prod,
            'descuento' => ($this->descuento == null) ? 0 : $this->descuento,
            'material_prod' => $this->material_prod,
            'image' => url($image)
        ];
    }
}
