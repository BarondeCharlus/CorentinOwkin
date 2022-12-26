import orjson
import uuid
from datetime import date
from typing import List
from ninja import NinjaAPI, ModelSchema
from django.shortcuts import get_object_or_404
from ninja import Schema

from ninja.renderers import BaseRenderer

from .models import Job


class ORJSONRenderer(BaseRenderer):
    media_type = "application/json"

    def render(self, request, data, *, response_status):
        return orjson.dumps(data)


api = NinjaAPI(renderer=ORJSONRenderer(), version="0.0.1")

# Schemas
class StatusIn(Schema):
    name: str
    description: str
    dockerfile: str


class StatusSchema(ModelSchema):
    class Config:
        model = Job
        model_fields = [
            "id",
            "name",
            "description",
            "dockerfile",
            "status",
            "performance",
        ]


# Status
@api.post("/job")
def create_status(request, payload: StatusIn):
    status = Job.objects.create(**payload.dict())
    return {"id": status.id}


@api.get("/job/{status_id}", response=StatusSchema)
def get_status(request, status_id: uuid.UUID):
    status = get_object_or_404(Job, id=status_id)
    return status


@api.get("/jobs", response=List[StatusSchema])
def list_status(request):
    qs = Job.objects.all()
    return qs


@api.put("/job/{status_id}")
def update_status(request, status_id: uuid.UUID, payload: StatusIn):
    status = get_object_or_404(Job, id=status_id)
    for attr, value in payload.dict().items():
        setattr(status, attr, value)
    status.save()
    return {"success": True}


@api.delete("/job/{status_id}")
def delete_status(request, status_id: uuid.UUID):
    status = get_object_or_404(Job, id=status_id)
    status.delete()
    return {"success": True}
