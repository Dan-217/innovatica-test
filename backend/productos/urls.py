from django.urls import path, include
from rest_framework import routers, serializers, viewsets

urlpatterns = [
    path("api/productos", include('rest_framework.urls'))
]
