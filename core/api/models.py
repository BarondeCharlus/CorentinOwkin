import uuid
from django.db import models
from django.utils.translation import gettext_lazy as _

# Create your models here.


class Job(models.Model):

    results = (
        ("success", "success"),
        ("processing", "processing"),
        ("fail", "fail"),
        ("error", "error"),
        ("init", "init"),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50, null=False, blank=False)
    description = models.CharField(max_length=100, null=True, blank=True)
    dockerfile = models.TextField(null=False, blank=False)
    status = models.CharField(max_length=10, choices=results, default="init")
    performance = models.FloatField(null=True)

    def __str__(self):
        return "%s" % (self.name)
