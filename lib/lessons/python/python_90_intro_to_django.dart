import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson90 = Lesson(
  language: 'Python',
  title: 'Intro to Django',
  content: """
🎯 WHAT IS DJANGO?
Django is Python's "batteries-included" full-stack web framework.
Where Flask says "here are the tools, you build the kitchen,"
Django says "the kitchen is already built — here are the appliances."

You get ALL of this out of the box:
  ✅ ORM (Object-Relational Mapper) → Python classes = database tables
  ✅ Automatic admin interface → working CRUD UI in minutes
  ✅ User authentication → login, logout, sessions, permissions
  ✅ URL routing → clean URL patterns
  ✅ Template engine → HTML generation
  ✅ Form handling + validation
  ✅ CSRF protection
  ✅ Database migrations → version-control your schema
  ✅ Security defaults → clickjacking, XSS, SQL injection protection
  ✅ Internationalization → multi-language support
  ✅ Caching framework
  ✅ Email sending

Django's philosophy: "Don't Repeat Yourself" (DRY).

─────────────────────────────────────
💡 DJANGO IN ONE SENTENCE
─────────────────────────────────────
Django gives you a complete, opinionated web framework
with conventions that let teams build production apps fast.

─────────────────────────────────────
🎯 WHEN TO USE DJANGO
─────────────────────────────────────
✅ Content-heavy websites (news, blogs, e-commerce)
✅ Apps that need a powerful admin interface
✅ Teams that benefit from strong conventions
✅ Apps needing authentication out of the box
✅ Rapid development of data-driven apps
✅ When you want "the Django way" to handle problems
✅ Large, long-lived projects with many developers

❌ Don't use Django when:
  • You need a pure async API (use FastAPI)
  • You want to choose every component yourself (use Flask)
  • Your app is a simple microservice (overkill)
  • You need real-time/WebSocket at the core (async limited)

─────────────────────────────────────
🚀 GETTING STARTED
─────────────────────────────────────
Install:
  pip install django

Create a project:
  django-admin startproject mysite
  cd mysite
  python manage.py startapp blog

Run:
  python manage.py runserver
  Open: http://127.0.0.1:8000

─────────────────────────────────────
📐 CORE CONCEPTS (MTV Pattern)
─────────────────────────────────────
Django uses MTV: Model → Template → View
(similar to MVC but called differently)

Model:    Python class → database table (ORM)
Template: HTML file with template language
View:     Python function/class → handles request, returns response
URL:      urls.py → maps URL patterns to Views

─────────────────────────────────────
🗺️  THE WORKFLOW
─────────────────────────────────────
1. Define Model (models.py) → database schema
2. makemigrations → generate migration files
3. migrate → apply to database
4. Register in admin.py → instant admin UI!
5. Write View (views.py) → handle request logic
6. Create Template → HTML for the view
7. Wire URL (urls.py) → map URL to view

─────────────────────────────────────
🏗️  PROJECT STRUCTURE
─────────────────────────────────────
mysite/                  ← project root
├── manage.py            ← command-line tool
├── mysite/              ← project settings package
│   ├── settings.py      ← all configuration
│   ├── urls.py          ← root URL configuration
│   └── wsgi.py          ← production server entry
├── blog/                ← an app (reusable module)
│   ├── models.py        ← database models
│   ├── views.py         ← request handlers
│   ├── urls.py          ← app URL patterns
│   ├── admin.py         ← admin site registration
│   ├── forms.py         ← form definitions
│   ├── templates/       ← HTML templates
│   │   └── blog/
│   │       ├── list.html
│   │       └── detail.html
│   └── tests.py         ← tests
└── static/              ← CSS, JS, images

─────────────────────────────────────
⚡ DJANGO REST FRAMEWORK (DRF)
─────────────────────────────────────
For building REST APIs with Django:
  pip install djangorestframework

DRF adds:
  • Serializers (like Pydantic for Django)
  • ViewSets + Routers (auto-generate CRUD endpoints)
  • Authentication classes (Token, JWT, Session)
  • Permissions
  • Browsable API (HTML interface for your API)
  • Pagination, filtering, search

─────────────────────────────────────
📖 DOCUMENTATION & LEARNING
─────────────────────────────────────
Official docs:   https://docs.djangoproject.com
Official tutorial: https://docs.djangoproject.com/en/stable/intro/tutorial01/
DRF docs:        https://www.django-rest-framework.org

📚 Recommended Resources:
  • Django Girls Tutorial: tutorial.djangogirls.com (best for beginners!)
  • "Django for Beginners" by William S. Vincent (book + djangoforbeginners.com)
  • "Django for Professionals" by William S. Vincent (production Django)
  • Real Python Django tutorials: realpython.com/get-started-with-django-1
  • Classy Class-Based Views: ccbv.co.uk (reference for Django's CBVs)

💻 CODE:
DJANGO_MODELS_EXAMPLE = '''
# blog/models.py
from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(unique=True)

    class Meta:
        verbose_name_plural = "categories"
        ordering = ["name"]

    def __str__(self):
        return self.name

class Post(models.Model):
    STATUS_DRAFT     = "draft"
    STATUS_PUBLISHED = "published"
    STATUS_CHOICES = [
        (STATUS_DRAFT, "Draft"),
        (STATUS_PUBLISHED, "Published"),
    ]

    title      = models.CharField(max_length=250)
    slug       = models.SlugField(max_length=250, unique_for_date="publish")
    author     = models.ForeignKey(User, on_delete=models.CASCADE, related_name="posts")
    category   = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, related_name="posts")
    body       = models.TextField()
    publish    = models.DateTimeField(auto_now_add=True)
    created    = models.DateTimeField(auto_now_add=True)
    updated    = models.DateTimeField(auto_now=True)
    status     = models.CharField(max_length=10, choices=STATUS_CHOICES, default=STATUS_DRAFT)
    tags       = models.ManyToManyField("Tag", blank=True)
    views      = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ["-publish"]
        indexes = [models.Index(fields=["-publish"])]

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse("blog:post_detail", kwargs={"pk": self.pk})

# Terminal commands:
# python manage.py makemigrations blog
# python manage.py migrate
'''

DJANGO_ADMIN_EXAMPLE = '''
# blog/admin.py
from django.contrib import admin
from .models import Post, Category, Tag

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display   = ["title", "author", "status", "publish", "views"]
    list_filter    = ["status", "category", "author"]
    search_fields  = ["title", "body"]
    prepopulated_fields = {"slug": ("title",)}
    raw_id_fields  = ["author"]
    date_hierarchy = "publish"
    ordering       = ["status", "-publish"]
    readonly_fields = ["created", "updated", "views"]

    def save_model(self, request, obj, form, change):
        if not obj.author_id:
            obj.author = request.user
        super().save_model(request, obj, form, change)

admin.site.register(Category)
# Now visit /admin — full CRUD for Post and Category!
'''

DJANGO_VIEWS_EXAMPLE = '''
# blog/views.py
from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.views.generic import ListView, DetailView, CreateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Q
from .models import Post, Category

# Function-Based View
def post_list(request):
    posts = Post.objects.filter(status="published").select_related("author", "category")
    category_slug = request.GET.get("category")
    if category_slug:
        posts = posts.filter(category__slug=category_slug)
    return render(request, "blog/list.html", {"posts": posts})

# Class-Based View (Django style)
class PostListView(ListView):
    queryset = Post.objects.filter(status="published").select_related("author")
    template_name = "blog/list.html"
    context_object_name = "posts"
    paginate_by = 20

class PostDetailView(DetailView):
    model = Post
    template_name = "blog/detail.html"

    def get_object(self):
        obj = super().get_object()
        Post.objects.filter(pk=obj.pk).update(views=models.F("views") + 1)
        return obj

# Login-required view
class PostCreateView(LoginRequiredMixin, CreateView):
    model = Post
    fields = ["title", "body", "category", "status"]
    login_url = "/login/"

    def form_valid(self, form):
        form.instance.author = self.request.user
        return super().form_valid(form)

# ORM queries
def search_posts(request):
    q = request.GET.get("q", "")
    posts = Post.objects.filter(
        Q(title__icontains=q) | Q(body__icontains=q),
        status="published"
    ).order_by("-publish")[:20]
    return render(request, "blog/search.html", {"posts": posts, "query": q})
'''

DJANGO_URLS_EXAMPLE = '''
# blog/urls.py
from django.urls import path
from . import views

app_name = "blog"   # namespace

urlpatterns = [
    path("",                    views.PostListView.as_view(), name="post_list"),
    path("<int:pk>/",           views.PostDetailView.as_view(), name="post_detail"),
    path("new/",                views.PostCreateView.as_view(), name="post_create"),
    path("search/",             views.search_posts, name="search"),
    path("category/<slug:slug>/", views.post_list, name="by_category"),
]

# mysite/urls.py (root)
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/",  admin.site.urls),
    path("blog/",   include("blog.urls")),
    path("api/",    include("api.urls")),
]
'''

DRF_EXAMPLE = '''
# Using Django REST Framework
# pip install djangorestframework

# api/serializers.py
from rest_framework import serializers
from blog.models import Post

class PostSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source="author.get_full_name", read_only=True)

    class Meta:
        model = Post
        fields = ["id", "title", "body", "author_name", "status", "publish"]
        read_only_fields = ["id", "publish"]

# api/views.py
from rest_framework import viewsets, permissions, filters
from rest_framework.decorators import action
from rest_framework.response import Response

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.filter(status="published")
    serializer_class = PostSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ["title", "body"]
    ordering_fields = ["publish", "views"]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

    @action(detail=False, methods=["get"])
    def popular(self, request):
        top = self.queryset.order_by("-views")[:5]
        return Response(PostSerializer(top, many=True).data)

# api/urls.py
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register("posts", PostViewSet)
urlpatterns = router.urls
# This creates: GET/POST /posts/, GET/PUT/PATCH/DELETE /posts/{id}/
'''

print("Django overview loaded!")
print()
print("Quick start:")
print("  pip install django")
print("  django-admin startproject mysite")
print("  cd mysite")
print("  python manage.py startapp blog")
print("  python manage.py migrate")
print("  python manage.py createsuperuser")
print("  python manage.py runserver")
print()
print("Then visit:")
print("  http://127.0.0.1:8000        ← your site")
print("  http://127.0.0.1:8000/admin  ← admin interface")
print()
print("Best learning path:")
print("  1. Django Girls Tutorial (tutorial.djangogirls.com)")
print("  2. Official Django Tutorial (docs.djangoproject.com)")
print("  3. 'Django for Beginners' by William S. Vincent")

📝 KEY POINTS:
✅ Django gives you ORM, admin, auth, forms, migrations, and more out of the box
✅ Admin interface is automatic — register a model and get full CRUD instantly
✅ ORM: Post.objects.filter(status="published") — Python instead of SQL
✅ Migrations version-control your database schema alongside your code
✅ Class-Based Views (CBVs) provide powerful, reusable view patterns
✅ Django REST Framework adds a complete API layer with serializers, viewsets, and routers
✅ The official Django tutorial + Django Girls Tutorial are the best starting points
✅ "Don't Repeat Yourself" (DRY) — Django conventions eliminate boilerplate
❌ Don't put business logic in views — keep models fat, views thin
❌ Don't skip migrations — always run makemigrations after changing models
❌ Don't disable Django's CSRF protection without understanding the implications
❌ Don't use DEBUG=True in production
""",
  quiz: [
    Quiz(question: 'What is Django\'s automatic admin interface?', options: [
      QuizOption(text: 'A third-party package that must be installed separately', correct: false),
      QuizOption(text: 'A built-in feature that creates a full CRUD management UI just by registering your models', correct: true),
      QuizOption(text: 'A command that generates Flask routes', correct: false),
      QuizOption(text: 'The Django shell for running management commands', correct: false),
    ]),
    Quiz(question: 'What does "python manage.py makemigrations" do?', options: [
      QuizOption(text: 'Applies pending migrations to the database', correct: false),
      QuizOption(text: 'Generates Python migration files from model changes — the instructions for updating the database schema', correct: true),
      QuizOption(text: 'Creates a new Django app', correct: false),
      QuizOption(text: 'Rolls back the last migration', correct: false),
    ]),
    Quiz(question: 'What does Django REST Framework add to Django?', options: [
      QuizOption(text: 'WebSocket support', correct: false),
      QuizOption(text: 'A complete toolkit for building REST APIs: serializers, viewsets, authentication, and browsable API', correct: true),
      QuizOption(text: 'A new ORM that replaces the Django ORM', correct: false),
      QuizOption(text: 'Real-time database sync', correct: false),
    ]),
  ],
);
