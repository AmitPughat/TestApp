FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 100
ENV ASPNETCORE_URLS http://*:100
FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY *.sln ./
COPY TestApp/TestApp.csproj TestApp/
RUN dotnet restore
COPY . .
WORKDIR /src/TestApp
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TestApp.dll", "--server.urls", "http://*:100"]
