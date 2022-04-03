FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ./hpa/hpaApi .

RUN dotnet restore
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish "hpaApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "hpaApi.dll"]