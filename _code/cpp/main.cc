#include <iostream>

// 定义一个通用的表达式模板接口
template<typename Derived>
class Expression {
public:
    // 将表达式转换为其派生类
    const Derived& derived() const {
        return static_cast<const Derived&>(*this);
    }
};

// 定义一个具体的矩阵类
class Matrix : public Expression<Matrix> {
private:
    double data[2][2]; // 简单的2x2矩阵
public:
    Matrix(double a, double b, double c, double d) {
        data[0][0] = a; data[0][1] = b;
        data[1][0] = c; data[1][1] = d;
    }

    double operator()(int i, int j) const {
        std::cout << "xxxx" << std::endl;
        return data[i][j];
    }

    // 打印矩阵
    void print() const {
        std::cout << data[0][0] << " " << data[0][1] << "\n"
                  << data[1][0] << " " << data[1][1] << "\n";
    }
};

// 矩阵加法表达式类
template<typename Lhs, typename Rhs>
class MatrixAdd : public Expression<MatrixAdd<Lhs, Rhs>> {
private:
    const Lhs& lhs;
    const Rhs& rhs;
public:
    MatrixAdd(const Lhs& lhs, const Rhs& rhs) : lhs(lhs), rhs(rhs) {}

    inline double operator()(int i, int j) const {
        std::cout << i << " " << j << std::endl;
        return lhs(i, j) + rhs(i, j);
    }

};

// 重载+运算符
template<typename Lhs, typename Rhs>
MatrixAdd<Lhs, Rhs> operator+(const Expression<Lhs>& lhs, const Expression<Rhs>& rhs) {
    return MatrixAdd<Lhs, Rhs>(lhs.derived(), rhs.derived());
}

template<typename EType>
Matrix evaluate(const Expression<EType>& expr) {
    const EType& e = expr.derived();
    return Matrix(e(0, 0), e(0, 1), e(1, 0), e(1, 1));
}

int main() {
    Matrix A(1, 2, 3, 4);
    Matrix B(5, 6, 7, 8);
    Matrix C(3, 4, 5, 6);

    // 使用惰性求值进行加法，然后将结果转换为一个新的Matrix
    auto D = evaluate(A + B + C);

    // 打印结果
    std::cout << "Matrix (A + B + C) is:\n";
    D.print();

    return 0;
}

//g++ main.cc -O3